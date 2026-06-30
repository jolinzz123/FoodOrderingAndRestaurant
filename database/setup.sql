-- ============================================================
--  FoodOrder & Restaurant Management System — Database Setup
--  Run this entire file in MySQL Workbench to get started.
--  Steps: open MySQL Workbench → paste → Ctrl+Shift+Enter
-- ============================================================

CREATE DATABASE IF NOT EXISTS food_order_db DEFAULT CHARACTER SET utf8mb4;
USE food_order_db;

-- --------------------------------------------------------
-- Tables
-- --------------------------------------------------------

CREATE TABLE IF NOT EXISTS categories (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS food_items (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    category_id      INT,
    name             VARCHAR(200) NOT NULL,
    description      TEXT,
    ingredients      TEXT,
    nutritional_info TEXT,
    price            DECIMAL(10,2) NOT NULL,
    image_url        VARCHAR(500) DEFAULT 'images/placeholder.jpg',
    rating           DOUBLE       DEFAULT 0.0,
    is_available     BOOLEAN      DEFAULT TRUE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS addons (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    food_item_id INT NOT NULL,
    name         VARCHAR(100) NOT NULL,
    extra_price  DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (food_item_id) REFERENCES food_items(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(100) NOT NULL UNIQUE,
    email         VARCHAR(200) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone         VARCHAR(20),
    role          VARCHAR(20)  DEFAULT 'CUSTOMER',
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS orders (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    user_id     INT NOT NULL,
    total_price DECIMAL(10,2),
    status      VARCHAR(50) DEFAULT 'PENDING',
    created_at  TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS order_items (
    id       INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    food_id  INT NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (food_id)  REFERENCES food_items(id)
);

CREATE TABLE IF NOT EXISTS order_item_addons (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    order_item_id INT NOT NULL,
    addon_id      INT NOT NULL,
    FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE CASCADE,
    FOREIGN KEY (addon_id)      REFERENCES addons(id)
);

-- --------------------------------------------------------
-- Categories
-- --------------------------------------------------------
INSERT INTO categories (name) VALUES
('Nasi'),
('Mee'),
('Roti'),
('Lauk'),
('Western'),
('Desserts'),
('Drinks');

-- --------------------------------------------------------
-- Food Items
-- --------------------------------------------------------
INSERT INTO food_items (category_id, name, description, ingredients, nutritional_info, price, rating, is_available) VALUES
-- Nasi (1)
(1,'Nasi Lemak Special','Malaysia national dish — fragrant coconut rice served with sambal, fried anchovies, peanuts, cucumber and half-boiled egg','Coconut rice, sambal tumis, ikan bilis, peanuts, cucumber, egg','Calories: 490 | Protein: 14g | Carbs: 58g | Fat: 22g',8.90,4.9,TRUE),
(1,'Nasi Goreng Kampung','Village-style fried rice with anchovies, chilli and egg — a true Malaysian comfort food','Rice, ikan bilis, egg, chilli, soy sauce, belacan, vegetables','Calories: 520 | Protein: 16g | Carbs: 65g | Fat: 18g',9.50,4.8,TRUE),
(1,'Nasi Dagang','Terengganu specialty — glutinous rice cooked in coconut milk served with tuna curry','Glutinous rice, coconut milk, ikan tongkol curry, hard-boiled egg, pickled cucumber','Calories: 580 | Protein: 22g | Carbs: 70g | Fat: 20g',12.90,4.7,TRUE),
(1,'Nasi Ayam Hainan','Silky poached chicken over fragrant rice with ginger sauce and clear soup','Chicken, jasmine rice, ginger, garlic, sesame oil, soy sauce, chilli sauce','Calories: 540 | Protein: 30g | Carbs: 60g | Fat: 14g',11.90,4.8,TRUE),
-- Mee (2)
(2,'Laksa Lemak','Rich and creamy coconut-based noodle soup with prawns and fish cake','Rice vermicelli, coconut milk, lemongrass, galangal, turmeric, prawns, fish cake, bean sprouts','Calories: 550 | Protein: 20g | Carbs: 52g | Fat: 26g',12.90,4.9,TRUE),
(2,'Char Kuey Teow','Wok-hei flat rice noodles stir-fried with prawns, egg, cockles and bean sprouts','Flat rice noodles, prawns, egg, cockles, bean sprouts, chilli, dark soy sauce','Calories: 480 | Protein: 18g | Carbs: 60g | Fat: 16g',11.90,4.8,TRUE),
(2,'Mee Goreng Mamak','Spicy Indian-Muslim style fried yellow noodles with tofu, potato and tomato','Yellow noodles, tofu, potato, egg, tomato, bean sprouts, sambal, lime','Calories: 460 | Protein: 14g | Carbs: 62g | Fat: 14g',9.90,4.7,TRUE),
(2,'Asam Laksa','Tangy tamarind-based fish noodle soup topped with pineapple and mint — Penang classic','Rice noodles, mackerel, tamarind, lemongrass, pineapple, cucumber, mint, prawn paste','Calories: 380 | Protein: 18g | Carbs: 55g | Fat: 8g',11.90,4.8,TRUE),
-- Roti (3)
(3,'Roti Canai','Flaky crispy flatbread served with dhal curry and sambal — Malaysian breakfast staple','Flour, butter, egg, salt, dhal curry, sambal','Calories: 320 | Protein: 8g | Carbs: 48g | Fat: 12g',3.50,4.9,TRUE),
(3,'Roti Telur Bawang','Crispy flatbread stuffed with egg and onion, served with curry sauce','Flour, egg, onion, butter, curry sauce','Calories: 380 | Protein: 12g | Carbs: 46g | Fat: 16g',4.50,4.7,TRUE),
(3,'Roti Bakar Kaya','Toasted bread generously spread with homemade pandan kaya and butter','White bread, kaya jam, butter, pandan','Calories: 280 | Protein: 6g | Carbs: 40g | Fat: 12g',4.90,4.8,TRUE),
(3,'Tosai','Crispy South Indian fermented rice crepe served with coconut chutney and sambar','Fermented rice batter, coconut chutney, sambar lentil curry','Calories: 180 | Protein: 6g | Carbs: 34g | Fat: 4g',4.50,4.6,TRUE),
-- Lauk (4)
(4,'Ayam Percik','Kelantan-style grilled chicken glazed with rich spiced coconut sauce','Whole chicken, coconut milk, lemongrass, galangal, turmeric, chilli, kaffir lime','Calories: 440 | Protein: 36g | Fat: 26g | Carbs: 12g',18.90,4.9,TRUE),
(4,'Satay Campur','10 skewers of grilled chicken and beef satay served with peanut sauce, ketupat and cucumber','Chicken, beef, lemongrass, turmeric, coriander, peanut sauce, ketupat, cucumber, onion','Calories: 480 | Protein: 34g | Fat: 22g | Carbs: 28g',16.90,4.9,TRUE),
(4,'Rendang Daging','Slow-cooked dry beef curry with aromatic spices and toasted coconut — rich and intense','Beef, coconut milk, kerisik, lemongrass, galangal, chilli, kaffir lime leaves','Calories: 520 | Protein: 38g | Fat: 30g | Carbs: 10g',19.90,4.8,TRUE),
(4,'Ikan Bakar','Whole grilled fish marinated in spicy sambal paste, wrapped in banana leaf','Stingray or tilapia, sambal, turmeric, lemongrass, banana leaf, lime','Calories: 360 | Protein: 32g | Fat: 16g | Carbs: 8g',22.90,4.8,TRUE),
-- Western (5)
(5,'Pepperoni Pizza','Classic tomato base loaded with pepperoni and mozzarella','Tomato sauce, mozzarella, pepperoni, oregano','Calories: 300 per slice | Protein: 14g | Carbs: 30g',21.90,4.6,TRUE),
(5,'Classic Beef Burger','Juicy beef patty with lettuce, tomato, pickles and special sauce','Beef patty, brioche bun, lettuce, tomato, pickles, special sauce','Calories: 520 | Protein: 28g | Carbs: 42g',14.90,4.5,TRUE),
(5,'Prawn Aglio Olio','Spaghetti tossed with garlic, chilli flakes and fresh prawns','Spaghetti, prawns, garlic, chilli flakes, olive oil, parsley','Calories: 490 | Protein: 24g | Carbs: 58g',19.90,4.6,TRUE),
-- Desserts (6)
(6,'Cendol','Shaved ice dessert with pandan jelly, red beans, coconut milk and gula melaka','Shaved ice, pandan cendol jelly, red beans, coconut milk, gula melaka, rose syrup','Calories: 280 | Sugar: 38g | Fat: 8g',6.90,4.9,TRUE),
(6,'Ais Kacang (ABC)','Colourful shaved ice dessert loaded with red beans, corn, attap seeds and rainbow jelly','Shaved ice, red beans, corn, attap chee, rainbow jelly, rose syrup, coconut milk, condensed milk','Calories: 320 | Sugar: 42g | Fat: 6g',7.90,4.8,TRUE),
(6,'Kuih Lapis','Colourful layered steamed kuih made with rice flour and coconut milk','Rice flour, coconut milk, sugar, pandan, food colouring','Calories: 180 | Sugar: 20g | Fat: 6g',5.90,4.7,TRUE),
(6,'Pengat Pisang','Warm banana dessert simmered in coconut milk and palm sugar','Banana, coconut milk, gula melaka, pandan leaves, sago','Calories: 240 | Sugar: 28g | Fat: 10g',6.50,4.7,TRUE),
-- Drinks (7)
(7,'Teh Tarik','Malaysia iconic frothy pulled milk tea — hot or iced','Black tea, condensed milk, evaporated milk','Calories: 130 | Sugar: 22g',3.50,4.9,TRUE),
(7,'Milo Dinosaur','Iced Milo topped with a generous heap of undissolved Milo powder','Milo, condensed milk, ice, Milo powder topping','Calories: 220 | Sugar: 30g',5.50,4.9,TRUE),
(7,'Air Bandung','Sweet rose-flavoured milk drink — a Malaysian party favourite','Rose syrup, evaporated milk, ice','Calories: 160 | Sugar: 24g',4.50,4.7,TRUE),
(7,'Kopi O Ais','Strong Malaysian black coffee over ice — robust and bold','Robusta coffee, sugar, ice','Calories: 40 | Sugar: 8g',3.50,4.8,TRUE);

-- --------------------------------------------------------
-- Add-ons (linked to food_items via FK)
-- --------------------------------------------------------
INSERT INTO addons (food_item_id, name, extra_price) VALUES
(1,'Extra Sambal',1.00),(1,'Extra Fried Egg',1.50),(1,'Extra Ikan Bilis',1.00),
(2,'Extra Fried Egg',1.00),(2,'Extra Prawn',3.00),(2,'Less Spicy',0.00),
(3,'Extra Fish Curry',2.00),(3,'Extra Egg',1.50),
(4,'Extra Chicken',5.00),(4,'Extra Soup',1.00),(4,'Dark Soy Sauce',0.00),
(5,'Extra Prawn',3.00),(5,'Extra Fish Cake',2.00),(5,'Extra Chilli',0.00),
(6,'Extra Prawn',3.00),(6,'Extra Egg',1.00),(6,'Extra Cockles',2.00),
(7,'Extra Egg',1.00),(7,'Extra Squid',3.00),(7,'Extra Lime',0.00),
(8,'Extra Fish',3.00),(8,'Extra Chilli',0.00),(8,'Extra Prawn Paste',0.50),
(9,'Extra Curry',1.00),(9,'Extra Dhal',0.50),(9,'Extra Sambal',0.50),
(10,'Extra Egg',1.50),(10,'Extra Curry',1.00),
(11,'Extra Kaya',1.00),(11,'Extra Butter',0.50),(11,'Half Boiled Egg',2.00),
(12,'Extra Coconut Chutney',0.50),(12,'Extra Sambar',1.00),
(13,'Extra Chicken Piece',8.00),(13,'Extra Rice',2.00),(13,'Extra Sauce',1.00),
(14,'Extra 5 Skewers',8.00),(14,'Extra Peanut Sauce',1.50),(14,'Extra Ketupat',1.00),
(15,'Extra Rice',2.00),(15,'Extra Rendang',7.00),
(16,'Extra Sambal',1.00),(16,'Extra Lime',0.50),(16,'Extra Rice',2.00),
(17,'Extra Cheese',3.00),(17,'Extra Pepperoni',4.00),(17,'Stuffed Crust',5.00),
(18,'Extra Beef Patty',6.00),(18,'Extra Cheese',2.00),(18,'Add Fried Egg',2.00),
(19,'Extra Prawn',5.00),(19,'Extra Chilli',0.00),(19,'Extra Parmesan',2.00),
(20,'Extra Gula Melaka',0.50),(20,'Extra Red Bean',1.00),(20,'Extra Coconut Milk',0.50),
(21,'Extra Red Bean',1.00),(21,'Extra Corn',0.50),(21,'Extra Coconut Milk',0.50),
(22,'Extra Piece',2.00),
(23,'Extra Banana',2.00),(23,'Extra Coconut Milk',1.00),
(24,'Less Sugar',0.00),(24,'Extra Thick',0.50),(24,'Iced',0.00),
(25,'Less Sugar',0.00),(25,'Extra Milo Powder',1.00),(25,'Extra Ice',0.00),
(26,'Less Sweet',0.00),(26,'Extra Ice',0.00),
(27,'Less Sugar',0.00),(27,'Extra Strong',0.50),(27,'Extra Ice',0.00);

-- --------------------------------------------------------
-- Admin account  (username: admin | password: admin123)
-- --------------------------------------------------------
INSERT INTO users (username, email, password_hash, phone, role) VALUES
('admin','admin@foodorder.com',
 '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
 '0123456789','ADMIN');
