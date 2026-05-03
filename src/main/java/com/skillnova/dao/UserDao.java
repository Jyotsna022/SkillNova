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
import java.util.List;
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
}
