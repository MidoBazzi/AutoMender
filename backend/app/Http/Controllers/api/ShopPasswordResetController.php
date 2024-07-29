<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Password;

class ShopPasswordResetController extends Controller
{
    public function sendResetLinkEmail(Request $request)
    {
        $request->validate(['email' => 'required|email']);


        $response = Password::broker('shops')->sendResetLink(
            $request->only('email')
        );

        if ($response == Password::RESET_LINK_SENT) {
            return response()->json(['message' => 'Reset link sent to your email.'], 200);
        }

        return response()->json(['message' => 'Unable to send reset link'], 500);
    }

    public function reset(Request $request)
    {
        $request->validate([
            'token' => 'required',
            'email' => 'required|email',
            'password' => 'required|confirmed|min:8',
        ]);

        $response = Password::broker('shops')->reset(
            $request->only('email', 'password', 'password_confirmation', 'token'),
            function ($shop, $password) {
                $shop->forceFill([
                    'password' => bcrypt($password)
                ])->save();
            }
        );

        if ($response == Password::PASSWORD_RESET) {
            return view("shops.reset_successful");
        }

        return view("shops.reset_failed");
    }
}
