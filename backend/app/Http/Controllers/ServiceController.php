<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreServiceRequest;
use App\Models\Service;
use App\Models\Service_Add_Request;
use App\Models\Shop;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ServiceController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $services = Service::get();

        return view("services.index", compact("services"));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view("services.add_service");
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(StoreServiceRequest $request)
    {
        $hours = $request->input('hours');
        $minutes = $request->input('min');
        $time_req = sprintf('%02d:%02d:00', $hours, $minutes);


        $service = new Service();
        $service->name = $request->input('name');
        $service->desc = $request->input('desc');
        $service->price = $request->input('price');
        $service->time_req = $time_req;


        $service->save();

        return redirect(route("services"));
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $service = Service::findorfail($id);

        return view("services.details", compact("service"));
    }


    public function show_addions()
    {
        $addions = DB::table("service__requests")->get();
        $shops = [];
        $services = [];
        foreach ($addions as $addion) {
            array_push($shops, Shop::find($addion->shop_id));
            array_push($services, Service::find($addion->service_id));
        }

        return view("services.add_requests", compact(["shops", "services", "addions"]));
    }
    public function show_addion($shop_id ,$service_id)
    {
        $addion = DB::table("service__requests")->get()->where("shop_id", $shop_id)->where('service_id',$service_id)->first();

        $shop = Shop::find($addion->shop_id);
        $service = Service::find($addion->service_id);


        return view("services.addion_details", compact(["shop", "service", "addion"]));
    }


    public function approve_addion($shop_id ,$service_id)
    {
        $addion = DB::table("service__requests")->get()->where("shop_id", $shop_id)->where('service_id',$service_id)->first();
        DB::table("shop_service")->insert([
            "shop_id" => $addion->shop_id,
            "service_id" => $addion->service_id
        ]);
        DB::table("service__requests")->where("shop_id", $shop_id)->where('service_id',$service_id)->delete();
        return redirect(route("services.addions"));
    }

    public function deny_addion($shop_id ,$service_id)
    {
        DB::table("service__requests")->where("shop_id", $shop_id)->where('service_id',$service_id)->delete();

        return redirect(route("services.addions"));
    }


    public function show_requests()
    {
        $services = Service_Add_Request::get();

        return view("services.requests", compact("services"));
    }
    public function show_request($id)
    {
        $service = Service_Add_Request::findorfail($id);
        $shop = Shop::findorfail($service->shop_id);
        return view("services.request_details", compact(["service", "shop"]));
    }



    public function approve_request(Request $request)
    {
        $service = Service_Add_Request::findorfail($request->service_id);
        $shop = Shop::findorfail($request->shop_id);
        $new_service = Service::create([
            "name" => $service->name,
            "desc" => $service->desc,
            "price" => $service->price,
            "time_req" => $service->time_req
        ]);


        DB::table('shop_service')->insert([
            "shop_id" => $shop->id,
            "service_id" => $new_service->id
        ]);

        Service_Add_Request::destroy($request->service_id);
        return redirect(route("services.requests"));
    }


    public function deny_request($id)
    {
        Service_Add_Request::destroy($id);
        return redirect(route("services.requests"));
    }
    public function edit($id)
    {
        $service = Service::findorfail($id);

        list($hours, $minutes) = explode(':', $service->time_req);

        return view('services.edit_service', compact('service', 'hours', 'minutes'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(StoreServiceRequest $request)
    {

        $hours = $request->input('hours');
        $minutes = $request->input('min');
        $time_req = sprintf('%02d:%02d:00', $hours, $minutes);

        $service = Service::findorfail($request->id);
        $service->name = $request->input('name');
        $service->desc = $request->input('desc');
        $service->price = $request->input('price');
        $service->time_req = $time_req;


        $service->save();

        return redirect(route("services.details",$service->id));
    }

    public function edit_request($id)
    {
        $service = Service_Add_Request::findorfail($id);

        list($hours, $minutes) = explode(':', $service->time_req);

        return view('services.edit_request', compact('service', 'hours', 'minutes'));
    }
    public function update_request(StoreServiceRequest $request)
    {

        $hours = $request->input('hours');
        $minutes = $request->input('min');
        $time_req = sprintf('%02d:%02d:00', $hours, $minutes);

        $service = new Service;
        $service->name = $request->input('name');
        $service->desc = $request->input('desc');
        $service->price = $request->input('price');
        $service->time_req = $time_req;
        $service->save();

        DB::table('shop_service')->insert([
            "shop_id" => $request->shop_id,
            "service_id" => $service->id
        ]);

        Service_Add_Request::destroy($request->id);

        return redirect(route('services.requests'));
    }



    public function destroy(Service $service)
    {
        //
    }
}
