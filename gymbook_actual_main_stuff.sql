use GymBook;


-- Get all available bookings
select s.title,s.session_type, r.room_name, i.full_name, s.start_time, s.end_time, s.status,(s.capacity - count(b.session_id)) as 'Available spaces', s.capacity as 'Maximum Capacity'
from Sessions s
left join Instructors i on s.instructor_id = i.instructor_id
left join rooms r on s.room_id = r.room_id
left join bookings b on s.session_id = b.session_id and b.status = 'confirmed'
group by
s.title, s.session_type, r.room_name, i.full_name, s.start_time, s.end_time, s.status, s.capacity  ;


select * from Sessions;

GO

-- =====================================================
-- CreateBooking stored procedure - WORK IN PROGRESS
-- Checks completed so far:
--   1. Session exists
--   2. Session is not in the past
--   3. Session is active (not cancelled)
--   4. Member exists
--   5. Member has not already got a confirmed booking for this session
-- Still to come:
--   6. Capacity check -> insert into Bookings OR Waitlist
-- =====================================================
select * from waitlistdetails;

alter PROCEDURE CreateBooking
    @session_id INT,
    @member_id  INT
AS
BEGIN
    DECLARE @start_time DATETIME, @status NVARCHAR(20), @capacity INT, @count int;

    -- Check 1: fetch session details (also covers "session exists")
    SELECT @start_time = start_time, @status = status, @capacity = capacity
    FROM Sessions
    WHERE session_id = @session_id;
	SELECT @count = COUNT(*) FROM Bookings 
	WHERE session_id = @session_id AND status = 'confirmed';

	DECLARE @maxpos INT;
	SELECT @maxpos = MAX(position) FROM WaitlistDetails w
    join bookings b on w.booking_id = b.booking_id
    where b.session_id = @session_id
	
	SET @maxpos = ISNULL(@maxpos, 0) + 1;


    IF @start_time IS NULL
    BEGIN
        PRINT 'Session does not exist';
        RETURN;
    END

    -- Check 2: session is not in the past
    IF @start_time < GETDATE()
    BEGIN
        PRINT 'Session cannot be in the past';
        RETURN;
    END

    -- Check 3: session is still active
    IF @status != 'active'
    BEGIN
        PRINT 'Session is no longer active';
        RETURN;
    END

    -- Check 4: member exists
    IF NOT EXISTS (SELECT 1 FROM Members WHERE member_id = @member_id)
    BEGIN
        PRINT 'Member doesn''t exist';
        RETURN;
    END

    -- Check 5: member hasn't already got a confirmed booking for this session
    IF EXISTS (
        SELECT 1 FROM Bookings 
        WHERE session_id = @session_id 
          AND member_id = @member_id 
          AND status = 'confirmed'
    )
    BEGIN
        PRINT 'Member has already booked this session';
        RETURN;
    END

	-- Check 6: If session is full, insert into waitlist, else insert into bookings	with status 'confirmed'
	IF @count >= @capacity
	BEGIN
		PRINT 'Session is full, adding to waitlist';
        -- add row to bookings with status = 'waitlist'
		INSERT INTO bookings (session_id, member_id, booked_at, status)
		VALUES (@session_id, @member_id, GETDATE(), 'waitlisted');

        -- capture the booking_id that was just generated
        DECLARE @new_booking_id INT = SCOPE_IDENTITY();

        -- add corresponding row to waitlistdetails
        INSERT INTO waitlistdetails (booking_id, position)
        values (@new_booking_id, @maxpos);

	END
	else
	begin
	Print 'Adding session to bookings';
		insert into bookings(session_id, member_id, booked_at, status)
		values(@session_id, @member_id, getdate(), 'confirmed')
	end
END;
GO



insert into Bookings(session_id, member_id, booked_at, status)
values (1002,7, '2026-06-30 10:00:00', 'confirmed'); 

select * from Bookings;
select * from Sessions;

select * from waitlistdetails;

-- tests for CreateBooking

BEGIN TRAN;

-- test 1: should fail, session doesnt exist
EXEC CreateBooking @session_id = 9999999, @member_id = 2;

-- test 2: should fail, session cant be in the past
EXEC CreateBooking @session_id = 2, @member_id = 2;


-- test 3: should fail, session not active. dont need to do this one

-- test 4 : should fail, member doesnt exist
EXEC CreateBooking @session_id = 1008, @member_id = 20000;

-- test 5: should fail, member has already booked this class

