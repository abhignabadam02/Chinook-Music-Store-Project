-- Created database chinook 
-- created tables 
-- inserted the data and analysis is done
-- Objective Question 1 
-- 1.Does any table have missing values or duplicates? If yes how would you handle it ?
-- Identifying null values ,handling null values and checking duplicates 
-- For album table 

select * 
from album 
where album_id is null or 
title is null or 
artist_id is null;
-- no missing values
select album_id from album group by album_id having count(*)>1;
-- no duplicates 

-- For artist table 
select * 
from artist 
where artist_id is null or name is null;
-- no null values 
select artist_id from artist group by artist_id having count(*)>1;
-- no duplicate values 

-- For customer table 
select * 
from customer 
where customer_id is null or 
first_name is null or 
last_name is null or 
company is null or 
address is null or 
city is null or 
state is null or 
country is null or 
postal_code is null or 
phone is null or 
fax is null or 
email is null or 
support_rep_id is null ;

-- Null values in company,state,postal_code,phone and fax columns 
update customer 
set company="Not mentioned"
where company is null;

update customer 
set state=coalesce(state,"Unknown state"),
postal_code=coalesce(postal_code,"00000"),
phone=coalesce(phone,"Not Provided"),
fax=coalesce(fax,"Not Provided");
-- missing values are handled


select customer_id 
from customer 
group by customer_id 
having count(*)>1;
-- no duplicate rows 

-- For employee table 
-- Missing values are checked 
select * 
from employee
where employee_id is null or 
last_name is null or 
first_name is null or 
title is null or 
reports_to is null or 
birthdate is null or 
hire_date is null or 
address is null or 
city is null or 
state is null or 
country is null or 
postal_code is null or 
fax is null or 
email is null;
 -- missing valuee in reports_to column


update employee
set reports_to = 2
where reports_to is null;
-- missing values are handled 

select employee_id 
from employee
group by employee_id 
having count(*)>1;
-- no duplicate values 

-- For genre table 
-- Missing values are checked 
select *
from genre 
where genre_id is null or 
name is null;
-- no missing values 

select genre_id 
from genre 
group by genre_id 
having count(*)>1;
-- No duplicate values 

-- For invoice table 

select *
from invoice 
where invoice_id is null or 
customer_id is null or 
invoice_date is null or 
billing_address is null or 
billing_city is null or 
billing_state is null or 
billing_country is null or 
billing_postal_code is null or 
total is null;
-- No missing values 

select invoice_id from invoice group by invoice_id having count(*)>1;
-- No duplicate values 

-- For invoice_line table 
select *
from invoice_line
where invoice_line_id is null or 
invoice_id is null or 
track_id is null or 
unit_price is null or 
quantity is null;
-- No missing values 

select invoice_line_id 
from invoice_line
group by invoice_line_id 
having count(*)>1;
-- No duplicate values 

-- For media_type table
select * 
from media_type 
where media_type_id is null or 
name is null;
-- No missing values 

select media_type_id 
from media_type 
group by media_type_id 
having count(*)>1;
-- no duplicate rows 

-- For playlist table 
select * 
from playlist
where playlist_id is null or 
name is null;
-- no missing values 

select playlist_id 
from playlist 
group by playlist_id 
having count(*)>1;
-- no duplicate rows  

-- for playlist_track table 

select * from playlist_track where playlist_id is null or track_id is null;
-- no missing values 

select playlist_id,track_id from playlist_track group by playlist_id,track_id having count(*)>1;
-- no duplicate rows 

-- For track table
select * from track 
where track_id is null or 
name is null or
album_id is null or 
media_type_id is null or 
genre_id is null or 
composer is null or 
milliseconds is null or 
bytes is null or 
unit_price is null;

-- missing values in composer column 

update track 
set composer="Unknown composer"
where composer is null;
-- missing values are handled 

select track_id from track group by track_id having count(*)>1;
-- no duplicate rows 

-- Objective question 2 
-- Find the top-selling tracks and top artist in the USA and identify their most famous genres.

