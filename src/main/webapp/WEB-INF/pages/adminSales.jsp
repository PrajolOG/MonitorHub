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

    <%-- Link to your CSS files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminSales.css"> <%-- Ensure this file exists and is styled --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <%-- Basic Styles (Keep or integrate into your main CSS) --%>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
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
         /* Style for DB Error Message */
         .db-error-message {
             padding: 10px 15px; margin-bottom: 20px; border-radius: 4px;
             background-color: rgba(229, 62, 62, 0.1); color: #a11c1c;
             border: 1px solid rgba(229, 62, 62, 0.3); font-weight: 500;
         }
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

        <jsp:include page="/WEB-INF/includes/adminNav.jsp" />

        <main class="admin-main-content">
            <h1>Sales Records</h1>

            <%-- Display Database Error if present --%>
            <c:if test="${not empty dbError}">
                <div class="db-error-message">
                    <i class="fas fa-database"></i> <c:out value="${dbError}" />
                </div>
            </c:if>

            <%-- Sales Table Container --%>
            <div class="content-box table-container">
                 <h2>All Sales Transactions</h2>
                 <div class="table-wrapper">
                    <table class="data-table sales-table">
                        <thead>
                            <tr>
                                <th>Order ID</th>
                                <th>Customer Name</th>
                                <th>Product</th>
                                <th>Product ID</th>
                                <th>Order Date</th>
                                <th>Qty</th>
                                <th>Price/Item</th>
                                <th>Total Amount</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty salesData}">
                                    <c:forEach var="order" items="${salesData}">
                                        <tr>
                                            <td class="order-id">#<c:out value="${order.orderId}"/></td>
                                            <td class="customer-name-cell" title="<c:out value='${order.userName}'/>">
                                                <span class="customer-name"><c:out value="${order.userName}"/></span>
                                            </td>
                                            <td class="product-name-cell" title="<c:out value='${order.productName}'/>"><c:out value="${order.productName}"/></td>
                                            <td class="numeric-cell product-id-cell"><c:out value="${order.productId}"/></td>
                                            <td>
                                                <%-- ** USE THE CONVERTED DATE FIELD (orderDateForJsp) ** --%>
                                                <c:if test="${not empty order.orderDateForJsp}">
                                                    <fmt:formatDate value="${order.orderDateForJsp}" pattern="MMM dd, yyyy HH:mm"/>
                                                </c:if>
                                                <c:if test="${empty order.orderDateForJsp}">N/A</c:if>
                                            </td>
                                            <td class="numeric-cell qty-cell"><c:out value="${order.quantity}"/></td>
                                            <td class="numeric-cell price-cell">
                                                <fmt:formatNumber value="${order.pricePerUnit}" type="currency" currencySymbol="$" />
                                            </td>
                                            <td class="numeric-cell total-cell">
                                                 <fmt:formatNumber value="${order.totalPrice}" type="currency" currencySymbol="$" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <%-- Display 'No data' only if there wasn't a DB error --%>
                                <c:when test="${empty dbError}">
                                    <tr>
                                        <td colspan="8" class="no-data-message">No sales data found.</td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                     <%-- Empty row if there was a DB error, message shown above --%>
                                     <tr><td colspan="8" style="display:none;"></td></tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Sales Summary Metrics --%>
            <section class="sales-summary-metrics">
                 <div class="metric-box">
                     <div class="metric-icon"><i class="fas fa-dollar-sign"></i></div>
                     <div class="metric-content">
                         <div class="metric-title">Total Revenue</div>
                         <div class="metric-value">
                             <fmt:formatNumber value="${summaryMetrics.totalRevenue}" type="currency" currencySymbol="$" minFractionDigits="2" maxFractionDigits="2"/>
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