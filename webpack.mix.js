const mix = require('laravel-mix')

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel application. By default, we are compiling the Sass
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.js('var/www/html/resources/js/app.js', 'var/www/html/public/js')
   .sass('var/www/html/resources/sass/app.scss', 'var/www/html/public/css')
