<?php

$basepath = "/app";

chmod($basepath ."/divio/run-locally.sh", 0755);
chmod($basepath ."/divio/ensure-env.sh", 0755);

$directories = [
    "bootstrap/cache",
    "storage/framework/sessions",
    "storage/framework/views",
    "storage/framework/cache",
    "storage/public"
];

foreach($directories as $directory) {
    if(!is_dir($basepath ."/". $directory)) {
        mkdir($basepath ."/". $directory, 0777, true);
    }
}

system("cd $basepath && composer install");
system("cd $basepath && php artisan migrate");
