-- 1
use shop;
DROP TABLE IF EXISTS users;
CREATE TABLE users ( 
  id SERIAL PRIMARY KEY,   
  name VARCHAR(255) COMMENT 'Имя покупателя',   
  birthday_at DATE COMMENT 'Дата рождения',   
  created_at DATETIME,  
  updated_at DATETIME 
  ) COMMENT = 'Покупатели',  ENGINE=MyISAM DEFAULT CHARSET=cp1251;
  
INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');

update users 
set created_at = now(), updated_at = now() 
where id <> 1;

-- 2
DROP TABLE IF EXISTS users;
CREATE TABLE users (  
 id SERIAL PRIMARY KEY, 
 name VARCHAR(255) COMMENT 'Имя покупателя',  
 birthday_at DATE COMMENT 'Дата рождения', 
 created_at VARCHAR(255),  
 updated_at VARCHAR(255)
 ) COMMENT = 'Покупатели',  ENGINE=MyISAM DEFAULT CHARSET=cp1251;

INSERT INTO users (name, birthday_at, created_at, updated_at) 
VALUES   ('Геннадий','1998-10-10', '05.10.2016 12:07','05.10.2016 12:07'),  
 ('Наталья', '1990-05-17','12.11.2017 19:43','12.11.2017 19:43'),  
 ('Александр', '1999-07-09', '20.05.2016 13:07', '20.05.2016 13:07'),  
 ('Сергей', '1988-04-30', '14.02.2015 16:57','14.02.2015 16:57'),
 ('Иван', '1998-09-09','12.01.2016 11:11', '12.01.2016 11:11'),  
 ('Мария', '1991-11-21', '29.08.2017 01:01','29.08.2017 01:01');


update users
 set created_at = str_to_date(created_at, '%d.%m.%Y %k:%i'), updated_at = str_to_date(updated_at, '%d.%m.%Y %k:%i') 
 where id<>0;

alter table users 
change created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;

alter table users
 change updated_at updated_ad DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
 
 
 -- 3
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (  
 id SERIAL PRIMARY KEY,  
 storehouse_id INT UNSIGNED,  
 product_id INT UNSIGNED,  
 value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',  
 created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
 updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
 ) COMMENT = 'Запасы на складе',  ENGINE=MyISAM DEFAULT CHARSET=cp1251;
 
 
 
insert into storehouses_products(storehouse_id, product_id, value) 
values (1,445,0),
 (1,559,60), 
 (1,899,90),
 (1,896,10), 
 (1,405,0), 
 (1,765,98);
 
 
select *
 from storehouses_products 
 order by if(value > 0, 0,1), value;
 
 
 -- 4
select name, date_format(birthday_at, '%M') AS month 
from users 
where date_format(birthday_at, '%M') in ('may','april');

-- 5
select * 
from catalogs
 where id in (1,5,2) 
 order by field(id,5,1,2);
 
 -- 1
select AVG(timestampdiff(YEAR, birthday_at, now())) 
from users;

-- 2
select date_format(date(concat_ws('-', year(now()), month(birthday_at), DAY(birthday_at))), '%W') AS days, count(*) AS total 
from users
 group by days 
 order by total desc;
 
 
 -- 3
select ROUND(EXP(SUM(LN(id)))) 
from catalogs;
