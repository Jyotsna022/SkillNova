package com.skillnova.service;

import com.skillnova.dao.ApplicationDao;
import com.skillnova.dao.JobDao;
import com.skillnova.model.ApplicationRecord;
import com.skillnova.model.Job;
import com.skillnova.model.UserDashboardData;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDashboardService {

    private final JobDao jobDao;
    private final ApplicationDao applicationDao;

    public UserDashboardService() {
        this.jobDao = new JobDao();
        this.applicationDao = new ApplicationDao();
    }

    public UserDashboardData buildForClient(long clientId, String fullName) throws SQLException {
        UserDashboardData data = new UserDashboardData();
        data.setRole("CLIENT");
        data.setFullName(fullName);

        int postedJobs = jobDao.countByClientId(clientId);
        int openJobs = jobDao.countByClientIdAndStatus(clientId, "OPEN");
        int totalApplications = applicationDao.countByClientId(clientId);

        List<Job> recentJobs = jobDao.findByClientId(clientId);
        List<ApplicationRecord> recentApplications = applicationDao.findRecentForClient(clientId, 8);

        data.setPrimaryCount(postedJobs);
        data.setSecondaryCount(totalApplications);
        data.setTertiaryCount(openJobs);
        data.setJobs(recentJobs);
        data.setApplications(recentApplications);
        return data;
    }

    public UserDashboardData buildForFreelancer(long freelancerId, String fullName) throws SQLException {
        UserDashboardData data = new UserDashboardData();
        data.setRole("FREELANCER");
        data.setFullName(fullName);

        int openJobs = jobDao.countOpenJobs();
        int myApplications = applicationDao.countByFreelancerId(freelancerId);
        int shortlisted = applicationDao.countByFreelancerIdAndStatus(freelancerId, "SHORTLISTED");

        List<Job> recentOpenJobs = jobDao.findRecentOpenJobs(8);
        List<ApplicationRecord> myRecentApplications = applicationDao.findRecentForFreelancer(freelancerId, 8);

        data.setPrimaryCount(openJobs);
        data.setSecondaryCount(myApplications);
        data.setTertiaryCount(shortlisted);
        data.setJobs(recentOpenJobs);
        data.setApplications(myRecentApplications);
        return data;
    }

    public UserDashboardData empty(String role, String fullName) {
        UserDashboardData data = new UserDashboardData();
        data.setRole(role);
        data.setFullName(fullName);
        data.setPrimaryCount(0);
        data.setSecondaryCount(0);
        data.setTertiaryCount(0);
        data.setJobs(new ArrayList<>());
        data.setApplications(new ArrayList<>());
        return data;
    }
}
