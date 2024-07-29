<?php

namespace App\Http\Controllers\API;

use App\Http\Resources\NoTimeResource;
use Illuminate\Auth\Events\Registered;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Exception;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\JWTException;
use Illuminate\Auth\Events\Verified;
use Illuminate\Support\Facades\Auth;

class AuthController extends Controller
{
    use apiResponse;
    /**
     * Create a new AuthController instance.
     *
     * @return void
     */
    public function __construct() {
        $this->middleware('auth:api', ['except' => ['login', 'register','logout','refresh','resendVerificationEmail','CheckEmail']]);
    }


    public function login(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string|min:8',
        ]);
        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422,"Validation error");
        }
        $credentials = $validator->validated();


        if (! $token = auth()->guard('api')->attempt($credentials)) {
            return $this->apiResponse(['error' => 'Unauthorized'], 401, "Wrong email or password");
        }

        $user = auth()->guard('api')->user();
        if( $user->email_verified_at == null){
            return $this->apiResponse(null, 401, "Your email address is not verified.");
        }
        return $this->apiResponse($this->createNewToken($token)->original,200,'ok');
    }


    public function register(Request $request) {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|between:2,25',
            'email' => 'required|string|email|max:100|unique:users',
            'password' => 'required|string|min:8',
            'phone_num' => 'required|min:10|unique:users',
        ]);
        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }
        try {

        $user = User::create(array_merge(
            $validator->validated(),
            ['password' => bcrypt($request->password)]));

        event(new Registered($user));

        return $this->apiResponse(new NoTimeResource($user),200,"User successfully registered");
        }
        catch (Exception $e) {
            $user->delete();
            return $this->apiResponse(["error"=>$e->getMessage()],400,"User registration failed");
        }
    }

    /**
     * Log the user out (Invalidate the token).
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout() {
        try {
            auth()->guard('api')->logout();
            return $this->apiResponse(null, 200, 'User successfully signed out');
        } catch (TokenInvalidException $e) {
            // Handle invalid token
            return $this->apiResponse(null, 400, 'Invalid token');
        } catch (JWTException $e) {
            // Handle other JWT related errors
            return $this->apiResponse(null, 500, 'An error occurred during logout');
        } catch (Exception $e) {
            // Handle any other exceptions
            return $this->apiResponse(null, 500, 'An unexpected error occurred');
        }
    }

    /**
     * Refresh a token.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function refresh() {
        try {
            $newToken = auth()->guard('api')->refresh();
            return $this->apiResponse(['token'=>$newToken], 200, 'Token refreshed successfully');
        } catch (TokenExpiredException $e) {

            return $this->apiResponse(null, 401, 'Token expired');
        } catch (TokenInvalidException $e) {

            return $this->apiResponse(null, 400, 'Invalid token');
        } catch (JWTException $e) {

            return $this->apiResponse(null, 500, 'Could not refresh token');
        } catch (Exception $e) {

            return $this->apiResponse(null, 500, 'An unexpected error occurred');
        }
    }

public function resendVerificationEmail(Request $request)
{
    $user = User::where('email',$request->email)->get()->first();

    if ($user->hasVerifiedEmail()) {
        return $this->apiResponse(null, 400, 'Email already verified.');
    }

    $user->sendEmailVerificationNotification();

    return $this->apiResponse(null, 200, 'Verification email resent.');
}

    public function userProfile() {
        return  $this->apiResponse(new NoTimeResource(auth()->guard('api')->user()),200,'ok');
    }
    public function CheckEmail(Request $request)
    {
        $user = User::where('email',$request->email)->get()->first();

        if ($user->hasVerifiedEmail()) {
            return $this->apiResponse(null, 200, 'Email is verified.');
        }

        return $this->apiResponse(null, 400, 'email is not verified.');
    }

    protected function createNewToken($token){
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth()->guard('api')->factory()->getTTL() * 60,
            'user' => new NoTimeResource(auth()->guard('api')->user())
        ]);
    }
}
