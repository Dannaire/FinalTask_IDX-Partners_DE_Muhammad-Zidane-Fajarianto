-- Create the DWH_Project Database
CREATE DATABASE DWH_Project;

-- Create the DimStatusOrder table
CREATE TABLE DimStatusOrder (
    StatusID INT NOT NULL,
    StatusOrder VARCHAR(50) NOT NULL,
    StatusOrderDesc VARCHAR(50) NOT NULL,
    CONSTRAINT PK_StatusOrder PRIMARY KEY (StatusID)
);

-- Create the DimProduct table
CREATE TABLE DimProduct (
    ProductID INT NOT NULL,
    ProductName VARCHAR(255) NOT NULL,
    ProductCategory VARCHAR(255) NOT NULL,
    ProductUnitPrice INT NOT NULL,
    CONSTRAINT PK_Product PRIMARY KEY (ProductID)
);

-- Create the DimCustomer table
CREATE TABLE DimCustomer (
    CustomerID INT NOT NULL,
    CustomerName VARCHAR(50) NOT NULL,
    Age INT NOT NULL,
    Gender VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    NoHP VARCHAR(50) NOT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY (CustomerID)
);

-- Create the FactSalesOrder table
CREATE TABLE FactSalesOrder (
    OrderID INT NOT NULL,
    CustomerID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Amount INT NOT NULL,
    StatusID INT NOT NULL,
    OrderDate DATE NOT NULL,
    CONSTRAINT PK_SalesOrder PRIMARY KEY (OrderID),
    CONSTRAINT FK_Customer FOREIGN KEY (CustomerID) REFERENCES DimCustomer (CustomerID),
    CONSTRAINT FK_Product FOREIGN KEY (ProductID) REFERENCES DimProduct (ProductID),
    CONSTRAINT FK_StatusOrder FOREIGN KEY (StatusID) REFERENCES DimStatusOrder (StatusID)
);

-- Create the summary_order_status Stored Procedure
CREATE PROCEDURE summary_order_status
    @StatusID INT
AS
BEGIN
    SELECT 
        a.OrderID, 
        b.CustomerName, 
        c.ProductName, 
        a.Quantity, 
        d.StatusOrder
    FROM FactSalesOrder a
    INNER JOIN DimCustomer b ON a.CustomerID = b.CustomerID
    INNER JOIN DimProduct c ON a.ProductID = c.ProductID
    INNER JOIN DimStatusOrder d ON a.StatusID = d.StatusID
    WHERE d.StatusID = @StatusID;
END;

-- Execute the summary_order_status Stored Procedure with StatusID 1 (Awaiting Shipment/Menunggu Pembayaran)
EXEC summary_order_status @StatusID = 1;

-- Execute the summary_order_status Stored Procedure with StatusID 2 (Awaiting Shipment/Menunggu Pembayaran)
EXEC summary_order_status @StatusID = 2;

-- Execute the summary_order_status Stored Procedure with StatusID 3 (Shipped/Sedang Dikirim)
EXEC summary_order_status @StatusID = 3;

-- Execute the summary_order_status Stored Procedure with StatusID 4 (Completed/Pesanan Sampai Tujuan)
EXEC summary_order_status @StatusID = 4;

-- Execute the summary_order_status Stored Procedure with StatusID 5 (Cancelled/Pesanan dibatalkan oleh customer)
EXEC summary_order_status @StatusID = 5;
