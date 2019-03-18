<?php

namespace App\Http\Middleware;

use Closure;

class DefaultDatabaseDsn
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        //TODO: - read db config from environment and env-local

        $DEFAULT_DATABASE_DSN = $request->server('DEFAULT_DATABASE_DSN');
        $DEFAULT_DATABASE_DSN = "postgres://laravelboilerplate-test-bccfa16670ad4313a4d417e4596506d-12a49a6:3RMUh9rTc00AjmEWSoXCZ5Cq3B4C2dElzNfx48APwUEFQEuFycrQa-v4s3GXzK8jXUggUo1zDgfYmFgv@appctl-black-sites-02.cs4nfpul9fcn.us-east-1.rds.amazonaws.com:5432/laravelboilerplate-test-bccfa16670ad4313a4d417e4596506d-9f37207";

        /*
         * parse env variable
         */
        list($pg_protocoll, $pg_credentials, $pg_host, $pg_port, $pg_dbname) = preg_split('/(:\/\/)|(\/)|(@)|(:(?!.*:))/', $DEFAULT_DATABASE_DSN);

        /*
         * extract credentials
         */
        $explodedCredentials = explode(':', $pg_credentials);
        $pg_username = $explodedCredentials[0];
        $pg_password = $explodedCredentials[1];

        /*
         * set config
         */
        /*config(['database.connections.pgsql' => [
            'driver' => 'pgsql',
            'host' => $pg_host,
            'password' => $pg_password,
            'database' => $pg_dbname,
            'username' => $pg_username,
            'port' => $pg_port
        ]]);*/


        /*
         * go on
         */
        return $next($request);
    }
}
