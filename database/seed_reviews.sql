-- =============================================================
-- Seed realistic reviews from 8 different Malaysian personas
-- Step 1: create seed users + orders
-- Step 2: insert varied reviews for all 39 food items
-- Step 3: recalculate cached ratings
-- Safe to re-run: INSERT IGNORE skips duplicates
-- =============================================================

USE food_order_db;

-- ---------------------------------------------------------------
-- Step 1: Insert 8 seed reviewer accounts (INSERT IGNORE = safe)
-- Password hash is bcrypt for "seed1234" — not real login accounts
-- ---------------------------------------------------------------
INSERT IGNORE INTO users (username, email, password_hash, phone, role) VALUES
('Amirah_Zahra',  'amirah.zahra@seedmail.my',  '$2a$10$seed.hash.placeholder.amirah000', '0123456781', 'user'),
('Hafiz_Razali',  'hafiz.razali@seedmail.my',   '$2a$10$seed.hash.placeholder.hafiz0000', '0123456782', 'user'),
('Priya_Nathan',  'priya.nathan@seedmail.my',   '$2a$10$seed.hash.placeholder.priya0000', '0123456783', 'user'),
('Wei_Liang',     'wei.liang@seedmail.my',      '$2a$10$seed.hash.placeholder.weiliang0', '0123456784', 'user'),
('Siti_Nurhaliza','siti.nurhaliza@seedmail.my', '$2a$10$seed.hash.placeholder.siti00000', '0123456785', 'user'),
('Raj_Kumar',     'raj.kumar@seedmail.my',      '$2a$10$seed.hash.placeholder.rajkumar0', '0123456786', 'user'),
('Mei_Ling',      'mei.ling@seedmail.my',       '$2a$10$seed.hash.placeholder.meiling00', '0123456787', 'user'),
('Izzatul_Husna', 'izzatul.husna@seedmail.my',  '$2a$10$seed.hash.placeholder.izzatul00', '0123456788', 'user');

-- ---------------------------------------------------------------
-- Step 2: Insert one past order per seed user (needed for FK)
-- ---------------------------------------------------------------
INSERT IGNORE INTO orders (user_id, total_price, status, delivery_address, payment_method, created_at)
SELECT id, 25.00, 'COMPLETED', 'Jalan Bukit Bintang, KL', 'cash',
       DATE_SUB(NOW(), INTERVAL FLOOR(RAND()*30+5) DAY)
FROM users WHERE username IN
('Amirah_Zahra','Hafiz_Razali','Priya_Nathan','Wei_Liang',
 'Siti_Nurhaliza','Raj_Kumar','Mei_Ling','Izzatul_Husna');

-- ---------------------------------------------------------------
-- Grab user IDs and their order IDs into variables
-- ---------------------------------------------------------------
SET @uA = (SELECT id FROM users WHERE username = 'Amirah_Zahra');
SET @uH = (SELECT id FROM users WHERE username = 'Hafiz_Razali');
SET @uP = (SELECT id FROM users WHERE username = 'Priya_Nathan');
SET @uW = (SELECT id FROM users WHERE username = 'Wei_Liang');
SET @uS = (SELECT id FROM users WHERE username = 'Siti_Nurhaliza');
SET @uR = (SELECT id FROM users WHERE username = 'Raj_Kumar');
SET @uM = (SELECT id FROM users WHERE username = 'Mei_Ling');
SET @uI = (SELECT id FROM users WHERE username = 'Izzatul_Husna');

SET @oA = (SELECT id FROM orders WHERE user_id = @uA ORDER BY id LIMIT 1);
SET @oH = (SELECT id FROM orders WHERE user_id = @uH ORDER BY id LIMIT 1);
SET @oP = (SELECT id FROM orders WHERE user_id = @uP ORDER BY id LIMIT 1);
SET @oW = (SELECT id FROM orders WHERE user_id = @uW ORDER BY id LIMIT 1);
SET @oS = (SELECT id FROM orders WHERE user_id = @uS ORDER BY id LIMIT 1);
SET @oR = (SELECT id FROM orders WHERE user_id = @uR ORDER BY id LIMIT 1);
SET @oM = (SELECT id FROM orders WHERE user_id = @uM ORDER BY id LIMIT 1);
SET @oI = (SELECT id FROM orders WHERE user_id = @uI ORDER BY id LIMIT 1);

