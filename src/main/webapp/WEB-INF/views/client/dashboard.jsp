<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillnova.model.Job" %>
<%@ page import="com.skillnova.model.ApplicationRecord" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Client Dashboard - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Space+Grotesk:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,0,0" rel="stylesheet">
    <style>
        :root {
            --page: #eef0f5;
            --card: #f9faff;
            --line: #d7dce8;
            --ink: #131a49;
            --muted: #4d5670;
            --success-bg: #e8f8ef;
            --success-text: #1f6d40;
            --danger-bg: #ffedf1;
            --danger-text: #b92850;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: "Manrope", sans-serif;
            color: var(--ink);
            background:
                radial-gradient(900px 340px at 8% -10%, rgba(122, 215, 204, 0.24), transparent 60%),
                linear-gradient(180deg, #f3f4f8 0%, var(--page) 100%);
            min-height: 100vh;
        }
        .topbar {
            position: sticky;
            top: 0;
            z-index: 60;
            height: 88px;
            background: #f4f4f8;
            border-bottom: 1px solid var(--line);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 0 24px;
        }
        .bar-left, .bar-right { display: flex; align-items: center; gap: 18px; }
        .bar-left { flex: 1; }
        .bar-right { flex: 1; justify-content: flex-end; }
        .brand { font-family: "Space Grotesk", sans-serif; font-size: 2.15rem; font-weight: 700; color:#11174a; }
        .nav { display: flex; align-items: center; gap: 24px; margin: 0 auto; }
        .nav a { text-decoration: none; color: #242b40; font-weight: 600; font-size: 1.04rem; padding-bottom: 8px; white-space: nowrap; }
        .nav a:hover { color: #0a8575; }
        .nav a.active { color: var(--ink); border-bottom: 3px solid #23b8a7; }
        .search {
            height: 52px;
            min-width: 360px;
            border: 1px solid #d8dbe4;
            border-radius: 999px;
            background: #e9e9ef;
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 0 14px;
            color: #677084;
        }
        .avatar {
            width: 52px;
            height: 52px;
            border-radius: 50%;
            border: 2px solid #c6cfde;
            background: linear-gradient(135deg, #d6e9ff, #a8c7ed);
            display: grid;
            place-items: center;
            color: #16436f;
            font-weight: 800;
        }
        .site-footer { background:#f4f3f7; border-top:1px solid #dbdee8; padding:28px 0 14px; margin-top:14px; }
        .footer-wrap { width:100%; }
        .footer-top { display:grid; grid-template-columns:1.2fr 1fr 1fr; gap:22px; padding-bottom:14px; border-bottom:1px solid #d6d9e4; }
        .foot-brand { font:700 24px/1.2 "Space Grotesk",sans-serif; margin-bottom:8px; color:#11174a; }
        .foot-text { color:#606a7f; line-height:1.55; max-width:360px; margin-bottom:10px; font-size:13px; }
        .social { display:flex; gap:10px; }
        .social a { width:28px; height:28px; border-radius:50%; border:1px solid #ced5e2; display:grid; place-items:center; text-decoration:none; color:#23324f; transition:all .2s ease; }
        .social a:hover { color:#0a8575; border-color:#0a8575; }
        .col h4 { font-size:12px; color:#4d5567; margin-bottom:8px; text-transform:uppercase; letter-spacing:.6px; }
        .col a { display:block; text-decoration:none; color:#5f697d; margin-bottom:7px; font-size:13px; transition:color .2s ease; }
        .col a:hover { color:#0a8575; }
        .footer-bottom { margin-top:10px; display:flex; justify-content:space-between; color:#697286; font-size:12px; gap:10px; flex-wrap:wrap; }
        .shell { width: min(1400px, 100% - 36px); margin: 18px auto 28px; }
        .hero {
            border-radius: 20px;
            border: 1px solid #1c237a;
            background:
                radial-gradient(700px 260px at 92% 10%, rgba(79, 171, 255, 0.2), transparent 55%),
                linear-gradient(150deg, #06024f, #11145f 60%, #0d2b5b);
            color: #eef5ff;
            padding: 26px;
            box-shadow: 0 18px 38px rgba(12, 18, 62, 0.24);
            margin-bottom: 14px;
        }
        .hero h1 { font-family: "Space Grotesk", sans-serif; font-size: clamp(2rem, 3vw, 3rem); margin-bottom: 4px; }
        .hero p { color: #c8d7fc; font-size: 1.08rem; }
        .flash {
            border-radius: 12px;
            border: 1px solid;
            padding: 10px 12px;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }
        .flash.success { background: var(--success-bg); border-color: #bee5cd; color: var(--success-text); }
        .flash.error { background: var(--danger-bg); border-color: #ffc8d8; color: var(--danger-text); }
        .stats {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
            margin-bottom: 14px;
        }
        .stat {
            background: var(--card);
            border: 1px solid var(--line);
            border-radius: 16px;
            padding: 16px;
        }
        .stat .meta {
            color: #566082;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.74rem;
            margin-bottom: 8px;
            font-weight: 700;
        }
        .stat .value { font-size: 2.2rem; font-weight: 800; }
        .actions { display: flex; gap: 10px; margin-bottom: 14px; flex-wrap: wrap; }
        .pill {
            border: 1px solid #c8d0e0;
            background: #f2f5fb;
            color: #1d2948;
            text-decoration: none;
            border-radius: 999px;
            padding: 10px 14px;
            font-weight: 700;
            font-size: 0.92rem;
        }
        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
            min-height: calc(100vh - 430px);
        }
        .panel {
            background: var(--card);
            border: 1px solid var(--line);
            border-radius: 16px;
            overflow: hidden;
        }
        .head {
            padding: 14px 16px;
            border-bottom: 1px solid #e6e9f1;
            font-family: "Space Grotesk", sans-serif;
            font-size: 1.2rem;
        }
        table { width: 100%; border-collapse: collapse; }
        th, td {
            text-align: left;
            padding: 11px;
            border-bottom: 1px solid #ebeff5;
            font-size: 0.92rem;
            vertical-align: top;
        }
        th {
            background: #f3f6fb;
            color: #566082;
            font-size: 0.74rem;
            letter-spacing: 0.7px;
            text-transform: uppercase;
        }
        .status {
            display: inline-flex;
            padding: 5px 10px;
            border-radius: 999px;
            border: 1px solid #d4dcec;
            background: #eef3fb;
            color: #2e3a52;
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: capitalize;
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

        @media (max-width: 1100px) {
            .grid { grid-template-columns: 1fr; min-height: auto; }
            .search { min-width: 240px; }
        }
        @media (max-width: 820px) {
            .topbar { height: auto; padding: 12px; flex-wrap: wrap; }
            .bar-left, .bar-right { width: 100%; justify-content: space-between; flex-wrap: wrap; }
            .search { min-width: 0; width: 100%; }
            .mobile-toggle { display: flex; }
            .nav { display: none; }
            .nav.open {
                display: flex; flex-direction: column; width: 100%;
                background: #ecedf3; border-radius: 12px; padding: 4px 0; order: 10;
            }
            .nav.open a { padding: 12px 16px; border-bottom: 1px solid #dfe2ea; font-size: 1rem; }
            .nav.open a:last-child { border-bottom: 0; }
            .shell { width: calc(100% - 16px); margin-top: 12px; }
            .hero, .head { padding: 12px; }
            .stats { grid-template-columns: 1fr; }
            .footer-top { grid-template-columns: 1fr; }
            table { display: block; overflow-x: auto; }
        }
        @media (max-width: 480px) {
            .brand { font-size: 1.5rem; }
            .hero h1 { font-size: 1.5rem; }
            .hero p { font-size: 0.9rem; }
            .shell { width: calc(100% - 12px); }
        }
    </style>
</head>
<body>
<%
    List<Job> jobs = (List<Job>) request.getAttribute("recentJobs");
    List<ApplicationRecord> apps = (List<ApplicationRecord>) request.getAttribute("recentApplications");
    NumberFormat nprFormat = NumberFormat.getCurrencyInstance(new Locale("en", "NP"));
    nprFormat.setMaximumFractionDigits(0);
%>
<header class="topbar">
    <div class="bar-left">
        <div class="brand">SkillNova</div>
        <button class="mobile-toggle" onclick="document.querySelector('.nav').classList.toggle('open')" aria-label="Toggle menu">&#9776;</button>
        <nav class="nav">
            <a class="active" href="${pageContext.request.contextPath}/client/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/client/jobs">Jobs</a>
            <a href="${pageContext.request.contextPath}/about.jsp">About</a>
            <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        </nav>
    </div>
    <div class="bar-right">
        <form method="get" action="${pageContext.request.contextPath}/client/dashboard" class="search"><span class="material-symbols-rounded">search</span><input name="search" value="${search}" placeholder="Search jobs or freelancers..." style="border:0;background:transparent;outline:none;width:100%;font:inherit;color:inherit;"></form>
        <a class="nav" style="text-decoration:none;" href="${pageContext.request.contextPath}/logout"><span class="material-symbols-rounded">logout</span></a>
        <div class="avatar">CL</div>
    </div>
</header>

<main class="shell">
    <section class="hero">
        <h1>Welcome back, ${fullName}!</h1>
        <p>Track your postings, shortlist better talent, and keep hiring momentum high.</p>
    </section>

    <% if (request.getAttribute("success") != null) { %>
        <div class="flash success"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="flash error"><%= request.getAttribute("error") %></div>
    <% } %>

    <section class="stats">
        <article class="stat"><div class="meta">Jobs Posted</div><div class="value">${postedJobs}</div></article>
        <article class="stat"><div class="meta">Open Jobs</div><div class="value">${openJobs}</div></article>
        <article class="stat"><div class="meta">Applications Received</div><div class="value">${receivedApplications}</div></article>
    </section>

    <div class="actions">
        <a class="pill" href="${pageContext.request.contextPath}/client/jobs">Manage Jobs</a>
        <a class="pill" href="${pageContext.request.contextPath}/client/jobs?selectedJobId=${latestJobId}">Review Applications</a>
    </div>

    <section class="grid">
        <article class="panel">
            <div class="head">Recent Jobs</div>
            <table>
                <thead><tr><th>Job</th><th>Budget (NPR)</th><th>Status</th></tr></thead>
                <tbody>
                <% if (jobs == null || jobs.isEmpty()) { %>
                    <tr><td colspan="3">No jobs yet.</td></tr>
                <% } else { for (Job j : jobs) { %>
                    <tr>
                        <td><%= j.getJobTitle() %></td>
                        <td><%= nprFormat.format(j.getBudgetMin()) %> - <%= nprFormat.format(j.getBudgetMax()) %></td>
                        <td><span class="status"><%= j.getJobStatus() %></span></td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </article>

        <article class="panel">
            <div class="head">Recent Applications</div>
            <table>
                <thead><tr><th>Job</th><th>Freelancer</th><th>Status</th></tr></thead>
                <tbody>
                <% if (apps == null || apps.isEmpty()) { %>
                    <tr><td colspan="3">No applications yet.</td></tr>
                <% } else { for (ApplicationRecord a : apps) { %>
                    <tr>
                        <td><%= a.getJobTitle() %></td>
                        <td><%= a.getFreelancerName() %></td>
                        <td><span class="status"><%= a.getApplicationStatus() %></span></td>
                    </tr>
                <% }} %>
                </tbody>
            </table>
        </article>
    </section>

    <footer class="site-footer">
        <div class="footer-wrap">
            <div class="footer-top">
                <div><div class="foot-brand">SkillNova</div><div class="foot-text">The premium marketplace for world-class freelance talent and elite global clients.</div><div class="social"><a href="#">x</a><a href="#">in</a><a href="#">o</a></div></div>
                <div class="col"><h4>Platform</h4><a href="${pageContext.request.contextPath}/about.jsp">About Us</a><a href="#">Safety</a><a href="#">Help Center</a><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></div>
                <div class="col"><h4>Legal</h4><a href="#">Terms of Service</a><a href="#">Privacy Policy</a></div>
            </div>
            <div class="footer-bottom"><div>&copy; 2024 SkillNova. All rights reserved.</div><div><span>English (US)</span> · <span>NPR</span></div></div>
        </div>
    </footer>
</main>
</body>
</html>
