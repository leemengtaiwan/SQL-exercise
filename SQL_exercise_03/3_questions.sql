-- The Warehouse
-- lINK: https://en.wikibooks.org/wiki/SQL_Exercises/The_warehouse
--3.1 Select all warehouses.
SELECT * FROM Warehouses;

--3.2 Select all boxes with a value larger than $150.
SELECT * FROM Boxes WHERE Value > 150;

--3.3 Select all distinct contents in all the boxes.
SELECT DISTINCT Contents FROM Boxes;

--3.4 Select the average value of all the boxes.
SELECT AVG(Value) FROM Boxes;

--3.5 Select the warehouse code and the average value of the boxes in each warehouse.
SELECT Warehouse, AVG(Value)
  FROM Boxes
  GROUP BY Warehouse;

--3.6 Same as previous exercise, but select only those warehouses where the average value of the boxes is greater than 150.
SELECT Warehouse, AVG(Value)
  FROM Boxes
  GROUP BY Warehouse
  HAVING AVG(Value) > 150;

--3.7 Select the code of each box, along with the name of the city the box is located in.
SELECT B.Code, W.Location
  FROM Boxes B INNER JOIN Warehouses W
  ON B.Warehouse = W.Code;

--3.8 Select the warehouse codes, along with the number of boxes in each warehouse. 
    -- Optionally, take into account that some warehouses are empty (i.e., the box count should show up as zero, instead of omitting the warehouse from the result).
-- 簡單case, 只列出有 boxes 的 warehouses
SELECT Warehouse, COUNT(*)
  FROM Boxes
  GROUP BY 1;

-- 就算 warehouse 沒有對應的 boxes 也會列出該 warehouse 的版本：使用 left join
SELECT W.Code, COUNT(B.Code)
  FROM Warehouses W Left JOIN Boxes B
  ON W.Code = B.Warehouse
  GROUP BY 1;

--3.9 Select the codes of all warehouses that are saturated (a warehouse is saturated if the number of boxes in it is larger than the warehouse's capacity).
-- JOIN ver
SELECT W.Code, COUNT(B.CODE) AS Num_boxes, W.Capacity
  FROM Warehouses W, Boxes B
  WHERE W.Code = B.Warehouse
  GROUP BY 1
  HAVING COUNT(B.CODE) > W.Capacity;

-- Subquery ver
SELECT Code AS WarehouseCode
  FROM Warehouses W
  WHERE W.Capacity <
  (
    SELECT COUNT(*)
      FROM Boxes B
      WHERE B.Warehouse = W.Code
  );

--3.10 Select the codes of all the boxes located in Chicago.
-- Subquery ver
SELECT Code
  FROM Boxes
  WHERE Warehouse IN
  (
    SELECT Code
      FROM Warehouses
      WHERE Location = 'Chicago'
  );
-- JOIN ver
SELECT B.Code
  FROM Boxes B
  INNER JOIN Warehouses W
  ON B.Warehouse = W.Code
  WHERE W.Location = 'Chicago';

--3.11 Create a new warehouse in New York with a capacity for 3 boxes.
INSERT INTO Warehouses(Location, Capacity)
VALUES ('New York', 3);

--3.12 Create a new box, with code "H5RT", containing "Papers" with a value of $200, and located in warehouse 2.
INSERT INTO Boxes(Code, Contents, Value, Warehouse)
VALUES ("H5RT", "Papers", 200, 2);

--3.13 Reduce the value of all boxes by 15%.
UPDATE Boxes
SET Value = 0.85 * Value;

--3.14 Remove all boxes with a value lower than $100.
DELETE FROM Boxes WHERE Value < 100;

-- 3.14.1 Apply a 20% value reduction to boxes with a value larger than the average value of all the boxes.
UPDATE Boxes
  SET Value = 0.8 * Value
  WHERE Value >
  (
    SELECT AVG(Value) FROM Boxes
  );

-- 3.15 Remove all boxes from saturated warehouses.
-- Subquery ver
DELETE FROM Boxes
  WHERE Warehouse IN
  (
    SELECT Code
      FROM Warehouses W
      WHERE Capacity <
      (
        SELECT COUNT(*)
          FROM Boxes
          WHERE Warehouse = W.Code
      )
  );

-- 3.16 Add Index for column "Warehouse" in table "boxes"
    -- !!!NOTE!!!: index should NOT be used on small tables in practice
CREATE INDEX INDEX_WAREHOUSE ON Boxes(Warehouse);


-- 3.17 Print all the existing indexes
    -- !!!NOTE!!!: index should NOT be used on small tables in practice
.indexes

-- 3.18 Remove (drop) the index you added just
    -- !!!NOTE!!!: index should NOT be used on small tables in practice
DROP INDEX INDEX_WAREHOUSE