-- ---------------------------------------------------------------
-- Step 3: Clear old seed reviews and insert fresh ones
-- (only removes reviews from our 8 seed accounts)
-- ---------------------------------------------------------------
DELETE FROM reviews WHERE user_id IN (@uA,@uH,@uP,@uW,@uS,@uR,@uM,@uI);

-- =============================================================
-- 4.9-tier items: id 1,5,9,13,14,30,34,35
-- All 8 reviewers — mostly 5★, one or two 4★
-- =============================================================
INSERT INTO reviews (food_id, order_id, user_id, rating, comment) VALUES
-- 1 Nasi Lemak Special
(1,@oA,@uA,5,'Sambal is perfectly spiced, coconut rice so fragrant. My absolute favourite!'),
(1,@oH,@uH,5,'Best nasi lemak I have tried here, the ikan bilis is wonderfully crispy.'),
(1,@oP,@uP,5,'Rich and authentic flavour, portion is generous too. Will definitely reorder!'),
(1,@oW,@uW,5,'The peanuts and cucumber balance the richness perfectly. Simply love it.'),
(1,@oS,@uS,5,'Such a classic done right. Every element is well prepared and fresh.'),
(1,@oR,@uR,4,'Very tasty nasi lemak! Sambal could be a touch spicier but still great.'),
(1,@oM,@uM,5,'Fragrant rice and bold sambal — cannot find better nasi lemak nearby.'),
(1,@oI,@uI,5,'My go-to dish every time I order. Never once disappointed. Superb!'),

-- 5 Laksa Lemak
(5,@oA,@uA,5,'Coconut broth is incredibly rich and creamy. Prawns are so fresh!'),
(5,@oH,@uH,5,'Best laksa I have had outside Penang, the spice balance is just right.'),
(5,@oP,@uP,5,'Full of flavour, fish cake adds great texture. Highly recommended!'),
(5,@oW,@uW,5,'Generous serving and the broth aroma is wonderful. Love every drop.'),
(5,@oS,@uS,5,'Perfect coconut laksa — creamy, spicy and satisfying all at once.'),
(5,@oR,@uR,4,'Lovely laksa! Would be perfect with slightly more sambal on the side.'),
(5,@oM,@uM,5,'The lemongrass and galangal flavour is so authentic. Absolutely delicious.'),
(5,@oI,@uI,5,'Rich and indulgent, this is what laksa should taste like. Amazing!'),

-- 9 Roti Canai
(9,@oA,@uA,5,'Crispy on the outside, perfectly fluffy inside. Dhal is outstanding.'),
(9,@oH,@uH,5,'Flaky and buttery with amazing dhal curry. Best breakfast choice here.'),
(9,@oP,@uP,5,'Authentic mamak-style roti canai, love that it stays crispy throughout.'),
(9,@oW,@uW,5,'Never too oily, perfectly flaky and the sambal adds a great kick.'),
(9,@oS,@uS,5,'Classic breakfast staple done perfectly. Cannot start the day without this.'),
(9,@oR,@uR,4,'Great roti canai! The dhal could be slightly thicker for my liking.'),
(9,@oM,@uM,5,'Consistently excellent every single time. My favourite breakfast option.'),
(9,@oI,@uI,5,'Crispy edges with a soft centre — textbook perfect roti canai!'),

-- 13 Ayam Percik
(13,@oA,@uA,5,'The coconut glaze caramelises beautifully. Chicken is incredibly tender.'),
(13,@oH,@uH,5,'Authentic Kelantan taste, the marinade penetrates deep into the meat.'),
(13,@oP,@uP,5,'Smoky, aromatic and juicy — this is one of the best dishes on the menu.'),
(13,@oW,@uW,5,'Percik sauce is addictive! I wanted to pour it on everything.'),
(13,@oS,@uS,5,'Perfectly grilled with a beautiful char. Flavour is incredible throughout.'),
(13,@oR,@uR,4,'Wonderful dish! A little more sauce on the side would make it perfect.'),
(13,@oM,@uM,5,'The spiced coconut glaze is unlike anything else. Truly outstanding!'),
(13,@oI,@uI,5,'My family always orders this. Rich, fragrant and perfectly cooked.'),

