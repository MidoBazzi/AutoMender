<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use App\Http\Resources\NoTimeResource;
use App\Models\Brand;
use App\Models\Car;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class CarController extends Controller
{
    use apiResponse;
    public function create_car(Request $request){

        $user = User::where('email',$request->email)->get()->first();
        if (!$user->hasVerifiedEmail()) {
            return $this->apiResponse(null,400,'User Not Verified');
        }
        $validator = Validator::make($request->all(), [
            'country_id' => 'required|integer',
            'car_model_id' => 'required|integer',
            'brand_id' => 'required|integer',
            'governorate' => 'required|string',
            'curr_mialage' => 'required|integer|between:0,999999',
            'next_mialage' => 'required|integer|between:0,999999',
            'plate_num' => 'required|integer|between:0,999999|unique:cars',
            'color' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422, "Validation error");
        }

        $car = new Car();
        $car->user_id = $user->id;
        $car->country_id = $request->country_id;
        $car->car_model_id = $request->car_model_id;
        $car->brand_id = $request->brand_id;
        $car->governorate = $request->governorate;
        $car->curr_mialage = $request->curr_mialage;
        $car->next_mialage = $request->next_mialage;
        $car->plate_num = $request->plate_num;
        $car->color = $request->color;

        $car->save();

        return $this->apiResponse(null, 200, 'Car Added successfully');

    }
    public function update_car(Request $request){

        $user = Auth::user();
        if (!$user->hasVerifiedEmail()) {
            return $this->apiResponse(null,400,'User Not Verified');
        }
        $validator = Validator::make($request->all(), [
            'car_id' => 'integer',
            'governorate' => 'string',
            'curr_mialage' => 'integer|between:0,999999',
            'next_mialage' => 'integer|between:0,999999',
            'plate_num' => 'integer|between:0,999999|unique:cars,plate_num,' . $request->car_id,
            'color' => 'string',
        ]);

        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422, "Validation error");
        }

        $car = Car::findorfail($request->car_id);
        if($car->user_id != $user->id){
            return $this->apiResponse(null, 400, "This user does not own this car");
        }
       if($request->governorate)
           $car->governorate = $request->governorate;

        if($request->curr_mialage)
            $car->curr_mialage = $request->curr_mialage;

        if($request->next_mialage)
            $car->next_mialage = $request->next_mialage;

        if($request->plate_num)
            $car->plate_num = $request->plate_num;

        if($request->color)
            $car->color = $request->color;

        $car->save();

        return $this->apiResponse(null, 200, 'Car Updated successfully');

    }
    public function get_brands(){

        $brands = NoTimeResource::collection(Brand::all());
        return $this->apiResponse(['brands'=>$brands], 200, 'ok');

    }
    public function get_country($id){

        $brand = Brand::with('country')->findorfail($id);
        $country = new NoTimeResource($brand->country);

        return $this->apiResponse(['country'=>$country], 200, 'ok');

    }
    public function get_models($id){

        $models = NoTimeResource::collection(Brand::findorfail($id)->carmodels()->get());
        return $this->apiResponse(['models'=>$models], 200, 'ok');

    }

    public function delete_car($id){
        $user = Auth::user();
        if (!$user->hasVerifiedEmail()) {
            return $this->apiResponse(null,400,'User Not Verified');
        }
        $car =Car::findorfail($id);

        if($car->user_id != $user->id){
            return $this->apiResponse(null, 400, "This user does not own this car");
        }
        $car->delete();
        return $this->apiResponse(null, 200, 'Car deleted successfully');

    }
}
