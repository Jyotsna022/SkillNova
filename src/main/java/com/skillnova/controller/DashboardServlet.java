package com.skillnova.controller;

import com.skillnova.model.UserDashboardData;
import com.skillnova.service.UserDashboardService;
import com.skillnova.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "dashboardServlet", urlPatterns = {"/client/dashboard", "/freelancer/dashboard"})
public class DashboardServlet extends HttpServlet {

    private final UserDashboardService userDashboardService = new UserDashboardService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String fullName = session == null ? "User" : (String) session.getAttribute(SessionUtil.FULL_NAME);
        String role = SessionUtil.getRole(session);
        Long userId = SessionUtil.getUserId(session);

        req.setAttribute("fullName", fullName);
        req.setAttribute("role", role);

        if (role == null || userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try {
            UserDashboardData dashboardData;
            if ("CLIENT".equals(role)) {
                dashboardData = userDashboardService.buildForClient(userId, fullName);
            } else if ("FREELANCER".equals(role)) {
                dashboardData = userDashboardService.buildForFreelancer(userId, fullName);
            } else {
                dashboardData = userDashboardService.empty(role, fullName);
            }

            req.setAttribute("dashboard", dashboardData);
            req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("dashboard", userDashboardService.empty(role, fullName));
            req.setAttribute("error", "Could not load dashboard data. Please verify database setup.");
            req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
        }
    }
}