-- 14 Chicken Satay
(14,@oA,@uA,5,'Peanut sauce is the best I have tasted — rich, creamy and not too sweet.'),
(14,@oH,@uH,5,'Every skewer is perfectly charred and juicy inside. Amazing every time.'),
(14,@oP,@uP,5,'The marinade is so fragrant, meat slides right off the skewer. Love it!'),
(14,@oW,@uW,5,'Ketupat and cucumber are a perfect accompaniment. Complete and satisfying.'),
(14,@oS,@uS,5,'Best satay in the area hands down. Peanut sauce alone is worth ordering for!'),
(14,@oR,@uR,4,'Excellent satay! Maybe one or two extra skewers in the portion would be ideal.'),
(14,@oM,@uM,5,'Juicy, well-marinated and grilled to perfection. My personal favourite!'),
(14,@oI,@uI,5,'Cannot visit without ordering this. Consistently the best dish here.'),

-- 30 Cendol
(30,@oA,@uA,5,'Gula melaka is so deeply caramel and rich. The pandan jelly is perfect.'),
(30,@oH,@uH,5,'Most refreshing dessert I have had. Coconut milk is so creamy and fresh.'),
(30,@oP,@uP,5,'Authentic Malaysian cendol — sweet, cold and utterly satisfying. Love it!'),
(30,@oW,@uW,5,'Red beans are soft and perfectly sweetened. The whole combination is superb.'),
(30,@oS,@uS,5,'Perfect end to any meal. The gula melaka sets this apart from other versions.'),
(30,@oR,@uR,4,'Delicious cendol! Slightly more gula melaka drizzled on top would be heaven.'),
(30,@oM,@uM,5,'Cold, sweet and beautifully fragrant. Best dessert on the menu by far!'),
(30,@oI,@uI,5,'Always save space for this. Traditional taste that feels like home.'),

-- 34 Teh Tarik
(34,@oA,@uA,5,'Perfectly pulled with a beautiful froth on top. Smooth and aromatic.'),
(34,@oH,@uH,5,'The strongest and most satisfying teh tarik I have had here. A must order!'),
(34,@oP,@uP,5,'Just the right sweetness and the milk tea ratio is spot on. Excellent!'),
(34,@oW,@uW,5,'Classic Malaysian drink done beautifully. Warm, comforting and fragrant.'),
(34,@oS,@uS,5,'Cannot leave without a teh tarik. The froth is thick and perfectly smooth.'),
(34,@oR,@uR,4,'Great teh tarik! Just a little less sweet would suit my taste perfectly.'),
(34,@oM,@uM,5,'The pulled technique gives it such a smooth texture. Simply the best!'),
(34,@oI,@uI,5,'My default drink every visit. Aromatic, smooth and never disappoints.'),

-- 35 Milo Dinosaur
(35,@oA,@uA,5,'The mountain of undissolved Milo powder is genius! Every sip is incredible.'),
(35,@oH,@uH,5,'Childhood memories in a cup. Chocolatey, cold and so satisfying.'),
(35,@oP,@uP,5,'That Milo powder on top takes it to another level. Absolutely love it!'),
(35,@oW,@uW,5,'Best Milo drink anywhere. The thick powder topping makes every sip exciting.'),
(35,@oS,@uS,5,'Cannot resist ordering this every time. So rich and chocolatey perfect.'),
(35,@oR,@uR,4,'Really delicious! Slightly less condensed milk would suit my taste better.'),
(35,@oM,@uM,5,'Every Malaysian must have grown up with this flavour. Hits perfectly every time.'),
(35,@oI,@uI,5,'Always my first order when I arrive. The powder topping is everything!');