-- Top 9 tracks by revenue in USA
with top_selling_tracks as (
select t.name as track_name,g.name as genre_name,ar.name as artist_name,
sum(il.quantity*il.unit_price) as track_revenue,
sum(il.quantity) as track_quantity
from invoice_line il 
join invoice i on il.invoice_id=i.invoice_id
join track t on il.track_id=t.track_id 
join genre g on t.genre_id=g.genre_id
join album a on t.album_id=a.album_id 
join artist ar on a.artist_id=ar.artist_id
where i.billing_country="USA"
group by il.track_id,t.name,g.name
order by track_revenue desc
limit 9)

select * from top_selling_tracks;

-- Top selling tracks most famous genres 

with top_selling_tracks as (
select t.name as track_name,g.name as genre_name,ar.name as artist_name,sum(il.quantity*il.unit_price) as track_revenue,sum(il.quantity) as track_quantity
from invoice_line il 
join invoice i on il.invoice_id=i.invoice_id
join track t on il.track_id=t.track_id 
join genre g on t.genre_id=g.genre_id
join album a on t.album_id=a.album_id 
join artist ar on a.artist_id=ar.artist_id
where i.billing_country="USA"
group by il.track_id,t.name,g.name
order by track_revenue desc
limit 9)

select genre_name,count(*) as tracks_count 
from top_selling_tracks
group by genre_name
order by tracks_count desc;

-- Top artists by revenue is USA
with top_artists as (
select ar.name as artist_name,g.name as genre_name,sum(il.quantity*il.unit_price) as track_revenue,sum(il.quantity) as track_quantity
from invoice_line il 
join invoice i on il.invoice_id=i.invoice_id
join track t on il.track_id=t.track_id 
join genre g on t.genre_id=g.genre_id
join album a on t.album_id=a.album_id 
join artist ar on a.artist_id=ar.artist_id
where i.billing_country="USA"
group by ar.name,g.name
order by track_revenue desc
limit 10) 

select * from top_artists;


-- Top artist top genres 

with top_artists as (
select ar.name as artist_name,g.name as genre_name,sum(il.quantity*il.unit_price) as track_revenue,sum(il.quantity) as track_quantity
from invoice_line il 
join invoice i on il.invoice_id=i.invoice_id
join track t on il.track_id=t.track_id 
join genre g on t.genre_id=g.genre_id
join album a on t.album_id=a.album_id 
join artist ar on a.artist_id=ar.artist_id
where i.billing_country="USA"
group by ar.name,g.name
order by track_revenue desc
limit 10) 

select genre_name,count(*) as artist_count 
from top_artists 
group by genre_name;


-- Objective question 3 
-- What is the customer demographic breakdown (age, gender, location) of Chinook's customer base?

-- By location (country) total no of customers
select country,count(customer_id) as No_of_customers 
from customer 
group by country 
order by country;
-- By location (country,state,city) total no of customers
select country,state,city,count(customer_id) as No_of_customers 
from customer 
group by country,state,city
order by country,state,city;

-- Objective question 4 
-- Calculate the total revenue and number of invoices for each country, state, and city:

-- by country,state and city no of invoices and total revenue
select billing_country,billing_state,billing_city,count(invoice_id) as no_of_invoices , sum(total) as total_revenue
from invoice 
group by billing_country,billing_state,billing_city
order by  billing_country,billing_state,billing_city;

-- by country no of invoices and total revenue
select billing_country,
count(invoice_id) as no_of_invoices , 
sum(total) as total_revenue
from invoice 
group by billing_country;

-- Objective question 5 
-- Find the top 5 customers by total revenue in each country

-- List of top 5 customer per each country
with customer_vs_revenue as 
(select c.customer_id,c.first_name,c.last_name,c.country,sum(i.total) as total_revenue 
from customer c
join invoice i
on c.customer_id=i.customer_id
group by c.customer_id,c.first_name,c.last_name,c.country),
customer_ranking as 
(select country,customer_id,first_name,last_name,total_revenue,
dense_rank() over(partition by country order by total_revenue desc) as ranking
from customer_vs_revenue)

select country,concat(first_name," ",last_name) as customer_name,total_revenue,ranking 
from customer_ranking 
where ranking<=5
order by country,ranking;

-- Objective question 6 
-- Identify the top-selling track for each customer

