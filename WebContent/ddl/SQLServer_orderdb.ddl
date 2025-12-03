CREATE DATABASE orders;
go

USE orders;
go

DROP TABLE review;
DROP TABLE shipment;
DROP TABLE productinventory;
DROP TABLE warehouse;
DROP TABLE orderproduct;
DROP TABLE incart;
DROP TABLE product;
DROP TABLE category;
DROP TABLE ordersummary;
DROP TABLE paymentmethod;
DROP TABLE customer;

CREATE TABLE customer (
    customerId          INT IDENTITY,
    firstName           VARCHAR(40),
    lastName            VARCHAR(40),
    email               VARCHAR(50),
    phonenum            VARCHAR(20),
    address             VARCHAR(50),
    city                VARCHAR(40),
    state               VARCHAR(20),
    postalCode          VARCHAR(20),
    country             VARCHAR(40),
    userid              VARCHAR(20),
    password            VARCHAR(30),
    PRIMARY KEY (customerId)
);

CREATE TABLE paymentmethod (
    paymentMethodId     INT IDENTITY,
    paymentType         VARCHAR(20),
    paymentNumber       VARCHAR(30),
    paymentExpiryDate   DATE,
    customerId          INT,
    PRIMARY KEY (paymentMethodId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE ordersummary (
    orderId             INT IDENTITY,
    orderDate           DATETIME,
    totalAmount         DECIMAL(10,2),
    shiptoAddress       VARCHAR(50),
    shiptoCity          VARCHAR(40),
    shiptoState         VARCHAR(20),
    shiptoPostalCode    VARCHAR(20),
    shiptoCountry       VARCHAR(40),
    customerId          INT,
    PRIMARY KEY (orderId),
    FOREIGN KEY (customerId) REFERENCES customer(customerid)
        ON UPDATE CASCADE ON DELETE CASCADE 
);

CREATE TABLE category (
    categoryId          INT IDENTITY,
    categoryName        VARCHAR(50),    
    PRIMARY KEY (categoryId)
);

CREATE TABLE product (
    productId           INT IDENTITY,
    productName         VARCHAR(40),
    productPrice        DECIMAL(10,2),
    productImageURL     VARCHAR(100),
    productImage        VARBINARY(MAX),
    productDesc         VARCHAR(1000),
    categoryId          INT,
    PRIMARY KEY (productId),
    FOREIGN KEY (categoryId) REFERENCES category(categoryId)
);

CREATE TABLE orderproduct (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE incart (
    orderId             INT,
    productId           INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (orderId, productId),
    FOREIGN KEY (orderId) REFERENCES ordersummary(orderId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE warehouse (
    warehouseId         INT IDENTITY,
    warehouseName       VARCHAR(30),    
    PRIMARY KEY (warehouseId)
);

CREATE TABLE shipment (
    shipmentId          INT IDENTITY,
    shipmentDate        DATETIME,   
    shipmentDesc        VARCHAR(100),   
    warehouseId         INT, 
    PRIMARY KEY (shipmentId),
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE productinventory ( 
    productId           INT,
    warehouseId         INT,
    quantity            INT,
    price               DECIMAL(10,2),  
    PRIMARY KEY (productId, warehouseId),   
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE NO ACTION,
    FOREIGN KEY (warehouseId) REFERENCES warehouse(warehouseId)
        ON UPDATE CASCADE ON DELETE NO ACTION
);

CREATE TABLE review (
    reviewId            INT IDENTITY,
    reviewRating        INT,
    reviewDate          DATETIME,   
    customerId          INT,
    productId           INT,
    reviewComment       VARCHAR(1000),          
    PRIMARY KEY (reviewId),
    FOREIGN KEY (customerId) REFERENCES customer(customerId)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (productId) REFERENCES product(productId)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =============================================
-- DATA POPULATION
-- =============================================

-- 1. CATEGORIES
INSERT INTO category(categoryName) VALUES ('Spray Paint');      -- ID 1
INSERT INTO category(categoryName) VALUES ('Bundles');          -- ID 2
INSERT INTO category(categoryName) VALUES ('Merchandise');      -- ID 3

-- 2. PRODUCTS
-- IDs 1-8: Matte Series
-- IDs 1-8: Matte Series
-- IDs 1-8: Matte Series
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Flat Black Matte', 1, 'Premium matte finish spray paint. Quick drying, industrial grade. Easy to wash formula. 400ml can.', 16.99, 'img/matte_black.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Pure White Matte', 1, 'Premium matte finish spray paint. Quick drying, industrial grade. Easy to wash formula. 400ml can.', 16.99, 'img/matte_white.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Bright Red Matte', 1, 'Premium matte finish spray paint. Quick drying, industrial grade. Easy to wash formula. 400ml can.', 16.99, 'img/matte_red.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Electric Blue Matte', 1, 'Premium matte finish spray paint. Quick drying, industrial grade. Easy to wash formula. 400ml can.', 16.99, 'img/matte_blue.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Cyan Blue Matte', 1, 'Premium matte finish spray paint. Quick drying, industrial grade. Easy to wash formula. 400ml can.', 16.99, 'img/matte_cyan.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Lemon Yellow Matte', 1, 'Premium matte finish spray paint. Quick drying, industrial grade. Easy to wash formula. 400ml can.', 16.99, 'img/matte_yellow.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Hot Pink Matte', 1, 'Premium matte finish spray paint. Quick drying, industrial grade. Easy to wash formula. 400ml can.', 16.99, 'img/matte_pink.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Silver Matte', 1, 'Premium matte finish spray paint. Quick drying, industrial grade. Easy to wash formula. 400ml can.', 16.99, 'img/matte_silver.png');

-- IDs 9-16: Gloss Series
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Flat Black Gloss', 1, 'High gloss finish for maximum shine and durability. Easy to wash formula. 400ml can.', 16.99, 'img/gloss_black.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Pure White Gloss', 1, 'High gloss finish for maximum shine and durability. Easy to wash formula. 400ml can.', 16.99, 'img/gloss_white.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Bright Red Gloss', 1, 'High gloss finish for maximum shine and durability. Easy to wash formula. 400ml can.', 16.99, 'img/gloss_red.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Electric Blue Gloss', 1, 'High gloss finish for maximum shine and durability. Easy to wash formula. 400ml can.', 16.99, 'img/gloss_blue.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Cyan Blue Gloss', 1, 'High gloss finish for maximum shine and durability. Easy to wash formula. 400ml can.', 16.99, 'img/gloss_cyan.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Lemon Yellow Gloss', 1, 'High gloss finish for maximum shine and durability. Easy to wash formula. 400ml can.', 16.99, 'img/gloss_yellow.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Hot Pink Gloss', 1, 'High gloss finish for maximum shine and durability. Easy to wash formula. 400ml can.', 16.99, 'img/gloss_pink.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Silver Gloss', 1, 'High gloss finish for maximum shine and durability. Easy to wash formula. 400ml can.', 16.99, 'img/gloss_silver.png');

-- IDs 17-24: Metallic Series
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Flat Black Metallic', 1, 'Metallic flake finish. Shimmers under light. Easy to wash formula. 400ml can.', 16.99, 'img/metallic_black.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Pure White Metallic', 1, 'Metallic flake finish. Shimmers under light. Easy to wash formula. 400ml can.', 16.99, 'img/metallic_white.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Bright Red Metallic', 1, 'Metallic flake finish. Shimmers under light. Easy to wash formula. 400ml can.', 16.99, 'img/metallic_red.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Electric Blue Metallic', 1, 'Metallic flake finish. Shimmers under light. Easy to wash formula. 400ml can.', 16.99, 'img/metallic_blue.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Cyan Blue Metallic', 1, 'Metallic flake finish. Shimmers under light. Easy to wash formula. 400ml can.', 16.99, 'img/metallic_cyan.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Lemon Yellow Metallic', 1, 'Metallic flake finish. Shimmers under light. Easy to wash formula. 400ml can.', 16.99, 'img/metallic_yellow.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Hot Pink Metallic', 1, 'Metallic flake finish. Shimmers under light. Easy to wash formula. 400ml can.', 16.99, 'img/metallic_pink.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Silver Metallic', 1, 'Metallic flake finish. Shimmers under light. Easy to wash formula. 400ml can.', 16.99, 'img/metallic_silver.png');

-- IDs 25-32: Satin Series
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Flat Black Satin', 1, 'Smooth satin finish. Low sheen, high coverage. Easy to wash formula. 400ml can.', 16.99, 'img/satin_black.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Pure White Satin', 1, 'Smooth satin finish. Low sheen, high coverage. Easy to wash formula. 400ml can.', 16.99, 'img/satin_white.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Bright Red Satin', 1, 'Smooth satin finish. Low sheen, high coverage. Easy to wash formula. 400ml can.', 16.99, 'img/satin_red.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Electric Blue Satin', 1, 'Smooth satin finish. Low sheen, high coverage. Easy to wash formula. 400ml can.', 16.99, 'img/satin_blue.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Cyan Blue Satin', 1, 'Smooth satin finish. Low sheen, high coverage. Easy to wash formula. 400ml can.', 16.99, 'img/satin_cyan.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Lemon Yellow Satin', 1, 'Smooth satin finish. Low sheen, high coverage. Easy to wash formula. 400ml can.', 16.99, 'img/satin_yellow.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Hot Pink Satin', 1, 'Smooth satin finish. Low sheen, high coverage. Easy to wash formula. 400ml can.', 16.99, 'img/satin_pink.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Silver Satin', 1, 'Smooth satin finish. Low sheen, high coverage. Easy to wash formula. 400ml can.', 16.99, 'img/satin_silver.png');

-- IDs 33-36: Finish Collections (Bundles)
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('The Matte Collection', 2, 'All 8 Matte colors. The complete set. Easy to wash formula. Includes 8 x 400ml cans.', 118.99, 'img/cloud_eight_matte_collection.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('The Gloss Collection', 2, 'All 8 Gloss colors. The complete set. Easy to wash formula. Includes 8 x 400ml cans.', 118.99, 'img/cloud_eight_gloss_collection.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('The Metallic Collection', 2, 'All 8 Metallic colors. The complete set. Easy to wash formula. Includes 8 x 400ml cans.', 118.99, 'img/cloud_eight_metallic_collection.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('The Satin Collection', 2, 'All 8 Satin colors. The complete set. Easy to wash formula. Includes 8 x 400ml cans.', 118.99, 'img/cloud_eight_satin_collection.png');

-- ID 37: Pro Bundle
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Cloud Eight PRO Bundle', 2, 'The entire spray paint collection. All 32 cans (4 Finishes x 8 Colors). Best Value. Easy to wash formula. Includes 32 x 400ml cans.', 419.99, 'img/cloud_eight_pro_bundle.png');
-- ID 38: Accessories
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Cloud Eight Accessories Kit', 3, 'Includes Design Handbook, Safety Kit, Cleanser Kit, and Nozzle Pack.', 62.99, 'img/cloud_eight_accessories_kit.png');

-- ID 39-40: Stickers
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Logo Sticker', 3, 'Vinyl die-cut sticker.', 6.99, 'img/cloud_eight_logo_sticker.png');
INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES ('Logo Sticker (Surf)', 3, 'Vinyl die-cut sticker.', 13.49, 'img/cloud_eight_logo_lunar_sticker.png');


-- 3. INVENTORY (Set all to 100 stock)
INSERT INTO warehouse(warehouseName) VALUES ('Main warehouse');

INSERT INTO productInventory(productId, warehouseId, quantity, price) SELECT productId, 1, 100, productPrice FROM product;


-- 4. CUSTOMERS
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Arnold', 'Anderson', 'a.anderson@gmail.com', '204-111-2222', '103 AnyWhere Street', 'Winnipeg', 'MB', 'R3X 45T', 'Canada', 'arnold' , '304Arnold!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Bobby', 'Brown', 'bobby.brown@hotmail.ca', '572-342-8911', '222 Bush Avenue', 'Boston', 'MA', '22222', 'United States', 'bobby' , '304Bobby!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Candace', 'Cole', 'cole@charity.org', '333-444-5555', '333 Central Crescent', 'Chicago', 'IL', '33333', 'United States', 'candace' , '304Candace!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Darren', 'Doe', 'oe@doe.com', '250-807-2222', '444 Dover Lane', 'Kelowna', 'BC', 'V1V 2X9', 'Canada', 'darren' , '304Darren!');
INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) VALUES ('Elizabeth', 'Elliott', 'engel@uiowa.edu', '555-666-7777', '555 Everwood Street', 'Iowa City', 'IA', '52241', 'United States', 'beth' , '304Beth!');


