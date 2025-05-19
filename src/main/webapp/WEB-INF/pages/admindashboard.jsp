<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - MonitorHub</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/admindashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">


    <style>
	    *, *::before, *::after {
	        box-sizing: border-box;
	        margin: 0;
	        padding: 0;
	    }
	    :root {
	        --primary-purple: #9d4edd; --secondary-purple: #c77dff;
	        --gradient: linear-gradient(90deg, var(--primary-purple) 0%, var(--secondary-purple) 100%);
	        --bg-light-start: #f5f7fa; --bg-light-end: #c3cfe2;
	        --bg-body-gradient: linear-gradient(135deg, var(--bg-light-start) 0%, var(--bg-light-end) 100%);
	        --sidebar-bg: rgba(255, 255, 255, 0.5); --sidebar-border: rgba(255, 255, 255, 0.25);
	        --card-bg: rgba(255, 255, 255, 0.85); /* Slightly more opaque card background */
            --text-dark: #2d3748; --text-medium: #4a5568;
	        --text-light: #718096; --white: #ffffff; --hover-bg: rgba(237, 242, 247, 0.8); /* Lighter hover for cards */
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
	        display: flex;
	        min-height: 100vh;
	        background-attachment: fixed;
	    }
	    .dashboard-container {
	        display: flex;
	        width: 100%;
	    }
	    .main-content {
	        flex-grow: 1;
	        padding: 30px;
	        overflow-y: auto;
	    }
	    .main-content > h1 {
	        font-size: 28px;
	        margin-bottom: 25px; /* Increased margin for spacing */
	        color: var(--text-dark);
            font-weight: 600; /* Bolder heading */
	    }
        .status-message { padding: 12px 18px; border-radius: 6px; margin: 0 0 20px 0; font-size: 14px; font-weight: 500; border: 1px solid transparent; }
        .status-message.success { background-color: var(--success-green-light); border-color: var(--success-green); color: #2f6f4a; }
        .status-message.error { background-color: var(--danger-red-light); border-color: var(--danger-red); color: #a11c1c; }
        .status-message.info { background-color: var(--info-blue-light); border-color: var(--info-blue); color: #2c5282; }
        .status-message i { margin-right: 8px; }

	     @media (max-width: 768px) {
	         body { flex-direction: column; }
	         .dashboard-container { flex-direction: column; }
	         .main-content { height: auto; padding: 20px; overflow-y: visible; }
             .main-content > h1 { font-size: 24px; margin-bottom: 20px; }
	     }
    </style>
</head>
<body>

    <div class="dashboard-container">

        <jsp:include page="/WEB-INF/includes/adminNav.jsp" />

        <main class="main-content">
            <h1>Admin Dashboard</h1>

            <c:if test="${not empty dashboardError}">
                <div class="status-message error"><i class="fas fa-exclamation-triangle"></i> <c:out value="${dashboardError}"/></div>
            </c:if>

            <section class="summary-cards">
                 <fmt:setLocale value="en_US"/>
                <div class="summary-card sales">
                    <div class="card-icon"><i class="fas fa-dollar-sign"></i></div>
                    <div class="card-content">
                        <div class="card-title">Total Sales</div>
                        <div class="card-value"><fmt:formatNumber value="${not empty totalSalesValue ? totalSalesValue : 0}" type="currency" currencySymbol="$" minFractionDigits="2" maxFractionDigits="2"/></div>
                    </div>
                </div>
                <div class="summary-card users">
                    <div class="card-icon"><i class="fas fa-users"></i></div>
                    <div class="card-content">
                        <div class="card-title">Total Users</div>
                        <div class="card-value"><fmt:formatNumber value="${not empty totalUsersCount ? totalUsersCount : 0}" type="number"/></div>
                    </div>
                </div>
                <div class="summary-card stock">
                    <div class="card-icon"><i class="fas fa-boxes-stacked"></i></div>
                    <div class="card-content">
                        <div class="card-title">Total Stock Items</div>
                         <div class="card-value"><fmt:formatNumber value="${not empty totalStockQuantity ? totalStockQuantity : 0}" type="number"/></div>
                    </div>
                </div>
            </section>

            <section class="main-layout">

                <div class="content-box top-products-container">
                    <h2>Best Selling Monitors</h2>
                    <div class="top-products-grid">
                        <c:choose>
                           <c:when test="${not empty topSellingMonitors}">
                                <c:forEach var="product" items="${topSellingMonitors}">
                                    <div class="product-card">
                                        <img class="product-image"
                                             src="${not empty product.imageUrl ? product.imageUrl : pageContext.request.contextPath.concat('/images/defaultmonitor.png')}"
                                             alt="<c:out value='${product.name}'/>"
                                             onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultmonitor.png';">
                                        <div class="product-info">
                                            <span class="product-name" title="${product.name}"><c:out value="${product.name}"/></span>
                                            <span class="product-category"><c:out value="${not empty product.category ? product.category : 'Uncategorized'}"/></span>
                                            <span class="product-sales"><fmt:formatNumber value="${product.salesCount}" type="number"/> Sales</span>
                                        </div>
                                        <span class="product-price"><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" minFractionDigits="2" maxFractionDigits="2"/></span>
                                    </div>
                                </c:forEach>
                           </c:when>
                           <c:otherwise>
                               <p class="no-data-message-inline">No best-selling product data available.</p>
                           </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="content-box recent-orders"> <%-- Kept class name recent-orders for CSS or change to recent-sales --%>
                    <div class="box-header">
                        <h2>Recent Sales</h2> <%-- Text changed --%>
                        <a href="${pageContext.request.contextPath}/admin/sales" class="view-all-btn">View All Sales</a> <%-- Link text changed --%>
                    </div>
                    <div class="table-wrapper">
                        <table class="orders-table"> <%-- Kept class name orders-table or change to recent-sales-table --%>
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Date</th>
                                    <th>Amount</th>
                                    <th>Items</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                   <c:when test="${not empty recentOrders}">
                                        <c:forEach var="order" items="${recentOrders}">
                                             <tr>
                                                 <td class="order-id-text">#<c:out value="${order.id}"/></td>
                                                 <td>
                                                     <div class="customer-cell">
                                                         <img src="${not empty order.customerAvatarUrl ? order.customerAvatarUrl : pageContext.request.contextPath.concat('/images/defaultuserprofile.jpg')}"
                                                              alt="Avatar"
                                                              onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultuserprofile.jpg';">
                                                         <div class="customer-details">
                                                             <span class="customer-name" title="${order.customerName}"><c:out value="${order.customerName}"/></span>
                                                             <span class="customer-email" title="${order.customerEmail}"><c:out value="${order.customerEmail}"/></span>
                                                         </div>
                                                     </div>
                                                 </td>
													<td>
													    <c:if test="${not empty order.orderDateAsUtilDate}">
													       <fmt:formatDate value="${order.orderDateAsUtilDate}" pattern="MMM dd, yyyy HH:mm"/>
													    </c:if>
													    <c:if test="${empty order.orderDateAsUtilDate}">N/A</c:if>
													</td>
                                                 <td><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="$" minFractionDigits="2" maxFractionDigits="2"/></td>
                                                 <td><c:out value="${order.itemCount}"/></td>
                                             </tr>
                                        </c:forEach>
                                   </c:when>
                                   <c:otherwise>
                                       <tr><td colspan="5" class="no-data-message-table">No recent sales found.</td></tr>
                                   </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>

            </section>

        </main>

    </div>
</body>
</html>