-- 1
use shop;
start transaction;
insert into sample.users (id, `name`)
select id, `name` from shop.users where id = 2;
commit;



-- 2
create view products_catalogs as
select
  p.name as products,
  c.name as catalogs
from
  catalogs as c join products as p
on
  c.id = p.catalog_id;
 
 
 -- 3
 create table `date` (
 created_at datetime
 );
 insert into `date` (created_at) values ( '2018-08-01'), ('2016-08-04'), ('2018-08-16'), ('2018-08-17');
 
 select created_at, if (orders.created_at in( select * from `date`), '1',  '0' ) as availability  from orders where month(created_at) = 8;



-- 4 (Ругается на ключи, когда отключаю все равно ругается)
delete from orders where created_at not in (select created_at from (select * from orders order by created_at desc limit 5) as d) order by created_at;
 

 
 
 
 
 
-- Хранимые процедуры и функции
-- 1
delimiter //
 DROP PROCEDURE IF EXISTS hello//
CREATE PROCEDURE hello ()

BEGIN
	set @time = CURRENT_TIME();
  --  set @greeting = '';
  if (@time >= '06:00:00' and @time < '12:00:00') then (select 'Доброе утро!');   -- @greeting = 'Доброе утро!'
  elseif (@time >= '12:00:00' and @time < '18:00:00') then (select 'Добрый день!'); -- @greeting = 'Добрый день!'
  elseif (@time >= '18:00:00' and @time < '00:00:00') then (select 'Добрый вечер!'); -- @greeting = 'Добрый вечер!'
  else ( select 'Доброй ночи!');
  end if;

END //
delimiter ;
call hello;

-- 2
delimiter //
DROP TRIGGER IF EXISTS NULLTrigger//
CREATE TRIGGER NULLTrigger BEFORE INSERT ON products
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.desription)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'NULL in both fields!';
	END IF;
END //
delimiter ;

INSERT INTO products (name, desription, price, catalog_id)
VALUES (NULL, NULL, 5000, 2); 

INSERT INTO products (name, desription, price, catalog_id)
VALUES ("ASUS 567", NULL, 15000, 12); 

INSERT INTO products (name, desription, price, catalog_id)
VALUES ("ASUS 567", "Классный ноутбук", 15000, 12); 
