<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Dashboard - SkillNova</title>
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
            max-width: 1080px;
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
    </style>
</head>
<body>
<header class="topbar">
    <div class="brand"><span>Skill</span>Nova Dashboard</div>
    <a class="logout" href="${pageContext.request.contextPath}/logout">Logout</a>
</header>

<main class="layout">
    <section class="hero">
        <h1>Hello, ${fullName}</h1>
        <p>You are logged in as <strong>${role}</strong>. Route: <strong>${dashboardPath}</strong></p>
    </section>

    <section class="grid">
        <article class="card">
            <div class="meta"><span class="material-symbols-rounded">person</span> Account</div>
            <div class="value">Active</div>
        </article>
        <article class="card">
            <div class="meta"><span class="material-symbols-rounded">task_alt</span> Status</div>
            <div class="value">Ready</div>
        </article>
        <article class="card">
            <div class="meta"><span class="material-symbols-rounded">hub</span> Module</div>
            <div class="value">Milestone 1</div>
        </article>
    </section>
</main>
</body>
</html>
