--   tabla "persona"
CREATE TABLE IF NOT EXISTS persona (
  dni varchar(10),
  nombre varchar(20),
  telefono varchar(9),
  ruc varchar(11)
);

--   tabla "cliente"
CREATE TABLE IF NOT EXISTS cliente (
  dni varchar(10)
);

--   tabla "empleado"
CREATE TABLE IF NOT EXISTS empleado (
  dni varchar(10),
  sueldo float,
  edad integer
);

--   tabla "dia_de_trabajo"
CREATE TABLE IF NOT EXISTS dia_de_trabajo (
  dni varchar(10),
  fecha date,
  hora_entrada time,
  hora_salida time
);

--   tabla "administrador"
CREATE TABLE IF NOT EXISTS administrador (
  dni varchar(10),
  caja_id varchar(10)
);

--   tabla "owner"
CREATE TABLE IF NOT EXISTS owner (
  dni varchar(10),
  caja_id varchar(10)
);

--   tabla "local"
CREATE TABLE IF NOT EXISTS local (
  dni varchar(10),
  direccion varchar(100),
  distrito varchar(25),
  aforo integer,
  telefono varchar(9)
);

--   tabla "caja_registradora"
CREATE TABLE IF NOT EXISTS caja_registradora (
  id_caja varchar(10),
  direccion varchar(100)
);

--   tabla "producto"
CREATE TABLE IF NOT EXISTS producto (
  codigo_barras varchar(100),
  ruc varchar(11),
  familia varchar(100),
  nombre varchar(100),
  precio_compra float,
  precio_venta float
);

--   tabla "almacena"
CREATE TABLE IF NOT EXISTS almacena (
  direccion varchar(100),
  codigo_barras varchar(100),
  stock integer
);

--   tabla "proveedor"
CREATE TABLE IF NOT EXISTS proveedor (
  ruc varchar(11),
  nombre varchar(100),
  telefono varchar(9)
);

--   tabla "compra"
CREATE TABLE IF NOT EXISTS compra (
  dni_cliente varchar(10),
  dni_empleado varchar(10),
  id_caja varchar(10),
  id_compra varchar(10),
  fecha_compra date,
  hora_compra timestamp,
  monto float,
  metodo_pago varchar(50),
  tipo_compra varchar(100)
);

--   tabla "compra_fisica"
CREATE TABLE IF NOT EXISTS compra_fisica (
  id_compra varchar(10)
);

--   tabla "compra_delivery"
CREATE TABLE IF NOT EXISTS compra_delivery (
  id_compra varchar(10),
  direccion_entrega varchar(100),
  fecha_hora_salida timestamp,
  fecha_hora_entrega timestamp
);

--   tabla "compra_encargo"
CREATE TABLE IF NOT EXISTS compra_encargo (
  id_compra varchar(10),
  fecha_hora_recojo timestamp,
  direccion varchar(100)
);

--   tabla "contiene"
CREATE TABLE IF NOT EXISTS contiene (
  cantidad integer,
  id_compra varchar(10),
  codigo_barras varchar(100)
);

--   tabla "trabaja"
CREATE TABLE IF NOT EXISTS trabaja (
  empleado_dni varchar(10),
  direccion varchar(100)
);

 -- Key constraints
 
 -- Persona
ALTER TABLE persona
ADD CONSTRAINT persona_pk PRIMARY KEY (dni);
 -- Proveedor
ALTER TABLE proveedor
ADD CONSTRAINT proveedor_pk PRIMARY KEY (ruc);
 -- Caja Registradora
ALTER TABLE caja_registradora
ADD CONSTRAINT caja_registradora_pk PRIMARY KEY (id_caja);
 -- Persona
ALTER TABLE persona
ADD CONSTRAINT persona_fk_proveedor_ruc FOREIGN KEY (ruc) REFERENCES proveedor(ruc);

-- Tabla Cliente
ALTER TABLE cliente
ADD CONSTRAINT cliente_pk PRIMARY KEY (dni),
ADD CONSTRAINT cliente_fk_persona_dni FOREIGN KEY (dni) REFERENCES persona(dni);

-- Tabla Empleado
ALTER TABLE empleado
ADD CONSTRAINT empleado_pk PRIMARY KEY (dni);

-- Tabla Dia de Trabajo
ALTER TABLE dia_de_trabajo
ADD CONSTRAINT dia_de_trabajo_pk PRIMARY KEY (dni, fecha),
ADD CONSTRAINT dia_de_trabajo_fk_empleado_dni FOREIGN KEY (dni) REFERENCES empleado(dni);

-- Tabla Administrador
ALTER TABLE administrador
ADD CONSTRAINT administrador_pk PRIMARY KEY (dni),
ADD CONSTRAINT administrador_fk_empleado_dni FOREIGN KEY (dni) REFERENCES empleado(dni),
ADD CONSTRAINT administrador_fk_caja_registradora_caja_id FOREIGN KEY (caja_id) REFERENCES caja_registradora(id_caja);

-- Tabla Owner
ALTER TABLE owner
ADD CONSTRAINT owner_pk PRIMARY KEY (dni),
ADD CONSTRAINT owner_fk_empleado_dni FOREIGN KEY (dni) REFERENCES empleado(dni),
ADD CONSTRAINT owner_fk_caja_registradora_caja_id FOREIGN KEY (caja_id) REFERENCES caja_registradora(id_caja);

-- Tabla Local
ALTER TABLE local
ADD CONSTRAINT local_pk PRIMARY KEY (direccion),
ADD CONSTRAINT local_fk_owner_dni FOREIGN KEY (dni) REFERENCES owner(dni);

-- Tabla Caja Registradora
ALTER TABLE caja_registradora
ADD CONSTRAINT caja_registradora_fk_local_direccion FOREIGN KEY (direccion) REFERENCES local(direccion);

-- Tabla Producto
ALTER TABLE producto
ADD CONSTRAINT producto_pk PRIMARY KEY (codigo_barras),
ADD CONSTRAINT producto_fk_proveedor_ruc FOREIGN KEY (ruc) REFERENCES proveedor(ruc);

-- Tabla Almacena
ALTER TABLE almacena
ADD CONSTRAINT almacena_pk PRIMARY KEY (direccion, codigo_barras),
ADD CONSTRAINT almacena_fk_local_direccion FOREIGN KEY (direccion) REFERENCES local(direccion),
ADD CONSTRAINT almacena_fk_producto_codigo_barras FOREIGN KEY (codigo_barras) REFERENCES producto(codigo_barras);

-- Tabla Compra 
ALTER TABLE compra
ADD CONSTRAINT compra_pk PRIMARY KEY (id_compra),
ADD CONSTRAINT compra_fk_persona_cliente_dni FOREIGN KEY (dni_cliente) REFERENCES persona(dni),
ADD CONSTRAINT compra_fk_empleado_dni FOREIGN KEY (dni_empleado) REFERENCES empleado(dni),
ADD CONSTRAINT compra_fk_caja_registradora_id_caja FOREIGN KEY (id_caja) REFERENCES caja_registradora(id_caja);

-- Tabla Compra Fisica
ALTER TABLE compra_fisica
ADD CONSTRAINT compra_fisica_pk PRIMARY KEY (id_compra),
ADD CONSTRAINT compra_fisica_fk_compra_id_compra FOREIGN KEY (id_compra) REFERENCES compra(id_compra);

-- Tabla Compra Delivery
ALTER TABLE compra_delivery
ADD CONSTRAINT compra_delivery_pk PRIMARY KEY (id_compra),
ADD CONSTRAINT compra_delivery_fk_compra_id_compra FOREIGN KEY (id_compra) REFERENCES compra(id_compra);

-- Tabla Compra Encargo
ALTER TABLE compra_encargo
ADD CONSTRAINT compra_encargo_pk PRIMARY KEY (id_compra),
ADD CONSTRAINT compra_encargo_fk_id_compra FOREIGN KEY (id_compra) REFERENCES compra(id_compra),
ADD CONSTRAINT compra_encargo_fk_local_direccion FOREIGN KEY (direccion) REFERENCES local(direccion);

-- Tabla Contiene
ALTER TABLE contiene
ADD CONSTRAINT contiene_pk PRIMARY KEY (id_compra, codigo_barras),
ADD CONSTRAINT contiene_fk_compra_id_compra FOREIGN KEY (id_compra) REFERENCES compra(id_compra),
ADD CONSTRAINT contiene_fk_producto_codigo_barras FOREIGN KEY (codigo_barras) REFERENCES producto(codigo_barras);

-- Tabla Trabaja
ALTER TABLE trabaja
ADD CONSTRAINT trabaja_pk PRIMARY KEY (empleado_dni, direccion),
ADD CONSTRAINT trabaja_fk_empleado_dni FOREIGN KEY (empleado_dni) REFERENCES empleado(dni),
ADD CONSTRAINT trabaja_fk_local_direccion FOREIGN KEY (direccion) REFERENCES local(direccion);

-- ---------------------
-- NOT NULL CONSTRAINTS
-- ---------------------

-- Persona

ALTER TABLE persona ALTER COLUMN nombre SET NOT NULL;

-- Empleado

ALTER TABLE empleado ALTER COLUMN sueldo SET NOT NULL;
ALTER TABLE empleado ALTER COLUMN edad SET NOT NULL;

-- Dia de Trabajo

ALTER TABLE dia_de_trabajo ALTER COLUMN fecha SET NOT NULL;
ALTER TABLE dia_de_trabajo ALTER COLUMN hora_entrada SET NOT NULL;
ALTER TABLE dia_de_trabajo ALTER COLUMN hora_salida SET NOT NULL;

-- Administrador

-- Onwer

-- Local
ALTER TABLE local ALTER COLUMN distrito SET NOT NULL;
ALTER TABLE local ALTER COLUMN aforo  SET NOT NULL;
ALTER TABLE local ALTER COLUMN telefono SET NOT NULL;

-- Caja Registradora

ALTER TABLE caja_registradora ALTER COLUMN direccion SET NOT NULL;


-- Producto

ALTER TABLE producto ALTER COLUMN nombre SET NOT NULL;
ALTER TABLE producto ALTER COLUMN precio_compra SET NOT NULL;
ALTER TABLE producto ALTER COLUMN precio_venta SET NOT NULL;

-- Almacena

ALTER TABLE almacena ALTER COLUMN stock SET NOT NULL;

-- Proveedor

ALTER TABLE proveedor ALTER COLUMN nombre SET NOT NULL;
ALTER TABLE proveedor ALTER COLUMN telefono SET NOT NULL;

-- Compra

ALTER TABLE compra ALTER COLUMN hora_compra SET NOT NULL;
ALTER TABLE compra ALTER COLUMN fecha_compra SET NOT NULL;
ALTER TABLE compra ALTER COLUMN monto  SET NOT NULL;
ALTER TABLE compra ALTER COLUMN metodo_pago SET NOT NULL;
ALTER TABLE compra ALTER COLUMN tipo_compra SET NOT NULL;

-- Compra Delivery
ALTER TABLE compra_delivery ALTER COLUMN direccion_entrega SET NOT NULL;
ALTER TABLE compra_delivery ALTER COLUMN fecha_hora_salida SET NOT NULL;

-- Compra Encargo
ALTER TABLE compra_encargo ALTER COLUMN fecha_hora_recojo SET NOT NULL;
ALTER TABLE compra_encargo ALTER COLUMN direccion SET NOT NULL;

-- Contiene
ALTER TABLE contiene ALTER COLUMN cantidad SET NOT NULL;


-- ----------------
-- MAS CONSTRAINTS 
-- ----------------

-- Tabla empleado
ALTER TABLE empleado
ADD CONSTRAINT empleado_sueldo_positive CHECK (sueldo > 0);

ALTER TABLE empleado
ADD CONSTRAINT empleado_edad_range CHECK (edad BETWEEN 18 AND 65);

-- Tabla dia_de_trabajo
ALTER TABLE dia_de_trabajo
ADD CONSTRAINT dia_de_trabajo_hora_entrada_before_hora_salida CHECK (hora_entrada < hora_salida);

-- Tabla local
ALTER TABLE local
ADD CONSTRAINT local_aforo_positive CHECK (aforo > 0);

ALTER TABLE local
ADD CONSTRAINT local_telefono_format CHECK (telefono ~ '^[0-9]{9}$');

ALTER TABLE local
ADD CONSTRAINT local_telefono_unique UNIQUE (telefono);

-- Tabla producto
ALTER TABLE producto
ADD CONSTRAINT producto_precio_positive CHECK (precio_compra > 0 AND precio_venta > 0);

ALTER TABLE producto
ADD CONSTRAINT producto_precio_valid CHECK (precio_compra <= precio_venta);

