```markdown
# 📋 Sistema de Gestión de Inventario TechZone

## 📌 Descripción del Proyecto

Sistema de gestión para tiendas de tecnología que permite:
- Control de inventario y stock
- Gestión de proveedores y productos
- Registro de ventas y clientes
- Reportes analíticos

## 🔍 Modelo Entidad-Relación

![Diagrama E-R](./Images/modelo_er.png)

## 🛠 Instalación

### Requisitos
- PostgreSQL 12+
- Acceso de superusuario

### Ejecución
```bash
# 1. Crear base de datos
psql -U postgres -c "CREATE DATABASE filtro_techzone;"

# 2. Ejecutar scripts en orden
psql -U postgres -d filtro_techzone -f db.sql
psql -U postgres -d filtro_techzone -f insert.sql
psql -U postgres -d filtro_techzone -f ProcedureAndFunctions.sql
```

## 📂 Estructura de Archivos

| Archivo                | Descripción                                                                 |
|------------------------|-----------------------------------------------------------------------------|
| `db.sql`               | Crea la estructura de la base de datos (tablas, relaciones, índices)        |
| `insert.sql`           | Inserta datos iniciales (15+ registros por tabla)                          |
| `queries.sql`          | 6 consultas analíticas requeridas                                          |
| `ProcedureAndFunctions.sql` | Procedimiento para registrar ventas con validaciones de stock           |

## 💻 Uso del Sistema

### Procedimiento de Venta
```sql
-- Ejemplo: Registrar venta
CALL registrar_venta(
    1,                     -- ID cliente
    ARRAY[1, 5, 7],        -- ID productos
    ARRAY[1, 2, 1],        -- Cantidades
    'vendedor1'            -- Usuario
);

-- Casos de error
CALL registrar_venta(999, ARRAY[1], ARRAY[1], 'vendedor1');  -- Cliente inexistente
CALL registrar_venta(1, ARRAY[999], ARRAY[1], 'vendedor1');  -- Producto inexistente
```

### Consultas Principales
```sql
-- Productos con stock bajo (<5 unidades)
SELECT * FROM productos WHERE calcular_stock(producto_id) < 5;

-- Top 5 productos más vendidos
\i queries.sql  -- Ejecuta todas las consultas analíticas
```

## 📊 Consultas Disponibles

1. Productos con stock crítico
2. Ventas por mes específico
3. Cliente más frecuente
4. Top 5 productos vendidos
5. Ventas por rangos de fechas
6. Clientes inactivos (6+ meses)

## 🚨 Manejo de Errores

El sistema notificará mediante mensajes:
- Clientes/productos inexistentes
- Stock insuficiente
- Inconsistencias en los datos
- Errores en transacciones

## 📌 Estructura del Repositorio
```
.
├── db.sql
├── insert.sql
├── queries.sql
├── ProcedureAndFunctions.sql
├── modelo_er.png
└── README.md
```