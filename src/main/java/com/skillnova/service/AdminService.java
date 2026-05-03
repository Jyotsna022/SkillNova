package com.skillnova.service;

import com.skillnova.dao.UserDao;
import com.skillnova.dao.AdminJobDao;
import com.skillnova.dao.ApplicationDao;
import com.skillnova.dao.AnalyticsDao;
import com.skillnova.dao.SystemControlDao;
import com.skillnova.model.AdminStats;
import com.skillnova.model.ApplicationRecord;
import com.skillnova.model.Job;
import com.skillnova.model.SystemControlOverview;
import com.skillnova.model.User;

import java.sql.SQLException;
import java.util.List;

public class AdminService {

    private final UserDao userDao;
    private final ApplicationDao applicationDao;
    private final AnalyticsDao analyticsDao;
    private final AdminJobDao adminJobDao;
    private final SystemControlDao systemControlDao;

    public AdminService() {
        this.userDao = new UserDao();
        this.applicationDao = new ApplicationDao();
        this.analyticsDao = new AnalyticsDao();
        this.adminJobDao = new AdminJobDao();
        this.systemControlDao = new SystemControlDao();
    }

    public List<User> getPendingUsers() throws SQLException {
        return userDao.findPendingUsers();
    }

    public List<User> getAllUsers() throws SQLException {
        return userDao.findAllUsers();
    }

    public boolean approveUser(long userId) throws SQLException {
        return userDao.updateAccountStatus(userId, "ACTIVE");
    }

    public boolean rejectUser(long userId) throws SQLException {
        return userDao.updateAccountStatus(userId, "REJECTED");
    }

    public List<ApplicationRecord> getAllApplications() throws SQLException {
        return applicationDao.findAllWithDetails();
    }

    public AdminStats getStats() throws SQLException {
        return analyticsDao.getAdminStats();
    }

    public List<Job> getAllJobs() throws SQLException {
        return adminJobDao.findAllJobs();
    }

    public boolean closeJob(long jobId) throws SQLException {
        return adminJobDao.updateJobStatus(jobId, "CLOSED");
    }

    public boolean cancelJob(long jobId) throws SQLException {
        return adminJobDao.updateJobStatus(jobId, "CANCELLED");
    }

    public boolean activateUser(long userId) throws SQLException {
        return systemControlDao.updateUserStatus(userId, "ACTIVE");
    }

    public boolean suspendUser(long userId) throws SQLException {
        return systemControlDao.updateUserStatus(userId, "SUSPENDED");
    }

    public boolean deleteUser(long userId) throws SQLException {
        return userDao.deleteById(userId);
    }

    public SystemControlOverview getSystemControlOverview() throws SQLException {
        return systemControlDao.getOverview();
    }
}
