package com.skillnova.service;

import com.skillnova.dao.UserDao;
import com.skillnova.model.User;

import java.sql.SQLException;
import java.util.List;

public class AdminService {

    private final UserDao userDao;

    public AdminService() {
        this.userDao = new UserDao();
    }

    public List<User> getPendingUsers() throws SQLException {
        return userDao.findPendingUsers();
    }

    public boolean approveUser(long userId) throws SQLException {
        return userDao.updateAccountStatus(userId, "ACTIVE");
    }

    public boolean rejectUser(long userId) throws SQLException {
        return userDao.updateAccountStatus(userId, "REJECTED");
    }
}
