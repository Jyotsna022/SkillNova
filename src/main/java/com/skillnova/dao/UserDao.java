package com.skillnova.dao;

import com.skillnova.model.Role;
import com.skillnova.model.User;
import com.skillnova.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

public class UserDao {

    public boolean existsByEmailOrPhone(String email, String phone) throws SQLException {
        final String sql = "SELECT 1 FROM users WHERE email = ? OR phone = ? LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            statement.setString(2, phone);
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    public long create(User user) throws SQLException {
        final String sql = """
                INSERT INTO users (role_id, full_name, email, phone, password_hash, account_status)
                VALUES ((SELECT role_id FROM roles WHERE role_name = ?), ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, user.getRole().name());
            statement.setString(2, user.getFullName());
            statement.setString(3, user.getEmail());
            statement.setString(4, user.getPhone());
            statement.setString(5, user.getPasswordHash());
            statement.setString(6, user.getAccountStatus());
            statement.executeUpdate();

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getLong(1);
                }
            }
        }

        throw new SQLException("Creating user failed, no generated key returned.");
    }

    public Optional<User> findByEmail(String email) throws SQLException {
        final String sql = """
                SELECT u.user_id, r.role_name, u.full_name, u.email, u.phone, u.password_hash, u.account_status
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                WHERE u.email = ?
                LIMIT 1
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return Optional.empty();
                }

                User user = new User();
                user.setUserId(resultSet.getLong("user_id"));
                user.setRole(Role.valueOf(resultSet.getString("role_name")));
                user.setFullName(resultSet.getString("full_name"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setPasswordHash(resultSet.getString("password_hash"));
                user.setAccountStatus(resultSet.getString("account_status"));
                return Optional.of(user);
            }
        }
    }

    public List<User> findPendingUsers() throws SQLException {
        final String sql = """
                SELECT u.user_id, r.role_name, u.full_name, u.email, u.phone, u.password_hash, u.account_status
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                WHERE u.account_status = 'PENDING'
                ORDER BY u.created_at DESC
                """;

        List<User> users = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                User user = new User();
                user.setUserId(resultSet.getLong("user_id"));
                user.setRole(Role.valueOf(resultSet.getString("role_name")));
                user.setFullName(resultSet.getString("full_name"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setPasswordHash(resultSet.getString("password_hash"));
                user.setAccountStatus(resultSet.getString("account_status"));
                users.add(user);
            }
        }
        return users;
    }

    public List<User> findAllUsers() throws SQLException {
        final String sql = """
                SELECT u.user_id, r.role_name, u.full_name, u.email, u.phone, u.password_hash, u.account_status
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                ORDER BY u.created_at DESC
                """;

        List<User> users = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                User user = new User();
                user.setUserId(resultSet.getLong("user_id"));
                user.setRole(Role.valueOf(resultSet.getString("role_name")));
                user.setFullName(resultSet.getString("full_name"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setPasswordHash(resultSet.getString("password_hash"));
                user.setAccountStatus(resultSet.getString("account_status"));
                users.add(user);
            }
        }
        return users;
    }

