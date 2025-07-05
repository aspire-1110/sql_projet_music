-------------------------------------------------------set (01)---------------------------------------------------------------------------------------

--Q1: Who is the senior most employee based on job title?

select top 1 * from employee
order by levels desc;

--Q2: Which countries have the most Invoices?

select top 1 billing_country, COUNT(1) as billing_country_count
from invoice
group by billing_country 
order by billing_country_count desc;

--Q3: What are top 3 values of total invoice

select top 3 total
from invoice
order by total desc;

--Q4: Which city has the best customers? We would like to throw a promotional Music Festival
--in the city we made the most money. Write a query that returns one city that has the highest
--sum of invoice totals. Return both the city name & sum of all invoice totals

select * from invoice;

select top 1 SUM(total) as invoice_total, billing_city
from invoice
group by billing_city
order by invoice_total desc;

--Q4: Who is the best customer? The customer who has spent the most money will be declared
--the best customer.Write a query that returns the person who has spent the most money.

select * from customer;
select * from invoice;

select top 1 c.customer_id, c.first_name, c. last_name, SUM(total) as invoice_total from invoice i
left join customer c on c.customer_id=i.customer_id
group by c.customer_id, c.first_name, c. last_name
order by invoice_total desc;

-------------------------------------------------------set (02)---------------------------------------------------------------------------------------

--Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners.
--Return your list ordered alphabetically by email starting with A

select * from customer;
select * from genre;
select * from track;

with ctea as
(
select c.email, c.first_name, c.last_name, il.track_id
from customer c
inner join invoice i on c.customer_id=i.customer_id
inner join invoice_line il on il.invoice_id=i.invoice_id
)
, cteb as
(select t.track_id, g.genre_id, g.name as genre_name from track t
inner join genre g on t.genre_id=g.genre_id
where g.name='rock')

select distinct (ctea.email) , ctea.first_name, ctea.last_name, cteb.genre_name from ctea
inner join cteb on ctea.track_id=cteb.track_id
order by ctea.email;

--Q2: Let's invite the artists who have written the most rock music in our dataset.
--Write a query that returns the Artist name and total track count of the top 10 rock bands

select * from artist;
select * from track;
select * from genre;
select * from album;

select top 10 ar.artist_id, ar.name, count(t.track_id) as total_track
from track t 
join album al on t.album_id=al.album_id
join artist ar on ar.artist_id=al.artist_id
join genre g on g.genre_id=t.genre_id
group by ar.artist_id, ar.name
order by total_track desc;

--Q3: Return all the track names that have a song length longer than the average song length.
--Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

select * from track

select avg(Milliseconds) from track;

select track_id, name, Milliseconds
from track
where Milliseconds>393599.212103911
order by Milliseconds desc

select track_id, name, Milliseconds
from track
where Milliseconds>(select avg(Milliseconds) from track)
order by Milliseconds desc

-------------------------------------------------------set (03)---------------------------------------------------------------------------------------

--Q1: Find how much amount spent by each customer on artists?
--Write a query to return customer name, artist name and total spent.

select * from invoice;
select * from invoice_line;
select * from customer;
select * from artist;

select customer.customer_id, first_name, last_name, artist.name, SUM(total) as amount_spent
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on track.track_id=invoice_line.track_id
join album on album.album_id=track.album_id
join artist on artist.artist_id=album.artist_id
group by customer.customer_id, first_name, last_name,artist.name

order by customer.customer_id,name;

--Q2: We want to find out the most popular music Genre for each country.
--We determine the most popular genre as the genre with the highest amount of purchases.
--Write a query that returns each country along with the top Genre. For countries where
--the maximum number of purchases is shared return all Genres.

select * from genre
select * from track
select * from invoice_line
select * from invoice
select * from customer

with final as
(
select customer.country, genre.genre_id, genre.name, count(invoice_line.quantity) as total_invoice,
row_number() over (partition by customer.country order by count(invoice_line.quantity) desc) as rn
from invoice_line
join invoice on invoice.invoice_id=invoice_line.invoice_id
join customer on customer.customer_id=invoice.customer_id
join track on  invoice_line.track_id=track.track_id
join genre on genre.genre_id=track.genre_id
group by customer.country,genre.genre_id, genre.name
)
select * from final where rn<=1;


with final as
(
select customer.country, genre.genre_id, genre.name, count(invoice_line.quantity) as total_invoice,
row_number() over (partition by customer.country order by count(invoice_line.quantity) desc) as rn
from customer
join invoice on customer.customer_id=invoice.customer_id
join invoice_line on invoice_line.invoice_id=invoice.invoice_id
join track on  invoice_line.track_id=track.track_id
join genre on genre.genre_id=track.genre_id
group by customer.country,genre.genre_id, genre.name
)
select * from final where rn<=1;

--Q3: Write a query that determines the customer that has spent the most on music for each country.
--Write a query that returns the country along with the top customer and how much they spent.
--For countries where the top amount spent is shared, provide all customers who spent this amount.

with finalcte as
(
select customer.first_name, customer.last_name, customer.country, customer.customer_id, SUM(invoice.total) total_spend,
ROW_NUMBER() over (partition by country order by SUM(invoice.total)) as rownumber
from customer
join invoice on customer.customer_id=invoice.customer_id
group by customer.first_name, customer.last_name, customer.country, customer.customer_id
)
select * from finalcte
where rownumber='1';






