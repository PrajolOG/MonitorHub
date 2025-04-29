<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- Keep for date formatting potentially later --%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%-- Use page title passed from servlet or a default --%>
    <title>Manage Users - Admin</title>

    <%-- Link CSS files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/userAdmin.css">

    <%-- Base styles needed for overall layout --%>
    <style>

	    *, *::before, *::after {
	        box-sizing: border-box;
	        margin: 0;
	        padding: 0;
	    }
	    :root { /* Define CSS Variables Consistently */
	        --primary-purple: #9d4edd; --secondary-purple: #c77dff;
	        --gradient: linear-gradient(90deg, var(--primary-purple) 0%, var(--secondary-purple) 100%);
	        --bg-light-start: #f5f7fa; --bg-light-end: #c3cfe2;
	        --bg-body-gradient: linear-gradient(135deg, var(--bg-light-start) 0%, var(--bg-light-end) 100%);
	        --sidebar-bg: rgba(255, 255, 255, 0.5); --sidebar-border: rgba(255, 255, 255, 0.25);
	        --card-bg: rgba(255, 255, 255, 0.75); --text-dark: #2d3748; --text-medium: #4a5568;
	        --text-light: #718096; --white: #ffffff; --hover-bg: rgba(157, 78, 221, 0.1);
	        --border-light: #e2e8f0; --border-medium: #cbd5e0;
	        --danger-red: #e53e3e; --danger-red-light: #fed7d7;
	        --info-blue: #3182ce; --info-blue-light: #bee3f8;
	        --success-green: #38a169; --success-green-light: #c6f6d5;
	        --warning-orange: #dd6b20; --warning-orange-light: #feebc8;
	    }
	    body {
	        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
	        background-color: var(--bg-light-start); background-image: var(--bg-body-gradient);
	        color: var(--text-dark);
	        margin: 0;
	        display: flex; /* Use flexbox for the main layout */
	        min-height: 100vh; /* Ensure body takes at least full viewport height */
	        background-attachment: fixed; /* Keep gradient fixed during scroll */
	    }
	    .dashboard-container {
	        display: flex; /* Sidebar and main content side-by-side */
	        width: 100%;
	    }
	    .main-content {
	        flex-grow: 1; /* Allow main content to take remaining width */
	        padding: 30px; /* Padding around content */
	        overflow-y: auto; /* Allow ONLY main content to scroll vertically if needed */
	        /* REMOVED height: 100vh; */
	    }
	    .main-content > h1 { /* Style for the main heading on each page */
	        font-size: 28px;
	        margin-bottom: 20px;
	        color: var(--text-dark);
	    }
	    /* Responsive adjustments affecting the overall layout */
	     @media (max-width: 768px) {
	         body {
	             flex-direction: column; /* Stack body elements vertically */
	         }
	         .dashboard-container {
	             flex-direction: column; /* Stack sidebar (now top bar) and content */
	         }
	         .main-content {
	             height: auto; /* Allow content height to be natural */
	             padding: 20px;
	             overflow-y: visible; /* Or keep auto if needed */
	         }
	     }
    </style>
