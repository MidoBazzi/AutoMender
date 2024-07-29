<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ShopResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray($request)
    {
        // Assuming 'picture' is the field name in your database
        $pictureUrl = $this->picture ? asset('images/' . $this->picture) : null;

        return [
            'id' => $this->id,
            'email' => $this->email,
            'email_verified_at' => $this->email_verified_at,
            'owner_name' => $this->owner_name,
            'shop_name' => $this->shop_name,
            'location' => $this->location,
            'location_x' => $this->location_x,
            'location_y' => $this->location_y,
            'open_time' => $this->open_time,
            'close_time' => $this->close_time,
            'schedule' => $this->schedule,
            'phone_num' => $this->phone_num,
            'picture' => $pictureUrl,
            'capacity' => $this->capacity,
            'approved' => $this->approved,
            // Do not include 'password' and 'pivot'
        ];
    }
}
