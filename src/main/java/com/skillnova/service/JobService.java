package com.skillnova.service;

import com.skillnova.dao.JobDao;
import com.skillnova.model.Job;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

public class JobService {

    private final JobDao jobDao;

    public JobService() {
        this.jobDao = new JobDao();
    }

    public long createJob(long clientId, String title, String description, String budgetMinRaw, String budgetMaxRaw,
                          String experienceLevel, String locationType) throws SQLException {
        Job job = buildJob(clientId, 0, title, description, budgetMinRaw, budgetMaxRaw, experienceLevel, locationType, "OPEN");
        return jobDao.create(job);
    }

    public boolean updateJob(long jobId, long clientId, String title, String description, String budgetMinRaw, String budgetMaxRaw,
                             String experienceLevel, String locationType, String jobStatus) throws SQLException {
        Job job = buildJob(clientId, jobId, title, description, budgetMinRaw, budgetMaxRaw, experienceLevel, locationType, jobStatus);
        return jobDao.update(job);
    }

    public boolean deleteJob(long jobId, long clientId) throws SQLException {
        return jobDao.delete(jobId, clientId);
    }

    public List<Job> getJobsByClient(long clientId) throws SQLException {
        return jobDao.findByClientId(clientId);
    }

    public Optional<Job> getJobForClient(long jobId, long clientId) throws SQLException {
        return jobDao.findByIdAndClientId(jobId, clientId);
    }

    private Job buildJob(long clientId, long jobId, String title, String description, String budgetMinRaw, String budgetMaxRaw,
                         String experienceLevel, String locationType, String jobStatus) {
        if (isBlank(title) || isBlank(description)) {
            throw new IllegalArgumentException("Job title and description are required.");
        }
        if (isBlank(experienceLevel) || isBlank(locationType) || isBlank(jobStatus)) {
            throw new IllegalArgumentException("Experience level, location type, and status are required.");
        }

        BigDecimal budgetMin;
        BigDecimal budgetMax;
        try {
            budgetMin = new BigDecimal(budgetMinRaw);
            budgetMax = new BigDecimal(budgetMaxRaw);
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Budget values must be valid numbers.");
        }

        if (budgetMin.compareTo(BigDecimal.ZERO) < 0 || budgetMax.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException("Budget values cannot be negative.");
        }
        if (budgetMax.compareTo(budgetMin) < 0) {
            throw new IllegalArgumentException("Maximum budget must be greater than or equal to minimum budget.");
        }

        Job job = new Job();
        job.setJobId(jobId);
        job.setClientId(clientId);
        job.setJobTitle(title.trim());
        job.setJobDescription(description.trim());
        job.setBudgetMin(budgetMin);
        job.setBudgetMax(budgetMax);
        job.setExperienceLevel(experienceLevel);
        job.setLocationType(locationType);
        job.setJobStatus(jobStatus);
        return job;
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
