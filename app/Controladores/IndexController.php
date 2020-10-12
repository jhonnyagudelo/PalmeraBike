<?php

namespace App\Controladores;
use App\Modelos\Categoria;

class IndexController extends BaseController{
    
    public function indexAction() {
        $categorias = Categoria::all();

        return $this->renderHtml('index.html',[
            'categorias' => $categorias,
        ]);
    }

    public function nosotrosAction(){
        return $this->renderHTML('nosotros.html');
    }
}