-- https://en.wikibooks.org/wiki/SQL_Exercises/Planet_Express 
-- 7.1 Who receieved a 1.5kg package?
    -- The result is "Al Gore's Head".
-- Subquery ver
SELECT Name
  FROM Client
  WHERE AccountNumber IN
  (
    SELECT Recipient
    FROM Package
    WHERE Weight = 1.5
  );

-- JOIN ver
SELECT Client.Name
  FROM Client INNER JOIN Package
  ON Client.AccountNumber = Package.Recipient
  WHERE Package.Weight = 1.5;

-- 7.2 What is the total weight of all the packages that he sent?
-- JOIN ver
SELECT SUM(P.Weight)
  FROM Package P INNER JOIN Client C
  ON P.Sender = C.AccountNumber
  WHERE C.Name = "Al Gore's Head";

-- Subquery ver
SELECT SUM(Weight)
  FROM Package
  WHERE Sender IN
  (
    SELECT AccountNumber
    FROM Client
    WHERE Name = "Al Gore's Head"
  );

-- 7.3 Which pilots transported those packages?
-- Subquery ver
SELECT Name
  FROM Employee
  WHERE EmployeeID IN
  (
    SELECT Manager
    FROM Shipment
    WHERE ShipmentID IN
    (
      SELECT Shipment
      FROM Package
      WHERE Sender IN
      (
        SELECT AccountNumber
        FROM Client
        WHERE Name = "Al Gore's Head"
      )
    )
  );

-- JOIN ver
SELECT E.Name
  FROM Employee E INNER JOIN Shipment S
  ON E.EmployeeID = S.Manager
  WHERE ShipmentID IN
  (
    SELECT Shipment
    FROM Package
    WHERE Sender IN
    (
      SELECT AccountNumber
      FROM Client
      WHERE Name = "Al Gore's Head"
    )
  );