-- Tabla almacena
ALTER TABLE almacena
ADD CONSTRAINT almacena_stock_positive CHECK (stock >= 0);

-- Tabla proveedor
ALTER TABLE proveedor
ADD CONSTRAINT proveedor_telefono_unique UNIQUE (telefono);

-- Tabla compra
ALTER TABLE compra
ADD CONSTRAINT compra_monto_positive CHECK (monto >= 0);

ALTER TABLE compra
ADD CONSTRAINT compra_tipo_valid CHECK (tipo_compra IN ('Boleta', 'Factura'));

ALTER TABLE compra
ADD CONSTRAINT compra_metodo_pago_valid CHECK (metodo_pago IN ('Efectivo', 'Yape', 'Visa', 'Mastercard', 'Plin', 'Transferencia'));

-- Tabla compra_delivery
ALTER TABLE compra_delivery
ADD CONSTRAINT compra_delivery_fecha_hora_entrega_gt_salida CHECK (fecha_hora_entrega > fecha_hora_salida);

-- Tabla contiene
ALTER TABLE contiene
ADD CONSTRAINT contiene_cantidad_positive CHECK (cantidad > 0);

------------
-- TRIGGERS 
---------------

CREATE OR REPLACE FUNCTION actualizar_total_compra()
RETURNS TRIGGER AS $$
DECLARE
    stock_local integer;
    direccion_local varchar(100);
    producto_encontrado boolean := false; -- Variable para verificar si el producto se encuentra en el local
BEGIN
    -- Obtener la dirección del local asociado a la compra actual
    SELECT caja_registradora.direccion INTO direccion_local
    FROM caja_registradora
    INNER JOIN compra ON caja_registradora.id_caja = compra.id_caja
    WHERE compra.id_compra = NEW.id_compra; -- Utilizamos el campo id_caja de la nueva compra

    -- Verificar si se encontró la dirección del local para la compra actual
    IF direccion_local IS NOT NULL THEN
        -- Verificar si el producto se encuentra en el local (almacena) de la compra actual
        SELECT almacena.stock INTO stock_local
        FROM almacena
        WHERE almacena.direccion = direccion_local -- Utilizamos la dirección obtenida previamente
            AND almacena.codigo_barras = NEW.codigo_barras;

        -- Verificar si el producto se encontró en el local
        IF FOUND THEN
            producto_encontrado := true;
        END IF;
    ELSE
        -- Si no se encontró la dirección del local, lanzar una excepción
    END IF;

    -- Mostrar mensajes de registro con la información de las variables
    RAISE NOTICE 'direccion_local: %, producto_encontrado: %, stock_local: %', direccion_local, producto_encontrado, stock_local;

    -- Si el producto no se encuentra en el local de la compra, lanzar una excepción
    IF NOT producto_encontrado THEN
        RAISE EXCEPTION 'El producto no se encuentra en el local de la compra';
    END IF;

    -- Actualizar el monto total de la compra solo si el stock es suficiente
    RAISE NOTICE 'stock_local: %, cantidad: %', stock_local, NEW.cantidad;

    IF stock_local >= NEW.cantidad THEN
        -- Actualizar el monto total de la compra en la tabla "compra"
        UPDATE compra
        SET monto = (SELECT SUM(p.precio_venta * c.cantidad)
                     FROM contiene c
                     INNER JOIN producto p ON c.codigo_barras = p.codigo_barras
                     WHERE c.id_compra = NEW.id_compra)
        WHERE id_compra = NEW.id_compra; -- Aseguramos que solo actualice la compra actual

        -- Reducir el stock del producto en el local correspondiente
        UPDATE almacena
        SET stock = stock - NEW.cantidad
        WHERE direccion = direccion_local -- Utilizamos la dirección obtenida previamente
            AND codigo_barras = NEW.codigo_barras; -- Aseguramos que actualice el producto específico

        RETURN NEW; -- Importante: Devolvemos la nueva fila de la tabla "compra" actualizada
    ELSE
        RAISE EXCEPTION 'No hay suficiente stock del producto en el local de la compra';
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;




CREATE TRIGGER actualizacion_compra
AFTER INSERT ON contiene
FOR EACH ROW
EXECUTE FUNCTION actualizar_total_compra();

-- Creación del Trigger
CREATE OR REPLACE FUNCTION generar_dias_trabajo()
RETURNS TRIGGER AS $$
DECLARE
    fecha_inicio date;
    fecha_fin date;
    dia_actual date;
BEGIN
    -- Obtener la fecha de inicio y fin para generar los registros de la semana
    fecha_inicio := CURRENT_DATE;
    fecha_fin := CURRENT_DATE + INTERVAL '6 days';

    dia_actual := fecha_inicio;

    -- Generar 6 registros para los días de trabajo (de lunes a sábado)
    WHILE dia_actual <= fecha_fin LOOP
        INSERT INTO dia_de_trabajo (dni, fecha, hora_entrada, hora_salida)
        VALUES (NEW.empleado_dni, dia_actual, '08:00:00', '17:00:00');

        dia_actual := dia_actual + INTERVAL '1 day';
    END LOOP;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Creación del Trigger que se ejecutará después de insertar en "trabaja"
CREATE TRIGGER generar_dias_trabajo_trigger
AFTER INSERT ON trabaja
FOR EACH ROW
EXECUTE FUNCTION generar_dias_trabajo();




CREATE OR REPLACE FUNCTION agregar_dia_trabajo(dni_empleado_param text, fecha_trabajo_param date, hora_entrada_param time, hora_salida_param time)
RETURNS VOID AS $$
BEGIN
    INSERT INTO dia_de_trabajo (dni, fecha, hora_entrada, hora_salida)
    VALUES (dni_empleado_param, fecha_trabajo_param, hora_entrada_param, hora_salida_param);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION verificar_compra_dia_trabajo()
RETURNS TRIGGER AS $$
DECLARE
    hora_entrada_actual time := '08:00:00';
    hora_salida_actual time := '17:00:00';
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM dia_de_trabajo
        WHERE dni = NEW.dni_empleado AND fecha = NEW.fecha_compra
    ) THEN
        PERFORM agregar_dia_trabajo(NEW.dni_empleado, NEW.fecha_compra, hora_entrada_actual, hora_salida_actual);
    END IF;
    
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER verificar_compra_dia_trabajo_trigger
AFTER INSERT ON compra
FOR EACH ROW
EXECUTE FUNCTION verificar_compra_dia_trabajo();


CREATE SEQUENCE compra_id_compra_seq;
CREATE OR REPLACE FUNCTION generar_id_compra() 
RETURNS VARCHAR(10) AS $$
DECLARE
    next_id VARCHAR(10);
BEGIN
    SELECT LPAD(NEXTVAL('compra_id_compra_seq')::VARCHAR, 10, '0') INTO next_id;
    RETURN next_id;
END;
$$ LANGUAGE plpgsql;
ALTER TABLE compra
    ALTER COLUMN id_compra SET DEFAULT generar_id_compra();





INSERT INTO persona (dni, nombre, telefono, ruc)
VALUES
  ('12345678', 'Juan Pérez', '987654321', NULL),
  ('23456789', 'María Gómez', '987654322', NULL),
  ('34567890', 'Carlos Ramírez', '987654323', NULL),
  ('45678901', 'Ana Torres', '987654324', NULL),
  ('56789012', 'Luis Rodríguez', '987654325', NULL),
  ('67890123', 'Elena Sánchez', '987654326', NULL),
  ('78901234', 'Pedro Gutiérrez', '987654327', NULL),
  ('89012345', 'Laura Mendoza', '987654328', NULL),
  ('90123456', 'Diego Guzmán', '987654329', NULL),
  ('01234567', 'Carla Rivera', '987654330', NULL),
  ('11223344', 'Ricardo López', '987654331', NULL),
  ('22334455', 'Isabel Cordero', '987654332', NULL),
  ('33445566', 'Miguel Montes', '987654333', NULL),
  ('44556677', 'Sofía Medina', '987654334', NULL),
  ('55667788', 'Jorge Rojas', '987654335', NULL),
  ('66778899', 'Paola Vargas', '987654336', NULL),
  ('66777819', 'Juan De la Cruz', '987624136', NULL),
  ('66775809', 'Lucero Vargas', '987654337', NULL);

INSERT INTO empleado (dni, sueldo, edad)
VALUES
  ('12345678', 1500.00, 25),
  ('23456789', 1800.00, 30),
  ('34567890', 2000.00, 28),
  ('45678901', 2200.00, 35),
  ('56789012', 1800.00, 26),
  ('67890123', 1700.00, 29),
  ('78901234', 1900.00, 31),
  ('89012345', 2100.00, 32),
  ('90123456', 1600.00, 27),
  ('01234567', 1750.00, 24),
  ('11223344', 1850.00, 26),
  ('22334455', 1950.00, 28),
  ('33445566', 2050.00, 30),
  ('44556677', 2300.00, 34),
  ('55667788', 2200.00, 33),
  ('66778899', 2400.00, 36),
  ('66777819', 2300.00, 24),
  ('66775809', 2200.00, 20);

INSERT INTO administrador (dni)
VALUES
  ('12345678'), 
  ('23456789'), 
  ('34567890'), 
  ('45678901'); 

INSERT INTO owner (dni)
VALUES
  ('56789012'), 
  ('67890123'); 

INSERT INTO local (dni, direccion, distrito, aforo, telefono) VALUES
('56789012', 'Av. Los Olivos 123', 'Los Olivos', 100, '123456789'),
('67890123', 'Jr. Comas 456', 'Comas', 150, '987654321');

INSERT INTO caja_registradora (id_caja, direccion) VALUES ('1', 'Av. Los Olivos 123');
INSERT INTO caja_registradora (id_caja, direccion) VALUES ('2', 'Av. Los Olivos 123');
INSERT INTO caja_registradora (id_caja, direccion) VALUES ('3', 'Av. Los Olivos 123');
INSERT INTO caja_registradora (id_caja, direccion) VALUES ('4', 'Jr. Comas 456');
INSERT INTO caja_registradora (id_caja, direccion) VALUES ('5', 'Jr. Comas 456');
INSERT INTO caja_registradora (id_caja, direccion) VALUES ('6', 'Jr. Comas 456');


UPDATE administrador
SET caja_id = CASE dni
    WHEN '12345678' THEN '1'
    WHEN '23456789' THEN '2'
    WHEN '34567890' THEN '3'
    WHEN '45678901' THEN '4'
    ELSE caja_id
END;

UPDATE owner
SET caja_id = CASE dni
    WHEN '56789012' THEN '5'
    WHEN '67890123' THEN '6'
    ELSE caja_id
END;



INSERT INTO proveedor (ruc, nombre, telefono)
VALUES
  ('20100123456', 'Alicorp', '016119999'),                       -- 15       
  ('20100234567', 'San Fernando', '016158888'),                  -- 15
  ('20100345678', 'Razzeto', '016227777'),
  ('20100456789', 'Laive', '016336666'),
  ('20100567890', 'Gloria', '016445555'),
  ('20100678901', 'Nestlé', '016554444'),
  ('20100789012', 'Backus (Compañía de Cervecerías Unidas S.A.)', '016663333'),
  ('20100890123', 'Molitalia', '016772222'),
  ('20100901234', 'Primor', '016881111'), 
  ('20607711144', 'Alacena', '016990000'),  
  ('20101123456', 'Aje Group', '017109999'), 
  ('20101234567', 'Panificadora Bimbo del Perú', '017218888'),
  ('20101345678', 'La Iberica', '017327777'),
  ('20201123456', 'Arca Continental Lindley (Coca-Cola)', '017436666'),
  ('20549757830', 'Alpesa', '01-545555'), --- 
  ('20521618605', 'Bells', '017654444'), --
  ('20178065212', 'Industrias Angel S.A.C.', '012640596'),
  ('20536727524', 'Costeño', '017872222'), ---
  ('20101901234', 'Agroindustrias del Sur', '017981111'),
  ('20102012345', 'PepsiCo Alimentos Perú', '018090000');

