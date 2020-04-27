

.. raw:: html

   <p align="center"><img src="https://laravel.com/assets/img/components/logo-laravel.svg"></p>


Laravel for Divio Cloud
-----------------------

This is a boilerplate template to integrate Laravel with Divio Cloud.


* `Laravel for Divio Cloud <#laravel-for-divio-cloud>`_
* `About Laravel <#about-laravel>`_
* `Divio Cloud <#divio-cloud>`_
* `Installation <#installation>`_

  * `Development <#development>`_
  * `Divio Cloud distinctions <#divio-cloud-distinctions>`_

About Laravel
-------------

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

* `Simple, fast routing engine <https://laravel.com/docs/routing>`_.
* `Powerful dependency injection container <https://laravel.com/docs/container>`_.
* Multiple back-ends for `session <https://laravel.com/docs/session>`_ and `cache <https://laravel.com/docs/cache>`_ storage.
* Expressive, intuitive `database ORM <https://laravel.com/docs/eloquent>`_.
* Database agnostic `schema migrations <https://laravel.com/docs/migrations>`_.
* `Robust background job processing <https://laravel.com/docs/queues>`_.
* `Real-time event broadcasting <https://laravel.com/docs/broadcasting>`_.

Laravel is accessible, powerful, and provides tools required for large, robust applications.

Divio Cloud
-----------

Divio Cloud is cloud native service to quickly and easily deploy web projects with a no-fuss easy-to-use platform. The service seamlessly integrates with Laravel due to Laravel`s flexible configuration and its wide support for databases and cloud services. However, the default configuration of Laravel has to be slightly extended to automatically get all the benefits from Divio Cloud like painless and zero-downtime deployments, auto-scaling, backups etc.

By using Divio Cloud you automatically get all the tools you are (or want to be ;)) used to out-of-the-box:


* a Docker setup for production and development
* a private git repository
* complete Laravel setup with all dependencies
* preinstalled and seamless AWS S3 integration
* composer on steroids with `prestissimo <https://github.com/hirak/prestissimo>`_
* a production environment using nginx and php-fpm
* the necessary frontend tools in the correct version

Installation
------------

After creating your project in the divio cloud interface, enter your applications dashboard and press ``DEPLOY`` to deploy the initial version on a test server. This will deploy a single server instance with your boilerplate ready to work in the cloud. Just click the link provided on the dashboard and the laravel default home will welcome you with a complete installation. You're new Laravel app is already deployed to the cloud, using your database and a cloud storage.

Development
^^^^^^^^^^^

First, you should install the ``divio-cli`` `command line application <http://docs.divio.com/en/latest/reference/divio-cli.html>`_ or the `Divio GUI <http://docs.divio.com/en/latest/reference/divio-app.html>`_ to get started. Please read the docs carefully and make sure the client is configured and ready to use before you continue as it will make sure all dependencies are present. The ``divio-cli`` makes use of docker to provide a local development environment. In the background ``docker-compose`` is used to provide all the services needed for development in an environment as similar as possible to the cloud running you production application. After making sure ``divio-cli`` is working fine, please tun the installation commands as follows and replace ``SLUG`` with the name you chose for your application:

.. code-block::

   $ divio project setup SLUG

This will clone the boilerplate to your local computer, download the database and setup your environment. To complete the php installation please enter the newly create directory (\ ``cd SLUG``\ ) named after your application, created by the ``git clone`` during the setup to enter the application root containing your laravel application sources and run

.. code-block::

   $ docker-compose run web php /app/divio/setup.php

This will make sure all directories needed are created, permissions are set correctly for development, run ``composer install`` to install all your requirements and migrate your database if necessary. *If you did NOT deploy to test prior to running the setup, your setup will complete but show an error message that the migrations have failed. This happens because your dependencies are missing during the setup and which is automatically fixed by running the ``setup.php`` script from above.*

You can now launch your development server by using

.. code-block::

   $ divio project up

which will open your browser with the welcome screen already opened.

If you need to use ``artisan`` or ``composer`` commands you can now either enter your docker container containing your web application or run a command directly like we did with ``setup.php``.

.. code-block::

   # To enter the running container and get a bash session
   $ docker-compose exec web bash

   # To directly run commands in your application
   $ docker-compose run web php artisan migrate

Divio Cloud distinctions
^^^^^^^^^^^^^^^^^^^^^^^^

There are are few minor differences from a default Laravel setup that you should be aware of when starting to develop your application.

The container running your application already contains everything you need for development, there is no need to install additional software. The provided source code is a plain Laravel installation, equal to what you would get by installing Laravel directly via ``composer``. We just added a few scripts that ease interaction with Divio Cloud. They are either located in the root directory or the divio folder. The only package that is installed in addition to a clean Laravel application is ``league/flysystem-aws-s3-v3`` which provides the support for Laravel`s native storage engine.

The biggest difference is the use of your environment variables, which are typically held in a file called ``.env``. This behaviour is slightly different in our setup and uses native environment variables over the ``.env`` file. All credentials needed by your application are automatically injected into your environment and mapped onto the correct environment variables. You therefore don't need to configure anything to run your application in production, everything happens automatically. Of course you might want to override specific values or add configuration options, that are different from the defaults:
For local development you can set the environment variables in ``divio/.env-local``\ , for test and production environments you can either set them in the Divio Cloud web interface or in the ``.env.example`` file. Please make sure you *never* store secrets in this file, because it is added to source control. Only use it to store configuration values. For secrets only use the web interface.
