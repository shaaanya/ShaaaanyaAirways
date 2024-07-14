-- Connect to the database
\c shanyaairways;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS feedbacks CASCADE;
DROP TABLE IF EXISTS complaints CASCADE;
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS tickets CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS promotions CASCADE;
DROP TABLE IF EXISTS routes CASCADE;
DROP TABLE IF EXISTS pilot_availability CASCADE;
DROP TABLE IF EXISTS pilots CASCADE;
DROP TABLE IF EXISTS aircrafts CASCADE;
DROP TABLE IF EXISTS airports CASCADE;
DROP TABLE IF EXISTS locations CASCADE;
DROP TABLE IF EXISTS registered_users CASCADE;
DROP TABLE IF EXISTS admin CASCADE;

-- Create tables
CREATE TABLE admin (
    admin_id SERIAL PRIMARY KEY,
    login_name VARCHAR(255),
    name VARCHAR(255),
    password VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(255)
);

CREATE TABLE registered_users (
    user_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    login_name VARCHAR(255),
    password VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(255),
    gender VARCHAR(255),
    user_type VARCHAR(20),
    reg_date DATE,
    last_login DATE
);

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    location_name VARCHAR(255),
    location_image BYTEA
);

CREATE TABLE airports (
    airport_id SERIAL PRIMARY KEY,
    airport_name VARCHAR(255),
    airport_code VARCHAR(8),
    airport_location_id INT,
    airport_location VARCHAR(255),
    airport_lattitude DECIMAL(10,6),
    airport_longitude DECIMAL(10,6),
    airport_status VARCHAR(255),
    FOREIGN KEY (airport_location_id) REFERENCES locations(location_id)
);

CREATE TABLE aircrafts (
    aircraft_id SERIAL PRIMARY KEY,
    aircraft_name VARCHAR(255),
    aircraft_type VARCHAR(255),
    aircraft_status VARCHAR(255)
);

CREATE TABLE pilots (
    pilot_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    phone_number VARCHAR(255),
    availiabe BOOLEAN DEFAULT TRUE
);

CREATE TABLE pilot_availability (
    availability_id SERIAL PRIMARY KEY,
    pilot_id INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    FOREIGN KEY (pilot_id) REFERENCES pilots(pilot_id)
);

CREATE TABLE routes (
    route_id SERIAL PRIMARY KEY,
    route_name VARCHAR(255),
    departure_airport_id INT,
    arrival_airport_id INT,
    distance DECIMAL(10,2),
    duration TIME,
    route_status VARCHAR(255),
    FOREIGN KEY (departure_airport_id) REFERENCES airports(airport_id),
    FOREIGN KEY (arrival_airport_id) REFERENCES airports(airport_id)
);

CREATE TABLE promotions (
    promotion_id SERIAL PRIMARY KEY,
    promotion_name VARCHAR(255),
    route_id INT,
    promotion_code VARCHAR(255),
    promotion_discount DECIMAL(10,2),
    promotion_start_date DATE,
    promotion_end_date DATE,
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
);

CREATE TABLE flights (
    flight_id SERIAL PRIMARY KEY,
    flight_number VARCHAR(255),
    route_id INT,
    departure_time TIMESTAMP,
    arrival_time TIMESTAMP,
    economy_seats_available INT,
    business_seats_available INT,
    first_class_seats_available INT,
    economy_class_fare DECIMAL(10,2),
    business_class_fare DECIMAL(10,2),
    first_class_fare DECIMAL(10,2),
    aircraft_id INT,
    pilot_id INT,
    FOREIGN KEY (route_id) REFERENCES routes(route_id),
    FOREIGN KEY (aircraft_id) REFERENCES aircrafts(aircraft_id),
    FOREIGN KEY (pilot_id) REFERENCES pilots(pilot_id)
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT,
    flight_id INT,
    booking_date DATE,
    booking_status VARCHAR(255),
    seat_type VARCHAR(255),
    seat_number INT,
    FOREIGN KEY (user_id) REFERENCES registered_users(user_id),
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
);

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    booking_id INT,
    ticket_number VARCHAR(255),
    ticket_status VARCHAR(255),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT,
    payment_date DATE,
    payment_status VARCHAR(255),
    payment_amount DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

CREATE TABLE feedbacks (
    feedback_id SERIAL PRIMARY KEY,
    user_id INT,
    feedback_date DATE,
    feedback_message TEXT,
    FOREIGN KEY (user_id) REFERENCES registered_users(user_id)
);

