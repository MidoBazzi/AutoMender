
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
                <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg" style="margin-block: 10%;">
                    <div class="p-6 text-gray-900 dark:text-gray-100">


                        <p style="font-weight: 200;font-size:30px; text-align: center">Sorry we couldn't reset your password</p>



                    </div>
                </div>
            </div>
        </div>
    </main>
</div>
</body>

</html>
