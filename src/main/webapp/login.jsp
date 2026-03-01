<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Ocean View Resort</title>

    <!-- Main CSS (same as dashboard) -->
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">

    <!-- Font Awesome -->
    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <!-- ✅ Same font style feeling -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700;800&display=swap" rel="stylesheet">

    <style>
        /* ✅ Split login layout (image + form) */
        body{ background: #f6f7fb; }

        .login-page{
            min-height: 100vh;
            display:grid;
            grid-template-columns: 1.15fr 1fr;
        }

        .login-left{
            position: relative;
            background:
              linear-gradient(120deg, rgba(14,165,233,.25), rgba(20,184,166,.25)),
              url("<%=request.getContextPath()%>/assets/img/login-hero.jpg");
            background-size: cover;
            background-position: center;
            padding: 28px;
            display:flex;
            align-items:flex-start;
            justify-content:flex-start;
        }

        /* ✅ Brand box (same style as dashboard branding) */
        .left-brand{
            display:flex;
            align-items:center;
            gap:14px;
            background: rgba(255,255,255,.92);
            border:1px solid rgba(15,23,42,.10);
            border-radius: 18px;
            padding: 14px 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,.08);
            backdrop-filter: blur(8px);
        }

        /* ✅ SAME logo image as dashboard */
        .login-brand-img{
            height: 65px;  /* make bigger if you want */
            width: auto;
            object-fit: contain;
            display:block;
        }

        /* ✅ Text like dashboard (gradient + Poppins) */
        .login-brand-text{
            display:flex;
            flex-direction:column;
            font-family: 'Poppins', sans-serif;
        }

        .login-brand-name{
            font-size: 20px;
            font-weight: 800;
            background: linear-gradient(135deg, #0ea5e9, #14b8a6);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .login-brand-sub{
            font-size: 13px;
            color: #64748b;
            margin-top: 4px;
            font-weight: 600;
        }

        .login-right{
            display:flex;
            align-items:center;
            justify-content:center;
            padding: 20px;
        }

        .login-card{
            width: min(440px, 96vw);
        }

        .login-title{
            margin:0 0 6px;
            display:flex;
            gap:10px;
            align-items:center;
            font-family: 'Poppins', sans-serif;
            font-weight: 800;
        }

        .pill{
            display:inline-block;
            font-size:12px;
            padding:6px 10px;
            border-radius:999px;
            border:1px solid #e6e8ef;
            background:#f8fafc;
            color:#374151;
        }

        .form-row{ margin-top: 12px; }
        .form-row small{
            display:block;
            margin-bottom:6px;
            color:#6b7280;
        }

        .input-wrap{
            position:relative;
        }
        .input-wrap i{
            position:absolute;
            left:12px;
            top:50%;
            transform: translateY(-50%);
            color:#94a3b8;
        }
        .input-wrap input{
            padding-left: 38px;
        }

        .btn-full{ width:100%; }

        /* ✅ Responsive */
        @media(max-width: 920px){
            .login-page{ grid-template-columns: 1fr; }
            .login-left{ min-height: 200px; }
        }
    </style>
</head>

<body>

<div class="login-page">

    <!-- LEFT: Image panel -->
    <div class="login-left">

        <!-- ✅ UPDATED BRAND (same as dashboard logo + text) -->
        <div class="left-brand">
            <img src="<%=request.getContextPath()%>/assets/img/logo.png"
                 class="login-brand-img"
                 alt="Ocean View Resort">

            <div class="login-brand-text">
                <span class="login-brand-name">Ocean View Resort</span>
                <span class="login-brand-sub">Admin / Staff Portal</span>
            </div>
        </div>

    </div>

    <!-- RIGHT: Login form -->
    <div class="login-right">
        <div class="card login-card">

            <div style="display:flex; justify-content:space-between; gap:10px; flex-wrap:wrap; align-items:center;">
                <h1 class="login-title">
                    <i class="fa-solid fa-right-to-bracket"></i> Welcome Back
                </h1>
                <span class="pill"><i class="fa-solid fa-lock"></i> Secure Login</span>
            </div>

            <small>Sign in to manage reservations, billing, and payments</small>

            <% if (error != null) { %>
            <div class="alert bad" style="margin-top:12px;">
                <i class="fa-solid fa-triangle-exclamation"></i> <%= error %>
            </div>
            <% } %>

            <form action="<%=request.getContextPath()%>/login" method="post" style="margin-top:14px;">

                <div class="form-row">
                    <small>Username</small>
                    <div class="input-wrap">
                        <i class="fa-solid fa-user"></i>
                        <input type="text" name="username" placeholder="Enter username" required>
                    </div>
                </div>

                <div class="form-row">
                    <small>Password</small>
                    <div class="input-wrap">
                        <i class="fa-solid fa-key"></i>
                        <input type="password" name="password" placeholder="Enter password" required>
                    </div>
                </div>

                <div class="form-row">
                    <button class="btn primary btn-full" type="submit">
                        <i class="fa-solid fa-right-to-bracket"></i> Login
                    </button>
                </div>

                <div style="margin-top:12px; color:#6b7280; font-size:12px; line-height:1.6;">
                    Tip: Use your Admin/Staff account. If account is disabled, contact admin.
                </div>

            </form>

        </div>
    </div>

</div>

</body>
</html>