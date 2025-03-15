/* CASO PRÁCTICO SQL
Explorar la tabla “menu_items” para conocer los productos del menú.
1.- Realizar consultas para contestar las siguientes preguntas:*/

-- Encontrar el número de artículos en el menú.
-- Existen 32 artículos en el menu
SELECT * FROM menu_items;
SELECT DISTINCT item_name FROM menu_items;

-- ¿Cuál es el artículo menos caro y el más caro en el menú?
SELECT MIN(price) as menos_caro 
FROM menu_items;
SELECT * FROM menu_items where price=5;
-- Respuesta el Edamame es el más barato con un precio de $5.00

SELECT MAX(price) as mas_caro 
FROM menu_items;
SELECT * FROM menu_items where price=19.95;
--Shrimp Scampi es el más caro con un precio de $19.95

SELECT * FROM menu_items ORDER BY price ASC;

--¿Cuántos platos americanos hay en el menú? 6 son los platos de esta categoría. 
SELECT COUNT(*) AS cuantos FROM menu_items WHERE category='American';

--¿Cuál es el precio promedio de los platos? $13.29 es el precio promedio
SELECT ROUND(AVG(price),2) FROM menu_items;

/*c) Explorar la tabla “order_details” para conocer los datos que han sido recolectados.
1.- Realizar consultas para contestar las siguientes preguntas:*/

--¿Cuántos pedidos únicos se realizaron en total? 5370 pedidos únicos
SELECT DISTINCT(order_id) FROM order_details;

--¿Cuáles son los 5 pedidos que tuvieron el mayor número de artículos?
SELECT order_id, count(item_id) 
FROM order_details
GROUP BY order_id
ORDER BY count(item_id) DESC
LIMIT 5;

-- Los pedidos con número de orden 440, 2675, 3473, 4305 y 443 tuvieron 14 artículos. 

--¿Cuándo se realizó el primer pedido y el último pedido?
SELECT * FROM order_details 
ORDER BY order_date ASC, order_time ASC
LIMIT 1;  -- La orden id 1 se realizó el 01/01/2023 a las 11:38:36

SELECT * FROM order_details 
ORDER BY order_date DESC, order_time DESC
LIMIT 1;  -- La orden id 12234 se realizó el 31/03/2023 a las 22:15:48

--En una sola consulta
(SELECT * FROM order_details ORDER BY order_date ASC, order_time ASC LIMIT 1)
UNION ALL
(SELECT * FROM order_details ORDER BY order_date DESC, order_time DESC LIMIT 1);

--¿Cuántos pedidos se hicieron entre el '2023-01-01' y el '2023-01-05'?
SELECT DISTINCT order_id FROM order_details 
WHERE order_date BETWEEN '2023-01-01' AND '2023-01-05';
--Se realizaron 308 pedidos distintos 

SELECT category, COUNT(item_name) 
FROM menu_items GROUP BY category;
--Existen 4 categorías de platillos y contienen cada una las siguientes cantidades:
--La categoría Americana tiene 6 platillos y es la que tiene menos, le sigue la Asiatica con 8,
-- y al final con el mismo número de platillos 9 las categorías Mexicana e Italiana

--LEFT JOIN
-- La categoría Asiatica es la que tiene mayor número de órdenes con 3740, seguida de la Italian con 2948, 
-- la Mexicana con 2945 y la que tiene menos órdenes en la Americana con 2734
SELECT  m.category, COUNT(o.order_id) AS Total_orders
FROM menu_items AS m
LEFT JOIN order_details AS o
ON m.menu_item_id = o.item_id
GROUP BY 1
ORDER BY 2 DESC;

--Inner Join
--Cuáles son las cinco órdenes que generaron más ingresos al restaurante
--Las órdenes son la 440 con $192.15, la 2075 con $191.05, la 1957 con $190.10, la 330 con $189.70
--y finalmente la 2675 con $185.10
SELECT  o.order_id, SUM(m.price) AS Total_orden
FROM menu_items AS m
INNER JOIN order_details AS o
ON m.menu_item_id = o.item_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- ¿Cual es el producto mas pedido de cada categoría?
SELECT m.category, m.item_name, COUNT(o.order_details_id) AS Total
FROM menu_items AS m
INNER JOIN order_details AS o
ON m.menu_item_id = o.item_id
GROUP BY 1,2
ORDER BY 3 DESC;
--De la categoría Americana la Hamburguesa, de la Asiatica el Edamame, de la Mexicana el Steak Torta y 
--italiana el Spaghetti & Meatballs

-- Los 5 productos más vendidos son: Hamburger, Edamame, Korean Beef Bowl, Cheeseburger y French Fries

-- Los productos menos ordenados por categoría
SELECT m.category, m.item_name, COUNT(o.order_details_id) AS Total
FROM menu_items AS m
INNER JOIN order_details AS o
ON m.menu_item_id = o.item_id
GROUP BY 1,2
ORDER BY 3 ASC;

-- De la categoría Mexicana Chicken Tacos, de la Asiatica Potstickers, de la italiana Cheese Lasagna 
-- y de la Americana Veggie Burger

-- Los 5 productos menos pedidos Chicken Tacos, Potstickers, Chesee Lasagna, Steak Tacos y Cheese Quesadillas


SELECT m.category, m.item_name, COUNT(o.order_details_id) AS Total
FROM menu_items AS m
INNER JOIN order_details AS o
ON m.menu_item_id = o.item_id
GROUP BY 1,2
HAVING COUNT(o.order_details_id) IS NULL;
-- NO HAY NULOS TODOS LOS PRODUCTOS FUERON ORDENADOS 

SELECT m.menu_item_id, m.item_name
FROM menu_items AS m
LEFT JOIN order_details AS o
ON m.menu_item_id = o.item_id
WHERE o.item_id IS NULL;

-- La categoría que generó mas y menos ingresos
SELECT  m.category, SUM(m.price) AS Total_categoria
FROM menu_items AS m
INNER JOIN order_details AS o
ON m.menu_item_id = o.item_id
GROUP BY 1
ORDER BY 2 DESC;
--La categoría que genera mayores ingresos es la italian con un monto de $49462.70 y la que genera menos es la 
--American con $28237.75 

--Total de ingresos
Select sum(m.price) AS Total_categoria
FROM menu_items AS m
INNER JOIN order_details AS o
ON m.menu_item_id = o.item_id;