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