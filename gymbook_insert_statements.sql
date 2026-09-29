use GymBook;


-- members inserts
insert into members (full_name, email, phone, join_date)
values( 'matthew page', 'matthew.caleb.page@gmail.com', '07517534552' , '2026-06-23');

insert into members (full_name, email, phone, join_date)
values( 'jon snow', 'jon.snow@gmail.com', '07517534553' , '2026-06-12');


insert into members (full_name, email, phone, join_date)
values( 'ned stark', 'ned.stark@hotmail.com', '07702779267' , '2023-02-20');


insert into members (full_name, email, phone, join_date)
values( 'jaime lannister', 'jaime.lannister@outlook.com', '07702779260' , '2023-08-24');


insert into members (full_name, email, phone, join_date)
values( 'cersei lannister', 'cersei.lannister@outlook.com', '07702779269' , '2023-08-24');


-- instructors inserts
insert into Instructors (full_name, speciality, bio)
values('hange zoe', 'cardio', 'leader of the scouts, likes titans');


insert into Instructors (full_name, speciality, bio)
values('levi ackermann', 'plyometrics', 'humanitys strongest soldier');

insert into Instructors (full_name, speciality, bio)
values('eddie hall', 'powerlifting', 'worlds strongest man');



-- rooms inserts

insert into Rooms(room_name, capacity)
values('weight room 1' , 50);

insert into Rooms(room_name, capacity)
values('cardio room 1' , 25);

insert into Rooms(room_name, capacity)
values('plyometrics room 1' , 10);

insert into Rooms(room_name, capacity)
values('powerlifting room 1' , 20);


-- EQUIPMENT INSERTS

insert into Equipment(equipment_name, category, room_id)
values('treadmill 1' , 'cardio' , 2);

insert into Equipment(equipment_name, category, room_id)
values('treadmill 2' , 'cardio' , 2);

insert into Equipment(equipment_name, category, room_id)
values('treadmill 3' , 'cardio' , 2);

insert into Equipment(equipment_name, category, room_id)
values('exercise bike 1' , 'cardio' , 2);

insert into Equipment(equipment_name, category, room_id)
values('exercise bike 2' , 'cardio' , 2);


insert into Equipment(equipment_name, category, room_id)
values('lat pulldown 1' , 'weights' , 1);

insert into Equipment(equipment_name, category, room_id)
values('lat pulldown 2' , 'weights' , 1);

insert into Equipment(equipment_name, category, room_id)
values('pec fly 1' , 'weights' , 1);

insert into Equipment(equipment_name, category, room_id)
values('pec fly 2' , 'weights' , 1);

insert into Equipment(equipment_name, category, room_id)
values('cables 1' , 'weights' , 1);

insert into Equipment(equipment_name, category, room_id)
values('cables 2' , 'weights' , 1);

insert into Equipment(equipment_name, category, room_id)
values('resistance bands' , 'plyos' , 3);

insert into Equipment(equipment_name, category, room_id)
values('squat rack A' , 'Powerlifting' , 4);

insert into Equipment(equipment_name, category, room_id)
values('squat rack B' , 'Powerlifting' , 4);

insert into Equipment(equipment_name, category, room_id)
values('squat rack C' , 'Powerlifting' , 4);

insert into Equipment(equipment_name, category, room_id)
values('Smith machine A' , 'Powerlifting' , 4);

insert into Equipment(equipment_name, category, room_id)
values('Smith machine B' , 'Powerlifting' , 4);


-- sessions inserts : A session is any bookable event — a class, an equipment slot, or a PT session. The session_type column distinguishes between them.

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('PT' , 'Advanced powerlifting' , 3, 4, '2026-06-24 15:00:00', '2026-06-24 16:30:00', 1, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Class' , 'Intense cardio' , 1, 2, '2026-06-28 15:00:00', '2026-06-28 16:00:00', 5, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Equipment' , 'Squat rack B - open slot' , null, null, '2026-06-28 15:00:00', '2026-06-28 16:00:00', 1, 'active');



insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Class' , 'Intense cardio 2' , 1, 2, '2026-06-28 15:00:00', '2028-06-28 16:00:00', 5, 'active');


insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('PT' , 'Advanced powerlifting' , 3, 4, '2028-06-24 15:00:00', '2026-06-24 16:30:00', 1, 'active');


insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Equipment' , 'Squat rack B - open slot' , null, null, '2026-06-28 15:00:00', '2028-06-28 16:00:00', 1, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('PT', 'Advanced powerlifting', 3, 4,
       DATEADD(YEAR, 5, GETDATE()),
       DATEADD(MINUTE, 90, DATEADD(YEAR, 5, GETDATE())),
       1, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Class', 'Intense cardio', 1, 2,
       DATEADD(YEAR, 5, GETDATE()),
       DATEADD(HOUR, 1, DATEADD(YEAR, 5, GETDATE())),
       5, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Equipment', 'Squat rack B - open slot', null, null,
       DATEADD(YEAR, 5, GETDATE()),
       DATEADD(HOUR, 1, DATEADD(YEAR, 5, GETDATE())),
       1, 'active');

update sessions
set start_time = '2028-06-28 15:00:00' where session_id = 1004;


insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Class', 'Beginner cardio', 1, 2,
       DATEADD(HOUR, 9, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
       DATEADD(HOUR, 10, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
       10, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('PT', 'Plyometrics intro', 2, 3,
       DATEADD(HOUR, 11, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
       DATEADD(HOUR, 12, CAST(DATEADD(DAY, 2, CAST(GETDATE() AS DATE)) AS DATETIME)),
       1, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Class', 'Powerlifting fundamentals', 3, 4,
       DATEADD(HOUR, 17, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
       DATEADD(HOUR, 18, CAST(DATEADD(DAY, 3, CAST(GETDATE() AS DATE)) AS DATETIME)),
       8, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Equipment', 'Treadmill 1 - open slot', null, 2,
       DATEADD(HOUR, 7, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
       DATEADD(HOUR, 8, CAST(DATEADD(DAY, 1, CAST(GETDATE() AS DATE)) AS DATETIME)),
       1, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Class', 'HIIT circuit', 2, 3,
       DATEADD(HOUR, 18, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
       DATEADD(HOUR, 19, CAST(DATEADD(DAY, 4, CAST(GETDATE() AS DATE)) AS DATETIME)),
       6, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('PT', 'One-to-one strength coaching', 3, 4,
       DATEADD(HOUR, 14, CAST(DATEADD(DAY, 6, CAST(GETDATE() AS DATE)) AS DATETIME)),
       DATEADD(HOUR, 15, CAST(DATEADD(DAY, 6, CAST(GETDATE() AS DATE)) AS DATETIME)),
       1, 'active');


insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Class', 'Beginner cardio', 1, 2,
       DATEADD(YEAR, 20, GETDATE()),
       DATEADD(HOUR, 1, DATEADD(YEAR, 20, GETDATE())),
       10, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('PT', 'Plyometrics intro', 2, 3,
       DATEADD(YEAR, 20, GETDATE()),
       DATEADD(HOUR, 1, DATEADD(YEAR, 20, GETDATE())),
       1, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Class', 'Powerlifting fundamentals', 3, 4,
       DATEADD(YEAR, 20, GETDATE()),
       DATEADD(HOUR, 1, DATEADD(YEAR, 20, GETDATE())),
       8, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Equipment', 'Treadmill 1 - open slot', null, 2,
       DATEADD(YEAR, 20, GETDATE()),
       DATEADD(HOUR, 1, DATEADD(YEAR, 20, GETDATE())),
       1, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('Class', 'HIIT circuit', 2, 3,
       DATEADD(YEAR, 20, GETDATE()),
       DATEADD(HOUR, 1, DATEADD(YEAR, 20, GETDATE())),
       6, 'active');

insert into Sessions(session_type, title, instructor_id, room_id, start_time, end_time, capacity, status)
values('PT', 'One-to-one strength coaching', 3, 4,
       DATEADD(YEAR, 20, GETDATE()),
       DATEADD(HOUR, 1, DATEADD(YEAR, 20, GETDATE())),
       1, 'active');

-- session_equipment inserts - junction table for session and equipment

insert into Session_Equipment(session_id, equipment_id)
values(1,13);

insert into Session_Equipment(session_id, equipment_id)
values(1,16);

insert into Session_Equipment(session_id, equipment_id)
values(2,1);

insert into Session_Equipment(session_id, equipment_id)
values(2,2);

insert into Session_Equipment(session_id, equipment_id)
values(2,3);

insert into Session_Equipment(session_id, equipment_id)
values(2,4);

insert into Session_Equipment(session_id, equipment_id)
values(2,5);


insert into Session_Equipment(session_id, equipment_id)
values(3,14);


insert into Session_Equipment(session_id, equipment_id)
values(1002,1);

insert into Session_Equipment(session_id, equipment_id)
values(1002,2);

insert into Session_Equipment(session_id, equipment_id)
values(1002,3);

insert into Session_Equipment(session_id, equipment_id)
values(1002,4);

insert into Session_Equipment(session_id, equipment_id)
values(1002,5);

insert into Session_Equipment(session_id, equipment_id)
values(1003,13);

insert into Session_Equipment(session_id, equipment_id)
values(1003,16);

insert into Session_Equipment(session_id, equipment_id)
values(1004,14);

-- bookings insertions

insert into Bookings(session_id, member_id, booked_at, status)
values(1,2,'2026-06-20 10:00:00','confirmed');


insert into Bookings(session_id, member_id, booked_at, status)
values(2,2,'2026-06-20 10:10:00','confirmed');

insert into Bookings(session_id, member_id, booked_at, status)
values(2,5,'2026-06-20 10:15:00','confirmed');

insert into Bookings(session_id, member_id, booked_at, status)
values(2,6,'2026-06-20 12:15:00','confirmed');


insert into Bookings(session_id, member_id, booked_at, status)
values(2,7,'2026-06-20 11:15:00','confirmed');


insert into Bookings(session_id, member_id, booked_at, status)
values(3,1,'2026-06-20 11:15:00','confirmed');

insert into Bookings(session_id, member_id, booked_at, status)
values(1004,1,'2026-07-03 11:15:00','confirmed');


insert into Bookings(session_id, member_id, booked_at, status)
values(1002,1,'2026-07-03 11:15:00','cancelled');


insert into Bookings(session_id, member_id, booked_at, status)
values(1007,1,getdate(),'confirmed');

-- waitlist insertions

insert into Waitlist(session_id, member_id, joined_at, position)
values(1, 5, '2026-06-21 15:00:00', 1);

insert into Waitlist(session_id, member_id, joined_at, position)
values(1, 6, '2026-06-22 16:00:00', 2);

insert into Waitlist(session_id, member_id, joined_at, position)
values(3, 6, '2026-06-22 16:00:00', 1);






select * from Members;
select * from Instructors;
select * from Rooms;

--select * from Equipment;
select * from Sessions;
select * from Session_Equipment;
select * from Bookings;
select * from Waitlist;

