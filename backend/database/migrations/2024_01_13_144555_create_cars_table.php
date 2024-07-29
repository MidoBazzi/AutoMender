<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('cars', function (Blueprint $table) {
            $table->id();
            $table->foreignId("country_id")->constrained("countries")->cascadeOnDelete();
            $table->foreignId("car_model_id")->constrained("car_models")->cascadeOnDelete();
            $table->foreignId("brand_id")->constrained("brands")->cascadeOnDelete();
            $table->string('governorate');
            $table->integer('curr_mialage')->unsigned();
            $table->integer('next_mialage')->unsigned();
            $table->integer('plate_num')->unique();
            $table->string('color');
            $table->foreignId("user_id")->constrained("users")->cascadeOnDelete();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cars');
    }
};
