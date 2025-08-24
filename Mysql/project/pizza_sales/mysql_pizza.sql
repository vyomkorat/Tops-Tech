create database real_pizza;

-- create orders table
create table orders(
order_id int not null,
order_date date not null,
order_time time not null,
primary key(order_id));

-- list all orders with their date and time.
SELECT order_id, order_date, order_time FROM orders;

-- Show all unique pizza names from pizza_types.
SELECT DISTINCT name FROM pizza_types;

-- Find all pizza categories available in the menu.
select distinct category from pizza_types;

-- Retrieve all pizzas with "Mushrooms" as an ingredient.
SELECT name, ingredients FROM pizza_types WHERE ingredients LIKE '%Mushrooms%';

-- List all pizzas of size L.
select pizza_id from pizzas where size='L';

-- Show the total number of pizzas sold.
SELECT SUM(quantity) AS total_pizzas_sold FROM order_details;

-- Display the names of pizzas that belong to the "Veggie" category.
SELECT name FROM pizza_types WHERE category = 'Veggie';

-- Find all pizzas that contain both "Tomatoes" and "Cheese".
SELECT name, ingredients FROM pizza_types WHERE ingredients LIKE '%Tomatoes%' AND ingredients LIKE '%Cheese%';

-- Show all orders placed on '2015-01-01'.
SELECT * FROM orders WHERE order_date = '2015-01-01';

-- Retrieve all ingredients used in the "BBQ Chicken" pizza.
select ingredients from pizza_types where name ='The Barbecue Chicken Pizza';

-- Count how many times each pizza was ordered.
select p.pizza_id, sum(od.quantity) as total_ordered
from order_details od
join pizzas p on od.pizza_id=p.pizza_id
group by p.pizza_id
order by total_ordered desc;

-- Find the most frequently ordered pizza.
select pizza_id, sum(quantity) as total_quantity
from order_details
group by pizza_id
order by total_quantity desc
limit 1;

-- Get total number of pizzas sold per category.
SELECT pt.category,SUM(od.quantity) AS total_pizzas_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id 
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas_sold DESC;

-- Find the average number of pizzas ordered per order.
select avg(total_pizzas) as avg_pizzas_per_order
from (
	select order_id,sum(quantity) as total_pizzas
    from order_details
    group by order_id
) as order_quantities;

-- Count the number of orders made each month.
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,COUNT(order_id) AS total_orders
FROM orders
GROUP BY month
ORDER BY month;

-- Show the top 5 most ordered pizzas.
select pizza_id, sum(quantity) as total_quantity
from order_details
group by pizza_id
order by total_quantity desc
limit 5;

-- Find how many distinct pizza types have been ordered.
SELECT COUNT(DISTINCT p.pizza_type_id) AS distinct_pizza_types_ordered
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id;

-- Calculate the total quantity ordered per pizza size (S, M, L, etc.).
SELECT p.size, SUM(od.quantity) AS total_quantity_ordered
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY p.size;

-- List all orders along with pizza names and categories.
SELECT od.order_id, pt.name, pt.category
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id;

-- Get all ingredients of pizzas included in orders on '2015-06-01'.
SELECT DISTINCT pt.ingredients
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
WHERE o.order_date = '2015-06-01';

-- Show the names of pizzas and their corresponding order quantities.
SELECT pt.name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC;

-- Display pizza names, order date, and time for each order detail.
SELECT o.order_id, o.order_date, o.order_time, pt.name AS pizza_name
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
ORDER BY o.order_id;

-- Show all pizzas not in the 'Chicken' category.
SELECT name, category FROM pizza_types WHERE category <> 'Chicken';

-- Find all orders where more than 3 pizzas were ordered (by total quantity).
SELECT order_id, SUM(quantity) AS total_pizzas
FROM order_details
GROUP BY order_id
HAVING SUM(quantity) > 3;

-- Retrieve pizzas ordered in quantities greater than 2 in a single line item.
SELECT order_id, pizza_id, quantity FROM order_details WHERE quantity > 2;

-- List orders that include at least one large (L) pizza.
SELECT DISTINCT od.order_id
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
WHERE p.size = 'L';

-- Show pizzas that include "Spinach" but not "Mushrooms".
SELECT name, ingredients
FROM pizza_types
WHERE ingredients LIKE '%Spinach%' AND ingredients NOT LIKE '%Mushrooms%';

-- Find pizzas with more than 5 ingredients.
SELECT name, ingredients
FROM pizza_types
WHERE (LENGTH(ingredients) - LENGTH(REPLACE(ingredients, ',', ''))) + 1 > 5;

-- Rank pizzas based on total quantity sold (most sold = rank 1).
SELECT
    pt.name,
    SUM(od.quantity) AS total_quantity,
    RANK() OVER (ORDER BY SUM(od.quantity) DESC) AS sales_rank
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name;

-- Assign row numbers to pizzas within each category by popularity.
WITH PizzaSales AS (
  SELECT
    pt.category,
    pt.name,
    SUM(od.quantity) AS total_quantity
  FROM order_details od
  JOIN pizzas p ON od.pizza_id = p.pizza_id
  JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
  GROUP BY pt.category, pt.name
)
SELECT
  category,
  name,
  total_quantity,
  ROW_NUMBER() OVER (PARTITION BY category ORDER BY total_quantity DESC) AS rank_in_category
FROM PizzaSales;

-- Create a view showing order_id, pizza_name, and category.
CREATE VIEW V_OrderSummary AS
SELECT
    od.order_id,
    pt.name AS pizza_name,
    pt.category
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id;

