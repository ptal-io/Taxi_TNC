CREATE TABLE taxi_dc (
	oid varchar(42),
	triptype varchar(257),	   
	provider varchar(257),  
	meterfare varchar(257),
	tip varchar(257),
	surcharge varchar(257),
	extras varchar(257),
	tolls varchar(257),
	totalamount varchar(257), 
	paymenttype varchar(257),
	paymentcardprovider varchar(257),
	pickupcity varchar(257),
	pickupstate varchar(257),
	pickupzip varchar(257),
	dropoffcity varchar(257),
	dropoffstate varchar(257),
	dropoffzip varchar(257),
	tripmileage varchar(257),
	triptime varchar(257),
	pu_lat varchar(257), 
	pu_lng varchar(257),
	pu_blockname varchar(257), 
	do_lat varchar(257), 
	do_lng varchar(257),
	do_blockname varchar(257),
	airport varchar(257),
	pu_datetime varchar(257) default '',
	do_datetime varchar(257) default ''
);

-- php cleanTaxi.php taxi_201703.txt taxi_201703_clean.txt

copy taxi_dc from '/home/mckenzieg/data/taxi/taxi_201701_clean.txt' with csv header delimiter as '|';
copy taxi_dc from '/home/mckenzieg/data/taxi/taxi_201702_clean.txt' with csv header delimiter as '|';
copy taxi_dc from '/home/mckenzieg/data/taxi/taxi_201703_clean.txt' with csv header delimiter as '|';


delete from taxi_dc where pu_lat is null and do_lat is null;
alter table taxi_dc add column do_ts timestamp without time zone;
update taxi_dc set do_ts = do_datetime::timestamp without time zone;
alter table taxi_dc add column pu_ts timestamp without time zone;
update taxi_dc set pu_ts = pu_datetime::timestamp without time zone;

-- UPDATE LAT/LNG TO FLOAT8 vals.
alter table taxi_dc add column pu_latd double precision;
alter table taxi_dc add column pu_lngd double precision;
alter table taxi_dc add column do_latd double precision;
alter table taxi_dc add column do_lngd double precision;

update taxi_dc set pu_latd = regexp_replace(split_part(pu_lat, ' ',1), '[^0-9.]', '', 'g')::float8 where char_length(regexp_replace(split_part(pu_lat, ' ',1), '[^0-9.]', '', 'g')) > 1;

delete from taxi_dc where position('.' in pu_lng) != 4;
delete from taxi_dc where pu_lng = '-77.018738.896723';
update taxi_dc set pu_lngd = regexp_replace(split_part(pu_lng, ' ',1), '[^0-9.-]', '', 'g')::float8 where char_length(regexp_replace(split_part(pu_lng, ' ',1), '[^0-9.-]', '', 'g')) > 1;

delete from taxi_dc where position('.' in do_lat) != 3;
delete from taxi_dc where (length(do_lat) - position('.' in reverse(do_lat)) + 1) <= 10 and (length(do_lat) - position('.' in reverse(do_lat)) + 1) > 3;
update taxi_dc set do_latd = regexp_replace(split_part(do_lat, ' ',1), '[^0-9.]', '', 'g')::float8 where char_length(regexp_replace(split_part(do_lat, ' ',1), '[^0-9.]', '', 'g')) > 1;

delete from do_lng from taxi_dc where position('.' in do_lng) != 4;
delete from taxi_dc where (length(do_lng) - position('.' in reverse(do_lng)) + 1) <= 16 and (length(do_lng) - position('.' in reverse(do_lng)) + 1) > 4;
update taxi_dc set do_lngd = regexp_replace(split_part(do_lng, ' ',1), '[^0-9.-]', '', 'g')::float8 where char_length(regexp_replace(split_part(do_lng, ' ',1), '[^0-9.-]', '', 'g')) > 1;

delete from taxi_dc where pu_latd is null;
delete from taxi_dc where pu_lngd is null;

--delete from taxi_dc where (length(do_lat) - position('.' in reverse(do_lat)) + 1) <= 10 and (length(do_lat) - position('.' in reverse(do_lat)) + 1) > 4;
--Select do_lat, (length(do_lat) - position('.' in reverse(do_lat)) + 1) from taxi_dc where (length(do_lat) - position('.' in reverse(do_lat)) + 1) > 3
