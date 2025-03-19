-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

-- Customers Details
CREATE TABLE `Customers` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `name` VARCHAR(100),
    `email` VARCHAR(100) UNIQUE,
    `phone` VARCHAR(15),
    `address` TEXT
);
CREATE INDEX idx_email ON `Customers` (`email`);

-- Meters Details
CREATE TABLE `Meters` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `customer_id` INT,
    `installation_date` DATE,
    `meter_number` VARCHAR(50),
    FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`id`) ON DELETE CASCADE
);
CREATE INDEX idx_meter_customer_id ON `Meters` (`customer_id`);

-- Meter Readings
CREATE TABLE `Meter_Readings` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `meter_id` INT,
    `reading_date` DATE,
    `units_consumed` INT,
    FOREIGN KEY (`meter_id`) REFERENCES `Meters`(`id`) ON DELETE CASCADE
);
CREATE INDEX idx_reading_meter_id ON `Meter_Readings` (`meter_id`);

-- Bills Data
CREATE TABLE `Bills` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `customer_id` INT,
    `bill_date` DATE,
    `total_amount` DECIMAL(10, 2),
    `status` ENUM('paid', 'unpaid'),
    FOREIGN KEY (`customer_id`) REFERENCES `Customers`(`id`) ON DELETE CASCADE
);
CREATE INDEX idx_bill_customer_id ON `Bills` (`customer_id`);

-- Payments Data
CREATE TABLE `Payments` (
    `id` INT PRIMARY KEY AUTO_INCREMENT,
    `bill_id` INT,
    `payment_date` DATE,
    `amount` DECIMAL(10, 2),
    FOREIGN KEY (`bill_id`) REFERENCES `Bills`(`id`) ON DELETE CASCADE
);
CREATE INDEX idx_payment_bill_id ON `Payments` (`bill_id`);

-- Add Bill Amounts using Triggers
CREATE TRIGGER `generate_bill_after_reading`
AFTER INSERT ON `Meter_Readings`
FOR EACH ROW
BEGIN
    DECLARE total_units INT;
    DECLARE bill_amount DECIMAL(10, 2);

    SET total_units = NEW.units_consumed;
    SET bill_amount = total_units * 0.10;

    INSERT INTO `Bills` (`customer_id`, `bill_date`, `total_amount`, `status`)
    VALUES (
        (SELECT `customer_id` FROM `Meters` WHERE `id` = NEW.meter_id), CURDATE(), bill_amount, 'unpaid'
    );
END;

-- Add payment Detail to the Payments
CREATE TRIGGER `update_bill_status_after_payment`
AFTER INSERT ON `Payments`
FOR EACH ROW
BEGIN
    UPDATE `Bills`
    SET `status` = 'paid'
    WHERE `id` = NEW.bill_id;
END;

-- Unpaid Bills
CREATE VIEW `UnpaidBills` AS
SELECT
    b.id AS bill_id,
    c.name AS customer_name,
    b.total_amount,
    b.bill_date
FROM
    Bills b
JOIN
    Customers c ON b.customer_id = c.id
WHERE
    b.status = 'unpaid';
