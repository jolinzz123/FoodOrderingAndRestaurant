# 🥗 HotServe — Food Ordering and Restaurant Management System

A Java EE (JSP + Servlet + JDBC) restaurant ordering and management system built for a university group assignment.

---

## 📌 Overview

This system allows customers to browse the restaurant's menu, view dish details (ingredients, price, ratings),
register/log in, add items to a cart, and place orders. Admins log in to a separate dashboard to manage
food items, categories, and view/update all customer orders.

## 🛠 Tech Stack

| Category | Technology |
|---|---|
| Front-end | HTML5, CSS3, Bootstrap 5, Bootstrap Icons |
| Back-end | JSP, Servlet (Jakarta EE 9+ / Tomcat 10.1), JavaBeans |
| Data access | JDBC + PreparedStatement |
| Database | MySQL 8+ |
| Server | Apache Tomcat 10.1 |
| Security | Servlet Filters (login restriction, admin-only restriction), SHA-256 password hashing |

> ⚠️ This project uses the **Jakarta EE namespace** (`jakarta.servlet.*`) because it targets Tomcat 10.1.
> If your Tomcat version is 9 or earlier, you'll need to change all `jakarta.servlet` imports back to
> `javax.servlet`, or the project won't compile.

> ℹ️ The project does **not** use the JSTL tag library (`<c:forEach>`, `<c:if>`, etc.). All page logic
> is implemented with plain Java scriptlets (`<% %>` / `<%= %>`) instead.

---

## 📁 Project Structure

```
FoodOrderingAndRestaurant/
├── database/
│   └── setup.sql                ← Database schema + seed data. Import this first.
├── src/main/java/com/foodorder/
│   ├── model/                   ← JavaBeans (User, FoodItem, Category, Addon, CartItem, Order, OrderItem)
│   ├── dao/                     ← Data access layer (UserDAO, FoodDAO, CategoryDAO, AddonDAO, OrderDAO)
│   ├── servlet/                 ← Business logic (register, login, menu, cart, checkout, admin CRUD)
│   ├── filter/                  ← AuthFilter, AdminFilter, AdminRedirectFilter
│   └── util/                    ← DBConnection, PasswordUtil, WebUtil, db.properties(.example)
└── src/main/webapp/
    ├── *.jsp                    ← Customer-facing pages (home, menu, cart, login, register, etc.)
    ├── admin/                   ← Admin dashboard pages
    ├── css/style.css, admin.css ← Site + admin panel styling
    ├── images/                  ← Food photos
    └── WEB-INF/
        ├── web.xml
        └── lib/                 ← MySQL Connector/J driver jar (already included)
```

---

## 🚀 Setup Instructions

### 1. Prerequisites
- **Eclipse IDE for Enterprise Java and Web Developers**
- **JDK 17 or later** (required for Tomcat 10.1)
- **Apache Tomcat 10.1**
- **MySQL 8+**

### 2. Import the Project
This repo is already a complete Eclipse Dynamic Web Project — no need to create a new project or copy files by hand.

1. In Eclipse: **File → Import → Git → Projects from Git → Clone URI**
2. Repo URL: `https://github.com/jolinzz123/FoodOrderingAndRestaurant.git`
3. Finish the wizard and let Eclipse import it as an existing Eclipse project

The MySQL driver jar is already checked into `WEB-INF/lib/`, so no manual download is needed.

### 3. Import the Database
1. Open MySQL Workbench or the MySQL command line
2. Run `database/setup.sql` — it creates the database, tables, and seed data automatically

### 4. Configure the Database Connection
`db.properties` is gitignored (each teammate uses their own local MySQL password), so it won't be in your clone yet:

1. Copy `src/main/java/com/foodorder/util/db.properties.example` → `db.properties` (same folder)
2. Edit it with your own MySQL password:
   ```properties
   db.url=jdbc:mysql://localhost:3306/food_order_db?useSSL=false&serverTimezone=UTC
   db.user=root
   db.password=your_mysql_password
   ```

### 5. Run the Project
Right-click the project → Run As → **Run on Server** → select Tomcat 10.1 → Finish

The app will open at:
```
http://localhost:8080/FoodOrderingAndRestaurant/
```

---

## 🔑 Test Accounts

| Role | Username | Password |
|---|---|---|
| Admin | `admin` | `admin123` |
| Customer | Create one via the Register page | — |

---

## ✅ Implemented Features

- [x] Homepage (featured restaurants, popular dishes)
- [x] Menu page (category filtering, ingredients/nutrition info, ratings, add-ons)
- [x] Food detail page (add to cart)
- [x] User registration (client + server-side validation, SHA-256 password hashing)
- [x] Login / Logout (session management)
- [x] Shopping cart (update quantity, remove items, clear cart)
- [x] Checkout (transactional order + order-item insert)
- [x] Order confirmation page
- [x] About Us / Contact Us / FAQ pages
- [x] Access control (login required to order, admin-only dashboard access)
- [x] Admin dashboard (stats overview, quick actions, recent orders)
- [x] Admin product management (card grid, search, category filter, edit/delete)
- [x] Admin category management (search, add/delete)
- [x] Admin order management (status stats, search, status updates)

---

## 👥 Team Members (fill in)

| Name | Responsibility |
|---|---|
| | Front-end pages & styling |
| | Back-end servlets & database |
| | Testing & documentation |

---

## 📄 License

This project was built for academic coursework purposes only and is not intended for commercial use.
