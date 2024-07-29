<?php

namespace App\Http\Controllers\api;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Auth\Events\Verified;

class VerificationController extends Controller
{
    use apiResponse;
    public function verify(Request $request)
    {
        $user = User::find($request->route('id'));

        if (! $user) {
            return'User not found';
        }

        if ($user->hasVerifiedEmail()) {
            return 'Email already verified';
        }

        if ($user->markEmailAsVerified()) {
            event(new Verified($user));
        }

        return 'Email has been verified';
    }
}
