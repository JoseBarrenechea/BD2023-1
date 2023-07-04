import json
from flask import Flask, jsonify, render_template
import psycopg2
import psycopg2.extras
import os

app = Flask(__name__)

# Configuración de la base de datos
host = 'localhost'
database = 'Proyecto100k'
user = 'postgres'
password = '79543786'
schema = 'public'

def get_connection():
    db = psycopg2.connect(host=host, database=database, user=user, password=password)
    db.autocommit = True
    cursor = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    return db, cursor

def consulta_top_vendidos():
    db, cursor = get_connection()
    cursor.execute("""
        -- Top 10 más vendidos
        SELECT direccion, producto_nombre, cantidad_vendida
        FROM (
            SELECT p.nombre AS producto_nombre,
                   COUNT(co.codigo_barras) AS cantidad_vendida,
                   l.direccion,
                   ROW_NUMBER() OVER (PARTITION BY l.direccion ORDER BY COUNT(co.codigo_barras) DESC) AS ranking
            FROM compra c
            JOIN contiene co ON c.id_compra = co.id_compra
            JOIN producto p ON co.codigo_barras = p.codigo_barras
            JOIN caja_registradora cr ON c.id_caja = cr.id_caja
            JOIN local l ON cr.direccion = l.direccion
            GROUP BY p.nombre, l.direccion
        ) AS ventas_por_direccion
        WHERE ranking <= 10;
    """)
    result = cursor.fetchall()
    return result

def consulta_top_menos_vendidos():
    db, cursor = get_connection()
    cursor.execute("""
        -- Top 10 menos vendidos
        SELECT direccion, producto_nombre, cantidad_vendida
        FROM (
            SELECT p.nombre AS producto_nombre,
                   COUNT(co.codigo_barras) AS cantidad_vendida,
                   l.direccion,
                   ROW_NUMBER() OVER (PARTITION BY l.direccion ORDER BY COUNT(co.codigo_barras) ASC) AS ranking
            FROM compra c
            JOIN contiene co ON c.id_compra = co.id_compra
            JOIN producto p ON co.codigo_barras = p.codigo_barras
            JOIN caja_registradora cr ON c.id_caja = cr.id_caja
            JOIN local l ON cr.direccion = l.direccion
            GROUP BY p.nombre, l.direccion
        ) AS ventas_por_direccion
        WHERE ranking <= 10;
    """)
    result = cursor.fetchall()
    return result



@app.route("/consulta3", methods=["GET"])
def consulta3():
    db, cursor = get_connection()
    cursor.execute("""
        WITH GananciasCajas AS (
          SELECT
            EXTRACT(YEAR FROM c.fecha_compra) AS año,
            EXTRACT(MONTH FROM c.fecha_compra) AS mes,
            cr.direccion AS direccion_local,
            SUM((p.precio_venta - p.precio_compra) * co.cantidad) AS ganancia_local
          FROM compra c
          JOIN caja_registradora cr ON c.id_caja = cr.id_caja
          JOIN contiene co ON c.id_compra = co.id_compra
          JOIN producto p ON co.codigo_barras = p.codigo_barras
          GROUP BY mes, año, direccion_local
        ),
        DiasTrabajados AS (
          SELECT 
            dni,
            COUNT(*) AS dias_trabajados,
            EXTRACT(YEAR FROM fecha) AS año,
            EXTRACT(MONTH FROM fecha) AS mes
          FROM dia_de_trabajo 
          GROUP BY dni, año, mes
        ),
        GananciasEmpleados AS (
          SELECT 
            dt.dni,
            dt.dias_trabajados,
            dt.año,
            dt.mes,
            e.sueldo,
            (dt.dias_trabajados / 30.0) * e.sueldo AS ganancia_empleado
          FROM DiasTrabajados dt
          JOIN empleado e ON dt.dni = e.dni
        ),
        GananciasTotales AS (
          SELECT
            año,
            mes,
            SUM(ganancia_empleado) AS ganancia_total_empleados
          FROM GananciasEmpleados
          GROUP BY año, mes
        )

        SELECT
          gc.año,
          gc.mes,
          gc.direccion_local,
          gc.ganancia_local AS ganancia_caja,
          gt.ganancia_total_empleados AS sueldo_total_empleados,
          gc.ganancia_local - gt.ganancia_total_empleados AS ganancia_total
        FROM GananciasCajas gc
        JOIN GananciasTotales gt ON gc.año = gt.año AND gc.mes = gt.mes
        ORDER BY gc.año DESC, gc.mes DESC;
    """)

    result = cursor.fetchall()
    return jsonify({
        'success': True,
        'consulta3_resultado': result
    }), 200

@app.route("/", methods=["GET"])
def index():
    return render_template("index.html")

@app.route("/size/<size>", methods=["GET"])
def change_database_size(size):
    print(size)
    global database
    if size == "1k":
        database = "Proyecto1k"
    elif size == "10k":
        database = "Proyecto10k"
    elif size == "100k":
        database = "Proyecto100k"
    elif size == "1m":
        database = "Proyecto1m"
    else:
        return jsonify({'error': 'Tamaño de base de datos no válido'})
    
    return jsonify({
        'success': True,
        'message': f'{size}'
    }), 200

@app.route("/consulta1", methods=["GET"])
def consulta1():
    top_mas_vendidos = consulta_top_vendidos()
    top_menos_vendidos = consulta_top_menos_vendidos()
    return jsonify({
        'success': True,
        'top_mas_vendidos': top_mas_vendidos,
        'top_menos_vendidos': top_menos_vendidos
    }), 200


@app.route("/consulta2", methods=["GET"])
def consulta2():
    db, cursor = get_connection()
    cursor.execute("""
        -- Consulta 2: Ventas por Mes
        SELECT año, mes, tipo_derivacion, cantidad_ventas
FROM (
  SELECT
    EXTRACT(MONTH FROM c.fecha_compra) AS mes,
    EXTRACT(YEAR FROM c.fecha_compra) AS año,
    CASE
      WHEN cf.id_compra IS NOT NULL THEN 'compra_fisica'
      WHEN ce.id_compra IS NOT NULL THEN 'compra_encargo'
      WHEN cd.id_compra IS NOT NULL THEN 'compra_delivery'
    END AS tipo_derivacion,
    COUNT(*) AS cantidad_ventas,
    ROW_NUMBER() OVER (PARTITION BY EXTRACT(MONTH FROM c.fecha_compra), EXTRACT(YEAR FROM c.fecha_compra) ORDER BY COUNT(*) DESC) AS rn
  FROM compra c
  LEFT JOIN compra_fisica cf ON c.id_compra = cf.id_compra
  LEFT JOIN compra_encargo ce ON c.id_compra = ce.id_compra
  LEFT JOIN compra_delivery cd ON c.id_compra = cd.id_compra
  GROUP BY año, mes, tipo_derivacion
) sub
WHERE rn <= 3
ORDER BY año DESC, mes DESC;
    """)

    result = cursor.fetchall()
    return jsonify({
        'success': True,
        'ventas_por_mes': result
    }), 200

if __name__ == "__main__":
    app.run(debug=True)
