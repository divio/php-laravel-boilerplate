<?php

namespace App\Http\Middleware;

use Closure;

class DefaultStorageDsn
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request $request
     * @param  \Closure $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        //TODO: - read s3config from environment and env-local
        //      - switch between s3 and local filesystem depending on STAGE variable
        //      - set region dynamically

        $DEFAULT_STORAGE_DSN = $request->server('DEFAULT_STORAGE_DSN');
        $DEFAULT_STORAGE_DSN = "s3://AKIAJVBYRKTFRWFUSZGQ:Q56LUCssaPi7npK4fBEm6pdR5gxL85PAiTXeG7ls@laravelboilerplate-test-bccfa16670ad43-6255fcb.aldryn-media.com.s3.amazonaws.com/?auth=s3v4&domain=laravelboilerplate-test-bccfa16670ad43-6255fcb.aldryn-media.com";

        list($s3_protocoll, $s3_key, $s3_secret, $s3_bucket, $s3_params) = preg_split('/(s3:\/\/)|(:)|(@)|(\/\?)/', $DEFAULT_STORAGE_DSN);


        config(['filesystems' => [
            'default' => 's3',
            'disks' => [
                's3' => [
                    'driver' => 's3',
                    'key' => $s3_key,
                    'secret' => $s3_secret,
                    'bucket' => explode('.s3.', $s3_bucket)[0],
                    'region' => 'us-east-1'
                ]
            ]
        ]]);

        return $next($request);
    }
}
