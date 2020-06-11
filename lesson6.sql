use vk;
-- 2
select * from users
 where id = (select to_user_id from messages where to_user_id 
				in (select target_user_id from friend_requests where initiator_user_id = 1 and `status` = 'approved'
						union
					select initiator_user_id from friend_requests where target_user_id = 1 and `status` = 'approved') order by to_user_id asc limit 1);




-- 3 Пыталась через in, но он не пускает limit без join...  придумать альтернативу не смогла...
select count(id) from likes_users where likedUsers_id in (select user_id from `profiles` order by timestampdiff(YEAR, birthday, now()) asc limit 10);

select user_id, timestampdiff(YEAR, birthday, now()) from `profiles` order by timestampdiff(YEAR, birthday, now()) asc;



select user_id from `profiles` order by timestampdiff(YEAR, birthday, now()) asc limit 10 offset 0;



-- 4

-- Есть два варианта запроса(но оба выглядят не очень хорошо). Первый выводит максимальное число, но не пишет кто выиграл

select if(
((select count(id) from likes_media where user_id in (select user_id from `profiles` where gender = 'w')) +
(select count(id) from likes_users where likingUsers_id in (select user_id from `profiles` where gender = 'w')) +     -- подсчет лайков женщин
(select count(id) from likes_posts where user_id in (select user_id from `profiles` where gender = 'w')))
>
((select count(id) from likes_media where user_id in (select user_id from `profiles` where gender = 'm')) +
(select count(id) from likes_users where likingUsers_id in (select user_id from `profiles` where gender = 'm')) +      -- подсчет лайков мужчин
(select count(id) from likes_posts where user_id in (select user_id from `profiles` where gender = 'm'))),
((select count(id) from likes_media where user_id in (select user_id from `profiles` where gender = 'w')) +
(select count(id) from likes_users where likingUsers_id in (select user_id from `profiles` where gender = 'w')) +
(select count(id) from likes_posts where user_id in (select user_id from `profiles` where gender = 'w'))),
((select count(id) from likes_media where user_id in (select user_id from `profiles` where gender = 'm')) +
(select count(id) from likes_users where likingUsers_id in (select user_id from `profiles` where gender = 'm')) +
(select count(id) from likes_posts where user_id in (select user_id from `profiles` where gender = 'm')))) AS maximum;


-- Второй выводит в таблицу количество лайков женщин и мужчин в разные колонки. Чтобы выводил только у кого максимальное количество, не смогла сделать..

select
((select count(id) from likes_media where user_id in (select user_id from `profiles` where gender = 'w')) +
(select count(id) from likes_users where likingUsers_id in (select user_id from `profiles` where gender = 'w')) +
(select count(id) from likes_posts where user_id in (select user_id from `profiles` where gender = 'w'))) as women,
((select count(id) from likes_media where user_id in (select user_id from `profiles` where gender = 'm')) +
(select count(id) from likes_users where likingUsers_id in (select user_id from `profiles` where gender = 'm')) +
(select count(id) from likes_posts where user_id in (select user_id from `profiles` where gender = 'm'))) as men;


-- 5 Получилось вывести только id пользователя... Пыталась через in вывести данные пользователя, но limit не разрешает добавить без join... Ничего другого не смогла придумать..
select user_id from (
select user_id, count(*) from media group by user_id
union
select user_id, count(*) from users_communities group by user_id
union
select from_user_id as user_id, count(*) from messages group by from_user_id
union
select to_user_id as user_id, count(*) from messages group by to_user_id
union
select likedUsers_id as user_id, count(*) from likes_users group by likedUsers_id
union
select likingUsers_id as user_id, count(*) from likes_users group by likingUsers_id
union
select user_id, count(*) from likes_posts group by user_id
union
select user_id, count(*) from likes_media group by user_id
union
select initiator_user_id as user_id, count(*) from friend_requests group by initiator_user_id
union
select target_user_id as user_id, count(*) from friend_requests group by target_user_id) as a group by user_id order by count(*) asc limit 10; 



