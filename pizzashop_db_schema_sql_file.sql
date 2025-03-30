-- 1. User Table

CREATE Table Users (
	id bigserial PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(255) NOT NULL,
	firstName VARCHAR(50) NOT NULL,
	lastName VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL,
	imgUrl VARCHAR(255),
	status BOOLEAN NOT NULL DEFAULT false,
	roleId	BIGINT NOT NULL REFERENCES Role(role_id),
	countryId	BIGINT NOT NULL REFERENCES Country(country_id),
	stateId	BIGINT NOT NULL REFERENCES State(state_id),
	cityId	BIGINT NOT NULL,
	address	VARCHAR NOT NULL,
	zipcode	INTEGER NOT NULL,
	phone	INTEGER NOT NULL,
	created_at	TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at	TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted	BOOLEAN NOT NULL DEFAULT false
)


-- alter table Users add column created_by BIGINT NOT NULL REFERENCES Users(id)

-- Country, State And City Table
-- 2.
CREATE TABLE Country(
	country_id bigserial PRIMARY KEY,
	name VARCHAR(50) NOT NULL
)

-- 3.
CREATE TABLE State(
	state_id bigserial PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	countryId BIGINT NOT NULL REFERENCES Country(country_id)
)

-- 4.
CREATE TABLE City(
	city_id bigserial PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	stateId BIGINT NOT NULL REFERENCES State(state_id)
)

-- Roles And Permissions
-- 5.
CREATE TABLE Role(
	role_id bigserial PRIMARY KEY,
	roleName VARCHAR(50) NOT NULL
)

-- 6.
CREATE TABLE Permissions(
	permission_id bigserial PRIMARY KEY,
	name VARCHAR(50) NOT NULL
)

-- Table No. 7
CREATE TABLE RolesAndPermission(
	id bigserial PRIMARY KEY,
	roleId	BIGINT NOT NULL REFERENCES Role(role_id),
	permissionId BIGINT NOT NULL REFERENCES Permissions(permission_id),
	canView BOOLEAN NOT NULL DEFAULT false,
	canAddEdit BOOLEAN NOT NULL DEFAULT false,
	canDelete BOOLEAN NOT NULL DEFAULT false,
	created_at	TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at	TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted	BOOLEAN NOT NULL DEFAULT false
)

-- Menu
-- Categories
-- 8.
 CREATE TABLE Categories(
	category_id BIGSERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	description VARCHAR(255),
	created_at	TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at	TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted	BOOLEAN NOT NULL DEFAULT false
 )


-- 9. Items
 CREATE TABLE Items(
	item_id BIGSERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	description VARCHAR(255),
	itemType_id BIGINT NOT NULL REFERENCES ItemTypes(id),
	rate DECIMAL(10, 2) NOT NULL,
	unitId BIGINT NOT NULL REFERENCES Units(unit_id),
	quantity INTEGER NOT NULL DEFAULT 1,
	additional_Tax DECIMAL(10, 2) NOT NULL DEFAULT 0,
	default_Tax BOOLEAN NOT NULL DEFAULT false,
	taxId BIGINT NOT NULL REFERENCES Taxes(id),
	isAvailable BOOLEAN NOT NULL DEFAULT false,
	shortCode VARCHAR(50),
	imgUrl VARCHAR(255),
	categoryId BIGINT NOT NULL REFERENCES Categories(category_id),
	created_at	TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at	TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted	BOOLEAN NOT NULL DEFAULT false
 )


-- eg. veg, non-veg, vegan
-- 10.
CREATE TABLE ItemTypes(
	id BIGSERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	imgUrl VARCHAR(255)
)


-- ex. pcs, kg, Kilo etc.
-- 11. 

CREATE TABLE Units(
	unit_id BIGSERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
)

-- Modifiers
-- 12.
 CREATE TABLE ModifierGroup(
	id	BIGSERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	description	VARCHAR(255),
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
 )

 
-- Modifier Item
-- 13. 
 CREATE TABLE ModifierItems(
	id	BIGSERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	description	VARCHAR(255),
	modifier_group_id BIGINT NOT NULL REFERENCES ModifierGroup(id),
	rate DECIMAL(10, 2),
	unitId BIGINT NOT NULL REFERENCES Units(unit_id),
	quantity INTEGER NOT NULL DEFAULT 1,
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
 )

 -- Sections
 -- 14. 
 CREATE TABLE Sections(
	section_id	BIGSERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	description	VARCHAR(255),
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
 )

 -- Tables
