select *
from zomato_dataset;

create table zomato_dataset_2
like zomato_dataset;

insert into zomato_dataset_2
select *
from zomato_dataset;

select *
from zomato_dataset_2;

-- Data Cleaning

-- Duplicate Rows
with duplicate_cte as
(
select *,
row_number() over(
partition by ID, Delivery_person_ID, Delivery_person_Age, Delivery_person_Ratings, Restaurant_latitude, Restaurant_longitude, Delivery_location_latitude, Delivery_location_longitude, Order_Date, Time_Orderd, Time_Order_picked, Weather_conditions, Road_traffic_density, Vehicle_condition, Type_of_order, Type_of_vehicle, multiple_deliveries, Festival, City, `Time_taken (min)`) as row_num
from zomato_dataset_2
)
select *
from duplicate_cte
where row_num > 1;

-- Data Transformation

update zomato_dataset_2 
set Delivery_person_Ratings = '5'
where Delivery_person_Ratings = '6';

alter table zomato_dataset_2 
modify vehicle_condition VARCHAR(20);

update zomato_dataset_2
set Vehicle_condition = case Vehicle_condition
when 0 then 'Poor'
when 1 then 'Fair'
when 2 then 'Good'
when 3 then 'Excellent'
else 'Unknown'
end;

-- Extreme values

update zomato_dataset_2
set Time_Orderd = '24'
where Time_Orderd = '1';

update zomato_dataset_2
set Time_Order_Picked = '24'
where Time_Order_Picked = '1';

-- NULL VALUES

-- Time of order
delete 
from zomato_dataset_2
where Time_Orderd is null;

-- Delivery partner age
select *
from zomato_dataset_2
where Delivery_person_Age is null

-- Delivery partner rating
select *
from zomato_dataset_2
where Delivery_person_Ratings is null;

alter table zomato_dataset_2
modify column Delivery_person_Ratings varchar(20);

update zomato_dataset_2
set Delivery_person_Ratings = 'Not rated'
where Delivery_person_Ratings is null;

-- Festival
select *
from zomato_dataset_2
where Festival is null;

update zomato_dataset_2
set Festival = 'Unknown'
where Festival is null;

-- City
select *
from zomato_dataset_2
where City is null;

update zomato_dataset_2
set City = 'Unknown'
where City is null;

-- BAD DATA REMOVAL

delete
from zomato_dataset_2
where Time_Orderd like '0.%'
or Time_Order_picked like '0.%';

-- Each person has different age for different order, we cannot identify person's actual age
alter table zomato_dataset_2
drop column Delivery_person_Age;

-- We need to drop multiple deliveries column. We can have multiple deliveries at one location but we need more data to understand it or it can lead to ambiguity.
alter table zomato_dataset_2
drop column multiple_deliveries;

-- Location
delete
from zomato_dataset_2
where Restaurant_latitude < 8;

select Restaurant_latitude
from zomato_dataset_2
where Restaurant_latitude > 37;


select Restaurant_longitude
from zomato_dataset_2
where Restaurant_longitude < 68;

select Restaurant_longitude
from zomato_dataset_2
where Restaurant_longitude > 97;


select Delivery_location_latitude
from zomato_dataset_2
where Delivery_location_latitude < 8;

select Delivery_location_latitude
from zomato_dataset_2
where Delivery_location_latitude > 37;


select Delivery_location_longitude
from zomato_dataset_2
where Delivery_location_longitude < 68;

select Delivery_location_longitude
from zomato_dataset_2
where Delivery_location_longitude > 97;


--

select *
from zomato_dataset_2;