    public boolean updateAccountStatus(long userId, String status) throws SQLException {
        final String sql = "UPDATE users SET account_status = ? WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status);
            statement.setLong(2, userId);
            return statement.executeUpdate() == 1;
        }
    }

    public boolean deleteById(long userId) throws SQLException {
        final String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            return statement.executeUpdate() == 1;
        }
    }

    public boolean updateFreelancerProfile(long userId, String headline, String yearsExperience, String hourlyRate, String bio)
            throws SQLException {
        final String sql = """
                INSERT INTO freelancer_profiles (user_id, headline, years_experience, hourly_rate, freelancer_bio)
                VALUES (?, ?, ?, ?, ?)
                ON DUPLICATE KEY UPDATE
                    headline = VALUES(headline),
                    years_experience = VALUES(years_experience),
                    hourly_rate = VALUES(hourly_rate),
                    freelancer_bio = VALUES(freelancer_bio)
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            statement.setString(2, headline == null ? null : headline.trim());
            statement.setInt(3, yearsExperience == null || yearsExperience.isBlank() ? 0 : Integer.parseInt(yearsExperience));
            if (hourlyRate == null || hourlyRate.isBlank()) {
                statement.setNull(4, java.sql.Types.DECIMAL);
            } else {
                statement.setBigDecimal(4, new java.math.BigDecimal(hourlyRate));
            }
            statement.setString(5, bio == null ? null : bio.trim());
            return statement.executeUpdate() > 0;
        }
    }

    public Optional<User> findById(long userId) throws SQLException {
        final String sql = """
                SELECT u.user_id, r.role_name, u.full_name, u.email, u.phone, u.password_hash, u.account_status
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                WHERE u.user_id = ?
                LIMIT 1
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (!resultSet.next()) {
                    return Optional.empty();
                }

                User user = new User();
                user.setUserId(resultSet.getLong("user_id"));
                user.setRole(Role.valueOf(resultSet.getString("role_name")));
                user.setFullName(resultSet.getString("full_name"));
                user.setEmail(resultSet.getString("email"));
                user.setPhone(resultSet.getString("phone"));
                user.setPasswordHash(resultSet.getString("password_hash"));
                user.setAccountStatus(resultSet.getString("account_status"));
                return Optional.of(user);
            }
        }
    }

    public boolean updateBasicUser(long userId, String fullName, String phone) throws SQLException {
        final String sql = "UPDATE users SET full_name = ?, phone = ? WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, fullName.trim());
            statement.setString(2, phone.trim());
            statement.setLong(3, userId);
            return statement.executeUpdate() == 1;
        }
    }

    public Map<String, String> getFreelancerProfile(long userId) throws SQLException {
        Map<String, String> profile = new HashMap<>();
        final String sql = """
                SELECT headline, years_experience, hourly_rate, freelancer_bio
                FROM freelancer_profiles
                WHERE user_id = ?
                """;
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setLong(1, userId);
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    profile.put("headline", safe(resultSet.getString("headline")));
                    profile.put("yearsExperience", String.valueOf(resultSet.getInt("years_experience")));
                    profile.put("hourlyRate", safe(resultSet.getString("hourly_rate")));
                    profile.put("bio", safe(resultSet.getString("freelancer_bio")));
                }
            }
        }
        return profile;
    }

    public List<Map<String, String>> searchFreelancerProfiles(String keyword, String minYearsExperience) throws SQLException {
        StringBuilder sql = new StringBuilder("""
                SELECT u.user_id, u.full_name, u.email, u.phone,
                       fp.headline, fp.years_experience, fp.hourly_rate, fp.freelancer_bio
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                LEFT JOIN freelancer_profiles fp ON fp.user_id = u.user_id
                WHERE r.role_name = 'FREELANCER' AND u.account_status = 'ACTIVE'
                """);

        List<Object> params = new ArrayList<>();
        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND (u.full_name LIKE ? OR fp.headline LIKE ? OR fp.freelancer_bio LIKE ?)");
            String like = "%" + keyword.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (minYearsExperience != null && !minYearsExperience.isBlank()) {
            sql.append(" AND fp.years_experience >= ?");
            params.add(Integer.parseInt(minYearsExperience.trim()));
        }
        sql.append(" ORDER BY fp.years_experience DESC, u.full_name ASC LIMIT 40");

        List<Map<String, String>> freelancers = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Map<String, String> row = new HashMap<>();
                    row.put("userId", String.valueOf(resultSet.getLong("user_id")));
                    row.put("fullName", safe(resultSet.getString("full_name")));
                    row.put("email", safe(resultSet.getString("email")));
                    row.put("phone", safe(resultSet.getString("phone")));
                    row.put("headline", safe(resultSet.getString("headline")));
                    row.put("yearsExperience", String.valueOf(resultSet.getInt("years_experience")));
                    row.put("hourlyRate", safe(resultSet.getString("hourly_rate")));
                    row.put("bio", safe(resultSet.getString("freelancer_bio")));
                    freelancers.add(row);
                }
            }
        }
        return freelancers;
    }

    private String safe(String value) {
        return value == null ? "" : value;
    }
}