-- List of customers and their top selling track by revenue
with customer_track_sales as(
    select c.customer_id,c.first_name,c.last_name,t.track_id,t.name as track_name,
    sum(il.unit_price * il.quantity) as total_spent
    from customer c
    join invoice i on c.customer_id = i.customer_id
    join invoice_line il on i.invoice_id = il.invoice_id
    join track t on il.track_id = t.track_id
    group by c.customer_id, c.first_name, c.last_name, t.track_id, t.name
),
ranked_tracks as (
    select *,
           rank() over(partition by customer_id order by total_spent desc) as rnk
    from customer_track_sales
)
select
    customer_id,concat(first_name," ",last_name),track_id,track_name,total_spent
from ranked_tracks
where rnk = 1
order by customer_id;

-- Objectibe question 7 
-- Are there any patterns or trends in customer purchasing behavior (e.g., frequency of purchases, preferred payment methods, average order value)?


-- Frequency of Orders per customer

select c.customer_id,
concat(c.first_name," ",c.last_name) as customer_name,
count(invoice_id) as no_of_purchases
from customer c 
join invoice i on c.customer_id=i.customer_id
group by c.customer_id,c.first_name,c.last_name
order by no_of_purchases desc,c.customer_id;

-- Average order value 

select c.customer_id,
concat(c.first_name," ",c.last_name) as customer_name,
round(avg(i.invoice_id),2) as average_order_value 
from customer c 
join invoice i on c.customer_id=i.customer_id
group by c.customer_id,c.first_name,c.last_name
order by average_order_value desc,c.customer_id;


-- Objective question 8 
-- What is the customer churn rate?

-- Churn rate is measured on basis customers who didnt make any purchase in last 6 months.
with recent_purchase_all_customers as (select max(invoice_date) as recent_date from invoice),
cte2 as
(
select customer_id, max(invoice_date)as recent_purchase
from invoice 
group by customer_id
having timestampdiff(month,recent_purchase,(select recent_date from recent_purchase_all_customers))>6
order by customer_id
)

select count(customer_id)/(select count(customer_id) from customer) as churn_rate
from customer 
where customer_id not in (select customer_id from cte2);

-- Objective question 9 
-- Calculate the percentage of total sales contributed by each genre in the USA and identify the best-selling genres and artists.

-- In USA For each genre percentage of sales is calculated
with cte as (select g.name as genre_name,sum(il.quantity*il.unit_price) as genre_revenue
from  invoice i 
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id 
join genre g on t.genre_id=g.genre_id
join customer c on i.customer_id=c.customer_id 
where country="USA"
group by g.name),
cte2 as 
(select sum(genre_revenue) as total_revenue from cte)

select genre_name,genre_revenue*100/(select total_revenue from cte2) as revenue_percentage 
from cte 
order by revenue_percentage desc;
-- Top genres Rock,Alternative & Punk,Metal
-- Identifying artist of top genre 

select ar.name as artist_name,g.name as genre_name,sum(il.quantity*il.unit_price) as artist_revenue
from artist ar 
join album a on ar.artist_id=a.artist_id 
join track t on a.album_id=t.album_id
join genre g on t.genre_id=g.genre_id 
join invoice_line il on t.track_id=il.track_id
join invoice i on il.invoice_id=i.invoice_id
where i.billing_country="USA"
group by ar.name,g.name
order by artist_revenue desc
limit 10;




-- Objective question 10
-- Find customers who have purchased tracks from at least 3 different+ genres

-- Customers who have purchased tracks from at least 3 different+ genres

select count(*) from (select concat(first_name," ",last_name) as customer_name,count(distinct t.genre_id) as genres
from customer c 
join invoice i on c.customer_id=i.customer_id 
join invoice_line il on i.invoice_id=il.invoice_id 
join track t on il.track_id=t.track_id
group by c.first_name,c.last_name
having count(distinct t.genre_id)>=3
order by genres desc) as t 
where genres>=10;


-- Objective question 11 
-- Rank genres based on their sales performance in the USA

with genre_and_revenue as 
(select g.name as genre_name,
sum(il.quantity*il.unit_price) as genre_revenue 
from invoice_line il
join invoice i on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on g.genre_id=t.genre_id
where i.billing_country="USA"
group by g.name)

