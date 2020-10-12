<?php

namespace App\Controladores\Backend;

use App\Controladores\BaseController;

class ContactoController extends BaseController {
    public function getContacto() {
    return $this->renderHTML('Contacto/contactenos.html',[

    ]);
    }
}