<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> <%-- For formatting numbers/dates --%>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - MonitorHub</title>

    <%-- Link the specific CSS files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/admindashboard.css">

    <%-- Keep essential base styles & variables here OR move to a shared base CSS file --%>
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

        <!-- Include the Sidebar Navigation -->
        <jsp:include page="/WEB-INF/includes/adminNav.jsp" />

        <!-- Main Content Area (Specific to Dashboard) -->
        <main class="main-content">
            <h1>Admin Dashboard</h1>

            <!-- Summary Cards -->
            <section class="summary-cards">
                 <%-- Use JSTL fmt tag for currency/number formatting --%>
                 <fmt:setLocale value="en_US"/> <%-- Set locale for formatting --%>
                <div class="summary-card sales">
                    <div class="card-icon">💲</div>
                    <div class="card-content">
                        <div class="card-title">Total Sales</div>
                        <%-- Example: Provide default if value is null --%>
                        <div class="card-value"><fmt:formatNumber value="${not empty totalSalesValue ? totalSalesValue : 0}" type="currency"/></div>
                    </div>
                </div>
                <div class="summary-card users">
                    <div class="card-icon">👥</div>
                    <div class="card-content">
                        <div class="card-title">Total Users</div>
                        <div class="card-value"><fmt:formatNumber value="${not empty totalUsersCount ? totalUsersCount : 0}" type="number"/></div>
                    </div>
                </div>
                <div class="summary-card stock">
                    <div class="card-icon">📦</div>
                    <div class="card-content">
                        <div class="card-title">Total Stock Items</div>
                         <div class="card-value"><fmt:formatNumber value="${not empty totalStockQuantity ? totalStockQuantity : 0}" type="number"/></div>
                    </div>
                </div>
                 <%-- Add more cards as needed --%>
            </section>

            <!-- Main Layout Grid -->
            <section class="main-layout">

                <!-- Top Selling Monitors -->
                <div class="content-box top-products-container">
                    <h2>Best Selling Monitors</h2>
                    <div class="top-products-grid">
                        <%-- Loop through top selling products passed from Servlet --%>
                        <c:choose>
                           <c:when test="${not empty topSellingMonitors}">
                                <c:forEach var="product" items="${topSellingMonitors}">
                                    <div class="product-card">
                                        <%-- Assume product object has imageUrl, name, category, salesCount, price --%>
                                        <img class="product-image"
                                             src="${not empty product.imageUrl ? product.imageUrl : pageContext.request.contextPath.concat('/images/defaultmonitor.png')}"
                                             alt="${product.name}"
                                             onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultmonitor.png';">
                                        <div class="product-info">
                                            <span class="product-name" title="${product.name}">${product.name}</span> <%-- Added title for full name on hover --%>
                                            <span class="product-category">${not empty product.category ? product.category : 'Uncategorized'}</span>
                                            <span class="product-sales"><fmt:formatNumber value="${product.salesCount}" type="number"/> Sales</span>
                                        </div>
                                        <span class="product-price"><fmt:formatNumber value="${product.price}" type="currency"/></span>
                                    </div>
                                </c:forEach>
                           </c:when>
                           <c:otherwise>
                               <p style="padding: 15px 0; text-align: center; color: var(--text-light);">No best-selling product data available.</p>
                           </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Recent Orders -->
                <div class="content-box recent-orders">
                    <div class="box-header">
                        <h2>Recent Orders</h2>
                        <a href="<%= request.getContextPath() %>/admin/orders" class="view-all-btn">View All Orders</a>
                    </div>
                    <div class="table-wrapper">
                        <table class="orders-table">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Items</th> <%-- Example extra column --%>
                                </tr>
                            </thead>
                            <tbody>
                                 <%-- Loop through recent orders passed from Servlet --%>
                                <c:choose>
                                   <c:when test="${not empty recentOrders}">
                                        <c:forEach var="order" items="${recentOrders}">
                                             <tr>
                                                 <%-- Assume order object has id, customerName, customerEmail, customerAvatarUrl, orderDate, totalAmount, itemCount --%>
                                                 <td><a href="${pageContext.request.contextPath}/admin/orders/details?id=${order.id}" class="order-id" title="View Order #${order.id}">#${order.id}</a></td> <%-- Link to order detail --%>
                                                 <td>
                                                     <div class="customer-cell">
                                                         <img src="${not empty order.customerAvatarUrl ? order.customerAvatarUrl : pageContext.request.contextPath.concat('/images/defaultuserprofile.jpg')}"
                                                              alt="Avatar"
                                                              onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultuserprofile.jpg';">
                                                         <div class="customer-details">
                                                             <span class="customer-name" title="${order.customerName}">${order.customerName}</span>
                                                             <span class="customer-email" title="${order.customerEmail}">${order.customerEmail}</span>
                                                         </div>
                                                     </div>
                                                 </td>
                                                 <td>
                                                     <c:if test="${not empty order.orderDate}">
                                                        <fmt:formatDate value="${order.orderDate}" pattern="MMM dd, yyyy HH:mm"/>
                                                     </c:if>
                                                     <c:if test="${empty order.orderDate}">
                                                         N/A
                                                     </c:if>
                                                 </td>
                                                 <td><fmt:formatNumber value="${order.totalAmount}" type="currency"/></td>
                                                 <td>${order.itemCount}</td>
                                             </tr>
                                        </c:forEach>
                                   </c:when>
                                   <c:otherwise>
                                       <tr><td colspan="5" style="text-align:center; padding: 20px; color: var(--text-light);">No recent orders found.</td></tr>
                                   </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </section> <%-- End main-layout --%>

        </main> <%-- End main-content --%>

    </div> <%-- End dashboard-container --%>

    <%-- The profile toggle script is now inside adminNav.jsp --%>

</body>
</html>