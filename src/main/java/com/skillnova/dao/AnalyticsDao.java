package com.skillnova.dao;

import com.skillnova.model.AdminStats;
import com.skillnova.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AnalyticsDao {

    public AdminStats getAdminStats() throws SQLException {
        AdminStats stats = new AdminStats();
        stats.setTotalUsers(fetchCountIfTableExists("users"));
        stats.setTotalJobs(fetchCountIfTableExists("jobs"));
        stats.setTotalApplications(fetchCountIfTableExists("applications"));
        return stats;
    }

    private int fetchCountIfTableExists(String tableName) throws SQLException {
        if (!tableExists(tableName)) {
            return 0;
        }
        return fetchCount("SELECT COUNT(*) FROM " + tableName);
    }

    private int fetchCount(String sql) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        }
    }

    private boolean tableExists(String tableName) throws SQLException {
        final String sql = "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, tableName);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next() && resultSet.getInt(1) > 0;
            }
        }
    }
}
