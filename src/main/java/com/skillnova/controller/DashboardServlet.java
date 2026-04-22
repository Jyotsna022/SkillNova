package com.skillnova.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "dashboardServlet", urlPatterns = {"/client/dashboard", "/freelancer/dashboard"})
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String fullName = session == null ? "User" : (String) session.getAttribute("fullName");
        String role = session == null ? "GUEST" : (String) session.getAttribute("role");

        req.setAttribute("fullName", fullName);
        req.setAttribute("role", role);
        req.setAttribute("dashboardPath", req.getRequestURI().substring(req.getContextPath().length()));
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}
