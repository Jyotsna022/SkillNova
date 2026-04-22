<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Register - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Spectral:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --red-900: #6a1018;
            --red-700: #991b1b;
            --red-600: #b91c1c;
            --red-100: #fee2e2;
            --bg: #fff7f7;
            --ink: #24191a;
            --muted: #7f5a5a;
            --border: #f2cccc;
            --white: #ffffff;
            --ok-bg: #dcfce7;
            --ok-fg: #166534;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            font-family: "Manrope", sans-serif;
            background:
                radial-gradient(circle at 85% 10%, #ffe8e8 0, transparent 35%),
                radial-gradient(circle at 15% 90%, #ffe4e4 0, transparent 30%),
                linear-gradient(145deg, #fffafa 0%, #fff1f1 100%);
            color: var(--ink);
            display: grid;
            place-items: center;
            padding: 20px;
        }

        .shell {
            width: 100%;
            max-width: 980px;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 18px;
            box-shadow: 0 18px 36px rgba(122, 28, 28, 0.12);
            overflow: hidden;
            display: grid;
            grid-template-columns: 1fr 1.15fr;
        }

        .left {
            padding: 30px;
            background: linear-gradient(170deg, #7f1118 0%, #aa1d24 60%, #cf2d34 100%);
            color: #ffe9e9;
        }

        .left .tag {
            display: inline-flex;
            gap: 6px;
            align-items: center;
            background: rgba(255, 255, 255, 0.2);
            padding: 6px 12px;
            border-radius: 999px;
            font-size: 0.8rem;
            margin-bottom: 14px;
        }

        .left h1 {
            font-family: "Spectral", serif;
            font-size: 2rem;
            line-height: 1.2;
            margin-bottom: 10px;
            color: #fff7f7;
        }

        .left p {
            line-height: 1.7;
            color: #ffd9d9;
            font-size: 0.95rem;
            margin-bottom: 22px;
        }

        .mini-list {
            list-style: none;
            display: grid;
            gap: 10px;
            font-size: 0.9rem;
        }

        .mini-list li {
            display: flex;
            gap: 8px;
            align-items: center;
        }

        .right {
            padding: 30px;
        }

        .title {
            font-family: "Spectral", serif;
            font-size: 1.8rem;
            margin-bottom: 6px;
        }

        .subtitle {
            color: var(--muted);
            margin-bottom: 16px;
            font-size: 0.95rem;
        }

        .alert {
            padding: 10px 12px;
            border-radius: 10px;
            margin-bottom: 14px;
            font-size: 0.9rem;
        }

        .alert.error { background: #fee2e2; color: #9b1c1c; border: 1px solid #fecaca; }
        .alert.success { background: var(--ok-bg); color: var(--ok-fg); border: 1px solid #bbf7d0; }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 12px;
        }

        .field { margin-bottom: 12px; }

        label {
            display: block;
            margin-bottom: 6px;
            font-size: 0.85rem;
            font-weight: 700;
            color: #5d2323;
        }

        input, select {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 11px;
            font-family: inherit;
            outline: none;
        }

        input:focus, select:focus { border-color: #de7f7f; box-shadow: 0 0 0 3px #ffe8e8; }

        .full { grid-column: 1 / -1; }

        button {
            margin-top: 4px;
            width: 100%;
            border: 0;
            border-radius: 10px;
            padding: 12px;
            font-weight: 800;
            background: linear-gradient(135deg, var(--red-700), var(--red-600));
            color: white;
            cursor: pointer;
        }

        .links {
            margin-top: 14px;
            display: flex;
            justify-content: space-between;
            font-size: 0.9rem;
        }

        .links a { text-decoration: none; color: var(--red-700); }

        @media (max-width: 900px) {
            .shell { grid-template-columns: 1fr; }
            .left { display: none; }
        }

        @media (max-width: 620px) {
            .grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<section class="shell">
    <aside class="left">
        <div class="tag"><span class="material-symbols-rounded">group_add</span> Join Team SkillNova</div>
        <h1>Build your trusted freelance identity</h1>
        <p>Register as a client or freelancer. Your profile will be reviewed by admin before activation.</p>
        <ul class="mini-list">
            <li><span class="material-symbols-rounded">verified_user</span> Secure account approval flow</li>
            <li><span class="material-symbols-rounded">work_history</span> Track applications and job progress</li>
            <li><span class="material-symbols-rounded">star_rate</span> Reputation through real ratings</li>
        </ul>
    </aside>

    <div class="right">
        <h2 class="title">Create Account</h2>
        <p class="subtitle">Fill in your details to start using SkillNova.</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert error"><%= request.getAttribute("error") %></div>
        <% } %>
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert success"><%= request.getAttribute("success") %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/register">
            <div class="grid">
                <div class="field full">
                    <label for="fullName">Full Name</label>
                    <input id="fullName" type="text" name="fullName" value="${fullName}" required />
                </div>

                <div class="field full">
                    <label for="email">Email Address</label>
                    <input id="email" type="email" name="email" value="${email}" required />
                </div>

                <div class="field">
                    <label for="phone">Phone Number</label>
                    <input id="phone" type="text" name="phone" value="${phone}" required />
                </div>

                <div class="field">
                    <label for="role">Role</label>
                    <select id="role" name="role" required>
                        <option value="CLIENT" ${role == 'CLIENT' ? 'selected' : ''}>Client</option>
                        <option value="FREELANCER" ${role == 'FREELANCER' ? 'selected' : ''}>Freelancer</option>
                    </select>
                </div>

                <div class="field">
                    <label for="password">Password</label>
                    <input id="password" type="password" name="password" required />
                </div>

                <div class="field">
                    <label for="confirmPassword">Confirm Password</label>
                    <input id="confirmPassword" type="password" name="confirmPassword" required />
                </div>
            </div>

            <button type="submit">Submit for Approval</button>
        </form>

        <div class="links">
            <a href="${pageContext.request.contextPath}/login">Already have an account?</a>
            <a href="${pageContext.request.contextPath}/">Back home</a>
        </div>
    </div>
</section>
</body>
</html>