CREATE TABLE complaints (
    complaint_id SERIAL PRIMARY KEY,
    user_id INT,
    complaint_date DATE,
    complaint_message TEXT,
    FOREIGN KEY (user_id) REFERENCES registered_users(user_id)
);

-- FUNCTIONS

-- Procedure to count bookings
CREATE OR REPLACE FUNCTION count_bookings()
RETURNS TABLE (booking_count INT)
AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(*) FROM bookings;
END;
$$ LANGUAGE plpgsql;

-- Function to generate ticket for a booking
CREATE OR REPLACE FUNCTION generate_ticket(booking_id INT)
RETURNS TABLE (ticket_number VARCHAR(255))
AS $$
DECLARE
    ticket_number VARCHAR(255);
BEGIN
    ticket_number := 'TICKET' || booking_id;
    RETURN QUERY
    SELECT ticket_number;
END;
$$ LANGUAGE plpgsql;

-- Function to add new user
CREATE OR REPLACE FUNCTION add_new_user(
    first_name VARCHAR(255), last_name VARCHAR(255), login_name VARCHAR(255), password VARCHAR(255), email VARCHAR(255), phone_number VARCHAR(255)
) RETURNS TABLE (user_id INT)
AS $$
DECLARE
    user_id INT;
BEGIN
    INSERT INTO registered_users (first_name, last_name, login_name, password, email, phone_number)
    VALUES (first_name, last_name, login_name, password, email, phone_number)
    RETURNING user_id INTO user_id;
    RETURN QUERY
    SELECT user_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add new admin
CREATE OR REPLACE FUNCTION add_new_admin(first_name VARCHAR(255), last_name VARCHAR(255), login_name VARCHAR(255), password VARCHAR(255), email VARCHAR(255), phone_number VARCHAR(255))
RETURNS TABLE (admin_id INT)
AS $$
DECLARE
    admin_id INT;
BEGIN
    INSERT INTO admin (login_name, name, password, email, phone_number)
    VALUES (first_name, last_name, login_name, password, email, phone_number)
    RETURNING admin_id INTO admin_id;
    RETURN QUERY
    SELECT admin_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add new airport
CREATE OR REPLACE FUNCTION add_new_airport(airport_name VARCHAR(255), airport_code VARCHAR(8), airport_location VARCHAR(255), airport_status VARCHAR(255))
RETURNS TABLE (airport_id INT)
AS $$
DECLARE
    airport_id INT;
BEGIN
    INSERT INTO airports (airport_name, airport_code, airport_location, airport_status)
    VALUES (airport_name, airport_code, airport_location, airport_status)
    RETURNING airport_id INTO airport_id;
    RETURN QUERY
    SELECT airport_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add new route
CREATE OR REPLACE FUNCTION add_new_route(route_name VARCHAR(255), departure_airport_id INT, arrival_airport_id INT, distance DECIMAL(10,2), duration TIME, route_status VARCHAR(255))
RETURNS TABLE (route_id INT)
AS $$
DECLARE
    route_id INT;
BEGIN
    INSERT INTO routes (route_name, departure_airport_id, arrival_airport_id, distance, duration, route_status)
    VALUES (route_name, departure_airport_id, arrival_airport_id, distance, duration, route_status)
    RETURNING route_id INTO route_id;
    RETURN QUERY
    SELECT route_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add new flight
CREATE OR REPLACE FUNCTION add_new_flight(flight_number VARCHAR(255), route_id INT, economy_seats_available INT, business_seats_available INT, first_class_seats_available INT, economy_class_fare DECIMAL(10,2), business_class_fare DECIMAL(10,2), first_class_fare DECIMAL(10,2), aircraft_id INT, pilot_id INT)
RETURNS TABLE (flight_id INT)
AS $$
DECLARE
    flight_id INT;
BEGIN
    INSERT INTO flights (flight_number, route_id, economy_seats_available, business_seats_available, first_class_seats_available, economy_class_fare, business_class_fare, first_class_fare, aircraft_id, pilot_id)
    VALUES (flight_number, route_id, economy_seats_available, business_seats_available, first_class_seats_available, economy_class_fare, business_class_fare, first_class_fare, aircraft_id, pilot_id)
    RETURNING flight_id INTO flight_id;
    RETURN QUERY
    SELECT flight_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add new aircraft
