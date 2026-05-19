<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String role = (String) session.getAttribute("role");
    String fullName = (String) session.getAttribute("fullName");
    boolean loggedIn = session.getAttribute("userId") != null;
    String dashboardUrl = request.getContextPath() + "/login";
    if ("ADMIN".equals(role)) {
        dashboardUrl = request.getContextPath() + "/admin/dashboard";
    } else if ("CLIENT".equals(role)) {
        dashboardUrl = request.getContextPath() + "/client/dashboard";
    } else if ("FREELANCER".equals(role)) {
        dashboardUrl = request.getContextPath() + "/freelancer/dashboard";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SkillNova - Home</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Space+Grotesk:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root { --ink:#101427; --muted:#5f6880; --line:#d9dde8; --surface:#f3f2f7; --hero1:#040643; --hero2:#02043a; --hero3:#090f55; --mint:#66e6dd; --mintText:#0f3442; --violet:#191b56; }
        * { box-sizing:border-box; margin:0; padding:0; }
        body { font-family:"Manrope",sans-serif; color:var(--ink); background:#fff; }
        .container { width:min(1240px,100% - 40px); margin:0 auto; }

        .topbar { position:sticky; top:0; z-index:60; height:66px; border-bottom:1px solid #eceef4; background:rgba(255,255,255,.95); backdrop-filter:blur(8px); }
        .topbar .container { height:100%; display:flex; align-items:center; justify-content:space-between; }
        .left,.right { display:flex; align-items:center; gap:18px; }
        .left { flex:1; }
        .right { flex:1; justify-content:flex-end; }
        .brand { text-decoration:none; color:#111; font:700 30px/1 "Space Grotesk",sans-serif; letter-spacing:-.4px; }
        .links { display:flex; gap:24px; font-size:14px; color:#4d5569; margin:0 auto; }
        .links a { text-decoration:none; color:inherit; transition:color .2s ease; white-space:nowrap; }
        .links a:hover { color:#0a8575; }
        .icon-btn { width:34px; height:34px; border-radius:50%; border:1px solid #e7ebf4; display:grid; place-items:center; text-decoration:none; color:#12172c; }
        .avatar { width:36px; height:36px; border-radius:50%; background:linear-gradient(135deg,#dce4f8,#c4d2ee); color:#112447; text-decoration:none; display:grid; place-items:center; font-weight:800; }
        .auth { display:flex; gap:10px; }
        .auth a { text-decoration:none; font-size:13px; font-weight:700; border-radius:10px; padding:9px 12px; }
        .auth .login { border:1px solid #e2e7f2; color:#0e1428; }
        .auth .signup { background:#12174f; color:#fff; }
        .auth a:hover { filter:brightness(.95); }

        .hero-wrap { color:#f3f7ff; background:radial-gradient(860px 280px at 72% 26%, rgba(93,182,255,.18), transparent 70%), radial-gradient(640px 280px at 35% 72%, rgba(101,87,255,.22), transparent 72%), linear-gradient(160deg,var(--hero1),var(--hero2) 58%,var(--hero3)); }
        .hero { display:grid; grid-template-columns:1fr 500px; gap:32px; align-items:center; padding:72px 0 82px; }
        h1 { font:700 clamp(44px,5vw,70px)/1.03 "Space Grotesk",sans-serif; letter-spacing:-.8px; margin-bottom:16px; }
        .hero p { max-width:650px; color:#d3dbf6; font-size:19px; line-height:1.62; margin-bottom:22px; }
        .hero-actions { display:flex; gap:12px; margin-bottom:28px; }
        .cta { text-decoration:none; border-radius:10px; padding:14px 30px; min-width:148px; text-align:center; font-weight:700; }
        .cta-primary { background:var(--violet); border:1px solid #2a2c72; color:#dbe0ff; }
        .cta-secondary { background:var(--mint); color:var(--mintText); }
        .trusted { display:flex; align-items:center; gap:12px; color:#dde4fa; font-size:14px; }
        .avatars { display:flex; }
        .avatars span { width:36px; height:36px; border-radius:50%; border:2px solid #090f47; margin-right:-8px; display:grid; place-items:center; background:linear-gradient(135deg,#ffe2bf,#f4c187); color:#0a1738; font-size:11px; font-weight:800; }

        .opp { position:relative; overflow:hidden; background:linear-gradient(160deg,#fcfdff,#eef3ff 55%,#edf7ff); color:#111838; border:1px solid #d8e2ff; border-radius:18px; box-shadow:0 18px 36px rgba(13,19,41,.22); padding:22px; }
        .opp::before { content:""; position:absolute; right:-36px; top:-32px; width:170px; height:170px; background:radial-gradient(circle,rgba(121,189,255,.36),transparent 70%); pointer-events:none; }
        .opp-top { display:flex; justify-content:space-between; align-items:center; margin-bottom:10px; }
        .opp-title { font-size:14px; font-weight:800; text-transform:uppercase; letter-spacing:.8px; color:#455078; }
        .status { background:#d0fff2; color:#0b7f67; border-radius:999px; padding:7px 11px; font-size:12px; font-weight:800; }
        .opp-role { font:700 34px/1.05 "Space Grotesk",sans-serif; margin-bottom:8px; }
        .opp-meta { color:#58627f; font-size:14px; margin-bottom:14px; }
        .skills { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:16px; }
        .skills span { border:1px solid #d8def0; background:#f7f9ff; color:#455174; border-radius:999px; padding:5px 10px; font-size:12px; font-weight:700; }
        .opp-rail { display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-bottom:14px; }
        .mini { border:1px solid #d9e1f2; background:#f9fbff; border-radius:10px; padding:10px; }
        .mini b { display:block; font-size:18px; color:#101849; margin-bottom:2px; }
        .mini span { color:#5e6780; font-size:12px; }
        .opp-bottom { border-top:1px solid #dfe5f2; padding-top:12px; display:flex; justify-content:space-between; align-items:center; color:#445068; font-size:14px; }
        .opp-bottom a { text-decoration:none; color:#fff; font-weight:800; background:#12174f; border-radius:10px; padding:8px 12px; }

        .section { background:var(--surface); border-top:1px solid #ececf2; padding:44px 0; }
        .section h2 { font:700 46px/1.12 "Space Grotesk",sans-serif; margin-bottom:8px; }
        .section-sub { color:var(--muted); font-size:18px; margin-bottom:24px; }

        .head-row { display:flex; justify-content:space-between; align-items:end; margin-bottom:12px; }
        .head-row a { text-decoration:none; color:#24657a; font-size:14px; font-weight:700; }
        .cards { display:grid; grid-template-columns:repeat(3,1fr); gap:16px; }
        .card { border:1px solid #d7dbe5; background:#f9f9fc; border-radius:14px; padding:20px; min-height:196px; }
        .card h3 { font:700 30px/1.16 "Space Grotesk",sans-serif; margin:10px 0 8px; }
        .card p { color:#5e677a; line-height:1.58; font-size:15px; margin-bottom:11px; }
        .tag-row { display:flex; gap:6px; flex-wrap:wrap; }
        .tag-row span { font-size:11px; border:1px solid #d9dce8; background:#ececf3; color:#5a6275; border-radius:999px; padding:3px 8px; font-weight:700; }

        .journey { background:#f0eff4; }
        .journey-grid { display:grid; grid-template-columns:1fr 1fr; gap:40px; margin-top:20px; }
        .journey h3 { font:700 31px/1.2 "Space Grotesk",sans-serif; margin-bottom:15px; display:flex; gap:10px; align-items:center; }
        .num { width:33px; height:33px; border-radius:50%; display:grid; place-items:center; color:#fff; font-size:12px; font-weight:800; }
        .n1 { background:#0e1550; } .n2 { background:#0a8575; }
        .points { border-left:2px solid #cbd0dd; margin-left:16px; padding-left:16px; display:grid; gap:14px; }
        .point h4 { font-size:21px; margin-bottom:4px; display:flex; gap:7px; align-items:center; }
        .dot { width:10px; height:10px; border-radius:50%; background:#141a54; } .dot.g { background:#0a8575; } .dot.gray { background:#b9becd; }
        .point p { color:#5f697d; font-size:15px; line-height:1.55; }

        .why-grid { display:grid; grid-template-columns:1fr 1fr; gap:28px; align-items:center; }
        .benefits { display:grid; grid-template-columns:repeat(2,1fr); gap:14px; }
        .benefit { border:1px solid #d9dce7; border-radius:12px; background:#f9f9fc; padding:18px; min-height:145px; }
        .benefit h4 { font:700 27px/1.2 "Space Grotesk",sans-serif; margin:8px 0 6px; }
        .benefit p { color:#626c80; font-size:14px; }
        .why h3 { font:700 46px/1.1 "Space Grotesk",sans-serif; margin-bottom:10px; }
        .why p { color:#5f697d; line-height:1.6; margin-bottom:14px; }
        .list { display:grid; gap:10px; margin-bottom:16px; font-size:15px; }
        .item { display:flex; gap:8px; align-items:center; }
        .item .material-symbols-rounded { color:#0a8575; font-size:16px; }
        .story { text-decoration:none; background:#0d1352; color:#fff; border-radius:9px; padding:11px 16px; font-weight:700; display:inline-block; font-size:14px; }

        .cta-band { background:#060649; color:#f5f6ff; text-align:center; padding:48px 0; }
        .cta-band h3 { font:700 54px/1.1 "Space Grotesk",sans-serif; margin-bottom:10px; }
        .cta-band p { color:#d1d7f3; max-width:650px; margin:0 auto 22px; font-size:17px; line-height:1.6; }
        .cta-row { display:flex; gap:12px; justify-content:center; flex-wrap:wrap; }
        .cta-row a { text-decoration:none; border-radius:10px; padding:13px 28px; min-width:170px; font-weight:700; border:1px solid #d6d9e8; }
        .get { background:#ffe6cf; color:#172038; border-color:#ffe6cf; }
        .demo { color:#fff; border-color:#8b91bc; }

        .footer { background:#f4f3f7; border-top:1px solid #dbdee8; padding:34px 0 18px; }
        .footer-top { display:grid; grid-template-columns:1.2fr 1fr 1fr; gap:26px; padding-bottom:18px; border-bottom:1px solid #d6d9e4; }
        .foot-brand { font:700 26px/1.2 "Space Grotesk",sans-serif; margin-bottom:10px; }
        .foot-text { color:#606a7f; line-height:1.6; max-width:360px; margin-bottom:12px; font-size:14px; }
        .social { display:flex; gap:10px; }
        .social a { width:30px; height:30px; border-radius:50%; border:1px solid #ced5e2; display:grid; place-items:center; text-decoration:none; color:#23324f; }
        .col h4 { font-size:13px; color:#4d5567; margin-bottom:10px; text-transform:uppercase; letter-spacing:.6px; }
        .col a { display:block; text-decoration:none; color:#5f697d; margin-bottom:8px; font-size:14px; transition:color .2s ease; }
        .col a:hover { color:#0a8575; }
        .footer-bottom { margin-top:12px; display:flex; justify-content:space-between; color:#697286; font-size:13px; gap:10px; flex-wrap:wrap; }
        .locale { display:flex; gap:16px; }

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

        @media (max-width:1080px) {
            .hero,.cards,.journey-grid,.why-grid,.footer-top { grid-template-columns:1fr; }
            .section h2,.why h3,.cta-band h3 { font-size:36px; }
            h1 { font-size:clamp(38px,8vw,58px); }
            .container { width:min(1240px,100% - 28px); }
        }
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
            .links.open a {
                padding:12px 16px; border-bottom:1px solid #e6e8f0;
                font-size:14px;
            }
            .links.open a:last-child { border-bottom:0; }
            .brand { font-size:24px; }
            .hero { padding-top:44px; }
            .hero-actions { flex-direction:column; }
            .cta { width:100%; }
            .benefits { grid-template-columns:1fr; }
            .opp-role { font-size:26px; }
            .footer-top { grid-template-columns:1fr; }
        }
        @media (max-width:480px) {
            h1 { font-size:32px; }
            .section h2,.why h3 { font-size:28px; }
            .cta-band h3 { font-size:28px; }
            .hero p { font-size:16px; }
            .container { width:min(1240px,100% - 20px); }
        }
    </style>
</head>
<body>
<header class="topbar">
    <div class="container">
        <div class="left">
            <a class="brand" href="${pageContext.request.contextPath}/">SkillNova</a>
            <button class="mobile-toggle" onclick="document.querySelector('.links').classList.toggle('open')" aria-label="Toggle menu">&#9776;</button>
            <nav class="links">
                 <a href="${pageContext.request.contextPath}/register?role=FREELANCER">Find Work</a>
                 <a href="${pageContext.request.contextPath}/register?role=CLIENT">Hire Talent</a>
                 <a href="<%= dashboardUrl %>">Dashboard</a>
                 <a href="#">Messages</a>
                 <a href="${pageContext.request.contextPath}/about.jsp">About</a>
                 <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
            </nav>
        </div>
        <div class="right">
            <% if (!loggedIn) { %>
                <div class="auth">
                    <a class="login" href="${pageContext.request.contextPath}/login">Log in</a>
                    <a class="signup" href="${pageContext.request.contextPath}/register">Sign up</a>
                </div>
            <% } else { %>
                <a class="icon-btn" href="#" aria-label="Notifications"><span class="material-symbols-rounded">notifications</span></a>
                <a class="avatar" href="<%= dashboardUrl %>" title="<%= fullName == null ? "User" : fullName %>"><%= (fullName != null && !fullName.isBlank()) ? String.valueOf(fullName.charAt(0)).toUpperCase() : "U" %></a>
                <a class="auth login" href="${pageContext.request.contextPath}/logout">Logout</a>
            <% } %>
        </div>
    </div>
</header>

<section class="hero-wrap">
    <div class="container hero">
        <div>
            <h1>Where Elite Talent Meets Global Opportunity.</h1>
            <p>SkillNova is the high-trust ecosystem designed for the modern economy. Connect with top-tier professionals and world-class clients in a secure, efficient environment.</p>
            <div class="hero-actions">
                 <a class="cta cta-primary" href="${pageContext.request.contextPath}/register?role=FREELANCER">Find Work</a>
                 <a class="cta cta-secondary" href="${pageContext.request.contextPath}/register?role=CLIENT">Hire Talent</a>
            </div>
            <div class="trusted">
                <div class="avatars"><span>A</span><span>B</span><span>C</span></div>
                Trusted by 50k+ elite professionals
            </div>
        </div>
        <article class="opp">
            <div class="opp-top"><div class="opp-title">Featured Match</div><div class="status">Hot Lead</div></div>
            <div class="opp-role">Lead Product Designer</div>
            <div class="opp-meta">Nexus FinLab · Hybrid (Singapore) · $92k - $136k</div>
            <div class="skills"><span>Figma Systems</span><span>UX Strategy</span><span>Design Ops</span></div>
            <div class="opp-rail">
                <div class="mini"><b>48 hrs</b><span>to apply</span></div>
                <div class="mini"><b>Top 5%</b><span>match score</span></div>
            </div>
            <div class="opp-bottom"><div><span class="material-symbols-rounded" style="font-size:18px; vertical-align:middle; margin-right:6px;">domain</span>Nexus Capital Group</div><a href="#">Explore Role</a></div>
        </article>
    </div>
</section>

<section class="section">
    <div class="container">
        <div class="head-row">
            <div><h2>Expertise for Every Need</h2><div class="section-sub">Explore our highly-vetted professional networks.</div></div>
            <a href="#">Browse all categories &rarr;</a>
        </div>
        <div class="cards">
            <article class="card"><span class="material-symbols-rounded" style="font-size:20px; background:#19195d; color:#fff; border-radius:8px; padding:10px;">code</span><h3>Development</h3><p>Full-stack, Mobile, DevOps, and Emerging Tech experts built for scale.</p><div class="tag-row"><span>React</span><span>Python</span><span>Cloud</span></div></article>
            <article class="card"><span class="material-symbols-rounded" style="font-size:20px; background:#8af2e3; border-radius:8px; padding:10px;">draw</span><h3>Design</h3><p>Visual identity, UI/UX, and product designers who transform brands.</p><div class="tag-row"><span>UI/UX</span><span>Branding</span><span>Motion</span></div></article>
            <article class="card"><span class="material-symbols-rounded" style="font-size:20px; background:#ffdcb8; border-radius:8px; padding:10px;">trending_up</span><h3>Marketing</h3><p>Growth hackers and strategic thinkers focused on measurable ROI.</p><div class="tag-row"><span>SEO</span><span>Social</span><span>Copy</span></div></article>
        </div>
    </div>
</section>

<section class="section journey">
    <div class="container">
        <h2 style="text-align:center;">A Transparent Journey</h2>
        <div class="section-sub" style="text-align:center;">Precision from project launch to final delivery.</div>
        <div class="journey-grid">
            <article><h3><span class="num n1">1</span>For Professionals</h3><div class="points"><div class="point"><h4><span class="dot"></span>Curated Profile</h4><p>Apply and pass our rigorous vetting process to join the elite top 3% of talent.</p></div><div class="point"><h4><span class="dot gray"></span>Seamless Bidding</h4><p>Access premium job postings and submit clear, value-driven proposals.</p></div><div class="point"><h4><span class="dot gray"></span>Secured Payments</h4><p>Work with confidence using our milestone-based escrow system.</p></div></div></article>
            <article><h3><span class="num n2">2</span>For Clients</h3><div class="points"><div class="point"><h4><span class="dot g"></span>Precision Posting</h4><p>Define your project requirements with our structured builder to attract the best fit.</p></div><div class="point"><h4><span class="dot gray"></span>Talent Matching</h4><p>Review highly relevant applications backed by verified reviews and portfolios.</p></div><div class="point"><h4><span class="dot gray"></span>Managed Delivery</h4><p>Track progress via real-time workspaces and release funds only when satisfied.</p></div></div></article>
        </div>
    </div>
</section>

<section class="section">
    <div class="container why-grid">
        <div class="benefits">
            <article class="benefit"><span class="material-symbols-rounded" style="color:#0a8575;">verified_user</span><h4>Trust</h4><p>Every user is identity-verified.</p></article>
            <article class="benefit"><span class="material-symbols-rounded" style="color:#172150;">public</span><h4>Global</h4><p>Access markets in 150+ countries.</p></article>
            <article class="benefit"><span class="material-symbols-rounded" style="color:#c0792b;">workspace_premium</span><h4>Professional</h4><p>Corporate-grade project tools.</p></article>
            <article class="benefit"><span class="material-symbols-rounded" style="color:#27b3aa;">payments</span><h4>Secure</h4><p>End-to-end payment encryption.</p></article>
        </div>
        <article class="why">
            <h3>Why Industry Leaders Choose SkillNova</h3>
            <p>We've moved beyond the "gig" economy. SkillNova provides the infrastructure for long-term strategic partnerships between specialized experts and visionary companies.</p>
            <div class="list">
                <div class="item"><span class="material-symbols-rounded">check_circle</span>Vetted profiles with audited project histories</div>
                <div class="item"><span class="material-symbols-rounded">check_circle</span>Enterprise-level legal and compliance protection</div>
                <div class="item"><span class="material-symbols-rounded">check_circle</span>Zero-fee milestone protection for high-value contracts</div>
            </div>
            <a href="#" class="story">Read Success Stories</a>
        </article>
    </div>
</section>

<section class="cta-band">
    <div class="container">
        <h3>Ready to elevate your trajectory?</h3>
        <p>Join the world's most sophisticated marketplace today and start building something extraordinary.</p>
        <div class="cta-row"><a class="get" href="${pageContext.request.contextPath}/register">Get Started</a><a class="demo" href="#">Schedule a Demo</a></div>
    </div>
</section>

<footer class="footer">
    <div class="container">
        <div class="footer-top">
            <div><div class="foot-brand">SkillNova</div><div class="foot-text">The premium marketplace for world-class freelance talent and elite global clients.</div><div class="social"><a href="#">x</a><a href="#">in</a><a href="#">o</a></div></div>
            <div class="col"><h4>Platform</h4><a href="${pageContext.request.contextPath}/about.jsp">About Us</a><a href="#">Safety</a><a href="#">Help Center</a><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></div>
            <div class="col"><h4>Legal</h4><a href="#">Terms of Service</a><a href="#">Privacy Policy</a></div>
        </div>
        <div class="footer-bottom"><div>&copy; 2024 SkillNova. All rights reserved.</div><div class="locale"><span>English (US)</span><span>USD ($)</span></div></div>
    </div>
</footer>
</body>
</html>
