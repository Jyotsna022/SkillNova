package com.skillnova.controller;

import com.skillnova.model.Job;
import com.skillnova.model.ApplicationRecord;
import com.skillnova.service.JobService;
import com.skillnova.dao.ApplicationDao;
import com.skillnova.dao.UserDao;
import com.skillnova.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "clientJobsServlet", urlPatterns = "/client/jobs")
public class ClientJobsServlet extends HttpServlet {

    private final JobService jobService = new JobService();
    private final ApplicationDao applicationDao = new ApplicationDao();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long clientId = getSessionUserId(req);
        String action = req.getParameter("action");
        req.setAttribute("search", req.getParameter("search") == null ? "" : req.getParameter("search"));

        req.setAttribute("searchKeyword", req.getParameter("searchKeyword") == null ? "" : req.getParameter("searchKeyword"));
        req.setAttribute("minYearsExperience", req.getParameter("minYearsExperience") == null ? "" : req.getParameter("minYearsExperience"));

        if ("edit".equalsIgnoreCase(action)) {
            String jobIdRaw = req.getParameter("jobId");
            if (jobIdRaw != null) {
                try {
                    long jobId = Long.parseLong(jobIdRaw);
                    Optional<Job> job = jobService.getJobForClient(jobId, clientId);
                    job.ifPresent(value -> req.setAttribute("editJob", value));
                } catch (NumberFormatException ignored) {
                    req.setAttribute("error", "Invalid job id for edit.");
                } catch (SQLException e) {
                    throw new ServletException("Unable to fetch job for edit.", e);
                }
            }
        }

        loadJobsAndForward(req, resp, clientId);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long clientId = getSessionUserId(req);
        String action = req.getParameter("action");

        try {
            if ("updateApplicationStatus".equalsIgnoreCase(action)) {
                long applicationId = Long.parseLong(req.getParameter("applicationId"));
                String newStatus = req.getParameter("newStatus");
                if (!"SHORTLISTED".equalsIgnoreCase(newStatus) && !"REJECTED".equalsIgnoreCase(newStatus)
                        && !"HIRED".equalsIgnoreCase(newStatus)) {
                    req.setAttribute("error", "Unsupported application status update.");
                    loadJobsAndForward(req, resp, clientId);
                    return;
                }
                boolean updated = applicationDao.updateApplicationStatusForClient(applicationId, clientId, newStatus.toUpperCase());
                req.getSession().setAttribute("flashSuccess", updated ? "Application status updated." : "Could not update application status.");
                resp.sendRedirect(req.getContextPath() + "/client/jobs");
                return;
            }

            if ("addFreelancerReview".equalsIgnoreCase(action)) {
                long jobId = Long.parseLong(req.getParameter("jobId"));
                long revieweeUserId = Long.parseLong(req.getParameter("revieweeUserId"));
                int rating = Integer.parseInt(req.getParameter("rating"));
                boolean reviewed = applicationDao.addReview(
                        jobId,
                        clientId,
                        revieweeUserId,
                        rating,
                        req.getParameter("comment")
                );
                req.getSession().setAttribute("flashSuccess", reviewed ? "Freelancer review saved." : "Could not save review.");
                resp.sendRedirect(req.getContextPath() + "/client/jobs");
                return;
            }

            if ("create".equalsIgnoreCase(action)) {
                jobService.createJob(
                        clientId,
                        req.getParameter("jobTitle"),
                        req.getParameter("jobDescription"),
                        req.getParameter("budgetMin"),
                        req.getParameter("budgetMax"),
                        req.getParameter("experienceLevel"),
                        req.getParameter("locationType")
                );
                req.getSession().setAttribute("flashSuccess", "Job posted successfully.");
                resp.sendRedirect(req.getContextPath() + "/client/jobs");
                return;
            }

            if ("update".equalsIgnoreCase(action)) {
                long jobId = Long.parseLong(req.getParameter("jobId"));
                boolean updated = jobService.updateJob(
                        jobId,
                        clientId,
                        req.getParameter("jobTitle"),
                        req.getParameter("jobDescription"),
                        req.getParameter("budgetMin"),
                        req.getParameter("budgetMax"),
                        req.getParameter("experienceLevel"),
                        req.getParameter("locationType"),
                        req.getParameter("jobStatus")
                );
                req.getSession().setAttribute("flashSuccess", updated ? "Job updated successfully." : "Job update failed.");
                resp.sendRedirect(req.getContextPath() + "/client/jobs");
                return;
            }

            if ("delete".equalsIgnoreCase(action)) {
                long jobId = Long.parseLong(req.getParameter("jobId"));
                boolean deleted = jobService.deleteJob(jobId, clientId);
                req.getSession().setAttribute("flashSuccess", deleted ? "Job deleted successfully." : "Job delete failed.");
                resp.sendRedirect(req.getContextPath() + "/client/jobs");
                return;
            }

            req.setAttribute("error", "Unsupported action.");
            loadJobsAndForward(req, resp, clientId);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Invalid numeric value in request.");
            loadJobsAndForward(req, resp, clientId);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            loadJobsAndForward(req, resp, clientId);
        } catch (SQLException e) {
            throw new ServletException("Unable to process client job action.", e);
        }
    }

    private void loadJobsAndForward(HttpServletRequest req, HttpServletResponse resp, long clientId) throws ServletException, IOException {
        try {
            List<Job> jobs = jobService.getJobsByClient(clientId);
            String search = req.getParameter("search");
            if (search != null && !search.trim().isEmpty()) {
                String q = search.trim().toLowerCase();
                jobs = jobs.stream().filter(job ->
                        contains(job.getJobTitle(), q)
                                || contains(job.getJobDescription(), q)
                                || contains(job.getExperienceLevel(), q)
                                || contains(job.getLocationType(), q)
                                || contains(job.getJobStatus(), q)
                ).toList();
            }
            req.setAttribute("jobs", jobs);

            String selectedJobIdRaw = req.getParameter("selectedJobId");
            if (selectedJobIdRaw != null && !selectedJobIdRaw.isBlank()) {
                try {
                    long selectedJobId = Long.parseLong(selectedJobIdRaw);
                    req.setAttribute("selectedJobId", selectedJobIdRaw);
                    List<ApplicationRecord> selectedJobApplications = applicationDao.findByJobForClient(selectedJobId, clientId);
                    req.setAttribute("selectedJobApplications", selectedJobApplications);
                } catch (NumberFormatException ignored) {
                    req.setAttribute("error", "Invalid selected job id.");
                }
            }

            List<java.util.Map<String, String>> freelancers = userDao.searchFreelancerProfiles(
                    req.getParameter("searchKeyword"),
                    req.getParameter("minYearsExperience")
            );
            req.setAttribute("freelancers", freelancers);

            Object flash = req.getSession().getAttribute("flashSuccess");
            if (flash != null) {
                req.setAttribute("success", flash.toString());
                req.getSession().removeAttribute("flashSuccess");
            }
            req.getRequestDispatcher("/WEB-INF/views/client/jobs.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Unable to load client jobs.", e);
        }
    }

    private long getSessionUserId(HttpServletRequest req) {
        Long userId = SessionUtil.getUserId(req.getSession(false));
        if (userId == null) {
            throw new IllegalStateException("Session user id is missing.");
        }
        return userId;
    }

    private boolean contains(String source, String q) {
        return source != null && source.toLowerCase().contains(q);
    }
}
