<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('shops', function (Blueprint $table) {
            $table->id();
            $table->string('email')->unique();
            $table->timestamp('email_verified_at')->nullable();
            $table->string("owner_name");
            $table->string("shop_name");
            $table->string("location");
            $table->decimal('location_x', 13, 10);
            $table->decimal('location_y', 13, 10);
            $table->integer('open_time')->unsigned();
            $table->integer('close_time')->unsigned();
            $table->string('schedule');
            $table->string('phone_num', 12)->unique();
            $table->string("picture")->unique();
            $table->string('password');
            $table->integer('capacity')->unsigned();
            $table->boolean("approved")->default(false);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('shops');
    }
};
