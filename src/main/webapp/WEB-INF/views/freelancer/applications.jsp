<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillnova.model.ApplicationRecord" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>My Applications - SkillNova</title>
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
            --deep: #08045f;
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

        .brand {
            font-family: "Space Grotesk", sans-serif;
            font-size: 2.05rem;
            font-weight: 700;
            color: #11174a;
        }

        .bar-left,
        .bar-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }
        .bar-left { flex: 1; }
        .bar-right { flex: 1; justify-content: flex-end; }

        .nav {
            display: flex;
            align-items: center;
            gap: 24px;
            margin: 0 auto;
        }

        .nav a {
            text-decoration: none;
            color: #242b40;
            font-weight: 600;
            font-size: 1.02rem;
            padding-bottom: 8px;
            transition: color .2s ease;
            white-space: nowrap;
        }

        .nav a:hover {
            color: #0a8575;
        }

        .nav a.active {
            color: var(--ink);
            border-bottom: 3px solid #23b8a7;
        }

        .nav a:active {
            background: #dff8f4;
            border-radius: 9px;
        }

        .search {
            height: 50px;
            min-width: 340px;
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
            width: 50px;
            height: 50px;
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

        .shell {
            width: min(1400px, 100% - 32px);
            margin: 18px auto 28px;
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 14px;
        }

        .sidebar {
            background: #05004f;
            color: #d4d8f7;
            padding: 20px 14px;
            border-radius: 16px;
            display: flex;
            flex-direction: column;
            min-height: calc(100vh - 140px);
        }

        .workspace { display:flex; align-items:center; gap:12px; margin-bottom:18px; }
        .workspace .pic { width:54px; height:54px; border-radius:12px; background:linear-gradient(135deg,#9ecde8,#4e86b3); display:grid; place-items:center; color:#153b60; font-weight:700; }
        .workspace h3 { font-size:1.7rem; color:#fff; line-height:1.1; }
        .workspace p { font-size:0.95rem; color:#bec8f4; }
        .menu { display:grid; gap:8px; }
        .menu a { text-decoration:none; color:#d3daf6; display:flex; align-items:center; gap:10px; border-radius:12px; padding:12px 12px; font-size:0.98rem; font-weight:600; transition:background .2s ease,color .2s ease; }
        .menu a.active { background:#7ad7cd; color:#0d6861; }
        .menu a:active { background:#d8fff8; color:#0e5f58; }
        .post { margin-top:auto; background:#0a7a70; color:#ecfffb; text-decoration:none; border-radius:12px; height:50px; display:grid; place-items:center; font-size:0.98rem; font-weight:700; }
        .content { min-width:0; }

        .hero {
            border-radius: 18px;
            border: 1px solid #1c237a;
            background:
                radial-gradient(680px 260px at 92% 10%, rgba(79, 171, 255, 0.2), transparent 55%),
                linear-gradient(150deg, #06024f, #11145f 60%, #0d2b5b);
            color: #eef5ff;
            padding: 24px;
            box-shadow: 0 16px 36px rgba(12, 18, 62, 0.24);
            margin-bottom: 14px;
        }

        .hero h1 {
            font-family: "Space Grotesk", sans-serif;
            font-size: clamp(1.7rem, 2.5vw, 2.5rem);
            margin-bottom: 4px;
        }

        .hero p { color: #c8d7fc; font-size: 1.02rem; }

        .flash {
            border-radius: 12px;
            border: 1px solid;
            padding: 10px 12px;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }

        .flash.success { background: var(--success-bg); border-color: #bee5cd; color: var(--success-text); }
        .flash.error { background: var(--danger-bg); border-color: #ffc8d8; color: var(--danger-text); }

        .panel {
            background: var(--card);
            border: 1px solid var(--line);
            border-radius: 16px;
            overflow: hidden;
            min-height: calc(100vh - 230px);
        }

        .panel-head {
            padding: 16px 18px;
            border-bottom: 1px solid #e6e9f1;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .panel-head h2 {
            font-family: "Space Grotesk", sans-serif;
            font-size: 1.35rem;
        }

        .stats { color: var(--muted); font-size: 0.95rem; }

        .list { display: grid; }

        .item {
            border-top: 1px solid #e8ebf1;
            padding: 16px 18px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 170px 190px minmax(260px, 1fr);
            align-items: start;
            gap: 14px;
        }

        .item:first-child { border-top: 0; }

        .meta {
            text-transform: uppercase;
            letter-spacing: 1px;
            color: #606a85;
            font-size: 0.72rem;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .title { font-size: 1.1rem; font-weight: 700; margin-bottom: 4px; }
        .sub { color: #485169; font-size: 0.95rem; }

        .badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 12px;
            border-radius: 999px;
            background: #e7ecf5;
            color: #2f3a51;
            font-weight: 700;
            font-size: 0.88rem;
            text-transform: capitalize;
        }

        .badge.shortlisted { background: #c8f3eb; color: #0a6d62; }
        .badge.interviewing { background: #f6dcc4; color: #7f4f21; }
        .badge.hired { background: #d5f1dc; color: #1c6b3f; }

        .actions {
            display: grid;
            gap: 8px;
        }

        .inline {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .input {
            height: 40px;
            border: 1px solid #c4cbda;
            border-radius: 10px;
            padding: 0 10px;
            background: #fff;
            font-family: inherit;
            font-size: 0.92rem;
        }

        .btn {
            border: 0;
            border-radius: 10px;
            height: 40px;
            padding: 0 12px;
            color: #fff;
            font-weight: 700;
            font-size: 0.9rem;
            cursor: pointer;
        }

        .btn-danger { background: linear-gradient(120deg, #de4f63, #b92f53); }
        .btn-rate { background: linear-gradient(120deg, #0f8f81, #0a5f57); }

        .empty { padding: 18px; color: #4f596f; }

        @media (max-width: 1200px) {
            .item { grid-template-columns: 1fr; }
            .search { min-width: 260px; }
        }

        @media (max-width: 820px) {
            .topbar {
                height: auto;
                padding: 12px;
                flex-wrap: wrap;
            }

            .bar-left,
            .bar-right {
                width: 100%;
                justify-content: space-between;
                flex-wrap: wrap;
            }

            .search {
                min-width: 0;
                width: 100%;
            }

            .shell { width: calc(100% - 20px); margin-top: 12px; grid-template-columns:1fr; }

            .hero,
            .panel-head,
            .item { padding: 12px; }
        }
    </style>
</head>
<body>
<%
    List<ApplicationRecord> apps = (List<ApplicationRecord>) request.getAttribute("applications");
    int appCount = apps == null ? 0 : apps.size();
%>

<header class="topbar">
    <div class="bar-left">
        <div class="brand">SkillNova</div>
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/freelancer/jobs">Find Work</a>
            <a href="${pageContext.request.contextPath}/freelancer/profile">Profile</a>
            <a class="active" href="${pageContext.request.contextPath}/freelancer/applications">Applications</a>
            <a href="${pageContext.request.contextPath}/freelancer/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/about.jsp">About</a>
            <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        </nav>
    </div>
    <div class="bar-right">
        <form method="get" action="${pageContext.request.contextPath}/freelancer/jobs" class="search"><span class="material-symbols-rounded">search</span><input name="keyword" placeholder="Search jobs..." style="border:0;background:transparent;outline:none;width:100%;font:inherit;color:inherit;"></form>
        <a class="nav" style="text-decoration:none;" href="${pageContext.request.contextPath}/logout"><span class="material-symbols-rounded">logout</span></a>
        <div class="avatar">SN</div>
    </div>
</header>

<div class="shell">
    <aside class="sidebar">
        <div class="workspace"><div class="pic">SN</div><div><h3>Workspace</h3><p>Pro Freelancer</p></div></div>
        <nav class="menu">
            <a href="${pageContext.request.contextPath}/freelancer/dashboard"><span class="material-symbols-rounded">monitoring</span>Metrics</a>
            <a href="${pageContext.request.contextPath}/freelancer/jobs"><span class="material-symbols-rounded">work</span>Jobs</a>
            <a href="${pageContext.request.contextPath}/freelancer/profile"><span class="material-symbols-rounded">settings</span>Settings</a>
            <a class="active" href="${pageContext.request.contextPath}/freelancer/applications"><span class="material-symbols-rounded">draft</span>Applications</a>
            <a href="${pageContext.request.contextPath}/logout"><span class="material-symbols-rounded">logout</span>Logout</a>
        </nav>
        <a class="post" href="${pageContext.request.contextPath}/freelancer/jobs">Find Jobs</a>
    </aside>

    <main class="content">
    <section class="hero">
        <h1>Track your applications in one place</h1>
        <p>Monitor statuses, withdraw when needed, and rate clients after successful hires.</p>
    </section>

    <% if (request.getAttribute("success") != null) { %>
        <div class="flash success"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="flash error"><%= request.getAttribute("error") %></div>
    <% } %>

    <section class="panel">
        <div class="panel-head">
            <h2>My Application Tracker</h2>
            <div class="stats"><%= appCount %> application(s)</div>
        </div>

        <div class="list">
            <% if (apps == null || apps.isEmpty()) { %>
                <div class="empty">No applications yet. Start applying from the jobs page.</div>
            <% } else { for (ApplicationRecord a : apps) {
                String s = a.getApplicationStatus() == null ? "pending" : a.getApplicationStatus().toLowerCase();
            %>
                <article class="item">
                    <div>
                        <div class="meta">Job</div>
                        <div class="title"><%= a.getJobTitle() %></div>
                        <div class="sub">Client: <%= a.getClientName() %></div>
                    </div>

                    <div>
                        <div class="meta">Status</div>
                        <span class="badge <%= s %>"><%= a.getApplicationStatus() %></span>
                    </div>

                    <div>
                        <div class="meta">Applied</div>
                        <div class="sub"><%= a.getAppliedAt() == null ? "Recently" : a.getAppliedAt() %></div>
                    </div>

                    <div class="actions">
                        <form method="post" action="${pageContext.request.contextPath}/freelancer/applications">
                            <input type="hidden" name="action" value="withdrawApplication" />
                            <input type="hidden" name="applicationId" value="<%= a.getApplicationId() %>" />
                            <button class="btn btn-danger" type="submit">Withdraw</button>
                        </form>

                        <% if ("HIRED".equalsIgnoreCase(a.getApplicationStatus())) { %>
                            <form method="post" action="${pageContext.request.contextPath}/freelancer/applications" class="inline">
                                <input type="hidden" name="action" value="addClientReview" />
                                <input type="hidden" name="jobId" value="<%= a.getJobId() %>" />
                                <input class="input" type="number" min="1" max="5" name="rating" placeholder="Rating" required />
                                <input class="input" name="comment" placeholder="Client review" />
                                <button class="btn btn-rate" type="submit">Submit Rating</button>
                            </form>
                        <% } %>
                    </div>
                </article>
            <% }} %>
        </div>
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
</div>
</body>
</html>
