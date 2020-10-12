<?php

namespace App\Controladores\Autorizacion;

use App\Controladores\BaseController;
use App\Modelos\Usuario;
use Laminas\Diactoros\Response\RedirectResponse;


class AuthController extends BaseController {

    public function getLogin()
    {
        $respuestaMensaje = $_SESSION['mensaje'] ?? null;
        return $this->renderHTML('Login/login.html',[
            'respuestaMensaje' => $respuestaMensaje
        ]);
    }

    public function postLogin($request){
        $respuestaMensaje = null;
        $postData = $request->getParsedBody();
        $user = Usuario::where('correo', $postData['correo'])->first();
        // $userPerfil = Usuario::where('username', 'tipo_id')->first();
        if($user){
            if(\password_verify($postData['password'], $user->password)){
                if($user->status == 't'){
                    $_SESSION['userID'] = $user->usuario_id;
                    $_SESSION['nombreID'] = $user->nombre;
                    $_SESSION['perfil'] = $user->getTipoArea->nombre; 
                    return new RedirectResponse('');
                    // date_default_timezone_set('America/Bogota');
                    // $date->setTimestamp;
                    // $ultimo_login = $user
                }else{
                    $respuestaMensaje = 'El usuario ha sido desactivado';                    
                }
            }else {
                $respuestaMensaje = 'Nombre ó usuario errados';
            }
        }else{
            $respuestaMensaje = 'Nombre ó usuario errados';
        }

        return $this->renderHTML('login.twig',[
            'respuestaMensaje'=>$respuestaMensaje
        ]);
    }

    public function getLogout(){
        unset($_SESSION['userID']);
        return new RedirectResponse('/palmeraBike/login');
    }


    
}