package com.skillnova.dao;

import com.skillnova.model.Job;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class JobDao {

    public long create(Job job) throws SQLException {
        final String sql = """
                INSERT INTO jobs (
                    client_id, job_title, job_description, budget_min, budget_max,
                    experience_level, location_type, job_status
                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setLong(1, job.getClientId());
            statement.setString(2, job.getJobTitle());
            statement.setString(3, job.getJobDescription());
            statement.setBigDecimal(4, job.getBudgetMin());
            statement.setBigDecimal(5, job.getBudgetMax());
            statement.setString(6, job.getExperienceLevel());
            statement.setString(7, job.getLocationType());
            statement.setString(8, job.getJobStatus());
            statement.executeUpdate();

            try (ResultSet resultSet = statement.getGeneratedKeys()) {
                if (resultSet.next()) {
                    return resultSet.getLong(1);
                }
            }
        }

        throw new SQLException("Creating job failed, no generated key returned.");
    }

    public boolean update(Job job) throws SQLException {
        final String sql = """
                UPDATE jobs
                SET job_title = ?, job_description = ?, budget_min = ?, budget_max = ?,
                    experience_level = ?, location_type = ?, job_status = ?
                WHERE job_id = ? AND client_id = ?
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, job.getJobTitle());
            statement.setString(2, job.getJobDescription());
            statement.setBigDecimal(3, job.getBudgetMin());
            statement.setBigDecimal(4, job.getBudgetMax());
            statement.setString(5, job.getExperienceLevel());
            statement.setString(6, job.getLocationType());
            statement.setString(7, job.getJobStatus());
            statement.setLong(8, job.getJobId());
            statement.setLong(9, job.getClientId());
            return statement.executeUpdate() == 1;
        }
    }

    public boolean delete(long jobId, long clientId) throws SQLException {
        final String sql = "DELETE FROM jobs WHERE job_id = ? AND client_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, jobId);
            statement.setLong(2, clientId);
            return statement.executeUpdate() == 1;
        }
    }

    public List<Job> findByClientId(long clientId) throws SQLException {
        if (!tableExists("jobs")) {
            return new ArrayList<>();
        }
        final String sql = """
                SELECT job_id, client_id, job_title, job_description, budget_min, budget_max,
                       experience_level, location_type, job_status
                FROM jobs
                WHERE client_id = ?
                ORDER BY created_at DESC
                """;

        List<Job> jobs = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, clientId);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    jobs.add(mapRow(resultSet));
                }
            }
        }
        return jobs;
    }

    public Optional<Job> findByIdAndClientId(long jobId, long clientId) throws SQLException {
        if (!tableExists("jobs")) {
            return Optional.empty();
        }
        final String sql = """
                SELECT job_id, client_id, job_title, job_description, budget_min, budget_max,
                       experience_level, location_type, job_status
                FROM jobs
                WHERE job_id = ? AND client_id = ?
                LIMIT 1
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, jobId);
            statement.setLong(2, clientId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return Optional.empty();
                }
                return Optional.of(mapRow(resultSet));
            }
        }
    }

    public int countByClientId(long clientId) throws SQLException {
        if (!tableExists("jobs")) {
            return 0;
        }
        final String sql = "SELECT COUNT(*) FROM jobs WHERE client_id = ?";
        return countWithLong(sql, clientId);
    }

    public int countByClientIdAndStatus(long clientId, String status) throws SQLException {
        if (!tableExists("jobs")) {
            return 0;
        }
        final String sql = "SELECT COUNT(*) FROM jobs WHERE client_id = ? AND job_status = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, clientId);
            statement.setString(2, status);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
                return 0;
            }
        }
    }

    public int countOpenJobs() throws SQLException {
        if (!tableExists("jobs")) {
            return 0;
        }
        final String sql = "SELECT COUNT(*) FROM jobs WHERE job_status = 'OPEN'";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
            return 0;
        }
    }

    public List<Job> findRecentOpenJobs(int limit) throws SQLException {
        if (!tableExists("jobs")) {
            return new ArrayList<>();
        }
        final String sql = """
                SELECT job_id, client_id, job_title, job_description, budget_min, budget_max,
                       experience_level, location_type, job_status
                FROM jobs
                WHERE job_status = 'OPEN'
                ORDER BY created_at DESC
                LIMIT ?
                """;

        List<Job> jobs = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setInt(1, limit);
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    jobs.add(mapRow(resultSet));
                }
            }
        }
        return jobs;
    }

    public List<Job> searchOpenJobs(String keyword, String experienceLevel, String locationType, int limit) throws SQLException {
        if (!tableExists("jobs")) {
            return new ArrayList<>();
        }

        StringBuilder sql = new StringBuilder("""
                SELECT job_id, client_id, job_title, job_description, budget_min, budget_max,
                       experience_level, location_type, job_status
                FROM jobs
                WHERE job_status = 'OPEN'
                """);

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (job_title LIKE ? OR job_description LIKE ?)");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
        }
        if (experienceLevel != null && !experienceLevel.isBlank()) {
            sql.append(" AND experience_level = ?");
            params.add(experienceLevel.trim());
        }
        if (locationType != null && !locationType.isBlank()) {
            sql.append(" AND location_type = ?");
            params.add(locationType.trim());
        }
        sql.append(" ORDER BY created_at DESC LIMIT ?");
        params.add(limit);

        List<Job> jobs = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    jobs.add(mapRow(resultSet));
                }
            }
        }
        return jobs;
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

    private Job mapRow(ResultSet resultSet) throws SQLException {
        Job job = new Job();
        job.setJobId(resultSet.getLong("job_id"));
        job.setClientId(resultSet.getLong("client_id"));
        job.setJobTitle(resultSet.getString("job_title"));
        job.setJobDescription(resultSet.getString("job_description"));
        job.setBudgetMin(resultSet.getBigDecimal("budget_min"));
        job.setBudgetMax(resultSet.getBigDecimal("budget_max"));
        job.setExperienceLevel(resultSet.getString("experience_level"));
        job.setLocationType(resultSet.getString("location_type"));
        job.setJobStatus(resultSet.getString("job_status"));
        return job;
    }
}
