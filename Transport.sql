DROP database if EXISTS ground_transportation;
create database ground_transportation;
use ground_transportation;

DROP TABLE IF EXISTS routes;
CREATE TABLE routes(
 id SERIAL PRIMARY KEY,
 `number` int,
 vehicle_fleet_id BIGINT UNSIGNED NOT NULL,
  index routs_id(id),                                                                       -- Рейсы
  FOREIGN KEY (vehicle_fleet_id) REFERENCES vehicle_fleet(id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS area;
CREATE TABLE area(
id SERIAL PRIMARY KEY,                                                  -- Районы
`name` varchar(255),
index (id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS vehicle_fleet;
CREATE TABLE vehicle_fleet(
id SERIAL PRIMARY KEY,
name varchar(255),                                                      -- Автопарки(депо)
area_id BIGINT UNSIGNED NOT NULL,
index (id),
FOREIGN KEY (area_id) REFERENCES area(id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


DROP TABLE IF EXISTS type_transport;
CREATE TABLE type_transport(
id SERIAL PRIMARY KEY,                                                   -- Вид транспорта
name varchar(255),
index (id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS transports;
CREATE TABLE transports(
id SERIAL PRIMARY KEY,                                                      -- Транспорт (машины)
`number` varchar(50),
date_manufacture date,
date_operation date,
route_id BIGINT UNSIGNED NOT NULL,
type_transport_id BIGINT UNSIGNED NOT NULL,
index (id),
FOREIGN KEY (route_id) REFERENCES routes(id),
FOREIGN KEY (type_transport_id) REFERENCES type_transport(id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS drivers;
CREATE TABLE drivers(
id SERIAL PRIMARY KEY,
transport_id BIGINT UNSIGNED NOT NULL,                                          -- К каким автобусам прикреплен водитель
vehicle_fleet_id BIGINT UNSIGNED NOT NULL,
index (id),
  FOREIGN KEY (vehicle_fleet_id) REFERENCES vehicle_fleet(id),
  FOREIGN KEY (transport_id) REFERENCES transports(id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS profile_drivers;
CREATE TABLE profile_drivers(
	drivers_id SERIAL PRIMARY KEY,
	firstname VARCHAR(50),
    lastname VARCHAR(50), 
    email VARCHAR(120) UNIQUE,
    phone BIGINT,                                                                  -- Все о водителях
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    hometown VARCHAR(100),
    license_id BIGINT UNSIGNED NULL UNIQUE,  
    passport_id BIGINT UNSIGNED NULL UNIQUE,  
    index (firstname),
    index (lastname),
    FOREIGN KEY (drivers_id) REFERENCES drivers(id), 
	FOREIGN KEY (photo_id) REFERENCES photos(id),
	FOREIGN KEY (license_id) REFERENCES licenses(id), 
	FOREIGN KEY (passport_id) REFERENCES passports(id) 
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS bus_shelters;
CREATE TABLE bus_shelters(
id SERIAL PRIMARY KEY,
`name` varchar(255),
address varchar(255),                                           -- Остановки
date_construction date,
area_id BIGINT UNSIGNED NULL,
index (address),
FOREIGN KEY (area_id) REFERENCES area(id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS transports_shelters;
CREATE TABLE transports_shelters(
	bus_shelters_id BIGINT UNSIGNED NOT NULL,
    routes_id BIGINT UNSIGNED NOT NULL,
	   PRIMARY KEY (bus_shelters_id, routes_id),
	INDEX (bus_shelters_id ),                                             -- Связь остановки и Рейсов
    INDEX (routes_id),
    FOREIGN KEY (bus_shelters_id) REFERENCES bus_shelters(id),
    FOREIGN KEY (routes_id) REFERENCES routes(id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS photos;
CREATE TABLE photos(
id SERIAL PRIMARY KEY,
photo blob,
type_photo varchar(50),                                            -- Фото (водителей)
size int,
index(id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS licenses;
CREATE TABLE licenses(
id SERIAL PRIMARY KEY,
`number` bigint,
date_receipt date,                                                -- Водительские права (отдельно от профиля водителя для безопасности данных)
date_expiration date,
scan blob,
index(`number`),
index(id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;


DROP TABLE IF EXISTS passports;
CREATE TABLE passports(
id SERIAL PRIMARY KEY,
series bigint,
`number` bigint,                                                  --  Паспорта водителей (отдельно от профиля водителя для безопасности данных)
issued varchar(255),
division_code varchar(50),
birthplace varchar(255),
date_receipt date,
scan blob,
index(id)
) ENGINE=MyISAM DEFAULT CHARSET=cp1251;

DROP TABLE IF EXISTS schedule;
CREATE TABLE schedule(
bus_shelters_id BIGINT UNSIGNED NOT NULL,                          -- Расписание (остановка - транспорт) лучше не получилось придумать..
transports_id BIGINT UNSIGNED NOT NULL,
arrival_time time,
PRIMARY KEY (bus_shelters_id,transports_id),
FOREIGN KEY (bus_shelters_id) REFERENCES bus_shelters(id),
    FOREIGN KEY (transports_id) REFERENCES transports(id)
)ENGINE=MyISAM DEFAULT CHARSET=cp1251;

