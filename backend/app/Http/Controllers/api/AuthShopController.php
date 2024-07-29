<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Http\Resources\NoTimeResource;
use App\Models\Shop;
use App\Models\shop_request;
use Illuminate\Auth\Events\Registered;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Exception;
use Tymon\JWTAuth\Exceptions\TokenInvalidException;
use Tymon\JWTAuth\Exceptions\TokenExpiredException;
use Tymon\JWTAuth\Exceptions\JWTException;
use Illuminate\Auth\Events\Verified;
use Illuminate\Support\Facades\Auth;


class AuthShopController extends Controller
{

    use apiResponse;
    /**
     * Create a new AuthController instance.
     *
     * @return void
     */
    public function __construct() {
        $this->middleware('auth:api_shop', ['except' => ['login', 'register','refresh','logout','resendVerificationEmail','CheckEmail']]);
    }

    /**
     * Get a JWT via given credentials.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request){
        $validator = Validator::make($request->all(), [
            'email' => 'required|email',
            'password' => 'required|string|min:8',
        ]);
        if ($validator->fails()) {
            return $this->apiResponse($validator->errors(), 422,"Validation error");
        }
        if (! $token = auth()->guard('api_shop')->attempt($validator->validated())) {
            return $this->apiResponse(['error' => 'Unauthorized'], 401,"Wrong email or password");
        }
        $shop = auth()->guard('api_shop')->user();
        if( $shop->email_verified_at == null){
            return $this->apiResponse(null, 401, "Your email address is not verified.");
        }
        return $this->apiResponse($this->createNewToken($token)->original,200,'ok');
    }

    /**
     * Register a User.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function register(Request $request) {
        $validator = Validator::make($request->all(), [
            'owner_name' => 'required|string|between:2,100',
            'shop_name' => 'required|string|between:2,100',
            'email' => 'required|string|email|max:100|unique:shops',
            'password' => 'required|string|min:8',
            'phone_num' => 'required|min:10|unique:shops',
            'location'=> 'required',
            "location_x"=>'required',
            "location_y"=>'required',
            'schedule'=>'required',
            'picture'=> 'required|string',
            'open_time'=>'required',
            'close_time'=>'required',
            'capacity' => 'required|between:1,100',
        ]);
        if($validator->fails()){
            return $this->apiResponse($validator->errors(), 400,'Validation error');
        }

        $shop = new Shop;
        try {

            if (preg_match('/^data:image\/(\w+);base64,/', $request->picture, $type)) {
                $data = substr($request->picture, strpos($request->picture, ',') + 1);
                $type = strtolower($type[1]); // jpg, png, gif

                if (!in_array($type, [ 'jpg', 'jpeg', 'gif', 'png' ])) {
                    throw new \Exception('Invalid image type.');
                }

                $data = base64_decode($data);

                if($data === false) {
                    throw new \Exception('Base64 decode failed.');
                }
            } else {
                throw new \Exception('Did not match data URI with image data.');
            }


            // Save the decoded image
            $imageName = uniqid() . '.' . $type;
            $path = 'shops/' . $imageName;
            Storage::disk('image')->put($path, $data);

            // Ensure the file was saved
            if (!Storage::disk('image')->exists($path)) {
                throw new \Exception('File could not be saved.');
            }


            $validatedData = array_merge($validator->validated(), ['picture' => $path]);
            $shop = shop::create(array_merge(
            $validatedData,
            ['password' => bcrypt($request->password)]));
            event(new Registered($shop));
            $shop = new NoTimeResource($shop);
            return $this->apiResponse($shop,201,'Shop successfully registered');}

        catch (Exception $e) {
            $shop->delete();
            return $this->apiResponse(["error"=>$e->getMessage()],400,"Shop registration failed");
        }

    }

    /**
     * Log the user out (Invalidate the token).
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout() {
        try {
            auth()->guard('api_shop')->logout();
            return $this->apiResponse('Shop successfully signed out', 200, 'ok');
        } catch (TokenInvalidException $e) {
            return $this->apiResponse('Invalid token', 400, 'Bad request');
        } catch (JWTException $e) {

            return $this->apiResponse('An error occurred during logout', 500, 'Internal Server Error');
        } catch (Exception $e) {

            return $this->apiResponse('An unexpected error occurred', 500, 'Internal Server Error');
        }
    }

    /**
     * Refresh a token.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function refresh() {
        try {
            $newToken = auth()->guard('api_shop')->refresh();
            return $this->apiResponse(['token'=>$newToken], 200, "Token refreshed successfully");
        } catch (TokenInvalidException $e) {
            return $this->apiResponse('Invalid token', 400, 'Bad request');
        } catch (TokenExpiredException $e) {
            return $this->apiResponse('Token expired', 401, 'Unauthorized');
        } catch (JWTException $e) {
            return $this->apiResponse('Could not refresh token', 500, 'Internal Server Error');
        }
    }


    public function resendVerificationEmail(Request $request)
    {
        $shop = Shop::where('email',$request->email)->get()->first();

        if ($shop->hasVerifiedEmail()) {
            return $this->apiResponse(null, 400, 'Email already verified.');
        }

        $shop->sendEmailVerificationNotification();

        return $this->apiResponse(null, 200, 'Verification email resent.');
    }
    public function CheckEmail(Request $request)
    {
        $shop = Shop::where('email',$request->email)->get()->first();

        if ($shop->hasVerifiedEmail()) {
            return $this->apiResponse(null, 200, 'Email is verified.');
        }



        return $this->apiResponse(null, 400, 'email is not verified.');
    }

    /**
     * Get the authenticated User.
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function userProfile() {
            return $this->apiResponse(new NoTimeResource (auth()->guard('api_shop')->user()), 200, 'ok');
    }
    /**
     * Get the token array structure.
     *
     * @param  string $token
     *
     * @return \Illuminate\Http\JsonResponse
     */
    protected function createNewToken($token){

        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth()->guard('api_shop')->factory()->getTTL() * 60,
            'user' => new NoTimeResource(auth()->guard('api_shop')->user())
        ]);
    }
}
