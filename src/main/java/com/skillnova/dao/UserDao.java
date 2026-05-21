package com.skillnova.dao;

import com.skillnova.model.Role;
import com.skillnova.model.User;
import com.skillnova.util.DBConnection;

import java.sql.*;
import java.util.*;

public class UserDao {

    public boolean existsByEmailOrPhone(String email, String phone) throws SQLException {
        if (email == null || phone == null) {
            throw new IllegalArgumentException("Email and phone cannot be null");
        }

        final String sql = "SELECT 1 FROM users WHERE email = ? OR phone = ? LIMIT 1";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email.trim());
            statement.setString(2, phone.trim());
            try (ResultSet resultSet = statement.executeQuery()) {
                return resultSet.next();
            }
        }
    }

    public long create(User user) throws SQLException {
        validateUser(user);

        final String sql = """
                INSERT INTO users (role_id, full_name, email, phone, password_hash, account_status)
                VALUES ((SELECT role_id FROM roles WHERE role_name = ?), ?, ?, ?, ?, ?)
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setString(1, user.getRole().name());
            statement.setString(2, user.getFullName().trim());
            statement.setString(3, user.getEmail().trim());
            statement.setString(4, user.getPhone().trim());
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
        if (email == null || email.isBlank()) {
            throw new IllegalArgumentException("Email cannot be null or blank");
        }

        final String sql = """
                SELECT u.user_id, r.role_name, u.full_name, u.email, u.phone, u.password_hash, u.account_status
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                WHERE u.email = ?
                LIMIT 1
                """;

        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, email.trim());
            try (ResultSet resultSet = statement.executeQuery()) {
                if (resultSet.next()) {
                    return Optional.of(mapUser(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    public List<User> findPendingUsers() throws SQLException {
        final String sql = """
                SELECT u.user_id, r.role_name, u.full_name, u.email, u.phone, u.password_hash, u.account_status
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                WHERE u.account_status = 'PENDING'
                ORDER BY u.created_at DESC
                """;

        return findUsersByQuery(sql);
    }

    public List<User> findAllUsers() throws SQLException {
        final String sql = """
                SELECT u.user_id, r.role_name, u.full_name, u.email, u.phone, u.password_hash, u.account_status
                FROM users u
                JOIN roles r ON r.role_id = u.role_id
                ORDER BY u.created_at DESC
                """;

        return findUsersByQuery(sql);
    }

    public boolean updateAccountStatus(long userId, String status) throws SQLException {
        if (status == null || status.isBlank()) {
            throw new IllegalArgumentException("Status cannot be null or blank");
        }

        final String sql = "UPDATE users SET account_status = ? WHERE user_id = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, status.trim());
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
                if (resultSet.next()) {
                    return Optional.of(mapUser(resultSet));
                }
            }
        }
        return Optional.empty();
    }

    private User mapUser(ResultSet resultSet) throws SQLException {
        User user = new User();
        user.setUserId(resultSet.getLong("user_id"));
        user.setRole(Role.valueOf(resultSet.getString("role_name")));
        user.setFullName(resultSet.getString("full_name"));
        user.setEmail(resultSet.getString("email"));
        user.setPhone(resultSet.getString("phone"));
        user.setPasswordHash(resultSet.getString("password_hash"));
        user.setAccountStatus(resultSet.getString("account_status"));
        return user;
    }

    private List<User> findUsersByQuery(String sql) throws SQLException {
        List<User> users = new ArrayList<>();
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement statement = connection.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {
            while (resultSet.next()) {
                users.add(mapUser(resultSet));
            }
        }
        return users;
    }

    private void validateUser(User user) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        if (user.getFullName() == null || user.getFullName().isBlank()) {
            throw new IllegalArgumentException("User full name cannot be null or blank");
        }
        if (user.getEmail() == null || user.getEmail().isBlank()) {
            throw new IllegalArgumentException("User email cannot be null or blank");
        }
        if (user.getPhone() == null || user.getPhone().isBlank()) {
            throw new IllegalArgumentException("User phone cannot be null or blank");
        }
        if (user.getPasswordHash() == null || user.getPasswordHash().isBlank()) {
            throw new IllegalArgumentException("User password hash cannot be null or blank");
        }
    }
}