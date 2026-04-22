<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

        @media (max-width: 780px) {
            th:nth-child(3), td:nth-child(3), th:nth-child(4), td:nth-child(4) {
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
            <div class="label">Current module stage</div>
            <div class="value">M1</div>
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
            <table>
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
                            </div>
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        <% } %>
    </section>
</main>
</body>
</html>