CREATE OR REPLACE FUNCTION add_new_aircraft(aircraft_name VARCHAR(255), aircraft_type VARCHAR(255), aircraft_status VARCHAR(255))
RETURNS TABLE (aircraft_id INT)
AS $$
DECLARE
    aircraft_id INT;
BEGIN
    INSERT INTO aircrafts (aircraft_name, aircraft_type, aircraft_status)
    VALUES (aircraft_name, aircraft_type, aircraft_status)
    RETURNING aircraft_id INTO aircraft_id;
    RETURN QUERY
    SELECT aircraft_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add new pilot
CREATE OR REPLACE FUNCTION add_new_pilot(first_name VARCHAR(255), last_name VARCHAR(255), email VARCHAR(255), phone_number VARCHAR(255))
RETURNS TABLE (pilot_id INT)
AS $$   
DECLARE
    pilot_id INT;
BEGIN
    INSERT INTO pilots (first_name, last_name, email, phone_number)
    VALUES (first_name, last_name, email, phone_number)
    RETURNING pilot_id INTO pilot_id;
    RETURN QUERY
    SELECT pilot_id;
END;
$$ LANGUAGE plpgsql;

-- Function to add new booking
CREATE OR REPLACE FUNCTION add_new_booking(user_id INT, flight_id INT, booking_date DATE, booking_status VARCHAR(255), seat_type VARCHAR(255), seat_number INT)
RETURNS TABLE (booking_id INT)
AS $$
DECLARE
    booking_id INT;
BEGIN
    INSERT INTO bookings (user_id, flight_id, booking_date, booking_status, seat_type, seat_number)
    VALUES (user_id, flight_id, booking_date, booking_status, seat_type, seat_number)
    RETURNING booking_id INTO booking_id;
    RETURN QUERY
    SELECT booking_id;
END;
$$ LANGUAGE plpgsql;

-- Function to check all routes from a departure airport to an arrival airport
CREATE OR REPLACE FUNCTION check_routes(departure_airport_id INT, arrival_airport_id INT)
RETURNS TABLE (route_id INT, route_name VARCHAR(255), distance DECIMAL(10,2), duration TIME, route_status VARCHAR(255))
AS $$
BEGIN
    RETURN QUERY
    SELECT route_id, route_name, distance, duration, route_status FROM routes WHERE departure_airport_id = departure_airport_id AND arrival_airport_id = arrival_airport_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION generate_routes()
RETURNS VOID AS $$
DECLARE
    dep_airport RECORD;
    arr_airport RECORD;
BEGIN
    FOR dep_airport IN SELECT airport_id, airport_name, airport_code, airport_location, airport_lattitude, airport_longitude FROM airports LOOP
        FOR arr_airport IN SELECT airport_id, airport_name, airport_code, airport_location, airport_lattitude, airport_longitude FROM airports WHERE airport_id <> dep_airport.airport_id LOOP
            INSERT INTO routes (route_name, departure_airport_id, arrival_airport_id, distance, duration, route_status)
            VALUES 
            (
                dep_airport.airport_name || ' to ' || arr_airport.airport_name,
                dep_airport.airport_id,
                arr_airport.airport_id,
                calculate_distance(dep_airport.airport_lattitude, dep_airport.airport_longitude, arr_airport.airport_lattitude, arr_airport.airport_longitude),
                calculate_duration(dep_airport.airport_lattitude, dep_airport.airport_longitude, arr_airport.airport_lattitude, arr_airport.airport_longitude),
                'Active'
            );
        END LOOP;
    END LOOP;
END $$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION calculate_distance(lat1 DECIMAL, lon1 DECIMAL, lat2 DECIMAL, lon2 DECIMAL)
RETURNS DECIMAL AS $$
DECLARE
    R INTEGER := 6371; -- Radius of the Earth in kilometers
    dLat DECIMAL;
    dLon DECIMAL;
    a DECIMAL;
    c DECIMAL;
    distance DECIMAL;
BEGIN
    dLat := RADIANS(lat2 - lat1);
    dLon := RADIANS(lon2 - lon1);
    a := SIN(dLat / 2) * SIN(dLat / 2) + COS(RADIANS(lat1)) * COS(RADIANS(lat2)) * SIN(dLon / 2) * SIN(dLon / 2);
    c := 2 * ATAN2(SQRT(a), SQRT(1 - a));
    distance := R * c;
    RETURN distance;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculate_duration(lat1 DECIMAL, lon1 DECIMAL, lat2 DECIMAL, lon2 DECIMAL)