-- =============================================================
-- 4.8-tier items: id 2,4,6,8,11,15,16,31,37,39
-- 6 reviewers per item — 5×5★ + 1×4★
-- =============================================================
INSERT INTO reviews (food_id, order_id, user_id, rating, comment) VALUES
-- 2 Fried Rice
(2,@oA,@uA,5,'Village-style anchovies and chilli give it such a bold flavour. Love it!'),
(2,@oH,@uH,5,'Simple comfort food done perfectly. Egg is cooked exactly how I like it.'),
(2,@oP,@uP,5,'Best fried rice I have had here. The belacan kick is subtle but wonderful.'),
(2,@oW,@uW,5,'Wok fragrance is amazing, every grain of rice is perfectly seasoned.'),
(2,@oS,@uS,5,'Homestyle taste that feels comforting and familiar. Always a great choice.'),
(2,@oR,@uR,4,'Very tasty! A bit more chilli would make this absolutely perfect for me.'),
-- 4 Chicken Rice
(4,@oA,@uA,5,'Silky poached chicken with the most fragrant ginger sauce. Outstanding!'),
(4,@oH,@uH,5,'Rice is perfectly fragrant and fluffy. Ginger chilli sauce is incredible.'),
(4,@oP,@uP,5,'The broth is so clear and light yet full of depth. Amazing chicken rice!'),
(4,@oW,@uW,5,'Best chicken rice around. Skin is perfectly smooth and chicken very tender.'),
(4,@oS,@uS,5,'Consistently good every visit. The sesame oil in the rice is a nice touch.'),
(4,@oR,@uR,4,'Delicious! Would love a slightly larger bowl of the clear chicken soup.'),
-- 6 Char Kuey Teow
(6,@oA,@uA,5,'Wok hei is incredibly fragrant, cockles are so plump and fresh. Love it!'),
(6,@oH,@uH,5,'Authentic Penang char kuey teow taste. Dark soy balance is spot on.'),
(6,@oP,@uP,5,'Smoky, slightly charred and full of umami. One of the best noodles here.'),
(6,@oW,@uW,5,'Prawns are beautifully fresh and the flat noodles have great bite to them.'),
(6,@oS,@uS,5,'Cannot find better CKT outside of Penang. This comes incredibly close!'),
(6,@oR,@uR,4,'Very tasty! A touch more dark soy sauce would bring it to absolute perfection.'),
-- 8 Asam Laksa
(8,@oA,@uA,5,'Tangy tamarind broth with fresh mint and pineapple — so uniquely refreshing!'),
(8,@oH,@uH,5,'Genuine Penang asam laksa taste. The mackerel flakes are generous and fresh.'),
(8,@oP,@uP,5,'Complex and bold flavours that keep you coming back for more. Superb!'),
(8,@oW,@uW,5,'Pineapple and cucumber topping adds such a brilliant freshness to the dish.'),
(8,@oS,@uS,5,'One of the most unique dishes here. Cannot get this flavour profile elsewhere.'),
(8,@oR,@uR,4,'Lovely asam laksa! A slightly richer prawn paste base would elevate it more.'),
-- 11 Kaya Toast
(11,@oA,@uA,5,'Pandan kaya is so fragrant and buttery. Toast is perfectly golden and crispy.'),
(11,@oH,@uH,5,'Classic Singaporean-Malaysian breakfast done right. Generous kaya spread!'),
(11,@oP,@uP,5,'Crispy toast with rich kaya — simple perfection for a morning treat.'),
(11,@oW,@uW,5,'The butter and kaya combination is irresistible. Always order this to start.'),
(11,@oS,@uS,5,'Freshly toasted and spread generously. The kaya is clearly homemade quality.'),
(11,@oR,@uR,4,'Really good kaya toast! Just a touch more kaya spread would be ideal.'),
-- 15 Beef Rendang
(15,@oA,@uA,5,'Slow-cooked to absolute perfection. The kerisik adds such wonderful texture.'),
(15,@oH,@uH,5,'Most flavourful rendang I have tried. Deep, complex spices throughout.'),
(15,@oP,@uP,5,'Beef is melt-in-your-mouth tender. The dry curry coating is incredibly rich.'),
(15,@oW,@uW,5,'Authentic recipe with real depth of flavour. This is the real deal rendang!'),
(15,@oS,@uS,5,'One of the best dishes on the entire menu. Never skip this when visiting.'),
(15,@oR,@uR,4,'Excellent rendang! I would love slightly more gravy to pour over my rice.'),
-- 16 Grilled Fish
(16,@oA,@uA,5,'Sambal paste is so fragrant and the banana leaf gives amazing smoky aroma.'),
(16,@oH,@uH,5,'Fish is perfectly fresh and the turmeric marinade is beautifully balanced.'),
(16,@oP,@uP,5,'One of the most unique dishes here. Smoky, spicy and wonderfully aromatic.'),
(16,@oW,@uW,5,'The lemongrass in the sambal makes such a difference. Incredibly flavourful!'),
(16,@oS,@uS,5,'Fresh whole fish, well-marinated and grilled with beautiful char marks.'),
(16,@oR,@uR,4,'Really lovely dish! An extra lime wedge or two would complete it perfectly.'),
-- 31 Ais Kacang ABC
(31,@oA,@uA,5,'Rainbow jelly and attap chee make this such a fun and colourful dessert!'),
(31,@oH,@uH,5,'Most refreshing dessert on a hot day. Rose syrup is perfectly measured.'),
(31,@oP,@uP,5,'Generous portion with so many toppings. Coconut milk drizzle is delicious!'),
(31,@oW,@uW,5,'Red beans are soft and sweet, shaved ice is fine and fluffy. Love it!'),
(31,@oS,@uS,5,'Perfect dessert to share. Always impresses with the colourful presentation.'),
(31,@oR,@uR,4,'Very refreshing! A few more attap chee seeds would make it even better.'),
-- 37 Kopi O Ais
(37,@oA,@uA,5,'Strong robusta coffee over ice — bold, aromatic and perfectly balanced.'),
(37,@oH,@uH,5,'Best black coffee here. The sugar level is just right, not overpowering.'),
(37,@oP,@uP,5,'Authentic Malaysian kopi taste. Strong enough to wake you up immediately!'),
(37,@oW,@uW,5,'Love the intensity of the Robusta beans. Perfect afternoon pick-me-up.'),
(37,@oS,@uS,5,'Simple yet so satisfying. This is exactly how Malaysian black coffee should be.'),
(37,@oR,@uR,4,'Good strong coffee! Slightly stronger roast would make this absolutely perfect.'),
-- 39 Iced Milo
(39,@oA,@uA,5,'Perfectly blended with condensed milk — creamy, chocolatey and refreshing!'),
(39,@oH,@uH,5,'Classic childhood drink that still hits perfectly every single time.'),
(39,@oP,@uP,5,'Smooth and sweet with the right Milo to milk ratio. So satisfying!'),
(39,@oW,@uW,5,'Brings back such great memories. The condensed milk makes it so creamy.'),
(39,@oS,@uS,5,'My comfort drink. Always consistent and exactly how I like it.'),
(39,@oR,@uR,4,'Really good! Slightly less sweet would suit my preference perfectly.');

