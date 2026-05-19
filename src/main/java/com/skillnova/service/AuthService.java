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
            System.out.println("[AUTH] User not found for email=" + email);
            return Optional.empty();
        }

        User user = userOptional.get();
        System.out.println("[AUTH] Found user email=" + user.getEmail() + " status=" + user.getAccountStatus() + " role=" + user.getRole());
        if (!"ACTIVE".equalsIgnoreCase(user.getAccountStatus())) {
            System.out.println("[AUTH] Blocked due to non-active status");
            return Optional.empty();
        }

        if (!PasswordUtil.verifyPassword(rawPassword, user.getPasswordHash())) {
            System.out.println("[AUTH] Password verification failed");
            return Optional.empty();
        }

        System.out.println("[AUTH] Authentication success");
        return Optional.of(user);
    }

    public boolean updateFreelancerProfile(long userId, String headline, String yearsExperience, String hourlyRate, String bio)
            throws SQLException {
        return userDao.updateFreelancerProfile(userId, headline, yearsExperience, hourlyRate, bio);
    }

    public Optional<User> getUserById(long userId) throws SQLException {
        return userDao.findById(userId);
    }
}