RETURNS INTERVAL AS $$
DECLARE
    distance DECIMAL;
    avg_speed DECIMAL := 900; -- Average speed of an airplane in km/h
    duration_hours DECIMAL;
    duration INTERVAL;
BEGIN
    distance := calculate_distance(lat1, lon1, lat2, lon2);
    duration_hours := distance / avg_speed;
    duration := (duration_hours || ' hours')::interval;
    RETURN duration;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION generate_promotions()
RETURNS VOID AS $$
DECLARE
    route RECORD;
BEGIN
    FOR route IN SELECT * FROM routes ORDER BY RANDOM() LIMIT 6 LOOP
        INSERT INTO promotions (promotion_name, route_id, promotion_code, promotion_discount, promotion_start_date, promotion_end_date)
        VALUES 
        (
            'Featured Promotion ' || route.route_name,
            route.route_id,
            'FEATURED' || route.route_id,
            ROUND((RANDOM() * 50)::numeric, 2), -- Random discount between 0 and 50
            CURRENT_DATE + (RANDOM() * 365)::int, -- Random start date within the next year
            CURRENT_DATE + (RANDOM() * 365 + 30)::int -- Random end date within the next year + 30 days
        );
    END LOOP;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_pilot_available(pilot_id INT, departure_time TIMESTAMP, arrival_time TIMESTAMP)
RETURNS BOOLEAN AS $$
DECLARE
    availability_count INT;
BEGIN
    SELECT COUNT(*)
    INTO availability_count
    FROM pilot_availability pa
    WHERE pa.pilot_id = $1
      AND pa.start_time <= $2
      AND pa.end_time >= $3;
    
    RETURN availability_count > 0;
END $$ LANGUAGE plpgsql;


-- YES, ALL NEEDS TO BE RANDOM!!!!!
CREATE OR REPLACE FUNCTION generate_flights(num_flights INT)
RETURNS VOID AS $$
DECLARE
    route RECORD;
    aircraft RECORD;
    pilot RECORD;
    i INT;
    dep_time TIMESTAMP;
    arr_time TIMESTAMP;
BEGIN
    FOR i IN 1..num_flights LOOP
        SELECT * INTO route FROM routes ORDER BY RANDOM() LIMIT 1;
        SELECT * INTO aircraft FROM aircrafts ORDER BY RANDOM() LIMIT 1;
        
        dep_time := NOW() + (RANDOM() * 365 * '1 day'::interval); -- Random departure time within the next year
        arr_time := dep_time + route.duration; -- Arrival time based on route duration
        
        FOR pilot IN SELECT * FROM pilots ORDER BY RANDOM() LOOP
            IF is_pilot_available(pilot.pilot_id, dep_time, arr_time) THEN
                INSERT INTO flights (
                    flight_number,
                    route_id,
                    economy_seats_available,
                    business_seats_available,
                    first_class_seats_available,
                    economy_class_fare,
                    business_class_fare,
                    first_class_fare,
                    aircraft_id,
                    pilot_id,
                    departure_time,
                    arrival_time
                ) VALUES (
                    'FL' || LPAD(i::text, 5, '0'),
                    route.route_id,
                    FLOOR(RANDOM() * 200 + 50), -- Random number of economy seats between 50 and 250
                    FLOOR(RANDOM() * 50 + 10), -- Random number of business seats between 10 and 60
                    FLOOR(RANDOM() * 20 + 5), -- Random number of first class seats between 5 and 25
                    ROUND((RANDOM() * 300 + 50)::numeric, 2), -- Random economy fare between 50 and 350
                    ROUND((RANDOM() * 500 + 100)::numeric, 2), -- Random business fare between 100 and 600
                    ROUND((RANDOM() * 1000 + 200)::numeric, 2), -- Random first class fare between 200 and 1200
                    aircraft.aircraft_id,
                    pilot.pilot_id,
                    dep_time,
                    arr_time
                );
                EXIT;
            END IF;
        END LOOP;
    END LOOP;
END $$ LANGUAGE plpgsql;



-- Will be calling this just to clean up the mess
CREATE OR REPLACE FUNCTION remove_arrived_flights()
RETURNS VOID AS $$
BEGIN
    DELETE FROM flights WHERE arrival_time < NOW();
END $$ LANGUAGE plpgsql;
