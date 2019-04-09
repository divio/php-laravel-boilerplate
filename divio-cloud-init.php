<?php
/**
 * This script is prepended to any single script call in the 
 * divio cloud. Its main purpose is to parse the environment 
 * variables and translate them into a format that laravel
 * can work with without touching the framework itself.
 */

/**
 * Set the basic environment settings like encryption key and 
 * debug mode
 */
$_ENV['APP_KEY'] = 'base64:'. base64_encode(substr($_SERVER['SECRET_KEY'] ?? $_SERVER['PHP_SHA256'], 0, 32));
$_ENV['APP_DEBUG'] = $_SERVER['DEBUG'] ?? true;
$_ENV['APP_URL'] = $_SERVER['DOMAIN'] ?? 'http://localhost';
$_ENV['APP_ENV'] = $_SERVER['STAGE'] ?? 'local';
$_ENV['APP_NAME'] = $_SERVER['SITE_NAME'] ?? 'Laravel Boilerplate';

/**
 * force setting the cache and session drivers to use database
 */
$_ENV['CACHE_DRIVER'] = 'database';
$_ENV['SESSION_DRIVER'] = 'database';

/**
 * set default logging output to stderr
 */
$_ENV['LOG_CHANNEL'] = 'stderr';

/**
 * get the database credentials from the DSN variable and 
 * translate them into different environment variables
 */
list($pg_protocol, $pg_credentials, $pg_host, $pg_port, $pg_dbname) = preg_split('/(:\/\/)|(\/)|(@)|(:(?!.*:))/', $_SERVER['DEFAULT_DATABASE_DSN'] ?? 'postgres://postgres@db:5432/db');
$explodedCredentials = explode(':', $pg_credentials);
$pg_username = $explodedCredentials[0];
$pg_password = $explodedCredentials[1] ?? '';

$_ENV['DB_CONNECTION'] = 'pgsql';
$_ENV['DB_USERNAME'] = $pg_username;
$_ENV['DB_PASSWORD'] = $pg_password;
$_ENV['DB_HOST'] = $pg_host;
$_ENV['DB_PORT'] = $pg_port;
$_ENV['DB_DATABASE'] = $pg_dbname;

/**
 * get the storage dsn and translate it into different
 * environment variables
 */

if(isset($_SERVER['DEFAULT_STORAGE_DSN'])) {

    list($s3_protocol, $s3_key, $s3_secret, $s3_bucket, $s3_params) = preg_split('/(s3:\/\/)|(:)|(@)|(\/\?)/', $_SERVER['DEFAULT_STORAGE_DSN']);

    $_ENV['FILESYSTEM_DRIVER'] = 's3';
    $_ENV['AWS_ACCESS_KEY_ID'] = $s3_key;
    $_ENV['AWS_SECRET_ACCESS_KEY'] = $s3_secret;
    $_ENV['AWS_BUCKET'] = $s3_bucket;

}