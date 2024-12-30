-- Average order amount for each country
SELECT country, AVG(priceEach * quantityOrdered) AS avg_order_value
FROM customers c 
INNER JOIN orders o ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY country
ORDER BY avg_order_value DESC;
-- Total sales amount for each product line 
SELECT productline, SUM(priceEach*quantityOrdered) as sales_value
FROM orderdetails od
INNER JOIN products p ON od.productCode = p.productCode
GROUP BY productLine;
-- Top 10 best selling products based on total quantity sold 
SELECT productName, SUM(quantityOrdered) AS units_sold
FROM orderdetails od
INNER JOIN products p ON od.productCode = p.productCode
GROUP BY productName
ORDER BY units_sold DESC
LIMIT 10;
-- Evaluation of sales performace of each sales representative
SELECT e.firstname, e.lastname, SUM(quantityOrdered * priceEach) AS order_value
FROM employees e
INNER JOIN customers c
ON employeeNumber = salesRepEmployeeNumber AND e.jobTitle = 'Sales Rep'
LEFT JOIN orders o 
ON c.customerNumber = o.customerNumber
LEFT JOIN orderdetails od 
ON o.orderNumber = od.orderNumber
GROUP BY e.firstname, e.lastname;
-- Average number of orders placed by each customer
SELECT COUNT(O.ordernumber)/ COUNT(DISTINCT c.customerNumber)
FROM customers c
LEFT JOIN orders o
ON c.customerNumber = o.customerNumber; 
-- Percentage of orders shipped on time 
SELECT SUM(CASE WHEN shippedDate <= requiredDate THEN 1 ELSE 0 END)/ COUNT(orderNumber) *100 AS PERCENT_ON_TIME
FROM orders;
-- Profit margin for each product (by subtracting COGS from sales revenue)
SELECT productName, SUM((priceEach*quantityOrdered) - (buyPrice*quantityOrdered)) as net_profit
FROM products p 
INNER JOIN orderdetails o
ON p.productCode = o.productCode
GROUP BY productName; 
-- Segmented customers based on total purchase amount 
SELECT c.*, t2.customer_segment
FROM customers c
LEFT JOIN
(SELECT *, 
CASE WHEN total_purchase_value > 100000 THEN 'High Value'
	WHEN total_purchase_value BETWEEN 50000 AND 100000 THEN 'Medium Value'
    WHEN total_purchase_value < 50000 THEN 'Low Value'
    ELSE 'Other' END AS customer_segment
    FROM
		(SELECT customerNumber, sum(priceEach*quantityOrdered) AS total_purchase_value
        FROM orders o
        INNER JOIN orderdetails od
        ON o.orderNumber = od.orderNumber
        GROUP BY customerNumber)t1
        )t2
ON c.customernumber = t2.customerNumber;
-- Frequently co-purchased products to understand cross selling opportunities orders
SELECT od.productCode, p.productName, od2.productCode, p2.productName, count(*) AS purchased_together
FROM orderdetails od
INNER JOIN orderdetails od2
ON od.orderNumber = od2.orderNumber AND od.productCode <> od2.productCode
INNER JOIN products p 
ON od.productCode = p.productCode
INNER JOIN products p2
ON od2.productCode = p2.productCode
GROUP BY od.productCode, p.productName, od2.productCode, p2.productCode; 




