CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Country VARCHAR(100),
    SignupDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Category VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL
);

CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    TotalAmount DECIMAL(10,2) NOT NULL,
    Status VARCHAR(50) CHECK (Status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);

CREATE TABLE OrderDetails (
    OrderDetailID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    PaymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(50) CHECK (PaymentMethod IN ('Credit Card', 'PayPal', 'Bank Transfer')),
    Amount DECIMAL(10,2) NOT NULL
);

-- Insert dummy customers
INSERT INTO Customers (CustomerName, Email, Country, SignupDate) VALUES
('John Doe', 'john.doe@example.com', 'USA', '2023-01-10'),
('Alice Smith', 'alice.smith@example.com', 'Canada', '2023-02-15'),
('Bob Johnson', 'bob.johnson@example.com', 'UK', '2023-03-20'),
('Emily Davis', 'emily.davis@example.com', 'Australia', '2023-04-05'),
('Michael Brown', 'michael.brown@example.com', 'Germany', '2023-05-12'),
('Sarah Wilson', 'sarah.wilson@example.com', 'France', '2023-06-08'),
('David Lee', 'david.lee@example.com', 'Japan', '2023-07-21'),
('Emma Garcia', 'emma.garcia@example.com', 'Mexico', '2023-08-30'),
('James Miller', 'james.miller@example.com', 'India', '2023-09-14'),
('Sophia Martinez', 'sophia.martinez@example.com', 'Spain', '2023-10-25');


-- Insert dummy products
INSERT INTO Products (ProductName, Category, Price, StockQuantity) VALUES
('Laptop', 'Electronics', 1000.00, 15),
('Smartphone', 'Electronics', 700.00, 20),
('Headphones', 'Accessories', 50.00, 50),
('Smartwatch', 'Electronics', 250.00, 30),
('Bluetooth Speaker', 'Accessories', 80.00, 40),
('Gaming Mouse', 'Accessories', 40.00, 35),
('Keyboard', 'Accessories', 60.00, 25),
('Office Chair', 'Furniture', 150.00, 10),
('Coffee Maker', 'Home Appliances', 120.00, 12),
('LED Monitor', 'Electronics', 300.00, 18);


-- Insert dummy orders
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, Status) VALUES
(1, '2023-03-05', 1700.00, 'Delivered'),
(2, '2023-03-08', 50.00, 'Pending'),
(1, '2023-04-10', 500.00, 'Shipped'),
(2, '2023-05-12', 80.00, 'Cancelled'),
(3, '2023-06-15', 1000.00, 'Delivered'),
(5, '2023-07-20', 700.00, 'Pending'),
(2, '2023-08-25', 150.00, 'Shipped'),
(8, '2023-09-10', 120.00, 'Delivered'),
(4, '2023-10-18', 90.00, 'Pending'),
(6, '2023-11-22', 60.00, 'Shipped');



-- Insert dummy order details
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price) VALUES
(1, 1, 1, 1000.00),  
(1, 2, 1, 700.00),  
(2, 3, 1, 50.00),   
(3, 6, 1, 500.00),  
(4, 4, 1, 80.00),    
(5, 1, 1, 1000.00),  
(6, 2, 1, 700.00),   
(7, 5, 1, 150.00),   
(8, 8, 1, 120.00),   
(9, 9, 1, 90.00);   


INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, Amount) VALUES
(1, '2023-03-06', 'Credit Card', 1700.00),  
(2, '2023-03-09', 'PayPal', 50.00),         
(3, '2023-04-11', 'Bank Transfer', 500.00), 
(4, '2023-05-13', 'Credit Card', 80.00),    
(5, '2023-06-16', 'PayPal', 1000.00),       
(6, '2023-07-21', 'Credit Card', 700.00),   
(7, '2023-08-26', 'Bank Transfer', 150.00), 
(8, '2023-09-11', 'PayPal', 120.00),        
(9, '2023-10-19', 'Credit Card', 90.00),    
(10, '2023-11-23', 'Bank Transfer', 60.00); 


-- 1. Query: Total Sales Per Product Category
select p.Category,
SUM(od.Quantity * od.Price) AS "Total Sales"
from OrderDetails as od
JOIN Products as p
ON p.ProductID = od.ProductID
GROUP BY p.Category
ORDER BY "Total Sales"