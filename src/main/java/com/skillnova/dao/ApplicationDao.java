package com.skillnova.dao;

import com.skillnova.model.ApplicationRecord;

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
                       a.job_id,
                       a.freelancer_id,
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
                application.setJobId(resultSet.getLong("job_id"));
                application.setFreelancerId(resultSet.getLong("freelancer_id"));
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
                       a.job_id,
                       a.freelancer_id,
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
                    application.setJobId(resultSet.getLong("job_id"));
                    application.setFreelancerId(resultSet.getLong("freelancer_id"));
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
                       a.job_id,
                       a.freelancer_id,
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
                    application.setJobId(resultSet.getLong("job_id"));
                    application.setFreelancerId(resultSet.getLong("freelancer_id"));
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

    public List<ApplicationRecord> findByJobForClient(long jobId, long clientId) throws SQLException {
        if (!tableExists("applications") || !tableExists("jobs") || !tableExists("users")) {
            return new ArrayList<>();
        }
        final String sql = """
                SELECT a.application_id,
                       a.job_id,
                       a.freelancer_id,
                       j.job_title,
                       freelancer.full_name AS freelancer_name,
                       freelancer.email AS freelancer_email,
                       a.application_status,
                       a.applied_at
                FROM applications a
                JOIN jobs j ON j.job_id = a.job_id
                JOIN users freelancer ON freelancer.user_id = a.freelancer_id
                WHERE a.job_id = ? AND j.client_id = ?
                ORDER BY a.applied_at DESC
                """;

        List<ApplicationRecord> applications = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, jobId);
            statement.setLong(2, clientId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    ApplicationRecord application = new ApplicationRecord();
                    application.setApplicationId(resultSet.getLong("application_id"));
                    application.setJobId(resultSet.getLong("job_id"));
                    application.setFreelancerId(resultSet.getLong("freelancer_id"));
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

    public boolean updateApplicationStatusForClient(long applicationId, long clientId, String newStatus) throws SQLException {
        if (!tableExists("applications") || !tableExists("jobs")) {
            return false;
        }
        final String sql = """
                UPDATE applications a
                JOIN jobs j ON j.job_id = a.job_id
                SET a.application_status = ?
                WHERE a.application_id = ? AND j.client_id = ?
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, newStatus);
            statement.setLong(2, applicationId);
            statement.setLong(3, clientId);
            return statement.executeUpdate() == 1;
        }
    }

    public boolean applyToJob(long freelancerId, long jobId, String coverLetter, String proposedBudgetRaw, String estimatedDaysRaw)
            throws SQLException {
        if (!tableExists("applications") || !tableExists("jobs")) {
            return false;
        }
        if (hasApplied(freelancerId, jobId)) {
            return false;
        }

        final String sql = """
                INSERT INTO applications (job_id, freelancer_id, cover_letter, proposed_budget, estimated_days, application_status)
                VALUES (?, ?, ?, ?, ?, 'APPLIED')
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, jobId);
            statement.setLong(2, freelancerId);
            statement.setString(3, coverLetter == null ? null : coverLetter.trim());

            if (proposedBudgetRaw == null || proposedBudgetRaw.isBlank()) {
                statement.setNull(4, java.sql.Types.DECIMAL);
            } else {
                statement.setBigDecimal(4, new java.math.BigDecimal(proposedBudgetRaw));
            }

            if (estimatedDaysRaw == null || estimatedDaysRaw.isBlank()) {
                statement.setNull(5, java.sql.Types.INTEGER);
            } else {
                statement.setInt(5, Integer.parseInt(estimatedDaysRaw));
            }

            return statement.executeUpdate() == 1;
        }
    }

    public boolean withdrawApplication(long applicationId, long freelancerId) throws SQLException {
        if (!tableExists("applications")) {
            return false;
        }
        final String sql = """
                UPDATE applications
                SET application_status = 'WITHDRAWN'
                WHERE application_id = ? AND freelancer_id = ?
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, applicationId);
            statement.setLong(2, freelancerId);
            return statement.executeUpdate() == 1;
        }
    }

    public boolean addReview(long jobId, long reviewerUserId, long revieweeUserId, int rating, String comment) throws SQLException {
        if (!tableExists("reviews") || rating < 1 || rating > 5) {
            return false;
        }
        final String sql = """
                INSERT INTO reviews (job_id, reviewer_user_id, reviewee_user_id, rating, review_comment)
                VALUES (?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                    rating = VALUES(rating),
                    review_comment = VALUES(review_comment)
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, jobId);
            statement.setLong(2, reviewerUserId);
            statement.setLong(3, revieweeUserId);
            statement.setInt(4, rating);
            statement.setString(5, comment == null ? null : comment.trim());
            return statement.executeUpdate() >= 1;
        }
    }

    public Long getClientIdByJobId(long jobId) throws SQLException {
        if (!tableExists("jobs")) {
            return null;
        }
        final String sql = "SELECT client_id FROM jobs WHERE job_id = ? LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, jobId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getLong(1);
                }
                return null;
            }
        }
    }

    public double getAverageReviewByPair(long revieweeUserId, long reviewerUserId) throws SQLException {
        if (!tableExists("reviews")) {
            return 0.0;
        }
        final String sql = "SELECT AVG(rating) FROM reviews WHERE reviewee_user_id = ? AND reviewer_user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, revieweeUserId);
            statement.setLong(2, reviewerUserId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble(1);
                }
                return 0.0;
            }
        }
    }

    public double getAverageRatingForUser(long revieweeUserId) throws SQLException {
        if (!tableExists("reviews")) {
            return 0.0;
        }
        final String sql = "SELECT AVG(rating) FROM reviews WHERE reviewee_user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, revieweeUserId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getDouble(1);
                }
                return 0.0;
            }
        }
    }

    private boolean hasApplied(long freelancerId, long jobId) throws SQLException {
        final String sql = "SELECT 1 FROM applications WHERE freelancer_id = ? AND job_id = ? LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, freelancerId);
            statement.setLong(2, jobId);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
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
