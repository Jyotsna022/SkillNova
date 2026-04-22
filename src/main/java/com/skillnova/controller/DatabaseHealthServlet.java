package com.skillnova.controller;

import com.skillnova.util.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "databaseHealthServlet", urlPatterns = "/health/db")
public class DatabaseHealthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        boolean connected = DBConnection.canConnect();
        req.setAttribute("dbConnected", connected);
        req.getRequestDispatcher("/WEB-INF/views/health-db.jsp").forward(req, resp);
    }
}
