<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillnova.model.Job" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Client Job Management - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Spectral:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --red-700: #991b1b;
            --red-600: #b91c1c;
            --ink: #2a1a1b;
            --muted: #7b5b5b;
            --border: #efc9c9;
            --white: #fff;
            --ok-bg: #dcfce7;
            --ok-fg: #166534;
            --err-bg: #fee2e2;
            --err-fg: #9b1c1c;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Manrope", sans-serif;
            background: radial-gradient(circle at 80% 12%, #ffe8e8 0, transparent 34%), linear-gradient(150deg, #fffafa 0%, #fff1f1 100%);
            color: var(--ink);
        }

        .topbar {
            height: 64px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 18px;
            border-bottom: 1px solid var(--border);
            background: rgba(255,255,255,0.86);
            backdrop-filter: blur(8px);
            position: sticky;
            top: 0;
        }

        .brand {
            font-family: "Spectral", serif;
            font-size: 1.3rem;
            font-weight: 700;
        }

        .brand span { color: var(--red-600); }

        .top-actions {
            display: flex;
            gap: 8px;
        }

        .link-btn {
            text-decoration: none;
            border-radius: 9px;
            border: 1px solid #eabebe;
            background: #fff7f7;
            color: var(--red-700);
            padding: 8px 12px;
            font-weight: 700;
            font-size: 0.86rem;
        }

        .layout {
            max-width: 1150px;
            margin: 18px auto;
            padding: 0 14px;
        }

        .hero {
            background: linear-gradient(130deg, #7f1118 0%, #a71d24 52%, #cb2e35 100%);
            color: #ffe8e8;
            border-radius: 16px;
            padding: 22px;
            margin-bottom: 14px;
        }

        .hero h1 {
            font-family: "Spectral", serif;
            margin-bottom: 6px;
            font-size: 1.85rem;
        }

        .hero p { color: #ffd6d6; }

        .grid {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 12px;
        }

        .card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 12px;
            box-shadow: 0 8px 16px rgba(127,29,29,0.06);
        }

        .card-head {
            border-bottom: 1px solid var(--border);
            padding: 12px;
            font-weight: 800;
            color: #6b1d1d;
            display: flex;
            align-items: center;
            gap: 7px;
        }

        .card-body { padding: 12px; }

        .field { margin-bottom: 10px; }

        label {
            display: block;
            margin-bottom: 4px;
            font-size: 0.82rem;
            font-weight: 700;
            color: #5e2424;
        }

        input, textarea, select {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 9px;
            font-family: inherit;
            outline: none;
        }

        textarea { min-height: 96px; resize: vertical; }

        .two-col {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
        }

        .btn {
            border: 0;
            border-radius: 8px;
            padding: 10px;
            font-weight: 800;
            cursor: pointer;
            width: 100%;
        }

        .btn-primary {
            background: linear-gradient(130deg, var(--red-700), var(--red-600));
            color: #fff;
        }

        .btn-soft {
            background: #fff2f2;
            color: var(--red-700);
            border: 1px solid #efc5c5;
        }

        .alert {
            margin-bottom: 10px;
            padding: 10px;
            border-radius: 9px;
            font-size: 0.88rem;
        }

        .alert.success { background: var(--ok-bg); color: var(--ok-fg); border: 1px solid #bbf7d0; }
        .alert.error { background: var(--err-bg); color: var(--err-fg); border: 1px solid #fecaca; }

        table { width: 100%; border-collapse: collapse; }

        th, td {
            text-align: left;
            padding: 10px;
            border-bottom: 1px solid #f6dfdf;
            font-size: 0.88rem;
            vertical-align: top;
        }

        th {
            background: #fff5f5;
            color: #6c2323;
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .status {
            display: inline-flex;
            padding: 4px 8px;
            border-radius: 999px;
            border: 1px solid #f1cbcb;
            background: #fff1f1;
            color: #8f2727;
            font-size: 0.75rem;
            font-weight: 700;
        }

        .row-actions {
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .inline {
            display: inline;
        }

        @media (max-width: 980px) {
            .grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<header class="topbar">
    <div class="brand"><span>Skill</span>Nova Client</div>
    <div class="top-actions">
        <a class="link-btn" href="${pageContext.request.contextPath}/client/dashboard">Dashboard</a>
        <a class="link-btn" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</header>

<main class="layout">
    <section class="hero">
        <h1>Job Management Workspace</h1>
        <p>Create, update, view, and remove your job posts from one place.</p>
    </section>

    <% if (request.getAttribute("success") != null) { %>
    <div class="alert success"><%= request.getAttribute("success") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
    <div class="alert error"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="grid">
        <section class="card">
            <div class="card-head">
                <span class="material-symbols-rounded">work</span>
                ${editJob != null ? 'Edit Job' : 'Create New Job'}
            </div>
            <div class="card-body">
                <% Job editJob = (Job) request.getAttribute("editJob"); %>
                <form method="post" action="${pageContext.request.contextPath}/client/jobs">
                    <input type="hidden" name="action" value="${editJob != null ? 'update' : 'create'}" />
                    <% if (editJob != null) { %>
                        <input type="hidden" name="jobId" value="<%= editJob.getJobId() %>" />
                    <% } %>

                    <div class="field">
                        <label for="jobTitle">Job Title</label>
                        <input id="jobTitle" name="jobTitle" type="text" value="<%= editJob != null ? editJob.getJobTitle() : "" %>" required />
                    </div>
                    <div class="field">
                        <label for="jobDescription">Job Description</label>
                        <textarea id="jobDescription" name="jobDescription" required><%= editJob != null ? editJob.getJobDescription() : "" %></textarea>
                    </div>

                    <div class="two-col">
                        <div class="field">
                            <label for="budgetMin">Budget Min</label>
                            <input id="budgetMin" name="budgetMin" type="number" step="0.01" min="0" value="<%= editJob != null ? editJob.getBudgetMin() : "" %>" required />
                        </div>
                        <div class="field">
                            <label for="budgetMax">Budget Max</label>
                            <input id="budgetMax" name="budgetMax" type="number" step="0.01" min="0" value="<%= editJob != null ? editJob.getBudgetMax() : "" %>" required />
                        </div>
                    </div>

                    <div class="two-col">
                        <div class="field">
                            <label for="experienceLevel">Experience Level</label>
                            <select id="experienceLevel" name="experienceLevel" required>
                                <option value="ENTRY" <%= editJob != null && "ENTRY".equals(editJob.getExperienceLevel()) ? "selected" : "" %>>Entry</option>
                                <option value="INTERMEDIATE" <%= editJob != null && "INTERMEDIATE".equals(editJob.getExperienceLevel()) ? "selected" : "" %>>Intermediate</option>
                                <option value="EXPERT" <%= editJob != null && "EXPERT".equals(editJob.getExperienceLevel()) ? "selected" : "" %>>Expert</option>
                            </select>
                        </div>
                        <div class="field">
                            <label for="locationType">Location Type</label>
                            <select id="locationType" name="locationType" required>
                                <option value="REMOTE" <%= editJob != null && "REMOTE".equals(editJob.getLocationType()) ? "selected" : "" %>>Remote</option>
                                <option value="ONSITE" <%= editJob != null && "ONSITE".equals(editJob.getLocationType()) ? "selected" : "" %>>Onsite</option>
                                <option value="HYBRID" <%= editJob != null && "HYBRID".equals(editJob.getLocationType()) ? "selected" : "" %>>Hybrid</option>
                            </select>
                        </div>
                    </div>

                    <% if (editJob != null) { %>
                        <div class="field">
                            <label for="jobStatus">Job Status</label>
                            <select id="jobStatus" name="jobStatus" required>
                                <option value="OPEN" <%= "OPEN".equals(editJob.getJobStatus()) ? "selected" : "" %>>Open</option>
                                <option value="CLOSED" <%= "CLOSED".equals(editJob.getJobStatus()) ? "selected" : "" %>>Closed</option>
                                <option value="CANCELLED" <%= "CANCELLED".equals(editJob.getJobStatus()) ? "selected" : "" %>>Cancelled</option>
                            </select>
                        </div>
                    <% } %>

                    <button class="btn btn-primary" type="submit">${editJob != null ? 'Update Job' : 'Post Job'}</button>
                </form>

                <% if (editJob != null) { %>
                    <form method="get" action="${pageContext.request.contextPath}/client/jobs" style="margin-top: 8px;">
                        <button class="btn btn-soft" type="submit">Cancel Edit</button>
                    </form>
                <% } %>
            </div>
        </section>

        <section class="card">
            <div class="card-head">
                <span class="material-symbols-rounded">view_list</span>
                Your Posted Jobs
            </div>
            <div class="card-body">
                <%
                    List<Job> jobs = (List<Job>) request.getAttribute("jobs");
                    if (jobs == null || jobs.isEmpty()) {
                %>
                <p style="color: var(--muted);">No jobs posted yet. Use the form to create your first job.</p>
                <% } else { %>
                <table>
                    <thead>
                    <tr>
                        <th>Title</th>
                        <th>Budget</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% for (Job job : jobs) { %>
                        <tr>
                            <td>
                                <strong><%= job.getJobTitle() %></strong><br/>
                                <small><%= job.getExperienceLevel() %> · <%= job.getLocationType() %></small>
                            </td>
                            <td><%= job.getBudgetMin() %> - <%= job.getBudgetMax() %></td>
                            <td><span class="status"><%= job.getJobStatus() %></span></td>
                            <td>
                                <div class="row-actions">
                                    <a class="link-btn" href="${pageContext.request.contextPath}/client/jobs?action=edit&jobId=<%= job.getJobId() %>">Edit</a>
                                    <form class="inline" method="post" action="${pageContext.request.contextPath}/client/jobs">
                                        <input type="hidden" name="action" value="delete" />
                                        <input type="hidden" name="jobId" value="<%= job.getJobId() %>" />
                                        <button class="link-btn" type="submit" onclick="return confirm('Delete this job?');">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                    </tbody>
                </table>
                <% } %>
            </div>
        </section>
    </div>
</main>
</body>
</html>
