-- 📄 3. Inserción de Datos (insert.sql)

INSERT INTO categorias (nombre, descripcion) VALUES
('Laptops', 'Computadoras portátiles de diferentes marcas y especificaciones'),
('Teléfonos', 'Smartphones y teléfonos móviles'),
('Componentes', 'Componentes para computadoras y dispositivos'),
('Periféricos', 'Teclados, ratones, monitores y otros accesorios'),
('Audio', 'Audífonos, parlantes y equipos de sonido');

INSERT INTO proveedores (nombre, contacto, telefono, email, direccion) VALUES
('TecnoSuministros', 'Juan Pérez', '555-1001', 'juan@tecnosuministros.com', 'Av. Tecnológica 123'),
('ElectroParts', 'María Gómez', '555-1002', 'maria@electroparts.com', 'Calle Circuito 456'),
('GadgetMasters', 'Carlos Ruiz', '555-1003', 'carlos@gadgetmasters.com', 'Boulevard Digital 789'),
('CompuGlobal', 'Laura Díaz', '555-1004', 'laura@compuglobal.com', 'Calle Byte 101'),
('TechImport', 'Roberto Sánchez', '555-1005', 'roberto@techimport.com', 'Av. Innovación 202');


INSERT INTO productos (nombre, descripcion, precio, categoria_id, proveedor_id) VALUES
('Laptop HP EliteBook', 'Core i7, 16GB RAM, 512GB SSD', 1200.00, 1, 1),
('Laptop Dell XPS 13', 'Core i5, 8GB RAM, 256GB SSD', 999.99, 1, 2),
('iPhone 14 Pro', '128GB, Pantalla Super Retina XDR', 1099.00, 2, 3),
('Samsung Galaxy S23', '256GB, 8GB RAM, Cámara 108MP', 899.00, 2, 4),
('Teclado Mecánico RGB', 'Switches Red, Retroiluminación RGB', 89.99, 4, 5),
('Mouse Inalámbrico', '2400DPI, 6 botones, ergonómico', 29.99, 4, 1),
('Monitor 24" Full HD', '1920x1080, 75Hz, IPS', 159.00, 4, 2),
('Disco SSD 1TB', 'NVMe, Velocidad 3500MB/s', 99.99, 3, 3),
('Memoria RAM 16GB', 'DDR4, 3200MHz', 59.99, 3, 4),
('Audífonos Bluetooth', 'Cancelación de ruido, 30h batería', 129.99, 5, 5),
('Parlante JBL', 'Portátil, resistente al agua', 79.99, 5, 1),
('Tarjeta Gráfica RTX 3060', '12GB GDDR6, 3 ventiladores', 399.00, 3, 2),
('Tablet Samsung Galaxy Tab', '10.4", 64GB, LTE', 249.00, 2, 3),
('Cargador USB-C 65W', 'Carga rápida, compatible con múltiples dispositivos', 29.99, 4, 4),
('Webcam 4K', 'Resolución UHD, micrófono integrado', 89.99, 4, 5),
('Router WiFi 6', 'Doble banda, 3000Mbps', 129.00, 3, 1),
('Impresora Multifuncional', 'Imprime, escanea, copia', 149.99, 4, 2);


INSERT INTO clientes (nombre, email, telefono, direccion) VALUES
('Ana Martínez', 'ana.martinez@email.com', '555-2001', 'Calle Primavera 123'),
('Luis Rodríguez', 'luis.rodriguez@email.com', '555-2002', 'Av. Libertad 456'),
('Marta Sánchez', 'marta.sanchez@email.com', '555-2003', 'Boulevard Flores 789'),
('Jorge Fernández', 'jorge.fernandez@email.com', '555-2004', 'Calle Roble 101'),
('Carmen López', 'carmen.lopez@email.com', '555-2005', 'Av. Central 202'),
('David González', 'david.gonzalez@email.com', '555-2006', 'Calle Luna 303'),
('Sofía Ramírez', 'sofia.ramirez@email.com', '555-2007', 'Boulevard Sol 404'),
('Pedro Cruz', 'pedro.cruz@email.com', '555-2008', 'Av. Norte 505'),
('Elena Morales', 'elena.morales@email.com', '555-2009', 'Calle Sur 606'),
('Ricardo Vargas', 'ricardo.vargas@email.com', '555-2010', 'Boulevard Este 707'),
('Patricia Castro', 'patricia.castro@email.com', '555-2011', 'Av. Oeste 808'),
('Francisco Ortega', 'francisco.ortega@email.com', '555-2012', 'Calle Arcoiris 909'),
('Isabel Reyes', 'isabel.reyes@email.com', '555-2013', 'Boulevard Universo 1010'),
('Manuel Herrera', 'manuel.herrera@email.com', '555-2014', 'Av. Galaxia 1111'),
('Lucía Mendoza', 'lucia.mendoza@email.com', '555-2015', 'Calle Estrella 1212');


INSERT INTO ventas (cliente_id, fecha_venta, total) VALUES
(1, '2023-10-15 10:30:00', 1299.99),
(3, '2023-10-16 14:15:00', 189.98),
(5, '2023-10-17 11:45:00', 399.00),
(2, '2023-10-18 16:20:00', 1099.00),
(4, '2023-10-19 09:10:00', 248.99);

INSERT INTO detalles_venta (venta_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 1200.00),  
(1, 5, 1, 89.99),    
(1, 6, 1, 29.99),    
(1, 7, 1, 159.00),   
(2, 10, 1, 129.99),  
(2, 11, 1, 79.99),   
(3, 12, 1, 399.00),  
(4, 3, 1, 1099.00),  
(5, 14, 2, 29.99),   
(5, 15, 1, 89.99),   
(5, 16, 1, 129.00);  

INSERT INTO movimientos_stock (producto_id, tipo_movimiento, cantidad, motivo, fecha_movimiento) VALUES
(1, 'ENTRADA', 15, 'CARGA INICIAL', '2023-10-01 09:00:00'), 
(2, 'ENTRADA', 8, 'CARGA INICIAL', '2023-10-01 09:00:00'),  
(3, 'ENTRADA', 20, 'CARGA INICIAL', '2023-10-01 09:00:00'), 
(1, 'ENTRADA', 1, 'CARGA INICIAL', '2023-10-15 10:30:00'),
(5, 'ENTRADA', 50, 'CARGA INICIAL', '2023-10-15 10:30:00'),
(6, 'SALIDA', 1, 'VENTA #1', '2023-10-15 10:30:00'),
(7, 'ENTRADA', 1, 'CARGA INICIAL', '2023-10-15 10:30:00'),
(10, 'SALIDA', 1, 'VENTA #2', '2023-10-16 14:15:00'),
(11, 'SALIDA', 1, 'VENTA #2', '2023-10-16 14:15:00'),
(12, 'ENTRADA', 1, 'CARGA INICIAL', '2023-10-17 11:45:00'),
(3, 'SALIDA', 1, 'VENTA #4', '2023-10-18 16:20:00'),
(14, 'ENTRADA', 2, 'CARGA INICIAL', '2023-10-19 09:10:00'),
(15, 'SALIDA', 1, 'VENTA #5', '2023-10-19 09:10:00'),
(16, 'SALIDA', 1, 'VENTA #5', '2023-10-19 09:10:00');