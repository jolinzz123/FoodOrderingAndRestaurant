# 🥗 Food Ordering and Restaurant Management System

A Java EE (JSP + Servlet + JDBC) restaurant ordering and management system built for a university group assignment.

---

## 📌 Overview

This system allows customers to browse the restaurant's menu, view dish details (ingredients, price, ratings),
register/log in, add items to a cart, and place orders. Admins can log in to a separate dashboard to manage
food items, categories, and view all customer orders.

## 🛠 Tech Stack

| Category | Technology |
|---|---|
| Front-end | HTML5, CSS3, Bootstrap 5, JavaScript |
| Back-end | JSP, Servlet (Jakarta EE 9+ / Tomcat 10.1), JavaBeans |
| Data access | JDBC + PreparedStatement |
| Database | MySQL 8+ |
| Server | Apache Tomcat 10.1 |
| Security | Servlet Filters (login restriction, admin-only restriction), SHA-256 password hashing |

> ⚠️ This project uses the **Jakarta EE namespace** (`jakarta.servlet.*`) because it targets Tomcat 10.1.
> If your Tomcat version is 9 or earlier, you'll need to change all `jakarta.servlet` imports back to
> `javax.servlet`, or the project won't compile.

> ℹ️ The project does **not** use the JSTL tag library (`<c:forEach>`, `<c:if>`, etc.). All page logic
> is implemented with plain Java scriptlets (`<% %>` / `<%= %>`) instead, to avoid needing an extra JSTL
> dependency jar.

---

## 📁 Project Structure

```
FoodOrderApp/
├── database/
│   └── schema.sql              ← Database schema + seed data. Import this first.
├── src/
│   └── com/foodorder/
│       ├── model/              ← JavaBeans (User, FoodItem, Category, CartItem, Order, OrderItem)
│       ├── dao/                ← Data access layer (UserDAO, FoodDAO, CategoryDAO, OrderDAO)
│       ├── servlet/            ← Business logic (register, login, menu, cart, checkout, admin CRUD)
│       ├── filter/              ← AuthFilter (ordering requires login), AdminFilter (admin-only access)
│       └── util/               ← DBConnection (JDBC connection), PasswordUtil (password hashing)
└── WebContent/
    ├── *.jsp                   ← Customer-facing pages (home, menu, cart, login, register, etc.)
    ├── admin/                  ← Admin dashboard pages
    ├── css/style.css           ← White & green theme styling
    ├── js/validate.js          ← Client-side form validation
    └── WEB-INF/
        ├── web.xml
        └── lib/                ← Place the MySQL driver jar here (mysql-connector-j-x.x.x.jar)
```

---

## 🚀 Setup Instructions

### 1. Prerequisites
- **Eclipse IDE for Enterprise Java and Web Developers**
- **JDK 17 or later** (required for Tomcat 10.1)
- **Apache Tomcat 10.1**
- **MySQL 8+**

### 2. Create the Eclipse Project
1. File → New → **Dynamic Web Project**
2. Set the Target Runtime to Tomcat 10.1
3. Set Dynamic Web Module version to **5.0** (matches Jakarta EE 9)
4. Copy this project's `src/com/foodorder` into `src/main/java/com/foodorder`
5. Copy everything under this project's `WebContent` into `src/main/webapp`

### 3. Download and Place the MySQL Driver
1. Download `mysql-connector-j` from the [MySQL website](https://dev.mysql.com/downloads/connector/j/)
2. Place the jar file in `WEB-INF/lib/`

### 4. Import the Database
1. Open MySQL Workbench or the MySQL command line
2. Run `database/schema.sql` — it creates the database, tables, and seed data automatically

### 5. Configure the Database Connection
Open `src/com/foodorder/util/DBConnection.java` and update it with your own credentials:
```java
private static final String DB_URL  = "jdbc:mysql://localhost:3306/food_order_db?useSSL=false&serverTimezone=UTC";
private static final String DB_USER = "root";
private static final String DB_PASSWORD = "your_mysql_password";
```

### 6. Run the Project
Right-click the project → Run As → **Run on Server** → select Tomcat 10.1 → Finish

The app will open at:
```
http://localhost:8080/your-project-name/
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
- [ ] Admin dashboard pages (Dashboard / Manage Food / Manage Categories / Manage Orders JSPs — in progress)

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
