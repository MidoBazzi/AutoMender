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
        Schema::create('shop_service', function (Blueprint $table) {
            $table->foreignId("shop_id")->constrained("shops")->cascadeOnDelete();
            $table->foreignId("service_id")->constrained("services")->cascadeOnDelete();
            $table->timestamps();

            $table->primary(['shop_id', 'service_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('shop_service');
    }
};
