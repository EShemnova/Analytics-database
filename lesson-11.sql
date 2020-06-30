-- Оптимизация запросов
-- 1

use shop;




DROP TABLE if EXISTS logs;
Create TABLE logs(
 created_at datetime not null,
 `table` varchar (50) not null,
 id bigint not null,
 name varchar(255) not null
) engine = Archive ;



DROP TRIGGER IF EXISTS logs_users;
delimiter //
CREATE TRIGGER logs_users AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at,`table`, id, name)
	VALUES (NOW(), 'users', NEW.id, NEW.name);
END //
delimiter ;

DROP TRIGGER IF EXISTS logs_catalogs;
delimiter //
CREATE TRIGGER logs_catalogs AFTER INSERT ON catalogs
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at,`table`, id, name)
	VALUES (NOW(), 'catalogs', NEW.id, NEW.name);
END //
delimiter ;

DROP TRIGGER IF EXISTS logs_products;
delimiter //
CREATE TRIGGER logs_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs (created_at,`table`, id, name)
	VALUES (NOW(), 'products', NEW.id, NEW.name);
END //
delimiter ;




-- 2



use shop;

DROP PROCEDURE IF EXISTS insert_users ;
delimiter //
CREATE PROCEDURE insert_users ()
BEGIN
	DECLARE i INT DEFAULT 1000000;
	DECLARE j INT DEFAULT 1;
	WHILE i > 0 DO
		INSERT INTO users(name) VALUES (CONCAT('user_', j));
		SET j = j + 1;
		SET i = i - 1;
	END WHILE;
END //
delimiter ;

call insert_users();

select * from users;


