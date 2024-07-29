<!DOCTYPE html>

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
</head>
<x-app-layout>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Add a Service') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8" style="margin-inline: 25%">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">


                    <p style="font-weight: 200;font-size:30px; margin-left:10px;">Please fill this form</p>

                    <form method="POST" action="{{ route('admin.store') }}" style="margin-inline: 20%">
                        @csrf

                        <div>
                            <x-input-label for="name" :value="__('Name')" />
                            <x-text-input id="name" class="block mt-1 w-full" name="name" :value="old('name')"
                                required autofocus autocomplete="name" />
                            <x-input-error :messages="$errors->get('name')" class="mt-2" />
                        </div>


                        <div class="mt-4">
                            <x-input-label for="password" :value="__('Password')" />
                            <x-text-input id="password" class="block mt-1 w-full" type="password" name="password"
                                :value="old('password')" required autocomplete="password"/>
                            <x-input-error :messages="$errors->get('password')" class="mt-2" />
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
</x-app-layout>
