CREATE TABLE Bus (
    license_plate_number VARCHAR(15) PRIMARY KEY,
    seat_capacity INT,
    make VARCHAR(50),
    model VARCHAR(50),
    model_year YEAR,
    fuel_type ENUM('petrol', 'diesel', 'hybrid', 'electric'),
    RouteID INT
);

CREATE TABLE Route (
    RouteID INT PRIMARY KEY,
    RouteName VARCHAR(50) UNIQUE
);

CREATE TABLE Bus_Stops (
    stopName VARCHAR(50) PRIMARY KEY,
    RouteID INT,
    StopOrder INT
);

CREATE TABLE Operates_On (
    license_plate_number VARCHAR(15),
    RouteID INT,
    FOREIGN KEY (license_plate_number) REFERENCES Bus(license_plate_number),
    FOREIGN KEY (RouteID) REFERENCES Route(RouteID)
);

CREATE TABLE Consist_of (
    stopName VARCHAR(50),
    RouteID INT,
    RouteName VARCHAR(50),
    StopOrder INT,
    FOREIGN KEY (stopName) REFERENCES Bus_Stops(stopName),
    FOREIGN KEY (RouteID) REFERENCES Route(RouteID),
    FOREIGN KEY (RouteName) REFERENCES Route(RouteName)
);

INSERT INTO Route (RouteID, RouteName) VALUES
(1, 'Route 1'),
(2, 'Route 2'),
(3, 'Route 3'),
(4, 'Route 4'),
(5, 'Route 5'),
(6, 'Route 6'),
(7, 'Route 7'),
(8, 'Route 8'),
(9, 'Route 9'),
(10, 'Route 10');

-- Insert tuples into Bus table
INSERT INTO Bus (license_plate_number, seat_capacity, make, model, model_year, fuel_type, RouteID) VALUES
('ABC123', 50, 'Make1', 'Model1', 2020, 'petrol', 1),
('DEF456', 60, 'Make2', 'Model2', 2021, 'diesel', 2),
('GHI789', 70, 'Make3', 'Model3', 2022, 'hybrid', 3),
('JKL012', 80, 'Make4', 'Model4', 2023, 'electric', 4),
('MNO345', 90, 'Make5', 'Model5', 2024, 'petrol', 5),
('ABC678', 70, 'Make3', 'Model3', 2022, 'Hybrid', 6),
('XYZ901', 60, 'Make2', 'Model2', 2021, 'Diesel', 7),
('DEF234', 85, 'Make1', 'Model1', 2020, 'Electric', 8),
('GHI567', 55, 'Make4', 'Model4', 2023, 'Hybrid', 9),
('JKL890', 65, 'Make5', 'Model5', 2024, 'Petrol', 10);

-- Insert tuples into Bus_Stops table
INSERT INTO Bus_Stops (stopName, RouteID, StopOrder) VALUES
('Stop1', 1, 1),
('Stop2', 1, 2),
('Stop3', 2, 1),
('Stop4', 2, 2),
('Stop5', 3, 1),
('Stop6', 3, 2),
('Stop7', 4, 1),
('Stop8', 4, 2),
('Stop9', 5, 1),
('Stop10', 5, 2);

-- Insert tuples into Operates_On table
INSERT INTO Operates_On (license_plate_number, RouteID) VALUES
('ABC123', 1),
('DEF456', 2),
('GHI789', 3),
('JKL012', 4),
('MNO345', 5);
('EER553', 6);
('TYU839', 7);
('RYE332', 8);
('ZZZ333', 9);
('TEY332', 10);

-- Insert tuples into Consist_of table
INSERT INTO Consist_of (stopName, RouteID, RouteName, StopOrder) VALUES
('Stop1', 1, 'Route 1', 1),
('Stop2', 1, 'Route 1', 2),
('Stop3', 2, 'Route 2', 1),
('Stop4', 2, 'Route 2', 2),
('Stop5', 3, 'Route 3', 1),
('Stop6', 3, 'Route 3', 2),
('Stop7', 4, 'Route 4', 1),
('Stop8', 4, 'Route 4', 2),
('Stop9', 5, 'Route 5', 1),
('Stop10', 5, 'Route 5', 2);

SELECT RouteName
FROM Route
WHERE RouteID IN (
    SELECT RouteID
    FROM Bus_Stops
    GROUP BY RouteID
    HAVING COUNT(*) = (
        SELECT MAX(StopCount)
        FROM (
            SELECT COUNT(*) as StopCount
            FROM Bus_Stops
            GROUP BY RouteID
        ) AS StopCounts
    )
);

CREATE VIEW ElectricBuses AS
SELECT *
FROM Bus
WHERE fuel_type = 'electric';

SELECT DISTINCT RouteName
FROM Route
WHERE RouteID IN (
    SELECT DISTINCT RouteID
    FROM ElectricBuses
) AND RouteID NOT IN (
    SELECT DISTINCT RouteID
    FROM Bus
    WHERE fuel_type <> 'electric'
);

SELECT stopName
FROM Bus_Stops
GROUP BY stopName
HAVING COUNT(DISTINCT RouteID) >= 2;

SELECT fuel_type, SUM(seat_capacity) as TotalSeatCapacity
FROM Bus
GROUP BY fuel_type;

SELECT stopName
FROM Bus_Stops
WHERE RouteID IS NULL;