-- SUM 

/*Find the total amount of poster_qty paper ordered in the orders table.*/

SELECT SUM(poster_qty) AS total_pqty
FROM orders;

/*Find the total amount of standard_qty paper ordered in the orders table.*/

SELECT SUM(standard_qty) AS total_sqty
FROM orders;

/*Find the total dollar amount of sales using the total_amt_usd in the orders table.*/

SELECT SUM(total_amt_usd) AS totalusd
FROM orders;

/*Find the total amount spent on standard_amt_usd and gloss_amt_usd paper
 for each order in the orders table. This should give a dollar amount for each order in the table*/

 SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

/*Find the standard_amt_usd per unit of standard_qty paper. 
Your solution should use both an aggregation and a mathematical operator.*/

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS standard_price_per_unit
FROM orders;

--MIN, MAX, AVG

/*When was the earliest order ever placed? You only need to return the date.*/

SELECT MIN(occurred_at) AS earliest
FROM orders;

/*Try performing the same query as in question 1 without using an aggregation function.*/

SELECT occurred_at 
FROM orders 
ORDER BY occurred_at
LIMIT 1;


/*When did the most recent (latest) web_event occur?*/

SELECT MAX(occurred_at) AS earliest
FROM web_events;

/*Try to perform the result of the previous query without using an aggregation function.*/

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;


/*Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order.
Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.*/

SELECT AVG(standard_qty) AS avg_sqty, AVG(gloss_qty) AS avg_gloss, AVG(poster_qty) AS avg_poster,
 AVG(standard_amt_usd) AS avg_standardusd, AVG(gloss_amt_usd) AS avg_glossusd, AVG(poster_amt_usd) AS avg_posterusd
FROM orders;

/*what is the MEDIAN total_usd spent on all orders?*/

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

--GROUP BY 

/*Which account (by name) placed the earliest order?
 Your solution should have the account name and the date of the order.*/

 SELECT accounts.name, orders.occurred_at
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
ORDER BY orders.occurred_at
LIMIT 1;

/*Find the total sales in usd for each account.
 You should include two columns - the total sales for each company's orders in usd and the company name.*/

 SELECT accounts.name AS aname,
	   SUM(orders.total_amt_usd) AS totalusd
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY aname;

/*Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?
 Your query should return only three values - the date, channel, and account name.*/

 SELECT accounts.name AS acname,    web_events.occurred_at AS date, web_events.channel AS channel
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
ORDER BY date DESC
LIMIT 1;

/*Find the total number of times each type of channel from the web_events was used.
 Your final table should have two columns - the channel and the number of times the channel was used.*/

 SELECT channel, 
       COUNT(*) AS times
FROM web_events
GROUP BY channel;

/*Who was the primary contact associated with the earliest web_event?*/

SELECT accounts.primary_poc AS earliestPOC
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
LIMIT 1;

/*What was the smallest order placed by each account in terms of total usd.
 Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.*/

 SELECT accounts.name AS acname,
       MIN(orders.total_amt_usd) AS min
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY acname
ORDER BY min;

/*Find the number of sales reps in each region. 
Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.*/

SELECT region.name AS region ,
       COUNT(sales_reps.*) AS no
FROM sales_reps
JOIN region
ON sales_reps.region_id = region.id
GROUP BY region
ORDER BY no;

/*For each account, determine the average amount of each type of paper they purchased across their orders.
 Your result should have four columns - one for the account name and one for the average quantity purchased
  for each of the paper types for each account.*/

SELECT accounts.name AS acname,
       AVG(orders.standard_qty) AS avgstd,
       AVG(orders.gloss_qty) AS avgglos,
       AVG(orders.poster_qty) AS avgposter
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY acname;

/*For each account, determine the average amount spent per order on each paper type.
 Your result should have four columns - one for the account name and one for the average amount spent on each paper type.*/

 SELECT a.name, AVG(o.standard_amt_usd) avg_stand, AVG(o.gloss_amt_usd) avg_gloss, AVG(o.poster_amt_usd) avg_post
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name;

/*Determine the number of times a particular channel was used in the web_events table for each sales rep.
 Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences.
  Order your table with the highest number of occurrences first.*/

SELECT sales_reps.name AS sname,
       web_events.channel AS channel,
       COUNT(*) AS occurno
 FROM web_events
 JOIN accounts
 ON web_events.account_id = accounts.id
 JOIN sales_reps
 ON accounts.sales_rep_id = sales_reps.id
 GROUP BY sname, channel
 ORDER BY occurno DESC;

 /*Determine the number of times a particular channel was used in the web_events table for each region.
  Your final table should have three columns - the region name, the channel, and the number of occurrences.
   Order your table with the highest number of occurrences first.*/

SELECT region.name AS rname,
       web_events.channel AS channel,
       COUNT(*) AS occurno
 FROM web_events
 JOIN accounts
 ON web_events.account_id = accounts.id
 JOIN sales_reps
 ON accounts.sales_rep_id = sales_reps.id
 JOIN region
 ON sales_reps.region_id = region.id
 GROUP BY rname, channel
 ORDER BY occurno DESC;

 
-- DISTINCT

/*Use DISTINCT to test if there are any accounts associated with more than one region.*/

/*The below two queries have the same number of resulting rows (351), so we know that every account
 is associated with only one region. If each account was associated with more than one region, the first
  query should have returned more rows than the second query.*/

SELECT a.id as "account id", r.id as "region id", 
a.name as "account name", r.name as "region name"
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
JOIN region r
ON r.id = s.region_id;


SELECT DISTINCT id, name
FROM accounts;

/*Have any sales reps worked on more than one account?*/

