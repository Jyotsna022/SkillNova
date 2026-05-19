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
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Space+Grotesk:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --page-bg: #f2f4f8;
            --ink: #171d31;
            --muted: #5a637c;
            --border: #dbe1ec;
            --white: #ffffff;
            --blue-500: #3c8dff;
            --blue-700: #2b67cf;
            --ok-bg: #e9f9ef;
            --ok-fg: #1c7a46;
            --err-bg: #ffe8ec;
            --err-fg: #c4365a;
            --shadow-soft: 0 12px 30px rgba(22, 49, 95, 0.08);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Manrope", sans-serif;
            background: var(--page-bg);
            color: var(--ink);
        }

        .topbar {
            height: 88px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 24px;
            border-bottom: 1px solid var(--border);
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(10px);
            position: sticky;
            top: 0;
            z-index: 40;
        }

        .top-links {
            display: flex;
            align-items: center;
            gap: 24px;
            flex-wrap: wrap;
            margin: 0 auto;
        }

        .top-links a {
            text-decoration: none;
            color: #24304f;
            font-weight: 700;
            font-size: 0.9rem;
            transition: color .2s ease;
        }

        .top-links a:hover {
            color: #0a8575;
        }

        .brand {
            font-family: "Space Grotesk", sans-serif;
            font-size: 1.7rem;
            font-weight: 700;
            letter-spacing: 0.2px;
        }

        .brand span { color: var(--blue-500); }

        .top-links .logout {
            text-decoration: none;
            font-size: 0.92rem;
            border: 1px solid transparent;
            color: #fff;
            border-radius: 12px;
            padding: 10px 16px;
            font-weight: 700;
            background: linear-gradient(120deg, #2f3f6f, #1e2a4f);
        }

        .layout {
            max-width: 1400px;
            margin: 16px auto;
            padding: 0 18px;
        }

        .site-footer {
            margin-top: 16px;
            border-top: 1px solid var(--border);
            padding: 14px 0 4px;
            display: flex;
            justify-content: space-between;
            gap: 10px;
            flex-wrap: wrap;
            color: #65708a;
            font-size: 0.88rem;
        }

        .site-footer a {
            color: #51607f;
            text-decoration: none;
            margin-right: 10px;
        }

        .site-footer a:hover {
            color: #0a8575;
        }

        .hero {
            background: #fff;
            color: var(--ink);
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 20px;
            margin-bottom: 14px;
            box-shadow: var(--shadow-soft);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
        }

        .hero h1 {
            font-family: "Space Grotesk", sans-serif;
            font-size: 1.6rem;
            margin-bottom: 6px;
        }

        .hero p { color: var(--muted); }

        .admin-search {
            width: 320px;
            border: 1px solid var(--border);
            border-radius: 999px;
            background: #f6f8fd;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 0 12px;
            height: 42px;
            color: #6b7387;
        }

        .admin-search input {
            border: 0;
            background: transparent;
            outline: none;
            width: 100%;
            font: inherit;
            color: inherit;
        }

        .cards {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
            margin-bottom: 14px;
        }

        .card {
            border: 1px solid var(--border);
            border-radius: 14px;
            padding: 16px;
            background: var(--white);
            box-shadow: var(--shadow-soft);
        }

        .card .label { color: var(--muted); font-size: 0.76rem; margin-bottom: 4px; text-transform: uppercase; letter-spacing:.6px; font-weight:700; }
        .card .value { color: var(--ink); font-size: 1.75rem; font-weight: 800; }

        .alert {
            margin-bottom: 12px;
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 0.9rem;
        }

        .alert.success { background: var(--ok-bg); color: var(--ok-fg); border: 1px solid #bfead0; }
        .alert.error { background: var(--err-bg); color: var(--err-fg); border: 1px solid #ffc8d5; }

        .panel {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: 14px;
            overflow: hidden;
            margin-bottom: 14px;
            box-shadow: var(--shadow-soft);
        }

        .panel-head {
            padding: 14px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 8px;
            color: var(--blue-700);
            font-weight: 800;
            background: #fbfcff;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            text-align: left;
            padding: 12px;
            border-bottom: 1px solid #edf1fb;
            font-size: 0.9rem;
            vertical-align: middle;
        }

        th {
            background: #f7f9ff;
            color: #4e5488;
            font-weight: 800;
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .role-chip {
            display: inline-flex;
            padding: 4px 8px;
            border-radius: 999px;
            background: #eef4ff;
            border: 1px solid #d4e2ff;
            color: #325fb9;
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
            border-radius: 9px;
            padding: 7px 10px;
            font-size: 0.78rem;
            font-weight: 800;
            cursor: pointer;
            color: #fff;
        }

        .btn-approve { background: linear-gradient(130deg, #15965a, #1ab36c); }
        .btn-reject { background: linear-gradient(130deg, #e45d70, #be3857); }

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
            border: 1px solid #d8e5ff;
            background: #eef4ff;
            padding: 4px 9px;
            color: #335ea8;
            font-size: 0.76rem;
            font-weight: 700;
        }

        .muted-info {
            margin-top: 10px;
            color: var(--muted);
            font-size: 0.85rem;
        }

        @media (max-width: 780px) {
            .topbar { height: auto; padding: 12px; flex-wrap: wrap; gap: 10px; }
            .mobile-toggle { display: flex; }
            .top-links { display: none; }
            .top-links.open {
                display: flex; flex-direction: column; width: 100%;
                background: #f0f1f6; border-radius: 12px; padding: 4px 0; order: 10;
            }
            .top-links.open a { padding: 12px 16px; border-bottom: 1px solid #dfe2ea; }
            .top-links.open a:last-child { border-bottom: 0; }
            .cards { grid-template-columns: 1fr 1fr; }
            .hero { flex-direction: column; gap: 10px; }
            .admin-search { width: 100%; }
            .user-table th:nth-child(3), .user-table td:nth-child(3), .user-table th:nth-child(4), .user-table td:nth-child(4) {
                display: none;
            }
            .job-table th:nth-child(4), .job-table td:nth-child(4), .job-table th:nth-child(5), .job-table td:nth-child(5) {
                display: none;
            }
            table { display: block; overflow-x: auto; }
        }

        .mobile-toggle {
            display: none;
            align-items: center;
            justify-content: center;
            width: 44px; height: 44px;
            border: 1px solid #d8dbe4;
            border-radius: 12px;
            background: transparent;
            color: #242b40;
            cursor: pointer;
            font-family: inherit;
            font-size: 1.5rem;
        }

        @media (max-width: 480px) {
            .brand { font-size: 1.3rem; }
            .cards { grid-template-columns: 1fr; }
            .hero h1 { font-size: 1.3rem; }
            .layout { padding: 0 10px; }
            .footer-top { grid-template-columns: 1fr !important; }
        }
    </style>
</head>
<body>
<header class="topbar">
    <div class="brand"><span>Skill</span>Nova Admin</div>
    <button class="mobile-toggle" onclick="document.querySelector('.top-links').classList.toggle('open')" aria-label="Toggle menu">&#9776;</button>
    <div class="top-links">
        <a href="${pageContext.request.contextPath}/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        <a class="logout" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</header>

<main class="layout">
    <section class="hero">
        <div>
            <h1>Registration Moderation Center</h1>
            <p>Review pending client/freelancer accounts and approve or reject each request.</p>
        </div>
        <form class="admin-search" method="get" action="${pageContext.request.contextPath}/admin/dashboard">
            <span class="material-symbols-rounded">search</span>
            <input name="q" value="${adminQuery}" placeholder="Search users, jobs, applications" />
        </form>
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

    <footer class="footer" style="background:#f4f3f7; border-top:1px solid #dbdee8; padding:28px 0 14px; margin-top:12px;">
        <div class="footer-top" style="display:grid; grid-template-columns:1.2fr 1fr 1fr; gap:22px; padding-bottom:14px; border-bottom:1px solid #d6d9e4;">
            <div><div style="font:700 24px/1.2 'Space Grotesk',sans-serif; margin-bottom:8px; color:#11174a;">SkillNova</div><div style="color:#606a7f; line-height:1.55; max-width:360px; margin-bottom:10px; font-size:13px;">The premium marketplace for world-class freelance talent and elite global clients.</div></div>
            <div><h4 style="font-size:12px; color:#4d5567; margin-bottom:8px; text-transform:uppercase; letter-spacing:.6px;">Platform</h4><a onmouseover="this.style.color='#0a8575'" onmouseout="this.style.color='#5f697d'" style="display:block; text-decoration:none; color:#5f697d; margin-bottom:7px; font-size:13px;" href="${pageContext.request.contextPath}/about.jsp">About Us</a><a onmouseover="this.style.color='#0a8575'" onmouseout="this.style.color='#5f697d'" style="display:block; text-decoration:none; color:#5f697d; margin-bottom:7px; font-size:13px;" href="#">Safety</a><a onmouseover="this.style.color='#0a8575'" onmouseout="this.style.color='#5f697d'" style="display:block; text-decoration:none; color:#5f697d; margin-bottom:7px; font-size:13px;" href="#">Help Center</a><a onmouseover="this.style.color='#0a8575'" onmouseout="this.style.color='#5f697d'" style="display:block; text-decoration:none; color:#5f697d; margin-bottom:7px; font-size:13px;" href="${pageContext.request.contextPath}/contact.jsp">Contact</a></div>
            <div><h4 style="font-size:12px; color:#4d5567; margin-bottom:8px; text-transform:uppercase; letter-spacing:.6px;">Legal</h4><a onmouseover="this.style.color='#0a8575'" onmouseout="this.style.color='#5f697d'" style="display:block; text-decoration:none; color:#5f697d; margin-bottom:7px; font-size:13px;" href="#">Terms of Service</a><a onmouseover="this.style.color='#0a8575'" onmouseout="this.style.color='#5f697d'" style="display:block; text-decoration:none; color:#5f697d; margin-bottom:7px; font-size:13px;" href="#">Privacy Policy</a></div>
        </div>
        <div style="margin-top:10px; display:flex; justify-content:space-between; color:#697286; font-size:12px; gap:10px; flex-wrap:wrap;"><div>&copy; 2024 SkillNova. All rights reserved.</div><div><span>English (US)</span> · <span>NPR</span></div></div>
    </footer>
</main>
</body>
</html>
