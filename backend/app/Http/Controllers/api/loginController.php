<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class loginController extends Controller
{
    public function index(){
        $users=\App\Models\User::get();
        $msg=["ok"];
        return response($users,200,$msg);
    }

    public function show($id){
        $users=\App\Models\User::find($id);
        $msg=["ok"];
        if($users){
            return response($users,200,$msg);
        }
        $msg=["The user is not found ..."];
        return response($msg,200,$msg);
    }

    public function store(Request $request){

        $validator = Validator::make($request->all(), [
            'name' => 'required',
            'email' => 'required',
            'phone_num' => 'required',
            'password' => 'required',
        ]);
        $msg=["The user is not saved ..."];
        if($validator->fails()){
            return response($validator->errors(),201,$msg);
        }
        $user=User::create($request->all());
        $msg=["ok"];
        if($user){
            return response($user,201,$msg);
        }
        $msg=["The user is not saved ..."];
        return response($msg,400,$msg);
    }
}