-- 15. 
-- CREATE TYPE Table_Status AS ENUM ('Available', 'Selected', 'Assigned', 'Running');
 
 CREATE TABLE Tables(
	id	BIGSERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	sectionId BIGINT NOT NULL REFERENCES Sections(section_id),
	capacity INTEGER NOT NULL DEFAULT 3,
	table_status BIGINT NOT NULL REFERENCES Table_Status(id),
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
 )

 -- Taxes And Fees
 -- 16. 
 CREATE TABLE Taxes(
	id	BIGSERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	-- type i) Percentage  --0  ii)Flat Amount --1
	taxType BOOLEAN NOT NULL DEFAULT false,
	amount DECIMAL(10, 2) NOT NULL,
	isEnabled BOOLEAN NOT NULL DEFAULT false,
	default_tax BOOLEAN NOT NULL DEFAULT true,
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
 )


 -- Orders
 -- 17.
-- CREATE TYPE order_status AS ENUM ('Pending', 'InProgress', 'Completed', 'Running');
 
 CREATE TABLE Orders(
	id	BIGSERIAL PRIMARY KEY,
	customerId BIGINT NOT NULL REFERENCES Customer(customer_id),
	tableId BIGINT NOT NULL REFERENCES Tables(id),
	orderDate TIMESTAMP NOT NULL,
	orderStatus BIGINT NOT NULL REFERENCES Order_Status(id),
	instruction VARCHAR(120),
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
 )

-- select * from Orders;
--18
 CREATE TABLE OrderTableMapping(
	id BIGSERIAL PRIMARY KEY,
	orderId BIGINT NOT NULL REFERENCES Orders(id),
	tableId BIGINT NOT NULL REFERENCES Tables(id)
 )

	-- DROP TABLE OrderTableMapping;

 -- 19.
 CREATE TABLE OrderDetails(
	id	BIGSERIAL PRIMARY KEY,
	orderId BIGINT NOT NULL REFERENCES Orders(id),
	itemID BIGINT NOT NULL REFERENCES Items(item_id),
	quantity INTEGER NOT NULL DEFAULT 1,
	price DECIMAL(10,2),
	instruction VARCHAR(120)
 )

 -- 20.
 CREATE TABLE OrderitemsModifier(
	id	BIGSERIAL PRIMARY KEY,
	order_item_id BIGINT NOT NULL REFERENCES OrderDetails(id),
	modifier_item_id BIGINT NOT NULL REFERENCES ModifierItems(id),
	rate DECIMAL(10, 2),
	quantity INTEGER NOT NULL DEFAULT 1
 )

 -- drop table OrderitemsModifier;

-- Customers Table
-- 21. 
CREATE TABLE Customer(
	customer_id BIGSERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	email VARCHAR(100) NOT NULL,
	phone INTEGER NOT NULL,
	persons INTEGER NOT NULL DEFAULT 1,
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
)


-- Waiting List
-- 22.
CREATE TABLE WaitingList(
	id BIGSERIAL PRIMARY KEY,
	customerId BIGINT NOT NULL REFERENCES Customer(customer_id),
	sectionId BIGINT NOT NULL REFERENCES Sections(section_id),
	persons INTEGER NOT NULL DEFAULT 1,
	is_assigned BOOLEAN NOT NULL DEFAULT false,
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
)

-- Customer Review
-- 23. 
CREATE TABLE CustomerReview(
	id BIGSERIAL PRIMARY KEY,
	customerId BIGINT NOT NULL REFERENCES Customer(customer_id),
	foodRating INTEGER NOT NULL DEFAULT 0,
	serviceRating INTEGER NOT NULL DEFAULT 0,
	ambienceRating INTEGER NOT NULL DEFAULT 0,
	average_rating INTEGER NOT NULL DEFAULT 0,
	review VARCHAR(100),
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
)

-- KOT Table
-- 24. 
CREATE TABLE KOT(
	id BIGSERIAL PRIMARY KEY,
	orderId BIGINT NOT NULL REFERENCES Orders(id),
	status BOOLEAN NOT NULL DEFAULT false,
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
)

