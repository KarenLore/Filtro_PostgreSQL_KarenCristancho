-- 📄 4. Consultas SQL (queries.sql)

--  1. Listar los productos con stock menor a 5 unidades.
SELECT 
    p.producto_id,
    p.nombre AS producto,
    c.nombre AS categoria,
    pr.nombre AS proveedor,
    (
        SELECT COALESCE(SUM(
            CASE 
                WHEN ms.tipo_movimiento = 'ENTRADA' THEN ms.cantidad 
                WHEN ms.tipo_movimiento = 'SALIDA' THEN -ms.cantidad 
                ELSE 0 
            END
        ), 0)
        FROM movimientos_stock ms
        WHERE ms.producto_id = p.producto_id
    ) AS stock_actual,
    p.precio
FROM 
    productos p
JOIN 
    categorias c ON p.categoria_id = c.categoria_id
JOIN 
    proveedores pr ON p.proveedor_id = pr.proveedor_id
WHERE 
    (
        SELECT COALESCE(SUM(
            CASE 
                WHEN ms.tipo_movimiento = 'ENTRADA' THEN ms.cantidad 
                WHEN ms.tipo_movimiento = 'SALIDA' THEN -ms.cantidad 
                ELSE 0 
            END
        ), 0)
        FROM movimientos_stock ms
        WHERE ms.producto_id = p.producto_id
    ) < 5
ORDER BY 
    stock_actual ASC;

-- 2. Calcular ventas totales de un mes específico (ejemplo: octubre 2023)
SELECT 
    EXTRACT(MONTH FROM fecha_venta) AS mes,
    EXTRACT(YEAR FROM fecha_venta) AS año,
    COUNT(*) AS total_ventas,
    SUM(total) AS ingresos_totales,
    ROUND(AVG(total), 2) AS promedio_venta
FROM ventas
WHERE EXTRACT(MONTH FROM fecha_venta) = 10 
  AND EXTRACT(YEAR FROM fecha_venta) = 2023
GROUP BY mes, año;

-- 3. Obtener el cliente con más compras realizadas
WITH compras_cliente AS (
    SELECT 
        c.cliente_id,
        c.nombre,
        c.email,
        COUNT(v.venta_id) AS total_compras,
        SUM(v.total) AS total_gastado
    FROM clientes c
    JOIN ventas v ON c.cliente_id = v.cliente_id
    GROUP BY c.cliente_id, c.nombre, c.email
)
SELECT * FROM compras_cliente
ORDER BY total_compras DESC, total_gastado DESC
LIMIT 1;

-- 4. Listar los 5 productos más vendidos (por cantidad)
SELECT 
    p.producto_id,
    p.nombre,
    SUM(dv.cantidad) AS total_vendido,
    SUM(dv.subtotal) AS ingresos_totales,
    c.nombre AS categoria
FROM productos p
JOIN detalles_venta dv ON p.producto_id = dv.producto_id
JOIN categorias c ON p.categoria_id = c.categoria_id
GROUP BY p.producto_id, p.nombre, c.nombre
ORDER BY total_vendido DESC
LIMIT 5;

-- 5. Consultar ventas realizadas en rangos de fechas
-- Rango de 3 días específico
SELECT 
    v.venta_id,
    c.nombre AS cliente,
    v.fecha_venta,
    v.total,
    COUNT(dv.detalle_id) AS productos_comprados
FROM ventas v
JOIN clientes c ON v.cliente_id = c.cliente_id
JOIN detalles_venta dv ON v.venta_id = dv.venta_id
WHERE v.fecha_venta BETWEEN '2023-10-15' AND '2023-10-17'
GROUP BY v.venta_id, c.nombre, v.fecha_venta, v.total
ORDER BY v.fecha_venta;

-- Rango de 1 mes completo (agrupado por día)
SELECT 
    DATE(v.fecha_venta) AS dia,
    COUNT(*) AS ventas_dia,
    SUM(v.total) AS ingresos_dia,
    ROUND(AVG(v.total), 2) AS promedio_venta_dia
FROM ventas v
WHERE v.fecha_venta BETWEEN '2023-10-01' AND '2023-10-31'
GROUP BY dia
ORDER BY dia;

-- 6. Identificar clientes que no han comprado en los últimos 6 meses
SELECT 
    c.cliente_id,
    c.nombre,
    c.email,
    c.telefono,
    MAX(v.fecha_venta) AS ultima_compra,
    EXTRACT(DAY FROM (CURRENT_DATE - MAX(v.fecha_venta))) AS dias_sin_comprar
FROM clientes c
LEFT JOIN ventas v ON c.cliente_id = v.cliente_id
GROUP BY c.cliente_id, c.nombre, c.email, c.telefono
HAVING MAX(v.fecha_venta) IS NULL 
   OR MAX(v.fecha_venta) < CURRENT_DATE - INTERVAL '6 months'
ORDER BY ultima_compra NULLS FIRST;