select genre_name,genre_revenue,dense_rank() over(order by genre_revenue desc) as genre_ranking 
from genre_and_revenue;

-- Objective question 12 
-- Identify customers who have not made a purchase in the last 3 months

-- List of customers who didn't made any purchase in the last 3 months 
with latest_purchase_date  as (select max(invoice_date) as last_record_date from invoice),
latest_customer_purchase as
(select c.customer_id,c.first_name,c.last_name,max(i.invoice_date) as latest_purchase_date
from invoice i 
join customer c 
on i.customer_id=c.customer_id 
group by c.customer_id,c.first_name,c.last_name
order by c.customer_id)

select concat(first_name," ",last_name) as customer_name,latest_purchase_date
from latest_customer_purchase 
cross join latest_purchase_date
where latest_purchase_date < DATE_SUB(last_record_date, interval 3 month)
order by latest_purchase_date desc;

-- Subjective question 1 
-- Recommend the three albums from the new record label that should be prioritised for advertising and promotion in the USA based on genre sales analysis.

-- Genre vs Sales
with genre_sales as (select g.name as genre_name,sum(il.quantity*il.unit_price) as total_sales
from invoice_line il 
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
join invoice i on i.invoice_id=il.invoice_id
where i.billing_country="USA"
group by g.name
order by total_sales desc
),

-- Top 3 genres 
top_genres as (select genre_name,total_sales,round(total_sales*100/(select sum(total_sales) from genre_sales),2) as perc_cont 
from genre_sales
order by total_sales desc
limit 3),

-- select * from top_genres;

-- album, genre vs revenue of album belongs to top 3 genres
album_revenue as (select a.title as album_title,g.name as genre_name,sum(il.quantity*il.unit_price) as total_sales
from album a 
join track t on a.album_id=t.album_id 
join genre g on g.genre_id=t.genre_id 
join invoice_line il on il.track_id=t.track_id
join invoice i on i.invoice_id=il.invoice_id 
where i.billing_country="USA"
group by a.title,g.name 
order by total_sales desc)

-- Top 3 albums in USA
select tg.genre_name,ar.album_title,ar.total_sales 
from album_revenue ar 
join top_genres tg on ar.genre_name=tg.genre_name
order by tg.total_sales desc,ar.total_sales desc 
limit 3;



-- Subjective question 2 
-- Determine the top-selling genres in countries other than the USA and identify any commonalities or differences.

--  List of each country other than USA for each genre revenue and its rank 
with genre_sales as (
    select i.billing_country,g.name as genre_name,sum(il.quantity * t.unit_price) as total_sales,
        row_number() over(partition by i.billing_country order by sum(il.quantity * t.unit_price) desc)
        as rnk from invoice_line il
    join track t
    on il.track_id = t.track_id
    join genre g 
    on t.genre_id = g.genre_id
    join invoice i 
    on il.invoice_id = i.invoice_id
    where i.billing_country != 'usa'
    group by i.billing_country, g.name
)

-- list of each country top 3 genres
select billing_country,genre_name,total_sales 
from genre_sales 
where rnk <= 3;

-- Below is the same steps as above 
with genre_sales as (
    select i.billing_country,g.name as genre_name,sum(il.quantity * t.unit_price) as total_sales,
        row_number() over(partition by i.billing_country order by sum(il.quantity * t.unit_price) desc)
        as rnk from invoice_line il
    join track t
    on il.track_id = t.track_id
    join genre g 
    on t.genre_id = g.genre_id
    join invoice i 
    on il.invoice_id = i.invoice_id
    where i.billing_country != 'usa'
    group by i.billing_country, g.name
)

-- this gives for each genre in how many countries it is in top 3 
select genre_name, count(*) as Top_3_countries from (
select billing_country,genre_name,total_sales 
from genre_sales 
where rnk <= 3) as t 
group by genre_name;


-- Subjective question 3 
-- Customer Purchasing Behavior Analysis: How do the purchasing habits (frequency, basket size, spending amount) of long-term customers differ from those of new customers? What insights can these patterns provide about customer loyalty and retention strategies?


select max(invoice_date) from invoice; -- which is 2020-12-30

