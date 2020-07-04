-- Процедура
-- Выводит расписание для нужного рейса на нужной остановке
DROP PROCEDURE IF EXISTS shedule;
delimiter //
create procedure shedule (bus_shelter bigint, route varchar(50))
begin
select bs.id, r.`number`, s.arrival_time from schedule s 
left join bus_shelters bs on s.bus_shelters_id = bs.id
left join transports t on s.transports_id = t.id 
left join routes r on t.route_id = r.id 
	where  bs.id = bus_shelter and r.`number` = route;
end //
delimiter ;


-- Триггер: Водителей без документов добавлять нельзя!
DROP TRIGGER IF EXISTS drivers_check;
delimiter //
create trigger drivers_check BEFORE insert ON profile_drivers
    FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.license_cards_id) OR ISNULL(NEW.passport_id)) THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Trigger Warning! You need to add documents!';
	END IF;
END //
delimiter ;

INSERT INTO `profile_drivers` (`drivers_id`, `firstname`, `lastname`, `email`, `phone`, `gender`, `birthday`, `photo_id`, `hometown`, `license_cards_id`, `passport_id`) VALUES ('101', 'Kristi', 'Dibber', 'keshawn@example.org', '4474968672', NULL, '1991-01-07', '16', NULL, NULL, NULL);



select t.id, count(*) as total from transports t left join drivers d on t.id = d.transport_id group by t.id;

-- Представление
-- расписание автобус - рейс
DROP VIEW IF EXISTS schedules;
create view schedules
as
select bs.id as bus_shelters, r.`number` as routes, s.arrival_time from schedule s 
left join bus_shelters bs on s.bus_shelters_id = bs.id
left join transports t on s.transports_id = t.id 
left join routes r on t.route_id = r.id order by   bs.id,r.`number`, s.arrival_time;

-- Представление
-- рейс - остановка
DROP VIEW IF EXISTS bus_shelters_routes;
create view bus_shelters_routes
as
select bs.id as bus_shelters, bs.address, r.`number` as routes from schedule s
left join bus_shelters bs on s.bus_shelters_id = bs.id
left join transports t on s.transports_id = t.id
left join routes r on t.route_id = r.id;

-- Представление: Расписание для водителя
drop view if exists schedule_drivers;
create view schedule_drivers
as
select pd.firstname, pd.lastname, bs.address, s.arrival_time from drivers d
    left join profile_drivers pd on d.id = pd.drivers_id
    join schedule s on s.transports_id = d.transport_id
    left join bus_shelters bs on s.bus_shelters_id = bs.id;

-- Запрос: На выборку всех остановок для ремонта
select address
from bus_shelters
where  date_construction < NOW() - INTERVAL 5 YEAR order by date_construction;

-- Запрос: На выборку всех автобусов подлежащих осмотру/ремонту
select t.`number` , vf.name  as vehicle_fleet, a.name as area
from transports t
    join vehicle_fleet vf on t.vehicle_fleet_id = vf.id
    join area a on vf.area_id = a.id
where  t.date_operation < NOW() - INTERVAL 10 YEAR order by t.date_operation;

-- Запрос: Какому водителю нужно делать замену прав и для какого транспорта нужен новый водитель
select pd.firstname, pd.lastname, pd.phone, t.`number`
from profile_drivers pd
    left join drivers d on pd.drivers_id = d.id
    left join transports t on d.transport_id = t.id
where pd.license_cards_id  in (select id from license_cards where date_expiration > NOW());

-- Запрос: Какой автопарк перегружен(водителями и транспортом)
select vf.name,sum(sum) as 'sum' from 
(SELECT vehicle_fleet_id, count(*) as 'sum' from transports group by vehicle_fleet_id
 union all
select vehicle_fleet_id, count(*) as 'sum' from drivers group by vehicle_fleet_id) s
    left join vehicle_fleet vf on s.vehicle_fleet_id = vf.id
group by s.vehicle_fleet_id order by sum desc;


