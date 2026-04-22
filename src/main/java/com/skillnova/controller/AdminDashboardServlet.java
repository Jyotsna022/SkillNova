package com.skillnova.controller;

import com.skillnova.model.User;
import com.skillnova.service.AdminService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "adminDashboardServlet", urlPatterns = "/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private final AdminService adminService = new AdminService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        loadDashboard(req);
        req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String userIdRaw = req.getParameter("userId");

        if (action == null || userIdRaw == null) {
            req.setAttribute("error", "Invalid request for user approval action.");
            doGet(req, resp);
            return;
        }

        try {
            long userId = Long.parseLong(userIdRaw);
            boolean updated = false;
            if ("approve".equalsIgnoreCase(action)) {
                updated = adminService.approveUser(userId);
            } else if ("reject".equalsIgnoreCase(action)) {
                updated = adminService.rejectUser(userId);
            }

            if (updated) {
                req.getSession().setAttribute("flashSuccess", "User status updated successfully.");
            } else {
                req.getSession().setAttribute("flashError", "Could not update user status.");
            }
            resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid user id.");
            doGet(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Unable to process admin action.", e);
        }
    }

    private void loadDashboard(HttpServletRequest req) throws ServletException {
        try {
            List<User> pendingUsers = adminService.getPendingUsers();
            req.setAttribute("pendingUsers", pendingUsers);
            req.setAttribute("pendingCount", pendingUsers.size());

            Object flashSuccess = req.getSession().getAttribute("flashSuccess");
            Object flashError = req.getSession().getAttribute("flashError");
            if (flashSuccess != null) {
                req.setAttribute("success", flashSuccess.toString());
                req.getSession().removeAttribute("flashSuccess");
            }
            if (flashError != null) {
                req.setAttribute("error", flashError.toString());
                req.getSession().removeAttribute("flashError");
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to load pending users.", e);
        }
    }
}
