package com.skillnova.controller;

import com.skillnova.model.Role;
import com.skillnova.model.User;
import com.skillnova.service.AuthService;
import com.skillnova.util.CookieUtil;
import com.skillnova.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Optional;

@WebServlet(name = "loginServlet", urlPatterns = "/login")
public class LoginServlet extends HttpServlet {

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

        String remember = CookieUtil.get(req, CookieUtil.REMEMBER_ME);
        req.setAttribute("rememberChecked", "1".equals(remember));
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
            System.out.println("[LOGIN] Attempt email=" + email + " from path=" + req.getRequestURI());
            Optional<User> userOptional = authService.authenticate(email.trim(), password);
            if (userOptional.isEmpty()) {
                req.setAttribute("error", "Invalid credentials or account not approved yet.");
                req.setAttribute("email", email);
                req.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(req, resp);
                return;
            }

            User user = userOptional.get();
            SessionUtil.createUserSession(req, user.getUserId(), user.getFullName(), user.getRole().name(), user.getAccountStatus());

            if ("on".equalsIgnoreCase(rememberMe)) {
                CookieUtil.add(req, resp, CookieUtil.REMEMBER_ME, "1", 7 * 24 * 60 * 60);
            } else {
                CookieUtil.delete(req, resp, CookieUtil.REMEMBER_ME);
            }

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
