package com.skillnova.model;

import java.util.List;
import java.util.Map;

public class UserDashboardData {
    private String role;
    private String fullName;
    private int primaryCount;
    private int secondaryCount;
    private int tertiaryCount;
    private List<Job> jobs;
    private List<ApplicationRecord> applications;
    private Map<String, String> freelancerProfile;
    private double ratingAverage;

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public int getPrimaryCount() {
        return primaryCount;
    }

    public void setPrimaryCount(int primaryCount) {
        this.primaryCount = primaryCount;
    }

    public int getSecondaryCount() {
        return secondaryCount;
    }

    public void setSecondaryCount(int secondaryCount) {
        this.secondaryCount = secondaryCount;
    }

    public int getTertiaryCount() {
        return tertiaryCount;
    }

    public void setTertiaryCount(int tertiaryCount) {
        this.tertiaryCount = tertiaryCount;
    }

    public List<Job> getJobs() {
        return jobs;
    }

    public void setJobs(List<Job> jobs) {
        this.jobs = jobs;
    }

    public List<ApplicationRecord> getApplications() {
        return applications;
    }

    public void setApplications(List<ApplicationRecord> applications) {
        this.applications = applications;
    }

    public Map<String, String> getFreelancerProfile() {
        return freelancerProfile;
    }

    public void setFreelancerProfile(Map<String, String> freelancerProfile) {
        this.freelancerProfile = freelancerProfile;
    }

    public double getRatingAverage() {
        return ratingAverage;
    }

    public void setRatingAverage(double ratingAverage) {
        this.ratingAverage = ratingAverage;
    }
}