EXEC CreateBooking @session_id = 1007, @member_id = 1;

-- test 6: should pass, inserts into bookings
EXEC CreateBooking @session_id = 1008, @member_id = 6;

-- test 7: should pass, inserts into waitlist 
EXEC CreateBooking @session_id = 1007, @member_id = 2;

-- test 8, should pass, adds a second person into the waitlist
EXEC CreateBooking @session_id = 1007, @member_id = 3;


SELECT * FROM Bookings ORDER BY booking_id DESC;
SELECT * FROM WaitlistDetails ORDER BY booking_id DESC;



-- Once all tests are acting correctly, we can rollback. dont run until then

ROLLBACK;

go
create or alter procedure CancelBooking

@booking_id  int, @member_id int
as 
begin
    declare @session_id int, @start_time datetime, @status NVARCHAR(20), @booked_at datetime , @next_member_id INT, @next_waitlist_id INT;
    select @session_id = session_id , @status = status , @booked_at = booked_at from bookings where booking_id = @booking_id;
    select @start_time = start_time from Sessions join Bookings on Sessions.session_id = Bookings.session_id where booking_id = @booking_id;

    -- Check if booking exists at all
    IF NOT EXISTS (SELECT 1 FROM Bookings WHERE booking_id = @booking_id) 
    BEGIN
        PRINT 'Booking does not exist in booking table';
        RETURN;
    END

    -- Check it belongs to this member
    IF NOT EXISTS (SELECT 1 FROM Bookings WHERE booking_id = @booking_id AND member_id = @member_id)
    BEGIN
        PRINT 'Booking does not belong to this member';
        RETURN;
    END

    -- check session hasnt already happened

    if (@start_time < getdate())
    begin
        print 'session has already happened';
        return;
    end

    -- check the session isnt already cancelled
    if @status = 'cancelled'
    begin
        print 'user has already cancelled their session';
        return;
    end

    print 'all checks passed for cancellation'

    -- change status to cancelled
    -- then check if there are entries for that session in the waitlist table. if yes, move first person up from waitlist 
    -- to booking, then remove their entry from the waitlist table
    DECLARE @promote_booking_id INT;

    IF @status = 'waitlisted'
    BEGIN
        UPDATE Bookings
        SET status = 'cancelled'
        WHERE booking_id = @booking_id;

        DELETE FROM WaitlistDetails
        WHERE booking_id = @booking_id;
    END
    ELSE
    BEGIN
        UPDATE Bookings
        SET status = 'cancelled'
        WHERE booking_id = @booking_id;

        IF EXISTS (SELECT 1 FROM Bookings WHERE session_id = @session_id AND status = 'waitlisted')
        BEGIN
            SELECT TOP 1 @promote_booking_id = b.booking_id
            FROM Bookings b
            JOIN WaitlistDetails w ON b.booking_id = w.booking_id
            WHERE b.session_id = @session_id
            ORDER BY w.position ASC;

            UPDATE Bookings
            SET status = 'confirmed'
            WHERE booking_id = @promote_booking_id;

            DELETE FROM WaitlistDetails
            WHERE booking_id = @promote_booking_id;
            PRINT 'Promoted booking_id ' + CAST(@promote_booking_id AS NVARCHAR(10)) + ' to confirmed';
        END
        ELSE
        BEGIN
            PRINT 'nothing needs to be deleted from waitlist';
        END
    END
end;




go

exec CreateBooking @session_id = 1021, @member_id = 4;

select * from Bookings;
select * from Sessions;
select * from WaitlistDetails;

-- Checks for cancel booking
begin tran;

-- test 1 - check booking exists - should fail
exec CancelBooking @booking_id = 1000000, @member_id = 1;

-- test 2 - check member has supplied the correct memeber id - should fail
exec CancelBooking @booking_id = 1, @member_id = 1;

-- test 3 - check booking hasnt already happened - should fail
exec CancelBooking @booking_id = 1, @member_id = 2;

-- test 4 - check booking isnt already cancelled - should fail
exec CancelBooking @booking_id = 1020, @member_id = 4;

-- test 5 - cancel a booking, no waitlist. should promote booking_id 1022, and delete it from waitlistdetails 
exec CancelBooking @booking_id = 1021, @member_id = 1;

-- test 6 - cancel a booking, is waitlist. should set status to cancelled, and delete from the waitlist table
exec CancelBooking @booking_id = 1024, @member_id = 4;

rollback;

