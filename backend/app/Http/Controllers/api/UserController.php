<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Http\Resources\NoTimeResource;
use App\Http\Resources\ShopResource;
use App\Models\Appointment;
use App\Models\Brand;
use App\Models\Car;
use App\Models\Country;
use App\Models\Service;
use App\Models\Shop;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    use apiResponse;
    public function home(){

        $user = Auth::user();
        if (!$user->hasVerifiedEmail()) {
            return $this->apiResponse(null,400,'User Not Verified');
        }

        $cars = $user->cars()->with(['country', 'model', 'brand'])->get()
            ->map(function ($car) {
                return [
                    "id" => $car->id,
                    "country_name" => $car->country->name, // Access as a property
                    "car_model_name" => $car->model->name, // Access as a property
                    "brand_name" => $car->brand->name, // Access as a property
                    "governorate" => $car->governorate,
                    "curr_mialage" => $car->curr_mialage,
                    "next_mialage" => $car->next_mialage,
                    "plate_num" => $car->plate_num,
                    "color" => $car->color,
                ];
            });
        $user = new NoTimeResource(User::findorfail($user->id));
        $data = ['user' => $user ,'cars'=> $cars];

        return $this->apiResponse($data , 200 ,'ok');
    }
    public function get_services(){

        if (!Auth::user()->hasVerifiedEmail()) {

            return $this->apiResponse(null,400,'User Not Verified');
        }
        $services = NoTimeResource::collection(Service::all());

        return $this->apiResponse(['services'=>$services] , 200 ,'ok');

    }
    public function get_shops($id){

        if (!Auth::user()->hasVerifiedEmail()) {

            return $this->apiResponse(null,400,'User Not Verified');
        }
        $service = Service::findorfail($id);
        $shops = $service->shops;
        $shopsResource = ShopResource::collection($shops);
        return $this->apiResponse(['shops'=>$shopsResource] , 200 ,'ok');

    }

    public function get_dates($id){
        if (!Auth::user()->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'User Not Verified');
        }

        $shop = Shop::findOrFail($id);
        $schedule = explode(':', $shop->schedule); // Assuming schedule is stored as 'sun:mon:fri'

        $daysOfWeek = [
            'Sunday' => Carbon::SUNDAY,
            'Monday' => Carbon::MONDAY,
            'Tuesday' => Carbon::TUESDAY,
            'Wednesday' => Carbon::WEDNESDAY,
            'Thursday' => Carbon::THURSDAY,
            'Friday' => Carbon::FRIDAY,
            'Saturday' => Carbon::SATURDAY,
        ];

        $matchingDates = [];
        $today = Carbon::today();

        for ($i = 1; $i <= 7; $i++) {
            $date = $today->copy()->addDays($i);
            $dayShort = strtolower($date->format('D')); // 'sun', 'mon', 'tue', etc.

            if (in_array($dayShort, $schedule)) {
                $dayName = ucfirst($dayShort); // Capitalize the first letter
                $matchingDates[] = [
                    'date' => $date->format('Y-m-d'),
                    'day' => $dayName
                ];
            }
        }
       $services= NoTimeResource::collection($shop->services()->get());
        return $this->apiResponse(['dates' => $matchingDates,'services'=>$services], 200, 'ok');
    }

    public function get_times(Request $request){
        if (!Auth::user()->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'User Not Verified');
        }

        $service_time = Service::findOrFail($request->service_id)->time_req;
        $serviceTimeParts = explode(':', $service_time);
        $serviceTimeInMinutes = $serviceTimeParts[0] * 60 + $serviceTimeParts[1];

        $shop = Shop::findOrFail($request->shop_id);

        $openingHour = intval($shop->open_time);
        $openingMinutes = ($shop->open_time - $openingHour) * 60;
        $openingTime = Carbon::createFromTime($openingHour, $openingMinutes);

        $closingHour = intval($shop->close_time);
        $closingMinutes = ($shop->close_time - $closingHour) * 60;
        $closingTime = Carbon::createFromTime($closingHour, $closingMinutes);

        $shopCapacity = $shop->capacity;

        $appointments = Appointment::where('date', $request->date)
            ->where('shop_id', $request->shop_id)->where('status', 1)
            ->get();

        $availableSlots = [];
        $currentTime = $openingTime->copy();


        while ($currentTime->lessThan($closingTime)) {
            $slotEnd = $currentTime->copy()->addMinutes($serviceTimeInMinutes);

            if ($slotEnd->greaterThan($closingTime)) {
                break;
            }

            // Count overlapping appointments
            $overlappingAppointments = 0;

            foreach ($appointments as $appointment) {
                $appointmentStart = Carbon::createFromTimeString($appointment->time);
                $appo_time = $appointment->service->time_req;
                $appoTimeParts = explode(':', $appo_time);
                $appoTimeInMinutes = $appoTimeParts[0] * 60 + $appoTimeParts[1];
                $appointmentEnd = $appointmentStart->copy()->addMinutes($appoTimeInMinutes);

                if ($slotEnd->greaterThan($appointmentStart) && $currentTime->lessThan($appointmentEnd)) {
                    $overlappingAppointments++;
                }
            }
            if ($overlappingAppointments < $shopCapacity) {
                $availableSlots[] = $currentTime->format('H:i');
            }

            $currentTime->addMinutes(30);
        }

        return $this->apiResponse(['slots' =>$availableSlots], 200, 'ok');

    }

    public function create_appointment(Request $request){

        $user = Auth::user();
        if (!$user->hasVerifiedEmail()) {
            return $this->apiResponse(null,400,'User Not Verified');
        }
        $validator = Validator::make($request->all(), [
            'car_id' => 'required|integer',
            'shop_id' => 'required|integer',
            'service_id' => 'required|integer',
            'date' => 'required|date',
            'time' => 'required|date_format:H:i', // Ensure the time is in the format 'HH:MM'
        ]);

        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422, "Validation error");
        }
        $appointment = new Appointment();
        $appointment->user_id = $user->id;
        $appointment->car_id = $request->car_id;
        $appointment->shop_id = $request->shop_id;
        $appointment->service_id = $request->service_id;
        $appointment->date = $request->date;
        $appointment->time = $request->time;

        $appointment->save();

        return $this->apiResponse(null, 200, 'Appointment created successfully');

    }

    public function update_user(Request $request){

        $user = Auth::user();
        if (!$user->hasVerifiedEmail()) {
            return $this->apiResponse(null,400,'User Not Verified');
        }
        $validator = Validator::make($request->all(), [
            'name' => 'string|between:2,25',
            'password' => 'string|min:8',
            'phone_num' => 'min:10|unique:users,phone_num,' . $user->id,
        ]);
        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422, "Validation error");
        }
        if($request->name)
            $user->name =$request->name;
        if($request->password)
            $user->password =bcrypt($request->password);
        if($request->phone_num)
            $user->phone_num =$request->phone_num;
        $user->save();

        return $this->apiResponse(new NoTimeResource($user), 200, 'User info updated successfully');

    }
}