-- List of customers and their first purchase
with first_purchase as (select customer_id,min(invoice_date) as first_purchase
from invoice 
group by customer_id
order by customer_id),

-- based on their first purchase the list of customers and their segementation into Long term and new customers
customers_segmentation as 
(select customer_id,
case when first_purchase<'2023-12-30' then "Long-term"
else "New"
end as customer_segmentation
from first_purchase)

-- For long term and new customers total purchase average basket size average spent per purchase is analysed
select cs.customer_segmentation,count(distinct i.invoice_id) as total_purchases,
count(il.invoice_line_id) * 1.0 / count(distinct i.invoice_id) as avg_basket_size,
sum(i.total) as total_spent,avg(i.total) as avg_spent_per_invoice
from customers_segmentation cs
join invoice i on cs.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
group by cs.customer_segmentation
order by cs.customer_segmentation;



-- Subjective question 4 
-- Product Affinity Analysis: Which music genres, artists, or albums are frequently purchased together by customers? How can this information guide product recommendations and cross-selling initiatives?


-- List of genre pairs and no of purchase customers purchased together
select g1.name as genre_1,g2.name as genre_2,
count(*) as total_purchase
from invoice i
join invoice_line il1 on i.invoice_id = il1.invoice_id
join track t1 on il1.track_id = t1.track_id
join genre g1 on t1.genre_id = g1.genre_id
join invoice_line il2 on i.invoice_id = il2.invoice_id and il1.track_id < il2.track_id
join track t2 on il2.track_id = t2.track_id
join genre g2 on t2.genre_id = g2.genre_id
where g1.genre_id < g2.genre_id
group by g1.name, g2.name
order by total_purchase desc
limit 10;

-- List of album pairs and no of purchase customers purchased together
select a1.title as album_1,a2.title as album_2,count(*) as total_purchase
from invoice i
join invoice_line il1 on i.invoice_id = il1.invoice_id
join track t1 on il1.track_id = t1.track_id
join album a1 on t1.album_id = a1.album_id
join invoice_line il2 on i.invoice_id = il2.invoice_id and il1.track_id < il2.track_id
join track t2 on il2.track_id = t2.track_id
join album a2 on t2.album_id = a2.album_id
where a1.album_id < a2.album_id
group by a1.title, a2.title
order by total_purchase desc
limit 10;

-- List of artist pairs and no of purchase customers purchased together
select a1.name as artist_1,a2.name as artist_2,count(*) as  purchase_count
from invoice_line il1
join track t1 on il1.track_id = t1.track_id
join album al1 on t1.album_id = al1.album_id
join artist a1 on al1.artist_id = a1.artist_id
join invoice_line il2 on il1.invoice_id = il2.invoice_id
join track t2 on il2.track_id = t2.track_id
join album al2 on t2.album_id = al2.album_id
join artist a2 on al2.artist_id = a2.artist_id
where a1.artist_id <> a2.artist_id  and a1.artist_id>a2.artist_id
group by  a1.name, a2.name 
order by purchase_count desc
limit 10;

-- Subjective question 5 
-- Regional Market Analysis: Do customer purchasing behaviors and churn rates vary across different geographic regions or store locations? How might these correlate with local demographic or economic factors?

-- List of countries and their revenue related analysis
select country,
count(distinct c.customer_id) as total_customers,count(distinct i.invoice_id) as total_purchases,
sum(il.quantity*il.unit_price) as total_revenue,
sum(il.quantity) as total_quantity,
avg(i.total) as avg_purchase_value,
sum(il.quantity) / count(distinct i.customer_id) as avg_quantity_per_customer
from customer c
join invoice i on c.customer_id=i.customer_id 
join invoice_line il on i.invoice_id=il.invoice_id
group by country 
order by country ;

-- List of customers and their latest purchase 
with last_invoices as (
select customer_id,max(invoice_date) as last_invoice_date
from invoice
group by customer_id
),

-- list of churned customers
churned_customers as (
select c.customer_id,c.country
from customer c
join last_invoices li on c.customer_id = li.customer_id
where li.last_invoice_date < date_sub('2020-12-30', interval 6 month)
),

-- list of all customers 

all_customers as (
select customer_id,country
from customer
)

