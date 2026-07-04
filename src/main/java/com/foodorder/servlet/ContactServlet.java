package com.foodorder.servlet;

import com.foodorder.dao.ContactMessageDAO;
import com.foodorder.model.ContactMessage;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.regex.Pattern;

@WebServlet("/contact")
public class ContactServlet extends HttpServlet {

    private final ContactMessageDAO contactMessageDAO = new ContactMessageDAO();
    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w.+-]+@[\\w-]+\\.[a-zA-Z]{2,}$");

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String subject = req.getParameter("subject");
        String message = req.getParameter("message");

        boolean missing = isBlank(name) || isBlank(email) || isBlank(subject) || isBlank(message);
        if (missing || !EMAIL_PATTERN.matcher(email.trim()).matches()) {
            req.setAttribute("error", "Please fill in all fields with a valid email address.");
            req.getRequestDispatcher("contact.jsp").forward(req, resp);
            return;
        }

        ContactMessage msg = new ContactMessage();
        msg.setName(name.trim());
        msg.setEmail(email.trim());
        msg.setSubject(subject.trim());
        msg.setMessage(message.trim());
        contactMessageDAO.save(msg);

        resp.sendRedirect(req.getContextPath() + "/contact-thanks.jsp");
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
