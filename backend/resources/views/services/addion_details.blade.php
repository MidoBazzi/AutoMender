<!DOCTYPE html>

<head>

    <style>
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

        html,
        body,
        .intro {
            height: 100%;
            width: 100%;
        }

        table {
            width: 100%;
            margin: 15px;

        }



        table td,
        table th {
            padding: 8px;
            text-align: center;
            text-overflow: ellipsis;
            white-space: nowrap;
            overflow: hidden;
        }

        .mask-custom {
            background: rgba(24, 24, 16, .2);
            border-radius: 2em;
            backdrop-filter: blur(25px);
            border: 2px solid rgba(255, 255, 255, 0.05);
            background-clip: padding-box;
            box-shadow: 10px 10px 10px rgba(46, 54, 68, 0.03);
        }
    </style>
</head>
<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Service Addion Requests') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">



                    <section class="intro">
                        <div class="bg-image h-100">
                            <div class="mask d-flex align-items-center h-100">
                                <div class="container">
                                    <div class="row justify-content-center">
                                        <div class="col-12">
                                            <div class="card mask-custom">
                                                <div class="card-body">
                                                    <div class="table-responsive">
                                                        <table class="table table-borderless text-white mb-0">
                                                            <thead>
                                                                <tr>
                                                                    <th scope="col" style="font-size: 28px;">Shop
                                                                    </th>
                                                                    <th scope="col" style="font-size: 28px;">Service
                                                                    </th>
                                                                </tr>
                                                            </thead>
                                                            <tbody>

                                                                <tr>
                                                                    <td scope="row">
                                                                        name: {{ $shop->shop_name }}
                                                                    </td>
                                                                    <td scope="row">name: {{ $service->name }}
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td scope="row">owner name:
                                                                        {{ $shop->owner_name }}
                                                                    </td>
                                                                    <td scope="row">price: {{ $service->price }}
                                                                    </td>
                                                                </tr>

                                                                <tr>
                                                                    <td scope="row">location: {{ $shop->location }}
                                                                    </td>
                                                                    <td scope="row">time
                                                                        required: {{ $service->time_req }}
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td scope="row"><a style="color: #405cf5"
                                                                            href="{{ route('shops.details', $shop->id) }}">
                                                                            More information</a></td>
                                                                    <td scope="row"><a style="color: #405cf5"
                                                                            href="{{ route('services.details', $service->id) }}">
                                                                            More information</a></td>
                                                                </tr>
                                                            </tbody>
                                                        </table>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </section>

                    <br><br><br>
                    <a href="{{ route('services.addions.approve', ['shop_id' => $addion->shop_id, 'service_id' => $addion->service_id]) }}">
                        <button class="button-9" type="submit" role="button"
                            style="background-color: #57c131;">Approve</button></a>

                    <a href="{{ route('services.addions.deny', ['shop_id' => $addion->shop_id, 'service_id' => $addion->service_id]) }}"><button class="button-9"
                            role="button">Deny</button></a>

                </div>
            </div>
        </div>
    </div>
</x-app-layout>
