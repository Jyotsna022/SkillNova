<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Spectral:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --red-800: #7f1d1d;
            --red-700: #991b1b;
            --red-600: #b91c1c;
            --red-100: #fee2e2;
            --bg: #fff6f6;
            --ink: #24191a;
            --muted: #7f5a5a;
            --border: #f3c9c9;
            --white: #ffffff;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            min-height: 100vh;
            font-family: "Manrope", sans-serif;
            background: radial-gradient(circle at 20% 10%, #ffe9e9 0, transparent 32%), linear-gradient(155deg, #fffafa 0%, #fff1f1 100%);
            color: var(--ink);
            display: grid;
            place-items: center;
            padding: 20px;
        }

        .panel {
            width: 100%;
            max-width: 920px;
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 18px 34px rgba(127, 29, 29, 0.12);
            display: grid;
            grid-template-columns: 1.1fr 1fr;
        }

        .art {
            background: linear-gradient(170deg, #8f1515 0%, #c62525 65%, #de3b3b 100%);
            color: white;
            padding: 34px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .art h1 {
            font-family: "Spectral", serif;
            font-size: 2rem;
            line-height: 1.2;
            margin-bottom: 10px;
        }

        .art p { line-height: 1.7; color: #ffe0e0; }

        .chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,0.2);
            font-size: 0.8rem;
            width: fit-content;
        }

        .form-wrap {
            padding: 34px;
        }

        .title {
            font-family: "Spectral", serif;
            font-size: 1.8rem;
            margin-bottom: 8px;
        }

        .sub { color: var(--muted); margin-bottom: 22px; }

        .alert {
            margin-bottom: 16px;
            padding: 10px 12px;
            border-radius: 10px;
            font-size: 0.92rem;
        }

        .alert.error { background: #fee2e2; color: #9b1c1c; border: 1px solid #fecaca; }

        .field { margin-bottom: 14px; }

        .remember {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-top: 2px;
            margin-bottom: 12px;
            color: #6f4e4e;
            font-size: 0.88rem;
        }

        .remember input {
            width: auto;
            margin: 0;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-size: 0.88rem;
            font-weight: 700;
            color: #5d2323;
        }

        input {
            width: 100%;
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 12px;
            font-family: inherit;
            outline: none;
        }

        input:focus { border-color: #dd7c7c; box-shadow: 0 0 0 3px #ffe5e5; }

        button {
            width: 100%;
            margin-top: 8px;
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

        .links a { color: var(--red-700); text-decoration: none; }

        @media (max-width: 850px) {
            .panel { grid-template-columns: 1fr; }
            .art { display: none; }
        }
    </style>
</head>
<body>
<section class="panel">
    <aside class="art">
        <div>
            <div class="chip"><span class="material-symbols-rounded">rocket_launch</span> SkillNova Access</div>
            <h1>Welcome Back to the Hiring Engine</h1>
            <p>Sign in to manage jobs, review applications, and monitor marketplace activity in real time.</p>
        </div>
        <p>CS5054NT · Team SkillNova</p>
    </aside>

    <div class="form-wrap">
        <h2 class="title">Sign In</h2>
        <p class="sub">Continue with your approved account credentials.</p>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert error"><%= request.getAttribute("error") %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/login">
            <div class="field">
                <label for="email">Email Address</label>
                <input id="email" type="email" name="email" value="${email}" required />
            </div>
            <div class="field">
                <label for="password">Password</label>
                <input id="password" type="password" name="password" required />
            </div>
            <label class="remember" for="rememberMe">
                <input id="rememberMe" type="checkbox" name="rememberMe" ${rememberChecked ? 'checked' : ''} />
                Keep me signed in on this device
            </label>
            <button type="submit">Sign In</button>
        </form>

        <div class="links">
            <a href="${pageContext.request.contextPath}/register">Create account</a>
            <a href="${pageContext.request.contextPath}/">Back home</a>
        </div>
    </div>
</section>
</body>
</html>