-- =============================================================
-- 4.7-tier items: id 3,7,10,18,19,32,33,36,38
-- 5 reviewers — 4×5★ + 1×4★
-- =============================================================
INSERT INTO reviews (food_id, order_id, user_id, rating, comment) VALUES
-- 3 Nasi Dagang
(3,@oA,@uA,5,'Tuna curry is perfectly spiced and pairs beautifully with the glutinous rice.'),
(3,@oH,@uH,5,'Authentic Terengganu taste — rich coconut rice and bold fish curry. Superb!'),
(3,@oP,@uP,5,'Pickled cucumber adds wonderful freshness. Rich and very filling meal.'),
(3,@oW,@uW,5,'The hard-boiled egg completes this beautifully. Great traditional dish.'),
(3,@oS,@uS,4,'Tasty and hearty. The tuna curry could be a tiny bit spicier for my taste.'),
-- 7 Mee Goreng Mamak
(7,@oA,@uA,5,'Spicy and bold with that signature mamak wok char. The tofu is a great touch.'),
(7,@oH,@uH,5,'Authentic Indian-Muslim flavour profile, love the lime squeeze finish.'),
(7,@oP,@uP,5,'Potato and tofu make it really unique and filling. Excellent dish!'),
(7,@oW,@uW,5,'Bean sprouts add great crunch. Sambal level is perfectly spicy.'),
(7,@oS,@uS,4,'Good flavour! A little more sambal in the base would make this outstanding.'),
-- 10 Egg Roti
(10,@oA,@uA,5,'Egg is perfectly cooked inside the flaky roti. Onion adds lovely sweetness.'),
(10,@oH,@uH,5,'Crispy outside with a soft egg filling — great breakfast or snack option.'),
(10,@oP,@uP,5,'Curry sauce pairs so well with the savoury egg roti. Will reorder!'),
(10,@oW,@uW,5,'Generous egg filling and beautifully golden crust. Love the flavour!'),
(10,@oS,@uS,4,'Tasty! Slightly crispier edges would make this absolutely perfect.'),
-- 18 Black Pepper Beef
(18,@oA,@uA,5,'Bold black pepper sauce with tender beef — exactly what this dish should be.'),
(18,@oH,@uH,5,'The capsicum and onion add great freshness to the rich peppery sauce.'),
(18,@oP,@uP,5,'Beef is incredibly tender and sauce has wonderful depth and heat.'),
(18,@oW,@uW,5,'Oyster sauce and dark soy balance is perfect. A really satisfying dish.'),
(18,@oS,@uS,4,'Good dish! Slightly more beef in the portion would make it even better.'),
-- 19 Kangkung Belacan
(19,@oA,@uA,5,'Fragrant belacan with a good chilli kick. Perfectly wok-fried kangkung!'),
(19,@oH,@uH,5,'The shrimp paste flavour is bold and aromatic without being overpowering.'),
(19,@oP,@uP,5,'Stalks are crunchy and leaves tender — cooked to the perfect texture.'),
(19,@oW,@uW,5,'Best kangkung belacan side dish here. Goes perfectly with steamed rice.'),
(19,@oS,@uS,4,'Nice flavour! Slightly more garlic would enhance the belacan aroma further.'),
-- 32 Kuih Lapis
(32,@oA,@uA,5,'Each layer is perfectly set with beautiful colour. Coconut milk so fragrant!'),
(32,@oH,@uH,5,'Soft and chewy texture with just the right level of sweetness. Excellent!'),
(32,@oP,@uP,5,'Traditional kuih that brings back childhood memories. Perfectly made here.'),
(32,@oW,@uW,5,'Love peeling each layer — it is part of the joy! Great pandan fragrance.'),
(32,@oS,@uS,4,'Good kuih! Slightly more pandan colour and fragrance would be wonderful.'),
-- 33 Pengat Pisang
(33,@oA,@uA,5,'Warm and comforting. Gula melaka gives such a deep caramel sweetness.'),
(33,@oH,@uH,5,'Bananas are perfectly ripe and soft. Pandan aroma is beautiful and subtle.'),
(33,@oP,@uP,5,'Coconut milk broth is rich and fragrant. A truly comforting dessert!'),
(33,@oW,@uW,5,'Sago pearls add nice texture. Sweet, warm and perfect after a meal.'),
(33,@oS,@uS,4,'Lovely dessert! A touch more gula melaka sweetness would be perfect.'),
-- 36 Air Bandung
(36,@oA,@uA,5,'Rose syrup with creamy evaporated milk — sweet, unique and so refreshing!'),
(36,@oH,@uH,5,'Pretty pink drink that tastes as good as it looks. Light and enjoyable.'),
(36,@oP,@uP,5,'Perfect sweetness level and the rose flavour is not artificial at all.'),
(36,@oW,@uW,5,'Fun and refreshing Malaysian classic. Always a great choice on hot days.'),
(36,@oS,@uS,4,'Nice drink! Slightly less sweet would suit my preference a bit better.'),
-- 38 Lemon Tea
(38,@oA,@uA,5,'Fresh lemon with a light tea base — clean, zesty and very refreshing!'),
(38,@oH,@uH,5,'Great balance between tea and citrus. Not too sweet and very thirst-quenching.'),
(38,@oP,@uP,5,'Love the brightness the fresh lemon adds. Perfect drink with any meal.'),
(38,@oW,@uW,5,'Light and clean on the palate. The sugar syrup level is spot on.'),
(38,@oS,@uS,4,'Nice drink! A little more lemon juice would give it extra zing.');

