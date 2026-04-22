<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>500 - SkillNova</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&family=Spectral:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            background: linear-gradient(145deg, #fff8f8 0%, #ffefef 100%);
            font-family: "Manrope", sans-serif;
            color: #271a1a;
            padding: 18px;
        }

        .card {
            width: 100%;
            max-width: 620px;
            background: #ffffff;
            border: 1px solid #f2cfcf;
            border-radius: 16px;
            padding: 28px;
            text-align: center;
            box-shadow: 0 16px 30px rgba(127, 29, 29, 0.1);
        }

        h1 {
            margin: 10px 0;
            font-family: "Spectral", serif;
            font-size: 2rem;
            color: #991b1b;
        }

        p { color: #7f5a5a; line-height: 1.7; }

        a {
            display: inline-block;
            margin-top: 16px;
            text-decoration: none;
            background: linear-gradient(130deg, #991b1b, #b91c1c);
            color: #fff;
            padding: 10px 14px;
            border-radius: 10px;
            font-weight: 700;
        }

        .material-symbols-rounded {
            font-size: 2.5rem;
            color: #b91c1c;
        }
    </style>
</head>
<body>
<section class="card">
    <span class="material-symbols-rounded">error</span>
    <h1>500 - Server Error</h1>
    <p>We hit an unexpected issue while processing your request. Please try again.</p>
    <a href="${pageContext.request.contextPath}/">Back to home</a>
</section>
</body>
</html>
