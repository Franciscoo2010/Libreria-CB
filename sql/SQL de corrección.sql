USE libreriadb_in4cm;

-- 1. Corregir errores tipográficos en nombres de columnas
ALTER TABLE editoriales 
CHANGE COLUMN direccion_editoria direccion_editorial VARCHAR(100);

-- 2. Asegurar campos obligatorios y unicos
ALTER TABLE categorias 
MODIFY COLUMN nombre_categoria VARCHAR(100) NOT NULL,
ADD CONSTRAINT uq_nombre_categoria UNIQUE (nombre_categoria);

ALTER TABLE clientes 
MODIFY COLUMN nombre_cliente VARCHAR(100) NOT NULL,
MODIFY COLUMN apellido_cliente VARCHAR(100) NOT NULL,
MODIFY COLUMN correo_electronico VARCHAR(100) NOT NULL,
ADD CONSTRAINT uq_correo_cliente UNIQUE (correo_electronico);

-- 3. Rediseño del detalle de compra (Cantidad y Precio Histórico al momento de la venta)
ALTER TABLE detalle_compra 
ADD COLUMN cantidad INT NOT NULL DEFAULT 1,
ADD COLUMN precio_unitario DECIMAL(8,2) NOT NULL DEFAULT 0.00;

-- 4. Optimización con Índices para Joins y búsquedas frecuentes
CREATE INDEX idx_libros_titulo ON libros(titulo);
CREATE INDEX idx_libros_categoria ON libros(id_categoria);
CREATE INDEX idx_libros_editorial ON libros(nit_editorial);
CREATE INDEX idx_compras_cliente ON compras(cui_cliente);
CREATE INDEX idx_detalle_compra_compra ON detalle_compra(no_compra);
CREATE INDEX idx_detalle_compra_libro ON detalle_compra(isbn);

-- 5. Actualización de procedimientos y vistas afectados por el cambio de columna
DROP PROCEDURE IF EXISTS sp_insertareditorial;
DELIMITER $$
CREATE PROCEDURE sp_insertareditorial(
    IN _nit VARCHAR(20),
    IN _nombre_editorial VARCHAR(100),
    IN _telefono_editorial VARCHAR(15),
    IN _direccion_editorial VARCHAR(100)
)
BEGIN
    INSERT INTO editoriales(nit, nombre_editorial, telefono_editorial, direccion_editorial) 
    VALUES (_nit, _nombre_editorial, _telefono_editorial, _direccion_editorial);
END $$
DELIMITER ;

CREATE OR REPLACE VIEW vw_lista_editoriales AS
SELECT 
    nit AS 'nit editorial',
    nombre_editorial AS 'editorial',
    telefono_editorial AS 'teléfono',
    direccion_editorial AS 'dirección'
FROM editoriales;