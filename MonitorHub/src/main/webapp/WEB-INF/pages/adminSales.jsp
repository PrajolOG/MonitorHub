<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sales Records - Admin Panel</title>

    <%-- Link CSS files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminSales.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <%-- Base styles (Same as before) --%>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { /* Use your defined CSS Variables */
            --primary-purple: #9d4edd; --secondary-purple: #c77dff;
            --gradient: linear-gradient(90deg, var(--primary-purple) 0%, var(--secondary-purple) 100%);
            --bg-light-start: #f5f7fa; --bg-light-end: #c3cfe2;
            --bg-body-gradient: linear-gradient(135deg, var(--bg-light-start) 0%, var(--bg-light-end) 100%);
            --sidebar-bg: rgba(255, 255, 255, 0.5); --sidebar-border: rgba(255, 255, 255, 0.25);
            --card-bg: rgba(255, 255, 255, 0.75); --text-dark: #2d3748; --text-medium: #4a5568;
            --text-light: #718096; --white: #ffffff; --hover-bg: rgba(157, 78, 221, 0.05);
            --border-light: #e2e8f0; --border-medium: #cbd5e0;
            --danger-red: #e53e3e; --success-green: #38a169;
             --warning-orange: #dd6b20; --info-blue: #3182ce;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-light-start); background-image: var(--bg-body-gradient);
            color: var(--text-dark); margin: 0; display: flex; min-height: 100vh;
            background-attachment: fixed;
        }
        .admin-body-container { display: flex; width: 100%; }
        .admin-main-content { flex-grow: 1; padding: 30px; overflow-y: auto; }
        .admin-main-content > h1 {
            font-size: 28px; margin-bottom: 20px; color: var(--text-dark);
            border-bottom: 1px solid var(--border-medium); padding-bottom: 10px; font-weight: 600;
        }
        /* Base responsive styles (Same as before) */
         @media (max-width: 768px) {
             body { flex-direction: column; }
             .admin-body-container { flex-direction: column; }
             .admin-main-content { height: auto; padding: 20px; overflow-y: visible; }
             .admin-main-content > h1 { font-size: 24px; }
         }
    </style>
</head>
<body>

    <div class="admin-body-container">

        <!-- Include Sidebar -->
        <jsp:include page="/WEB-INF/includes/adminNav.jsp" />

        <!-- Main Content Area -->
        <main class="admin-main-content">
            <h1>Sales Records</h1>

            <!-- Sales Table Container -->
            <div class="content-box table-container">
                 <h2>All Sales Transactions</h2>
                 <div class="table-wrapper">
                    <table class="data-table sales-table">
                        <thead>
                            <tr>
                                <th>Sale ID</th>
                                <th>Customer</th> <%-- Combined Customer Header --%>
                                <th>Product</th>
                                <th>Date</th>
                                <th>Qty</th>
                                <th>Price/Item</th>
                                <th>Total Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty salesData}">
                                    <c:forEach var="sale" items="${salesData}">
                                        <tr>
                                            <td class="sale-id"><a href="#" title="View Sale #${sale.saleId}">#${sale.saleId}</a></td>
                                            <td class="customer-cell"> <%-- Cell for image + name --%>
                                                <img class="table-customer-image"
                                                     src="${not empty sale.customerImageUrl ? sale.customerImageUrl : pageContext.request.contextPath.concat('/images/defaultuserprofile.jpg')}"
                                                     alt="Customer Avatar"
                                                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultuserprofile.jpg';">
                                                <span class="customer-name" title="${sale.customerName}"><c:out value="${sale.customerName}"/></span>
                                            </td>
                                            <td class="product-name-cell" title="${sale.productName}"><c:out value="${sale.productName}"/></td>
                                            <td>
                                                <fmt:formatDate value="${sale.saleDate}" pattern="MMM dd, yyyy HH:mm"/>
                                            </td>
                                            <td class="numeric-cell qty-cell"><c:out value="${sale.quantity}"/></td>
                                            <td class="numeric-cell price-cell">
                                                <fmt:formatNumber value="${sale.pricePerItem}" type="currency" currencySymbol="$" />
                                            </td>
                                            <td class="numeric-cell total-cell">
                                                 <fmt:formatNumber value="${sale.totalAmount}" type="currency" currencySymbol="$" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="no-data-message">No sales data found.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div> <%-- End table-wrapper --%>
            </div> <%-- End content-box table-container --%>

            <!-- Sales Summary Metrics -->
            <section class="sales-summary-metrics">
                 <div class="metric-box">
                     <div class="metric-icon"><i class="fas fa-dollar-sign"></i></div>
                     <div class="metric-content">
                         <div class="metric-title">Total Revenue</div>
                         <div class="metric-value">
                             <fmt:formatNumber value="${summaryMetrics.totalRevenue}" type="currency" currencySymbol="$" />
                         </div>
                     </div>
                 </div>
                   <div class="metric-box">
                       <div class="metric-icon"><i class="fas fa-receipt"></i></div>
                       <div class="metric-content">
                           <div class="metric-title">Number of Sales</div>
                           <div class="metric-value">
                               <fmt:formatNumber value="${summaryMetrics.numberOfSales}" type="number" groupingUsed="true"/>
                           </div>
                       </div>
                   </div>
            </section>

        </main> <%-- End admin-main-content --%>

    </div> <%-- End admin-body-container --%>

</body>
</html>