-- =============================================================
-- 4.6-tier items: id 12,17,20,22,24,25,27,28
-- 5 reviewers — 3×5★ + 2×4★
-- =============================================================
INSERT INTO reviews (food_id, order_id, user_id, rating, comment) VALUES
-- 12 Thosai
(12,@oA,@uA,5,'Light and crispy fermented crepe — coconut chutney pairing is wonderful.'),
(12,@oH,@uH,5,'Authentic South Indian taste. Sambar is well-spiced and flavourful.'),
(12,@oP,@uP,5,'Great healthy breakfast option. Perfectly fermented and beautifully crispy.'),
(12,@oW,@uW,4,'Good thosai! Sambar could be slightly thicker to complement it better.'),
(12,@oS,@uS,4,'Nice and light. The coconut chutney is fresh but I wanted a bit more of it.'),
-- 17 Sweet & Sour Chicken
(17,@oA,@uA,5,'Crispy chicken stays crunchy even in the tangy sauce. Brilliant execution!'),
(17,@oH,@uH,5,'Pineapple chunks add wonderful sweetness and the bell peppers add crunch.'),
(17,@oP,@uP,5,'Great balance of sweet and sour without being overwhelming. Very enjoyable!'),
(17,@oW,@uW,4,'Tasty dish! The sauce could be a touch more tangy for my preference.'),
(17,@oS,@uS,4,'Nice dish, chicken stays nicely crispy. Good with a bowl of steamed rice.'),
-- 20 Stir-fried Mixed Vegetables
(20,@oA,@uA,5,'So fresh and crunchy! Light oyster sauce coating is perfectly balanced.'),
(20,@oH,@uH,5,'Love the variety of vegetables — broccoli, baby corn and mushrooms are all great.'),
(20,@oP,@uP,5,'Healthy and delicious side dish. Vegetables are not overcooked at all.'),
(20,@oW,@uW,4,'Good vegetable dish! Could use slightly more seasoning and garlic flavour.'),
(20,@oS,@uS,4,'Nice healthy option. Mushrooms add great flavour to the overall dish.'),
-- 22 Sambal Long Beans
(22,@oA,@uA,5,'Crunchy long beans with a great sambal kick and umami from dried shrimp.'),
(22,@oH,@uH,5,'Spice level is exactly right and beans retain their satisfying crunch.'),
(22,@oP,@uP,5,'One of my favourite vegetable sides. Bold and flavourful with every bite.'),
(22,@oW,@uW,4,'Tasty dish! A little more sambal heat would make this even more addictive.'),
(22,@oS,@uS,4,'Good flavour combination. Dried shrimp gives a great savoury depth.'),
-- 24 Tofu Mixed Vegetables
(24,@oA,@uA,5,'Soft tofu contrasts beautifully with the crunchy vegetables. Great texture!'),
(24,@oH,@uH,5,'Light and healthy without sacrificing flavour. Mushrooms add lovely depth.'),
(24,@oP,@uP,5,'Love the variety of vegetables and how well-seasoned the tofu is.'),
(24,@oW,@uW,4,'Good healthy dish! Tofu could be slightly firmer but the flavour is good.'),
(24,@oS,@uS,4,'Nice option for a lighter meal. Oyster sauce seasoning is well-balanced.'),
-- 25 Pepperoni Pizza
(25,@oA,@uA,5,'Thin crispy crust loaded with pepperoni and perfectly melted mozzarella!'),
(25,@oH,@uH,5,'Great pizza option! Tomato base has a lovely herb flavour underneath.'),
(25,@oP,@uP,5,'Good quality ingredients and the crust is nicely crispy throughout.'),
(25,@oW,@uW,4,'Tasty pizza! More generous pepperoni coverage would make it excellent.'),
(25,@oS,@uS,4,'Nice pizza for a change of cuisine. Could use a bit more cheese on top.'),
-- 27 Prawn Aglio Olio
(27,@oA,@uA,5,'Garlic-infused olive oil with juicy fresh prawns — simple and absolutely perfect.'),
(27,@oH,@uH,5,'Chilli flakes give a wonderful gentle heat throughout. Parmesan finish is great!'),
(27,@oP,@uP,5,'Beautifully simple pasta with bold garlic flavour and fresh quality prawns.'),
(27,@oW,@uW,4,'Good aglio olio! Just a bit more chilli kick would take it to the next level.'),
(27,@oS,@uS,4,'Nice pasta dish. Prawns are fresh and the garlic flavour is well balanced.'),
-- 28 Chicken Chop
(28,@oA,@uA,5,'Grilled chicken thigh is so juicy and the black pepper sauce is bold and rich.'),
(28,@oH,@uH,5,'Coleslaw is fresh and creamy. Fries are perfectly golden and well-seasoned.'),
(28,@oP,@uP,5,'Great Western dish! Chicken is tender with a lovely grilled char on the outside.'),
(28,@oW,@uW,4,'Good meal! The black pepper sauce could be a little thicker in consistency.'),
(28,@oS,@uS,4,'Decent chicken chop. Fries were crispy and the portion size is satisfying.');

