package com.skillnova.controller;

import com.skillnova.model.Role;
import com.skillnova.model.User;
import com.skillnova.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet(name = "loginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        if ("1".equals(req.getParameter("timeout"))) {
            req.setAttribute("error", "Session timed out. Please sign in again.");
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String rememberMe = req.getParameter("rememberMe");

        if (isBlank(email) || isBlank(password)) {
            req.setAttribute("error", "Please enter both email and password.");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
            return;
        }

        try {
            Optional<User> userOptional = authService.authenticate(email.trim(), password);
            if (userOptional.isEmpty()) {
                req.setAttribute("error", "Invalid credentials or account not approved yet.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                return;
            }

            User user = userOptional.get();
            HttpSession session = req.getSession(true);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("fullName", user.getFullName());
            session.setAttribute("role", user.getRole().name());
            session.setAttribute("lastSeenAt", System.currentTimeMillis());

            Cookie rememberCookie = new Cookie("skillnova_remember", "1");
            rememberCookie.setPath(req.getContextPath().isEmpty() ? "/" : req.getContextPath());
            if ("on".equalsIgnoreCase(rememberMe)) {
                rememberCookie.setMaxAge(7 * 24 * 60 * 60);
            } else {
                rememberCookie.setMaxAge(0);
            }
            resp.addCookie(rememberCookie);

            if (user.getRole() == Role.ADMIN) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if (user.getRole() == Role.CLIENT) {
                resp.sendRedirect(req.getContextPath() + "/client/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/freelancer/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to process login.", e);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
