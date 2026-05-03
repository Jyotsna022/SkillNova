<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SkillNova - Freelance Job Marketplace</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Spectral:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --red-900: #5f0f18;
            --red-800: #7f1d1d;
            --red-700: #991b1b;
            --red-600: #b91c1c;
            --red-500: #dc2626;
            --red-100: #fee2e2;
            --red-50: #fef2f2;
            --white: #ffffff;
            --ink: #1f1a1b;
            --muted: #6b4b4b;
            --border: #f1c7c7;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: "Manrope", "Segoe UI", sans-serif;
            color: var(--ink);
            background:
                radial-gradient(circle at 10% 10%, #fff5f5 0, transparent 42%),
                radial-gradient(circle at 90% 25%, #ffeaea 0, transparent 40%),
                linear-gradient(160deg, #fffdfd 0%, #fff4f4 55%, #ffefef 100%);
            min-height: 100vh;
        }

        nav {
            height: 66px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 22px;
            border-bottom: 1px solid var(--border);
            background: rgba(255, 255, 255, 0.82);
            backdrop-filter: blur(8px);
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .logo {
            font-family: "Spectral", Georgia, serif;
            font-size: 1.45rem;
            font-weight: 700;
            letter-spacing: 0.2px;
        }

        .logo span {
            color: var(--red-600);
        }

        .actions {
            display: flex;
            gap: 10px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 9px;
            font-size: 0.92rem;
            font-weight: 700;
            padding: 9px 16px;
            border: 1px solid transparent;
            text-decoration: none;
            transition: transform 0.2s ease, box-shadow 0.2s ease, background 0.2s ease;
            cursor: pointer;
        }

        .btn:hover {
            transform: translateY(-1px);
        }

        .btn-primary {
            background: linear-gradient(130deg, var(--red-600), var(--red-500));
            color: var(--white);
            box-shadow: 0 8px 16px rgba(185, 28, 28, 0.22);
        }

        .btn-outline {
            border-color: var(--red-600);
            color: var(--red-700);
            background: #fff7f7;
        }

        .hero {
            max-width: 980px;
            margin: 0 auto;
            padding: 72px 22px 46px;
            text-align: center;
            animation: rise 0.6s ease;
        }

        .badge {
            display: inline-block;
            margin-bottom: 20px;
            font-size: 0.74rem;
            letter-spacing: 0.8px;
            text-transform: uppercase;
            font-weight: 800;
            background: var(--red-100);
            color: var(--red-700);
            border: 1px solid #f8bcbc;
            padding: 6px 12px;
            border-radius: 999px;
        }

        h1 {
            font-family: "Spectral", Georgia, serif;
            font-size: clamp(2rem, 4vw, 3.2rem);
            line-height: 1.15;
            margin-bottom: 16px;
        }

        h1 span {
            color: var(--red-600);
        }

        .hero p {
            max-width: 640px;
            margin: 0 auto 30px;
            font-size: 1rem;
            line-height: 1.7;
            color: var(--muted);
        }

        .hero-cta {
            display: flex;
            justify-content: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .stats {
            max-width: 920px;
            margin: 10px auto 30px;
            padding: 18px;
            border: 1px solid var(--border);
            background: rgba(255, 255, 255, 0.8);
            border-radius: 14px;
        }

        .stats-inner {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 12px;
            text-align: center;
        }

        .value {
            font-size: 1.65rem;
            font-weight: 800;
            color: var(--red-700);
        }

        .label {
            font-size: 0.86rem;
            color: #825353;
        }

        .features {
            max-width: 980px;
            margin: 0 auto;
            padding: 28px 22px 60px;
        }

        .features h2 {
            text-align: center;
            font-size: 1.6rem;
            margin-bottom: 22px;
            font-family: "Spectral", Georgia, serif;
            color: #4d1015;
        }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
            gap: 14px;
        }

        .feature-card {
            background: var(--white);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 18px;
            box-shadow: 0 8px 18px rgba(145, 27, 27, 0.07);
            animation: rise 0.45s ease;
        }

        .feature-card .icon {
            display: inline-flex;
            width: 38px;
            height: 38px;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            background: #fff2f2;
            color: var(--red-700);
            margin-bottom: 7px;
        }

        .feature-card .icon .material-symbols-rounded {
            font-size: 1.3rem;
            line-height: 1;
        }

        .feature-card h3 {
            margin-bottom: 6px;
            font-size: 1rem;
        }

        .feature-card p {
            font-size: 0.9rem;
            line-height: 1.55;
            color: var(--muted);
        }

        footer {
            text-align: center;
            border-top: 1px solid var(--border);
            padding: 18px;
            color: #865656;
            font-size: 0.8rem;
            background: rgba(255, 255, 255, 0.72);
        }

        @keyframes rise {
            from {
                opacity: 0;
                transform: translateY(8px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 700px) {
            nav {
                padding: 0 14px;
                height: 60px;
            }

            .actions .btn {
                padding: 8px 12px;
                font-size: 0.82rem;
            }

            .stats-inner {
                grid-template-columns: 1fr;
                gap: 8px;
            }

            .hero {
                padding-top: 48px;
            }
        }
    </style>
</head>
<body>
<nav>
    <div class="logo"><span>Skill</span>Nova</div>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Sign In</a>
        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Get Started</a>
    </div>
</nav>

<section class="hero">
    <h1>Connect Talent with <span>Real Opportunity</span></h1>
    <p>
        A focused freelance marketplace where clients post jobs and skilled freelancers apply with confidence,
        track progress, and build trusted working relationships.
    </p>
    <div class="hero-cta">
        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Join SkillNova</a>
        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Sign In</a>
    </div>
</section>

<section class="stats">
    <div class="stats-inner">
        <div>
            <div class="value">1,200+</div>
            <div class="label">Freelancers</div>
        </div>
        <div>
            <div class="value">340+</div>
            <div class="label">Jobs Posted</div>
        </div>
        <div>
            <div class="value">890+</div>
            <div class="label">Hires Made</div>
        </div>
    </div>
</section>

<section class="features">
    <h2>Everything you need in one place</h2>
    <div class="feature-grid">
        <article class="feature-card">
            <div class="icon"><span class="material-symbols-rounded">verified_user</span></div>
            <h3>Secure Access</h3>
            <p>Role-based access for Admin, Client, and Freelancer with protected workflows.</p>
        </article>
        <article class="feature-card">
            <div class="icon"><span class="material-symbols-rounded">manage_search</span></div>
            <h3>Smart Discovery</h3>
            <p>Search and filter jobs by skills, budget range, and experience level.</p>
        </article>
        <article class="feature-card">
            <div class="icon"><span class="material-symbols-rounded">assignment_turned_in</span></div>
            <h3>Simple Applying</h3>
            <p>Apply quickly, monitor status updates, and keep your hiring process organized.</p>
        </article>
        <article class="feature-card">
            <div class="icon"><span class="material-symbols-rounded">star_rate</span></div>
            <h3>Trusted Reviews</h3>
            <p>Build reputation through transparent client and freelancer reviews.</p>
        </article>
    </div>
</section>

<footer>
    © 2026 SkillNova · Built for smarter hiring between clients and freelancers.
</footer>
</body>
</html>
