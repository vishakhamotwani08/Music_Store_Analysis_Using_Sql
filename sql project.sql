--Who is the senior most employee ?
select * from employee  order by(levels) desc limit 1;
-- which country have the most invoices?
select count(invoice_id) as total_invoices,billing_country from invoice group by(billing_country) order by(total_invoices) desc limit 1;
--What are top 3 values of total invoice?
select invoice_id,total from invoice order by(total) desc limit 3;
--Whichcity has the best customers?We would like to throw a promotional 
--music festival in the city we made the most money.
--Write a query that returns one city that has the highest sum of 
--invoice totals.Return both city name and sum of all invoice totals.
select sum(total) as invoice_total_of_city ,billing_city from invoice group by(billing_city) order by(invoice_total_of_city) desc limit 1;
-- 	Who is the best customer?The customer who has spent the most wil be declared as the best customer.
select sum(total) as invoice_total,customer_id,first_name,last_name from customer inner join invoice using(customer_id) group by(customer_id) order by invoice_total desc limit 1;
--Write a query to retrieve the email,first name,last name,& Genre 
--of all Rock music listeners.Return your list ordered alphabetically by email.
select distinct email,first_name,last_name,genre from customer join invoice using(customer_id)  join  invoice_line using(invoice_id) join track using(track_id) join genre using(genre_id) where genre.name like 'Rock' order by(email) ;
--Lets invite the artists who have written the most rock music in 
--our dataset.Write a query that returns the Artist name and 
--track count of the top 10 rock bands.
select artist.name as artist_name,count(track_id) as track_count, genre.name  from track join genre using (genre_id) join album using(album_id) join artist using(artist_id)group by(artist_name,genre.name) having genre.name like 'Rock' order by track_count desc limit 10;
--Return all the track names that have a song length longer than
--the average song length.Return the name and milliseconds 
--for each track.Order by the song length with the longest songs 
--listed first.
select name ,milliseconds from track where milliseconds >(select avg(milliseconds) as avg_length from track) order by(milliseconds) desc;
--Find the amount spent by each customer on artists.
--Write a query to return customer name,artist name and total spent.
select first_name,last_name,sum(total) as invoice_total,artist.name from customer join invoice using(customer_id) join invoice_line using (invoice_id) join track using(track_id) join album using(album_id) join artist using (artist_id) group by(first_name,last_name,artist.name) order by invoice_total desc;

--We want to find out the most popular music Genre for each country.
--We determine the most popular genre as the genre with the highest 
--amount of purchases. Write a query that returns each country along 
--with the top Genre. For countries where the maximum number of 
--purchases is shared return all Genres.
WITH top_most_genre as (select billing_country,count(quantity) as quantity_count,genre.name,dense_rank() over (partition by billing_country order by count(quantity)desc) as rank_no from invoice join invoice_line using(invoice_id) join track using(track_id) join genre using(genre_id) group by(billing_country,genre.name)) SELECT *FROM top_most_genre WHERE rank_no<=1 ORDER BY 1 ASC,2 DESC;


-- Write a query that determines the customer that has spent the 
--most on music for each country. Write a query that returns the 
--country along with the top customer and how much they spent. 
--For countries where the top amount spent is shared, provide all 
--customers who spent this amount
with top_most_customer as (select customer_id,first_name,last_name,sum(total) as amount_spent,billing_country,dense_rank() over (partition by billing_country order by sum(total)desc) as rank_no from customer join invoice using(customer_id)group by(customer_id,billing_country) ) select * from top_most_customer where rank_no<=1 order by billing_country asc,amount_spent desc;