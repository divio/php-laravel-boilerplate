<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Cache;
use \Str;


class CheckController extends Controller
{

    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
    }   


    public function database() {

        echo "\n\n";
        echo "## selecting * from users\n\n";

        echo "<pre>";
        var_dump(DB::table('users')->get());
        echo "</pre>";

        echo "\n\n";
        echo "## insert into users\n\n";

        DB::table('users')->insert(
            [
                'name' => Str::random(10),
                'email' => Str::random(10) ."@example.com",
                'email_verified_at' => now(),
                'password' => '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 
                'remember_token' => Str::random(10),
            ]
        );

        echo "\n\n";
        echo "## selecting * from users\n\n";

        echo "<pre>";
        var_dump(DB::table('users')->get());
        echo "</pre>";

        DB::table('users')->delete();

    }

    public function cache() {
        
        echo "## inserting random string into cache \n\n";

        Cache::put('test', Str::random(12));

        echo "\n\n";
        echo "## getting random string from cache \n\n";

        echo "<pre>";
        var_dump(Cache::get('test'));
    }

    public function env() {
        echo "<pre>";

        var_dump($_ENV);
    }

    public function filesystem() {
        $filename = Str::random(8);

        echo "## Uploading random file $filename";
        Storage::put($filename, Str::random(100));

        echo "<br>";

        $url = Storage::url($filename);
        echo "## getting url of $filename -> $url";


    }
}