-- Asignar empleados a los locales
INSERT INTO trabaja (empleado_dni, direccion)
VALUES
  ('12345678', 'Av. Los Olivos 123'), -- Empleado 1 trabaja en el local Av. Los Olivos 123
  ('23456789', 'Av. Los Olivos 123'), -- Empleado 2 trabaja en el local Av. Los Olivos 123
  ('34567890', 'Av. Los Olivos 123'), -- Empleado 3 trabaja en el local Av. Los Olivos 123
  ('45678901', 'Jr. Comas 456'),      -- Empleado 4 trabaja en el local Jr. Comas 456
  ('56789012', 'Jr. Comas 456'),      -- Empleado 5 trabaja en el local Jr. Comas 456
  ('67890123', 'Av. Los Olivos 123'), -- Empleado 6 trabaja en el local Av. Los Olivos 123
  ('78901234', 'Jr. Comas 456'),      -- Empleado 7 trabaja en el local Jr. Comas 456
  ('89012345', 'Av. Los Olivos 123'), -- Empleado 8 trabaja en el local Av. Los Olivos 123
  ('90123456', 'Jr. Comas 456'),      -- Empleado 9 trabaja en el local Jr. Comas 456
  ('01234567', 'Av. Los Olivos 123'), -- Empleado 10 trabaja en el local Av. Los Olivos 123
  ('11223344', 'Jr. Comas 456'),      -- Empleado 11 trabaja en el local Jr. Comas 456
  ('22334455', 'Av. Los Olivos 123'), -- Empleado 12 trabaja en el local Av. Los Olivos 123
  ('33445566', 'Jr. Comas 456'),      -- Empleado 13 trabaja en el local Jr. Comas 456
  ('44556677', 'Av. Los Olivos 123'), -- Empleado 14 trabaja en el local Av. Los Olivos 123
  ('55667788', 'Jr. Comas 456'),      -- Empleado 15 trabaja en el local Jr. Comas 456
  ('66778899', 'Av. Los Olivos 123'), -- Empleado 16 trabaja en el local Av. Los Olivos 123
  ('66777819', 'Jr. Comas 456'),      -- Empleado 17 trabaja en el local Jr. Comas 456
  ('66775809', 'Av. Los Olivos 123'); -- Empleado 18 trabaja en el local Av. Los Olivos 123


INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201001234560', '20100123456', 'Alimentos', 'Leche Evaporada 400ml', 1.50, 2.50),
('201001234561', '20100123456', 'Alimentos', 'Aceite Vegetal 900ml', 3.00, 5.00),
('201001234562', '20100123456', 'Bebidas', 'Agua Mineral 500ml', 0.75, 1.25),
('201001234563', '20100123456', 'Bebidas', 'Gaseosa de Naranja 2L', 1.80, 3.00),
('201001234564', '20100123456', 'Limpieza', 'Detergente Líquido 1L', 2.50, 4.00),
('201001234565', '20100123456', 'Limpieza', 'Jabón de Barra 200g', 1.00, 1.80),
('201001234566', '20100123456', 'Cuidado Personal', 'Shampoo Anticaspa 400ml', 4.00, 6.50),
('201001234567', '20100123456', 'Cuidado Personal', 'Crema Hidratante 200ml', 3.50, 5.50),
('201001234568', '20100123456', 'Abarrotes', 'Arroz Integral 1kg', 2.00, 3.50),
('201001234569', '20100123456', 'Abarrotes', 'Azúcar Blanca 1kg', 1.80, 3.00),
('201001234570', '20100123456', 'Snacks', 'Papas Fritas 150g', 1.20, 2.00),
('201001234571', '20100123456', 'Snacks', 'Galletas de Chocolate 200g', 1.60, 2.80),
('201001234572', '20100123456', 'Lácteos', 'Yogur Natural 150g', 1.00, 1.80),
('201001234573', '20100123456', 'Lácteos', 'Queso Fresco 500g', 3.50, 6.00),
('201001234574', '20100123456', 'Carnes', 'Pollo Entero Fresco', 6.00, 9.00);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201001234560', 80),
('Jr. Comas 456', '201001234560', 50),
('Av. Los Olivos 123', '201001234561', 70),
('Jr. Comas 456', '201001234561', 40),
('Av. Los Olivos 123', '201001234562', 90),
('Jr. Comas 456', '201001234562', 60),
('Av. Los Olivos 123', '201001234563', 75),
('Jr. Comas 456', '201001234563', 45),
('Av. Los Olivos 123', '201001234564', 85),
('Jr. Comas 456', '201001234564', 55),
('Av. Los Olivos 123', '201001234565', 95),
('Jr. Comas 456', '201001234565', 65),
('Av. Los Olivos 123', '201001234566', 100),
('Jr. Comas 456', '201001234566', 70),
('Av. Los Olivos 123', '201001234567', 110),
('Jr. Comas 456', '201001234567', 80),
('Av. Los Olivos 123', '201001234568', 120),
('Jr. Comas 456', '201001234568', 90),
('Av. Los Olivos 123', '201001234569', 130),
('Jr. Comas 456', '201001234569', 95),
('Av. Los Olivos 123', '201001234570', 140),
('Jr. Comas 456', '201001234570', 100),
('Av. Los Olivos 123', '201001234571', 150),
('Jr. Comas 456', '201001234571', 110),
('Av. Los Olivos 123', '201001234572', 160),
('Jr. Comas 456', '201001234572', 120),
('Av. Los Olivos 123', '201001234573', 170),
('Jr. Comas 456', '201001234573', 130),
('Av. Los Olivos 123', '201001234574', 180),
('Jr. Comas 456', '201001234574', 140);

INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201002345670', '20100234567', 'Pollo', 'Pollo Entero Fresco', 5.50, 8.00),
('201002345671', '20100234567', 'Pollo', 'Pechuga de Pollo 1kg', 9.00, 12.00),
('201002345672', '20100234567', 'Pollo', 'Muslos de Pollo 500g', 4.00, 6.50),
('201002345673', '20100234567', 'Pollo', 'Alas de Pollo 400g', 3.50, 5.50),
('201002345674', '20100234567', 'Pollo', 'Hígado de Pollo 300g', 2.50, 4.00),
('201002345675', '20100234567', 'Pavo', 'Pavo Entero Fresco', 6.50, 10.00),
('201002345676', '20100234567', 'Pavo', 'Pechuga de Pavo 800g', 10.00, 15.00),
('201002345677', '20100234567', 'Pavo', 'Muslos de Pavo 500g', 7.50, 12.00),
('201002345678', '20100234567', 'Pavo', 'Hígado de Pavo 400g', 5.00, 8.50),
('201002345679', '20100234567', 'Cerdo', 'Carne de Cerdo 1kg', 8.00, 12.00),
('201002345680', '20100234567', 'Cerdo', 'Chuletas de Cerdo 600g', 9.50, 14.00),
('201002345681', '20100234567', 'Cerdo', 'Lomo de Cerdo 800g', 11.00, 16.00),
('201002345682', '20100234567', 'Huevo', 'Huevos Blancos docena', 3.50, 5.00),
('201002345683', '20100234567', 'Huevo', 'Huevos de Codorniz docena', 4.50, 6.50),
('201002345684', '20100234567', 'Procesados', 'Salchichas 10 unidades', 2.80, 4.50);

-- Asignación del producto 1 (Pollo Entero Fresco)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345670', 70),
('Jr. Comas 456', '201002345670', 30);

-- Asignación del producto 2 (Pechuga de Pollo 1kg)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345671', 50),
('Jr. Comas 456', '201002345671', 25);

