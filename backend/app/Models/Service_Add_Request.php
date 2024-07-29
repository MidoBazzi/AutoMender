<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Service_Add_Request extends Model
{
    protected $guarded = [];
    use HasFactory;


    public function shop(): BelongsTo
    {
        return $this->belongsTo(Shop::class);
    }
}
