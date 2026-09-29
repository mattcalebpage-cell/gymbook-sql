# Gym Booking System

A SQL Server backend for a gym booking system, built to learn database
design and T-SQL — schema design, normalization, and stored procedures
with real business logic.

## Schema

- **Members** — people who make bookings
- **Instructors** — staff who lead classes or PT sessions
- **Rooms** — physical spaces in the gym
- **Equipment** — bookable machines/kit
- **Sessions** — any bookable event (class, PT, or equipment slot)
- **Session_Equipment** — junction table linking sessions to the
  equipment they use (many-to-many)
- **Bookings** — a member's booking for a session, with status
  (confirmed / waitlisted / cancelled)
- **WaitlistDetails** — extends Bookings for waitlisted rows only,
  storing queue position

## Design decisions

- Originally had separate `Bookings` and `Waitlist` tables. Merging
  them into one meant `booking_id` and `waitlist_id` were two
  independent identity sequences that could collide, so cancellation
  logic couldn't tell which table an ID belonged to.
- A single merged table fixed the ID collision but left `position`
  NULL for most rows. Settled on a supertype/subtype split instead —
  `Bookings` holds what every row has, `WaitlistDetails` holds
  `position` and only exists for waitlisted rows.

## Key logic

- **CreateBooking** — checks the session exists, isn't in the past,
  is active, the member exists, and they haven't already booked —
  then inserts into Bookings as confirmed, or waitlisted if the
  session is full.
- **CancelBooking** — checks ownership and state, then cancels the
  booking. If it was confirmed, promotes the next person off the
  waitlist (by position) into a confirmed spot.

## A bug I found and fixed

Initially, promoting someone off the waitlist inserted a new booking
using the *cancelling* member's ID instead of the waitlisted member's
ID, because the variable holding the correct member wasn't looked up
until after the insert had already run. Fixed by looking up the
correct row first, then acting on it.

## Running it

1. Run `gymbook_create_statements.sql` to build the schema
2. Run `gymbook_insert_statements.sql` to seed test data
3. Run `gymbook_actual_main_stuff.sql` for procedures and test cases