-- List of countries and the customers churned percentage
select ac.country,round(cast(count(distinct cc.customer_id) as float) *100/ count(distinct ac.customer_id), 2) as churn_rate
from all_customers ac
left join churned_customers cc on ac.customer_id = cc.customer_id
group by ac.country
order by churn_rate desc;



-- Subjective question 6 
-- Customer Risk Profiling: Based on customer profiles (age, gender, location, purchase history), which customer segments are more likely to churn or pose a higher risk of reduced spending? What factors contribute to this risk?

-- List of customer , total invoices, total spent,average spent, days since their last purchase annd categorizimg based on that 
select customer_id,first_name,last_name,country,total_invoices,total_spent,avg_money_spent,
datediff('2020-12-30',latest_purchase) as days_since_last_purchase,
case when datediff('2020-12-30',latest_purchase)<=90 then 'Low Risk'
when datediff('2020-12-30',latest_purchase) between 90 and 180 then 'Medium Risk'
else 'High Risk'
end as risk_segment from 
(select c.customer_id,c.first_name,c.last_name,c.country,
count(i.invoice_id) as total_invoices,
sum(i.total) as total_spent,
avg(i.total) as avg_money_spent,
max(i.invoice_date) as latest_purchase 
from customer c 
join invoice i on c.customer_id=i.customer_id
group by c.customer_id,c.first_name,c.last_name,c.country) as customer_info 
order by  days_since_last_purchase desc;


-- Subjective question 7 
-- Customer Lifetime Value Modeling: How can you leverage customer data (tenure, purchase history, engagement) to predict the lifetime value of different customer segments? This could inform targeted marketing and loyalty program strategies. Can you observe any common characteristics or purchase patterns among customers who have stopped purchasing?

-- List of customer their first purchase date,latest purchase date,total revenue, average revenue ,customer tenure years
with customer_info as (select c.customer_id, concat(c.first_name,' ',c.last_name) as cust_name,min(i.invoice_date) as first_purchase_date,
max(invoice_date) as last_purchase_date,timestampdiff(year,min(i.invoice_date),max(i.invoice_date)) as customer_tenure_in_yrs,
sum(i.total) as total_revenue, avg(i.total) as avg_revenue,
count(distinct i.invoice_id) as total_purchases from customer c 
join invoice i 
on c.customer_id = i.customer_id 
join invoice_line il 
on i.invoice_id = il.invoice_id
group by c.customer_id,cust_name)

-- List of customer,revenue,predicted revenue,days since last purchase and their categorization based on their days since their last purchase
select customer_id,cust_name,total_revenue,round(avg_revenue*total_purchases*customer_tenure_in_yrs,2) as Predicted_CLV ,
datediff('2020-12-30',last_purchase_date) as days_since_last_purchase,
case 
when datediff('2020-12-30',last_purchase_date)<=90 then "Active"
when datediff('2020-12-30',last_purchase_date)  between 91 and 180 then "At risk"
else "Churned"
end as customer_segmentation
from customer_info
group by customer_id,cust_name
order by customer_id;





-- Subjective question 10 
-- How can you alter the "Albums" table to add a new column named "ReleaseYear" of type INTEGER to store the release year of each album?

start transaction;

savepoint before_album_alter;

alter table album
add ReleaseYear integer;




-- Subjective question 11
-- Chinook is interested in understanding the purchasing behaviour of customers based on their geographical location. 
-- They want to know the average total amount spent by customers from each country, along with the number of customers and the average number of tracks purchased per customer.
-- Write an SQL query to provide this information

-- List of countries, no of customers, average total spent for customers and average tracks purchased per customer
select c.country,
count(distinct c.customer_id) as total_customers,
round(avg(i.total_amount), 2) as avg_total_spent_per_customer,
round(avg(i.total_tracks), 2) as avg_tracks_per_customer
from customer c
join (
	select i.customer_id,sum(il.unit_price * il.quantity) as total_amount,sum(il.quantity) as total_tracks
    from invoice i
    join invoice_line il on i.invoice_id = il.invoice_id
    group by i.customer_id
) i on c.customer_id = i.customer_id
group by c.country
order by c.country,avg_total_spent_per_customer desc;











