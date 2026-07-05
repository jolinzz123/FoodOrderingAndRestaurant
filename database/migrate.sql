-- ============================================================
--  FoodOrder Migration Script
--  Run this file if you already have the old database set up.
--  Steps: open MySQL Workbench → open this file → Ctrl+Shift+Enter
-- ============================================================

USE food_order_db;

-- --------------------------------------------------------
-- Step 1: Add new columns to orders table
-- --------------------------------------------------------
ALTER TABLE orders
ADD COLUMN delivery_address VARCHAR(255) AFTER status,
ADD COLUMN payment_method VARCHAR(50) AFTER delivery_address;

-- --------------------------------------------------------
-- Step 1b: Fix typo in Black Pepper Beef image filename
-- --------------------------------------------------------
UPDATE food_items SET image_url = 'images/blackpepperbeef.png' WHERE id = 18;

-- --------------------------------------------------------
-- Step 1c: Fix category name typo
-- --------------------------------------------------------
UPDATE categories SET name = 'Main Dishes' WHERE name = 'MainDishes';

-- --------------------------------------------------------
-- Step 1d: Fix Mixed Vegetables image filename typo
-- --------------------------------------------------------
UPDATE food_items SET image_url = 'images/mixedvege.png' WHERE image_url = 'images/mixedvege.jpng';

-- --------------------------------------------------------
-- Step 1e: Add reviews table
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS reviews (
  id        INT AUTO_INCREMENT PRIMARY KEY,
  food_id   INT NOT NULL,
  order_id  INT NOT NULL,
  user_id   INT NOT NULL,
  rating    TINYINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment   TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_user_food_order (user_id, food_id, order_id),
  FOREIGN KEY (food_id)  REFERENCES food_items(id) ON DELETE CASCADE,
  FOREIGN KEY (order_id) REFERENCES orders(id)     ON DELETE CASCADE,
  FOREIGN KEY (user_id)  REFERENCES users(id)      ON DELETE CASCADE
);

