<!DOCTYPE html>

<head>

    <style>

        li{
            margin-top: 5px;
        }

    </style>
</head>
<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Shop details') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">
                    <div>
                        <img src="{{ asset('images/' . $shop->picture) }}" alt="shop logo" style="width: 500px; height: 300px; object-fit: cover; border: 2px; float: right; margin: 0 0 8px 8px; margin-right: 4%;">

                        <div style="margin-left: 8%;">
                            <br>
                            <p style="font-size: 30px; font-weight: bold;">Shop name: {{ $shop->shop_name }}</p>
                            <ul style="margin-left: 2%; list-style-type: disc;">
                                <li>Owner name: {{ $shop->owner_name }}</li>
                                <li>Location: {{ $shop->location }}</li>
                                <li>Cor: {{ $shop->location_x }},{{ $shop->location_y }}</li>
                                <li>Schedule: {{ $shop->open_time }} -> {{ $shop->close_time }}</li>
                                <li>Email: {{ $shop->email }}</li>
                                <li>Phone number: {{ $shop->phone_num }}</li>
                                <li>Capacity: {{ $shop->capacity }}</li>
                                <li>Schedule: {{ $shop->schedule }}</li>
                            </ul>
                        </div>
                    </div>
                    <br><br>




                </div>
            </div>
        </div>
    </div>
</x-app-layout>
