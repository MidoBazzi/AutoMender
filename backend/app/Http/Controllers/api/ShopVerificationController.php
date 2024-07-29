<?php

namespace App\Http\Controllers\api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Shop;
use Illuminate\Auth\Events\Verified;

class ShopVerificationController extends Controller
{
    use apiResponse;

    public function verify(Request $request)
    {
        // Find the shop using the provided id
        $shop = Shop::find($request->route('id'));

        // Check if the shop exists
        if (! $shop) {
            return 'Shop not found';
        }

        // Check if the shop's email is already verified
        if ($shop->hasVerifiedEmail()) {
            return 'Email already verified';
        }

        // Mark the email as verified and trigger the verified event
        if ($shop->markEmailAsVerified()) {
            event(new Verified($shop));
        }

        // Return a success response
        return 'Email has been verified';
    }
}
