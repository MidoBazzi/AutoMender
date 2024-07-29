<x-app-layout>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <x-slot name="header">
        <h2 class="font-semibold text-xl text-gray-800 dark:text-gray-200 leading-tight">
            {{ __('Dashboard') }}
        </h2>
    </x-slot>

    <div class="py-12">
        <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
            <div class="bg-white dark:bg-gray-800 overflow-hidden shadow-sm sm:rounded-lg">
                <div class="p-6 text-gray-900 dark:text-gray-100">
                    <p style="font-weight: 250;font-size:28px;">Welcome to the AutoMender Dashboard</p><br>
                    <ul style="list-style-type: disc;margin-left: 5%">
                    <li>there are {{$num_shops }} requests for new shops</li>
                    <li>there are {{ $num_services }} requests for services</li>
                    </ul>
                    <br> <br>

                    <p style="font-weight: 250;font-size:28px;">Statistics:</p><br>
                    <div style="display: flex; justify-content: space-around; align-items: center;">
                    <!-- Doughnut Chart -->
                    <div style="width:500px; height:500px;flex: 1; padding: 20px;">
                        <canvas id="myChart"></canvas>
                    </div>

                    <script>
                        var chartData = @json($topServices);

                        const doughnutData = {
                            labels: chartData.map(item => item.name),
                            datasets: [{
                                label: 'Service Usage',
                                data: chartData.map(item => item.usage_count),
                                borderColor: 'rgba(8,11,12,0)',
                                backgroundColor: ['rgba(132,51,255,0.63)' ,'rgba(175,30,171,0.78)', 'rgba(17,34,210,0.63)', 'rgba(0,217,255,0.63)', 'rgba(74,52,114,0.63)']
                            }]
                        };

                        const doughnutConfig = {
                            type: 'doughnut',
                            data: doughnutData,
                            options: {
                                responsive: true,
                                plugins: {
                                    legend: {
                                        position: 'top',
                                    },
                                    title: {
                                        display: true,
                                        text: 'Most Requested Services'
                                    }
                                }
                            },
                        };

                        const doughnutChart = new Chart(
                            document.getElementById('myChart'),
                            doughnutConfig
                        );
                    </script>

                    <!-- Bar Chart -->
                    <div style="width:500px; height:500px;flex: 1; padding: 20px;padding-top: 150px ">
                        <canvas id="myOtherChart"></canvas>
                    </div>

                    <script>
                        var shopChartData = @json($topShops);

                        const barData = {
                            labels: shopChartData.map(item => item.shop_name),
                            datasets: [{
                                label: 'Shop Usage',
                                data: shopChartData.map(item => item.usage_count),
                                backgroundColor: ['rgba(132,51,255,0.63)' ,'rgba(175,30,171,0.78)', 'rgba(17,34,210,0.63)', 'rgba(0,217,255,0.63)', 'rgba(74,52,114,0.63)']
                            }]
                        };

                        const barConfig = {
                            type: 'bar',
                            data: barData,
                            options: {
                                responsive: true,
                                plugins: {
                                    legend: {
                                        position: 'top',
                                    },
                                    title: {
                                        display: true,
                                        text: 'Most Requested Shops'
                                    }
                                }
                            },
                        };

                        const barChart = new Chart(
                            document.getElementById('myOtherChart'),
                            barConfig
                        );
                    </script>
                </div>
            </div>
        </div>
    </div>
    </div>

</x-app-layout>
