<?php

ini_set('display_errors', 1); //inicializa errores
ini_set('display_starup_error', 1); //inicializa errores
error_reporting(E_ALL); //mostrar errores en pantalla

require_once '../vendor/autoload.php';


session_start();


use Illuminate\Database\Capsule\Manager as Capsule;
use Aura\Router\RouterContainer;


$capsule = new Capsule;

$capsule->addConnection([
    'driver'    => 'pgsql',
    'host'      => 'localhost',
    'database'  => 'palmeraBike',
    'username'  => 'postgres',
    'password'  => '1113645020',
    'charset'   => 'utf8',
    'collation' => 'utf8_unicode_ci',
    'prefix'    => '',
]);

// Make this Capsule instance available globally via static methods... (optional)
$capsule->setAsGlobal();

// Setup the Eloquent ORM... (optional; unless you've used setEventDispatcher())
$capsule->bootEloquent();


$response = Laminas\Diactoros\ServerRequestFactory::fromGlobals(
    $_SERVER,
    $_GET,
    $_POST,
    $_COOKIE,
    $_FILES
);

$routerContainer = new RouterContainer();
$map = $routerContainer->getMap();

$map->get('index', '/palmeraBike/', [
    'control' => 'App\Controladores\IndexController',
    'accion' => 'indexAction'
]);
$map->get('logout', '/palmeraBike/Logout', [
    'control' => 'App\Controladores\Autorizacion\AuthController',
    'accion' => 'getLogin'
]);
$map->get('nosotros', '/palmeraBike/nosotros',[
    'control' => 'App\controladores\indexController',
    'accion' => 'nosotrosAction'
]);

$map->get('contacto', '/palmeraBike/contacto',[
    'control' => 'App\Controladores\Backend\ContactoController',
    'accion' => 'getContacto'

]);




$matcher = $routerContainer->getMatcher();
$route = $matcher->match($response);
if(!$route) {
    echo 'No Route';
}else {
    $handlerData =  $route->handler;
    $nombreControl = $handlerData['control'];
    $actionName = $handlerData['accion'];

    $control =  new $nombreControl;
    $response = $control->$actionName();

    echo $response->getBody();
}
