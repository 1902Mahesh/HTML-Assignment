INSERT INTO public.customer (name, email, phone, persons, created_by)
VALUES
('John Doe', 'john@example.com', '1234567890', 2, 1),
('Alice Smith', 'alice@example.com', '9876543210', 3, 1),
('Bob Johnson', 'bob@example.com', '5556667777', 4, 1),
('Emily White', 'emily@example.com', '6667778888', 2, 1),
('Michael Brown', 'michael@example.com', '9998887777', 1, 1),
('Sophia Green', 'sophia@example.com', '1112223333', 2, 1),
('William Black', 'william@example.com', '2223334444', 3, 1),
('Emma Blue', 'emma@example.com', '3334445555', 1, 1),
('James Red', 'james@example.com', '4445556666', 2, 1),
('Olivia Yellow', 'olivia@example.com', '5556667777', 4, 1),
('Daniel Purple', 'daniel@example.com', '6667778888', 2, 1),
('Charlotte Orange', 'charlotte@example.com', '7778889999', 3, 1),
('Ethan Gray', 'ethan@example.com', '8889990000', 2, 1),
('Ava Silver', 'ava@example.com', '9990001111', 1, 1),
('Liam Gold', 'liam@example.com', '0001112222', 3, 1);


INSERT INTO public.orders (customerid, tableid, orderstatus, instruction, created_by, subtotal)
VALUES
(11, 1, 1, 'Less spicy', 1, 20.50),
(12, 1, 2, 'Extra cheese', 1, 35.00),
(13, 3, 3, 'No onions', 1, 15.75),
(14, 4, 4, 'Extra sauce', 1, 22.30),
(15, 1, 5, 'Gluten-free base', 1, 18.90),
(16, 1, 6, 'More veggies', 1, 25.00),
(17, 1, 7, 'Less salt', 1, 30.50),
(18, 1, 8, 'Spicy level 3', 1, 40.75),
(19, 1, 1, 'No garlic', 1, 12.60),
(20, 2, 2, 'Extra crispy', 1, 27.40),
(21, 3, 3, 'Less cheese', 1, 19.80),
(22, 3, 4, 'More butter', 1, 16.30),
(23, 1, 5, 'Less sugar', 1, 22.50),
(24, 2, 6, 'No pepper', 1, 33.90),
(25, 2, 7, 'Extra sauce', 1, 21.75);


INSERT INTO public.payments (orderid, customerid, methods, status, amount, created_by)
VALUES
(44, 11, 1, 2, 20.50, 1),
(45, 12, 2, 1, 35.00, 1),
(46, 13, 3, 3, 15.75, 1),
(47, 14, 4, 4, 22.30, 1),
(48, 15, 2, 1, 18.90, 1),
(49, 16, 1, 2, 25.00, 1),
(50, 17, 3, 3, 30.50, 1),
(51, 18, 4, 4, 40.75, 1),
(52, 19, 1, 2, 12.60, 1),
(53, 20, 2, 1, 27.40, 1),
(54, 21, 3, 3, 19.80, 1),
(55, 22, 4, 4, 16.30, 1),
(56, 23, 2, 1, 22.50, 1),
(57, 24, 1, 2, 33.90, 1),
(58, 25, 3, 3, 21.75, 1);

INSERT INTO public.customerreview (orderid, customerid, foodrating, servicerating, ambiencerating, average_rating, review, created_by)
VALUES
(44, 11, 4.5, 4.0, 4.2, 4.2, 'Great experience!', 1),
(45, 12, 5.0, 4.8, 4.5, 4.77, 'Loved the food and service!', 1),
(46, 13, 3.8, 3.5, 3.7, 3.67, 'Good but could be better.', 1),
(47, 14, 4.0, 4.2, 4.1, 4.1, 'Nice ambiance.', 1),
(48, 15, 4.7, 4.6, 4.8, 4.7, 'Amazing place!', 1),
(49, 16, 3.5, 3.2, 3.0, 3.23, 'Average experience.', 1),
(50, 17, 4.9, 4.7, 4.8, 4.8, 'Exceptional service!', 1),
(51, 18, 4.3, 4.1, 4.0, 4.13, 'Tasty food.', 1),
(52, 19, 3.6, 3.8, 3.5, 3.63, 'Decent place.', 1),
(53, 20, 4.2, 4.5, 4.4, 4.37, 'Will visit again!', 1),
(54, 21, 4.0, 4.3, 4.2, 4.17, 'Great service.', 1),
(55, 22, 3.7, 3.9, 3.6, 3.73, 'Satisfactory.', 1),
(56, 23, 4.5, 4.2, 4.0, 4.23, 'Good ambiance.', 1),
(57, 24, 4.8, 4.6, 4.5, 4.63, 'Loved the food!', 1),
(58, 25, 3.9, 3.7, 3.8, 3.8, 'Decent experience.', 1);

INSERT INTO public.payments (orderid, customerid, methods, status, amount)
VALUES
(44, 11, 1, 4, 20.50),
(45, 12, 2, 5, 35.00),
(46, 13, 3, 6, 15.75),
(47, 14, 4, 4, 22.30),
(48, 15, 2, 5, 18.90),
(49, 16, 1, 6, 25.00),
(50, 17, 3, 4, 30.50),
(51, 18, 4, 5, 40.75),
(52, 19, 1, 6, 12.60),
(53, 20, 2, 4, 27.40),
(54, 21, 3, 5, 19.80),
(55, 22, 4, 6, 16.30),
(56, 23, 2, 4, 22.50),
(57, 24, 1, 5, 33.90),
(58, 25, 3, 6, 21.75);


