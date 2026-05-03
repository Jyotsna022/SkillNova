<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillnova.model.ApplicationRecord" %>
<%@ page import="com.skillnova.model.Job" %>
<%@ page import="com.skillnova.model.RolePermission" %>
<%@ page import="com.skillnova.model.SystemControlOverview" %>
<%@ page import="com.skillnova.model.User" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Spectral:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --red-900: #671018;
            --red-700: #991b1b;
            --red-600: #b91c1c;
            --red-100: #fee2e2;
            --ink: #291b1b;
            --muted: #795757;
            --border: #f0c8c8;
            --white: #ffffff;
            --ok-bg: #dcfce7;
            --ok-fg: #166534;
            --err-bg: #fee2e2;
            --err-fg: #9b1c1c;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Manrope", sans-serif;
            background: radial-gradient(circle at 88% 10%, #ffe8e8 0, transparent 30%), linear-gradient(150deg, #fffafa 0%, #fff2f2 100%);
            color: var(--ink);
        }

        .topbar {
            height: 64px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 18px;
            border-bottom: 1px solid var(--border);
            background: rgba(255,255,255,0.86);
            backdrop-filter: blur(8px);
            position: sticky;
            top: 0;
        }

        .brand {
            font-family: "Spectral", serif;
            font-size: 1.35rem;
            font-weight: 700;
        }

        .brand span { color: var(--red-600); }

        .logout {
            text-decoration: none;
            font-size: 0.9rem;
            border: 1px solid #ecbdbd;
            color: var(--red-700);
            border-radius: 10px;
            padding: 8px 12px;
            font-weight: 700;
            background: #fff8f8;
        }

        .layout {
            max-width: 1160px;
            margin: 18px auto;
            padding: 0 14px;
        }

        .hero {
            background: linear-gradient(130deg, #7f1118 0%, #a71d24 52%, #cb2e35 100%);
            color: #ffe9e9;
            border-radius: 16px;
            padding: 22px;
            margin-bottom: 14px;
        }

        .hero h1 {
            font-family: "Spectral", serif;
            font-size: 1.9rem;
            margin-bottom: 6px;
        }

        .hero p { color: #ffd6d6; }

        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 12px;
            margin-bottom: 14px;
        }

        .card {
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 14px;
            background: var(--white);
            box-shadow: 0 8px 16px rgba(127, 29, 29, 0.06);
        }

        .card .label { color: var(--muted); font-size: 0.84rem; margin-bottom: 4px; }
        .card .value { color: var(--red-700); font-size: 1.5rem; font-weight: 800; }

        .alert {
            margin-bottom: 12px;
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 0.9rem;
        }

        .alert.success { background: var(--ok-bg); color: var(--ok-fg); border: 1px solid #bbf7d0; }
        .alert.error { background: var(--err-bg); color: var(--err-fg); border: 1px solid #fecaca; }

        .panel {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
            margin-bottom: 14px;
        }

        .panel-head {
            padding: 14px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 8px;
            color: #651018;
            font-weight: 800;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            text-align: left;
            padding: 12px;
            border-bottom: 1px solid #f6dede;
            font-size: 0.9rem;
            vertical-align: middle;
        }

        th {
            background: #fff5f5;
            color: #6c2323;
            font-weight: 800;
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .role-chip {
            display: inline-flex;
            padding: 4px 8px;
            border-radius: 999px;
            background: #fff1f1;
            border: 1px solid #f5cccc;
            color: #8d2323;
            font-size: 0.75rem;
            font-weight: 700;
        }

        .actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .btn {
            border: 0;
            border-radius: 8px;
            padding: 7px 10px;
            font-size: 0.8rem;
            font-weight: 800;
            cursor: pointer;
        }

        .btn-approve {
            color: #fff;
            background: linear-gradient(130deg, #15803d, #16a34a);
        }

        .btn-reject {
            color: #fff;
            background: linear-gradient(130deg, #b91c1c, #dc2626);
        }

        .empty {
            padding: 28px;
            text-align: center;
            color: var(--muted);
        }

        .pill {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            border-radius: 999px;
            border: 1px solid #f3cbcb;
            background: #fff4f4;
            padding: 4px 9px;
            color: #7b1f1f;
            font-size: 0.76rem;
            font-weight: 700;
        }

        .muted-info {
            margin-top: 10px;
            color: var(--muted);
            font-size: 0.85rem;
        }

        @media (max-width: 780px) {
            .user-table th:nth-child(3), .user-table td:nth-child(3), .user-table th:nth-child(4), .user-table td:nth-child(4) {
                display: none;
            }

            .job-table th:nth-child(4), .job-table td:nth-child(4), .job-table th:nth-child(5), .job-table td:nth-child(5) {
                display: none;
            }
        }
    </style>
</head>
<body>
<header class="topbar">
    <div class="brand"><span>Skill</span>Nova Admin</div>
    <a class="logout" href="${pageContext.request.contextPath}/logout">Logout</a>
</header>

<main class="layout">
    <section class="hero">
        <h1>Registration Moderation Center</h1>
        <p>Review pending client/freelancer accounts and approve or reject each request.</p>
    </section>

    <section class="cards">
        <article class="card">
            <div class="label">Pending registrations</div>
            <div class="value">${pendingCount}</div>
        </article>
        <article class="card">
            <div class="label">Total users</div>
            <div class="value">${totalUsers}</div>
        </article>
        <article class="card">
            <div class="label">Total jobs posted</div>
            <div class="value">${totalJobs}</div>
        </article>
        <article class="card">
            <div class="label">Total applications</div>
            <div class="value">${totalApplications}</div>
        </article>
    </section>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert success"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert error"><%= request.getAttribute("error") %></div>
    <% } %>

    <section class="panel">
        <div class="panel-head">
            <span class="material-symbols-rounded">pending_actions</span>
            Pending User Requests
        </div>

        <%
            List<User> users = (List<User>) request.getAttribute("pendingUsers");
            if (users == null || users.isEmpty()) {
        %>
            <div class="empty">No pending users right now. Great job keeping approvals up to date.</div>
        <% } else { %>
            <table class="user-table">
                <thead>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (User user : users) { %>
                    <tr>
                        <td><%= user.getFullName() %></td>
                        <td><%= user.getEmail() %></td>
                        <td><%= user.getPhone() %></td>
                        <td><span class="role-chip"><%= user.getRole().name() %></span></td>
                        <td>
                            <div class="actions">
                                <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>" />
                                    <input type="hidden" name="action" value="approve" />
                                    <button class="btn btn-approve" type="submit">Approve</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>" />
                                    <input type="hidden" name="action" value="reject" />
                                    <button class="btn btn-reject" type="submit">Reject</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>" />
                                    <input type="hidden" name="action" value="suspendUser" />
                                    <button class="btn btn-reject" type="submit">Suspend</button>
                                </form>
                                <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>" />
                                    <input type="hidden" name="action" value="activateUser" />
                                    <button class="btn btn-approve" type="submit">Activate</button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </section>

    <section class="panel">
        <div class="panel-head">
            <span class="material-symbols-rounded">groups</span>
            User Management
        </div>
        <%
            List<User> allUsers = (List<User>) request.getAttribute("allUsers");
            if (allUsers == null || allUsers.isEmpty()) {
        %>
        <div class="empty">No users found.</div>
        <% } else { %>
        <table class="user-table">
            <thead>
            <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (User user : allUsers) { %>
            <tr>
                <td><%= user.getFullName() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getPhone() %></td>
                <td><span class="role-chip"><%= user.getRole().name() %></span></td>
                <td><span class="pill"><%= user.getAccountStatus() %></span></td>
                <td>
                    <div class="actions">
                        <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                            <input type="hidden" name="userId" value="<%= user.getUserId() %>" />
                            <input type="hidden" name="action" value="activateUser" />
                            <button class="btn btn-approve" type="submit">Activate</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                            <input type="hidden" name="userId" value="<%= user.getUserId() %>" />
                            <input type="hidden" name="action" value="suspendUser" />
                            <button class="btn btn-reject" type="submit">Suspend</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                            <input type="hidden" name="userId" value="<%= user.getUserId() %>" />
                            <input type="hidden" name="action" value="deleteUser" />
                            <button class="btn btn-reject" type="submit" onclick="return confirm('Delete this user?');">Delete</button>
                        </form>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </section>

    <section class="panel">
        <div class="panel-head">
            <span class="material-symbols-rounded">monitoring</span>
            Application Monitoring
        </div>
        <%
            List<ApplicationRecord> applications = (List<ApplicationRecord>) request.getAttribute("applications");
            if (applications == null || applications.isEmpty()) {
        %>
        <div class="empty">No applications found yet. Once freelancers apply, they will appear here.</div>
        <% } else { %>
        <table>
            <thead>
            <tr>
                <th>Job</th>
                <th>Freelancer</th>
                <th>Client</th>
                <th>Status</th>
                <th>Applied At</th>
            </tr>
            </thead>
            <tbody>
            <% for (ApplicationRecord appRecord : applications) { %>
                <tr>
                    <td><%= appRecord.getJobTitle() %></td>
                    <td>
                        <strong><%= appRecord.getFreelancerName() %></strong><br/>
                        <small><%= appRecord.getFreelancerEmail() %></small>
                    </td>
                    <td><%= appRecord.getClientName() %></td>
                    <td><span class="pill"><%= appRecord.getApplicationStatus() %></span></td>
                    <td><%= appRecord.getAppliedAt() %></td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </section>

    <section class="panel">
        <div class="panel-head">
            <span class="material-symbols-rounded">work_history</span>
            Job Monitoring
        </div>
        <%
            List<Job> jobs = (List<Job>) request.getAttribute("jobs");
            if (jobs == null || jobs.isEmpty()) {
        %>
        <div class="empty">No jobs found yet. Once clients post jobs, monitoring entries will appear here.</div>
        <% } else { %>
        <table class="job-table">
            <thead>
            <tr>
                <th>Title</th>
                <th>Client Id</th>
                <th>Budget</th>
                <th>Experience</th>
                <th>Location</th>
                <th>Status</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (Job job : jobs) { %>
            <tr>
                <td><%= job.getJobTitle() %></td>
                <td><%= job.getClientId() %></td>
                <td><%= job.getBudgetMin() %> - <%= job.getBudgetMax() %></td>
                <td><%= job.getExperienceLevel() %></td>
                <td><%= job.getLocationType() %></td>
                <td><span class="pill"><%= job.getJobStatus() %></span></td>
                <td>
                    <div class="actions">
                        <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>" />
                            <input type="hidden" name="action" value="closeJob" />
                            <button class="btn btn-approve" type="submit">Close</button>
                        </form>
                        <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>" />
                            <input type="hidden" name="action" value="cancelJob" />
                            <button class="btn btn-reject" type="submit">Cancel</button>
                        </form>
                    </div>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } %>
    </section>

    <section class="panel">
        <div class="panel-head">
            <span class="material-symbols-rounded">admin_panel_settings</span>
            System Control
        </div>
        <div style="padding: 16px; color: var(--muted); line-height: 1.7;">
            <%
                SystemControlOverview systemControl = (SystemControlOverview) request.getAttribute("systemControl");
                List<RolePermission> permissions = systemControl == null ? null : systemControl.getPermissions();
            %>
            <div><strong>Active Users:</strong> <%= systemControl == null ? 0 : systemControl.getActiveUsers() %></div>
            <div><strong>Suspended Users:</strong> <%= systemControl == null ? 0 : systemControl.getSuspendedUsers() %></div>
            <div><strong>Rejected Users:</strong> <%= systemControl == null ? 0 : systemControl.getRejectedUsers() %></div>
            <div class="muted-info">Role and permission controls currently enforced in filter and admin actions:</div>
            <% if (permissions == null || permissions.isEmpty()) { %>
                <div class="muted-info">No permission mapping available.</div>
            <% } else { %>
                <table style="margin-top: 10px;">
                    <thead>
                    <tr>
                        <th>Code</th>
                        <th>Description</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (RolePermission permission : permissions) { %>
                        <tr>
                            <td><span class="pill"><%= permission.getPermissionCode() %></span></td>
                            <td><%= permission.getDescription() %></td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>
    </section>
</main>
</body>
</html>
