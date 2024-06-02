
-- 2a
select count(*) as total_count from passenger where gender = 'F' and distance >=600 ;
-- 2b
select * from passenger where distance > 500 and bus_type = 'sleeper';
-- 2c
select * from passenger where passenger_name like 'S%';
-- 2d
select passenger.passenger_name, passenger.boarding_city, passenger.destination_city, passenger.bus_type, price.price from passenger, price where passenger.distance = price.distance;
-- 2e
SELECT passenger.passenger_name, price.price from passenger, price where passenger.distance = 1000 and passenger.bus_type = 'Sitting';
-- 2f
select  passenger.passenger_name, price.price, price.distance, price.bus_type from passenger , price where price.bus_type in ('Sleeper','Sitting')  and passenger.passenger_name = 'Pallavi' and price.distance=(select distance from passenger where boarding_city='Panaji' and destination_city='Bengaluru');

-- 2g
update passenger set category = 'NON-AC' where bus_type = 'Sleeper';
select * from passenger;
-- 2h
delete from passenger where passenger_name = 'Piyush';
commit;
select * from passenger;
-- 2i
truncate table passenger;
select * from passenger;
-- 2j
drop table passenger;
