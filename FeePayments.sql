-- ==============================
-- Table Creation (SQL Server)
-- ==============================
IF OBJECT_ID('dbo.FeePayments', 'U') IS NOT NULL
    DROP TABLE dbo.FeePayments;
GO

CREATE TABLE dbo.FeePayments (
    payment_id   INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    amount       DECIMAL(10,2) CHECK (amount > 0),
    payment_date DATE
);
GO


-- ==============================
-- Part A: Insert Initial Records
-- ==============================
BEGIN TRANSACTION;

INSERT INTO dbo.FeePayments (payment_id, student_name, amount, payment_date)
VALUES
    (1, 'Ashish',  5000.00, '2024-06-01'),
    (2, 'Smaran',  4500.00, '2024-06-02'),
    (3, 'Vaibhav', 5500.00, '2024-06-03');

COMMIT TRANSACTION;
GO

SELECT *
FROM dbo.FeePayments;
GO


-- ==============================
-- Part B & C: Demonstrate ROLLBACK
-- ==============================
BEGIN TRANSACTION;

BEGIN TRY
    -- Valid insert
    INSERT INTO dbo.FeePayments (payment_id, student_name, amount, payment_date)
    VALUES (4, 'Kiran', 6000.00, '2024-06-04');

    -- Invalid insert (NULL student_name)
    INSERT INTO dbo.FeePayments (payment_id, student_name, amount, payment_date)
    VALUES (5, NULL, 3500.00, '2024-06-05');

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Transaction rolled back due to error: ' + ERROR_MESSAGE();
END CATCH;
GO

SELECT *
FROM dbo.FeePayments;
GO


-- ==============================
-- Part D: ACID Compliance
-- ==============================

-- Session 1: Valid + intentionally failing insert
BEGIN TRANSACTION;

BEGIN TRY
    -- Valid insert
    INSERT INTO dbo.FeePayments (payment_id, student_name, amount, payment_date)
    VALUES (7, 'Sneha', 4700.00, '2024-06-08');

    -- Invalid insert (duplicate ID)
    INSERT INTO dbo.FeePayments (payment_id, student_name, amount, payment_date)
    VALUES (1, 'Ashish', 5000.00, '2024-06-01');

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Session 1 rolled back due to error: ' + ERROR_MESSAGE();
END CATCH;
GO


-- Session 2: Independent successful transaction
BEGIN TRANSACTION;

INSERT INTO dbo.FeePayments (payment_id, student_name, amount, payment_date)
VALUES (8, 'Arjun', 4900.00, '2024-06-09');

COMMIT TRANSACTION;
GO


-- ==============================
-- Final Table State
-- ==============================
SELECT *
FROM dbo.FeePayments
ORDER BY payment_id;
GO
