<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Contact - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;700;800&family=Space+Grotesk:wght@600;700&display=swap" rel="stylesheet">
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
        .hero { color:#f3f7ff; background:radial-gradient(860px 280px at 72% 26%, rgba(93,182,255,.18), transparent 70%), linear-gradient(160deg,var(--hero1),var(--hero2) 58%,var(--hero3)); padding:72px 0 78px; }
        .hero h1 { font:700 clamp(42px,5vw,64px)/1.06 "Space Grotesk",sans-serif; margin-bottom:14px; }
        .hero p { color:#d3dbf6; max-width:760px; line-height:1.6; font-size:18px; }
        .section { background:var(--surface); border-top:1px solid #ececf2; padding:42px 0; }
        .grid { display:grid; grid-template-columns:1fr 1.1fr; gap:18px; }
        .card { border:1px solid #d7dbe5; background:#f9f9fc; border-radius:14px; padding:20px; }
        .card h3 { font:700 28px/1.2 "Space Grotesk",sans-serif; margin-bottom:8px; }
        .card p { color:#5e677a; line-height:1.6; margin-bottom:10px; }
        .field { margin-bottom:10px; }
        label { display:block; margin-bottom:6px; font-size:13px; font-weight:700; color:#4f586e; }
        input, textarea { width:100%; border:1px solid #ccd2e0; border-radius:10px; padding:10px; font-family:inherit; outline:none; }
        textarea { min-height:110px; resize:vertical; }
        button { border:0; border-radius:10px; padding:12px 18px; font-weight:800; color:#fff; background:linear-gradient(120deg,#0f8f81,#0a5f57); cursor:pointer; }
        .flash { border:1px solid #bfead0; background:#e8f8ef; color:#1f6d40; border-radius:10px; padding:10px; margin-bottom:10px; display:none; }
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
        @media (max-width:900px) { .grid { grid-template-columns:1fr; } }
    </style>
</head>
<body>
<header class="topbar">
    <div class="container">
        <div class="left">
            <a class="brand" href="${pageContext.request.contextPath}/">SkillNova</a>
            <nav class="links">
                <a href="${pageContext.request.contextPath}/register?role=FREELANCER">Find Work</a>
                <a href="${pageContext.request.contextPath}/register?role=CLIENT">Hire Talent</a>
                <a href="${pageContext.request.contextPath}/about.jsp">About</a>
                <a href="${pageContext.request.contextPath}/contact.jsp">Contact</a>
            </nav>
        </div>
        <div class="right auth">
            <a class="login" href="${pageContext.request.contextPath}/login">Log in</a>
            <a class="signup" href="${pageContext.request.contextPath}/register">Sign up</a>
        </div>
    </div>
</header>
<section class="hero"><div class="container"><h1>Contact & Support</h1><p>Need platform assistance, onboarding support, or partnership information? Our team is here to help.</p></div></section>
<section class="section"><div class="container grid"><article class="card"><h3>Support Details</h3><p><strong>Company:</strong> SkillNova Labs Pvt. Ltd.</p><p><strong>Email:</strong> support@skillnova.com.np</p><p><strong>Phone:</strong> +977-25-580321</p><p><strong>Address:</strong> Innovation Tower, Itahari-6, Sunsari, Nepal</p><p><strong>Support Hours:</strong> Sun-Fri, 9:00 AM to 5:00 PM (NPT)</p></article><article class="card"><h3>Send an Inquiry</h3><div id="contactFlash" class="flash">Thank you! Your inquiry has been submitted. Our support team will contact you shortly.</div><form id="contactForm"><div class="field"><label for="name">Full Name</label><input id="name" placeholder="Your full name" required /></div><div class="field"><label for="email">Email</label><input id="email" type="email" placeholder="you@example.com" required /></div><div class="field"><label for="subject">Subject</label><input id="subject" placeholder="How can we help?" required /></div><div class="field"><label for="message">Message</label><textarea id="message" placeholder="Write your inquiry details..." required></textarea></div><button type="submit">Submit Inquiry</button></form></article></div></section>
<footer class="footer"><div class="container"><div class="footer-top"><div><div class="foot-brand">SkillNova</div><div class="foot-text">The premium marketplace for world-class freelance talent and elite global clients.</div><div class="social"><a href="#">x</a><a href="#">in</a><a href="#">o</a></div></div><div class="col"><h4>Platform</h4><a href="${pageContext.request.contextPath}/about.jsp">About Us</a><a href="#">Safety</a><a href="#">Help Center</a><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></div><div class="col"><h4>Legal</h4><a href="#">Terms of Service</a><a href="#">Privacy Policy</a></div></div><div class="footer-bottom"><div>&copy; 2024 SkillNova. All rights reserved.</div><div><span>English (US)</span> · <span>NPR</span></div></div></div></footer>
<script>
    document.getElementById('contactForm').addEventListener('submit', function (event) {
        event.preventDefault();
        const flash = document.getElementById('contactFlash');
        flash.style.display = 'block';
        this.reset();
        flash.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    });
</script>
</body>
</html>
