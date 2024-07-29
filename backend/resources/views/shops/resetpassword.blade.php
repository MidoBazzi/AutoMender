
<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">

<head>
    <style>
        .flex-row {
            display: flex;
            justify-content: space-between;
            /* Adjusts spacing between items */
        }

        .flex-row>div {
            flex: 1;
            /* Each child takes equal width */
            margin-right: 10px;
            /* Optional: Adjusts spacing between fields */
        }
    </style>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <title>{{ config('app.name') }}</title>
    <link rel="icon" type="image/png" href="{{ asset('favicon.ico') }}">

    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />

    <!-- Scripts -->
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>

<body class="font-sans antialiased">
<div class="min-h-screen bg-gray-100 dark:bg-gray-900">


    <!-- Page Heading -->
    @if (isset($header))
        <header class="bg-white dark:bg-gray-800 shadow">
            <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
                {{ $header }}
            </div>
        </header>
    @endif

    <!-- Page Content -->
    <main>


        <div class="py-12" >
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8" style="margin-inline: 25%" >
                <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg" style="margin-top: 10%;">
                    <div class="p-6 text-gray-900 dark:text-gray-100">


                        <p style="font-weight: 200;font-size:30px; text-align: center">fill this form to reset your password</p>
                        <br>
                        <form method="POST" action="{{ route('shop.resetpassword') }}" style="margin-inline: 20%">
                            @csrf

                            <input type="hidden" name="token" value="{{ $token }}">

                            <div>
                                <x-input-label for="email" :value="__('Email')" />
                                <x-text-input id="email" class="block mt-1 w-full" name="email" :value="old('email')"
                                              required autofocus autocomplete="email" />
                                <x-input-error :messages="$errors->get('email')" class="mt-2" />
                            </div>

                            <div class="mt-4">
                                <x-input-label for="password" :value="__('New Password')" />
                                <x-text-input id="password" class="block mt-1 w-full" type='password' name="password"
                                              :value="old('password')" required autocomplete="password" />
                                <x-input-error :messages="$errors->get('password')" class="mt-2" />
                            </div>

                            <div class="mt-4">
                                <x-input-label for="password_confirmation" :value="__('Confirm Password')" />
                                <x-text-input id="password_confirmation" class="block mt-1 w-full" type='password' name="password_confirmation"
                                              :value="old('password_confirmation')" required autocomplete="password_confirmation" />
                                <x-input-error :messages="$errors->get('password_confirmation')" class="mt-2" />
                            </div>

                            <div class="flex items-center justify-end mt-4">
                                <x-primary-button class="ms-3">
                                    {{ __('Submit') }}
                                </x-primary-button>
                            </div>
                        </form>


                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>

</html>
