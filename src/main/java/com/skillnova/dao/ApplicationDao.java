package com.skillnova.dao;

import com.skillnova.model.ApplicationRecord;
import com.skillnova.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ApplicationDao {

    public List<ApplicationRecord> findAllWithDetails() throws SQLException {
        if (!tableExists("applications") || !tableExists("jobs")) {
            return new ArrayList<>();
        }

        final String sql = """
                SELECT a.application_id,
                       j.job_title,
                       freelancer.full_name AS freelancer_name,
                       freelancer.email AS freelancer_email,
                       client.full_name AS client_name,
                       a.application_status,
                       a.applied_at
                FROM applications a
                JOIN jobs j ON j.job_id = a.job_id
                JOIN users freelancer ON freelancer.user_id = a.freelancer_id
                JOIN users client ON client.user_id = j.client_id
                ORDER BY a.applied_at DESC
                """;

        List<ApplicationRecord> applications = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                ApplicationRecord application = new ApplicationRecord();
                application.setApplicationId(resultSet.getLong("application_id"));
                application.setJobTitle(resultSet.getString("job_title"));
                application.setFreelancerName(resultSet.getString("freelancer_name"));
                application.setFreelancerEmail(resultSet.getString("freelancer_email"));
                application.setClientName(resultSet.getString("client_name"));
                application.setApplicationStatus(resultSet.getString("application_status"));
                application.setAppliedAt(resultSet.getTimestamp("applied_at"));
                applications.add(application);
            }
        }
        return applications;
    }

    public int countByClientId(long clientId) throws SQLException {
        if (!tableExists("applications") || !tableExists("jobs")) {
            return 0;
        }
        final String sql = """
                SELECT COUNT(*)
                FROM applications a
                JOIN jobs j ON j.job_id = a.job_id
                WHERE j.client_id = ?
                """;
        return countWithLong(sql, clientId);
    }

    public int countByFreelancerId(long freelancerId) throws SQLException {
        if (!tableExists("applications")) {
            return 0;
        }
        final String sql = "SELECT COUNT(*) FROM applications WHERE freelancer_id = ?";
        return countWithLong(sql, freelancerId);
    }

    public int countByFreelancerIdAndStatus(long freelancerId, String status) throws SQLException {
        if (!tableExists("applications")) {
            return 0;
        }
        final String sql = "SELECT COUNT(*) FROM applications WHERE freelancer_id = ? AND application_status = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, freelancerId);
            statement.setString(2, status);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
                return 0;
            }
        }
    }

    public List<ApplicationRecord> findRecentForClient(long clientId, int limit) throws SQLException {
        if (!tableExists("applications") || !tableExists("jobs") || !tableExists("users")) {
            return new ArrayList<>();
        }
        final String sql = """
                SELECT a.application_id,
                       j.job_title,
                       freelancer.full_name AS freelancer_name,
                       freelancer.email AS freelancer_email,
                       a.application_status,
                       a.applied_at
                FROM applications a
                JOIN jobs j ON j.job_id = a.job_id
                JOIN users freelancer ON freelancer.user_id = a.freelancer_id
                WHERE j.client_id = ?
                ORDER BY a.applied_at DESC
                LIMIT ?
                """;

        List<ApplicationRecord> applications = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, clientId);
            statement.setInt(2, limit);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    ApplicationRecord application = new ApplicationRecord();
                    application.setApplicationId(resultSet.getLong("application_id"));
                    application.setJobTitle(resultSet.getString("job_title"));
                    application.setFreelancerName(resultSet.getString("freelancer_name"));
                    application.setFreelancerEmail(resultSet.getString("freelancer_email"));
                    application.setApplicationStatus(resultSet.getString("application_status"));
                    application.setAppliedAt(resultSet.getTimestamp("applied_at"));
                    applications.add(application);
                }
            }
        }
        return applications;
    }

    public List<ApplicationRecord> findRecentForFreelancer(long freelancerId, int limit) throws SQLException {
        if (!tableExists("applications") || !tableExists("jobs") || !tableExists("users")) {
            return new ArrayList<>();
        }
        final String sql = """
                SELECT a.application_id,
                       j.job_title,
                       client.full_name AS client_name,
                       a.application_status,
                       a.applied_at
                FROM applications a
                JOIN jobs j ON j.job_id = a.job_id
                JOIN users client ON client.user_id = j.client_id
                WHERE a.freelancer_id = ?
                ORDER BY a.applied_at DESC
                LIMIT ?
                """;

        List<ApplicationRecord> applications = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, freelancerId);
            statement.setInt(2, limit);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    ApplicationRecord application = new ApplicationRecord();
                    application.setApplicationId(resultSet.getLong("application_id"));
                    application.setJobTitle(resultSet.getString("job_title"));
                    application.setClientName(resultSet.getString("client_name"));
                    application.setApplicationStatus(resultSet.getString("application_status"));
                    application.setAppliedAt(resultSet.getTimestamp("applied_at"));
                    applications.add(application);
                }
            }
        }
        return applications;
    }

    private int countWithLong(String sql, long value) throws SQLException {
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, value);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
                return 0;
            }
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
