package com.skillnova.service;

import com.skillnova.dao.UserDao;
import com.skillnova.model.Role;
import com.skillnova.model.User;
import com.skillnova.util.PasswordUtil;

import java.sql.SQLException;
import java.util.Optional;

public class AuthService {

    private final UserDao userDao;

    public AuthService() {
        this.userDao = new UserDao();
    }

    public long registerPendingUser(String fullName, String email, String phone, String rawPassword, Role role) throws SQLException {
        if (userDao.existsByEmailOrPhone(email, phone)) {
            throw new IllegalArgumentException("An account with this email or phone already exists.");
        }

        User user = new User();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.setPasswordHash(PasswordUtil.hashPassword(rawPassword));
        user.setRole(role);
        user.setAccountStatus("PENDING");
        return userDao.create(user);
    }

    public Optional<User> authenticate(String email, String rawPassword) throws SQLException {
        Optional<User> userOptional = userDao.findByEmail(email);
        if (userOptional.isEmpty()) {
            return Optional.empty();
        }

        User user = userOptional.get();
        if (!"ACTIVE".equalsIgnoreCase(user.getAccountStatus())) {
            return Optional.empty();
        }

        if (!PasswordUtil.verifyPassword(rawPassword, user.getPasswordHash())) {
            return Optional.empty();
        }

        return Optional.of(user);
    }
}
