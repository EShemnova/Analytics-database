use vk;
insert into users (`id`, `firstname`, `lastname`, `email`, `phone`)
values ('101', 'Olav','Shmel','shmel@shhhh.com','839387283928');

insert into users values
('102','Monika','Geler','monika@friends.com','374238293'),
('103','Rachel','Green','rachel@friends.com','8377289320'),
('104','Phoebe','Buffay','phoebe@friends.com','7436637282'),
('105','Joseph','Tribbiani','joseph@friends.com',Null),
('106','Chandler','Bing','chandler@friends.com',NULL),
('107','Ross','Geller','ross@friends.com',NULL);


insert into users
SET
	firstname = 'Jack',
	lastname = 'Geller',
	email = 'jack@mail.ru',
	phone = '84837477483'
;
select 10+40;

select distinct lastname
from users;

select *
from users_communities
where user_id = 3 or community_id = 11;

select *
from friend_requests
where initiator_user_id = 23;

select target_user_id, `status`
from friend_requests
where initiator_user_id = 23;


select *
from users
where id in (102,103,104,105,106);

select * 
from users
limit 6;

select *
from users
limit 6 offset 101;

insert into friend_requests (`initiator_user_id`,`target_user_id`,`status`)
values ('102','103','requested');

insert into friend_requests (`initiator_user_id`,`target_user_id`,`status`)
values ('102','104','requested');

insert into friend_requests (`initiator_user_id`,`target_user_id`,`status`)
values ('102','105','requested');

insert into friend_requests (`initiator_user_id`,`target_user_id`,`status`)
values ('102','106','requested');

insert into friend_requests (`initiator_user_id`,`target_user_id`,`status`)
values ('102','107','requested');



UPDATE friend_requests
SET 
	status = 'declined',
	confirmed_at = now()
WHERE
	initiator_user_id = 102 and target_user_id = 107;
    
    
    
UPDATE users
SET 
	lastname = 'Geller'
WHERE
	id = 102;
    
    
select *
from friend_requests
where initiator_user_id = 98 OR target_user_id = 98;   


delete from friend_requests
where  target_user_id = 98;
    
delete from friend_requests
where initiator_user_id = 98;