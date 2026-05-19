package com.skillnova.controller;

import com.skillnova.model.Role;
import com.skillnova.service.AuthService;
import com.skillnova.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "registerServlet", urlPatterns = "/register")
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        jakarta.servlet.http.HttpSession session = req.getSession(false);
        if (session != null && SessionUtil.getRole(session) != null) {
            String role = SessionUtil.getRole(session);
            if ("ADMIN".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
            } else if ("CLIENT".equals(role)) {
                resp.sendRedirect(req.getContextPath() + "/client/dashboard");
            } else {
                resp.sendRedirect(req.getContextPath() + "/freelancer/dashboard");
            }
            return;
        }

        String role = trim(req.getParameter("role"));
        if ("CLIENT".equalsIgnoreCase(role) || "FREELANCER".equalsIgnoreCase(role)) {
            req.setAttribute("role", role.toUpperCase());
        }
        req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String phone = trim(req.getParameter("phone"));
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String roleValue = req.getParameter("role");
        String action = req.getParameter("action");

        if ("updateFreelancerProfile".equalsIgnoreCase(action)) {
            updateFreelancerProfile(req, resp);
            return;
        }

        req.setAttribute("fullName", fullName);
        req.setAttribute("email", email);
        req.setAttribute("phone", phone);
        req.setAttribute("role", roleValue);

        if (isBlank(fullName) || isBlank(email) || isBlank(phone) || isBlank(password) || isBlank(confirmPassword) || isBlank(roleValue)) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (!fullName.matches("^[A-Za-z ]{3,120}$")) {
            req.setAttribute("error", "Full name should contain letters and spaces only.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            req.setAttribute("error", "Please enter a valid email address.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (!phone.matches("^[0-9]{7,15}$")) {
            req.setAttribute("error", "Phone number should contain 7 to 15 digits only.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 8) {
            req.setAttribute("error", "Password must be at least 8 characters.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Password and confirm password do not match.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        Role role;
        try {
            role = Role.valueOf(roleValue);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", "Invalid role selected.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        if (role == Role.ADMIN) {
            req.setAttribute("error", "Admin account cannot be created from registration page.");
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
            return;
        }

        try {
            long newUserId = authService.registerPendingUser(fullName, email, phone, password, role);
            if (role == Role.FREELANCER) {
                authService.updateFreelancerProfile(
                        newUserId,
                        req.getParameter("headline"),
                        req.getParameter("yearsExperience"),
                        req.getParameter("hourlyRate"),
                        req.getParameter("bio")
                );
            }

            SessionUtil.createUserSession(req, newUserId, fullName, role.name());
            if (role == Role.CLIENT) {
                req.getSession().setAttribute("flashSuccess", "Welcome! Your client account is pending approval.");
                resp.sendRedirect(req.getContextPath() + "/client/dashboard");
            } else {
                req.getSession().setAttribute("flashSuccess", "Welcome! Your freelancer profile is created and pending approval.");
                resp.sendRedirect(req.getContextPath() + "/freelancer/dashboard");
            }
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Unable to register user.", e);
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void updateFreelancerProfile(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        Long userId = com.skillnova.util.SessionUtil.getUserId(req.getSession(false));
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        try {
            boolean updated = authService.updateFreelancerProfile(
                    userId,
                    req.getParameter("headline"),
                    req.getParameter("yearsExperience"),
                    req.getParameter("hourlyRate"),
                    req.getParameter("bio")
            );
            req.getSession().setAttribute("flashSuccess", updated ? "Freelancer profile updated." : "Could not update profile.");
            resp.sendRedirect(req.getContextPath() + "/freelancer/dashboard");
        } catch (SQLException e) {
            throw new ServletException("Unable to update freelancer profile.", e);
        }
    }
}
