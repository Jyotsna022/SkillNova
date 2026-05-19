<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillnova.model.ApplicationRecord" %>
<%@ page import="com.skillnova.model.Job" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Freelancer Dashboard - SkillNova</title>
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
            --sidebar: #070056;
            --mint: #7ad7cd;
            --mint-deep: #0d6861;
            --panel: #fbfbfd;
            --deep-card: #09005b;
            --chip: #eef1f6;
            --danger: #c92738;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        html { font-size: 13px; }

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

        .bar-left,
        .bar-right {
            display: flex;
            align-items: center;
            gap: 24px;
        }
        .bar-left { flex: 1; }
        .bar-right { flex: 1; justify-content: flex-end; }

        .brand {
            font-family: "Space Grotesk", sans-serif;
            font-size: 2.05rem;
            font-weight: 700;
            color: #11174a;
        }

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

        .nav a:hover { color: #0a8575; }

        .nav a.active {
            color: var(--ink);
            border-bottom: 3px solid #23b8a7;
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

        .content { min-width: 0; }

        .hero h1 {
            font-family: "Space Grotesk", sans-serif;
            font-size: clamp(2rem, 3vw, 3.2rem);
            line-height: 1.06;
            margin-bottom: 8px;
        }

        .hero p {
            font-size: clamp(1rem, 1.2vw, 1.3rem);
            color: #3e465b;
            margin-bottom: 16px;
        }

        .flash {
            border-radius: 10px;
            padding: 10px 12px;
            margin-bottom: 12px;
            font-size: 0.95rem;
        }

        .flash.success { background: #e8f8ef; border: 1px solid #bee8ce; color: #1d6f42; }
        .flash.error { background: #ffeef3; border: 1px solid #ffc8d8; color: #b52b56; }

        .metrics {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr)) 360px;
            gap: 14px;
        }

        .metric {
            background: var(--panel);
            border: 1px solid #dfe4ec;
            border-radius: 18px;
            padding: 18px;
            min-height: 178px;
        }

        .metric .icon {
            width: 54px;
            height: 54px;
            border-radius: 12px;
            display: grid;
            place-items: center;
            margin-bottom: 12px;
        }

        .metric .row {
            display: flex;
            justify-content: space-between;
            align-items: baseline;
            gap: 8px;
        }

        .metric .label {
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 1.1rem;
            color: #20283f;
        }

        .metric .delta {
            font-size: 1rem;
            font-weight: 700;
            color: #0d6a63;
        }

        .metric .delta.down {
            color: var(--danger);
        }

        .metric .value {
            margin-top: 8px;
            font-size: 3rem;
            font-weight: 800;
            line-height: 1;
        }

        .strength {
            background: var(--deep-card);
            color: #f4f7ff;
            border-radius: 18px;
            padding: 18px;
        }

        .strength h3 {
            font-size: 2.2rem;
            margin-bottom: 16px;
        }

        .s-row {
            display: flex;
            gap: 14px;
            align-items: center;
            margin-bottom: 12px;
        }

        .ring {
            --val: 80;
            --angle: calc(var(--val) * 3.6deg);
            width: 82px;
            height: 82px;
            border-radius: 50%;
            background: conic-gradient(#86eee0 var(--angle), rgba(255,255,255,0.18) 0);
            position: relative;
            display: grid;
            place-items: center;
            flex: 0 0 auto;
        }

        .ring::before {
            content: "";
            position: absolute;
            inset: 8px;
            border-radius: 50%;
            background: var(--deep-card);
        }

        .ring span {
            position: relative;
            z-index: 1;
            font-weight: 800;
            font-size: 1.1rem;
        }

        .strength p {
            font-size: 1.1rem;
            line-height: 1.4;
        }

        .strength button {
            margin-top: 10px;
            width: 100%;
            height: 52px;
            border-radius: 11px;
            border: 1px solid rgba(227, 237, 255, 0.3);
            background: rgba(255,255,255,0.14);
            color: #fff;
            font-weight: 700;
            font-size: 1.1rem;
            cursor: pointer;
        }

        .grid {
            margin-top: 18px;
            display: grid;
            grid-template-columns: minmax(0, 1fr) 360px;
            gap: 14px;
        }

        .head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }

        .head h3 {
            font-size: 2.2rem;
        }

        .head a {
            text-decoration: none;
            color: #0a6b64;
            font-weight: 600;
            font-size: 1.6rem;
        }

        .proposals {
            background: var(--panel);
            border: 1px solid #dde3ec;
            border-radius: 16px;
            overflow: hidden;
        }

        .proposal {
            display: grid;
            grid-template-columns: 56px 1fr auto 20px;
            align-items: center;
            gap: 12px;
            padding: 14px;
            border-top: 1px solid #e6eaf1;
        }

        .proposal:first-child {
            border-top: 0;
        }

        .picon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            background: #e9edf3;
            display: grid;
            place-items: center;
            color: #203257;
        }

        .proposal h4 {
            font-size: 1.1rem;
            line-height: 1.25;
        }

        .proposal p {
            color: #41495f;
            font-size: 0.95rem;
            margin-top: 4px;
        }

        .badge {
            border-radius: 999px;
            padding: 7px 14px;
            font-size: 0.95rem;
            font-weight: 600;
            text-transform: capitalize;
        }

        .badge.review { background: #7ad7cd; color: #0d635c; }
        .badge.interviewing { background: #efd1b5; color: #7e5021; }
        .badge.default { background: var(--chip); color: #364056; }

        .stack {
            display: grid;
            gap: 14px;
            align-content: start;
        }

        .interviews {
            background: transparent;
        }

        .interview {
            background: var(--panel);
            border: 1px solid #dde3ec;
            border-radius: 14px;
            padding: 12px;
            display: grid;
            grid-template-columns: 62px 1fr 20px;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        .date {
            border-right: 1px solid #dfe4eb;
            text-align: center;
            padding-right: 8px;
        }

        .date .m {
            font-size: 0.76rem;
            letter-spacing: 2px;
            color: #4a5368;
        }

        .date .d {
            font-size: 2rem;
            font-weight: 800;
            line-height: 1;
        }

        .interview h5 {
            font-size: 1rem;
            margin-bottom: 3px;
        }

        .interview p {
            color: #424a5f;
            font-size: 0.9rem;
        }

        .learn {
            background: #e9e4ec;
            border: 1px solid #d8d2de;
            border-radius: 16px;
            padding: 16px;
        }

        .learn .tag {
            text-transform: uppercase;
            letter-spacing: 2px;
            font-size: 0.9rem;
            font-weight: 700;
            margin-bottom: 10px;
            display: inline-flex;
            gap: 8px;
            align-items: center;
        }

        .learn h4 {
            font-size: 1.95rem;
            line-height: 1.2;
            margin-bottom: 10px;
        }

        .learn p {
            color: #3b4256;
            line-height: 1.5;
            font-size: 1.05rem;
        }

        .progress {
            margin: 14px 0;
            height: 7px;
            background: #ced4df;
            border-radius: 999px;
            overflow: hidden;
        }

        .progress span {
            display: block;
            height: 100%;
            width: 35%;
            background: #0f0d57;
        }

        .learn a {
            text-decoration: none;
            color: #121748;
            font-weight: 700;
        }

        .recommend {
            margin-top: 16px;
        }

        .jobs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .job {
            background: var(--panel);
            border: 1px solid #dde3ec;
            border-radius: 16px;
            padding: 14px;
            display: flex;
            flex-direction: column;
            min-height: 250px;
        }

        .new {
            background: #c6f2e9;
            color: #0b6b61;
            border-radius: 8px;
            padding: 6px 10px;
            width: fit-content;
            font-size: 0.84rem;
        }

        .job h4 {
            margin-top: 12px;
            font-size: 1.35rem;
            line-height: 1.2;
        }

        .job p {
            margin-top: 8px;
            color: #3e465b;
            line-height: 1.45;
            font-size: 1rem;
            flex: 1;
        }

        .tags {
            margin-top: 8px;
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        .tags span {
            background: #e8ecf2;
            border-radius: 8px;
            padding: 5px 10px;
            font-size: 0.85rem;
            color: #333c50;
        }

        .job .foot {
            margin-top: 10px;
            padding-top: 10px;
            border-top: 1px solid #e5e9f0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-weight: 700;
            font-size: 1.1rem;
        }

        .job .foot a {
            text-decoration: none;
            color: #12184a;
        }

        .footer {
            margin-top: 24px;
            border-top: 1px solid #d7dbe4;
            padding-top: 14px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            color: #3f465c;
        }

        .fbrand {
            font-family: "Space Grotesk", sans-serif;
            font-size: 1.9rem;
            color: #11174a;
        }

        .flinks {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
            font-size: 0.94rem;
        }

        .flinks a {
            color: #384156;
            text-decoration: none;
            transition: color .2s ease;
        }

        .flinks a:hover { color: #0a8575; }

        @media (max-width: 1500px) {
            html { font-size: 12.5px; }
            .metrics {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }

            .strength {
                grid-column: 1 / -1;
            }

            .grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 1200px) {
            .search { min-width: 260px; }
            .jobs { grid-template-columns: 1fr; }
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

            .content {
                padding: 14px;
            }

            .metrics {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<%
    String fullName = (String) request.getAttribute("fullName");
    if (fullName == null || fullName.trim().isEmpty()) {
        fullName = "Freelancer";
    }
    String firstName = fullName.trim();
    int split = firstName.indexOf(' ');
    if (split > 0) {
        firstName = firstName.substring(0, split);
    }

    List<ApplicationRecord> recentApplications = (List<ApplicationRecord>) request.getAttribute("recentApplications");
    if (recentApplications == null) {
        recentApplications = new ArrayList<>();
    }

    List<Job> recommendedJobs = (List<Job>) request.getAttribute("recommendedJobs");
    if (recommendedJobs == null) {
        recommendedJobs = new ArrayList<>();
    }

    Integer profileStrengthObj = (Integer) request.getAttribute("profileStrength");
    int profileStrength = profileStrengthObj == null ? 65 : profileStrengthObj;

    List<ApplicationRecord> interviews = new ArrayList<>();
    for (ApplicationRecord app : recentApplications) {
        String status = app.getApplicationStatus() == null ? "" : app.getApplicationStatus();
        if ("INTERVIEWING".equalsIgnoreCase(status) || "SHORTLISTED".equalsIgnoreCase(status)) {
            interviews.add(app);
        }
    }

    String initials = firstName.length() >= 2 ? firstName.substring(0, 2).toUpperCase() : firstName.toUpperCase();
%>

<header class="topbar">
    <div class="bar-left">
        <div class="brand">SkillNova</div>
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/freelancer/jobs">Find Work</a>
            <a href="${pageContext.request.contextPath}/freelancer/profile">Profile</a>
            <a href="${pageContext.request.contextPath}/freelancer/applications">Applications</a>
            <a class="active" href="${pageContext.request.contextPath}/freelancer/dashboard">Dashboard</a>
            <a href="${pageContext.request.contextPath}/about.jsp">About</a>
            <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        </nav>
    </div>
    <div class="bar-right">
        <form method="get" action="${pageContext.request.contextPath}/freelancer/dashboard" class="search"><span class="material-symbols-rounded">search</span><input name="search" value="${search}" placeholder="Search jobs..." style="border:0;background:transparent;outline:none;width:100%;font:inherit;color:inherit;"></form>
        <a class="nav" style="text-decoration:none;" href="${pageContext.request.contextPath}/logout"><span class="material-symbols-rounded">logout</span></a>
        <div class="avatar"><%= initials %></div>
    </div>
</header>

<div class="shell">
    <aside class="sidebar">
        <div class="workspace">
            <div class="pic"><%= initials %></div>
            <div>
                <h3>Workspace</h3>
                <p>Pro Freelancer</p>
            </div>
        </div>

        <nav class="menu">
            <a class="active" href="${pageContext.request.contextPath}/freelancer/dashboard"><span class="material-symbols-rounded">monitoring</span>Metrics</a>
            <a href="${pageContext.request.contextPath}/freelancer/jobs"><span class="material-symbols-rounded">work</span>Jobs</a>
            <a href="${pageContext.request.contextPath}/freelancer/profile"><span class="material-symbols-rounded">settings</span>Settings</a>
            <a href="${pageContext.request.contextPath}/freelancer/applications"><span class="material-symbols-rounded">draft</span>Applications</a>
            <a href="${pageContext.request.contextPath}/logout"><span class="material-symbols-rounded">logout</span>Logout</a>
        </nav>

        <a class="post" href="${pageContext.request.contextPath}/freelancer/jobs">Post a Job</a>
    </aside>

    <main class="content">
        <section class="hero">
            <h1>Welcome back, <%= firstName %>!</h1>
            <p>You have ${newNotifications} new notifications and ${upcomingInterviewsCount} upcoming interviews today.</p>
        </section>

        <% if (request.getAttribute("success") != null) { %>
            <div class="flash success"><%= request.getAttribute("success") %></div>
        <% } %>
        <% if (request.getAttribute("error") != null) { %>
            <div class="flash error"><%= request.getAttribute("error") %></div>
        <% } %>

        <section class="metrics">
            <article class="metric">
                <div class="icon" style="background:#d9d8f4;"><span class="material-symbols-rounded">payments</span></div>
                <div class="row">
                    <div class="label">Earnings this month</div>
                    <div class="delta">+12.5%</div>
                </div>
                <div class="value">$<%= String.format("%,d", (Integer)request.getAttribute("openJobs") * 8450) %>.00</div>
            </article>

            <article class="metric">
                <div class="icon" style="background:#88e4d9;"><span class="material-symbols-rounded">description</span></div>
                <div class="row">
                    <div class="label">Active applications</div>
                    <div class="delta">${myApplications} New</div>
                </div>
                <div class="value">${myApplications}</div>
            </article>

            <article class="metric">
                <div class="icon" style="background:#f0d2b4;"><span class="material-symbols-rounded">visibility</span></div>
                <div class="row">
                    <div class="label">Profile views</div>
                    <div class="delta down">-2%</div>
                </div>
                <div class="value"><%= Math.max(1240, ((Integer)request.getAttribute("myApplications") * 120)) %></div>
            </article>

            <article class="strength">
                <h3>Profile Strength</h3>
                <div class="s-row">
                    <div class="ring" style="--val:<%= profileStrength %>;"><span><%= profileStrength %>%</span></div>
                    <p>Almost there! Add your portfolio and details to reach 100% and get more invites.</p>
                </div>
                <form method="get" action="${pageContext.request.contextPath}/freelancer/profile">
                    <button type="submit">Complete Profile</button>
                </form>
            </article>
        </section>

        <section class="grid">
            <div>
                <div class="head">
                    <h3>Active Proposals</h3>
                    <a href="${pageContext.request.contextPath}/freelancer/applications">View all</a>
                </div>

                <div class="proposals">
                    <% if (recentApplications.isEmpty()) { %>
                        <article class="proposal">
                            <div class="picon"><span class="material-symbols-rounded">info</span></div>
                            <div>
                                <h4>No active proposals yet</h4>
                                <p>Start by applying for open jobs from the jobs page.</p>
                            </div>
                            <span class="badge default">No data</span>
                            <span class="material-symbols-rounded">more_vert</span>
                        </article>
                    <% } else {
                        int count = Math.min(2, recentApplications.size());
                        for (int i = 0; i < count; i++) {
                            ApplicationRecord app = recentApplications.get(i);
                            String status = app.getApplicationStatus() == null ? "PENDING" : app.getApplicationStatus();
                            String c = "default";
                            if ("SHORTLISTED".equalsIgnoreCase(status)) {
                                c = "review";
                            } else if ("INTERVIEWING".equalsIgnoreCase(status)) {
                                c = "interviewing";
                            }
                    %>
                        <article class="proposal">
                            <div class="picon"><span class="material-symbols-rounded"><%= i == 0 ? "brush" : "code" %></span></div>
                            <div>
                                <h4><%= app.getJobTitle() == null ? "Untitled Job" : app.getJobTitle() %></h4>
                                <p><%= app.getClientName() == null ? "Client" : app.getClientName() %> • <%= app.getAppliedAt() == null ? "Recently" : app.getAppliedAt().toLocalDateTime().toLocalDate().toString() %></p>
                            </div>
                            <span class="badge <%= c %>"><%= status.replace('_', ' ') %></span>
                            <span class="material-symbols-rounded">more_vert</span>
                        </article>
                    <%  }
                    } %>
                </div>

                <div class="recommend">
                    <div class="head">
                        <h3>Recommended for You</h3>
                        <div style="display:flex; gap:8px;">
                            <span class="badge default">Design</span>
                            <span class="badge default">Development</span>
                        </div>
                    </div>

                    <div class="jobs">
                        <% if (recommendedJobs.isEmpty()) { %>
                            <article class="job">
                                <span class="new">New</span>
                                <h4>No recommendations yet</h4>
                                <p>We are preparing opportunities based on your profile and activity.</p>
                                <div class="foot"><span>--</span><a href="${pageContext.request.contextPath}/freelancer/jobs">Apply Now</a></div>
                            </article>
                            <article class="job">
                                <span class="new">2h ago</span>
                                <h4>Improve your profile</h4>
                                <p>Add headline, hourly rate, and bio to unlock stronger job matches.</p>
                                <div class="foot"><span>Profile</span><a href="${pageContext.request.contextPath}/freelancer/profile">Update</a></div>
                            </article>
                        <% } else {
                            int jc = Math.min(2, recommendedJobs.size());
                            for (int i = 0; i < jc; i++) {
                                Job job = recommendedJobs.get(i);
                                String desc = job.getJobDescription() == null ? "Opportunity from SkillNova matching your experience." : job.getJobDescription();
                                String shortDesc = desc.length() > 95 ? desc.substring(0, 95) + "..." : desc;
                        %>
                            <article class="job">
                                <span class="new"><%= i == 0 ? "New" : "2h ago" %></span>
                                <h4><%= job.getJobTitle() == null ? "Untitled Job" : job.getJobTitle() %></h4>
                                <p><%= shortDesc %></p>
                                <div class="tags">
                                    <span><%= job.getExperienceLevel() == null ? "Any" : job.getExperienceLevel() %></span>
                                    <span><%= job.getLocationType() == null ? "Remote" : job.getLocationType() %></span>
                                    <span>SkillNova</span>
                                </div>
                                <div class="foot">
                                    <span>
                                        <%= job.getBudgetMin() == null ? "$0" : "$" + job.getBudgetMin().toPlainString() %>
                                        -
                                        <%= job.getBudgetMax() == null ? "$0" : "$" + job.getBudgetMax().toPlainString() %>
                                    </span>
                                    <a href="${pageContext.request.contextPath}/freelancer/jobs">Apply Now</a>
                                </div>
                            </article>
                        <%  }
                        } %>
                    </div>
                </div>
            </div>

            <aside class="stack">
                <div class="head"><h3>Upcoming Interviews</h3></div>

                <div class="interviews">
                    <% if (interviews.isEmpty()) { %>
                        <article class="interview">
                            <div class="date"><div class="m">--</div><div class="d">--</div></div>
                            <div>
                                <h5>No interviews scheduled</h5>
                                <p>Keep applying to increase interview invites.</p>
                            </div>
                            <span class="material-symbols-rounded">videocam</span>
                        </article>
                    <% } else {
                        int ic = Math.min(2, interviews.size());
                        for (int i = 0; i < ic; i++) {
                            ApplicationRecord iv = interviews.get(i);
                    %>
                        <article class="interview">
                            <div class="date"><div class="m">OCT</div><div class="d"><%= 24 + i * 2 %></div></div>
                            <div>
                                <h5><%= iv.getClientName() == null ? "Client Interview" : iv.getClientName() %></h5>
                                <p><%= iv.getJobTitle() == null ? "Project discussion" : iv.getJobTitle() %></p>
                            </div>
                            <span class="material-symbols-rounded">videocam</span>
                        </article>
                    <%  }
                    } %>
                </div>

                <article class="learn">
                    <div class="tag"><span class="material-symbols-rounded">school</span>Skill Up</div>
                    <h4>Master Advanced Figma Auto-Layout</h4>
                    <p>Complete this course to earn a Pro Designer badge and increase visibility.</p>
                    <div class="progress"><span></span></div>
                    <a href="#">Continue learning -></a>
                </article>
            </aside>
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
