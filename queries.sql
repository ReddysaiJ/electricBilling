-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

-- new customer
INSERT INTO `Customers` (`name`, `email`, `phone`, `address`)
VALUES ('Ravi Kumar', 'ravikumar@example.com', '9876543210', '456 MG Road, Bengaluru');

-- Insert customer
INSERT INTO `Customers` (`name`, `email`, `phone`, `address`)
VALUES ('Priya Sharma', 'priyasharma@example.com', '9988776655', '789 Laxmi Nagar, Delhi');

-- Insert new meter for a customer
INSERT INTO `Meters` (`customer_id`, `installation_date`, `meter_number`)
VALUES (1, '2024-10-10', 'MTR98765');

-- Insert new meter reading
INSERT INTO `Meter_Readings` (`meter_id`, `reading_date`, `units_consumed`)
VALUES (1, '2024-10-10', 200);

-- Insert new payment for a bill
INSERT INTO `Payments` (`bill_id`, `payment_date`, `amount`)
VALUES (1, '2024-10-10', 20.00);

-- all unpaid bills
SELECT *
FROM `UnpaidBills`;

-- Get all bills for a customer
SELECT b.id AS bill_id, b.bill_date, b.total_amount, b.status
FROM `Bills` b
WHERE b.customer_id = 1;

-- meter readings for a customer
SELECT mr.reading_date, mr.units_consumed
FROM `Meter_Readings` mr
JOIN `Meters` m ON mr.meter_id = m.id
WHERE m.customer_id = 1;

-- Update customer information
UPDATE `Customers`
SET `email` = 'newravi@example.com', `phone` = '9123456789'
WHERE `id` = 1;

-- Mark a bill as paid
UPDATE `Bills`
SET `status` = 'paid'
WHERE `id` = 1;

-- Delete a customer and cascade delete associated records
DELETE FROM `Customers`
WHERE `id` = 2;

-- Delete meter reading
DELETE FROM `Meter_Readings`
WHERE `id` = 1;

-- total amount paid by customer
SELECT SUM(p.amount) AS total_paid
FROM `Payments` p
JOIN `Bills` b ON p.bill_id = b.id
WHERE b.customer_id = 1;

-- payment History
SELECT p.payment_date, p.amount
FROM `Payments` p
JOIN `Bills` b ON p.bill_id = b.id
WHERE b.customer_id = 1;
