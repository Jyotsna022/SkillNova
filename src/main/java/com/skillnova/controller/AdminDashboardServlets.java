// package com.skillnova.controller;

// import com.skillnova.model.AdminStats;
// import com.skillnova.model.ApplicationRecord;
// import com.skillnova.model.Job;
// import com.skillnova.model.SystemControlOverview;
// import com.skillnova.model.User;
// import com.skillnova.service.AdminService;
// import jakarta.servlet.ServletException;
// import jakarta.servlet.annotation.WebServlet;
// import jakarta.servlet.http.HttpServlet;
// import jakarta.servlet.http.HttpServletRequest;
// import jakarta.servlet.http.HttpServletResponse;

// import java.io.IOException;
// import java.sql.SQLException;
// import java.util.List;
// import java.util.Locale;

// @WebServlet(name = "adminDashboardServlet", urlPatterns = "/admin/dashboard")
// public class AdminDashboardServlet extends HttpServlet {

//     private final AdminService adminService = new AdminService();

//     @Override
//     protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//         loadDashboard(req);
//         req.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(req, resp);
//     }

//     @Override
//     protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//         String action = req.getParameter("action");
//         String userIdRaw = req.getParameter("userId");
//         String jobIdRaw = req.getParameter("jobId");

//         if (action == null) {
//             req.setAttribute("error", "Invalid request action.");
//             doGet(req, resp);
//             return;
//         }

//         try {
//             boolean updated = false;
//             if ("approve".equalsIgnoreCase(action) || "reject".equalsIgnoreCase(action)
//                     || "suspendUser".equalsIgnoreCase(action) || "activateUser".equalsIgnoreCase(action)
//                     || "deleteUser".equalsIgnoreCase(action)) {
//                 if (userIdRaw == null) {
//                     req.setAttribute("error", "User id is required for this action.");
//                     doGet(req, resp);
//                     return;
//                 }
//                 long userId = Long.parseLong(userIdRaw);
//                 if ("approve".equalsIgnoreCase(action)) {
//                     updated = adminService.approveUser(userId);
//                 } else if ("reject".equalsIgnoreCase(action)) {
//                     updated = adminService.rejectUser(userId);
//                 } else if ("suspendUser".equalsIgnoreCase(action)) {
//                     updated = adminService.suspendUser(userId);
//                 } else if ("activateUser".equalsIgnoreCase(action)) {
//                     updated = adminService.activateUser(userId);
//                 } else if ("deleteUser".equalsIgnoreCase(action)) {
//                     updated = adminService.deleteUser(userId);
//                 }
//             } else if ("closeJob".equalsIgnoreCase(action) || "cancelJob".equalsIgnoreCase(action)) {
//                 if (jobIdRaw == null) {
//                     req.setAttribute("error", "Job id is required for this action.");
//                     doGet(req, resp);
//                     return;
//                 }
//                 long jobId = Long.parseLong(jobIdRaw);
//                 if ("closeJob".equalsIgnoreCase(action)) {
//                     updated = adminService.closeJob(jobId);
//                 } else {
//                     updated = adminService.cancelJob(jobId);
//                 }
//             } else {
//                 req.setAttribute("error", "Unsupported admin action.");
//                 doGet(req, resp);
//                 return;
//             }

//             if (updated) {
//                 req.getSession().setAttribute("flashSuccess", "Action completed successfully.");
//             } else {
//                 req.getSession().setAttribute("flashError", "Could not complete the requested action.");
//             }
//             resp.sendRedirect(req.getContextPath() + "/admin/dashboard");
//         } catch (NumberFormatException e) {
//             req.setAttribute("error", "Invalid numeric id.");
//             doGet(req, resp);
//         } catch (SQLException e) {
//             throw new ServletException("Unable to process admin action.", e);
//         }
//     }

//     private void loadDashboard(HttpServletRequest req) throws ServletException {
//         List<User> pendingUsers;
//         List<User> allUsers;
//         List<ApplicationRecord> applications;
//         List<Job> jobs;
//         AdminStats stats;
//         SystemControlOverview systemControl;