</head>
<body>
    <div class="dashboard-container">

        <!-- Include Admin Navigation Sidebar -->
        <jsp:include page="/WEB-INF/includes/adminNav.jsp" />

        <!-- Main Content Area for User Management -->
        <main class="main-content">
            <h1>Manage Users</h1>

            <%-- Display messages if passed via redirect --%>
             <c:if test="${not empty param.message}">
                 <div class="status-message info">${param.message}</div>
             </c:if>
            <c:if test="${not empty param.success}">
                <div class="status-message success">${param.success}</div>
            </c:if>
            <c:if test="${not empty param.error}">
                <div class="status-message error">${param.error}</div>
            </c:if>

            <div class="users-main-container">
                <div class="users-header">
                    <h2>All Users</h2>
                    <%-- No Add button for now --%>
                </div>

                <div class="table-wrapper">
                    <table class="users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>User</th>
                                <th>Contact</th>
                                <th>Role</th>
                                <th>Joined</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- === Static Placeholder Row 1 === --%>
                            <tr>
                                <td data-label="ID:"><span class="user-id">101</span></td>
                                <td data-label="User:">
                                    <div class="user-details-cell">
                                        <img class="profile-img-sm" src="${pageContext.request.contextPath}/images/defaultuserprofile.jpg" alt="Placeholder User">
                                        <div class="user-name-email">
                                            <span class="user-name">Alice Admin</span>
                                            <span class="user-email">alice.admin@example.com</span>
                                        </div>
                                    </div>
                                </td>
                                <td data-label="Contact:">123-456-7890</td>
                                <td data-label="Role:"><span class="user-role admin">Admin</span></td>
                                <td data-label="Joined:">Jan 15, 2024</td>
                                <td class="actions-cell">
                                     <%-- The delete button form - submits to POST handler (which currently just redirects) --%>
                                     <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;" onsubmit="alert('Delete action not implemented yet.'); return false;">
                                         <input type="hidden" name="action" value="delete">
                                         <input type="hidden" name="userId" value="101"> <%-- Dummy ID --%>
                                         <button type="submit" class="action-btn delete-btn" title="Delete User (Not Implemented)">Delete</button>
                                     </form>
                                </td>
                            </tr>
                            <%-- === Static Placeholder Row 2 === --%>
                            <tr>
                                <td data-label="ID:"><span class="user-id">102</span></td>
                                <td data-label="User:">
                                    <div class="user-details-cell">
                                        <img class="profile-img-sm" src="${pageContext.request.contextPath}/images/defaultuserprofile.jpg" alt="Placeholder User 2">
                                        <div class="user-name-email">
                                            <span class="user-name">Bob Customer</span>
                                            <span class="user-email">bob.c@sample.net</span>
                                        </div>
                                    </div>
                                </td>
                                <td data-label="Contact:">987-654-3210</td>
                                <td data-label="Role:"><span class="user-role customer">Customer</span></td>
                                <td data-label="Joined:">Mar 22, 2024</td>
                                <td class="actions-cell">
                                     <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;" onsubmit="alert('Delete action not implemented yet.'); return false;">
                                         <input type="hidden" name="action" value="delete">
                                         <input type="hidden" name="userId" value="102">
                                         <button type="submit" class="action-btn delete-btn" title="Delete User (Not Implemented)">Delete</button>
                                     </form>
                                </td>
                            </tr>
                             <%-- === Static Placeholder Row 3 === --%>
                            <tr>
                                <td data-label="ID:"><span class="user-id">103</span></td>
                                <td data-label="User:">
                                    <div class="user-details-cell">
                                        <img class="profile-img-sm" src="${pageContext.request.contextPath}/images/defaultuserprofile.jpg" alt="Placeholder User 3">
                                        <div class="user-name-email">
                                            <span class="user-name">Charlie Another</span>
                                            <span class="user-email">charlie@domain.org</span>
                                        </div>
                                    </div>
                                </td>
                                <td data-label="Contact:">N/A</td>
                                <td data-label="Role:"><span class="user-role customer">Customer</span></td>
                                <td data-label="Joined:">Apr 01, 2024</td>
                                <td class="actions-cell">
                                     <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;" onsubmit="alert('Delete action not implemented yet.'); return false;">
                                         <input type="hidden" name="action" value="delete">
                                         <input type="hidden" name="userId" value="103">
                                         <button type="submit" class="action-btn delete-btn" title="Delete User (Not Implemented)">Delete</button>
                                     </form>
                                </td>
                            </tr>
                            <%-- Add more static rows if needed --%>
                        </tbody>
                    </table>
                </div> <%-- End table-wrapper --%>

                <p style="text-align: center; margin-top: 20px; color: var(--text-light); font-style: italic;">
                    (Displaying static placeholder data. Database connection is currently disabled for this view.)
                </p>

            </div> <%-- End users-main-container --%>
        </main> <%-- End main-content --%>
    </div> <%-- End dashboard-container --%>
</body>
</html>