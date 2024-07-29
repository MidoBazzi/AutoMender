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
        Schema::create('service__add__requests', function (Blueprint $table) {
            $table->id();
            $table->string('name')->unique();
            $table->string('desc');
            $table->integer('price')->unsigned();
            $table->time("time_req");
            $table->foreignId("shop_id")->constrained("shops")->cascadeOnDelete();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('service__add__requests');
    }
};
