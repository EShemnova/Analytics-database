-- 1 Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.(Надеюсь правильно поняла задание)
insert into orders (user_id, created_at, updated_at)
values ('2',now(), now()),
		('1',now(), now()),
        ('6',now(), now()),
        ('5',now(), now()),
        ('2',now(), now()),
        ('4',now(), now());
	
insert into orders_products (order_id, product_id, total, created_at, updated_at)
values ('3', '6', '2', now(),now()), 
		('5','2','1', now(),now()),
        ('2','3','1', now(),now()),
        ('2','2','1', now(),now()), 
        ('1','1','6', now(),now()), 
        ('4','5','10', now(),now()), 
        ('6','2', '1', now(),now());
      
      
-- 2 Выведите список товаров products и разделов catalogs, который соответствует товару.

select
  p.name,
  p.price,
  c.name
from
  catalogs as c join products as p
on
  c.id = p.catalog_id;
  
-- 3 Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). 
-- Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
  
create database airport; 

drop table if exists flights;
create table flights (
id SERIAL PRIMARY KEY,
`from` VARCHAR(255),
`to` VARCHAR(255) 
)
ENGINE=MyISAM DEFAULT CHARSET=cp1251;

drop table if exists cities;
create table cities (
label VARCHAR(255),
`name` VARCHAR(255)
)
ENGINE=MyISAM DEFAULT CHARSET=cp1251;

insert into flights (`from`,`to`)
values ('moscow','omsk'),
		('novgorod','kasan'),
        ('irkutsk','moscow'),
        ('omsk','irkutsk'),
        ('moscow','kasan');
        
        
insert into cities (label, `name`)
values ('moscow','Москва'),
		('novgorod','Новгород'),
        ('irkutsk','Иркутск'),
        ('omsk','Омск'),
        ('kasan','Казань');
        
        
 SELECT
f.id, cfrom.name as `from`, cto.name as `to`
FROM
  flights as f
  join cities as cfrom on cfrom.label = f.`from`
 join cities as cto on cto.label = f.`to`
 order by f.id;
  
               
  
