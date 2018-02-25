-- 8.1 Obtain the names of all physicians that have performed a medical procedure they have never been certified to perform.
-- Subquery ver
SELECT Name
  FROM Physician
  WHERE EmployeeID IN
  (
    SELECT Physician
      FROM Undergoes U
      WHERE NOT EXISTS (
        SELECT *
          FROM Trained_in
          WHERE Physician = U.Physician
            AND U.Procedure = Treatment
      )
  );
-- JOIN ver
SELECT Name
  FROM Physician
  WHERE EmployeeID IN
  (
    SELECT U.Physician
      FROM Undergoes U
        LEFT JOIN Trained_in T
        ON U.Procedure = T.Treatment
          AND U.Physician = T.Physician
      WHERE Treatment IS NULL
  );

-- EXCEPT ver: 取差集
SELECT *
  FROM Physician P,
  (
    SELECT Physician, Procedure FROM Undergoes
    EXCEPT
    SELECT Physician, Treatment FROM Trained_in
  ) PE
  WHERE P.EmployeeID = PE.Physician;

-- 8.2 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on.

-- Subquery ver
SELECT PH.Name AS Physician, P.Name AS Procedure, U.Date, PA.Name
  FROM Procedure P, Physician PH, Patient PA, Undergoes U
  WHERE P.Code = U.Procedure
    AND PH.EmployeeID = U.Physician
    AND PA.SSN = U.Patient
    AND NOT EXISTS
    (
      SELECT *
        FROM Trained_in
        WHERE Physician = U.Physician
          AND U.Procedure = Treatment
    )

-- JOIN ver
SELECT P.Name AS Physican, PR.Name AS Procedure, U.Date, PA.Name
  FROM Undergoes U, Patient PA, Physician P, Procedure PR,
  (
    SELECT Physician, Procedure FROM Undergoes
    EXCEPT
    SELECT Physician, Treatment FROM Trained_in
  ) AS T
  WHERE U.Physician = T.Physician
    AND U.Procedure = T.Procedure
    AND U.Patient = PA.SSN
    AND U.Physician = P.EmployeeID
    AND U.Procedure = PR.Code

-- 8.3 Obtain the names of all physicians that have performed a medical procedure that they are certified to perform, but such that the procedure was done at a date (Undergoes.Date) after the physician's certification expired (Trained_In.CertificationExpires).
SELECT P.Name AS Physician
  FROM Undergoes AS U, Physician P
  WHERE U.Physician = P.EmployeeID
    AND EXISTS
    (
      SELECT * FROM Trained_In AS TI
        WHERE U.Physician = TI.Physician
          AND U.Procedure = TI.Treatment
          AND U.Date > TI.CertificationExpires
    );

-- 8.4 Same as the previous query, but include the following information in the results: Physician name, name of procedure, date when the procedure was carried out, name of the patient the procedure was carried out on, and date when the certification expired.
SELECT P.Name AS Physician, PA.Name AS Patient, PR.Name AS Procedure, U.Date, T.CertificationExpires
  FROM Undergoes U, Physician P, Patient PA, Trained_In T, Procedure PR
  WHERE U.Physician = T.Physician
    AND U.Procedure = T.Treatment
    AND P.EmployeeID = U.Physician
    AND U.Patient = PA.SSN
    AND U.Procedure = PR.Code
    AND U.Date > T.CertificationExpires

-- 8.5 Obtain the information for appointments where a patient met with a physician other than his/her primary care physician. Show the following information: Patient name, physician name, nurse name (if any), start and end time of appointment, examination room, and the name of the patient's primary care physician.
-- 第一次嘗試版本：沒有包含「沒Nurse」的情況, 還有可以重複呼叫兩次同樣table
SELECT P.Name AS Patient, PH.Name AS Physician, N.Name AS Nurse, A.Start, A.End, A.ExaminationRoom AS Room, P.PCP AS PCP, P.Physician_Name
  FROM Appointment A, Physician PH, Nurse N,
  (
    SELECT P.PCP, P.SSN, P.Name, PH.Name AS Physician_Name
      FROM Patient P INNER JOIN Physician PH
      ON P.PCP = PH.EmployeeId
  ) AS P
  WHERE A.Patient = P.SSN
    AND A.Physician = PH.EmployeeID
    AND A.PrepNurse = N.EmployeeID
    AND A.Physician <> P.PCP

