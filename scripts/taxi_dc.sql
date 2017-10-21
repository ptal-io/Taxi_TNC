-- create table for storing data
CREATE TABLE taxi_dc_2016 (
	oid varchar(42),
	triptype varchar(275),	   
	provider varchar(275),  
	meterfare varchar(275),
	tip varchar(275),
	surcharge varchar(275),
	extras varchar(275),
	tolls varchar(275),
	totalamount varchar(275), 
	paymenttype varchar(275),
	paymentcardprovider varchar(275),
	pickupcity varchar(275),
	pickupstate varchar(275),
	pickupzip varchar(275),
	dropoffcity varchar(275),
	dropoffstate varchar(275),
	dropoffzip varchar(275),
	tripmileage varchar(275),
	triptime varchar(275),
	pu_lat varchar(275), 
	pu_lng varchar(275),
	pu_blockname varchar(275), 
	do_lat varchar(275), 
	do_lng varchar(275),
	do_blockname varchar(275),
	airport varchar(275),
	pu_datetime varchar(275) default '',
	do_datetime varchar(275) default ''
);

-- php cleanTaxi.php taxi_201703.txt taxi_201703_clean.txt
-- load data into postgres table
copy taxi_dc from '/home/mckenzieg/data/taxi/taxi_201701_clean.txt' with csv header delimiter as '|';
copy taxi_dc from '/home/mckenzieg/data/taxi/taxi_201702_clean.txt' with csv header delimiter as '|';
copy taxi_dc from '/home/mckenzieg/data/taxi/taxi_201703_clean.txt' with csv header delimiter as '|';

-- first pass on removing empty records
delete from taxi_dc where pu_lat is null and do_lat is null;

-- change text timestamps to real database timestamps
alter table taxi_dc add column do_ts timestamp without time zone;
update taxi_dc set do_ts = do_datetime::timestamp without time zone;
alter table taxi_dc add column pu_ts timestamp without time zone;
update taxi_dc set pu_ts = pu_datetime::timestamp without time zone;

-- UPDATE LAT/LNG TO FLOAT8 vals.
alter table taxi_dc add column pu_latd double precision;
alter table taxi_dc add column pu_lngd double precision;
alter table taxi_dc add column do_latd double precision;
alter table taxi_dc add column do_lngd double precision;

-- do some funky data cleaning on update
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

-- ONLY KEEP RECORDS THAT HAVE PU AND DO LOCATIONS
delete from taxi_dc where pu_latd is null;
delete from taxi_dc where pu_lngd is null;
delete from taxi_dc where do_latd is null;
delete from taxi_dc where do_lngd is null;
delete from taxi_dc where pu_lngd = -77;
delete from taxi_dc where do_lngd = -77;

-- Update GEOMETRY
alter table taxi_dc add column pu_geom geometry;
alter table taxi_dc add column do_geom geometry;
update taxi_dc set pu_geom = st_setsrid(st_makepoint(pu_lngd, pu_latd),4326);
update taxi_dc set do_geom = st_setsrid(st_makepoint(do_lngd, do_latd),4326);


create table taxi_dc_pu as select oid, pu_ts, pu_geom from taxi_dc;
-- pgsql2shp -f "taxi_dc_pu" taxi public.taxi_dc_pu


-- MISC
--delete from taxi_dc where (length(do_lat) - position('.' in reverse(do_lat)) + 1) <= 10 and (length(do_lat) - position('.' in reverse(do_lat)) + 1) > 4;
--Select do_lat, (length(do_lat) - position('.' in reverse(do_lat)) + 1) from taxi_dc where (length(do_lat) - position('.' in reverse(do_lat)) + 1) > 3
