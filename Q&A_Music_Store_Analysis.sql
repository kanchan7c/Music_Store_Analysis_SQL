Question 1: Who is the seniormost employee?

select * from employee;

-- Query to check the seniormost employee
select * from employee 
order by levels desc
limit 1;

Question 2: Which countries have the most invoices?

select * from invoice;
select * from invoice_line;

-- This query will output USA with 131 invoices topping the list
select billing_country as country, count(*) as Count_of_invoices 
from invoice
group by 1
order by Count_of_invoices desc;


Question 3: What are top 3 values of total invoice?

select * from invoice;

-- This query will output top 3 total values in invoice table sorted by total
select * from invoice
order by total desc
limit 3;

Question 4: Which city has best customers? 

select * from customer;
select * from invoice;

-- This query will filter the city based on highest total invoice value
select billing_city as city, sum(total) as total_invoice
from  invoice
group by city
order by total_invoice desc
limit 1;

Question 5: Who is the best customer who has spent the most?

-- This query will fetch the top spender from the customer list aggregated on invoice totals
select 
	customer.customer_id as customer_id, 
	concat(customer.first_name, customer.last_name) as customer_name,
	sum(invoice.total) as total_invoice
from 
	customer join invoice
on 
	customer.customer_id = invoice.customer_id
group by 
	1, 2
order by 
	3 desc
limit 1;

Question 6: Write a query to return the email, first name, last name and Genre of all Rock
			music listeners. Return your list ordered alphabetically by email starting with A.
			
select * from genre;

-- This query will return the list of customers that enjoys rock music with their email address sorted alphabetically
select 
	email,
	first_name,
	last_name
from 
	customer 
	join invoice on customer.customer_id = invoice.customer_id
	join invoice_line on invoice.invoice_id = invoice_line.invoice_id
	join track on invoice_line.track_id = track.track_id
	join genre on track.genre_id = genre.genre_id
where 
	genre.name = 'Rock'
group by 1, 2, 3
order by email asc;

Question 7: Lets invite the artists who have written the most rock music in our dataset. Write
			a query that returns the Artist name and total track count of the top 10 rock bands.
			
-- artist --> album --> track --> genre

-- This query fetches top 10 rock bands sorted by most track counts first
select 
	artist.name as Artist_name,
	count(track_id) as track_count
from
	artist
	join album on artist.artist_id = album.artist_id
	join track on album.album_id = track.album_id
	join genre on track.genre_id = genre.genre_id
where
	genre.name like 'Rock'
group by artist.artist_id, 1
order by track_count desc
limit 10;
			
Question 8: Return all the track names that have a song length longer than the average song length. 
			Return the Name and milliseconds for each track. Order by the song length with the longest songs listed first. 
			
-- This query returns a list of tracks that are longer than the average length of songs
select
	name as track_name,
	milliseconds as song_len_ms
from 
	track
where 
	milliseconds > (select avg(milliseconds) from track)
order by 
	2 desc;
	
Question 9: Find how much amount spent by each customer on artists? Write a query to
			return customer name, artist name and total spent.

-- artist --> album --> track 
-- customer --> invoice --> invoice_line ---> track

-- This query will return total amount spent by each customer on artists sorted in decreasing order
select
	concat(customer.first_name, customer.last_name) as customer_name,
	artist.name as artist_name,
	sum(invoice.total) as total_spent
from
	customer
	join invoice on customer.customer_id = invoice.customer_id
	join invoice_line on invoice.invoice_id = invoice_line.invoice_id
	join track on invoice_line.track_id = track.track_id
	join album on track.album_id = album.album_id
	join artist on album.artist_id = artist.artist_id
group by
	1, 2
order by
	3 desc;
	


Question 10: We want to find out the most popular music genre for each country.
			 We determine the most popular genre as the genre with the highest amount of
			 purchases. Write a query that returns each country along with the top genre.
			 For countries where the maximum number of purchases. Shared all genres.

-- customer --> invoice --> invoice_line --> track --> genre

select
	invoice.billing_country as Country,
	genre.name as top_genre,
	sum(invoice_line.quantity) as total_purchase_qty
from
	customer
	join invoice on customer.customer_id = invoice.customer_id
	join invoice_line on invoice.invoice_id = invoice_line.invoice_id
	join track on invoice_line.track_id = track.track_id
	join genre on track.genre_id = genre.genre_id
group by
	2,1
order by 
	3 desc;
	


Question 11: Write a query that determined the customer that has spent the most on music for each 
			 country. Write a query that returns the country along with the top customer and how much they spent.
			 For countries where the top amount spent is shared, provide all customers who spent this amount.

-- This query returns the top customer per country who has spent highest amount purchasing the tracks.

with rows_and_position as(			 
select
	invoice.billing_country as Country,
	concat(customer.first_name,customer.last_name) as customer_name,
	sum(invoice.total) as total_spent,
	row_number() over(partition by invoice.billing_country order by sum(invoice.total) desc)
from
	customer
	join invoice on customer.customer_id = invoice.customer_id
	group by 1,2
	order by 3 desc
	)

select Country, customer_name, total_spent
from  rows_and_position
where row_number = 1;



















