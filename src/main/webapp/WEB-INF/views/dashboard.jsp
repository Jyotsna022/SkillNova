<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillnova.model.UserDashboardData" %>
<%@ page import="com.skillnova.model.Job" %>
<%@ page import="com.skillnova.model.ApplicationRecord" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>User Dashboard - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Spectral:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --red-900: #651018;
            --red-700: #991b1b;
            --red-600: #b91c1c;
            --red-100: #fee2e2;
            --bg: #fff7f7;
            --ink: #271a1a;
            --muted: #7b5c5c;
            --white: #ffffff;
            --border: #f1cccc;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Manrope", sans-serif;
            background: radial-gradient(circle at 85% 12%, #ffe9e9 0, transparent 30%), linear-gradient(155deg, #fffafa 0%, #fff1f1 100%);
            color: var(--ink);
        }

        .topbar {
            height: 64px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 20px;
            border-bottom: 1px solid var(--border);
            background: rgba(255,255,255,0.85);
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
            color: var(--red-700);
            border: 1px solid #eabcbc;
            border-radius: 10px;
            padding: 8px 12px;
            font-weight: 700;
        }

        .layout {
            max-width: 1160px;
            margin: 22px auto;
            padding: 0 16px;
        }

        .hero {
            background: linear-gradient(120deg, #7f1118 0%, #aa1d24 55%, #cf2d34 100%);
            color: #fff3f3;
            border-radius: 16px;
            padding: 24px;
            margin-bottom: 16px;
        }

        .hero h1 {
            font-family: "Spectral", serif;
            margin-bottom: 6px;
            font-size: 1.9rem;
        }

        .hero p { color: #ffdcdc; }

        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 12px;
            margin-bottom: 14px;
        }

        .card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 16px;
            box-shadow: 0 8px 18px rgba(127, 29, 29, 0.07);
        }

        .card .meta {
            font-size: 0.82rem;
            color: var(--muted);
            margin-bottom: 6px;
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .card .value {
            font-weight: 800;
            font-size: 1.5rem;
            color: var(--red-700);
        }

        .panel {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 18px rgba(127, 29, 29, 0.07);
            margin-bottom: 14px;
        }

        .panel-head {
            padding: 12px 14px;
            border-bottom: 1px solid var(--border);
            color: var(--red-700);
            font-weight: 800;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            text-align: left;
            padding: 11px;
            border-bottom: 1px solid #f7dede;
            font-size: 0.88rem;
            vertical-align: top;
        }

        th {
            background: #fff5f5;
            color: #6c2323;
            text-transform: uppercase;
            letter-spacing: 0.35px;
            font-size: 0.78rem;
        }

        .pill {
            display: inline-flex;
            padding: 4px 9px;
            border-radius: 999px;
            background: #fff1f1;
            border: 1px solid #f1caca;
            color: #8e2626;
            font-size: 0.75rem;
            font-weight: 700;
        }

        .quick-links {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }

        .quick-link {
            text-decoration: none;
            font-size: 0.85rem;
            border: 1px solid #ecc0c0;
            background: #fff7f7;
            color: var(--red-700);
            padding: 8px 12px;
            border-radius: 9px;
            font-weight: 700;
        }

        .empty {
            padding: 20px;
            color: var(--muted);
            font-size: 0.92rem;
        }
    </style>
</head>
<body>
<%
    UserDashboardData dashboard = (UserDashboardData) request.getAttribute("dashboard");
    String userRole = dashboard == null ? "USER" : dashboard.getRole();
    List<Job> jobs = dashboard == null ? null : dashboard.getJobs();
    List<ApplicationRecord> applications = dashboard == null ? null : dashboard.getApplications();
%>
<header class="topbar">
    <div class="brand"><span>Skill</span>Nova <%= userRole %> Dashboard</div>
    <a class="logout" href="${pageContext.request.contextPath}/logout">Logout</a>
</header>

<main class="layout">
    <section class="hero">
        <h1>Hello, ${fullName}</h1>
        <% if ("CLIENT".equals(userRole)) { %>
            <p>Manage postings, track hiring progress, and review incoming freelancer applications.</p>
        <% } else if ("FREELANCER".equals(userRole)) { %>
            <p>Track your applications, monitor shortlisted opportunities, and browse new open jobs.</p>
        <% } else { %>
            <p>Dashboard is available for client and freelancer roles.</p>
        <% } %>
    </section>

    <% if (request.getAttribute("error") != null) { %>
        <div class="card" style="margin-bottom: 14px; border-color: #f7bcbc; color: #9b1c1c;">
            <strong>Notice:</strong> <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <section class="grid">
        <article class="card">
            <div class="meta"><span class="material-symbols-rounded">insights</span>
                <%= "CLIENT".equals(userRole) ? "Jobs Posted" : "Open Jobs" %>
            </div>
            <div class="value"><%= dashboard == null ? 0 : dashboard.getPrimaryCount() %></div>
        </article>
        <article class="card">
            <div class="meta"><span class="material-symbols-rounded">assignment</span>
                <%= "CLIENT".equals(userRole) ? "Total Applications" : "My Applications" %>
            </div>
            <div class="value"><%= dashboard == null ? 0 : dashboard.getSecondaryCount() %></div>
        </article>
        <article class="card">
            <div class="meta"><span class="material-symbols-rounded">flag</span>
                <%= "CLIENT".equals(userRole) ? "Open Jobs" : "Shortlisted" %>
            </div>
            <div class="value"><%= dashboard == null ? 0 : dashboard.getTertiaryCount() %></div>
        </article>
    </section>

    <section class="quick-links">
        <% if ("CLIENT".equals(userRole)) { %>
            <a class="quick-link" href="${pageContext.request.contextPath}/client/jobs">Manage Jobs</a>
            <a class="quick-link" href="${pageContext.request.contextPath}/client/dashboard">Refresh Dashboard</a>
        <% } else if ("FREELANCER".equals(userRole)) { %>
            <a class="quick-link" href="${pageContext.request.contextPath}/freelancer/dashboard">Refresh Dashboard</a>
        <% } %>
    </section>

    <section class="panel">
        <div class="panel-head">
            <span class="material-symbols-rounded">
                <%= "CLIENT".equals(userRole) ? "work_history" : "search" %>
            </span>
            <%= "CLIENT".equals(userRole) ? "Recent Job Activity" : "Recent Open Jobs" %>
        </div>
        <% if (jobs == null || jobs.isEmpty()) { %>
            <div class="empty">No records available yet.</div>
        <% } else { %>
            <table>
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Budget</th>
                    <th>Experience</th>
                    <th>Location</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>
                <% for (Job job : jobs) { %>
                    <tr>
                        <td><%= job.getJobTitle() %></td>
                        <td><%= job.getBudgetMin() %> - <%= job.getBudgetMax() %></td>
                        <td><%= job.getExperienceLevel() %></td>
                        <td><%= job.getLocationType() %></td>
                        <td><span class="pill"><%= job.getJobStatus() %></span></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </section>

    <section class="panel">
        <div class="panel-head">
            <span class="material-symbols-rounded">pending_actions</span>
            <%= "CLIENT".equals(userRole) ? "Recent Applications on Your Jobs" : "Your Recent Applications" %>
        </div>
        <% if (applications == null || applications.isEmpty()) { %>
            <div class="empty">No application entries available yet.</div>
        <% } else { %>
            <table>
                <thead>
                <tr>
                    <th>Job</th>
                    <th><%= "CLIENT".equals(userRole) ? "Freelancer" : "Client" %></th>
                    <th>Status</th>
                    <th>Applied At</th>
                </tr>
                </thead>
                <tbody>
                <% for (ApplicationRecord appRecord : applications) { %>
                    <tr>
                        <td><%= appRecord.getJobTitle() %></td>
                        <td>
                            <% if ("CLIENT".equals(userRole)) { %>
                                <strong><%= appRecord.getFreelancerName() %></strong><br/>
                                <small><%= appRecord.getFreelancerEmail() %></small>
                            <% } else { %>
                                <%= appRecord.getClientName() %>
                            <% } %>
                        </td>
                        <td><span class="pill"><%= appRecord.getApplicationStatus() %></span></td>
                        <td><%= appRecord.getAppliedAt() %></td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </section>
</main>
</body>
</html>
