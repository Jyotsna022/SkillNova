package com.skillnova.controller;

import com.skillnova.model.Job;
import com.skillnova.service.JobService;
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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long clientId = getSessionUserId(req);
        String action = req.getParameter("action");

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
            req.setAttribute("jobs", jobs);

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
}