-- Refined 版本
-- note 1: JOIN之後的 table 還是可以各自呼叫子table的column
-- note 2: 可以重複拿同樣的table 做不同mapping
SELECT PA.Name AS Patient, PCUR.Name AS Physician, PCP.Name AS PCP, N.Name AS Nurse, A.Start, A.End, A.ExaminationRoom AS Room
  FROM Patient PA, Physician PCUR, Physician PCP,
    Appointment A LEFT JOIN Nurse N ON A.PrepNurse = N.EmployeeId
  WHERE A.Patient = PA.SSN
    AND A.Physician = PCUR.EmployeeID
    AND PA.PCP = PCP.EmployeeID
    AND A.Physician <> PCP.EmployeeID

-- 8.6 The Patient field in Undergoes is redundant, since we can obtain it from the Stay table. There are no constraints in force to prevent inconsistencies between these two tables. More specifically, the Undergoes table may include a row where the patient ID does not match the one we would obtain from the Stay table through the Undergoes.Stay foreign key. Select all rows from Undergoes that exhibit this inconsistency.
-- JOIN ver
SELECT *
  FROM Undergoes U, Stay S
  WHERE U.Stay = S.StayID
    AND U.Patient <> S.Patient

-- Subquery ver + EXISTS
SELECT *
  FROM Undergoes U
  WHERE NOT EXISTS
  (
    SELECT *
      FROM Stay
      WHERE Stay.StayID = U.Stay
        AND Patient = U.Patient
  )

-- Subquery ver + equal
SELECT *
  FROM Undergoes
  WHERE Patient <>
  (
    SELECT Patient FROM Stay WHERE StayID = Undergoes.Stay
  )

-- 8.7 Obtain the names of all the nurses who have ever been on call for room 123.
-- JOIN ver
SELECT N.Name AS Nurse
  FROM On_Call C, Room R, Nurse N
  WHERE C.BlockFloor = R.BlockFloor
    AND C.BlockCode = R.BlockCode
    AND C.Nurse = N.EmployeeID
    AND R.Number = 123

-- Subquery ver
SELECT Name FROM Nurse
  WHERE EmployeeID IN
  (
    SELECT Nurse
      FROM On_Call OC, Room R
      WHERE OC.BlockFloor = R.BlockFloor
        AND OC.BlockCode = R.BlockCode
        AND R.Number = 123
  )

-- 8.8 The hospital has several examination rooms where appointments take place. Obtain the number of appointments that have taken place in each examination room.
SELECT ExaminationRoom, COUNT(*) AS Number_Appointments
  FROM Appointment
  GROUP BY 1

-- 8.9 Obtain the names of all patients (also include, for each patient, the name of the patient's primary care physician), such that \emph{all} the following are true:
    -- The patient has been prescribed some medication by his/her primary care physician.
    -- The patient has undergone a procedure with a cost larger that $5,000
    -- The patient has had at least two appointment where the nurse who prepped the appointment was a registered nurse.
    -- The patient's primary care physician is not the head of any department.

SELECT P.Name AS Patient, PH.Name AS Physician
  FROM Patient P, Physician PH
  WHERE P.PCP = PH.EmployeeID
    AND EXISTS
    (
      SELECT *
        FROM Prescribes PRE
        WHERE PRE.Patient = P.SSN
          AND PRE.Physician = P.PCP
    )
    AND EXISTS
    (
      SELECT *
        FROM Undergoes U, Procedure PR
        WHERE U.Procedure = PR.Code
          AND U.Patient = P.SSN
          AND PR.Cost > 5000
    )
    AND NOT EXISTS
    (
      SELECT * FROM Department WHERE Head = PH.EmployeeID
    )
    AND 2 <=
    (
      SELECT COUNT(*)
      FROM Appointment A, Nurse N
      WHERE A.PrepNurse = N.EmployeeID
        AND A.patient = P.SSN
        AND N.Registered = 1
    )