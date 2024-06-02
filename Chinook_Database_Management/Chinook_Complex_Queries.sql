use chinook;

-- Find the track names that have a song length longer than the average song length

SELECT 
    name, milliseconds
FROM
    track
WHERE
    milliseconds > (SELECT 
            AVG(milliseconds) AS avg_track_length
        FROM
            track)
ORDER BY milliseconds DESC;

-- Find the total number of invoices and the average invoice total for each billing country, only for countries with more than 15 invoices

SELECT 
    billingcountry,
    COUNT(invoiceId) AS total_invoices,
    ROUND(AVG(Total), 2) AS Avg_invoice_total
FROM
    invoice
GROUP BY billingcountry
HAVING total_invoices > 15
ORDER BY total_invoices DESC;

-- List all customers who have purchased tracks from multiple genres.

SELECT 
    CONCAT(a.firstName, ' ', a.lastName) AS full_name
FROM
    customer a
        INNER JOIN
    invoice b ON a.customerId = b.customerId
        INNER JOIN
    invoiceline c ON b.invoiceId = c.invoiceId
        INNER JOIN
    track d ON c.trackid = d.trackid
        INNER JOIN
    genre e ON e.genreid = e.genreid
GROUP BY a.customerid
HAVING COUNT(DISTINCT e.genreId) > 1;

-- Identify the total sales amount for each genre.

SELECT 
    a.genreid, a.name, SUM(c.quantity * b.unitprice) as total_sales
FROM
    genre a
        INNER JOIN
    track b USING (genreid)
        INNER JOIN
    invoiceline c USING (trackid)
GROUP BY a.name , a.genreid;

-- Find the top 10 most purchased tracks

SELECT 
    track.Name, COUNT(invoiceline.trackid) AS totalpurchases
FROM
    track
        INNER JOIN
    invoiceline ON track.trackid = invoiceline.trackid
GROUP BY track.Name
ORDER BY totalpurchases DESC
LIMIT 10;

--  Find the top 3 customers who have spent the most in each country.

with cte as (
	select 
		customerid, firstname,totalspent, country,rank() over (partition by country order by totalspent desc) as countryrank 
	from (select a.customerid,a.firstname,a.country,sum(b.total) as totalspent from customer a inner join invoice b using(customerid) 
			group by customerid) as abc)

select * from cte where countryrank<=3;

-- List all artists who have albums with tracks longer than the average track length across all albums

SELECT 
    artistId, name
FROM
    artist
WHERE
    artist.artistid IN (SELECT DISTINCT
            album.artistid
        FROM
            album
                JOIN
            track ON album.albumid = track.albumid
        WHERE
            milliseconds > (SELECT 
                    AVG(milliseconds)
                FROM
                    track));

-- Find the average number of tracks per album for each genre, sorted by the genre with the highest average first.

SELECT 
    genre.name AS genre, cast(AVG(trackcount) as float) AS avg_tracks_per_album
FROM
    genre
        LEFT JOIN
    (SELECT 
        album.albumid, COUNT(track.trackId) AS trackcount
    FROM
        album
    LEFT JOIN track ON album.albumid = track.albumid
    GROUP BY album.albumid) AS albumtrackcounts ON genre.genreid = albumtrackcounts.albumid
GROUP BY genre.genreid
ORDER BY avg_tracks_per_album DESC;