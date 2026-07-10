-- =========================================================================
-- SYSTEM: Football Ticket Booking System Database Setup Template
-- DESCRIPTION: Pseudo-DDL Template for Table Creation & Data Insertion
-- INSTRUCTIONS: Replace 'TYPE' and the constraint placeholders with your own
--               actual data types, relational keys, and check criteria.
-- =========================================================================

-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;

-- =========================================================================
-- 1. CREATE USERS TABLE
-- =========================================================================
CREATE TABLE Users (
    user_id INTEGER,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role VARCHAR(30) NOT NULL,
    phone_number VARCHAR(20),
    
    -- Write your constraint to make 'user_id' the Primary Key
    CONSTRAINT pk_users PRIMARY KEY (user_id),
    -- Write your constraint to ensure 'email' values are never duplicated
    CONSTRAINT uq_users_email UNIQUE (email),
    -- Write your check constraint to restrict 'role' to specific allowed strings
    CONSTRAINT chk_users_role CHECK (role IN ('Ticket Manager', 'Football Fan'))
);

-- =========================================================================
-- 2. CREATE MATCHES TABLE
-- =========================================================================
CREATE TABLE Matches (
    match_id INTEGER,
    fixture VARCHAR(150) NOT NULL,
    tournament_category VARCHAR(100) NOT NULL,
    base_ticket_price NUMERIC(10, 2) NOT NULL,
    match_status VARCHAR(20) NOT NULL,

    -- Write your constraint to make 'match_id' the Primary Key
    CONSTRAINT pk_matches PRIMARY KEY (match_id),
    -- Write your check constraint to prevent negative ticket prices
    CONSTRAINT chk_matches_ticket_price CHECK (base_ticket_price >= 0),
    -- Write your check constraint to restrict 'match_status' values
    CONSTRAINT chk_matches_status CHECK (
          match_status IN (
              'Available',
              'Selling Fast',
              'Sold Out',
              'Postponed'
          )
      )
);

-- =========================================================================
-- 3. CREATE BOOKINGS TABLE
-- =========================================================================
CREATE TABLE Bookings (
    booking_id INTEGER,
    user_id INTEGER NOT NULL,
    match_id INTEGER NOT NULL,
    seat_number VARCHAR(20),
    payment_status VARCHAR(20),
    total_cost NUMERIC(10, 2) NOT NULL,

    -- Write your constraint to make 'booking_id' the Primary Key
    CONSTRAINT pk_bookings PRIMARY KEY (booking_id),
    -- Write your Foreign Key constraint linking 'user_id' to the Users table
    CONSTRAINT fk_bookings_user FOREIGN KEY (user_id) REFERENCES Users(user_id),
    -- Write your Foreign Key constraint linking 'match_id' to the Matches table
    CONSTRAINT fk_bookings_match FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    -- Write your check constraint to ensure 'total_cost' is non-negative
    CONSTRAINT chk_bookings_payment_status CHECK (
          payment_status IN (
              'Pending',
              'Confirmed',
              'Cancelled',
              'Refunded'
          )
          OR payment_status IS NULL
      ),
    -- Write your check constraint to restrict 'payment_status' values
    CONSTRAINT chk_bookings_total_cost CHECK (total_cost >= 0)
);


-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO USERS
-- =========================================================================
INSERT INTO Users (user_id, full_name, email, role, phone_number) VALUES
(1, 'Tanvir Rahman', 'tanvir@mail.com', 'Football Fan', '+8801711111111'),
(2, 'Asif Haque', 'asif@mail.com', 'Football Fan', '+8801722222222'),
(3, 'Sajjad Rahman', 'sajjad@mail.com', 'Ticket Manager', '+8801733333333'),
(4, 'Jannat Ara', 'jannat@mail.com', 'Football Fan', NULL);

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO MATCHES
-- =========================================================================
INSERT INTO Matches (match_id, fixture, tournament_category, base_ticket_price, match_status) VALUES
(101, 'Real Madrid vs Barcelona', 'Champions League', 150.00, 'Available'),
(102, 'Man City vs Liverpool', 'Premier League', 120.00, 'Selling Fast'),
(103, 'Bayern Munich vs PSG', 'Champions League', 130.00, 'Available'),
(104, 'AC Milan vs Inter Milan', 'Serie A', 90.00, 'Sold Out'),
(105, 'Juventus vs Roma', 'Serie A', 80.00, 'Available');

-- =========================================================================
-- DATA SEEDING: INSERT SAMPLE DATA INTO BOOKINGS
-- =========================================================================
INSERT INTO Bookings (booking_id, user_id, match_id, seat_number, payment_status, total_cost) VALUES
(501, 1, 101, 'A-12', 'Confirmed', 150.00),
(502, 1, 102, 'B-04', 'Confirmed', 120.00),
(503, 2, 101, 'A-13', 'Confirmed', 150.00),
(504, 2, 101, NULL, NULL, 150.00),
(505, 3, 102, 'C-20', 'Pending', 120.00);




-- =========================================================
-- QUERY 1
-- Retrieve all available Champions League matches
-- =========================================================
SELECT match_id, fixture, base_ticket_price
FROM Matches
WHERE tournament_category = 'Champions League'
AND match_status = 'Available';



-- =========================================================
-- QUERY 2
-- Search users whose names start with Tanvir or contain Haque, case-insensitively
-- =========================================================
SELECT user_id, full_name, email
FROM Users
WHERE full_name ILIKE 'Tanvir%'
OR full_name ILIKE '%Haque%';



-- =========================================================
-- QUERY 3
-- Find bookings with missing payment status and replace NULL with 'Action Required'
-- =========================================================
SELECT booking_id, user_id, match_id,
    COALESCE(payment_status, 'Action Required') AS systematic_status
FROM Bookings
WHERE payment_status IS NULL;



-- =========================================================
-- QUERY 4
-- Retrieve booking details with user name and match fixture
-- =========================================================
SELECT b.booking_id, u.full_name, m.fixture, b.total_cost
FROM Bookings AS b
INNER JOIN Users AS u ON b.user_id = u.user_id
INNER JOIN Matches AS m ON b.match_id = m.match_id;



-- =========================================================
-- QUERY 5
-- Display all users and their booking IDs,
-- including users who have never made a booking
-- =========================================================
SELECT u.user_id, u.full_name, b.booking_id
FROM Users AS u
LEFT JOIN Bookings AS b ON u.user_id = b.user_id;



