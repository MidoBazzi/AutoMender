<?php

namespace App\Http\Controllers;


use App\Models\Admin;
use App\Models\Appointment;
use App\Models\Service_Add_Request;
use App\Models\Shop;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class AdminController extends Controller
{
    public function index()
    {
        $shops = Shop::all()->where('approved',false)->where('email_verified_at','!=',null);
        $num_shops = count($shops);

        $services = Service_Add_Request::get();
        $addions = DB::table("service__requests")->get();

        $num_services = count($services) + count($addions);


        $topServices = Appointment::join('services', 'appointments.service_id', '=', 'services.id')
            ->selectRaw('services.name, COUNT(*) as usage_count')
            ->where('appointments.status', 2)
            ->groupBy('services.id', 'services.name') // Include all selected columns
            ->orderByDesc('usage_count')
            ->limit(5)
            ->get();

        $topShops = Appointment::join('shops', 'appointments.shop_id', '=', 'shops.id')
            ->selectRaw('shops.shop_name, COUNT(*) as usage_count')
            ->where('appointments.status', 2)
            ->groupBy('shops.id', 'shops.shop_name')
            ->orderByDesc('usage_count')
            ->limit(5)
            ->get();

        return view("dashboard", compact(["num_shops", "num_services",'topServices','topShops']));
    }

    public function show_admins(){
        if( !Auth::user()->s_admin){
            return redirect(route('main'));
        }

        $admins= Admin::all()->where('s_admin',false);

        return view('admins.index',compact('admins'));


    }
    public function delete_admin($id){

        if( !Auth::user()->s_admin){
            return redirect(route('main'));
        }
        Admin::destroy($id);

        return redirect(route('admin.show'));
    }

    public function create_admin(){
        if( !Auth::user()->s_admin){
            return redirect(route('main'));
        }


        return view('admins.add_admin');


    }
    public function store_admin(Request $request){
        $request->validate([
            'name'=>'required|string|unique:admins',
            'password'=>'required|string|min:8'
        ]);

        if( !Auth::user()->s_admin){
            return redirect(route('main'));
        }
        $admin = new Admin;
        $admin->name=$request->name;
        $admin->password = bcrypt($request->password);
        $admin->save();

        return redirect(route('admin.show'));
    }
}
