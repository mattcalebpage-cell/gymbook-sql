USE GymBook;

 
-- Members: people who make bookings, identified by email
CREATE TABLE Members (
    member_id   INT PRIMARY KEY IDENTITY(1,1),
    full_name   NVARCHAR(100) NOT NULL,
    email       NVARCHAR(100) NOT NULL UNIQUE,
    phone       NVARCHAR(20) NULL,
    join_date   DATE NOT NULL
);

-- Instructors: staff who lead classes or PT sessions
CREATE TABLE Instructors (
    instructor_id   INT PRIMARY KEY IDENTITY(1,1),
    full_name       NVARCHAR(100) NOT NULL,
    speciality      NVARCHAR(100) NULL,
    bio             NVARCHAR(500) NULL
);

-- Rooms: physical spaces in the gym
CREATE TABLE Rooms (
    room_id     INT PRIMARY KEY IDENTITY(1,1),
    room_name   NVARCHAR(100) NOT NULL,
    capacity    INT NOT NULL
);

-- Equipment: machines/kit members can book (depends on Rooms)
CREATE TABLE Equipment (
    equipment_id    INT PRIMARY KEY IDENTITY(1,1),
    equipment_name  NVARCHAR(100) NOT NULL,
    category        NVARCHAR(50) NOT NULL,
    room_id         INT REFERENCES Rooms(room_id)
);

-- Sessions: any bookable event - class, equipment slot, or PT (depends on Instructors, Rooms, Equipment)
CREATE TABLE Sessions (
    session_id      INT PRIMARY KEY IDENTITY(1,1),
    session_type    NVARCHAR(20) NOT NULL,
    title           NVARCHAR(100) NOT NULL,
    instructor_id   INT REFERENCES Instructors(instructor_id),
    equipment_id    INT REFERENCES Equipment(equipment_id),
    room_id         INT REFERENCES Rooms(room_id),
    start_time      DATETIME NOT NULL,
    end_time        DATETIME NOT NULL,
    capacity        INT NOT NULL,
    status          NVARCHAR(20) NOT NULL
);

-- Bookings: a member's booking for a session (depends on Sessions, Members)
CREATE TABLE Bookings (
    booking_id  INT PRIMARY KEY IDENTITY(1,1),
    session_id  INT REFERENCES Sessions(session_id),
    member_id   INT REFERENCES Members(member_id),
    booked_at   DATETIME NOT NULL,
    status      NVARCHAR(20) NOT NULL
);

-- Waitlist: queue when a session is full (depends on Sessions, Members)
CREATE TABLE Waitlist (
    waitlist_id INT PRIMARY KEY IDENTITY(1,1),
    session_id  INT REFERENCES Sessions(session_id),
    member_id   INT REFERENCES Members(member_id),
    joined_at   DATETIME NOT NULL,
    position    INT NOT NULL
);



CREATE TABLE Session_Equipment (
    session_id      INT REFERENCES Sessions(session_id),
    equipment_id    INT REFERENCES Equipment(equipment_id),
    PRIMARY KEY (session_id, equipment_id)
);

CREATE TABLE WaitlistDetails (
    booking_id  INT PRIMARY KEY REFERENCES Bookings(booking_id),
    position    INT NOT NULL
);



-- tests

SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';

SELECT DB_NAME() AS current_db;

SELECT TABLE_CATALOG, TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME IN ('Members','Instructors','Rooms','Equipment','Sessions','Bookings','Waitlist','Session_Equipment');

