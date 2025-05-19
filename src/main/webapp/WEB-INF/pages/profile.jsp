<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>


<c:if test="${empty sessionScope.user}">
    <% session.setAttribute("loginMessage", "Please login to view your profile."); %>
    <c:redirect url="${pageContext.request.contextPath}/login"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile - MonitorHub</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/auth.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/profile.css">

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
            overflow-x: hidden;
        }

        .main-content { 
            width: 100%;
            margin: 0 auto;
            flex-grow: 1;
            display: flex;
            justify-content: center;
            align-items: center; 
            padding: 40px 20px; 
        }


        .status-message {
            padding: 12px 18px;
            margin-bottom: 20px;
            border-radius: 5px;
            font-size: 0.95em;
            text-align: center;
        }

        .status-message.success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .status-message.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }


        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .profile-container {
            animation: fadeIn 0.6s ease-in-out;
        }

        .profile-form {
            margin-top: 20px; 
        }
        

        @media (max-width: 768px) {
            body {
                padding-top: 0; 
            }
            .main-content {
                padding: 30px 15px;
            }
        }

        @media (max-width: 576px) {
            .main-content {
                padding: 20px 10px;
                align-items: flex-start; 
            }
        }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">
        <div class="profile-container auth-container">
            <h1>Edit Profile</h1>
            <p class="subtitle">Update your personal details.</p>

            <%-- Display Status Messages from Request Scope (set by ProfileServlet) --%>
            <c:if test="${not empty requestScope.profileError}">
                <div class="status-message error"><p><c:out value="${requestScope.profileError}"/></p></div>
            </c:if>
            <c:if test="${not empty requestScope.profileSuccess}">
                 <div class="status-message success"><p><c:out value="${requestScope.profileSuccess}"/></p></div>
            </c:if>

            <form action="${pageContext.request.contextPath}/profile" method="post" class="profile-form">

                <div class="input-group">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" placeholder="Enter your first name"
                           value="<c:out value='${not empty requestScope.form_firstName ? requestScope.form_firstName : sessionScope.user.firstname}'/>" 
                           required maxlength="50">
                </div>
                <div class="input-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" placeholder="Enter your last name"
                           value="<c:out value='${not empty requestScope.form_lastName ? requestScope.form_lastName : sessionScope.user.lastname}'/>" 
                           required maxlength="50">
                </div>
                 <div class="input-group">
                     <label for="phone">Phone Number</label>
                     <input type="tel" id="phone" name="phone" 
                            value="<c:out value='${not empty requestScope.form_phone ? requestScope.form_phone : sessionScope.user.phone}'/>" 
                            placeholder="e.g., +1234567890" maxlength="25">
                </div>
                <div class="input-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" 
                           value="<c:out value='${sessionScope.user.email}'/>" 
                           readonly disabled style="background-color: #e9ecef; cursor: not-allowed;">
                    <small style="font-size: 12px; color: #6c757d;">Email cannot be changed here.</small>
                </div>

                <div class="action-buttons">
                    <a href="#" class="btn back-btn" onclick="window.history.back(); return false;">Back</a>
                    <button type="submit" class="btn save-btn" id="saveProfileBtn">Save Changes</button>
                </div>

            </form>

        </div>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>