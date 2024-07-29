<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Http\Resources\NoTimeResource;
use App\Models\Appointment;
use App\Models\Service;
use App\Models\Service_Add_Request;
use App\Models\Service_Request;
use App\Models\Shop;
use Carbon\Carbon;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class ShopController extends Controller
{
    use apiResponse;
    public function get_appointments(){
        $shop = Auth::user();
        if (!$shop->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'User Not Verified');
        }

        $appointments = $shop
            ->appointments()
            ->where('status', 0)
            ->with(['user', 'car', 'car.model', 'service']) // Eager load related data
            ->get()
            ->map(function ($appointment) {
                return [
                    'id' => $appointment->id,
                    'user_name' => $appointment->user->name,
                    'date' => $appointment->date,
                    'start_time' => $appointment->time,
                    'end_time' => Carbon::parse($appointment->time)->addSeconds(strtotime($appointment->service->time_req) - strtotime('TODAY'))->format('H:i'),
                    'service_name' => $appointment->service->name,
                    'car_model' => $appointment->car->model->name,
                    'car_year' => $appointment->car->model->year,
                ];
            });

        return $this->apiResponse(['appointments' => $appointments], 200, 'ok');
    }
    public function deny_appointment($id){
        $shop = Auth::user();
        if (!$shop->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'User Not Verified');
        }

        $appointment = Appointment::findorfail($id);
        if($appointment->shop_id != $shop->id){
            return $this->apiResponse(null, 400, "This Shop does not own this appointment");
        }
        if($appointment->status != 0){
            return $this->apiResponse(null, 400, "This appointment is already accepted");
        }

        Appointment::destroy($appointment->id);

        return $this->apiResponse(null, 200, 'appointment deleted');
    }
    public function confirm_appointment($id) {
        $shop = Auth::user();
        if (!$shop->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'User Not Verified');
        }

        $appointmentToConfirm = Appointment::findOrFail($id);

        if ($appointmentToConfirm->shop_id != $shop->id) {
            return $this->apiResponse(null, 400, "This Shop does not own this appointment");
        }

        if ($appointmentToConfirm->status != 0) {
            return $this->apiResponse(null, 400, "This appointment is already accepted");
        }

        $serviceTime = Service::findOrFail($appointmentToConfirm->service_id)->time_req;
        $serviceTimeParts = explode(':', $serviceTime);
        $serviceTimeInMinutes = $serviceTimeParts[0] * 60 + $serviceTimeParts[1];

        $appointmentStart = Carbon::createFromFormat('Y-m-d H:i:s', $appointmentToConfirm->date . ' ' . $appointmentToConfirm->time);
        $appointmentEnd = $appointmentStart->copy()->addMinutes($serviceTimeInMinutes);

        $conflictingAppointments = Appointment::where('date', $appointmentToConfirm->date)
            ->where('shop_id', $appointmentToConfirm->shop_id)
            ->where('status', 1)
            ->where('id', '!=', $id)
            ->get();

        $overlappingCount = 0;

        foreach ($conflictingAppointments as $conflictAppointment) {
            $conflictStart = Carbon::createFromFormat('Y-m-d H:i:s', $conflictAppointment->date . ' ' . $conflictAppointment->time);
            $conflictEnd = $conflictStart->copy()->addMinutes(
                explode(':', $conflictAppointment->service->time_req)[0] * 60 + explode(':', $conflictAppointment->service->time_req)[1]
            );

            if ($appointmentEnd->greaterThanOrEqualTo($conflictStart) && $appointmentStart->lessThan($conflictEnd)) {
                $overlappingCount++;
            }
        }

        if ($overlappingCount < $shop->capacity) {
            $appointmentToConfirm->status = 1;
            $appointmentToConfirm->save();
            return $this->apiResponse(null, 200, "Appointment confirmed");
        } else {
            Appointment::destroy($appointmentToConfirm->id);
            return $this->apiResponse(null, 400, "Unable to confirm appointment due to capacity constraints");
        }
    }
    public function get_services() {
        $shop = Auth::user();
        if (!$shop->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'User Not Verified');
        }

        $linkedServiceIds = DB::table('shop_service')
            ->where('shop_id', $shop->id)
            ->pluck('service_id');

        $linkedServiceIds2 = Service_Request::all()->where('shop_id',$shop->id)->pluck('service_id');;

        $unlinkedServices = Service::whereNotIn('id', $linkedServiceIds)->whereNotIn('id', $linkedServiceIds2)->get();
        $services = NoTimeResource::collection($unlinkedServices);

        return $this->apiResponse(['services' => $services], 200, 'ok');
    }

    public function add_service(Request $request){

        $shop = Auth::user();
        if (!$shop->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'User Not Verified');
        }

        $linkedserive = DB::table('shop_service')
            ->where('shop_id', $shop->id)->where('service_id',$request->service_id)->get();
        \Log::info($linkedserive);
        if(count($linkedserive) > 0){
            return $this->apiResponse(null , 400 ,'This shop already has this service');
        }

        $requested_services = Service_Request::all()->where('shop_id', $shop->id)->where('service_id',$request->service_id);
        if(count($requested_services) > 0){
            return $this->apiResponse(null , 400 ,'This shop already requested this service');
        }
        $service_request = new Service_Request;

        $service_request->shop_id = $shop->id;
        $service_request->service_id = $request->service_id;
        $service_request->save();

        return $this->apiResponse(null , 200 ,'ok');

    }
    public function request_service(Request $request){

        $shop = Auth::user();
        if (!$shop->hasVerifiedEmail()) {
            return $this->apiResponse(null,400,'User Not Verified');
        }
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|unique:service__add__requests|unique:services',
            'desc' => 'required|string',
            'price' => 'required|integer|min:1',
            'time_req' => 'required|date_format:H:i', // Ensure the time is in the format 'HH:MM'
        ]);

        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422, "Validation error");
        }
        $service = new Service_Add_Request;
        $service->name = $request->name;
        $service->desc = $request->desc;
        $service->price = $request->price;
        $service->time_req = $request->time_req;
        $service->shop_id = $shop->id;

        $service->save();
        return $this->apiResponse(null, 200, 'Service Request created successfully');

    }

    public function get_history(){
        $shop = Auth::user();
        if (!$shop->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'User Not Verified');
        }

    $appointments = Shop::findOrFail($shop->id)
        ->appointments()
        ->whereIn('status', [1, 2])
        ->with(['user', 'car', 'car.model', 'service']) // Eager load related data
        ->get()
        ->map(function ($appointment) {
            return [
                'id' => $appointment->id,
                'user_name' => $appointment->user->name,
                'date' => $appointment->date,
                'start_time' => $appointment->time,
                'end_time' => Carbon::parse($appointment->time)->addSeconds(strtotime($appointment->service->time_req) - strtotime('TODAY'))->format('H:i'),
                'service_name' => $appointment->service->name,
                'car_model' => $appointment->car->model->name,
                'car_year' => $appointment->car->model->year,
            ];
        });

        return $this->apiResponse(['appointments' => $appointments], 200, 'ok');
    }
    public function update_shop(Request $request){

        $shop = Auth::user();
        if (!$shop->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'User Not Verified');
        }
        $validator = Validator::make($request->all(), [
            'owner_name' => 'string|between:2,100',
            'shop_name' => 'string|between:2,100',
            'password' => 'string|min:8',
            'phone_num' => 'min:10|unique:shops,phone_num,' . $shop->id,

        ]);
        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422, "Validation error");
        }
        if($request->owner_name)
            $shop->owner_name = $request->owner_name;
        if($request->shop_name)
            $shop->shop_name = $request->shop_name;
        if($request->password)
            $shop->password = bcrypt($request->password);
        if($request->phone_num)
            $shop->phone_num = $request->phone_num;


        $shop->save();

        return $this->apiResponse(new NoTimeResource($shop), 200, 'Shop info updated successfully');

    }
}
