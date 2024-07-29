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

                    <form method="POST" action="{{ route('services.requests.update') }}" style="margin-inline: 20%">
                        @csrf
                        <input type="hidden" name="id" value="{{$service->id}}">
                        <input type="hidden" name="shop_id" value="{{$service->shop_id}}">
                        <div>
                            <x-input-label for="name" :value="__('Name')" />
                            <x-text-input id="name" class="block mt-1 w-full" name="name" :value="old('name', $service->name)"
                                required autofocus autocomplete="name" />
                            <x-input-error :messages="$errors->get('name')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="desc" :value="__('Desc')" />
                            <textarea id="desc" name="desc" required autocomplete="desc"
                                class="border-gray-300 dark:border-gray-700 dark:bg-gray-900 dark:text-gray-300 focus:border-indigo-500 dark:focus:border-indigo-600 focus:ring-indigo-500 dark:focus:ring-indigo-600 rounded-md shadow-sm'"
                                style="width:100%;height:100px">{{ old('desc', $service->desc) }}</textarea>
                            <x-input-error :messages="$errors->get('desc')" class="mt-2" />
                        </div>

                        <div class="mt-4">
                            <x-input-label for="price" :value="__('Price')" />
                            <x-text-input id="price" class="block mt-1 w-full" type="text" name="price"
                                :value="old('price', $service->price)" required autocomplete="price"
                                onkeypress="return isNumberKey(event)" />
                            <x-input-error :messages="$errors->get('price')" class="mt-2" />
                        </div>

                        <div class="flex-row">
                            <div class="mt-4">
                                <x-input-label for="hours" :value="__('Hours')" />
                                <x-text-input id="hours" class="block mt-1 w-full" type="text" name="hours"
                                    :value="old('hours',$hours)" required autocomplete="hours" min="0"
                                    onkeypress="return isNumberKey(event)" />
                                <x-input-error :messages="$errors->get('hours')" class="mt-2" />
                            </div>

                            <div class="mt-4">
                                <x-input-label for="min" :value="__('Min')" />
                                <x-text-input id="min" class="block mt-1 w-full" type="text" name="min"
                                    :value="old('min',$minutes)" required autocomplete="min" min="0" max="59"
                                    onkeypress="return isNumberKey(event)" />
                                <x-input-error :messages="$errors->get('min')" class="mt-2" />
                            </div>
                        </div>



                        <div class="flex items-center justify-end mt-4">
                            <x-primary-button class="ms-3">
                                {{ __('Approve') }}
                            </x-primary-button>
                        </div>
                    </form>

                    <script>
                        function isNumberKey(evt) {
                            var charCode = (evt.which) ? evt.which : evt.keyCode;
                            // Allow only numeric (0-9) characters
                            return (charCode >= 48 && charCode <= 57);
                        }
                    </script>

                </div>
            </div>
        </div>
    </div>
</x-app-layout>