-- Book Table
-- 25. 
CREATE TABLE BookTable(
	id BIGSERIAL PRIMARY KEY,
	orderId BIGINT NOT NULL REFERENCES Orders(id),
	customerId BIGINT NOT NULL REFERENCES Customer(customer_id),
	persons INTEGER DEFAULT 1,
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
)

-- Payment
-- 26. 
-- CREATE TYPE PayentMethods AS ENUM ('Cash', 'UPI', 'Card');


CREATE TABLE Payments(
	id BIGSERIAL PRIMARY KEY,
	orderId BIGINT NOT NULL REFERENCES Orders(id),
	customerId BIGINT NOT NULL REFERENCES Customer(customer_id),
	methods BIGINT NOT NULL REFERENCES PaymentMethods(id),
	status BIGINT NOT NULL REFERENCES PaymentStatus(id),
	paymentDate TIMESTAMP NOT NULL,
	amount DECIMAL(10, 2) NOT NULL
)

-- 27. 
CREATE TABLE PaymentStatus(
	id BIGSERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL
)


-- Favirote Items
-- 28. 
CREATE TABLE FavoriteItem(
	id BIGSERIAL PRIMARY KEY,
	orderId BIGINT NOT NULL REFERENCES Orders(id),
	customerId BIGINT NOT NULL REFERENCES Customer(customer_id),
	isFavorite BOOLEAN NOT NULL DEFAULT false
)

-- Invoice 
--29
CREATE TABLE Invoices(
	id bigserial PRIMARY KEY,
	orderId BIGINT NOT NULL REFERENCES Orders(id)
)

-- DROP TABLE Invoices;
--30
CREATE TABLE InvoiceTaxMapping(
	id BIGSERIAL PRIMARY KEY,
	invoiceId BIGINT NOT NULL REFERENCES Invoices(id),
	taxName VARCHAR(50),
	taxValue DECIMAL(10,2)
)

-- Status Tables
--31
CREATE TABLE Table_Status(
	id bigserial PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT 'Available'
)

--32
CREATE TABLE Order_Status(
	id bigserial PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT 'InProgress'
)

--33
CREATE TABLE PaymentMethods(
	id bigserial PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT 'Available'
)

--34
CREATE TABLE Reset_Password_Token(
	id bigserial PRIMARY KEY,
	email VARCHAR(50) NOT NULL,
	token VARCHAR(100) NOT NULL,
	is_used BOOLEAN NOT NULL DEFAULT false,
	expiryTime TIMESTAMP NOT NULL DEFAULT (CURRENT_TIMESTAMP + '24:00:00'::interval)
)

--35
CREATE TABLE ModifierGroupItemMap(
	id bigserial PRIMARY KEY,
	modifier_group_id BIGINT NOT NULL REFERENCES ModifierGroup(id),
	modifier_item_id BIGINT NOT NULL REFERENCES ModifierItems(id),
	created_at TIMESTAMP NOT NULL DEFAULT now() ,
	updated_at TIMESTAMP,
	created_by	BIGINT NOT NULL REFERENCES Users(id),
	updated_by	BIGINT REFERENCES Users(id),
	isDeleted BOOLEAN NOT NULL DEFAULT false
)

--36
CREATE TABLE IF NOT EXISTS public.itemmodifiergroup
(
    id bigint NOT NULL DEFAULT nextval('itemmodifiergroup_id_seq'::regclass),
    itemid bigint NOT NULL,
    modifier_group_id bigint NOT NULL,
    max_allowed integer DEFAULT 0,
    min_allowed integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL DEFAULT now(),
    updated_at timestamp without time zone,
    created_by bigint NOT NULL,
    updated_by bigint,
    isdeleted boolean NOT NULL DEFAULT false,
    CONSTRAINT itemmodifiergroup_pkey PRIMARY KEY (id),
    CONSTRAINT itemmodifiergroup_created_by_fkey FOREIGN KEY (created_by)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT itemmodifiergroup_itemid_fkey FOREIGN KEY (itemid)
        REFERENCES public.items (item_id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT itemmodifiergroup_modifier_group_id_fkey FOREIGN KEY (modifier_group_id)
        REFERENCES public.modifiergroup (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT itemmodifiergroup_updated_by_fkey FOREIGN KEY (updated_by)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)
