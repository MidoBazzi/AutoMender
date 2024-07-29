<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Service extends Model
{
    use HasFactory;

    protected $guarded = [];

    public function shops(): BelongsToMany
    {
        return $this->belongsToMany(Shop::class , 'shop_service');
    }
    public function appointments(): HasMany
    {
        return $this->hasMany(Appointment::class);
    }
    public function requests(): HasMany
    {
        return $this->hasMany(Service_Request::class);
    }

}
