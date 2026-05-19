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
    <title>Client Job Management - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Space+Grotesk:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,0,0" rel="stylesheet">
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
        .brand { font-family: "Space Grotesk", sans-serif; font-size: 2.15rem; font-weight: 700; color:#11174a; }
        .bar-left, .bar-right { display: flex; align-items: center; gap: 18px; }
        .bar-left { flex: 1; }
        .bar-right { flex: 1; justify-content: flex-end; }
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
        .alert {
            border-radius: 12px;
            border: 1px solid;
            padding: 10px 12px;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }
        .alert.success { background: var(--success-bg); border-color: #bee5cd; color: var(--success-text); }
        .alert.error { background: var(--danger-bg); border-color: #ffc8d8; color: var(--danger-text); }
        .grid {
            display: grid;
            grid-template-columns: 430px 1fr;
            gap: 14px;
            min-height: calc(100vh - 260px);
        }
        .card {
            background: var(--card);
            border: 1px solid var(--line);
            border-radius: 16px;
            overflow: hidden;
        }
        .card-head {
            border-bottom: 1px solid #e6e9f1;
            padding: 14px 16px;
            font-family: "Space Grotesk", sans-serif;
            font-size: 1.15rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .card-body { padding: 14px 16px; }
        .field { margin-bottom: 10px; }
        label {
            display: block;
            margin-bottom: 5px;
            font-size: 0.86rem;
            font-weight: 700;
            color: #435072;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }
        .input, .textarea, .select {
            width: 100%;
            border: 1px solid #c4cbda;
            border-radius: 10px;
            background: #fff;
            padding: 10px 11px;
            font-family: inherit;
            font-size: 0.95rem;
            outline: none;
        }
        .textarea { min-height: 95px; resize: vertical; }
        .input:focus, .textarea:focus, .select:focus {
            border-color: #8da7e9;
            box-shadow: 0 0 0 3px #e7edff;
        }
        .two-col { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; }
        .btn {
            border: 0;
            border-radius: 10px;
            padding: 10px 12px;
            font-weight: 800;
            cursor: pointer;
            white-space: nowrap;
        }
        .btn-primary { width: 100%; color: #fff; background: linear-gradient(120deg, #0f8f81, #0a5f57); }
        .btn-soft { width: 100%; background: #edf2fa; color: #1f2b47; border: 1px solid #cfd7e8; }
        .btn-danger { background: linear-gradient(120deg, #de4f63, #b92f53); color: #fff; }
        .hint { margin-top: 2px; color: #5a6583; font-size: 0.82rem; }
        .section-title { margin: 14px 0 8px; font-family: "Space Grotesk", sans-serif; font-size: 1.05rem; }
        table { width: 100%; border-collapse: collapse; }
        th, td {
            text-align: left;
            padding: 10px;
            border-bottom: 1px solid #ebeff5;
            font-size: 0.9rem;
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
            padding: 4px 8px;
            border-radius: 999px;
            border: 1px solid #d4dcec;
            background: #eef3fb;
            color: #2e3a52;
            font-size: 0.76rem;
            font-weight: 700;
            text-transform: capitalize;
        }
        .row-actions { display: flex; flex-wrap: wrap; gap: 6px; }
        .compact { display: inline-flex; align-items: center; gap: 6px; flex-wrap: wrap; }
        .compact .input { width: auto; min-width: 90px; height: 38px; padding: 0 9px; }

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

        @media (max-width: 1180px) {
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
            .hero, .card-head, .card-body { padding: 12px; }
            .two-col { grid-template-columns: 1fr; }
            .footer-top { grid-template-columns: 1fr; }
            table { display: block; overflow-x: auto; }
        }
        @media (max-width: 480px) {
            .brand { font-size: 1.5rem; }
            .hero h1 { font-size: 1.5rem; }
            .shell { width: calc(100% - 12px); }
        }
    </style>
</head>
<body>
<%
    Job editJob = (Job) request.getAttribute("editJob");
    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
    List<ApplicationRecord> selectedJobApplications = (List<ApplicationRecord>) request.getAttribute("selectedJobApplications");
    List<java.util.Map<String, String>> freelancers = (List<java.util.Map<String, String>>) request.getAttribute("freelancers");
    NumberFormat nprFormat = NumberFormat.getCurrencyInstance(new Locale("en", "NP"));
    nprFormat.setMaximumFractionDigits(0);
%>

<header class="topbar">
    <div class="bar-left">
        <div class="brand">SkillNova</div>
        <button class="mobile-toggle" onclick="document.querySelector('.nav').classList.toggle('open')" aria-label="Toggle menu">&#9776;</button>
        <nav class="nav">
            <a href="${pageContext.request.contextPath}/client/dashboard">Dashboard</a>
            <a class="active" href="${pageContext.request.contextPath}/client/jobs">Jobs</a>
            <a href="${pageContext.request.contextPath}/about.jsp">About</a>
            <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        </nav>
    </div>
    <div class="bar-right">
        <form method="get" action="${pageContext.request.contextPath}/client/jobs" class="search"><span class="material-symbols-rounded">search</span><input name="search" value="${search}" placeholder="Search your posted jobs..." style="border:0;background:transparent;outline:none;width:100%;font:inherit;color:inherit;"></form>
        <a class="nav" style="text-decoration:none;" href="${pageContext.request.contextPath}/logout"><span class="material-symbols-rounded">logout</span></a>
        <div class="avatar">CL</div>
    </div>
</header>

<main class="shell">
    <section class="hero">
        <h1>Job Management Workspace</h1>
        <p>Create jobs, review applications, and make hiring decisions with confidence.</p>
    </section>

    <% if (request.getAttribute("success") != null) { %>
        <div class="alert success"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert error"><%= request.getAttribute("error") %></div>
    <% } %>

    <section class="grid">
        <section class="card">
            <div class="card-head"><span class="material-symbols-rounded">work</span>${editJob != null ? 'Edit Job' : 'Create New Job'}</div>
            <div class="card-body">
                <form method="post" action="${pageContext.request.contextPath}/client/jobs">
                    <input type="hidden" name="action" value="${editJob != null ? 'update' : 'create'}" />
                    <% if (editJob != null) { %><input type="hidden" name="jobId" value="<%= editJob.getJobId() %>" /><% } %>
                    <div class="field"><label for="jobTitle">Job Title</label><input class="input" id="jobTitle" name="jobTitle" type="text" value="<%= editJob != null ? editJob.getJobTitle() : "" %>" required /></div>
                    <div class="field"><label for="jobDescription">Job Description</label><textarea class="textarea" id="jobDescription" name="jobDescription" required><%= editJob != null ? editJob.getJobDescription() : "" %></textarea></div>

                    <div class="two-col">
                        <div class="field">
                            <label for="budgetMin">Budget Min (NPR)</label>
                            <input class="input" id="budgetMin" name="budgetMin" type="number" step="1" min="1000" placeholder="50000" value="<%= editJob != null ? editJob.getBudgetMin() : "" %>" required />
                            <div class="hint">Minimum NPR 1,000</div>
                        </div>
                        <div class="field">
                            <label for="budgetMax">Budget Max (NPR)</label>
                            <input class="input" id="budgetMax" name="budgetMax" type="number" step="1" min="1000" placeholder="120000" value="<%= editJob != null ? editJob.getBudgetMax() : "" %>" required />
                            <div class="hint">Should be equal or greater than min</div>
                        </div>
                    </div>

                    <div class="two-col">
                        <div class="field">
                            <label for="experienceLevel">Experience Level</label>
                            <select class="select" id="experienceLevel" name="experienceLevel" required>
                                <option value="ENTRY" <%= editJob != null && "ENTRY".equals(editJob.getExperienceLevel()) ? "selected" : "" %>>Entry</option>
                                <option value="INTERMEDIATE" <%= editJob != null && "INTERMEDIATE".equals(editJob.getExperienceLevel()) ? "selected" : "" %>>Intermediate</option>
                                <option value="EXPERT" <%= editJob != null && "EXPERT".equals(editJob.getExperienceLevel()) ? "selected" : "" %>>Expert</option>
                            </select>
                        </div>
                        <div class="field">
                            <label for="locationType">Location Type</label>
                            <select class="select" id="locationType" name="locationType" required>
                                <option value="REMOTE" <%= editJob != null && "REMOTE".equals(editJob.getLocationType()) ? "selected" : "" %>>Remote</option>
                                <option value="ONSITE" <%= editJob != null && "ONSITE".equals(editJob.getLocationType()) ? "selected" : "" %>>Onsite</option>
                                <option value="HYBRID" <%= editJob != null && "HYBRID".equals(editJob.getLocationType()) ? "selected" : "" %>>Hybrid</option>
                            </select>
                        </div>
                    </div>

                    <% if (editJob != null) { %>
                        <div class="field">
                            <label for="jobStatus">Job Status</label>
                            <select class="select" id="jobStatus" name="jobStatus" required>
                                <option value="OPEN" <%= "OPEN".equals(editJob.getJobStatus()) ? "selected" : "" %>>Open</option>
                                <option value="CLOSED" <%= "CLOSED".equals(editJob.getJobStatus()) ? "selected" : "" %>>Closed</option>
                                <option value="CANCELLED" <%= "CANCELLED".equals(editJob.getJobStatus()) ? "selected" : "" %>>Cancelled</option>
                            </select>
                        </div>
                    <% } %>

                    <button class="btn btn-primary" type="submit">${editJob != null ? 'Update Job' : 'Post Job'}</button>
                </form>
                <% if (editJob != null) { %>
                    <form method="get" action="${pageContext.request.contextPath}/client/jobs" style="margin-top:8px;"><button class="btn btn-soft" type="submit">Cancel Edit</button></form>
                <% } %>
            </div>
        </section>

        <section class="card">
            <div class="card-head"><span class="material-symbols-rounded">view_list</span>Your Posted Jobs</div>
            <div class="card-body">
                <% if (jobs == null || jobs.isEmpty()) { %>
                    <p style="color: var(--muted);">No jobs posted yet. Use the form to create your first job.</p>
                <% } else { %>
                    <table>
                        <thead><tr><th>Title</th><th>Budget (NPR)</th><th>Status</th><th>Actions</th></tr></thead>
                        <tbody>
                        <% for (Job job : jobs) { %>
                            <tr>
                                <td><strong><%= job.getJobTitle() %></strong><br/><small><%= job.getExperienceLevel() %> · <%= job.getLocationType() %></small></td>
                                <td><%= nprFormat.format(job.getBudgetMin()) %> - <%= nprFormat.format(job.getBudgetMax()) %></td>
                                <td><span class="status"><%= job.getJobStatus() %></span></td>
                                <td>
                                    <div class="row-actions">
                                        <a class="btn btn-soft" style="text-decoration:none;" href="${pageContext.request.contextPath}/client/jobs?action=edit&jobId=<%= job.getJobId() %>">Edit</a>
                                        <form method="post" action="${pageContext.request.contextPath}/client/jobs">
                                            <input type="hidden" name="action" value="delete" />
                                            <input type="hidden" name="jobId" value="<%= job.getJobId() %>" />
                                            <button class="btn btn-danger" type="submit" onclick="return confirm('Delete this job?');">Delete</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                <% } %>

                <div class="section-title">Application Handling</div>
                <form method="get" action="${pageContext.request.contextPath}/client/jobs" class="compact" style="margin-bottom:10px;">
                    <select class="select" id="selectedJobId" name="selectedJobId" style="min-width:220px;">
                        <option value="">-- Choose Job --</option>
                        <% if (jobs != null) for (Job job : jobs) { %>
                            <option value="<%= job.getJobId() %>" <%= String.valueOf(job.getJobId()).equals(String.valueOf(request.getAttribute("selectedJobId"))) ? "selected" : "" %>><%= job.getJobTitle() %></option>
                        <% } %>
                    </select>
                    <button class="btn btn-soft" type="submit">Load Applications</button>
                </form>

                <% if (selectedJobApplications != null) {
                    if (selectedJobApplications.isEmpty()) { %>
                        <p style="color: var(--muted);">No applications for selected job yet.</p>
                    <% } else { %>
                        <table>
                            <thead><tr><th>Freelancer</th><th>Status</th><th>Action</th></tr></thead>
                            <tbody>
                            <% for (ApplicationRecord ar : selectedJobApplications) { %>
                                <tr>
                                    <td><strong><%= ar.getFreelancerName() %></strong><br/><small><%= ar.getFreelancerEmail() %></small></td>
                                    <td><span class="status"><%= ar.getApplicationStatus() %></span></td>
                                    <td>
                                        <div class="row-actions">
                                            <form method="post" action="${pageContext.request.contextPath}/client/jobs"><input type="hidden" name="action" value="updateApplicationStatus" /><input type="hidden" name="applicationId" value="<%= ar.getApplicationId() %>" /><input type="hidden" name="newStatus" value="SHORTLISTED" /><button class="btn btn-soft" type="submit">Shortlist</button></form>
                                            <form method="post" action="${pageContext.request.contextPath}/client/jobs"><input type="hidden" name="action" value="updateApplicationStatus" /><input type="hidden" name="applicationId" value="<%= ar.getApplicationId() %>" /><input type="hidden" name="newStatus" value="HIRED" /><button class="btn btn-primary" type="submit">Hire</button></form>
                                            <form method="post" action="${pageContext.request.contextPath}/client/jobs"><input type="hidden" name="action" value="updateApplicationStatus" /><input type="hidden" name="applicationId" value="<%= ar.getApplicationId() %>" /><input type="hidden" name="newStatus" value="REJECTED" /><button class="btn btn-danger" type="submit">Reject</button></form>
                                            <form method="post" action="${pageContext.request.contextPath}/client/jobs" class="compact"><input type="hidden" name="action" value="addFreelancerReview" /><input type="hidden" name="jobId" value="<%= ar.getJobId() %>" /><input type="hidden" name="revieweeUserId" value="<%= ar.getFreelancerId() %>" /><input class="input" type="number" name="rating" min="1" max="5" placeholder="Rating" required /><input class="input" type="text" name="comment" placeholder="Review" /><button class="btn btn-soft" type="submit">Save Review</button></form>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    <% }
                } %>

                <div class="section-title">Freelancer Search & Filter</div>
                <form method="get" action="${pageContext.request.contextPath}/client/jobs" class="compact" style="margin-bottom:10px;">
                    <input class="input" type="text" name="searchKeyword" placeholder="Name, headline, bio" value="${searchKeyword}" />
                    <input class="input" type="number" name="minYearsExperience" min="0" placeholder="Min years" value="${minYearsExperience}" />
                    <button class="btn btn-soft" type="submit">Search</button>
                </form>

                <% if (freelancers != null) {
                    if (freelancers.isEmpty()) { %>
                        <p style="color: var(--muted);">No freelancer profiles match current filters.</p>
                    <% } else { %>
                        <table>
                            <thead><tr><th>Freelancer</th><th>Experience</th><th>Rate (NPR/hr)</th></tr></thead>
                            <tbody>
                            <% for (java.util.Map<String, String> f : freelancers) { %>
                                <tr>
                                    <td><strong><%= f.get("fullName") %></strong><br/><small><%= f.get("headline") %></small><br/><small><%= f.get("email") %></small></td>
                                    <td><%= f.get("yearsExperience") %> years</td>
                                    <td><%= (f.get("hourlyRate") == null || f.get("hourlyRate").isBlank()) ? "N/A" : "NPR " + f.get("hourlyRate") %></td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    <% }
                } %>
            </div>
        </section>
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
