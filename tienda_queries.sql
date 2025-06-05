
DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda CHARACTER SET utf8mb4;
USE tienda;

CREATE TABLE fabricante (
  codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE producto (
  codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DOUBLE NOT NULL,
  codigo_fabricante INT UNSIGNED NOT NULL,
  FOREIGN KEY (codigo_fabricante) REFERENCES fabricante(codigo)
);

INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');

INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);


-- QUERIES

-- 1. List all product names
SELECT nombre FROM producto;

-- 2. List product names and prices
SELECT nombre, precio FROM producto;

-- 3. List all columns from the product table
SELECT * FROM producto;

-- 4. List product name, price in EUR, and price in USD (assuming 1 EUR = 1.1 USD)
SELECT nombre, precio, precio * 1.1 AS price_usd FROM producto;

-- 5. List with aliases: product name, euros, dollars
SELECT nombre AS product_name, precio AS euros, precio * 1.1 AS dollars FROM producto;

-- 6. Product names and prices with names in uppercase
SELECT UPPER(nombre) AS product_name, precio FROM producto;

-- 7. Product names and prices with names in lowercase
SELECT LOWER(nombre) AS product_name, precio FROM producto;

-- 8. Manufacturer names and first two characters in uppercase
SELECT nombre, UPPER(LEFT(nombre, 2)) AS initials FROM fabricante;

-- 9. Product names and rounded prices
SELECT nombre, ROUND(precio) AS rounded_price FROM producto;

-- 10. Product names and truncated prices
SELECT nombre, TRUNCATE(precio, 0) AS truncated_price FROM producto;

-- 11. Manufacturer codes with products
SELECT codigo_fabricante FROM producto;

-- 12. Distinct manufacturer codes with products
SELECT DISTINCT codigo_fabricante FROM producto;

-- 13. Manufacturer names ascending
SELECT nombre FROM fabricante ORDER BY nombre ASC;

-- 14. Manufacturer names descending
SELECT nombre FROM fabricante ORDER BY nombre DESC;

-- 15. Product names ordered by name ascending and price descending
SELECT nombre, precio FROM producto ORDER BY nombre ASC, precio DESC;

-- 16. First 5 rows from fabricante
SELECT * FROM fabricante LIMIT 5;

-- 17. 2 rows starting from the 4th (inclusive)
SELECT * FROM fabricante LIMIT 3, 2;

-- 18. Cheapest product
SELECT nombre, precio FROM producto ORDER BY precio ASC LIMIT 1;

-- 19. Most expensive product
SELECT nombre, precio FROM producto ORDER BY precio DESC LIMIT 1;

-- 20. Products from manufacturer with code 2
SELECT nombre FROM producto WHERE codigo_fabricante = 2;

-- 21. Product name, price, and manufacturer name
SELECT p.nombre AS product_name, p.precio, f.nombre AS manufacturer_name
FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo;

-- 22. Same as 21 but ordered by manufacturer name
SELECT p.nombre AS product_name, p.precio, f.nombre AS manufacturer_name
FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
ORDER BY f.nombre ASC;

-- 23. Product and manufacturer codes and names
SELECT p.codigo AS product_code, p.nombre AS product_name, f.codigo AS manufacturer_code, f.nombre AS manufacturer_name
FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo;

-- 24. Cheapest product with manufacturer
SELECT p.nombre AS product_name, p.precio, f.nombre AS manufacturer_name
FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
ORDER BY p.precio ASC LIMIT 1;

-- 25. Most expensive product with manufacturer
SELECT p.nombre AS product_name, p.precio, f.nombre AS manufacturer_name
FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
ORDER BY p.precio DESC LIMIT 1;

-- 26. All products by Lenovo
SELECT p.* FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre = 'Lenovo';

-- 27. Products by Crucial with price > 200
SELECT p.* FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre = 'Crucial' AND p.precio > 200;

-- 28. Products by Asus, Hewlett-Packard, Seagate (without IN)
SELECT p.* FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre = 'Asus' OR f.nombre = 'Hewlett-Packard' OR f.nombre = 'Seagate';

-- 29. Products by Asus, Hewlett-Packard, Seagate (with IN)
SELECT p.* FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre IN ('Asus', 'Hewlett-Packard', 'Seagate');

-- 30. Products with manufacturer name ending with 'e'
SELECT p.nombre, p.precio FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre LIKE '%e';

-- 31. Products with manufacturer name containing 'w'
SELECT p.nombre, p.precio FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE f.nombre LIKE '%w%';

-- 32. Products with price >= 180, ordered by price desc and name asc
SELECT p.nombre, p.precio, f.nombre AS manufacturer_name
FROM producto p
JOIN fabricante f ON p.codigo_fabricante = f.codigo
WHERE p.precio >= 180
ORDER BY p.precio DESC, p.nombre ASC;

-- 33. Manufacturer codes and names with associated products
SELECT DISTINCT f.codigo, f.nombre
FROM fabricante f
JOIN producto p ON f.codigo = p.codigo_fabricante;

-- 34. All manufacturers with their products, including those without products
SELECT f.nombre AS manufacturer_name, p.nombre AS product_name
FROM fabricante f
LEFT JOIN producto p ON f.codigo = p.codigo_fabricante;

-- 35. Manufacturers without products
SELECT f.nombre
FROM fabricante f
LEFT JOIN producto p ON f.codigo = p.codigo_fabricante
WHERE p.codigo IS NULL;

-- 36. All products by Lenovo (without INNER JOIN)
SELECT * FROM producto
WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Lenovo');

-- 37. Products with same price as most expensive Lenovo product (without INNER JOIN)
SELECT * FROM producto
WHERE precio = (
  SELECT MAX(precio) FROM producto WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Lenovo')
);

-- 38. Most expensive product name from Lenovo
SELECT nombre FROM producto
WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Lenovo')
ORDER BY precio DESC LIMIT 1;

-- 39. Cheapest product name from Hewlett-Packard
SELECT nombre FROM producto
WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Hewlett-Packard')
ORDER BY precio ASC LIMIT 1;

-- 40. Products with price >= most expensive Lenovo product
SELECT * FROM producto
WHERE precio >= (
  SELECT MAX(precio) FROM producto WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Lenovo')
);

-- 41. Products by Asus with price above their average price
SELECT * FROM producto
WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Asus')
AND precio > (
  SELECT AVG(precio) FROM producto WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Asus')
);
