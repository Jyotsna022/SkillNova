<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SkillNova DB Health</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700&family=Spectral:wght@600;700&family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@24,500,1,0" rel="stylesheet">
    <style>
        :root {
            --red-700: #991b1b;
            --red-600: #b91c1c;
            --red-100: #fee2e2;
            --ink: #22191a;
            --muted: #755656;
            --border: #f2cbcb;
        }

        body {
            font-family: "Manrope", sans-serif;
            margin: 0;
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 18px;
            background: radial-gradient(circle at 80% 10%, #ffe9e9 0, transparent 34%), linear-gradient(145deg, #fff8f8 0%, #ffefef 100%);
            color: var(--ink);
        }

        .container {
            max-width: 760px;
            width: 100%;
            padding: 28px;
            background: #ffffff;
            border-radius: 16px;
            border: 1px solid var(--border);
            box-shadow: 0 16px 30px rgba(127, 29, 29, 0.09);
        }

        h1 {
            font-family: "Spectral", serif;
            font-size: 2rem;
            margin-bottom: 8px;
            color: var(--red-700);
        }

        p {
            color: var(--muted);
            line-height: 1.7;
        }

        .status {
            font-size: 1.1rem;
            margin-top: 18px;
            padding: 13px;
            border-radius: 10px;
            border: 1px solid transparent;
        }

        .ok {
            background: #dcfce7;
            color: #166534;
            border-color: #bbf7d0;
        }

        .fail {
            background: #fee2e2;
            color: #991b1b;
            border-color: #fecaca;
        }

        .actions {
            margin-top: 16px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn {
            text-decoration: none;
            border-radius: 10px;
            padding: 10px 14px;
            font-weight: 700;
            font-size: 0.9rem;
        }

        .btn-primary {
            color: #fff;
            background: linear-gradient(130deg, var(--red-700), var(--red-600));
        }

        .btn-soft {
            color: var(--red-700);
            background: #fff5f5;
            border: 1px solid #f0c7c7;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Database Health Check</h1>
    <p>This page verifies if the application can connect to MySQL using <code>DBConnection.java</code>.</p>
    <div class="status ${dbConnected ? 'ok' : 'fail'}">
        ${dbConnected ? 'Connected to skillnova database successfully.' : 'Database connection failed. Check DBConnection.java values.'}
    </div>
    <div class="actions">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/">Back Home</a>
        <a class="btn btn-soft" href="${pageContext.request.contextPath}/login">Go to Login</a>
    </div>
</div>
</body>
</html>