-- =============================================================
-- 4.5-tier items: id 21,23,26,29
-- 4 reviewers — 2×5★ + 1×4★ + 1×3★
-- =============================================================
INSERT INTO reviews (food_id, order_id, user_id, rating, comment) VALUES
-- 21 Broccoli with Oyster Sauce
(21,@oA,@uA,5,'Perfectly blanched with a rich oyster sauce glaze and crispy fried garlic.'),
(21,@oH,@uH,5,'Fresh, crunchy broccoli done simply and well. Sesame oil adds great aroma.'),
(21,@oP,@uP,4,'Good side dish. Broccoli was slightly softer than I prefer but still tasty.'),
(21,@oW,@uW,3,'Decent enough but fairly basic. More seasoning would help this dish a lot.'),
-- 23 Stir-fried Cabbage
(23,@oA,@uA,5,'Simple and tasty — garlic and fish sauce combination works really well here.'),
(23,@oH,@uH,5,'Light and refreshing vegetable option. Chilli gives just the right gentle heat.'),
(23,@oP,@uP,4,'Nice simple dish. Could use more garlic and perhaps a stronger seasoning.'),
(23,@oW,@uW,3,'Okay cabbage stir-fry but it felt a bit plain compared to the other dishes.'),
-- 26 Classic Beef Burger
(26,@oA,@uA,5,'Juicy beef patty in a soft brioche bun with great special sauce. Really good!'),
(26,@oH,@uH,5,'Good quality burger! Pickles and lettuce add a nice fresh crunch inside.'),
(26,@oP,@uP,4,'Nice burger overall. The patty could be a touch thicker for more satisfaction.'),
(26,@oW,@uW,3,'Okay but I expected more for the price. Patty was a bit thin for a beef burger.'),
-- 29 Fish & Chips
(29,@oA,@uA,5,'Golden crispy battered dory with perfectly seasoned fries. Tartare is fresh!'),
(29,@oH,@uH,5,'Great execution of a Western classic. Fish is moist inside the crunchy batter.'),
(29,@oP,@uP,4,'Good fish and chips! Batter was slightly thick but the fish inside was fresh.'),
(29,@oW,@uW,3,'Decent but the batter was a bit heavy for my liking. Fries were good though.');

-- =============================================================
-- Recalculate all cached ratings from real review data
-- =============================================================
UPDATE food_items fi
JOIN (
    SELECT food_id, AVG(rating) AS avg_r
    FROM reviews
    GROUP BY food_id
) agg ON fi.id = agg.food_id
SET fi.rating = agg.avg_r;

-- Verify results
SELECT fi.id, fi.name,
       ROUND(fi.rating, 2)      AS cached_rating,
       COUNT(r.id)              AS review_count,
       ROUND(AVG(r.rating), 2) AS real_avg
FROM food_items fi
LEFT JOIN reviews r ON r.food_id = fi.id
GROUP BY fi.id, fi.name, fi.rating
ORDER BY fi.rating DESC, fi.id;
