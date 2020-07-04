DROP database if EXISTS ground_transportation;
create database ground_transportation;
use ground_transportation;

DROP TABLE IF EXISTS routes;
CREATE TABLE routes
(
    id               SERIAL PRIMARY KEY,
    `number`         int,
    vehicle_fleet_id BIGINT UNSIGNED NOT NULL,
    index routs_id (id),
    FOREIGN KEY (vehicle_fleet_id) REFERENCES vehicle_fleet (id)
) comment = 'Рейсы',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;

DROP TABLE IF EXISTS area;
CREATE TABLE area
(
    id     SERIAL PRIMARY KEY,
    `name` varchar(255),
    index (id)
) comment = 'Районы',
 ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;

DROP TABLE IF EXISTS vehicle_fleet;
CREATE TABLE vehicle_fleet
(
    id      SERIAL PRIMARY KEY AUTO_INCREMENT,
    name    varchar(255),
    area_id BIGINT UNSIGNED NOT NULL,
    index (id),
    FOREIGN KEY (area_id) REFERENCES area (id)
) comment = 'Автопарки',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;


DROP TABLE IF EXISTS type_transport;
CREATE TABLE type_transport
(
    id   SERIAL PRIMARY KEY,
    name varchar(255),
    index (id)
) comment = 'Вид транспорта',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;

DROP TABLE IF EXISTS transports;
CREATE TABLE transports
(
    id                SERIAL PRIMARY KEY,
    `number`          varchar(50),
    date_manufacture  date,
    date_operation    date,
    route_id          BIGINT UNSIGNED NOT NULL,
    type_transport_id BIGINT UNSIGNED NOT NULL,
    vehicle_fleet_id  BIGINT UNSIGNED NOT NULL,
    index (id),
    FOREIGN KEY (route_id) REFERENCES routes (id),
    FOREIGN KEY (type_transport_id) REFERENCES type_transport (id),
    FOREIGN KEY (vehicle_fleet_id) REFERENCES vehicle_fleet (id)
)  comment = 'Транспорт (машины)',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;


DROP TABLE IF EXISTS drivers;
CREATE TABLE drivers
(
    id               SERIAL PRIMARY KEY AUTO_INCREMENT,
    transport_id     BIGINT UNSIGNED NOT NULL,
    vehicle_fleet_id BIGINT UNSIGNED NOT NULL,
    index (id),
    FOREIGN KEY (vehicle_fleet_id) REFERENCES vehicle_fleet (id),
    FOREIGN KEY (transport_id) REFERENCES transports (id)
) comment = 'Связь водители - транспорт',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;

DROP TABLE IF EXISTS profile_drivers;
CREATE TABLE profile_drivers
(
    drivers_id  SERIAL PRIMARY KEY,
    firstname   VARCHAR(50),
    lastname    VARCHAR(50),
    email       VARCHAR(120) UNIQUE,
    phone       BIGINT,
    gender      CHAR(1),
    birthday    DATE,
    photo_id    BIGINT UNSIGNED NULL,
    hometown    VARCHAR(100),
    license_cards_id  BIGINT UNSIGNED NULL UNIQUE,
    passport_id BIGINT UNSIGNED NULL UNIQUE,
    index (firstname),
    index (lastname),
    FOREIGN KEY (drivers_id) REFERENCES drivers (id),
    FOREIGN KEY (photo_id) REFERENCES photos (id),
    FOREIGN KEY (license_cards_id) REFERENCES license_cards (id),
    FOREIGN KEY (passport_id) REFERENCES passports (id)
) comment = 'Профиль водителя',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;

DROP TABLE IF EXISTS bus_shelters;
CREATE TABLE bus_shelters
(
    id                SERIAL PRIMARY KEY,
    `name`            varchar(255),
    address           varchar(255),
    date_construction date,
    area_id           BIGINT UNSIGNED NULL,
    index (address),
    FOREIGN KEY (area_id) REFERENCES area (id)
) comment = 'Остановки',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;

DROP TABLE IF EXISTS photos;
CREATE TABLE photos
(
    id         SERIAL PRIMARY KEY,
    photo      blob,
    type_photo varchar(50),
    size       int,
    index (id)
) comment = 'Фото(водителей)',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;

DROP TABLE IF EXISTS license_cards;
CREATE TABLE license_cards
(
    id              SERIAL PRIMARY KEY,
    `number`        bigint,
    date_receipt    date,
    date_expiration date,
    scan            blob,
    index (id)
) comment = 'Водительские права',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;


DROP TABLE IF EXISTS passports;
CREATE TABLE passports
(
    id            SERIAL PRIMARY KEY,
    series        bigint,
    `number`      bigint,
    issued        varchar(255),
    division_code varchar(50),
    birthplace    varchar(255),
    date_receipt  date,
    scan          blob,
    index (id)
) comment = 'Паспорта',
 ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;



DROP TABLE IF EXISTS schedule;
CREATE TABLE schedule
(
    bus_shelters_id BIGINT UNSIGNED NOT NULL,
    transports_id   BIGINT UNSIGNED NOT NULL,
    arrival_time    time,
    KEY (bus_shelters_id, transports_id),
    FOREIGN KEY (bus_shelters_id) REFERENCES bus_shelters (id),
    FOREIGN KEY (transports_id) REFERENCES transports (id)
) comment = 'Расписание (остановки - транспорт)',
ENGINE = MyISAM
  DEFAULT CHARSET = cp1251;



