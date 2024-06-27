-- Create restaurant table
CREATE TABLE restaurant (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(100),
    rating DECIMAL(3, 1),
    telephone CHAR(10),
    hour VARCHAR(100)
);

-- Create address table
CREATE TABLE address (
    id SERIAL PRIMARY KEY,
    street_number VARCHAR(10),
    street_name VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    google_map_link VARCHAR(100),
    restaurant_id INTEGER REFERENCES restaurant(id) UNIQUE
);

-- Create category table
CREATE TABLE category (
    id CHAR(2) PRIMARY KEY,
    name VARCHAR(50),
    description VARCHAR(200)
);

-- Create dish table
CREATE TABLE dish (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description VARCHAR(200),
    hot_and_spicy BOOLEAN
);

-- Create review table
CREATE TABLE review (
    id SERIAL PRIMARY KEY,
    rating DECIMAL(3, 1),
    description VARCHAR(200),
    date DATE,
    restaurant_id INTEGER REFERENCES restaurant(id)
);

-- Create categories_dishes table for many-to-many relationship
CREATE TABLE categories_dishes (
    category_id CHAR(2) REFERENCES category(id),
    dish_id INTEGER REFERENCES dish(id),
    price MONEY,
    PRIMARY KEY (category_id, dish_id)
);

-- Insert data into restaurant table
INSERT INTO restaurant (id, name, description, rating, telephone, hour)
VALUES
    (1, 'Bytes of China', 'Delectable Chinese Cuisine', 3.9, '6175551212', 'Mon - Fri 9:00 am to 9:00 pm, Weekends 10:00 am to 11:00 pm');

-- Insert data into address table
INSERT INTO address (id, street_number, street_name, city, state, google_map_link, restaurant_id)
VALUES
    (1, '2020', 'Busy Street', 'Chinatown', 'MA', 'http://bit.ly/BytesOfChina', 1);

-- Insert data into review table
INSERT INTO review (id, rating, description, date, restaurant_id)
VALUES
    (1, 5.0, 'Would love to host another birthday party at Bytes of China!', '2020-05-22', 1),
    (2, 4.5, 'Other than a small mix-up, I would give it a 5.0!', '2020-01-04', 1),
    (3, 3.9, 'A reasonable place to eat for lunch, if you are in a rush!', '2020-03-15', 1);

-- Insert data into category table
INSERT INTO category (id, name, description)
VALUES
    ('C', 'Chicken', NULL),
    ('LS', 'Luncheon Specials', 'Served with Hot and Sour Soup or Egg Drop Soup and Fried or Steamed Rice  between 11:00 am and 3:00 pm from Monday to Friday.'),
    ('HS', 'House Specials', NULL);

-- Insert data into dish table
INSERT INTO dish (id, name, description, hot_and_spicy)
VALUES
    (1, 'Chicken with Broccoli', 'Diced chicken stir-fried with succulent broccoli florets', FALSE),
    (2, 'Sweet and Sour Chicken', 'Marinated chicken with tangy sweet and sour sauce together with pineapples and green peppers', FALSE),
    (3, 'Chicken Wings', 'Finger-licking mouth-watering entree to spice up any lunch or dinner', TRUE),
    (4, 'Beef with Garlic Sauce', 'Sliced beef steak marinated in garlic sauce for that tangy flavor', TRUE),
    (5, 'Fresh Mushroom with Snow Peapods and Baby Corns', 'Colorful entree perfect for vegetarians and mushroom lovers', FALSE),
    (6, 'Sesame Chicken', 'Crispy chunks of chicken flavored with savory sesame sauce', FALSE),
    (7, 'Special Minced Chicken', 'Marinated chicken breast sauteed with colorful vegetables topped with pine nuts and shredded lettuce.', FALSE),
    (8, 'Hunan Special Half & Half', 'Shredded beef in Peking sauce and shredded chicken in garlic sauce', TRUE);

-- Insert data into categories_dishes table
INSERT INTO categories_dishes (category_id, dish_id, price)
VALUES
    ('C', 1, 6.95),
    ('C', 3, 6.95),
    ('LS', 1, 8.95),
    ('LS', 4, 8.95),
    ('LS', 5, 8.95),
    ('HS', 6, 15.95),
    ('HS', 7, 16.95),
    ('HS', 8, 17.95);

-- Example queries

-- [1] Join to get restaurant details with address
SELECT r.name AS restaurant_name, r.telephone, a.street_number, a.street_name
FROM restaurant r
JOIN address a ON r.id = a.restaurant_id;

-- [2] Get the highest rating from reviews
SELECT MAX(rating) AS best_rating
FROM review;

-- [3] List dishes with their categories and prices, ordered by dish name
SELECT d.name AS dish_name, cd.price, c.name AS category
FROM dish d
JOIN categories_dishes cd ON d.id = cd.dish_id
JOIN category c ON cd.category_id = c.id
ORDER BY d.name;

-- [4] List categories with dishes and prices, ordered by category name
SELECT c.name AS category, d.name AS dish_name, cd.price
FROM category c
JOIN categories_dishes cd ON c.id = cd.category_id
JOIN dish d ON cd.dish_id = d.id
ORDER BY c.name;

-- [5] List spicy dishes with their categories and prices
SELECT d.name AS spicy_dish_name, c.name AS category, cd.price
FROM dish d
JOIN categories_dishes cd ON d.id = cd.dish_id
JOIN category c ON cd.category_id = c.id
WHERE d.hot_and_spicy = TRUE;

-- [6] Count the number of dishes in each category
SELECT cd.category_id, COUNT(cd.dish_id) AS dish_count
FROM categories_dishes cd
GROUP BY cd.category_id
ORDER BY cd.category_id;

-- [7] Count categories with more than one dish
SELECT cd.category_id, COUNT(cd.dish_id) AS dish_count
FROM categories_dishes cd
GROUP BY cd.category_id
HAVING COUNT(cd.dish_id) > 1
ORDER BY cd.category_id;

-- [8] List dishes with the number of categories they belong to, ordered by dish name
SELECT d.name AS dish_name, d.id AS dish_id, COUNT(cd.category_id) AS category_count
FROM dish d
JOIN categories_dishes cd ON d.id = cd.dish_id
GROUP BY d.id, d.name
ORDER BY d.name;

-- [9] List reviews with the maximum rating
SELECT r.rating, r.description
FROM review r
WHERE r.rating = (SELECT MAX(rating) FROM review);