SELECT accounts.id AS acid, accounts.name AS acname, sales_reps.id AS saleid, sales_reps.name AS salename
FROM accounts
JOIN sales_reps
ON accounts.sales_rep_id = sales_reps.id;

SELECT DISTINCT id, name
FROM sales_reps;


--THIS IS OFFICIAL ANSWER

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;

SELECT DISTINCT id, name
FROM sales_reps;


-- HAVING

/*How many of the sales reps have more than 5 accounts that they manage?*/

SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

/*and technically, we can get this using a SUBQUERY as shown below.
 This same logic can be used for the other queries, but this will not be shown.*/

 SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
     FROM accounts a
     JOIN sales_reps s
     ON s.id = a.sales_rep_id
     GROUP BY s.id, s.name
     HAVING COUNT(*) > 5
     ORDER BY num_accounts) AS Table1;

/*How many accounts have more than 20 orders?*/

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;

/*Which account has the most orders?*/

SELECT accounts.id,
       accounts.name,
       COUNT(*) AS ct
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY 1,2
ORDER BY ct DESC
LIMIT 1;

/*Which accounts spent more than 30,000 usd total across all orders?*/

SELECT accounts.id,
       accounts.name,
       SUM(orders.total_amt_usd) AS tmusd
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY 1,2
HAVING SUM(orders.total_amt_usd) > 30000
ORDER BY tmusd;

/*Which accounts spent less than 1,000 usd total across all orders?*/

SELECT accounts.id,
       accounts.name,
       SUM(orders.total_amt_usd) AS tmusd
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY 1,2
HAVING SUM(orders.total_amt_usd) < 30000
ORDER BY tmusd;

/*Which account has spent the most with us?*/

SELECT accounts.id,
       accounts.name,
       SUM(orders.total_amt_usd) AS tmusd
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY 1,2
ORDER BY tmusd DESC
LIMIT 1;

/*Which account has spent the least with us?*/

SELECT accounts.id,
       accounts.name,
       SUM(orders.total_amt_usd) AS tmusd
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
GROUP BY 1,2
ORDER BY tmusd

/*Which accounts used facebook as a channel to contact customers more than 6 times?*/

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

/*Which account used facebook most as a channel?*/

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING w.channel = 'facebook'
ORDER BY use_of_channel DESC

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1;

/*Which channel was most frequently used by most accounts?*/

SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;

-- DATE 

/*Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least.
 Do you notice any trends in the yearly sales totals?*/

SELECT DATE_PART('year', occurred_at) AS year,
       SUM(total_amt_usd) AS totalsales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*Which month did Parch & Posey have the greatest sales
 in terms of total dollars? Are all months evenly represented by the dataset?*/

SELECT DATE_PART('month', occurred_at) AS month,
       SUM(total_amt_usd) AS totalsales
FROM orders
GROUP BY 1
ORDER BY totalsales DESC
LIMIT 1;

/*Which year did Parch & Posey have the greatest sales in terms of total number of orders?
 Are all years evenly represented by the dataset?*/

 SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*Which month did Parch & Posey have the greatest sales in terms of total number of orders?
 Are all months evenly represented by the dataset?*/

 SELECT DATE_PART('month', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

/*n which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/

SELECT DATE_TRUNC('month', o.occurred_at) AS month,SUM(o.gloss_amt_usd) AS glossusd
 FROM orders o
 JOIN accounts a
 ON o.account_id = a.id
 WHERE a.name = 'Walmart'
 GROUP BY 1
 ORDER BY glossusd DESC
 LIMIT 1;


-- CASE STATEMENTS

/*Write a query to display for each order, the account ID, total amount of the order,
 and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.*/

 SELECT account_id,
       total_amt_usd,
       CASE WHEN total_amt_usd>=3000 THEN 'LARGE'
            ELSE 'Small' END AS order_level
FROM orders;


/*Write a query to display the number of orders in each of three categories, 
based on the total number of items in each order. The three categories are: 'At Least 2000',
 'Between 1000 and 2000' and 'Less than 1000'.*/

SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
   WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
   ELSE 'Less than 1000' END AS order_category,
COUNT(*) AS order_count
FROM orders
GROUP BY 1;

/*We would like to understand 3 different levels of customers based on the amount associated with their purchases.
 The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd.
  The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd.
  \ Provide a table that includes the level associated with each account. You should provide the account name, 
  the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.*/


  SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
GROUP BY a.name
ORDER BY 2 DESC;

/*We would now like to perform a similar calculation to the first, but we want to
 obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question.
  Order with the top spending customers listed first.*/

  SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' 
GROUP BY 1
ORDER BY 2 DESC;

/*We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. 
Create a table with the sales rep name, the total number of orders, and a column with top or not depending 
on if they have more than 200 orders. Place the top sales people first in your final table.*/

SELECT s.name AS rep_name,
       COUNT(*) AS rep_total,
       CASE WHEN COUNT(*)>200 THEN 'top'
            ELSE 'not' END AS type
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 2 DESC;

/*The previous didn't account for the middle, nor the dollar amount associated with the sales.
 Management decides they want to see these characteristics represented as well. We would like to
  identify top performing sales reps, which are sales reps associated with more than 200 orders or 
  more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales.
   Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column 
   with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales 
   first in your final table. You might see a few upset sales people by this criteria!*/


SELECT s.name AS rep_name,
       COUNT(*) AS rep_total,
       SUM(o.total_amt_usd) AS rep_total_usd,
       CASE WHEN COUNT(*)>200 OR               SUM(o.total_amt_usd)>750000 THEN 'top'
            WHEN COUNT(*)>150 OR SUM(o.total_amt_usd)> 500000 THEN 'middle'
            ELSE 'low' END AS type
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY 1
ORDER BY 3 DESC;

       

       