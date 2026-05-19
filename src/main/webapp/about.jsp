<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>About - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Space+Grotesk:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,0,0" rel="stylesheet">
    <style>
        :root { --ink:#101427; --muted:#5f6880; --line:#d9dde8; --surface:#f3f2f7; --hero1:#040643; --hero2:#02043a; --hero3:#090f55; }
        * { box-sizing:border-box; margin:0; padding:0; }
        body { font-family:"Manrope",sans-serif; color:var(--ink); background:#fff; }
        .container { width:min(1240px,100% - 40px); margin:0 auto; }
        .topbar { position:sticky; top:0; z-index:60; height:66px; border-bottom:1px solid #eceef4; background:rgba(255,255,255,.95); backdrop-filter:blur(8px); }
        .topbar .container { height:100%; display:flex; align-items:center; justify-content:space-between; }
        .left,.right { display:flex; align-items:center; gap:18px; }
        .left { flex:1; }
        .right { flex:1; justify-content:flex-end; }
        .brand { text-decoration:none; color:#111; font:700 30px/1 "Space Grotesk",sans-serif; }
        .links { display:flex; gap:24px; font-size:14px; color:#4d5569; margin:0 auto; }
        .links a { text-decoration:none; color:inherit; transition:color .2s ease; white-space:nowrap; }
        .links a:hover { color:#0a8575; }
        .auth a { text-decoration:none; font-size:13px; font-weight:700; border-radius:10px; padding:9px 12px; }
        .auth .login { border:1px solid #e2e7f2; color:#0e1428; }
        .auth .signup { background:#12174f; color:#fff; }
        .hero { color:#f3f7ff; background:radial-gradient(860px 280px at 72% 26%, rgba(93,182,255,.18), transparent 70%), linear-gradient(160deg,var(--hero1),var(--hero2) 58%,var(--hero3)); padding:66px 0 72px; }
        .hero h1 { font:700 clamp(40px,5vw,62px)/1.06 "Space Grotesk",sans-serif; margin-bottom:14px; }
        .hero p { color:#d3dbf6; max-width:780px; line-height:1.6; font-size:18px; }
        .section { background:var(--surface); border-top:1px solid #ececf2; padding:40px 0; }
        .intro-grid { display:grid; grid-template-columns:1.1fr .9fr; gap:18px; }
        .image-card { border-radius:16px; overflow:hidden; border:1px solid #d7dbe5; background:#fff; }
        .image-card img { width:100%; height:100%; object-fit:cover; min-height:320px; display:block; }
        .copy-card { border:1px solid #d7dbe5; background:#f9f9fc; border-radius:14px; padding:22px; }
        .copy-card h3 { font:700 32px/1.2 "Space Grotesk",sans-serif; margin-bottom:10px; }
        .copy-card p { color:#5e677a; line-height:1.62; margin-bottom:10px; }
        .feature-grid { margin-top:18px; display:grid; grid-template-columns:repeat(3,1fr); gap:14px; }
        .feature { border:1px solid #d7dbe5; background:#f9f9fc; border-radius:14px; padding:18px; }
        .feature .material-symbols-rounded { color:#0a8575; }
        .feature h4 { font:700 22px/1.2 "Space Grotesk",sans-serif; margin:8px 0 6px; }
        .feature p { color:#5e677a; line-height:1.55; font-size:14px; }
        .footer { background:#f4f3f7; border-top:1px solid #dbdee8; padding:34px 0 18px; }
        .footer-top { display:grid; grid-template-columns:1.2fr 1fr 1fr; gap:26px; padding-bottom:18px; border-bottom:1px solid #d6d9e4; }
        .foot-brand { font:700 26px/1.2 "Space Grotesk",sans-serif; margin-bottom:10px; }
        .foot-text { color:#606a7f; line-height:1.6; max-width:360px; margin-bottom:12px; font-size:14px; }
        .social { display:flex; gap:10px; }
        .social a { width:30px; height:30px; border-radius:50%; border:1px solid #ced5e2; display:grid; place-items:center; text-decoration:none; color:#23324f; transition:all .2s ease; }
        .social a:hover { color:#0a8575; border-color:#0a8575; }
        .col h4 { font-size:13px; color:#4d5567; margin-bottom:10px; text-transform:uppercase; letter-spacing:.6px; }
        .col a { display:block; text-decoration:none; color:#5f697d; margin-bottom:8px; font-size:14px; transition:color .2s ease; }
        .col a:hover { color:#0a8575; }
        .footer-bottom { margin-top:12px; display:flex; justify-content:space-between; color:#697286; font-size:13px; gap:10px; flex-wrap:wrap; }

        .mobile-toggle {
            display: none;
            align-items: center;
            justify-content: center;
            width: 40px; height: 40px;
            border: 1px solid #d8dbe4;
            border-radius: 10px;
            background: transparent;
            color: #242b40;
            cursor: pointer;
            font-family: inherit;
            font-size: 1.4rem;
        }

        @media (max-width:980px) { .intro-grid,.feature-grid,.footer-top { grid-template-columns:1fr; } }
        @media (max-width:760px) {
            .topbar { height:auto; padding:12px 0; }
            .topbar .container { flex-wrap:wrap; gap:10px; }
            .left,.right { width:100%; justify-content:space-between; }
            .mobile-toggle { display:flex; }
            .links { display:none; }
            .links.open {
                display:flex; flex-direction:column; width:100%;
                background:#f4f5fa; border-radius:12px; padding:4px 0;
                gap:0; order:10;
            }
            .links.open a { padding:12px 16px; border-bottom:1px solid #e6e8f0; }
            .links.open a:last-child { border-bottom:0; }
            .brand { font-size:24px; }
            .hero h1 { font-size:32px; }
            .hero p { font-size:16px; }
            .footer-top { grid-template-columns:1fr; }
        }
        @media (max-width:480px) {
            .container { width:min(1240px,100% - 20px); }
            .hero { padding:40px 0 48px; }
        }
    </style>
</head>
<body>
<header class="topbar"><div class="container"><div class="left"><a class="brand" href="${pageContext.request.contextPath}/">SkillNova</a><button class="mobile-toggle" onclick="document.querySelector('.links').classList.toggle('open')" aria-label="Toggle menu">&#9776;</button><nav class="links"><a href="${pageContext.request.contextPath}/register?role=FREELANCER">Find Work</a><a href="${pageContext.request.contextPath}/register?role=CLIENT">Hire Talent</a><a href="${pageContext.request.contextPath}/about.jsp">About</a><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></nav></div><div class="right auth"><a class="login" href="${pageContext.request.contextPath}/login">Log in</a><a class="signup" href="${pageContext.request.contextPath}/register">Sign up</a></div></div></header>
<section class="hero"><div class="container"><h1>About SkillNova Institution Initiative</h1><p>SkillNova is a practice-driven digital platform created to connect institutional learning with real client outcomes, professional freelancing discipline, and sustainable innovation culture.</p></div></section>
<section class="section"><div class="container"><div class="intro-grid"><article class="copy-card"><h3>Institution First. Industry Ready.</h3><p>SkillNova operates as a strategic initiative of our institution to transform student potential into professional impact. We focus on verified profiles, transparent collaboration, and real-world project execution.</p><p>By combining academic supervision with marketplace mechanics, the platform enables structured growth from foundational learning to advanced industry contribution.</p></article><article class="image-card"><img src="https://images.pexels.com/photos/256395/pexels-photo-256395.jpeg?auto=compress&cs=tinysrgb&w=1400" alt="Modern institutional campus architecture" onerror="this.onerror=null;this.src='https://picsum.photos/1200/700?blur=1';"></article></div><div class="feature-grid"><article class="feature"><span class="material-symbols-rounded">school</span><h4>Academic Integration</h4><p>Curriculum-aligned workflows that transform classroom projects into client-deliverable outcomes and measurable competencies.</p></article><article class="feature"><span class="material-symbols-rounded">verified_user</span><h4>Quality Governance</h4><p>Role moderation, account verification, and milestone supervision to maintain credibility and institutional standards.</p></article><article class="feature"><span class="material-symbols-rounded">groups</span><h4>Talent Development</h4><p>Students and graduates build communication, project ownership, and portfolio confidence through live engagements.</p></article><article class="feature"><span class="material-symbols-rounded">domain</span><h4>Industry Collaboration</h4><p>Clients access focused talent pools with clear accountability, structured proposals, and streamlined hiring visibility.</p></article><article class="feature"><span class="material-symbols-rounded">workspace_premium</span><h4>Career Pathways</h4><p>Supports long-term employability by emphasizing ethical professionalism, delivery discipline, and niche specialization.</p></article><article class="feature"><span class="material-symbols-rounded">trending_up</span><h4>Institutional Impact</h4><p>Strengthens innovation culture, creates economic opportunities, and builds a sustainable regional digital talent ecosystem.</p></article></div></div></section>
<footer class="footer"><div class="container"><div class="footer-top"><div><div class="foot-brand">SkillNova</div><div class="foot-text">The premium marketplace for world-class freelance talent and elite global clients.</div><div class="social"><a href="#">x</a><a href="#">in</a><a href="#">o</a></div></div><div class="col"><h4>Platform</h4><a href="${pageContext.request.contextPath}/about.jsp">About Us</a><a href="#">Safety</a><a href="#">Help Center</a><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></div><div class="col"><h4>Legal</h4><a href="#">Terms of Service</a><a href="#">Privacy Policy</a></div></div><div class="footer-bottom"><div>&copy; 2024 SkillNova. All rights reserved.</div><div><span>English (US)</span> · <span>NPR</span></div></div></div></footer>
</body>
</html>
