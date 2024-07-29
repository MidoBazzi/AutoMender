<?php

use App\Http\Controllers\AdminController;
use App\Http\Controllers\api\PasswordResetController;
use App\Http\Controllers\api\ShopPasswordResetController;
use App\Http\Controllers\ProfileController;
use App\Http\Controllers\ServiceController;
use App\Http\Controllers\ShopController;
use App\Http\Controllers\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "web" middleware group. Make something great!
|
*/

Route::get('/', [AdminController::class, "index"])->middleware('auth')->name("main");

Route::controller(AdminController::class)->group(function () {

    Route::get('/admins',"show_admins")->middleware('auth')->name("admin.show");
    Route::get('/admin/delete/{id}',  "delete_admin")->middleware('auth')->name("admin.delete");
    Route::get('/admin/add',  "create_admin")->middleware('auth')->name("admin.create");
    Route::post('/admin/store',  "store_admin")->middleware('auth')->name("admin.store");

});

Route::get('/dashboard', [AdminController::class, "index"])->middleware(['auth', 'verified'])->name('dashboard');

Route::controller(UserController::class)->group(function () {
    Route::get('users', 'index')->middleware('auth')->name("users");
    Route::get('users/delete/{id}', 'destroy')->middleware('auth')->name("users.delete");

});

Route::controller(ShopController::class)->group(function () {
    Route::get('shops', 'index')->middleware('auth')->name("shops");
    Route::get('shops/details/{id}', 'show')->middleware('auth')->name("shops.details");
    Route::get('shops/requests', 'show_requests')->middleware('auth')->name("shops.requests");
    Route::get('shops/requests/details/{id}', 'show_request')->middleware('auth')->name("shops.requests.details");
    Route::get('shops/requests/approve/{id}', 'approve_request')->middleware('auth')->name("shops.requests.approve");
    Route::get('shops/requests/deny/{id}', 'deny_request')->middleware('auth')->name("shops.requests.deny");
});

Route::controller(ServiceController::class)->group(function () {
    Route::get('services', 'index')->middleware('auth')->name("services");
    Route::get('services/details/{id}', 'show')->middleware('auth')->name("services.details");

    Route::get('services/edit/{id}', 'edit')->middleware('auth')->name("services.edit");
    Route::post('services/edit', 'update')->middleware('auth')->name("services.update");

    Route::get('services/requests', 'show_requests')->middleware('auth')->name("services.requests");
    Route::get('services/requests/details/{id}', 'show_request')->middleware('auth')->name("services.requests.details");
    Route::post('services/requests/approve', 'approve_request')->middleware('auth')->name("services.requests.approve");
    Route::get('services/requests/deny/{id}', 'deny_request')->middleware('auth')->name("services.requests.deny");
    Route::get('services/requests/edit/{id}', 'edit_request')->middleware('auth')->name("services.requests.edit");
    Route::post('services/requests/edit', 'update_request')->middleware('auth')->name("services.requests.update");


    Route::get('services/addions', 'show_addions')->middleware('auth')->name("services.addions");
    Route::get('services/addions/details/{shop_id}/{service_id}', 'show_addion')->middleware('auth')->name("services.addions.details");
    Route::get('services/addions/approve/{shop_id}/{service_id}', 'approve_addion')->middleware('auth')->name("services.addions.approve");
    Route::get('services/addions/deny/{shop_id}/{service_id}', 'deny_addion')->middleware('auth')->name("services.addions.deny");

    Route::get('services/add', 'create')->middleware('auth')->name("services.add");
    Route::post('services/store', 'store')->middleware('auth')->name("services.store");
})->middleware('auth');

Route::get('user/password/reset/{token}',[UserController::class,'resetpassword']);
Route::post('user/password/reset', [PasswordResetController::class, 'reset'])->name("user.resetpassword");

Route::get('shop/password/reset/{token}',[ShopController::class,'resetpassword']);
Route::post('shop/password/reset', [ShopPasswordResetController::class, 'reset'])->name("shop.resetpassword");






require __DIR__ . '/auth.php';
