CREATE DATABASE palmerabike;
\c palmerabike;

CREATE TYPE t_estado AS ENUM('Activo', 'Desactivo');
CREATE TABLE IF NOT EXISTS establecimiento (
    id SERIAL PRIMARY KEY NOT NULL,
    nombre VARCHAR(80) NOT NULL,
    descripcion varchar(150),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS usuario(
    id SERIAL PRIMARY KEY NOT NULL,
    establecimiento_id INT NOT NULL REFERENCES establecimiento(id),
    nombres VARCHAR(10) NOT NULL,
    apellidos VARCHAR(15) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    contraseña VARCHAR(200) NOT NULL,
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
 );

CREATE TABLE IF NOT EXISTS perfil(
    id SERIAL PRIMARY KEY NOT NULL,
    nombre VARCHAR(20) NOT NULL,
    descripcion VARCHAR(150) NOT NULL,
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS usuario_perfil(
    id SERIAL PRIMARY KEY NOT NULL,
    usuario_id INT NOT NULL REFERENCES usuario(id),
    perfil_id INT NOT NULL REFERENCES perfil(id),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sesion(
    id SERIAL PRIMARY KEY NOT NULL,
    usuario_id INT NOT NULL REFERENCES usuario(id),
    fecha_inicio TIMESTAMP,
    fecha_fin TIMESTAMP,
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS rol(
    id SERIAL PRIMARY KEY NOT NULL,
    nombre VARCHAR NOT NULL,
    descripcion VARCHAR NOT NULL,
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS usuario_rol(
    id SERIAL PRIMARY KEY NOT NULL,
    usuario_id INT NOT NULL REFERENCES usuario(id),
    rol_id INT NOT NULL REFERENCES rol(id),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cliente(
    id SERIAL PRIMARY KEY NOT NULL,
    usuario_id INT NOT NULL REFERENCES usuario(id),
    documento INT NOT NULL UNIQUE,
    telefono VARCHAR(15),
    n_celular VARCHAR(15) NOT NULL,
    direccion VARCHAR(30) NOT NULL,
    ciudad VARCHAR(30) NOT NULL,
    pais VARCHAR(30) NOT NULL,
    departamento VARCHAR(30) NOT NULL,
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS categoria(
    id SERIAL PRIMARY KEY NOT NULL,
    nombre VARCHAR(10) NOT NULL,
    descripcion VARCHAR(150),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS subcategoria(
    id SERIAL PRIMARY KEY NOT NULL,
    categoria_id INT NOT NULL REFERENCES categoria(id),
    nombre VARCHAR(10) NOT NULL,
    descripcion VARCHAR(150),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS proveedor (
    id SERIAL PRIMARY KEY NOT NULL,
    identificacion VARCHAR(30) UNIQUE,
    telefono VARCHAR(15),
    email VARCHAR(200) UNIQUE,
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS prod_imagen(
    id SERIAL PRIMARY KEY NOT NULL,
    imagen VARCHAR(200),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS garantia(
    id SERIAL PRIMARY KEY NOT NULL,
    descripcion varchar(500),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP    
);

-- (Balance - p_venta - P_costo)/P_venta  = MArgen de ganancia, porcentake de utilidad

CREATE TABLE IF NOT EXISTS producto(
    id SERIAL PRIMARY KEY NOT NULL,
    categoria_id INT NOT NULL REFERENCES categoria(id),
    proveedor_id INT REFERENCES proveedor(id),
    establecimiento_id INT NOT NULL REFERENCES establecimiento(id),
    garantia_id INT REFERENCES garantia(id),
    nombre VARCHAR(50) NOT NULL,
    p_costo DOUBLE PRECISION NOT NULL CHECK(p_costo > 0),
    p_venta DOUBLE PRECISION NOT NULL CHECK(p_venta > p_costo),
    descripcion VARCHAR(200),
    stock INT NOT NULL CHECK (stock >0),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS imagen_prod(
    id SERIAL PRIMARY KEY NOT NULL,
    producto_id INT NOT NULL REFERENCES producto(id),
    url_imagen VARCHAR(200),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



CREATE TABLE IF NOT EXISTS detalle_producto(
    id SERIAL PRIMARY KEY NOT NULL,
    producto_id INT NOT NULL REFERENCES producto(id),
    marca VARCHAR(25) NOT NULL,
    talla VARCHAR(5),
    color VARCHAR(10),
    referencia VARCHAR(50),
    descripcion VARCHAR(500),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP

);

CREATE TABLE IF NOT EXISTS entrada_producto(
    id SERIAL PRIMARY KEY NOT NULL,
    producto_id INT NOT NULL REFERENCES producto(id),
    f_entrada DATE NOT NULL,
    cantidad INT NOT NULL CHECK(cantidad > 0),
    p_costo DOUBLE PRECISION NOT NULL CHECK(p_costo > 0),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- crear tabla temporar para borrar la factura

CREATE TABLE IF NOT EXISTS anuncio(
    id SERIAL PRIMARY KEY NOT NULL,
    producto_id INT NOT NULL REFERENCES producto(id),
    imagen VARCHAR(200) NOT NULL,
    f_inicio DATE NOT NULL CHECK(f_inicio >= created_at ),
    f_fin DATE NOT NULL CHECK(f_fin >= f_inicio),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP    
);

CREATE TABLE IF NOT EXISTS factura(
    id SERIAL PRIMARY KEY NOT NULL,
    cliente_id INT NOT NULL REFERENCES cliente(id),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS detalle_factura(
    id SERIAL PRIMARY KEY NOT NULL,
    factura_id INT NOT NULL REFERENCES factura(id),
    producto INT NOT NULL REFERENCES producto(id),
    cantidad INT CHECK(cantidad > 0),
    descuento DOUBLE PRECISION CHECK(descuento > 0),
    p_total DOUBLE PRECISION NOT NULL CHECK (p_total >= 0 AND p_total > descuento),
    iva FLOAT NOT NULL CHECK (iva > 0),
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS forma_pago(
    id SERIAL PRIMARY KEY NOT NULL,
    n_pago VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50),
    num_tarjeta INT CHECK (num_tarjeta = 16),
    f_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado t_estado DEFAULT 'Activo',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP   
);


INSERT INTO establecimiento (nombre, descripcion) VALUES ('PalmeraBike', 'sitio de venda de bicicletas en palmira');
INSERT INTO categoria (nombre) VALUES ('bicicletas'), ('componentes'),('accesorios');