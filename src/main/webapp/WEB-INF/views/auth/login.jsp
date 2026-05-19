<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Space+Grotesk:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --page: #f4f3f8;
            --ink: #131827;
            --muted: #545d70;
            --line: #bfc6d3;
            --deep: #07084b;
            --deep-2: #11145f;
            --mint: #24cfc4;
            --danger-bg: #ffe8ec;
            --danger-text: #c4365a;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: "Manrope", sans-serif;
            background: var(--page);
            color: var(--ink);
        }

        .topbar {
            position: sticky;
            top: 0;
            z-index: 50;
            height: 72px;
            background: rgba(246, 245, 250, 0.94);
            border-bottom: 1px solid #d7d8e1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 14px;
            padding: 0 20px;
        }

        .brand-top {
            font-family: "Space Grotesk", sans-serif;
            font-size: 1.75rem;
            font-weight: 700;
            color: #0d1045;
            text-decoration: none;
        }

        .top-links {
            display: flex;
            align-items: center;
            gap: 24px;
            flex-wrap: wrap;
            margin: 0 auto;
        }

        .top-links a {
            color: #2e3550;
            text-decoration: none;
            font-weight: 700;
            font-size: 0.93rem;
            transition: color .2s ease;
            white-space: nowrap;
        }

        .top-links a:hover {
            color: #0a8575;
        }

        .layout {
            min-height: calc(100vh - 72px - 72px);
            display: grid;
            grid-template-columns: 47.5% 52.5%;
        }

        .promo {
            position: relative;
            color: #ecf2ff;
            padding: 52px 54px;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            background:
                linear-gradient(180deg, rgba(7, 10, 66, 0.48), rgba(5, 7, 58, 0.8)),
                radial-gradient(900px 350px at 70% 20%, rgba(74, 181, 255, 0.22), transparent 65%),
                linear-gradient(155deg, #071067, #030641 62%, #05064e);
            overflow: hidden;
        }

        .promo::before {
            content: "";
            position: absolute;
            inset: 0;
            background:
                radial-gradient(circle at 25% 30%, rgba(159, 210, 255, 0.2), transparent 40%),
                repeating-radial-gradient(circle at 70% 75%, rgba(105, 144, 255, 0.08) 0 2px, transparent 2px 20px);
            pointer-events: none;
        }

        .promo-content {
            position: relative;
            z-index: 1;
            max-width: 560px;
        }

        .promo h2 {
            font-family: "Space Grotesk", sans-serif;
            font-size: clamp(2rem, 4.2vw, 3.35rem);
            line-height: 1.1;
            margin-bottom: 14px;
        }

        .promo p {
            color: #d8e0fa;
            line-height: 1.55;
            font-size: 1rem;
            margin-bottom: 26px;
        }

        .trusted {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #8df3e8;
            font-weight: 700;
            font-size: 0.95rem;
        }

        .avatars {
            display: flex;
        }

        .avatars span {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            border: 2px solid #071054;
            margin-right: -8px;
            background: linear-gradient(135deg, #d7e7ff, #a7c1ef);
            color: #0e2854;
            display: grid;
            place-items: center;
            font-size: 0.73rem;
            font-weight: 800;
        }

        .form-side {
            padding: 82px 64px 48px;
            display: flex;
            align-items: flex-start;
            justify-content: center;
        }

        .card {
            width: min(560px, 100%);
        }

        .brand {
            font-family: "Space Grotesk", sans-serif;
            font-size: 2.35rem;
            margin-bottom: 22px;
            color: #0d1045;
        }

        .card h1 {
            font-family: "Space Grotesk", sans-serif;
            font-size: clamp(2rem, 3.1vw, 2.95rem);
            margin-bottom: 8px;
        }

        .sub {
            color: var(--muted);
            font-size: 1.03rem;
            margin-bottom: 28px;
        }

        .alert {
            margin-bottom: 14px;
            padding: 11px 12px;
            border-radius: 10px;
            font-size: 0.9rem;
            background: var(--danger-bg);
            border: 1px solid #ffc8d5;
            color: var(--danger-text);
        }

        .field {
            margin-bottom: 16px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 700;
            font-size: 1rem;
        }

        .input {
            width: 100%;
            border: 1px solid #bcc4d3;
            border-radius: 12px;
            height: 62px;
            padding: 0 18px;
            font-size: 1rem;
            background: #fff;
            color: #1d2538;
            outline: none;
        }

        .input:focus {
            border-color: #7a9eff;
            box-shadow: 0 0 0 3px #e7eeff;
        }

        .row {
            margin-top: 10px;
            margin-bottom: 18px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 12px;
            flex-wrap: wrap;
        }

        .remember {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            color: #333c53;
            font-size: 1.02rem;
        }

        .remember input {
            width: 24px;
            height: 24px;
            border: 1px solid #b9c1d1;
        }

        .forgot {
            color: #00675f;
            text-decoration: none;
            font-weight: 700;
            font-size: 1.01rem;
        }

        .submit {
            width: 100%;
            border: 0;
            border-radius: 12px;
            height: 68px;
            font-weight: 800;
            font-size: 1.2rem;
            color: #fff;
            background: linear-gradient(180deg, var(--deep-2), var(--deep));
            cursor: pointer;
        }

        .signup {
            text-align: center;
            font-size: 1rem;
            color: #30384f;
        }

        .signup a {
            color: #046a63;
            text-decoration: none;
            font-weight: 800;
        }

        .site-footer { background:#f4f3f7; border-top:1px solid #dbdee8; padding:28px 0 14px; }
        .footer-wrap { width:min(1240px,100% - 34px); margin:0 auto; }
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


        @media (max-width: 1120px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .promo {
                min-height: 360px;
            }

            .form-side {
                padding-top: 42px;
            }
        }

        @media (max-width: 720px) {
            .promo {
                padding: 26px 18px;
                min-height: 300px;
            }

            .form-side {
                padding: 24px 16px 30px;
            }

            .brand {
                font-size: 1.9rem;
            }

        }
    </style>
</head>
<body>
<header class="topbar">
    <a class="brand-top" href="${pageContext.request.contextPath}/">SkillNova</a>
    <nav class="top-links">
        <a href="${pageContext.request.contextPath}/register?role=FREELANCER">Find Work</a>
        <a href="${pageContext.request.contextPath}/register?role=CLIENT">Hire Talent</a>
        <a href="${pageContext.request.contextPath}/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
        <a href="${pageContext.request.contextPath}/register">Sign up</a>
    </nav>
</header>

<main class="layout">
    <section class="promo">
        <div class="promo-content">
            <h2>Empower your career trajectory.</h2>
            <p>Join the elite network of talent and global enterprises. Access high-value contracts and secure collaborations built on trust.</p>
            <div class="trusted">
                <div class="avatars"><span>A</span><span>B</span><span>+2k</span></div>
                Trusted by 2,000+ top enterprises
            </div>
        </div>
    </section>

    <section class="form-side">
        <div class="card">
            <div class="brand">SkillNova</div>
            <h1>Welcome back</h1>
            <p class="sub">Please enter your credentials to access your dashboard.</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert"><%= request.getAttribute("error") %></div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/login">
                <div class="field">
                    <label for="email">Email Address</label>
                    <input class="input" id="email" type="email" name="email" value="${email}" placeholder="name@company.com" required />
                </div>

                <div class="field">
                    <label for="password">Password</label>
                    <input class="input" id="password" type="password" name="password" placeholder="••••••••" required />
                </div>

                <div class="row">
                    <label class="remember" for="rememberMe">
                        <input id="rememberMe" type="checkbox" name="rememberMe" ${rememberChecked ? 'checked' : ''} />
                        Remember me
                    </label>
                    <a class="forgot" href="#">Forgot password?</a>
                </div>

                <button class="submit" type="submit">Log In</button>
            </form>

            <div class="signup">Don't have an account? <a href="${pageContext.request.contextPath}/register">Sign Up for free</a></div>
        </div>
    </section>
</main>

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

</body>
</html>
