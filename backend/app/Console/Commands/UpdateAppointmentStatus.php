<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use App\Models\Appointment;
use Carbon\Carbon;

class UpdateAppointmentStatus extends Command
{
    protected $signature = 'appointments:update-status';
    protected $description = 'Update the status of appointments where the date and time have passed';

    public function handle()
    {

        $now = Carbon::now();

        // Update appointments with status 1
        Appointment::where(function ($query) use ($now) {
            $query->where('date', '<', $now->toDateString())
                ->orWhere(function ($query) use ($now) {
                    $query->where('date', '=', $now->toDateString())
                        ->where('time', '<', $now->toTimeString());
                });
        })
            ->where('status', 1)
            ->update(['status' => 2]);

        // Delete appointments with status 0
        Appointment::where(function ($query) use ($now) {
            $query->where('date', '<', $now->toDateString())
                ->orWhere(function ($query) use ($now) {
                    $query->where('date', '=', $now->toDateString())
                        ->where('time', '<', $now->toTimeString());
                });
        })
            ->where('status', 0)
            ->delete();

        $this->info('Appointment statuses updated and old appointments deleted successfully.');
    }
}
