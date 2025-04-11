-- 📄 5. Procedimientos y Funciones (ProcedureAndFunctions.sql)
-- 1. Un procedimiento almacenado para registrar una venta.
-- 2. Validar que el cliente exista.
-- 3. Verificar que el stock sea suficiente antes de procesar la venta.
-- 4. Si no hay stock suficiente, Notificar por medio de un mensaje en consola usando RAISE.
-- 5. Si hay stock, se realiza el registro de la venta.

CREATE OR REPLACE FUNCTION calcular_stock(p_producto_id INTEGER) 
RETURNS INTEGER AS $$
BEGIN
    RETURN (
        SELECT COALESCE(SUM(
            CASE 
                WHEN tipo_movimiento = 'ENTRADA' THEN cantidad 
                WHEN tipo_movimiento = 'SALIDA' THEN -cantidad 
                ELSE 0 
            END
        ), 0)
        FROM movimientos_stock 
        WHERE producto_id = p_producto_id
    );
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE registrar_venta(
    p_cliente_id INTEGER,
    p_productos_ids INTEGER[],
    p_cantidades INTEGER[],
    p_usuario VARCHAR(50) DEFAULT 'SISTEMA'
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_venta_id INTEGER;
    v_index INTEGER;
    v_producto RECORD;
    v_stock_actual INTEGER;
    v_total DECIMAL(12,2) := 0;
    v_cliente_existe BOOLEAN;
    v_error_message TEXT;
BEGIN
    -- Validar que el cliente existe
    SELECT EXISTS(SELECT 1 FROM clientes WHERE cliente_id = p_cliente_id) INTO v_cliente_existe;
    
    IF NOT v_cliente_existe THEN
        RAISE EXCEPTION 'Error: El cliente con ID % no existe', p_cliente_id;
    END IF;
    
    -- Validar que los arrays tienen la misma longitud
    IF array_length(p_productos_ids, 1) IS DISTINCT FROM array_length(p_cantidades, 1) THEN
        RAISE EXCEPTION 'Error: La cantidad de productos no coincide con la cantidad de cantidades';
    END IF;
    
    -- Verificar stock para todos los productos antes de iniciar la transacción
    FOR v_index IN 1..array_length(p_productos_ids, 1) LOOP
        -- Obtener información del producto
        SELECT 
            p.*,
            calcular_stock(p.producto_id) AS stock_actual,
            p.precio AS precio_actual
        INTO v_producto
        FROM productos p
        WHERE p.producto_id = p_productos_ids[v_index];
        
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Error: El producto con ID % no existe', p_productos_ids[v_index];
        END IF;
        
        IF v_producto.stock_actual < p_cantidades[v_index] THEN
            v_error_message := FORMAT(
                'Error: Stock insuficiente para %s (ID: %). Stock actual: %, Cantidad solicitada: %',
                v_producto.nombre, v_producto.producto_id, v_producto.stock_actual, p_cantidades[v_index]
            );
            RAISE EXCEPTION '%', v_error_message;
        END IF;
        
        -- Calcular subtotal y acumular total
        v_total := v_total + (v_producto.precio_actual * p_cantidades[v_index]);
    END LOOP;
    
    -- Iniciar transacción explícita
    BEGIN
        -- Registrar la venta
        INSERT INTO ventas (cliente_id, fecha_venta, total)
        VALUES (p_cliente_id, CURRENT_TIMESTAMP, v_total)
        RETURNING venta_id INTO v_venta_id;
        
        -- Registrar detalles de venta y movimientos de stock
        FOR v_index IN 1..array_length(p_productos_ids, 1) LOOP
            -- Obtener precio actual del producto
            SELECT precio INTO v_producto.precio_actual FROM productos WHERE producto_id = p_productos_ids[v_index];
            
            -- Registrar detalle de venta
            INSERT INTO detalles_venta (venta_id, producto_id, cantidad, precio_unitario)
            VALUES (v_venta_id, p_productos_ids[v_index], p_cantidades[v_index], v_producto.precio_actual);
            
            -- Registrar movimiento de stock (salida)
            INSERT INTO movimientos_stock (
                producto_id, 
                tipo_movimiento, 
                cantidad, 
                motivo, 
                referencia_id,
                usuario_responsable
            ) VALUES (
                p_productos_ids[v_index], 
                'SALIDA', 
                p_cantidades[v_index], 
                'VENTA #' || v_venta_id,
                v_venta_id,
                p_usuario
            );
        END LOOP;
        
        -- Notificar éxito
        RAISE NOTICE 'Venta registrada exitosamente. ID: %, Total: %', v_venta_id, v_total;
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Revertir transacción en caso de error
            RAISE EXCEPTION 'Error al registrar la venta: %', SQLERRM;
    END;
END;
$$;

--Como probarlo
-- 1. Verificar datos existentes
SELECT * FROM clientes LIMIT 5;
SELECT p.producto_id, p.nombre, calcular_stock(p.producto_id) as stock FROM productos p WHERE p.producto_id IN (1, 5, 7);

-- 2. Venta exitosa
CALL registrar_venta(
    1,                 
    ARRAY[1, 5, 7],    
    ARRAY[1, 1, 1],    
    'vendedor1'        
);

-- 3. Verificar resultados
SELECT * FROM ventas ORDER BY venta_id DESC LIMIT 1;
SELECT dv.*, p.nombre FROM detalles_venta dv JOIN productos p ON dv.producto_id = p.producto_id WHERE venta_id = (SELECT MAX(venta_id) FROM ventas);
SELECT * FROM movimientos_stock ORDER BY movimiento_id DESC LIMIT 3;

-- Cliente que no existe
CALL registrar_venta(999, ARRAY[1], ARRAY[1], 'vendedor1');

-- Producto que no existe
CALL registrar_venta(1, ARRAY[999], ARRAY[1], 'vendedor1');

-- Error stock insuficiente - Primero verificar stock
SELECT calcular_stock(12) FROM productos WHERE producto_id = 12;

-- Intentar vender más
CALL registrar_venta(1, ARRAY[12], ARRAY[100], 'vendedor1');