-- Create a stored procedure to calculate total pizzas sold between two dates.
DELIMITER //
CREATE PROCEDURE GetTotalPizzasSoldByDateRange(IN start_date DATE, IN end_date DATE)
BEGIN
    SELECT SUM(od.quantity) AS total_pizzas
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
    WHERE o.date BETWEEN start_date AND end_date;
END //
DELIMITER ;

-- Use a CTE to get pizzas with a total sold quantity greater than the average sold quantity.
WITH PizzaQuantities AS (
    SELECT pizza_id, SUM(quantity) AS total_quantity
    FROM order_details
    GROUP BY pizza_id
),
AverageQuantity AS (
    SELECT AVG(total_quantity) as avg_qty FROM PizzaQuantities
)
SELECT pq.pizza_id, pq.total_quantity
FROM PizzaQuantities pq, AverageQuantity aq
WHERE pq.total_quantity > aq.avg_qty;

-- Replace NULL values in quantity with 1 (if any).
SELECT order_details_id, order_id, pizza_id, COALESCE(quantity, 1) AS quantity
FROM order_details;

-- Extract the pizza size (S, M, L) from pizza_id into a new column.
SELECT pizza_id, SUBSTRING_INDEX(pizza_id, '_', -1) AS size
FROM order_details;

-- Categorize pizzas by size into "Small", "Medium", "Large".
SELECT
    pizza_id,
    size,
    CASE
        WHEN size = 'S' THEN 'Small'
        WHEN size = 'M' THEN 'Medium'
        ELSE 'Large'
    END AS size_category
FROM pizzas;

-- Create a trigger to prevent inserting an order with quantity <= 0.
DELIMITER //
CREATE TRIGGER before_order_details_insert
BEFORE INSERT ON order_details
FOR EACH ROW
BEGIN
    IF NEW.quantity <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantity must be greater than 0.';
    END IF;
END; //
DELIMITER ;

-- Create an index on pizza_id in order_details for faster lookups.
ALTER TABLE order_details MODIFY pizza_id VARCHAR(50) NOT NULL;
CREATE INDEX idx_pizza_id ON order_details(pizza_id);

-- Write a transaction: insert an order and its details, commit only if both succeed.
START TRANSACTION;

INSERT INTO orders (order_id, order_date, order_time) VALUES (99999, '2025-08-22', '11:17:46');
INSERT INTO order_details (order_details_id, order_id, pizza_id, quantity) VALUES (99998, 99999, 'thai_ckn_l', 1);
INSERT INTO order_details (order_details_id, order_id, pizza_id, quantity) VALUES (99999, 99999, 'classic_dlx_m', 2);
COMMIT;

-- Show the number of unique pizza types per category.
SELECT category, COUNT(DISTINCT pizza_type_id) AS unique_pizza_types
FROM pizza_types
GROUP BY category;

-- Which category generates the most sales (by quantity)?
SELECT pt.category, SUM(od.quantity) AS total_quantity_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- What is the most popular pizza size overall?
SELECT p.size, SUM(od.quantity) AS total_sold
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY p.size
ORDER BY total_sold DESC
LIMIT 1;

-- Which ingredient appears in the most pizzas?
WITH RECURSIVE IngredientSplit AS (
  SELECT
    pizza_type_id,
    TRIM(SUBSTRING_INDEX(ingredients, ',', 1)) AS ingredient,
    SUBSTRING(ingredients, LOCATE(',', ingredients) + 1) AS remaining_ingredients
  FROM pizza_types
  WHERE ingredients LIKE '%,%'
  UNION ALL
  SELECT
    pizza_type_id,
    TRIM(SUBSTRING_INDEX(remaining_ingredients, ',', 1)),
    SUBSTRING(remaining_ingredients, LOCATE(',', remaining_ingredients) + 1)
  FROM IngredientSplit
  WHERE remaining_ingredients LIKE '%,%'
)
SELECT ingredient, COUNT(*) AS appearance_count
FROM IngredientSplit
GROUP BY ingredient
ORDER BY appearance_count DESC
LIMIT 1;

-- Compare average quantity ordered per category.
SELECT
    pt.category,
    AVG(od.quantity) AS avg_quantity_per_item
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- Find the top 3 pizza types per category based on quantity sold.
WITH CategorySales AS (
  SELECT
    pt.category,
    pt.name,
    SUM(od.quantity) AS total_quantity,
    RANK() OVER(PARTITION BY pt.category ORDER BY SUM(od.quantity) DESC) as category_rank
  FROM order_details od
  JOIN pizzas p ON od.pizza_id = p.pizza_id
  JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
  GROUP BY pt.category, pt.name
)
SELECT category, name, total_quantity
FROM CategorySales
WHERE category_rank <= 3;

-- Identify pizzas that were never ordered.
SELECT p.pizza_id
FROM pizzas p
LEFT JOIN order_details od ON p.pizza_id = od.pizza_id
WHERE od.order_details_id IS NULL;

-- Determine the busiest day of the week based on the number of orders
SELECT DAYNAME(order_date) AS day_of_week, COUNT(order_id) AS number_of_orders
FROM orders
GROUP BY day_of_week
ORDER BY number_of_orders DESC
LIMIT 1;

-- List orders with the highest variety of pizza types.
SELECT od.order_id, COUNT(DISTINCT p.pizza_type_id) AS variety_count
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
GROUP BY od.order_id
ORDER BY variety_count DESC
LIMIT 5;

-- Calculate the average number of ingredients per pizza.
SELECT AVG((LENGTH(ingredients) - LENGTH(REPLACE(ingredients, ',', ''))) + 1) AS avg_ingredients
FROM pizza_types;

-- List categories with fewer than 5 unique pizza types.
SELECT category, COUNT(pizza_type_id) AS number_of_pizzas
FROM pizza_types
GROUP BY category
HAVING COUNT(pizza_type_id) < 5;