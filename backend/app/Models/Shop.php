<?php

namespace App\Models;

use App\Notifications\ApiResetPasswordNotification;
use App\Notifications\ShopApiResetPasswordNotification;
use App\Notifications\ShopVerifyEmail;
use Illuminate\Contracts\Auth\CanResetPassword;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Illuminate\Support\Facades\URL;
use Laravel\Sanctum\HasApiTokens;
use Tymon\JWTAuth\Contracts\JWTSubject;


class Shop extends Authenticatable implements JWTSubject, MustVerifyEmail , CanResetPassword
{
    use HasApiTokens, HasFactory, Notifiable;



    public function sendPasswordResetNotification($token)
    {
        $this->notify(new ShopApiResetPasswordNotification($token));
    }

    public function sendEmailVerificationNotification()
    {
        $this->notify(new ShopVerifyEmail);
    }
    public function verificationUrl()
    {
        return URL::signedRoute(
            'shop.verification.verify',
            ['id' => $this->getKey(), 'hash' => sha1($this->getEmailForVerification())]
        );
    }
    protected $guarded = [];






    /**
     * Get the identifier that will be stored in the subject claim of the JWT.
     *
     * @return mixed
     */
    public function getJWTIdentifier() {
        return $this->getKey();
    }
    /**
     * Return a key value array, containing any custom claims to be added to the JWT.
     *
     * @return array
     */
    public function getJWTCustomClaims() {
        return [];
    }

    public function appointments(): HasMany
    {
        return $this->hasMany(Appointment::class);
    }
    public function service_add_requests(): HasMany
    {
        return $this->hasMany(Service_Add_Request::class);
    }

    public function services(): BelongsToMany
    {
        return $this->belongsToMany(Service::class , 'shop_service');
    }
    public function requests(): HasMany
    {
        return $this->hasMany(Service_Request::class);
    }

}
