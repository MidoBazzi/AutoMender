<?php

namespace App\Http\Controllers;

use App\Models\Shop;
use App\Models\Shop_Request;
use Illuminate\Http\Request;

class ShopController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $shops = Shop::all()->where('approved',true);
        return view("shops.index", compact("shops"));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $shop = Shop::findorfail($id);

        return view("shops.details", compact("shop"));
    }

    public function show_request($id)
    {
        $shop = Shop::findorfail($id);

        return view("shops.request_details", compact("shop"));
    }

    public function approve_request($id)
    {
        $shop = Shop::findorfail($id);
        $shop->approved = true;
        $shop->save();
        return redirect(route("shops.requests"));
    }

    public function deny_request($id)
    {
        Shop::destroy($id);

        return redirect(route("shops.requests"));
    }
    public function show_requests()
    {
        $shops = Shop::all()->where('approved',false)->where('email_verified_at','!=',null);

        return view("shops.requests", compact("shops"));
    }

    public function edit(Shop $shop)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Shop $shop)
    {
        //
    }

    public function resetpassword($token)
    {
        return view('shops.resetpassword',compact('token'));
    }
    public function destroy(Shop $shop)
    {
        //
    }
}
