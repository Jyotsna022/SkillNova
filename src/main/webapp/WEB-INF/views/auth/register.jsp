<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Create Account - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Space+Grotesk:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --bg: #f2f1f6;
            --panel: #f3f2f7;
            --line: #c6c7d1;
            --ink: #121836;
            --muted: #555d70;
            --deep: #06034f;
            --teal: #045c55;
            --danger-bg: #ffe8ec;
            --danger-text: #c4365a;
            --success-bg: #e8f8ef;
            --success-text: #1c6f42;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: "Manrope", sans-serif; background: var(--bg); color: var(--ink); }

        .topbar {
            position: sticky;
            top: 0;
            z-index: 60;
            height: 88px;
            background: #f6f5fa;
            border-bottom: 1px solid #d7d8e1;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 48px;
        }

        .brand { font-family: "Space Grotesk", sans-serif; font-size: 2.2rem; font-weight: 700; color:#121836; }
        .nav { display: flex; align-items: center; gap: 40px; }
        .nav a { text-decoration: none; color: #232a3f; font-weight: 600; transition: color .2s ease; white-space: nowrap; }
        .nav a:hover { color: #0a8575; }
        .actions { display: flex; align-items: center; gap: 22px; }
        .actions a { text-decoration: none; color: #22283f; font-weight: 600; transition: color .2s ease; }
        .actions a:hover { color: #0a8575; }
        .signup-btn { background: var(--deep); color: #fff !important; border-radius: 12px; padding: 12px 26px; }

        .layout { min-height: calc(100vh - 88px - 84px); display: grid; grid-template-columns: 50% 50%; }

        .hero {
            color: #eaf2ff;
            padding: 62px 64px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background:
                linear-gradient(180deg, rgba(4, 9, 84, 0.5), rgba(2, 25, 73, 0.72)),
                radial-gradient(1000px 450px at 70% 20%, rgba(55, 171, 255, 0.3), transparent 70%),
                linear-gradient(145deg, #01055e 0%, #03254f 45%, #056464 100%);
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            border: 1px solid rgba(100, 239, 236, 0.24);
            color: #90fff4;
            background: rgba(0, 111, 124, 0.26);
            border-radius: 999px;
            padding: 9px 16px;
            margin-bottom: 28px;
            font-size: 0.95rem;
            font-weight: 700;
            width: fit-content;
        }

        .hero h1 { font-family: "Space Grotesk", sans-serif; font-size: clamp(2.2rem, 5.1vw, 4rem); line-height: 1.05; margin-bottom: 20px; }
        .hero p { max-width: 620px; font-size: 1.1rem; line-height: 1.6; color: #c8dbff; margin-bottom: 34px; }

        .stats { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; max-width: 740px; }
        .stat { border: 1px solid rgba(188, 234, 255, 0.22); border-radius: 16px; background: rgba(23, 61, 102, 0.35); padding: 24px 28px; }
        .stat strong { display: block; color: #89fff4; font-size: 2rem; margin-bottom: 8px; }
        .stat span { color: #d7e4ff; font-size: 1.03rem; }

        .form-side { background: var(--panel); border-left: 1px solid #d7d8e1; padding: 72px 52px 52px; }
        .form-wrap { max-width: 620px; margin: 0 auto; }
        .form-wrap h2 { font-family: "Space Grotesk", sans-serif; font-size: clamp(2rem, 4vw, 3.2rem); margin-bottom: 8px; }
        .sub { color: #3d4459; font-size: 1.12rem; margin-bottom: 28px; }

        .alert { margin-bottom: 14px; padding: 11px 12px; border-radius: 10px; font-size: 0.9rem; }
        .alert.error { background: var(--danger-bg); border: 1px solid #ffc8d5; color: var(--danger-text); }
        .alert.success { background: var(--success-bg); border: 1px solid #bfead0; color: var(--success-text); }

        .role-box { display: grid; grid-template-columns: 1fr 1fr; border: 1px solid var(--line); border-radius: 14px; padding: 6px; gap: 6px; margin-bottom: 20px; }
        .role {
            min-height: 72px;
            border-radius: 11px;
            border: 0;
            background: transparent;
            color: #1d2438;
            font-size: 1.05rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            cursor: pointer;
        }
        .role.active { background: #fff; box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06); }

        .divider { margin: 18px 0 22px; display: flex; align-items: center; gap: 12px; color: #424a5d; font-size: 0.95rem; letter-spacing: 1.1px; text-transform: uppercase; }
        .divider::before, .divider::after { content: ""; height: 1px; background: #caccd5; flex: 1; }

        .grid { display: grid; grid-template-columns: 1fr; gap: 14px; }
        label { display: block; margin-bottom: 8px; font-weight: 600; color: #232a3f; font-size: 1.02rem; }
        input, textarea {
            width: 100%; border: 1px solid #babfcc; border-radius: 12px; min-height: 62px;
            padding: 0 18px; font-size: 1.02rem; color: #1e2437; background: #f7f7fa;
            outline: none; font-family: inherit;
        }
        textarea { min-height: 110px; padding: 14px 16px; resize: vertical; }
        input:focus, textarea:focus { border-color: #95a8e9; box-shadow: 0 0 0 3px #e5eafc; }
        .hint { margin-top: 8px; color: #595f70; font-size: 0.95rem; }

        .freelancer-only { display: none; }
        .freelancer-only.show { display: block; }

        .terms { margin: 18px 0 26px; display: flex; align-items: flex-start; gap: 12px; color: #2e3548; font-size: 1rem; }
        .terms input { width: 22px; min-height: 22px; margin-top: 2px; accent-color: var(--deep); }
        .terms a { color: var(--teal); font-weight: 700; text-decoration: none; }

        .submit {
            width: 100%; min-height: 78px; border: 0; border-radius: 16px; background: var(--deep);
            color: #fff; font-weight: 800; font-size: 1.6rem; cursor: pointer; margin-top: 16px;
        }

        .signin { margin-top: 24px; text-align: center; color: #2f364a; font-size: 1.02rem; }
        .signin a { color: var(--teal); text-decoration: none; font-weight: 800; }

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

        @media (max-width: 1100px) {
            .topbar { height: auto; padding: 16px; flex-wrap: wrap; gap: 12px; }
            .layout { grid-template-columns: 1fr; }
            .hero { min-height: 420px; padding: 34px 28px; }
            .form-side { border-left: 0; border-top: 1px solid #d7d8e1; padding: 34px 20px; }
            .footer-top { grid-template-columns:1fr; }
        }

        @media (max-width: 640px) {
            .brand { font-size: 1.7rem; }
            .nav { gap: 14px; font-size: 0.92rem; }
            .stats { grid-template-columns: 1fr; }
            .role-box { grid-template-columns: 1fr; }
            .submit { min-height: 62px; font-size: 1.15rem; }
        }
    </style>
</head>
<body>
<header class="topbar">
    <div class="brand">SkillNova</div>
    <nav class="nav">
        <a href="${pageContext.request.contextPath}/register?role=FREELANCER">Find Work</a>
        <a href="${pageContext.request.contextPath}/register?role=CLIENT">Hire Talent</a>
        <a href="${pageContext.request.contextPath}/about.jsp">About</a>
        <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
    </nav>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/login">Log In</a>
        <a class="signup-btn" href="${pageContext.request.contextPath}/register">Sign Up</a>
    </div>
</header>

<main class="layout">
    <section class="hero">
        <div class="badge"><span class="material-symbols-rounded">auto_awesome</span> Top 1% Global Talent Pool</div>
        <h1>Join the world's work marketplace</h1>
        <p>Connect with millions of talented professionals and growing businesses to get your best work done.</p>
        <div class="stats">
            <article class="stat"><strong>4.9/5</strong><span>Client Satisfaction</span></article>
            <article class="stat"><strong>200+</strong><span>Unique Skillsets</span></article>
        </div>
    </section>

    <section class="form-side">
        <div class="form-wrap">
            <h2>Get started</h2>
            <p class="sub">Create your SkillNova account and start building.</p>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert error"><%= request.getAttribute("error") %></div>
            <% } %>
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert success"><%= request.getAttribute("success") %></div>
            <% } %>

            <form method="post" action="${pageContext.request.contextPath}/register">
                <input type="hidden" name="role" id="role" value="${empty role ? 'CLIENT' : role}" />

                <div class="role-box">
                    <button class="role" type="button" data-role="CLIENT"><span class="material-symbols-rounded">person</span>Join as a Client</button>
                    <button class="role" type="button" data-role="FREELANCER"><span class="material-symbols-rounded">work</span>Join as a Freelancer</button>
                </div>

                <div class="divider">Or signup with email</div>

                <div class="grid">
                    <div class="field">
                        <label for="fullName">Full Name</label>
                        <input id="fullName" type="text" name="fullName" placeholder="Jane Doe" value="${fullName}" required />
                    </div>
                    <div class="field">
                        <label for="email">Email Address</label>
                        <input id="email" type="email" name="email" placeholder="jane@example.com" value="${email}" required />
                    </div>
                    <div class="field">
                        <label for="phone">Phone Number</label>
                        <input id="phone" type="text" name="phone" placeholder="94771234567" value="${phone}" required />
                    </div>

                    <div class="field freelancer-only" data-freelancer="true">
                        <label for="headline">Professional Headline</label>
                        <input id="headline" type="text" name="headline" value="${headline}" placeholder="Full Stack Developer" />
                    </div>
                    <div class="field freelancer-only" data-freelancer="true">
                        <label for="yearsExperience">Years of Experience</label>
                        <input id="yearsExperience" type="number" min="0" name="yearsExperience" value="${yearsExperience}" placeholder="5" />
                    </div>
                    <div class="field freelancer-only" data-freelancer="true">
                        <label for="hourlyRate">Hourly Rate</label>
                        <input id="hourlyRate" type="number" min="0" step="0.01" name="hourlyRate" value="${hourlyRate}" placeholder="20.00" />
                    </div>
                    <div class="field freelancer-only" data-freelancer="true">
                        <label for="bio">Bio</label>
                        <textarea id="bio" name="bio" placeholder="Share your expertise and experience">${bio}</textarea>
                    </div>

                    <div class="field">
                        <label for="password">Password</label>
                        <input id="password" type="password" name="password" placeholder="........" required />
                        <div class="hint">Must be at least 8 characters</div>
                    </div>
                    <div class="field">
                        <label for="confirmPassword">Confirm Password</label>
                        <input id="confirmPassword" type="password" name="confirmPassword" placeholder="........" required />
                    </div>
                </div>

                <label class="terms" for="agreeTerms">
                    <input id="agreeTerms" type="checkbox" required />
                    <span>I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>.</span>
                </label>

                <button class="submit" type="submit">Create my account</button>
            </form>

            <div class="signin">Already have an account? <a href="${pageContext.request.contextPath}/login">Log In</a></div>
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

<script>
    (function () {
        const roleInput = document.getElementById("role");
        const roleButtons = document.querySelectorAll(".role[data-role]");
        const freelancerFields = document.querySelectorAll("[data-freelancer='true']");

        function syncRole(role) {
            roleInput.value = role;
            roleButtons.forEach((button) => {
                button.classList.toggle("active", button.dataset.role === role);
            });
            freelancerFields.forEach((el) => {
                if (role === "FREELANCER") {
                    el.classList.add("show");
                } else {
                    el.classList.remove("show");
                }
            });
        }

        roleButtons.forEach((button) => {
            button.addEventListener("click", function () {
                syncRole(button.dataset.role);
            });
        });

        syncRole(roleInput.value === "FREELANCER" ? "FREELANCER" : "CLIENT");
    })();
</script>
</body>
</html>
