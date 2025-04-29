<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Orders - Admin</title>

    <%-- Link CSS files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminOrders.css"> <%-- Link the specific CSS --%>

    <%-- === CORRECTED Base styles needed for overall layout (MUST MATCH other admin pages) === --%>
    <style>
        /* Basic Reset & Font */
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
            /* REMOVED height: 100vh; - This was the likely cause of the inconsistency */
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
    <%-- === End Base Styles === --%>
</head>
<body>
    <div class="dashboard-container">

        <!-- Include Admin Navigation Sidebar -->
        <jsp:include page="/WEB-INF/includes/adminNav.jsp" />

        <!-- Main Content Area for Order Management -->
        <main class="main-content">
            <h1>Manage Orders</h1>

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

            <div class="orders-main-container">
                <div class="orders-header">
                    <h2>All Orders</h2>
                    <%-- Add filters or search bar here later --%>
                </div>

                <div class="table-wrapper">
                    <table class="orders-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Items</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%-- === Static Placeholder Row 1 === --%>
                            <tr>
                                <td data-label="Order ID:"><a href="#" class="order-id">#5001</a></td>
                                <td data-label="Customer:">
                                     <div class="customer-cell">
                                        <img class="profile-img-sm" src="${pageContext.request.contextPath}/images/defaultuserprofile.jpg" alt="Customer">
                                        <div class="customer-details">
                                            <span class="customer-name">Bob Customer</span>
                                            <span class="customer-email">bob.c@sample.net</span>
                                        </div>
                                    </div>
                                </td>
                                <td data-label="Date:">Apr 25, 2025</td>
                                <td data-label="Amount:">$199.99</td>
                                <td data-label="Items:">1</td>
                                <td data-label="Status:"><span class="order-status pending">Pending</span></td>
                                <td class="actions-cell">
                                    <button type="button" class="action-btn approve-btn" onclick="alert('Approve Action (Not Implemented)');">Approve</button>
                                    <button type="button" class="action-btn cancel-btn" onclick="alert('Cancel Action (Not Implemented)');">Cancel</button>
                                </td>
                            </tr>
                             <%-- === Static Placeholder Row 2 === --%>
                             <tr>
                                <td data-label="Order ID:"><a href="#" class="order-id">#5002</a></td>
                                <td data-label="Customer:">
                                     <div class="customer-cell">
                                        <img class="profile-img-sm" src="${pageContext.request.contextPath}/images/defaultuserprofile.jpg" alt="Customer">
                                        <div class="customer-details">
                                            <span class="customer-name">Charlie Another</span>
                                            <span class="customer-email">charlie@domain.org</span>
                                        </div>
                                    </div>
                                </td>
                                <td data-label="Date:">Apr 24, 2025</td>
                                <td data-label="Amount:">$345.50</td>
                                <td data-label="Items:">2</td>
                                <td data-label="Status:"><span class="order-status approved">Approved</span></td>
                                <td class="actions-cell">
                                     <button type="button" class="action-btn approve-btn" disabled>Approve</button> <%-- Example disabled --%>
                                    <button type="button" class="action-btn cancel-btn" onclick="alert('Cancel Action (Not Implemented)');">Cancel</button>
                                </td>
                            </tr>
                            <%-- === Static Placeholder Row 3 === --%>
                             <tr>
                                <td data-label="Order ID:"><a href="#" class="order-id">#5003</a></td>
                                <td data-label="Customer:">
                                     <div class="customer-cell">
                                        <img class="profile-img-sm" src="${pageContext.request.contextPath}/images/defaultuserprofile.jpg" alt="Customer">
                                        <div class="customer-details">
                                            <span class="customer-name">Alice Admin</span> <%-- Can be any user --%>
                                            <span class="customer-email">alice.admin@example.com</span>
                                        </div>
                                    </div>
                                </td>
                                <td data-label="Date:">Apr 23, 2025</td>
                                <td data-label="Amount:">$99.00</td>
                                <td data-label="Items:">1</td>
                                <td data-label="Status:"><span class="order-status cancelled">Cancelled</span></td>
                                <td class="actions-cell">
                                    <button type="button" class="action-btn approve-btn" disabled>Approve</button>
                                    <button type="button" class="action-btn cancel-btn" disabled>Cancel</button>
                                </td>
                            </tr>
                            <%-- Add more static rows as needed --%>
                        </tbody>
                    </table>
                </div> <%-- End table-wrapper --%>

                <p style="text-align: center; margin-top: 20px; color: var(--text-light); font-style: italic;">
                    (Displaying static placeholder order data.)
                </p>

            </div> <%-- End orders-main-container --%>
        </main> <%-- End main-content --%>
    </div> <%-- End dashboard-container --%>
</body>
</html>