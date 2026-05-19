package com.skillnova.dao;

import com.skillnova.model.Job;
import com.skillnova.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AdminJobDao {

    public List<Job> findAllJobs() throws SQLException {
        if (!tableExists("jobs")) {
            return new ArrayList<>();
        }

        final String sql = """
                SELECT job_id, client_id, job_title, job_description, budget_min, budget_max,
                       experience_level, location_type, job_status
                FROM jobs
                ORDER BY created_at DESC
                """;

        List<Job> jobs = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
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
                jobs.add(job);
            }
        }
        return jobs;
    }

    public boolean updateJobStatus(long jobId, String status) throws SQLException {
        if (!tableExists("jobs")) {
            return false;
        }
        final String sql = "UPDATE jobs SET job_status = ? WHERE job_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setLong(2, jobId);
            return statement.executeUpdate() == 1;
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
