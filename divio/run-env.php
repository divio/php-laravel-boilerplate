<?php
/**
 * This script is prepended to any single script call.
 * Its main purpose is to parse the environment
 * variables and translate them into a format that laravel
 * can work with without touching the framework itself.
 */

require_once("rewrite-env.php");
system(implode(" ", array_slice($argv, 1)));
