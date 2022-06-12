--Cелекты
SELECT 
   c.lastname AS lastname,
   c.id,
   pi.order_id AS order_id,
   pr.product_name AS product_name,
   (pi.product_quantity * pi.price_per_item) AS cost
FROM 
   purchase_items pi
JOIN
   orders o ON o.id = pi.order_id
JOIN 
   customers c 
JOIN 
   products pr ON pr.id = pi.product_id
WHERE  pi.order_id = 6 AND c.id = o.customer_id
; 


SELECT 
   c.lastname AS lastname,
   c.id,
   pi.order_id AS order_id,
   SUM(pi.product_quantity * pi.price_per_item) AS total_cost
FROM 
   purchase_items pi
JOIN
   orders o ON o.id = pi.order_id
JOIN 
   customers c 
WHERE pi.order_id = 5 AND c.id = o.customer_id
GROUP BY pi.order_id
; 


SELECT 
   c.lastname AS lastname,
   c.id,
   pi.order_id AS order_id,
   SUM(pi.product_quantity * pi.price_per_item) AS total_cost
FROM 
   purchase_items pi
JOIN
   orders o ON o.id = pi.order_id
JOIN 
   customers c 
WHERE  c.id = o.customer_id
GROUP BY pi.order_id
; 

--Представления
CREATE VIEW c AS
SELECT 
   c.lastname,
   c.id,
   pi.order_id,
   SUM(pi.product_quantity * pi.price_per_item) AS total_cost
FROM 
   purchase_items pi, orders o, customers c
WHERE  c.id = o.customer_id AND o.id = pi.order_id
GROUP BY pi.order_id;

SELECT lastname, total_cost FROM c;

DROP VIEW c;


CREATE VIEW v AS SELECT products.id, products.product_name, purchase_items.price_per_item 
FROM products, purchase_items
WHERE products.id = purchase_items.product_id ;

SELECT * FROM v;

DROP VIEW v;

-- Хранимая процедура обновления таблицы purchase _items

DROP PROCEDURE IF EXISTS price_update;

DELIMITER //
CREATE PROCEDURE price_update(IN product_id INT) 
  BEGIN
	
       UPDATE purchase_items 
       SET price_per_item = (
       SELECT new_price 
       FROM price_change 
       WHERE price_change.product_id = purchase_items.product_id);
	
  END// 
DELIMITER ; 

-- вызов процедуры
CALL price_update(5);

--Cоздаем еще одну таблицу логов, в которой будут храниться записи обновлений таблицы customers
--лог
DROP TABLE IF EXISTS `log`; 

CREATE TABLE `log` (
`id` INT( 11 ) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
`msg` VARCHAR( 255 ) NOT NULL,
`time` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
`row_id` INT( 11 ) NOT NULL
) ENGINE = MYISAM
--триггер
DELIMITER //
CREATE TRIGGER `update_test` AFTER INSERT ON `price_change`
FOR EACH ROW BEGIN
   INSERT INTO log Set msg = 'insert', row_id = NEW.id;
END; # * This source code was highlighted with Source Code Highlighter. 

--триггер

DROP TRIGGER IF EXISTS watchlog_customers;
delimiter //
CREATE TRIGGER watchlog_users AFTER INSERT ON customers
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at, table_name, str_id, name_value)
	VALUES (NOW(), 'customers', NEW.id, NEW.firstname);
END //
delimiter ;
