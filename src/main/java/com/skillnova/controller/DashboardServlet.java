package com.skillnova.controller;

import com.skillnova.dao.ApplicationDao;
import com.skillnova.dao.JobDao;
import com.skillnova.dao.UserDao;
import com.skillnova.model.ApplicationRecord;
import com.skillnova.model.Job;
import com.skillnova.model.UserDashboardData;
import com.skillnova.service.UserDashboardService;
import com.skillnova.util.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Locale;
import java.util.List;
import java.util.Map;

@WebServlet(name = "dashboardServlet", urlPatterns = {
        "/client/dashboard", "/freelancer/dashboard",
        "/freelancer/jobs", "/freelancer/profile", "/freelancer/applications"
})
public class DashboardServlet extends HttpServlet {

    private final UserDashboardService userDashboardService = new UserDashboardService();
    private final ApplicationDao applicationDao = new ApplicationDao();
    private final JobDao jobDao = new JobDao();
    private final UserDao userDao = new UserDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String fullName = session == null ? "User" : (String) session.getAttribute(SessionUtil.FULL_NAME);
        String role = SessionUtil.getRole(session);
        Long userId = SessionUtil.getUserId(session);
        String search = req.getParameter("search");

        if (role == null || userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("fullName", fullName);
        bindFlash(req);

        String path = req.getServletPath();

        try {
            if ("/client/dashboard".equals(path) && "CLIENT".equals(role)) {
                UserDashboardData data = userDashboardService.buildForClient(userId, fullName);
                if (search != null && !search.trim().isEmpty()) {
                    String q = search.trim().toLowerCase(Locale.ROOT);
                    data.setJobs(data.getJobs().stream().filter(j -> contains(j.getJobTitle(), q) || contains(j.getJobDescription(), q)).toList());
                    data.setApplications(data.getApplications().stream().filter(a -> contains(a.getJobTitle(), q) || contains(a.getFreelancerName(), q)).toList());
                    req.setAttribute("search", search);
                }
                req.setAttribute("postedJobs", data.getPrimaryCount());
                req.setAttribute("receivedApplications", data.getSecondaryCount());
                req.setAttribute("openJobs", data.getTertiaryCount());
                req.setAttribute("recentJobs", data.getJobs());
                req.setAttribute("recentApplications", data.getApplications());
                req.setAttribute("latestJobId", data.getJobs().isEmpty() ? "" : data.getJobs().get(0).getJobId());
                req.getRequestDispatcher("/WEB-INF/views/client/dashboard.jsp").forward(req, resp);
                return;
            }

            if ("/freelancer/dashboard".equals(path) && "FREELANCER".equals(role)) {
                UserDashboardData data = userDashboardService.buildForFreelancer(userId, fullName, null, null, null);
                if (search != null && !search.trim().isEmpty()) {
                    String q = search.trim().toLowerCase(Locale.ROOT);
                    data.setJobs(data.getJobs().stream().filter(j -> contains(j.getJobTitle(), q) || contains(j.getJobDescription(), q)).toList());
                    data.setApplications(data.getApplications().stream().filter(a -> contains(a.getJobTitle(), q) || contains(a.getClientName(), q)).toList());
                    req.setAttribute("search", search);
                }
                req.setAttribute("openJobs", data.getPrimaryCount());
                req.setAttribute("myApplications", data.getSecondaryCount());
                req.setAttribute("shortlisted", data.getTertiaryCount());
                req.setAttribute("ratingAverage", String.format("%.2f", data.getRatingAverage()));
                req.setAttribute("recentApplications", data.getApplications());
                req.setAttribute("recommendedJobs", data.getJobs());
                req.setAttribute("profile", data.getFreelancerProfile());
                int upcomingInterviews = applicationDao.countByFreelancerIdAndStatus(userId, "INTERVIEWING");
                req.setAttribute("upcomingInterviewsCount", upcomingInterviews);
                req.setAttribute("newNotifications", Math.max(0, data.getTertiaryCount()));
                req.setAttribute("profileStrength", calculateProfileStrength(data.getFreelancerProfile()));
                req.getRequestDispatcher("/WEB-INF/views/freelancer/dashboard.jsp").forward(req, resp);
                return;
            }

            if ("/freelancer/jobs".equals(path) && "FREELANCER".equals(role)) {
                List<Job> jobs = jobDao.searchOpenJobs(
                        req.getParameter("keyword"),
                        req.getParameter("experienceLevel"),
                        req.getParameter("locationType"),
                        30
                );
                req.setAttribute("jobs", jobs);
                req.setAttribute("keyword", req.getParameter("keyword") == null ? "" : req.getParameter("keyword"));
                req.setAttribute("search", req.getParameter("search") == null ? "" : req.getParameter("search"));
                req.getRequestDispatcher("/WEB-INF/views/freelancer/jobs.jsp").forward(req, resp);
                return;
            }

            if ("/freelancer/profile".equals(path) && "FREELANCER".equals(role)) {
                Map<String, String> profile = userDao.getFreelancerProfile(userId);
                req.setAttribute("profile", profile);
                req.getRequestDispatcher("/WEB-INF/views/freelancer/profile.jsp").forward(req, resp);
                return;
            }

            if ("/freelancer/applications".equals(path) && "FREELANCER".equals(role)) {
                List<ApplicationRecord> apps = applicationDao.findRecentForFreelancer(userId, 50);
                req.setAttribute("applications", apps);
                req.getRequestDispatcher("/WEB-INF/views/freelancer/applications.jsp").forward(req, resp);
                return;
            }

            resp.sendRedirect(req.getContextPath() + ("CLIENT".equals(role) ? "/client/dashboard" : "/freelancer/dashboard"));
        } catch (SQLException e) {
            throw new ServletException("Unable to load portal page.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        String role = SessionUtil.getRole(session);
        Long userId = SessionUtil.getUserId(session);
        if (role == null || userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");
        String path = req.getServletPath();

        try {
            if ("applyAsFreelancer".equalsIgnoreCase(action) && "FREELANCER".equals(role)) {
                long jobId = Long.parseLong(req.getParameter("jobId"));
                boolean applied = applicationDao.applyToJob(
                        userId,
                        jobId,
                        req.getParameter("coverLetter"),
                        req.getParameter("proposedBudget"),
                        req.getParameter("estimatedDays")
                );
                req.getSession().setAttribute("flashSuccess", applied ? "Applied successfully." : "Application exists or failed.");
                resp.sendRedirect(req.getContextPath() + "/freelancer/jobs");
                return;
            }

            if ("withdrawApplication".equalsIgnoreCase(action) && "FREELANCER".equals(role)) {
                long applicationId = Long.parseLong(req.getParameter("applicationId"));
                boolean withdrawn = applicationDao.withdrawApplication(applicationId, userId);
                req.getSession().setAttribute("flashSuccess", withdrawn ? "Application withdrawn." : "Could not withdraw application.");
                resp.sendRedirect(req.getContextPath() + "/freelancer/applications");
                return;
            }

            if ("updateFreelancerProfile".equalsIgnoreCase(action) && "FREELANCER".equals(role)) {
                boolean updated = userDao.updateFreelancerProfile(
                        userId,
                        req.getParameter("headline"),
                        req.getParameter("yearsExperience"),
                        req.getParameter("hourlyRate"),
                        req.getParameter("bio")
                );
                req.getSession().setAttribute("flashSuccess", updated ? "Profile updated successfully." : "Profile update failed.");
                resp.sendRedirect(req.getContextPath() + "/freelancer/profile");
                return;
            }

            if ("addClientReview".equalsIgnoreCase(action) && "FREELANCER".equals(role)) {
                long jobId = Long.parseLong(req.getParameter("jobId"));
                int rating = Integer.parseInt(req.getParameter("rating"));
                Long clientId = applicationDao.getClientIdByJobId(jobId);
                if (clientId != null) {
                    boolean reviewed = applicationDao.addReview(jobId, userId, clientId, rating, req.getParameter("comment"));
                    req.getSession().setAttribute("flashSuccess", reviewed ? "Client review submitted." : "Could not submit review.");
                }
                resp.sendRedirect(req.getContextPath() + "/freelancer/applications");
                return;
            }

            req.getSession().setAttribute("flashError", "Unsupported action.");
            resp.sendRedirect(req.getContextPath() + path);
        } catch (SQLException | NumberFormatException e) {
            throw new ServletException("Unable to process action.", e);
        }
    }

    private void bindFlash(HttpServletRequest req) {
        Object flashSuccess = req.getSession().getAttribute("flashSuccess");
        if (flashSuccess != null) {
            req.setAttribute("success", flashSuccess.toString());
            req.getSession().removeAttribute("flashSuccess");
        }
        Object flashError = req.getSession().getAttribute("flashError");
        if (flashError != null) {
            req.setAttribute("error", flashError.toString());
            req.getSession().removeAttribute("flashError");
        }
    }

    private int calculateProfileStrength(Map<String, String> profile) {
        if (profile == null || profile.isEmpty()) {
            return 35;
        }

        int score = 35;
        score += hasValue(profile.get("headline")) ? 20 : 0;
        score += hasValue(profile.get("yearsExperience")) ? 15 : 0;
        score += hasValue(profile.get("hourlyRate")) ? 15 : 0;
        score += hasValue(profile.get("bio")) ? 15 : 0;

        if (score > 100) {
            return 100;
        }
        return score;
    }

    private boolean hasValue(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private boolean contains(String source, String q) {
        return source != null && source.toLowerCase(Locale.ROOT).contains(q);
    }
}