-- --------------------------------------------------------
-- Step 1f: Add contact_messages table
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS contact_messages (
  id         INT AUTO_INCREMENT PRIMARY KEY,
  user_id    INT NOT NULL,
  name       VARCHAR(200) NOT NULL,
  email      VARCHAR(200) NOT NULL,
  subject    VARCHAR(255) NOT NULL,
  message    TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- --------------------------------------------------------
-- Step 1g: Link contact_messages to the submitting user
-- (only needed if you already ran Step 1f before this column existed)
-- --------------------------------------------------------
ALTER TABLE contact_messages ADD COLUMN user_id INT NOT NULL AFTER id;
ALTER TABLE contact_messages ADD FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- --------------------------------------------------------
-- Step 2: Clear all data (keeps table structure)
-- --------------------------------------------------------
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE order_item_addons;
TRUNCATE TABLE order_items;
TRUNCATE TABLE orders;
TRUNCATE TABLE addons;
TRUNCATE TABLE food_items;
TRUNCATE TABLE categories;

SET FOREIGN_KEY_CHECKS = 1;

-- --------------------------------------------------------
-- Step 3: Re-insert clean data
-- --------------------------------------------------------

INSERT INTO categories (name) VALUES
('Rice'),
('Noodles'),
('Bread & FlatBread'),
('Main Dishes'),
('Vegetables'),
('Western'),
('Desserts'),
('Drinks');

INSERT INTO food_items (category_id, name, description, ingredients, nutritional_info, price, rating, is_available, image_url) VALUES
-- Rice (1)
(1,'Nasi Lemak Special','Malaysia national dish — fragrant coconut rice served with sambal, fried anchovies, peanuts, cucumber and half-boiled egg','Coconut rice, sambal tumis, ikan bilis, peanuts, cucumber, egg','Calories: 490 | Protein: 14g | Carbs: 58g | Fat: 22g',8.90,4.9,TRUE,'images/nasilemak.png'),
(1,'Fried Rice','Village-style fried rice with anchovies, chilli and egg — a true Malaysian comfort food','Rice, ikan bilis, egg, chilli, soy sauce, belacan, vegetables','Calories: 520 | Protein: 16g | Carbs: 65g | Fat: 18g',9.50,4.8,TRUE,'images/friedrice.png'),
(1,'Nasi Dagang','Terengganu specialty — glutinous rice cooked in coconut milk served with tuna curry','Glutinous rice, coconut milk, ikan tongkol curry, hard-boiled egg, pickled cucumber','Calories: 580 | Protein: 22g | Carbs: 70g | Fat: 20g',12.90,4.7,TRUE,'images/nasidagang.png'),
(1,'Chicken Rice','Silky poached chicken over fragrant rice with ginger sauce and clear soup','Chicken, jasmine rice, ginger, garlic, sesame oil, soy sauce, chilli sauce','Calories: 540 | Protein: 30g | Carbs: 60g | Fat: 14g',11.90,4.8,TRUE,'images/chickenrice.png'),

-- Noodles (2)
(2,'Laksa Lemak','Rich and creamy coconut-based noodle soup with prawns and fish cake','Rice vermicelli, coconut milk, lemongrass, galangal, turmeric, prawns, fish cake, bean sprouts','Calories: 550 | Protein: 20g | Carbs: 52g | Fat: 26g',12.90,4.9,TRUE,'images/laksalemak.png'),
(2,'Char Kuey Teow','Wok-hei flat rice noodles stir-fried with prawns, egg, cockles and bean sprouts','Flat rice noodles, prawns, egg, cockles, bean sprouts, chilli, dark soy sauce','Calories: 480 | Protein: 18g | Carbs: 60g | Fat: 16g',11.90,4.8,TRUE,'images/charkueyteow.png'),
(2,'Mee Goreng Mamak','Spicy Indian-Muslim style fried yellow noodles with tofu, potato and tomato','Yellow noodles, tofu, potato, egg, tomato, bean sprouts, sambal, lime','Calories: 460 | Protein: 14g | Carbs: 62g | Fat: 14g',9.90,4.7,TRUE,'images/meegorengmamak.png'),
(2,'Asam Laksa','Tangy tamarind-based fish noodle soup topped with pineapple and mint — Penang classic','Rice noodles, mackerel, tamarind, lemongrass, pineapple, cucumber, mint, prawn paste','Calories: 380 | Protein: 18g | Carbs: 55g | Fat: 8g',11.90,4.8,TRUE,'images/asamlaksa.png'),

-- Bread & FlatBread (3)
(3,'Roti Canai','Flaky crispy flatbread served with dhal curry and sambal — Malaysian breakfast staple','Flour, butter, egg, salt, dhal curry, sambal','Calories: 320 | Protein: 8g | Carbs: 48g | Fat: 12g',3.50,4.9,TRUE,'images/roticanai.png'),
(3,'Egg Roti','Crispy flatbread stuffed with egg and onion, served with curry sauce','Flour, egg, onion, butter, curry sauce','Calories: 380 | Protein: 12g | Carbs: 46g | Fat: 16g',4.50,4.7,TRUE,'images/eggroti.png'),
(3,'Kaya Toast','Toasted bread generously spread with homemade pandan kaya and butter','White bread, kaya jam, butter, pandan','Calories: 280 | Protein: 6g | Carbs: 40g | Fat: 12g',4.90,4.8,TRUE,'images/kayatoast.png'),
(3,'Thosai','Crispy South Indian fermented rice crepe served with coconut chutney and sambar','Fermented rice batter, coconut chutney, sambar lentil curry','Calories: 180 | Protein: 6g | Carbs: 34g | Fat: 4g',4.50,4.6,TRUE,'images/thosai.png'),

-- Main Dishes (4)
(4,'Ayam Percik','Kelantan-style grilled chicken glazed with rich spiced coconut sauce','Whole chicken, coconut milk, lemongrass, galangal, turmeric, chilli, kaffir lime','Calories: 440 | Protein: 36g | Fat: 26g | Carbs: 12g',18.90,4.9,TRUE,'images/ayampercik.png'),
(4,'Chicken Satay','10 skewers of grilled chicken satay served with peanut sauce, ketupat and cucumber','Chicken, lemongrass, turmeric, coriander, peanut sauce, ketupat, cucumber, onion','Calories: 480 | Protein: 34g | Fat: 22g | Carbs: 28g',16.90,4.9,TRUE,'images/chickensatay.png'),
(4,'Beef Rendang','Slow-cooked dry beef curry with aromatic spices and toasted coconut — rich and intense','Beef, coconut milk, kerisik, lemongrass, galangal, chilli, kaffir lime leaves','Calories: 520 | Protein: 38g | Fat: 30g | Carbs: 10g',19.90,4.8,TRUE,'images/beefrendang.png'),
(4,'Grilled Fish','Whole grilled fish marinated in spicy sambal paste, wrapped in banana leaf','Stingray or tilapia, sambal, turmeric, lemongrass, banana leaf, lime','Calories: 360 | Protein: 32g | Fat: 16g | Carbs: 8g',22.90,4.8,TRUE,'images/grilledfish.png'),
(4,'Sweet & Sour Chicken','Crispy fried chicken tossed in tangy sweet and sour sauce with bell peppers and pineapple','Chicken, bell pepper, pineapple, tomato sauce, vinegar, sugar, cornstarch, onion','Calories: 420 | Protein: 28g | Fat: 14g | Carbs: 46g',14.90,4.6,TRUE,'images/sweetsourchicken.png'),
(4,'Black Pepper Beef','Tender beef slices stir-fried with onion and capsicum in a bold black pepper sauce','Beef, black pepper sauce, onion, green capsicum, butter, oyster sauce, dark soy sauce','Calories: 480 | Protein: 32g | Fat: 24g | Carbs: 20g',17.90,4.7,TRUE,'images/blackpepperbeef.png'),

-- Vegetables (5)
(5,'Kangkung Belacan','Water spinach stir-fried with fragrant shrimp paste and chilli — a Malaysian classic side','Kangkung, belacan, red chilli, garlic, oil','Calories: 120 | Protein: 4g | Fat: 8g | Carbs: 10g',7.90,4.7,TRUE,'images/kangkung.png'),
(5,'Stir-fried Mixed Vegetables','Colourful stir-fry of seasonal vegetables tossed in light oyster sauce','Carrot, broccoli, baby corn, snap peas, mushroom, oyster sauce, garlic','Calories: 140 | Protein: 5g | Fat: 7g | Carbs: 16g',8.90,4.6,TRUE,'images/mixedvege.png'),
(5,'Broccoli with Oyster Sauce','Blanched broccoli drizzled with savoury oyster sauce and crispy fried garlic','Broccoli, oyster sauce, garlic, sesame oil, cornstarch','Calories: 110 | Protein: 5g | Fat: 6g | Carbs: 12g',7.90,4.5,TRUE,'images/broccoli.png'),
(5,'Sambal Long Beans','Crunchy long beans wok-tossed with spicy sambal and dried shrimp','Long beans, sambal, dried shrimp, red onion, garlic','Calories: 130 | Protein: 4g | Fat: 8g | Carbs: 12g',7.90,4.6,TRUE,'images/longbeans.png'),
(5,'Stir-fried Cabbage','Tender cabbage stir-fried with garlic, fish sauce and a hint of chilli','Cabbage, garlic, fish sauce, chilli, oil','Calories: 100 | Protein: 3g | Fat: 6g | Carbs: 10g',6.90,4.5,TRUE,'images/cabbage.png'),
(5,'Tofu with Mixed Vegetables','Soft tofu stir-fried with a colourful mix of seasonal vegetables in light savoury sauce','Tofu, carrot, broccoli, baby corn, mushroom, oyster sauce, garlic, soy sauce','Calories: 150 | Protein: 9g | Fat: 8g | Carbs: 12g',8.90,4.6,TRUE,'images/tofu.png'),

-- Western (6)
(6,'Pepperoni Pizza','Classic tomato base loaded with pepperoni and mozzarella on a crispy thin crust','Tomato sauce, mozzarella, pepperoni, oregano, pizza dough','Calories: 300 per slice | Protein: 14g | Carbs: 30g | Fat: 12g',21.90,4.6,TRUE,'images/pepperonipizza.png'),
(6,'Classic Beef Burger','Juicy beef patty with lettuce, tomato, pickles and special sauce in a brioche bun','Beef patty, brioche bun, lettuce, tomato, pickles, cheddar, special sauce','Calories: 520 | Protein: 28g | Carbs: 42g | Fat: 22g',14.90,4.5,TRUE,'images/beefburger.png'),
(6,'Prawn Aglio Olio','Spaghetti tossed with garlic, chilli flakes and juicy fresh prawns in olive oil','Spaghetti, prawns, garlic, chilli flakes, olive oil, parsley, parmesan','Calories: 490 | Protein: 24g | Carbs: 58g | Fat: 14g',19.90,4.6,TRUE,'images/prawnaglioolio.png'),
(6,'Chicken Chop','Grilled chicken thigh served with black pepper sauce, coleslaw and golden fries','Chicken thigh, black pepper sauce, coleslaw, french fries, butter, garlic','Calories: 580 | Protein: 34g | Fat: 24g | Carbs: 44g',16.90,4.6,TRUE,'images/chickenchop.png'),
(6,'Fish & Chips','Golden battered fish fillet served with crispy fries, tartare sauce and lemon','Dory fillet, beer batter, french fries, tartare sauce, lemon, malt vinegar','Calories: 560 | Protein: 26g | Fat: 22g | Carbs: 52g',18.90,4.5,TRUE,'images/fishnchips.png'),

-- Desserts (7)
(7,'Cendol','Shaved ice dessert with pandan jelly, red beans, coconut milk and gula melaka','Shaved ice, pandan cendol jelly, red beans, coconut milk, gula melaka, rose syrup','Calories: 280 | Sugar: 38g | Fat: 8g',6.90,4.9,TRUE,'images/cendol.png'),
(7,'Ais Kacang (ABC)','Colourful shaved ice dessert loaded with red beans, corn, attap seeds and rainbow jelly','Shaved ice, red beans, corn, attap chee, rainbow jelly, rose syrup, coconut milk, condensed milk','Calories: 320 | Sugar: 42g | Fat: 6g',7.90,4.8,TRUE,'images/abc.png'),
(7,'Kuih Lapis','Colourful layered steamed kuih made with rice flour and coconut milk','Rice flour, coconut milk, sugar, pandan, food colouring','Calories: 180 | Sugar: 20g | Fat: 6g',5.90,4.7,TRUE,'images/layercake.png'),
(7,'Pengat Pisang','Warm banana dessert simmered in coconut milk and palm sugar','Banana, coconut milk, gula melaka, pandan leaves, sago','Calories: 240 | Sugar: 28g | Fat: 10g',6.50,4.7,TRUE,'images/pengatpisang.png'),

-- Drinks (8)
(8,'Teh Tarik','Malaysia iconic frothy pulled milk tea — smooth, sweet and aromatic','Black tea, condensed milk, evaporated milk','Calories: 130 | Sugar: 22g | Fat: 3g',3.50,4.9,TRUE,'images/tehtarik.png'),
(8,'Milo Dinosaur','Iced Milo topped with a generous heap of undissolved Milo powder','Milo, condensed milk, ice, Milo powder topping','Calories: 220 | Sugar: 30g | Fat: 5g',5.50,4.9,TRUE,'images/milodinosaur.png'),
(8,'Air Bandung','Sweet rose-flavoured milk drink — a Malaysian party favourite','Rose syrup, evaporated milk, ice','Calories: 160 | Sugar: 24g | Fat: 4g',4.50,4.7,TRUE,'images/airbandung.png'),
(8,'Kopi O Ais','Strong Malaysian black coffee over ice — robust and bold','Robusta coffee, sugar, ice','Calories: 40 | Sugar: 8g | Fat: 0g',3.50,4.8,TRUE,'images/icedblackcoffee.png'),
(8,'Lemon Tea','Refreshing iced tea with a bright squeeze of fresh lemon — light and zesty','Black tea, lemon juice, sugar syrup, ice','Calories: 80 | Sugar: 18g | Fat: 0g',4.50,4.7,TRUE,'images/lemontea.png'),
(8,'Iced Milo','Classic chilled Milo made with condensed milk over ice — a childhood favourite','Milo, condensed milk, ice, water','Calories: 180 | Sugar: 26g | Fat: 4g',4.50,4.8,TRUE,'images/icedmilo.png');

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
(17,'Extra Sauce',1.00),(17,'Extra Pineapple',1.00),(17,'Less Sweet',0.00),
(18,'Extra Beef',6.00),(18,'Extra Black Pepper Sauce',1.00),(18,'Less Spicy',0.00),
(19,'Extra Belacan',0.50),(19,'Extra Chilli',0.00),(19,'Less Spicy',0.00),
(20,'Extra Mushroom',1.50),(20,'Extra Oyster Sauce',0.50),(20,'Less Oil',0.00),
(21,'Extra Oyster Sauce',0.50),(21,'Extra Garlic',0.50),(21,'Less Oil',0.00),
(22,'Extra Sambal',1.00),(22,'Extra Dried Shrimp',1.00),(22,'Less Spicy',0.00),
(23,'Extra Chilli',0.00),(23,'Extra Garlic',0.50),(23,'Less Oil',0.00),
(24,'Extra Tofu',2.00),(24,'Extra Vegetables',1.50),(24,'Less Salt',0.00),
(25,'Extra Cheese',3.00),(25,'Extra Pepperoni',4.00),(25,'Stuffed Crust',5.00),
(26,'Extra Beef Patty',6.00),(26,'Extra Cheese',2.00),(26,'Add Fried Egg',2.00),
(27,'Extra Prawn',5.00),(27,'Extra Chilli',0.00),(27,'Extra Parmesan',2.00),
(28,'Extra Black Pepper Sauce',1.00),(28,'Extra Fries',3.00),(28,'Add Coleslaw',1.50),
(29,'Extra Tartare Sauce',0.50),(29,'Extra Fries',3.00),(29,'Extra Lemon',0.50),
(30,'Extra Gula Melaka',0.50),(30,'Extra Red Bean',1.00),(30,'Extra Coconut Milk',0.50),
(31,'Extra Red Bean',1.00),(31,'Extra Corn',0.50),(31,'Extra Coconut Milk',0.50),
(32,'Extra Piece',2.00),
(33,'Extra Banana',2.00),(33,'Extra Coconut Milk',1.00),
(34,'Less Sugar',0.00),(34,'Extra Thick',0.50),(34,'Iced',0.00),
(35,'Less Sugar',0.00),(35,'Extra Milo Powder',1.00),(35,'Extra Ice',0.00),
(36,'Less Sweet',0.00),(36,'Extra Ice',0.00),
(37,'Less Sugar',0.00),(37,'Extra Strong',0.50),(37,'Extra Ice',0.00),
(38,'Less Sugar',0.00),(38,'Extra Lemon',0.50),(38,'Extra Ice',0.00),
(39,'Less Sugar',0.00),(39,'Extra Milo Powder',1.00),(39,'Extra Ice',0.00);

-- --------------------------------------------------------
-- Admin account (username: admin | password: admin306)
-- --------------------------------------------------------
INSERT IGNORE INTO users (username, email, password_hash, phone, role) VALUES
('admin','admin@foodorder.com',
 '1621514f4abb2d0b68bb344ebc60e12233fcf7bff1a99c9b1e4ac257f949f698',
 '0123456789','ADMIN');

-- --------------------------------------------------------
-- Step 4: Split users into separate customers + admins tables
-- --------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(100) NOT NULL UNIQUE,
    email         VARCHAR(200) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone         VARCHAR(20),
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS admins (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(100) NOT NULL UNIQUE,
    email         VARCHAR(200) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone         VARCHAR(20),
    created_at    TIMESTAMP    DEFAULT CURRENT_TIMESTAMP
);

-- Copy existing accounts across, keeping their original IDs so orders/reviews/
-- contact_messages (which will reference customers only) still line up.
INSERT INTO customers (id, username, email, password_hash, phone, created_at)
SELECT id, username, email, password_hash, phone, created_at FROM users WHERE role = 'CUSTOMER';

INSERT INTO admins (id, username, email, password_hash, phone, created_at)
SELECT id, username, email, password_hash, phone, created_at FROM users WHERE role = 'ADMIN';

-- Repoint orders/reviews/contact_messages at customers instead of users.
-- Constraint names are looked up dynamically since they were auto-generated.
SET @fk := (SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'orders'
              AND COLUMN_NAME = 'user_id' AND REFERENCED_TABLE_NAME = 'users' LIMIT 1);
SET @sql := CONCAT('ALTER TABLE orders DROP FOREIGN KEY ', @fk);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
ALTER TABLE orders ADD FOREIGN KEY (user_id) REFERENCES customers(id);

SET @fk := (SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'reviews'
              AND COLUMN_NAME = 'user_id' AND REFERENCED_TABLE_NAME = 'users' LIMIT 1);
SET @sql := CONCAT('ALTER TABLE reviews DROP FOREIGN KEY ', @fk);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
ALTER TABLE reviews ADD FOREIGN KEY (user_id) REFERENCES customers(id) ON DELETE CASCADE;

SET @fk := (SELECT CONSTRAINT_NAME FROM information_schema.KEY_COLUMN_USAGE
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'contact_messages'
              AND COLUMN_NAME = 'user_id' AND REFERENCED_TABLE_NAME = 'users' LIMIT 1);
SET @sql := CONCAT('ALTER TABLE contact_messages DROP FOREIGN KEY ', @fk);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;
ALTER TABLE contact_messages ADD FOREIGN KEY (user_id) REFERENCES customers(id) ON DELETE CASCADE;

-- Now safe to drop the old combined table
DROP TABLE users;

-- --------------------------------------------------------
-- Step 5: Track which admin last updated an order's status
-- --------------------------------------------------------
ALTER TABLE orders ADD COLUMN handled_by_admin_id INT NULL;
ALTER TABLE orders ADD FOREIGN KEY (handled_by_admin_id) REFERENCES admins(id) ON DELETE SET NULL;
