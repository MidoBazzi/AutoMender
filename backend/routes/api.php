<?php

use App\Http\Controllers\api\CarController;
use App\Http\Controllers\api\ServiceController;
use App\Http\Controllers\api\ShopController;
use App\Http\Controllers\api\ShopPasswordResetController;
use App\Http\Controllers\api\ShopVerificationController;
use App\Http\Controllers\api\VerificationController;
use App\Http\Controllers\api\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\api\AuthController;
use App\Http\Controllers\api\AuthShopController;
use App\Http\Controllers\api\loginController;
use App\Http\Controllers\api\PasswordResetController;
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

//Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
//    return $request->user();
//});


Route::group([
    'middleware' => 'api',
    'prefix' => 'auth'
], function ($router) {
    Route::post('/login', [AuthController::class, 'login']);
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/refresh', [AuthController::class, 'refresh']);
    Route::get('/user-profile', [AuthController::class, 'userProfile']);
});

Route::group([
    'middleware' => 'api',
    'prefix' => 'auth_shop'
], function ($router) {
    Route::post('/login', [AuthShopController::class, 'login']);
    Route::post('/register', [AuthShopController::class, 'register']);
    Route::post('/logout', [AuthShopController::class, 'logout']);
    Route::post('/refresh', [AuthShopController::class, 'refresh']);
    Route::get('/user-profile', [AuthShopController::class, 'userProfile']);
});
Route::group([
    'middleware' => 'api','',
    'prefix' => 'auth_shop'
], function ($router) {
    Route::post('/login', [AuthShopController::class, 'login']);
    Route::post('/register', [AuthShopController::class, 'register']);
    Route::post('/logout', [AuthShopController::class, 'logout']);
    Route::post('/refresh', [AuthShopController::class, 'refresh']);
    Route::get('/user-profile', [AuthShopController::class, 'userProfile']);
});
Route::middleware(['jwt.verify'])->group(function() {
    Route::get('/show',[loginController::class,'index']);
    Route::get('/login/{id}',[loginController::class,'show']);
    Route::post('/login',[loginController::class,'store']);
});


Route::get('/email/verify/{id}/{hash}', [VerificationController::class, 'verify'])->middleware(['signed'])->name('verification.verify');
Route::post('/email/resend', [AuthController::class, 'resendVerificationEmail'])->name('verification.resend');
Route::post('/email/check', [AuthController::class, 'CheckEmail'])->name('verification.check');


Route::get('/shop/email/verify/{id}/{hash}', [ShopVerificationController::class, 'verify'])->middleware(['signed'])->name('shop.verification.verify');
Route::post('/shop/email/resend', [AuthShopController::class, 'resendVerificationEmail'])->name('shop.verification.resend');
Route::post('/shop/email/check', [AuthShopController::class, 'CheckEmail'])->name('shop.verification.check');


Route::post('/password/email', [PasswordResetController::class, 'sendResetLinkEmail']);
Route::post('shop/password/email', [ShopPasswordResetController::class, 'sendResetLinkEmail']);

Route::group([
    'middleware' => ['auth:api'],
    'prefix' => 'user'
], function () {
    Route::get("/home",[UserController::class,"home"]);
    Route::get("/services",[UserController::class,"get_services"]);
    Route::get("/shops/{id}",[UserController::class,"get_shops"]);
    Route::get("/get_dates/{id}",[UserController::class,"get_dates"]);
    Route::post("/get_times",[UserController::class,"get_times"]);
    Route::post("/make_appointment",[UserController::class,"create_appointment"]);
    Route::post("/edit_profile",[UserController::class,"update_user"]);

    Route::post("/edit_car",[CarController::class,"update_car"]);
    Route::get("/delete_car/{id}",[CarController::class,"delete_car"]);


});
Route::post("/user/add_car",[CarController::class,"create_car"]);
Route::get("/user/get_brands",[CarController::class,"get_brands"]);
Route::get("/user/get_country/{id}",[CarController::class,"get_country"]);
Route::get("/user/get_models/{id}",[CarController::class,"get_models"]);

Route::group([
    'middleware' => ['auth:api_shop'],
    'prefix' => 'shop'
], function () {
    Route::get("/show_appointments",[ShopController::class,"get_appointments"]);
    Route::get("/deny_appointment/{id}",[ShopController::class,"deny_appointment"]);
    Route::get("/confirm_appointment/{id}",[ShopController::class,"confirm_appointment"]);
    Route::get("/services",[ShopController::class,"get_services"]);
    Route::post("/add_service",[ShopController::class,"add_service"]);
    Route::post("/request_service",[ShopController::class,"request_service"]);
    Route::get("/history",[ShopController::class,"get_history"]);
    Route::post("/edit_profile",[ShopController::class,"update_shop"]);


});

