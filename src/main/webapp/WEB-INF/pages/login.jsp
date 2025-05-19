<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - MonitorHub</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/login.css">

    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #eef2f7;
            background-image: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            padding-top: 105px;
            margin: 0;
        }
        .main-content {
             width: 100%;
             margin: 0 auto;
             flex-grow: 1;
             display: flex; 
        }
        @media (max-width: 768px) { body { padding-top: 0; } }

        .options-row { display: flex; justify-content: space-between; align-items: center; font-size: 13px; color: #495057; margin-top: -5px; margin-bottom: 10px; flex-wrap: wrap; gap: 10px; }
        .options-row .checkbox-group { display: flex; align-items: center; gap: 8px; } 
        .options-row input[type="checkbox"] { width: 15px; height: 15px; cursor: pointer; accent-color: #9d4edd; }
        .options-row .checkbox-group label { font-weight: 400; margin-bottom: 0; cursor: pointer; font-size: 13px; color: #495057; }
        .forgot-password a { color: #9d4edd; font-weight: 500; text-decoration: none; transition: text-decoration 0.2s ease; font-size: 13px; }
        .forgot-password a:hover { text-decoration: underline; }

         @media (max-width: 576px) {
            .options-row, .options-row .checkbox-group label, .forgot-password a { font-size: 12px; }
            .options-row { margin-top: -8px; }
         }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">
        <div class="main-auth-content">
            <div class="auth-container">
                <h1>Welcome Back</h1>
                <p class="subtitle">Log in to your MonitorHub account</p>

                <c:if test="${not empty loginError}"><div class="error-message"><p>${loginError}</p></div></c:if>
                <c:if test="${not empty message}"><div class="status-message success"><p>${message}</p></div></c:if>

                <form class="auth-form" action="${pageContext.request.contextPath}/login" method="post">
                    <div class="input-group">
                        <label for="email">Email</label>
                        <input type="email" id="email" name="email" required value="${param.email}">
                    </div>
                    <div class="input-group">
                        <label for="password">Password</label>
                        <input type="password" id="password" name="password" required>
                    </div>
                    <div class="options-row">
                        <div class="checkbox-group">
                            <input type="checkbox" id="remember-me" name="remember">
                            <label for="remember-me">Remember me</label>
                        </div>
                        <div class="forgot-password">
                            <a href="">Forgot Password?</a>
                        </div>
                    </div>
                    <button type="submit" class="submit-btn">Log In</button>
                </form>
                <p class="switch-link">
                    Don't have an account? <a href="${pageContext.request.contextPath}/signup">Sign up</a>
                </p>
            </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>