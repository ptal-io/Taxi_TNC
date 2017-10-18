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