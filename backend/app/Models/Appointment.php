<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Carbon;
class Appointment extends Model
{
    protected $guarded = [];

    use HasFactory;



    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
    public function shop(): BelongsTo
    {
        return $this->belongsTo(Shop::class);
    }
    public function service(): BelongsTo
    {
        return $this->belongsTo(Service::class);
    }
    public function car(): BelongsTo
    {
        return $this->belongsTo(Car::class);
    }

}
