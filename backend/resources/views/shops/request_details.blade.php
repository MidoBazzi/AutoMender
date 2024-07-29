<!DOCTYPE html>

<head>

    <style>
        li{
            margin-top: 5px;
        }

        .button-9 {
            float: middle;
            appearance: button;
            backface-visibility: hidden;
            background-color: #ef4141;
            border-radius: 6px;
            border-width: 0;
            box-shadow: rgba(50, 50, 93, .1) 0 0 0 1px inset, rgba(50, 50, 93, .1) 0 2px 5px 0, rgba(0, 0, 0, .07) 0 1px 1px 0;
            box-sizing: border-box;
            color: #fff;
            cursor: pointer;
            font-family: -apple-system, system-ui, "Segoe UI", Roboto, "Helvetica Neue", Ubuntu, sans-serif;
            font-size: 100%;
            height: 44px;
            line-height: 1.15;
            margin: 12px 0 0;
            outline: none;
            overflow: hidden;
            padding: 0 25px;
            position: relative;
            text-align: center;
            text-transform: none;
            transform: translateZ(0);
            transition: all .2s, box-shadow .08s ease-in;
            user-select: none;
            -webkit-user-select: none;
            touch-action: manipulation;
            width: 15%;
            margin-left: 22%;
            margin-right: 5%;
        }

        .button-9:disabled {
            cursor: default;
        }

        .button-9:focus {
            box-shadow: rgba(50, 50, 93, .1) 0 0 0 1px inset, rgba(50, 50, 93, .2) 0 6px 15px 0, rgba(0, 0, 0, .1) 0 2px 2px 0, rgba(50, 151, 211, .3) 0 0 0 4px;

        }
    </style>
</head>
<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Shop request details') }}
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
                    <br><br><br><br>

                    <a href="{{ route('shops.requests.approve', $shop->id) }}"><button class="button-9" role="button"
                            style="background-color: #57c131;">Approve</button></a>
                    <a href="{{ route('shops.requests.deny', $shop->id) }}"><button class="button-9"
                            role="button">Deny</button></a>



                </div>
            </div>
        </div>
    </div>
</x-app-layout>