//         try {
//             pendingUsers = adminService.getPendingUsers();
//         } catch (SQLException e) {
//             pendingUsers = List.of();
//             req.setAttribute("error", "Could not load pending users. Please verify users table in database.");
//         }

//         try {
//             allUsers = adminService.getAllUsers();
//         } catch (SQLException e) {
//             allUsers = List.of();
//             req.setAttribute("error", "Could not load users list.");
//         }

//         try {
//             applications = adminService.getAllApplications();
//         } catch (SQLException e) {
//             applications = List.of();
//             req.setAttribute("error", "Could not load applications. Please verify jobs/applications tables.");
//         }

//         try {
//             stats = adminService.getStats();
//         } catch (SQLException e) {
//             stats = new AdminStats();
//             req.setAttribute("error", "Could not load analytics stats. Please verify database schema.");
//         }

//         try {
//             jobs = adminService.getAllJobs();
//         } catch (SQLException e) {
//             jobs = List.of();
//             req.setAttribute("error", "Could not load jobs for monitoring.");
//         }

//         try {
//             systemControl = adminService.getSystemControlOverview();
//         } catch (SQLException e) {
//             systemControl = new SystemControlOverview();
//             systemControl.setPermissions(List.of());
//             req.setAttribute("error", "Could not load system control overview.");
//         }

//         req.setAttribute("pendingUsers", pendingUsers);
//         req.setAttribute("allUsers", allUsers);
//         req.setAttribute("pendingCount", pendingUsers.size());
//         req.setAttribute("applications", applications);
//         req.setAttribute("jobs", jobs);
//         req.setAttribute("totalUsers", stats.getTotalUsers());
//         req.setAttribute("totalJobs", stats.getTotalJobs());
//         req.setAttribute("totalApplications", stats.getTotalApplications());
//         req.setAttribute("systemControl", systemControl);

//         String q = req.getParameter("q");
//         if (q != null && !q.trim().isEmpty()) {
//             String query = q.trim().toLowerCase(Locale.ROOT);
//             pendingUsers = pendingUsers.stream().filter(u -> containsUser(u, query)).toList();
//             allUsers = allUsers.stream().filter(u -> containsUser(u, query)).toList();
//             applications = applications.stream().filter(a -> containsApplication(a, query)).toList();
//             jobs = jobs.stream().filter(j -> containsJob(j, query)).toList();

//             req.setAttribute("pendingUsers", pendingUsers);
//             req.setAttribute("allUsers", allUsers);
//             req.setAttribute("applications", applications);
//             req.setAttribute("jobs", jobs);
//             req.setAttribute("pendingCount", pendingUsers.size());
//             req.setAttribute("adminQuery", q);
//         }

//         Object flashSuccess = req.getSession().getAttribute("flashSuccess");
//         Object flashError = req.getSession().getAttribute("flashError");
//         if (flashSuccess != null) {
//             req.setAttribute("success", flashSuccess.toString());
//             req.getSession().removeAttribute("flashSuccess");
//         }
//         if (flashError != null) {
//             req.setAttribute("error", flashError.toString());
//             req.getSession().removeAttribute("flashError");
//         }
//     }

//     private boolean containsUser(User user, String q) {
//         return contains(user.getFullName(), q) || contains(user.getEmail(), q) || contains(user.getPhone(), q)
//                 || (user.getRole() != null && contains(user.getRole().name(), q));
//     }

//     private boolean containsApplication(ApplicationRecord app, String q) {
//         return contains(app.getJobTitle(), q) || contains(app.getFreelancerName(), q)
//                 || contains(app.getFreelancerEmail(), q) || contains(app.getClientName(), q)
//                 || contains(app.getApplicationStatus(), q);
//     }

//     private boolean containsJob(Job job, String q) {
//         return contains(job.getJobTitle(), q) || contains(job.getExperienceLevel(), q)
//                 || contains(job.getLocationType(), q) || contains(job.getJobStatus(), q)
//                 || contains(String.valueOf(job.getClientId()), q);
//     }

//     private boolean contains(String source, String q) {
//         return source != null && source.toLowerCase(Locale.ROOT).contains(q);
//     }
// }
