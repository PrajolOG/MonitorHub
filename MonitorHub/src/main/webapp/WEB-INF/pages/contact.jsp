<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - MonitorHub</title>

    <%-- Link External CSS Files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css"> <%-- Nav & Footer --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/contact.css">  <%-- Contact Specific Styles --%>
    <%-- Add auth.css if reusing button/input styles --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/auth.css">

    <%-- Minimal Global Layout Styles + Page Specific Adjustments --%>
    <style>
        /* Global Body Layout */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #eef2f7;
            background-image: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            padding-top: 105px; /* ADJUST FOR FIXED NAV */
            margin: 0;
            overflow-x: hidden; /* Prevent horizontal scroll */
        }
         .main-content { /* Generic wrapper adjusted for centering single item */
             width: 100%;
             margin: 0 auto;
             flex-grow: 1;
             display: flex; /* Center the contact-container */
             justify-content: center;
             align-items: center; /* Vertically center if content is short */
             padding: 40px 20px; /* Add vertical padding */
        }
        @media (max-width: 768px) {
             body { padding-top: 0; } /* Remove padding when nav is static */
             .main-content { padding: 30px 15px; }
        }
        @media (max-width: 576px) {
             .main-content { padding: 20px 10px; align-items: flex-start; } /* Align top on mobile */
        }

         /* --- Styles Specific to Contact Page (from contact.css if needed) --- */
         /* Optional: Add specific overrides here if contact.css isn't sufficient */
         .contact-container {
             animation: fadeIn 0.6s ease-in-out;
         }

         /* Style for server messages (Ensure these exist in auth.css or define here) */
         .status-message {
             width: 100%;
             margin-bottom: 20px;
             padding: 10px 15px;
             border-radius: 8px;
             font-size: 14px;
             text-align: center;
             /* display: none; /* Handled by c:if now */
        }
        .status-message.error { color: #721c24; background-color: #f8d7da; border: 1px solid #f5c6cb; }
        .status-message.success { color: #155724; background-color: #d4edda; border: 1px solid #c3e6cb; }

         /* --- Page Load Animation --- */
         @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">
        <div class="contact-container">
            <h1>Contact Us</h1>
            <p class="subtitle">We'd love to hear from you! Please fill out the form below.</p>

            <%-- Display Server-Side Messages passed via request attributes --%>
            <c:if test="${not empty requestScope.contactError}">
                <div class="status-message error"> <%-- Use appropriate error class --%>
                    <p><c:out value="${requestScope.contactError}" /></p>
                </div>
            </c:if>
            <c:if test="${not empty requestScope.contactSuccess}">
                 <div class="status-message success"> <%-- Use appropriate success class --%>
                     <p><c:out value="${requestScope.contactSuccess}" /></p>
                 </div>
            </c:if>
            <%-- If using Redirect + Session message: --%>
            <%--
            <c:if test="${not empty sessionScope.contactSuccessMessage}">
                 <div class="status-message success">
                     <p><c:out value="${sessionScope.contactSuccessMessage}" /></p>
                 </div>
                 <% session.removeAttribute("contactSuccessMessage"); %>
            </c:if>
            --%>

            <%-- Form submits directly to the ContactServlet --%>
            <form class="contact-form" id="contactForm" action="${pageContext.request.contextPath}/contact" method="post">
                <div class="input-group">
                    <label for="name">Full Name</label>
                    <%-- Retain value on error using request attributes set by servlet --%>
                    <input type="text" id="name" name="name" required placeholder="Enter your full name" value="${not empty formName ? formName : ''}">
                </div>
                <div class="input-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required placeholder="Enter your email address" value="${not empty formEmail ? formEmail : ''}">
                </div>
                <div class="input-group">
                    <label for="subject">Subject</label>
                    <input type="text" id="subject" name="subject" required placeholder="What is the subject of your message?" value="${not empty formSubject ? formSubject : ''}">
                </div>
                <div class="input-group">
                    <label for="message">Message</label>
                    <%-- Use JSTL c:out for textarea to handle potential special characters --%>
                    <textarea id="message" name="message" required placeholder="Enter your message here..."><c:out value="${not empty formMessage ? formMessage : ''}"/></textarea>
                </div>
                <%-- Button type="submit" is the default --%>
                <button type="submit" class="submit-btn">Send Message</button>
            </form>
        </div>
         <%-- Popup HTML Removed - feedback handled by server message --%>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />

    <%-- JavaScript for popup is REMOVED --%>
    <%-- Add any other necessary JS specific to the contact page if needed --%>

</body>
</html>