-- Asignación del producto 3 (Muslos de Pollo 500g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345672', 40),
('Jr. Comas 456', '201002345672', 20);

-- Asignación del producto 4 (Alas de Pollo 400g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345673', 30),
('Jr. Comas 456', '201002345673', 15);

-- Asignación del producto 5 (Hígado de Pollo 300g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345674', 25),
('Jr. Comas 456', '201002345674', 10);

-- Asignación del producto 6 (Pavo Entero Fresco)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345675', 60),
('Jr. Comas 456', '201002345675', 35);

-- Asignación del producto 7 (Pechuga de Pavo 800g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345676', 45),
('Jr. Comas 456', '201002345676', 25);

-- Asignación del producto 8 (Muslos de Pavo 500g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345677', 35),
('Jr. Comas 456', '201002345677', 15);

-- Asignación del producto 9 (Hígado de Pavo 400g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345678', 30),
('Jr. Comas 456', '201002345678', 10);

-- Asignación del producto 10 (Carne de Cerdo 1kg)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345679', 55),
('Jr. Comas 456', '201002345679', 30);

-- Asignación del producto 11 (Chuletas de Cerdo 600g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345680', 40),
('Jr. Comas 456', '201002345680', 20);

-- Asignación del producto 12 (Lomo de Cerdo 800g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345681', 35),
('Jr. Comas 456', '201002345681', 15);

-- Asignación del producto 13 (Huevos Blancos docena)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345682', 50),
('Jr. Comas 456', '201002345682', 25);

-- Asignación del producto 14 (Huevos de Codorniz docena)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345683', 20),
('Jr. Comas 456', '201002345683', 10);

-- Asignación del producto 15 (Salchichas 10 unidades)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201002345684', 15),
('Jr. Comas 456', '201002345684', 5);


INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201003456780', '20100345678', 'Carne', 'Bistec de Res 1kg', 12.50, 18.00),
('201003456781', '20100345678', 'Carne', 'Chuletas de Cordero 500g', 15.00, 22.00),
('201003456782', '20100345678', 'Pollo', 'Pollo a la Brasa', 10.00, 15.00),
('201003456783', '20100345678', 'Pollo', 'Muslos de Pollo a la Parrilla 400g', 7.50, 12.00),
('201003456784', '20100345678', 'Pavita', 'Pechuga de Pavita 800g', 10.50, 16.00),
('201003456785', '20100345678', 'Pavita', 'Pierna de Pavita 600g', 9.00, 14.00),
('201003456786', '20100345678', 'Cerdo', 'Costillas de Cerdo 1kg', 8.00, 13.00),
('201003456787', '20100345678', 'Cerdo', 'Chuletas de Cerdo 500g', 9.50, 15.00),
('201003456788', '20100345678', 'Embutidos', 'Salchicha Frankfurt 10 unidades', 4.50, 7.00),
('201003456789', '20100345678', 'Embutidos', 'Jamón Serrano 200g', 6.00, 10.00),
('201003456790', '20100345678', 'Embutidos', 'Salame 300g', 5.00, 8.50),
('201003456791', '20100345678', 'Embutidos', 'Longaniza 500g', 7.00, 11.00),
('201003456792', '20100345678', 'Embutidos', 'Chorizo Criollo 400g', 6.50, 10.50),
('201003456793', '20100345678', 'Embutidos', 'Mortadela 250g', 4.50, 7.50),
('201003456794', '20100345678', 'Embutidos', 'Salami Italiano 350g', 6.50, 11.00);


-- Asignación del producto 1 (Bistec de Res 1kg)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456780', 40),
('Jr. Comas 456', '201003456780', 20);

-- Asignación del producto 2 (Chuletas de Cordero 500g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456781', 30),
('Jr. Comas 456', '201003456781', 15);

-- Asignación del producto 3 (Pollo a la Brasa)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456782', 45),
('Jr. Comas 456', '201003456782', 20);

-- Asignación del producto 4 (Muslos de Pollo a la Parrilla 400g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456783', 35),
('Jr. Comas 456', '201003456783', 20);

-- Asignación del producto 5 (Pechuga de Pavita 800g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456784', 30),
('Jr. Comas 456', '201003456784', 15);

-- Asignación del producto 6 (Pierna de Pavita 600g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456785', 25),
('Jr. Comas 456', '201003456785', 10);

-- Asignación del producto 7 (Costillas de Cerdo 1kg)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456786', 40),
('Jr. Comas 456', '201003456786', 20);

-- Asignación del producto 8 (Chuletas de Cerdo 500g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456787', 35),
('Jr. Comas 456', '201003456787', 15);

-- Asignación del producto 9 (Salchicha Frankfurt 10 unidades)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456788', 25),
('Jr. Comas 456', '201003456788', 10);

-- Asignación del producto 10 (Jamón Serrano 200g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456789', 30),
('Jr. Comas 456', '201003456789', 15);

-- Asignación del producto 11 (Salame 300g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456790', 25),
('Jr. Comas 456', '201003456790', 10);

-- Asignación del producto 12 (Longaniza 500g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456791', 35),
('Jr. Comas 456', '201003456791', 15);

-- Asignación del producto 13 (Chorizo Criollo 400g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456792', 30),
('Jr. Comas 456', '201003456792', 15);

-- Asignación del producto 14 (Mortadela 250g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456793', 25),
('Jr. Comas 456', '201003456793', 10);

-- Asignación del producto 15 (Salami Italiano 350g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201003456794', 30),
('Jr. Comas 456', '201003456794', 15);

INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201004567890', '20100456789', 'Mantequilla', 'Mantequilla de Vacuno 200g', 4.50, 7.00),
('201004567891', '20100456789', 'Mantequilla', 'Mantequilla de Maní 250g', 5.00, 8.00),
('201004567892', '20100456789', 'Queso', 'Queso Gouda 300g', 6.50, 10.00),
('201004567893', '20100456789', 'Queso', 'Queso Edam 250g', 6.00, 9.50),
('201004567894', '20100456789', 'Yogur', 'Yogur Natural 500g', 3.50, 6.00),
('201004567895', '20100456789', 'Yogur', 'Yogur de Frutas Variadas 150g', 2.00, 3.50),
('201004567896', '20100456789', 'Leche', 'Leche Descremada 1L', 3.00, 5.00),
('201004567897', '20100456789', 'Leche', 'Leche Entera 1L', 3.20, 5.50),
('201004567898', '20100456789', 'Jugo', 'Jugo de Naranja 500ml', 2.50, 4.00),
('201004567899', '20100456789', 'Jugo', 'Jugo de Manzana 500ml', 2.20, 3.80),
('201004567900', '20100456789', 'Embutidos', 'Salchicha de Pavo 10 unidades', 4.00, 6.50),
('201004567901', '20100456789', 'Embutidos', 'Salchicha de Pollo 10 unidades', 3.80, 6.20),
('201004567902', '20100456789', 'Embutidos', 'Salchicha de Cerdo 10 unidades', 4.20, 6.80),
('201004567903', '20100456789', 'Embutidos', 'Salchicha de Tofu 10 unidades', 4.50, 7.00),
('201004567904', '20100456789', 'Embutidos', 'Chorizo de Pavo 500g', 5.50, 9.00);

-- Asignación del producto 1 (Mantequilla de Vacuno 200g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567890', 25),
('Jr. Comas 456', '201004567890', 30);

-- Asignación del producto 2 (Mantequilla de Maní 250g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567891', 20),
('Jr. Comas 456', '201004567891', 30);

-- Asignación del producto 3 (Queso Gouda 300g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567892', 30),
('Jr. Comas 456', '201004567892', 25);

-- Asignación del producto 4 (Queso Edam 250g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567893', 25),
('Jr. Comas 456', '201004567893', 20);

-- Asignación del producto 5 (Yogur Natural 500g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567894', 40),
('Jr. Comas 456', '201004567894', 35);

-- Asignación del producto 6 (Yogur de Frutas Variadas 150g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567895', 50),
('Jr. Comas 456', '201004567895', 45);

-- Asignación del producto 7 (Leche Descremada 1L)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567896', 30),
('Jr. Comas 456', '201004567896', 25);

-- Asignación del producto 8 (Leche Entera 1L)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567897', 35),
('Jr. Comas 456', '201004567897', 30);

-- Asignación del producto 9 (Jugo de Naranja 500ml)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567898', 40),
('Jr. Comas 456', '201004567898', 35);

-- Asignación del producto 10 (Jugo de Manzana 500ml)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567899', 45),
('Jr. Comas 456', '201004567899', 40);

-- Asignación del producto 11 (Salchicha de Pavo 10 unidades)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567900', 25),
('Jr. Comas 456', '201004567900', 30);

-- Asignación del producto 12 (Salchicha de Pollo 10 unidades)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567901', 30),
('Jr. Comas 456', '201004567901', 35);

-- Asignación del producto 13 (Salchicha de Cerdo 10 unidades)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567902', 20),
('Jr. Comas 456', '201004567902', 25);

-- Asignación del producto 14 (Salchicha de Tofu 10 unidades)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567903', 15),
('Jr. Comas 456', '201004567903', 20);

-- Asignación del producto 15 (Chorizo de Pavo 500g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201004567904', 30),
('Jr. Comas 456', '201004567904', 35);


INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201005678900', '20100567890', 'Abarrotes', 'Arroz Extra 1kg', 3.50, 6.00),
('201005678901', '20100567890', 'Abarrotes', 'Azúcar Blanca 1kg', 2.50, 5.00),
('201005678902', '20100567890', 'Abarrotes', 'Aceite Vegetal 900ml', 4.00, 7.50),
('201005678903', '20100567890', 'Conservas', 'Atún en Agua 150g', 2.00, 4.00),
('201005678904', '20100567890', 'Conservas', 'Champiñones en Conserva 200g', 2.50, 5.00),
('201005678905', '20100567890', 'Chocolates', 'Tableta de Chocolate Amargo 100g', 3.00, 6.00),
('201005678906', '20100567890', 'Chocolates', 'Barra de Chocolate con Leche 80g', 2.50, 5.00),
('201005678907', '20100567890', 'Fideos y Pastas', 'Spaghetti 500g', 2.00, 4.00),
('201005678908', '20100567890', 'Fideos y Pastas', 'Fideo Mostacholes 400g', 1.80, 3.50),
('201005678909', '20100567890', 'Galletas', 'Galletas de Vainilla 200g', 1.50, 3.00),
('201005678910', '20100567890', 'Galletas', 'Galletas de Chocolate 250g', 1.80, 3.50),
('201005678911', '20100567890', 'Golosinas', 'Paquete de Malvaviscos 100g', 1.00, 2.50),
('201005678912', '20100567890', 'Golosinas', 'Chicles Surtidos 50g', 0.80, 2.00),
('201005678913', '20100567890', 'Salsas', 'Salsa de Tomate 400g', 2.00, 4.00),
('201005678914', '20100567890', 'Salsas', 'Salsa de Soja 250ml', 2.50, 5.00);

-- Asignación del producto 1 (Arroz Extra 1kg)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678900', 30),
('Jr. Comas 456', '201005678900', 20);

-- Asignación del producto 2 (Azúcar Blanca 1kg)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678901', 25),
('Jr. Comas 456', '201005678901', 20);

-- Asignación del producto 3 (Aceite Vegetal 900ml)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678902', 35),
('Jr. Comas 456', '201005678902', 30);

-- Asignación del producto 4 (Atún en Agua 150g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678903', 40),
('Jr. Comas 456', '201005678903', 35);

-- Asignación del producto 5 (Champiñones en Conserva 200g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678904', 30),
('Jr. Comas 456', '201005678904', 25);

-- Asignación del producto 6 (Tableta de Chocolate Amargo 100g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678905', 25),
('Jr. Comas 456', '201005678905', 30);

-- Asignación del producto 7 (Barra de Chocolate con Leche 80g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678906', 30),
('Jr. Comas 456', '201005678906', 25);

-- Asignación del producto 8 (Spaghetti 500g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678907', 40),
('Jr. Comas 456', '201005678907', 35);

-- Asignación del producto 9 (Fideo Mostacholes 400g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678908', 25),
('Jr. Comas 456', '201005678908', 30);

-- Asignación del producto 10 (Galletas de Vainilla 200g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678909', 30),
('Jr. Comas 456', '201005678909', 25);

-- Asignación del producto 11 (Galletas de Chocolate 250g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678910', 20),
('Jr. Comas 456', '201005678910', 25);

-- Asignación del producto 12 (Paquete de Malvaviscos 100g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678911', 35),
('Jr. Comas 456', '201005678911', 30);

-- Asignación del producto 13 (Chicles Surtidos 50g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678912', 20),
('Jr. Comas 456', '201005678912', 15);

-- Asignación del producto 14 (Salsa de Tomate 400g)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678913', 40),
('Jr. Comas 456', '201005678913', 35);

-- Asignación del producto 15 (Salsa de Soja 250ml)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201005678914', 30),
('Jr. Comas 456', '201005678914', 25);


-- Creación de 15 productos para Nestlé

-- Alientos para bebés
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789010', '20100678901', 'Alimentos para bebés', 'Leche en polvo para bebés 400g', 10.00, 18.50);

-- Agua embotellada
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789011', '20100678901', 'Agua embotellada', 'Agua mineral natural 500ml', 1.50, 3.00);

-- Cereales
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789012', '20100678901', 'Cereales', 'Cereal de avena con frutas 250g', 4.00, 7.50);

-- Chocolate y confitería
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789013', '20100678901', 'Chocolate y confitería', 'Barra de chocolate con almendras 100g', 3.50, 6.50);

-- Café
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789014', '20100678901', 'Café', 'Café molido tostado 250g', 8.00, 15.00);

-- Gastronomía y cocina
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789015', '20100678901', 'Gastronomía y cocina', 'Salsa de tomate para pasta 500g', 5.00, 9.00);

-- Alimentos refrigerados y congelados
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789016', '20100678901', 'Alimentos refrigerados y congelados', 'Pizza de pepperoni 400g', 7.50, 14.00);

-- Lácteos
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789017', '20100678901', 'Lácteos', 'Yogur natural sin azúcar 200g', 2.00, 4.00);

-- Bebidas
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789018', '20100678901', 'Bebidas', 'Refresco de naranja 500ml', 2.50, 5.00);

-- Servicio de alimentación profesional
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789019', '20100678901', 'Servicio de alimentación profesional', 'Preparado de sopa instantánea 200g', 3.00, 6.00);

-- Nutrición para el cuidado de la salud
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789020', '20100678901', 'Nutrición para el cuidado de la salud', 'Suplemento vitamínico 30 tabletas', 12.00, 22.00);

-- Helados
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789021', '20100678901', 'Helados', 'Helado de vainilla 500ml', 6.50, 12.00);

-- Cuidado de mascotas
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201006789022', '20100678901', 'Cuidado de mascotas', 'Comida para perros raza pequeña 1kg', 9.00, 16.00);

-- Continúa la creación de productos...
-- ...

-- Asignación de productos a locales (con probabilidad del 55%)

-- Producto 1
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789010', 120),
('Jr. Comas 456', '201006789010', 180);

-- Producto 2
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789011', 160),
('Jr. Comas 456', '201006789011', 100);

-- Producto 3
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789012', 100),
('Jr. Comas 456', '201006789012', 130);

-- Producto 4
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789013', 180),
('Jr. Comas 456', '201006789013', 200);

-- Producto 5
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789014', 140),
('Jr. Comas 456', '201006789014', 190);

-- Producto 6
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789015', 200),
('Jr. Comas 456', '201006789015', 100);

-- Producto 7
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789016', 90),
('Jr. Comas 456', '201006789016', 120);

-- Producto 8
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789017', 200),
('Jr. Comas 456', '201006789017', 120);

-- Producto 9
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789018', 120),
('Jr. Comas 456', '201006789018', 200);

-- Producto 10
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789019', 180),
('Jr. Comas 456', '201006789019', 160);

-- Producto 11
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789020', 200),
('Jr. Comas 456', '201006789020', 100);

-- Producto 12
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789021', 110),
('Jr. Comas 456', '201006789021', 140);

-- Producto 13
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201006789022', 150),
('Jr. Comas 456', '201006789022', 90);

-- Continúa la asignación de productos a locales...
-- ...

-- Productos para Backus (Compañía de Cervecerías Unidas S.A.)
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201007890120', '20100789012', 'Bebidas', 'Guaraná 500ml', 1.50, 3.00),
('201007890121', '20100789012', 'Bebidas', 'Maltin Power 500ml', 1.50, 3.00),
('201007890122', '20100789012', 'Bebidas', 'Viva Backus 500ml', 1.50, 3.00),
('201007890123', '20100789012', 'Bebidas', 'Agua Tónica 500ml', 1.50, 3.00),
('201007890124', '20100789012', 'Bebidas', 'Guaraná 1L', 2.50, 5.00),
('201007890125', '20100789012', 'Bebidas', 'Maltin Power 1L', 2.50, 5.00),
('201007890126', '20100789012', 'Bebidas', 'Viva Backus 1L', 2.50, 5.00),
('201007890127', '20100789012', 'Bebidas', 'Agua Tónica 1L', 2.50, 5.00),
('201007890128', '20100789012', 'Bebidas', 'Gaseosa 500ml', 1.80, 3.50),
('201007890129', '20100789012', 'Bebidas', 'Gaseosa 1L', 2.80, 5.50);

-- Asignación de productos a locales con stock variable entre 150 a 270
-- Para simular la asignación, se selecciona aleatoriamente el stock para cada local.

-- Producto 1
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890120', 180),
('Jr. Comas 456', '201007890120', 210);

-- Producto 2
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890121', 200),
('Jr. Comas 456', '201007890121', 170);

-- Producto 3
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890122', 250),
('Jr. Comas 456', '201007890122', 190);

-- Producto 4
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890123', 270),
('Jr. Comas 456', '201007890123', 150);

-- Producto 5
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890124', 220),
('Jr. Comas 456', '201007890124', 240);

-- Producto 6
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890125', 160),
('Jr. Comas 456', '201007890125', 200);

-- Producto 7
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890126', 180),
('Jr. Comas 456', '201007890126', 250);

-- Producto 8
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890127', 210),
('Jr. Comas 456', '201007890127', 190);

-- Producto 9
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890128', 230),
('Jr. Comas 456', '201007890128', 160);

-- Producto 10
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201007890129', 250),
('Jr. Comas 456', '201007890129', 180);


-- Productos para Molitalia
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('201008901230', '20100890123', 'Pastas', 'Espagueti 500g', 2.50, 5.00),
('201008901231', '20100890123', 'Pastas', 'Fideos Tallarín 500g', 2.50, 5.00),
('201008901232', '20100890123', 'Pastas', 'Lasaña 500g', 3.00, 6.00),
('201008901233', '20100890123', 'Salsas', 'Salsa de Tomate 250g', 1.50, 3.00),
('201008901234', '20100890123', 'Salsas', 'Salsa Alfredo 250g', 1.80, 3.50),
('201008901235', '20100890123', 'Salsas', 'Salsa Bolognesa 250g', 2.00, 4.00),
('201008901236', '20100890123', 'Chocolates', 'Tableta de Chocolate 100g', 2.50, 5.00),
('201008901237', '20100890123', 'Chocolates', 'Chocolate Relleno 50g', 1.80, 3.50),
('201008901238', '20100890123', 'Golosinas', 'Gomitas 150g', 1.50, 3.00),
('201008901239', '20100890123', 'Golosinas', 'Paleta de Caramelo 30g', 0.50, 1.00),
('201008901240', '20100890123', 'Cereales', 'Cereal de Maíz 500g', 3.00, 6.00),
('201008901241', '20100890123', 'Cereales', 'Granola 250g', 2.50, 5.00),
('201008901242', '20100890123', 'Mermeladas', 'Mermelada de Fresa 250g', 2.00, 4.00),
('201008901243', '20100890123', 'Mermeladas', 'Mermelada de Piña 250g', 2.00, 4.00),
('201008901244', '20100890123', 'Alimentos para mascotas', 'Comida para Gatos 1kg', 4.50, 9.00);

-- Asignación de productos a locales con stock variable entre 150 y 300
-- Para simular la asignación, se selecciona aleatoriamente el stock para cada local.

-- Producto 1
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901230', 180),
('Jr. Comas 456', '201008901230', 240);

-- Producto 2
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901231', 200),
('Jr. Comas 456', '201008901231', 270);

-- Producto 3
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901232', 160),
('Jr. Comas 456', '201008901232', 250);

-- Producto 4
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901233', 250),
('Jr. Comas 456', '201008901233', 180);

-- Producto 5
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901234', 180),
('Jr. Comas 456', '201008901234', 270);

-- Producto 6
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901235', 200),
('Jr. Comas 456', '201008901235', 150);

-- Producto 7
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901236', 270),
('Jr. Comas 456', '201008901236', 220);

-- Producto 8
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901237', 150),
('Jr. Comas 456', '201008901237', 280);

-- Producto 9
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901238', 290),
('Jr. Comas 456', '201008901238', 200);

-- Producto 10
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901239', 220),
('Jr. Comas 456', '201008901239', 180);

-- Producto 11
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901240', 260),
('Jr. Comas 456', '201008901240', 180);

-- Producto 12
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901241', 180),
('Jr. Comas 456', '201008901241', 240);

-- Producto 13
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901242', 250),
('Jr. Comas 456', '201008901242', 290);

-- Producto 14
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901243', 280),
('Jr. Comas 456', '201008901243', 240);

-- Producto 15
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '201008901244', 190),
('Jr. Comas 456', '201008901244', 270);


-- Insertar productos para el proveedor 'Aje Group' con códigos de barras simulados

-- Producto 1
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234561', '20101123456', 'Bebidas', 'Bio Limonada 500 ml', 2.5, 4.5);

-- Producto 2
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234562', '20101123456', 'Bebidas', 'CIELO Agua 1.5 L', 1.8, 3.0);

-- Producto 3
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234563', '20101123456', 'Bebidas', 'Pulp Mango 1 L', 2.0, 3.5);

-- Producto 4
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234564', '20101123456', 'Bebidas', 'Free Tea Durazno 250 ml', 1.5, 2.8);

-- Producto 5
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234565', '20101123456', 'Bebidas', 'Cifrut Manzana 500 ml', 1.8, 3.2);

-- Producto 6
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234566', '20101123456', 'Bebidas', 'Sporade Naranja 1 L', 2.2, 3.8);

-- Producto 7
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234567', '20101123456', 'Bebidas', 'BIG Cola 2 L', 2.0, 3.5);

-- Producto 8
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234568', '20101123456', 'Bebidas', 'Volt Energética 500 ml', 2.5, 4.0);

-- Producto 9
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234569', '20101123456', 'Bebidas', 'Pulp Piña 1 L', 1.8, 3.2);

-- Producto 10
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234570', '20101123456', 'Bebidas', 'CIELO Agua 500 ml', 1.5, 2.8);

-- Producto 11
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234571', '20101123456', 'Bebidas', 'Bio Limonada 1 L', 2.0, 3.5);

-- Producto 12
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234572', '20101123456', 'Bebidas', 'Sporade Naranja 500 ml', 1.8, 3.2);

-- Producto 13
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234573', '20101123456', 'Bebidas', 'BIG Cola 500 ml', 1.5, 2.8);

-- Producto 14
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234574', '20101123456', 'Bebidas', 'Pulp Mango 500 ml', 1.8, 3.2);

-- Producto 15
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('201011234575', '20101123456', 'Bebidas', 'CIELO Agua 2 L', 2.2, 3.8);

-- Insertar datos en la tabla "almacena" para los productos del proveedor 'Aje Group'

-- Producto 1 - Bio Limonada 500 ml
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234561', 180),
       ('Jr. Comas 456', '201011234561', 250);

-- Producto 2 - CIELO Agua 1.5 L
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234562', 150),
       ('Jr. Comas 456', '201011234562', 220);

-- Producto 3 - Pulp Mango 1 L
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234563', 190),
       ('Jr. Comas 456', '201011234563', 260);

-- Producto 4 - Free Tea Durazno 250 ml
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234564', 130),
       ('Jr. Comas 456', '201011234564', 200);

-- Producto 5 - Cifrut Manzana 500 ml
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234565', 180),
       ('Jr. Comas 456', '201011234565', 250);

-- Producto 6 - Sporade Naranja 1 L
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234566', 210),
       ('Jr. Comas 456', '201011234566', 270);

-- Producto 7 - BIG Cola 2 L
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234567', 240),
       ('Jr. Comas 456', '201011234567', 300);

-- Producto 8 - Volt Energética 500 ml
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234568', 180),
       ('Jr. Comas 456', '201011234568', 240);

-- Producto 9 - Pulp Piña 1 L
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234569', 200),
       ('Jr. Comas 456', '201011234569', 260);

-- Producto 10 - CIELO Agua 500 ml
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234570', 160),
        ('Jr. Comas 456', '201011234570', 220);

-- Producto 11 - Bio Limonada 1 L
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234571', 200),
        ('Jr. Comas 456', '201011234571', 270);

-- Producto 12 - Sporade Naranja 500 ml
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234572', 140),
        ('Jr. Comas 456', '201011234572', 210);

-- Producto 13 - BIG Cola 500 ml
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234573', 160),
        ('Jr. Comas 456', '201011234573', 230);

-- Producto 14 - Pulp Mango 500 ml
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234574', 150),
        ('Jr. Comas 456', '201011234574', 220);

-- Producto 15 - CIELO Agua 2 L
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '201011234575', 230),
        ('Jr. Comas 456', '201011234575', 290);

-- Insertar datos en la tabla "producto" para el proveedor 'Panificadora Bimbo del Perú'

-- Panes de caja
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('2010123456701', '20101234567', 'Panes de caja', 'Pan Blanco 600g', 1.50, 3.00),
       ('2010123456702', '20101234567', 'Panes de caja', 'Pan Integral 600g', 1.80, 3.50),
       ('2010123456703', '20101234567', 'Panes de caja', 'Pan Multigrano 500g', 2.00, 4.00),
       ('2010123456704', '20101234567', 'Panes de caja', 'Pan de Leche 400g', 1.20, 2.50);

-- Bollería
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('2010123456705', '20101234567', 'Bollería', 'Croissant de Chocolate', 2.50, 5.00),
       ('2010123456706', '20101234567', 'Bollería', 'Donas Rellenas', 2.20, 4.50),
       ('2010123456707', '20101234567', 'Bollería', 'Pastelitos Vainilla', 1.80, 3.50);

-- Empanizadores
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('2010123456708', '20101234567', 'Empanizadores', 'Pan Rallado 250g', 1.00, 2.00),
       ('2010123456709', '20101234567', 'Empanizadores', 'Galleta Molida 200g', 1.20, 2.50),
       ('2010123456710', '20101234567', 'Empanizadores', 'Panko 300g', 1.50, 3.00);

-- Snacks Saludables
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('2010123456711', '20101234567', 'Snacks Saludables', 'Chips de Plátano 100g', 1.50, 3.00),
       ('2010123456712', '20101234567', 'Snacks Saludables', 'Palitos de Zanahoria 150g', 1.80, 3.50);

-- Pan Dulce
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('2010123456713', '20101234567', 'Pan Dulce', 'Concha Chocolate', 1.50, 3.00),
       ('2010123456714', '20101234567', 'Pan Dulce', 'Bolillo Relleno Crema', 1.80, 3.50),
       ('2010123456715', '20101234567', 'Pan Dulce', 'Rosquitas de Canela', 1.20, 2.50);

-- Panes Tostados
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES ('2010123456716', '20101234567', 'Panes Tostados', 'Tostadas Integrales', 1.50, 3.00),
       ('2010123456717', '20101234567', 'Panes Tostados', 'Tostadas Multigrano', 1.80, 3.50),
       ('2010123456718', '20101234567', 'Panes Tostados', 'Tostadas con Sésamo', 2.00, 4.00);

-- Insertar datos en la tabla "almacena" con una probabilidad del 55% de que el producto esté en ambos locales

-- Panes de caja
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456701', 250),
       ('Jr. Comas 456', '2010123456701', 180);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456702', 280),
       ('Jr. Comas 456', '2010123456702', 200);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456703', 210),
       ('Jr. Comas 456', '2010123456703', 290);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456704', 180),
       ('Jr. Comas 456', '2010123456704', 260);

-- Bollería
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456705', 190),
       ('Jr. Comas 456', '2010123456705', 270);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456706', 220),
       ('Jr. Comas 456', '2010123456706', 290);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456707', 180),
       ('Jr. Comas 456', '2010123456707', 250);

-- Empanizadores
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456708', 270),
       ('Jr. Comas 456', '2010123456708', 190);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456709', 230),
       ('Jr. Comas 456', '2010123456709', 180);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456710', 250),
       ('Jr. Comas 456', '2010123456710', 210);

-- Snacks Saludables
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456711', 200),
       ('Jr. Comas 456', '2010123456711', 240);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456712', 220),
       ('Jr. Comas 456', '2010123456712', 260);

-- Pan Dulce
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456713', 190),
       ('Jr. Comas 456', '2010123456713', 250);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456714', 250),
       ('Jr. Comas 456', '2010123456714', 180);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456715', 220),
       ('Jr. Comas 456', '2010123456715', 290);

-- Panes Tostados
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456716', 280),
       ('Jr. Comas 456', '2010123456716', 200);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456717', 260),
       ('Jr. Comas 456', '2010123456717', 230);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES ('Av. Los Olivos 123', '2010123456718', 210),
       ('Jr. Comas 456', '2010123456718', 270);


-- Inserción de productos para La Ibérica
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
    ('20101345678001', '20101345678', 'Chocolates', 'Chocolate con leche 50ml', 2.5, 4.5),
    ('20101345678002', '20101345678', 'Chocolates', 'Chocolate negro 70% cacao 100ml', 3.5, 5.5),
    ('20101345678003', '20101345678', 'Chocolates', 'Tableta de chocolate blanco 80ml', 2.8, 4.8),
    ('20101345678004', '20101345678', 'Toffees', 'Toffees surtidos 200ml', 4.2, 6.2),
    ('20101345678005', '20101345678', 'Toffees', 'Toffees de café 150ml', 3.9, 5.9),
    ('20101345678006', '20101345678', 'Turrones', 'Turrón de almendras 250ml', 5.5, 7.5),
    ('20101345678007', '20101345678', 'Turrones', 'Turrón de yema 180ml', 4.8, 6.8),
    ('20101345678008', '20101345678', 'Chocolates', 'Chocolate con leche 100ml', 3.0, 5.0),
    ('20101345678009', '20101345678', 'Chocolates', 'Tableta de chocolate negro 80ml', 2.9, 4.9),
    ('20101345678010', '20101345678', 'Toffees', 'Toffees de frutas 150ml', 3.7, 5.7),
    ('20101345678011', '20101345678', 'Toffees', 'Toffees de mantequilla 200ml', 4.0, 6.0),
    ('20101345678012', '20101345678', 'Turrones', 'Turrón de chocolate 200ml', 4.5, 6.5),
    ('20101345678013', '20101345678', 'Turrones', 'Turrón de nueces 200ml', 5.2, 7.2),
    ('20101345678014', '20101345678', 'Chocolates', 'Tableta de chocolate amargo 80ml', 2.7, 4.7),
    ('20101345678015', '20101345678', 'Chocolates', 'Chocolate con almendras 100ml', 3.2, 5.2);

-- Inserción en la tabla 'almacena'
-- Dirección: Av. Los Olivos 123, Distrito: Los Olivos
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Av. Los Olivos 123', '20101345678001', 230),
    ('Av. Los Olivos 123', '20101345678002', 270),
    ('Av. Los Olivos 123', '20101345678003', 180),
    ('Av. Los Olivos 123', '20101345678004', 250),
    ('Av. Los Olivos 123', '20101345678005', 200),
    ('Av. Los Olivos 123', '20101345678006', 210),
    ('Av. Los Olivos 123', '20101345678007', 180),
    ('Av. Los Olivos 123', '20101345678008', 230),
    ('Av. Los Olivos 123', '20101345678009', 220),
    ('Av. Los Olivos 123', '20101345678010', 240),
    ('Av. Los Olivos 123', '20101345678011', 260),
    ('Av. Los Olivos 123', '20101345678012', 280),
    ('Av. Los Olivos 123', '20101345678013', 230),
    ('Av. Los Olivos 123', '20101345678014', 290),
    ('Av. Los Olivos 123', '20101345678015', 270);

-- Dirección: Jr. Comas 456, Distrito: Comas
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Jr. Comas 456', '20101345678001', 190),
    ('Jr. Comas 456', '20101345678002', 250),
    ('Jr. Comas 456', '20101345678003', 220),
    ('Jr. Comas 456', '20101345678004', 240),
    ('Jr. Comas 456', '20101345678005', 200),
    ('Jr. Comas 456', '20101345678006', 220),
    ('Jr. Comas 456', '20101345678007', 200),
    ('Jr. Comas 456', '20101345678008', 220),
    ('Jr. Comas 456', '20101345678009', 210),
    ('Jr. Comas 456', '20101345678010', 240),
    ('Jr. Comas 456', '20101345678011', 220),
    ('Jr. Comas 456', '20101345678012', 200),
    ('Jr. Comas 456', '20101345678013', 210),
    ('Jr. Comas 456', '20101345678014', 230),
    ('Jr. Comas 456', '20101345678015', 220);

-- Inserción de productos para Arca Continental Lindley (Coca-Cola)
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
    ('20201123456001', '20201123456', 'Bebidas', 'Inca Kola 500ml', 1.8, 3.0),
    ('20201123456002', '20201123456', 'Bebidas', 'Coca-Cola 500ml', 1.5, 2.5),
    ('20201123456003', '20201123456', 'Bebidas', 'Sprite 500ml', 1.3, 2.2),
    ('20201123456004', '20201123456', 'Bebidas', 'Fanta 500ml', 1.3, 2.2),
    ('20201123456005', '20201123456', 'Bebidas', 'Inca Kola Sin Azúcar 500ml', 1.9, 3.2),
    ('20201123456006', '20201123456', 'Bebidas', 'Coca-Cola Sin Azúcar 500ml', 1.6, 2.8),
    ('20201123456007', '20201123456', 'Bebidas', 'Fanta Kola Inglesa 500ml', 1.4, 2.4),
    ('20201123456008', '20201123456', 'Bebidas', 'Inca Kola Power 500ml', 2.0, 3.5),
    ('20201123456009', '20201123456', 'Bebidas', 'Inca Kola 1L', 2.5, 4.0),
    ('20201123456010', '20201123456', 'Bebidas', 'Coca-Cola 1L', 2.2, 3.8),
    ('20201123456011', '20201123456', 'Bebidas', 'Sprite 1L', 2.0, 3.5),
    ('20201123456012', '20201123456', 'Bebidas', 'Fanta 1L', 2.0, 3.5),
    ('20201123456013', '20201123456', 'Bebidas', 'Inca Kola Sin Azúcar 1L', 2.7, 4.5),
    ('20201123456014', '20201123456', 'Bebidas', 'Coca-Cola Sin Azúcar 1L', 2.4, 4.0),
    ('20201123456015', '20201123456', 'Bebidas', 'Fanta Kola Inglesa 1L', 2.2, 3.8);

-- Inserción en la tabla 'almacena'
-- Dirección: Av. Los Olivos 123, Distrito: Los Olivos
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Av. Los Olivos 123', '20201123456001', 280),
    ('Av. Los Olivos 123', '20201123456002', 320),
    ('Av. Los Olivos 123', '20201123456003', 300),
    ('Av. Los Olivos 123', '20201123456004', 290),
    ('Av. Los Olivos 123', '20201123456005', 250),
    ('Av. Los Olivos 123', '20201123456006', 280),
    ('Av. Los Olivos 123', '20201123456007', 270),
    ('Av. Los Olivos 123', '20201123456008', 300),
    ('Av. Los Olivos 123', '20201123456009', 350),
    ('Av. Los Olivos 123', '20201123456010', 320),
    ('Av. Los Olivos 123', '20201123456011', 300),
    ('Av. Los Olivos 123', '20201123456012', 290),
    ('Av. Los Olivos 123', '20201123456013', 250),
    ('Av. Los Olivos 123', '20201123456014', 280),
    ('Av. Los Olivos 123', '20201123456015', 270);


-- Inserción en la tabla 'almacena'
-- Dirección: Av. Comas 456, Distrito: Comas
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Jr. Comas 456', '20201123456001', 220),
    ('Jr. Comas 456', '20201123456002', 250),
    ('Jr. Comas 456', '20201123456003', 240),
    ('Jr. Comas 456', '20201123456004', 230),
    ('Jr. Comas 456', '20201123456005', 200),
    ('Jr. Comas 456', '20201123456006', 220),
    ('Jr. Comas 456', '20201123456007', 210),
    ('Jr. Comas 456', '20201123456008', 240),
    ('Jr. Comas 456', '20201123456009', 270),
    ('Jr. Comas 456', '20201123456010', 250),
    ('Jr. Comas 456', '20201123456011', 240),
    ('Jr. Comas 456', '20201123456012', 230),
    ('Jr. Comas 456', '20201123456013', 200),
    ('Jr. Comas 456', '20201123456014', 220),
    ('Jr. Comas 456', '20201123456015', 210);

-- Inserción en la tabla 'producto'
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
    ('20221123456001', '20178065212', 'Cereales', 'Cereal de Maíz', 3.50, 6.00),
    ('20221123456002', '20178065212', 'Cereales', 'Cereal de Trigo', 3.75, 6.50),
    ('20221123456003', '20178065212', 'Cereales', 'Cereal de Arroz', 2.80, 5.00),
    ('20221123456004', '20178065212', 'Cereales', 'Cereal de Avena', 3.20, 5.80),
    ('20221123456005', '20178065212', 'Cereales', 'Granola con Frutas', 4.50, 8.00),
    ('20221123456006', '20178065212', 'Cereales', 'Cereal Integral', 3.60, 6.20),
    ('20221123456007', '20178065212', 'Cereales', 'Cereal de Centeno', 3.80, 6.50),
    ('20221123456008', '20178065212', 'Cereales', 'Cereal Multigrano', 4.00, 7.00),
    ('20221123456009', '20178065212', 'Cereales', 'Cereal de Quinoa', 4.20, 7.50),
    ('20221123456010', '20178065212', 'Cereales', 'Cereal de Amaranto', 4.00, 7.20),
    ('20221123456011', '20178065212', 'Cereales', 'Cereal de Cebada', 3.50, 6.00),
    ('20221123456012', '20178065212', 'Cereales', 'Cereal de Espelta', 3.90, 6.80),
    ('20221123456013', '20178065212', 'Cereales', 'Cereal de Kamut', 4.30, 7.80),
    ('20221123456014', '20178065212', 'Cereales', 'Cereal de Sorgo', 3.70, 6.50),
    ('20221123456015', '20178065212', 'Cereales', 'Cereal de Trigo Sarraceno', 4.20, 7.50);


-- Inserción en la tabla 'almacena' para el primer local (Av. Los Olivos 123)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Av. Los Olivos 123', '20221123456001', 180),
    ('Av. Los Olivos 123', '20221123456002', 250),
    ('Av. Los Olivos 123', '20221123456003', 200),
    ('Av. Los Olivos 123', '20221123456004', 270),
    ('Av. Los Olivos 123', '20221123456005', 220),
    ('Av. Los Olivos 123', '20221123456006', 190),
    ('Av. Los Olivos 123', '20221123456007', 240),
    ('Av. Los Olivos 123', '20221123456008', 190),
    ('Av. Los Olivos 123', '20221123456009', 280),
    ('Av. Los Olivos 123', '20221123456010', 230),
    ('Av. Los Olivos 123', '20221123456011', 270),
    ('Av. Los Olivos 123', '20221123456012', 200),
    ('Av. Los Olivos 123', '20221123456013', 290),
    ('Av. Los Olivos 123', '20221123456014', 240),
    ('Av. Los Olivos 123', '20221123456015', 180);

-- Inserción en la tabla 'almacena' para el segundo local (Jr. Comas 456)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Jr. Comas 456', '20221123456001', 190),
    ('Jr. Comas 456', '20221123456002', 260),
    ('Jr. Comas 456', '20221123456003', 210),
    ('Jr. Comas 456', '20221123456004', 280),
    ('Jr. Comas 456', '20221123456005', 230),
    ('Jr. Comas 456', '20221123456006', 200),
    ('Jr. Comas 456', '20221123456007', 240),
    ('Jr. Comas 456', '20221123456008', 200),
    ('Jr. Comas 456', '20221123456009', 290),
    ('Jr. Comas 456', '20221123456010', 240),
    ('Jr. Comas 456', '20221123456011', 270),
    ('Jr. Comas 456', '20221123456012', 200),
    ('Jr. Comas 456', '20221123456013', 290),
    ('Jr. Comas 456', '20221123456014', 240),
    ('Jr. Comas 456', '20221123456015', 180);


-- Inserción en la tabla 'producto' para Agroindustrias del Sur
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
    ('20231101901234001', '20101901234', 'Alimentos', 'Quinua Orgánica 500g', 5.50, 10.00),
    ('20231101901234002', '20101901234', 'Alimentos', 'Quinua Orgánica 1kg', 10.00, 18.00),
    ('20231101901234003', '20101901234', 'Alimentos', 'Quinua Orgánica 2kg', 18.00, 32.00),
    ('20231101901234004', '20101901234', 'Alimentos', 'Kiwicha Orgánica 500g', 4.50, 9.00),
    ('20231101901234005', '20101901234', 'Alimentos', 'Kiwicha Orgánica 1kg', 8.50, 15.00),
    ('20231101901234006', '20101901234', 'Alimentos', 'Chía Orgánica 250g', 3.00, 6.50),
    ('20231101901234007', '20101901234', 'Alimentos', 'Chía Orgánica 500g', 5.50, 11.00),
    ('20231101901234008', '20101901234', 'Alimentos', 'Quinua Inorgánica 500g', 4.00, 8.50),
    ('20231101901234009', '20101901234', 'Alimentos', 'Quinua Inorgánica 1kg', 7.50, 14.00),
    ('20231101901234010', '20101901234', 'Alimentos', 'Quinua Inorgánica 2kg', 14.00, 25.00),
    ('20231101901234011', '20101901234', 'Alimentos', 'Kiwicha Inorgánica 500g', 3.50, 7.00),
    ('20231101901234012', '20101901234', 'Alimentos', 'Kiwicha Inorgánica 1kg', 6.50, 12.00),
    ('20231101901234013', '20101901234', 'Alimentos', 'Chía Inorgánica 250g', 2.50, 5.50),
    ('20231101901234014', '20101901234', 'Alimentos', 'Chía Inorgánica 500g', 4.50, 9.00),
    ('20231101901234015', '20101901234', 'Alimentos', 'Mazapanes Variados', 1.50, 3.00),
    ('20231101901234016', '20101901234', 'Alimentos', 'Turrones Surtidos', 3.00, 6.50),
    ('20231101901234017', '20101901234', 'Alimentos', 'Chocolates 70% Cacao', 2.50, 5.50),
    ('20231101901234018', '20101901234', 'Alimentos', 'Chocolates con Almendras', 3.50, 7.00),
    ('20231101901234019', '20101901234', 'Alimentos', 'Granola Premium', 6.00, 12.00),
    ('20231101901234020', '20101901234', 'Alimentos', 'Granola con Frutas', 5.50, 11.00);

-- Inserción de los productos en almacena (Local 1)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Av. Los Olivos 123', '20231101901234001', 180),
    ('Av. Los Olivos 123', '20231101901234002', 200),
    ('Av. Los Olivos 123', '20231101901234003', 220),
    ('Av. Los Olivos 123', '20231101901234004', 190),
    ('Av. Los Olivos 123', '20231101901234005', 210),
    ('Av. Los Olivos 123', '20231101901234006', 170),
    ('Av. Los Olivos 123', '20231101901234007', 230),
    ('Av. Los Olivos 123', '20231101901234008', 240),
    ('Av. Los Olivos 123', '20231101901234009', 260),
    ('Av. Los Olivos 123', '20231101901234010', 280),
    ('Av. Los Olivos 123', '20231101901234011', 300),
    ('Av. Los Olivos 123', '20231101901234012', 190),
    ('Av. Los Olivos 123', '20231101901234013', 220),
    ('Av. Los Olivos 123', '20231101901234014', 210),
    ('Av. Los Olivos 123', '20231101901234015', 270),
    ('Av. Los Olivos 123', '20231101901234016', 180),
    ('Av. Los Olivos 123', '20231101901234017', 250),
    ('Av. Los Olivos 123', '20231101901234018', 230),
    ('Av. Los Olivos 123', '20231101901234019', 240),
    ('Av. Los Olivos 123', '20231101901234020', 260);

-- Inserción de los productos en almacena (Local 2)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Jr. Comas 456', '20231101901234001', 170),
    ('Jr. Comas 456', '20231101901234002', 210),
    ('Jr. Comas 456', '20231101901234003', 230),
    ('Jr. Comas 456', '20231101901234004', 200),
    ('Jr. Comas 456', '20231101901234005', 220),
    ('Jr. Comas 456', '20231101901234006', 190),
    ('Jr. Comas 456', '20231101901234007', 250),
    ('Jr. Comas 456', '20231101901234008', 260),
    ('Jr. Comas 456', '20231101901234009', 280),
    ('Jr. Comas 456', '20231101901234010', 290),
    ('Jr. Comas 456', '20231101901234011', 310),
    ('Jr. Comas 456', '20231101901234012', 200),
    ('Jr. Comas 456', '20231101901234013', 230),
    ('Jr. Comas 456', '20231101901234014', 220),
    ('Jr. Comas 456', '20231101901234015', 280),
    ('Jr. Comas 456', '20231101901234016', 190),
    ('Jr. Comas 456', '20231101901234017', 260),
    ('Jr. Comas 456', '20231101901234018', 240),
    ('Jr. Comas 456', '20231101901234019', 250),
    ('Jr. Comas 456', '20231101901234020', 270);


INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
    ('20102012345001', '20102012345', 'Snacks', 'Doritos Nacho (200g)', 2.50, 4.99),
    ('20102012345002', '20102012345', 'Snacks', 'Doritos Cool Ranch (180g)', 2.30, 4.79),
    ('20102012345003', '20102012345', 'Snacks', 'Doritos Sweet Chili (150g)', 2.00, 3.99),
    ('20102012345004', '20102012345', 'Snacks', 'Cheetos Crunchy (180g)', 2.20, 4.49),
    ('20102012345005', '20102012345', 'Snacks', 'Cheetos Puffs (150g)', 2.10, 3.99),
    ('20102012345006', '20102012345', 'Snacks', 'Fritolay Mix (250g)', 2.80, 5.29),
    ('20102012345007', '20102012345', 'Snacks', 'Fritolay Mix (500g)', 5.00, 8.99),
    ('20102012345008', '20102012345', 'Snacks', 'Doritos Roulette (180g)', 2.40, 4.89),
    ('20102012345009', '20102012345', 'Snacks', 'Cheetos Flamin Hot (180g)' , 2.30, 4.79),
    ('20102012345010', '20102012345', 'Snacks', 'Doritos Incógnita (170g)', 2.10, 3.99),
    ('20102012345011', '20102012345', 'Snacks', 'Cheetos XTRA Flamin Hot (170g)', 2.30, 4.79),
    ('20102012345012', '20102012345', 'Snacks', 'Fritolay Mix XTRA (250g)', 3.00, 5.49),
    ('20102012345013', '20102012345', 'Snacks', 'Doritos Incógnita XTRA (170g)', 2.30, 4.79),
    ('20102012345014', '20102012345', 'Snacks', 'Cheetos XTRA Crunchy (180g)', 2.40, 4.89),
    ('20102012345015', '20102012345', 'Snacks', 'Fritolay Mix XTRA (500g)', 5.50, 9.99),
    ('20102012345016', '20102012345', 'Snacks', 'Doritos Sweet Chili XTRA (150g)', 2.20, 4.49);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Av. Los Olivos 123', '20102012345001', 250),
    ('Av. Los Olivos 123', '20102012345002', 270),
    ('Av. Los Olivos 123', '20102012345003', 220),
    ('Av. Los Olivos 123', '20102012345004', 240),
    ('Av. Los Olivos 123', '20102012345005', 280),
    ('Av. Los Olivos 123', '20102012345006', 300),
    ('Av. Los Olivos 123', '20102012345007', 180),
    ('Av. Los Olivos 123', '20102012345008', 190),
    ('Av. Los Olivos 123', '20102012345009', 230),
    ('Av. Los Olivos 123', '20102012345010', 270),
    ('Av. Los Olivos 123', '20102012345011', 290),
    ('Av. Los Olivos 123', '20102012345012', 220),
    ('Av. Los Olivos 123', '20102012345013', 260),
    ('Av. Los Olivos 123', '20102012345014', 300),
    ('Av. Los Olivos 123', '20102012345015', 250),
    ('Av. Los Olivos 123', '20102012345016', 270);

INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
    ('Jr. Comas 456', '20102012345001', 280),
    ('Jr. Comas 456', '20102012345002', 250),
    ('Jr. Comas 456', '20102012345003', 260),
    ('Jr. Comas 456', '20102012345004', 290),
    ('Jr. Comas 456', '20102012345005', 210),
    ('Jr. Comas 456', '20102012345006', 230),
    ('Jr. Comas 456', '20102012345007', 270),
    ('Jr. Comas 456', '20102012345008', 220),
    ('Jr. Comas 456', '20102012345009', 290),
    ('Jr. Comas 456', '20102012345010', 260),
    ('Jr. Comas 456', '20102012345011', 240),
    ('Jr. Comas 456', '20102012345012', 280),
    ('Jr. Comas 456', '20102012345013', 310),
    ('Jr. Comas 456', '20102012345014', 290),
    ('Jr. Comas 456', '20102012345015', 230),
    ('Jr. Comas 456', '20102012345016', 250);

-- Inserción de productos para Primor
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('20230100901234001', '20100901234', 'Aceites', 'Aceite de Oliva Extra Virgen 500ml', 15.50, 24.99),
('20230100901234002', '20100901234', 'Aceites', 'Aceite de Canola 1L', 12.25, 19.99),
('20230100901234003', '20100901234', 'Aceites', 'Aceite de Girasol Alto Oleico 750ml', 9.75, 15.99),
('20230100901234004', '20100901234', 'Aceites', 'Aceite de Maíz 1L', 11.20, 17.99),
('20230100901234005', '20100901234', 'Aceites', 'Aceite de Soja 500ml', 8.60, 13.99),
('20230100901234006', '20100901234', 'Aceites', 'Aceite de Aguacate 250ml', 14.75, 23.99),
('20230100901234007', '20100901234', 'Aceites', 'Aceite de Almendras 250ml', 17.30, 26.99),
('20230100901234008', '20100901234', 'Aceites', 'Aceite de Semillas de Uva 750ml', 13.90, 21.99),
('20230100901234009', '20100901234', 'Aceites', 'Aceite de Sésamo 500ml', 16.80, 27.99),
('20230100901234010', '20100901234', 'Aceites', 'Aceite de Cacahuate 500ml', 10.70, 17.99),
('20230100901234011', '20100901234', 'Aceites', 'Aceite de Nuez 250ml', 18.40, 29.99),
('20230100901234012', '20100901234', 'Aceites', 'Aceite de Lino 500ml', 12.50, 20.99),
('20230100901234013', '20100901234', 'Aceites', 'Aceite de Ajonjolí 750ml', 14.80, 23.99),
('20230100901234014', '20100901234', 'Aceites', 'Aceite de Canola Orgánico 1L', 17.90, 28.99),
('20230100901234015', '20100901234', 'Aceites', 'Aceite de Coco Orgánico 500ml', 18.80, 29.99);

-- Almacenas para productos de Primor
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '20230100901234001', 200),
('Av. Los Olivos 123', '20230100901234002', 150),
('Av. Los Olivos 123', '20230100901234003', 180),
('Av. Los Olivos 123', '20230100901234004', 160),
('Av. Los Olivos 123', '20230100901234005', 220),
('Av. Los Olivos 123', '20230100901234006', 100),
('Av. Los Olivos 123', '20230100901234007', 120),
('Av. Los Olivos 123', '20230100901234008', 170),
('Av. Los Olivos 123', '20230100901234009', 190),
('Av. Los Olivos 123', '20230100901234010', 140),
('Av. Los Olivos 123', '20230100901234011', 90),
('Av. Los Olivos 123', '20230100901234012', 200),
('Av. Los Olivos 123', '20230100901234013', 110),
('Av. Los Olivos 123', '20230100901234014', 180),
('Av. Los Olivos 123', '20230100901234015', 70);
-- Almacenas para productos de Primor
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Jr. Comas 456', '20230100901234001', 200),
('Jr. Comas 456', '20230100901234002', 150),
('Jr. Comas 456', '20230100901234003', 180),
('Jr. Comas 456', '20230100901234004', 220),
('Jr. Comas 456', '20230100901234005', 100),
('Jr. Comas 456', '20230100901234006', 120),
('Jr. Comas 456', '20230100901234007', 170),
('Jr. Comas 456', '20230100901234008', 190),
('Jr. Comas 456', '20230100901234009', 140),
('Jr. Comas 456', '20230100901234010', 90),
('Jr. Comas 456', '20230100901234011', 200),
('Jr. Comas 456', '20230100901234012', 110),
('Jr. Comas 456', '20230100901234013', 180),
('Jr. Comas 456', '20230100901234014', 70),
('Jr. Comas 456', '20230100901234015', 160);

-- Inserción de productos para Alacena
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('20230607711144001', '20607711144', 'Mayonesas', 'Mayonesa Clásica 400g', 5.80, 9.99),
('20230607711144002', '20607711144', 'Mayonesas', 'Mayonesa Light 250g', 4.50, 7.99),
('20230607711144003', '20607711144', 'Mayonesas', 'Mayonesa de Ajo 350g', 6.20, 10.99),
('20230607711144004', '20607711144', 'Mostazas', 'Mostaza Tradicional 200g', 3.30, 5.99),
('20230607711144005', '20607711144', 'Mostazas', 'Mostaza Dijon 150g', 4.10, 6.99),
('20230607711144006', '20607711144', 'Mostazas', 'Mostaza en Grano 250g', 4.50, 7.99),
('20230607711144007', '20607711144', 'Ketchup', 'Ketchup Clásico 500g', 6.40, 11.99),
('20230607711144008', '20607711144', 'Ketchup', 'Ketchup Picante 350g', 5.70, 9.99),
('20230607711144009', '20607711144', 'Ketchup', 'Ketchup Orgánico 250g', 7.20, 12.99),
('20230607711144010', '20607711144', 'Ají Criollo', 'Ají Criollo en Pasta 300g', 5.50, 9.99),
('20230607711144011', '20607711144', 'Ají Criollo', 'Ají Criollo en Crema 200g', 4.90, 8.99),
('20230607711144012', '20607711144', 'Ají Criollo', 'Ají Amarillo en Pasta 350g', 6.20, 10.99),
('20230607711144013', '20607711144', 'Vinagretas', 'Vinagreta Balsámica 250ml', 8.80, 15.99),
('20230607711144014', '20607711144', 'Vinagretas', 'Vinagreta de Frambuesa 200ml', 9.30, 16.99),
('20230607711144015', '20607711144', 'Vinagretas', 'Vinagreta de Mostaza y Miel 300ml', 7.50, 13.99);

-- Almacenas para productos de Alacena
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Jr. Comas 456', '20230607711144001', 250),
('Jr. Comas 456', '20230607711144002', 180),
('Jr. Comas 456', '20230607711144003', 200),
('Jr. Comas 456', '20230607711144004', 300),
('Jr. Comas 456', '20230607711144005', 220),
('Jr. Comas 456', '20230607711144006', 180),
('Jr. Comas 456', '20230607711144007', 160),
('Jr. Comas 456', '20230607711144008', 190),
('Jr. Comas 456', '20230607711144009', 210),
('Jr. Comas 456', '20230607711144010', 230),
('Jr. Comas 456', '20230607711144011', 170),
('Jr. Comas 456', '20230607711144012', 200),
('Jr. Comas 456', '20230607711144013', 140),
('Jr. Comas 456', '20230607711144014', 180),
('Jr. Comas 456', '20230607711144015', 200);

-- Almacenas para productos de Alacena
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '20230607711144001', 250),
('Av. Los Olivos 123', '20230607711144002', 180),
('Av. Los Olivos 123', '20230607711144003', 200),
('Av. Los Olivos 123', '20230607711144004', 300),
('Av. Los Olivos 123', '20230607711144005', 220),
('Av. Los Olivos 123', '20230607711144006', 180),
('Av. Los Olivos 123', '20230607711144007', 160),
('Av. Los Olivos 123', '20230607711144008', 190),
('Av. Los Olivos 123', '20230607711144009', 210),
('Av. Los Olivos 123', '20230607711144010', 230),
('Av. Los Olivos 123', '20230607711144011', 170),
('Av. Los Olivos 123', '20230607711144012', 200),
('Av. Los Olivos 123', '20230607711144013', 140),
('Av. Los Olivos 123', '20230607711144014', 180),
('Av. Los Olivos 123', '20230607711144015', 200);




-- Productos para Alpesa
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('202411205497578301', '20549757830', 'Condimentos', 'Mayonesa en Balde 5kg', 25.00, 40.00),
('202411205497578302', '20549757830', 'Condimentos', 'Mayonesa Sachet 10g', 0.50, 1.00),
('202411205497578303', '20549757830', 'Condimentos', 'Mostaza en Balde 5kg', 20.00, 35.00),
('202411205497578304', '20549757830', 'Condimentos', 'Mostaza Sachet 10g', 0.40, 0.80),
('202411205497578305', '20549757830', 'Condimentos', 'Ketchup en Balde 5kg', 22.00, 38.00),
('202411205497578306', '20549757830', 'Condimentos', 'Ketchup Sachet 10g', 0.45, 0.90),
('202411205497578307', '20549757830', 'Condimentos', 'Vinagreta en Balde 5kg', 28.00, 45.00),
('202411205497578308', '20549757830', 'Condimentos', 'Vinagreta Sachet 10g', 0.55, 1.10),
('202411205497578309', '20549757830', 'Condimentos', 'Aceite en Balde 5kg', 30.00, 50.00),
('202411205497578310', '20549757830', 'Condimentos', 'Aceite Sachet 10g', 0.60, 1.20),
('202411205497578311', '20549757830', 'Condimentos', 'Salsa de Soja en Balde 5kg', 35.00, 60.00),
('202411205497578312', '20549757830', 'Condimentos', 'Salsa de Soja Sachet 10g', 0.70, 1.40),
('202411205497578313', '20549757830', 'Condimentos', 'Salsa BBQ en Balde 5kg', 40.00, 70.00),
('202411205497578314', '20549757830', 'Condimentos', 'Salsa BBQ Sachet 10g', 0.75, 1.50),
('202411205497578315', '20549757830', 'Condimentos', 'Miel en Balde 5kg', 45.00, 80.00);



-- Productos para Bells
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('202412205216186051', '20521618605', 'Cereales', 'Arroz 1kg', 5.00, 8.00),
('202412205216186052', '20521618605', 'Cereales', 'Arroz 5kg', 20.00, 30.00),
('202412205216186053', '20521618605', 'Cereales', 'Lentejas 1kg', 8.00, 12.00),
('202412205216186054', '20521618605', 'Cereales', 'Lentejas 5kg', 35.00, 50.00),
('202412205216186055', '20521618605', 'Conservas', 'Atún en Lata', 6.00, 10.00),
('202412205216186056', '20521618605', 'Conservas', 'Atún en Conserva', 5.00, 8.00),
('202412205216186057', '20521618605', 'Condimentos', 'Sal 1kg', 2.50, 4.00),
('202412205216186058', '20521618605', 'Condimentos', 'Sal 5kg', 10.00, 15.00),
('202412205216186059', '20521618605', 'Condimentos', 'Azúcar 1kg', 3.00, 5.00),
('202412205216186060', '20521618605', 'Condimentos', 'Azúcar 5kg', 12.00, 18.00),
('202412205216186061', '20521618605', 'Condimentos', 'Pimienta 100g', 4.50, 7.00),
('202412205216186062', '20521618605', 'Condimentos', 'Comino 100g', 5.00, 8.00),
('202412205216186063', '20521618605', 'Aceites', 'Aceite Vegetal 1L', 7.00, 12.00),
('202412205216186064', '20521618605', 'Aceites', 'Aceite Vegetal 5L', 30.00, 50.00),
('202412205216186065', '20521618605', 'Aceites', 'Aceite de Oliva 500ml', 10.00, 18.00);


-- Productos para Costeño
INSERT INTO producto (codigo_barras, ruc, familia, nombre, precio_compra, precio_venta)
VALUES
('202413205367275241', '20536727524', 'Cereales', 'Arroz 1kg', 4.00, 7.00),
('202413205367275242', '20536727524', 'Cereales', 'Arroz 5kg', 18.00, 25.00),
('202413205367275243', '20536727524', 'Condimentos', 'Sal 1kg', 2.00, 4.00),
('202413205367275244', '20536727524', 'Condimentos', 'Sal 5kg', 8.00, 12.00),
('202413205367275245', '20536727524', 'Condimentos', 'Azúcar 1kg', 2.50, 5.00),
('202413205367275246', '20536727524', 'Condimentos', 'Azúcar 5kg', 10.00, 15.00),
('202413205367275247', '20536727524', 'Condimentos', 'Pimienta 100g', 4.00, 7.00),
('202413205367275248', '20536727524', 'Condimentos', 'Comino 100g', 5.50, 9.00),
('202413205367275249', '20536727524', 'Harinas', 'Harina de Trigo 1kg', 3.50, 6.00),
('202413205367275250', '20536727524', 'Harinas', 'Harina de Trigo 5kg', 15.00, 25.00),
('202413205367275251', '20536727524', 'Harinas', 'Harina de Maíz 1kg', 3.00, 5.50),
('202413205367275252', '20536727524', 'Harinas', 'Harina de Maíz 5kg', 13.00, 22.00),
('202413205367275253', '20536727524', 'Aceites', 'Aceite Vegetal 1L', 6.00, 10.00),
('202413205367275254', '20536727524', 'Aceites', 'Aceite Vegetal 5L', 25.00, 40.00),
('202413205367275255', '20536727524', 'Aceites', 'Aceite de Girasol 1L', 7.00, 12.00);

-- Almacena para Alpesa (Local 1)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '202411205497578301', 150),
('Av. Los Olivos 123', '202411205497578302', 200),
('Av. Los Olivos 123', '202411205497578303', 120),
('Av. Los Olivos 123', '202411205497578304', 180),
('Av. Los Olivos 123', '202411205497578305', 250),
('Av. Los Olivos 123', '202411205497578306', 100),
('Av. Los Olivos 123', '202411205497578307', 80),
('Av. Los Olivos 123', '202411205497578308', 60),
('Av. Los Olivos 123', '202411205497578309', 40),
('Av. Los Olivos 123', '202411205497578310', 90),
('Av. Los Olivos 123', '202411205497578311', 70),
('Av. Los Olivos 123', '202411205497578312', 200),
('Av. Los Olivos 123', '202411205497578313', 150),
('Av. Los Olivos 123', '202411205497578314', 100),
('Av. Los Olivos 123', '202411205497578315', 80);

-- Almacena para Alpesa (Local 2)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Jr. Comas 456', '202411205497578301', 220),
('Jr. Comas 456', '202411205497578302', 150),
('Jr. Comas 456', '202411205497578303', 200),
('Jr. Comas 456', '202411205497578304', 280),
('Jr. Comas 456', '202411205497578305', 120),
('Jr. Comas 456', '202411205497578306', 90),
('Jr. Comas 456', '202411205497578307', 70),
('Jr. Comas 456', '202411205497578308', 50),
('Jr. Comas 456', '202411205497578309', 100),
('Jr. Comas 456', '202411205497578310', 80),
('Jr. Comas 456', '202411205497578311', 220),
('Jr. Comas 456', '202411205497578312', 180),
('Jr. Comas 456', '202411205497578313', 120),
('Jr. Comas 456', '202411205497578314', 100),
('Jr. Comas 456', '202411205497578315', 150);

-- Almacena para Bells (Local 1)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '202412205216186051', 200),
('Av. Los Olivos 123', '202412205216186052', 120),
('Av. Los Olivos 123', '202412205216186053', 180),
('Av. Los Olivos 123', '202412205216186054', 250),
('Av. Los Olivos 123', '202412205216186055', 100),
('Av. Los Olivos 123', '202412205216186056', 80),
('Av. Los Olivos 123', '202412205216186057', 60),
('Av. Los Olivos 123', '202412205216186058', 40),
('Av. Los Olivos 123', '202412205216186059', 90),
('Av. Los Olivos 123', '202412205216186060', 70),
('Av. Los Olivos 123', '202412205216186061', 200),
('Av. Los Olivos 123', '202412205216186062', 150),
('Av. Los Olivos 123', '202412205216186063', 100),
('Av. Los Olivos 123', '202412205216186064', 80),
('Av. Los Olivos 123', '202412205216186065', 120);

-- Almacena para Bells (Local 2)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Jr. Comas 456', '202412205216186051', 220),
('Jr. Comas 456', '202412205216186052', 150),
('Jr. Comas 456', '202412205216186053', 200),
('Jr. Comas 456', '202412205216186054', 280),
('Jr. Comas 456', '202412205216186055', 120),
('Jr. Comas 456', '202412205216186056', 90),
('Jr. Comas 456', '202412205216186057', 70),
('Jr. Comas 456', '202412205216186058', 50),
('Jr. Comas 456', '202412205216186059', 100),
('Jr. Comas 456', '202412205216186060', 80),
('Jr. Comas 456', '202412205216186061', 220),
('Jr. Comas 456', '202412205216186062', 180),
('Jr. Comas 456', '202412205216186063', 120),
('Jr. Comas 456', '202412205216186064', 100),
('Jr. Comas 456', '202412205216186065', 150);

-- Almacena para Costeño (Local 1)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Av. Los Olivos 123', '202413205367275241', 200),
('Av. Los Olivos 123', '202413205367275242', 120),
('Av. Los Olivos 123', '202413205367275243', 180),
('Av. Los Olivos 123', '202413205367275244', 250),
('Av. Los Olivos 123', '202413205367275245', 100),
('Av. Los Olivos 123', '202413205367275246', 80),
('Av. Los Olivos 123', '202413205367275247', 60),
('Av. Los Olivos 123', '202413205367275248', 40),
('Av. Los Olivos 123', '202413205367275249', 90),
('Av. Los Olivos 123', '202413205367275250', 70),
('Av. Los Olivos 123', '202413205367275251', 200),
('Av. Los Olivos 123', '202413205367275252', 150),
('Av. Los Olivos 123', '202413205367275253', 100),
('Av. Los Olivos 123', '202413205367275254', 80),
('Av. Los Olivos 123', '202413205367275255', 120);

-- Almacena para Costeño (Local 2)
INSERT INTO almacena (direccion, codigo_barras, stock)
VALUES
('Jr. Comas 456', '202413205367275241', 220),
('Jr. Comas 456', '202413205367275242', 150),
('Jr. Comas 456', '202413205367275243', 200),
('Jr. Comas 456', '202413205367275244', 280),
('Jr. Comas 456', '202413205367275245', 120),
('Jr. Comas 456', '202413205367275246', 90),
('Jr. Comas 456', '202413205367275247', 70),
('Jr. Comas 456', '202413205367275248', 50),
('Jr. Comas 456', '202413205367275249', 100),
('Jr. Comas 456', '202413205367275250', 80),
('Jr. Comas 456', '202413205367275251', 220),
('Jr. Comas 456', '202413205367275252', 180),
('Jr. Comas 456', '202413205367275253', 120),
('Jr. Comas 456', '202413205367275254', 100),
('Jr. Comas 456', '202413205367275255', 150);




UPDATE almacena
SET stock = stock * 10;



