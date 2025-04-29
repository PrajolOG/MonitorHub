<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Products - Admin Panel</title>

    <%-- Link CSS files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminProducts.css"> <%-- Styles for this page --%>
     <%-- Optional: Link FontAwesome if using icons --%>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <%-- Base styles (Similar to admindashboard.jsp for consistency) --%>
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root { /* Ensure your CSS Variables are defined here or in a global CSS file */
            --primary-purple: #9d4edd; --secondary-purple: #c77dff;
            --gradient: linear-gradient(90deg, var(--primary-purple) 0%, var(--secondary-purple) 100%);
            --bg-light-start: #f5f7fa; --bg-light-end: #c3cfe2;
            --bg-body-gradient: linear-gradient(135deg, var(--bg-light-start) 0%, var(--bg-light-end) 100%);
            --sidebar-bg: rgba(255, 255, 255, 0.5); --sidebar-border: rgba(255, 255, 255, 0.25);
            --card-bg: rgba(255, 255, 255, 0.75); --text-dark: #2d3748; --text-medium: #4a5568;
            --text-light: #718096; --white: #ffffff; --hover-bg: rgba(157, 78, 221, 0.05); /* Reduced opacity */
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
        .admin-body-container { /* Container for sidebar + main */
            display: flex; width: 100%;
        }
        .admin-main-content { /* Main content area */
            flex-grow: 1; padding: 30px; overflow-y: auto;
        }
        .admin-main-content > h1 { /* Page title */
            font-size: 28px; margin-bottom: 20px; color: var(--text-dark);
            border-bottom: 1px solid var(--border-medium); padding-bottom: 10px; font-weight: 600;
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

        <!-- Include the Sidebar Navigation -->
        <jsp:include page="/WEB-INF/includes/adminNav.jsp" />

        <!-- Main Content Area -->
        <main class="admin-main-content">
            <h1>Manage Products</h1>

            <!-- Actions Bar (Add New Product Button) -->
            <div class="actions-bar">
                <button class="btn btn-add" onclick="location.href='${pageContext.request.contextPath}/admin/products/add';">
                    <i class="fas fa-plus"></i> Add New Product
                </button>
            </div>

            <!-- Products Table Container -->
            <div class="content-box table-container"> <%-- Box styling container --%>
                 <h2>All Monitors</h2> <%-- Subheading inside the box --%>
                 <div class="table-wrapper"> <%-- Wrapper for horizontal scroll --%>
                    <table class="data-table product-table"> <%-- Shared and specific table classes --%>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Image</th>
                                <th>Name</th>
                                <th>Brand</th>
                                <th>Model</th>
                                <th>Price</th>
                                <th>Stock</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty requestScope.products}">
                                    <c:forEach var="product" items="${requestScope.products}">
                                        <tr>
                                            <td><c:out value="${product.id}"/></td>
                                            <td class="product-image-cell">
                                                <img class="table-product-image"
                                                     src="${not empty product.imageUrl ? product.imageUrl : pageContext.request.contextPath.concat('/images/defaultmonitor.png')}"
                                                     alt="<c:out value='${product.name}'/>"
                                                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultmonitor.png';">
                                            </td>
                                            <td class="product-name-cell" title="${product.name}"><c:out value="${product.name}"/></td>
                                            <td><c:out value="${product.brand}"/></td>
                                            <td><c:out value="${product.model}"/></td>
                                            <td>
                                                <fmt:setLocale value="en_US"/>
                                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" />
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${product.stock > 10}">
                                                        <span class="status-badge stock-high"><c:out value="${product.stock}"/> In Stock</span>
                                                    </c:when>
                                                    <c:when test="${product.stock > 0}">
                                                        <span class="status-badge stock-low"><c:out value="${product.stock}"/> Low Stock</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge stock-out">Out of Stock</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="actions-cell">
                                                <%-- Use icons for actions --%>
                                                    <a href="${pageContext.request.contextPath}/admin/products/edit?id=${product.id}" class="btn-action btn-edit" title="Edit Product ${product.id}"><i class="fas fa-pencil-alt"></i></a>
    
                                                <button class="btn-action btn-delete" title="Delete Product ${product.id}"><i class="fas fa-trash-alt"></i></button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="no-data-message">No products found. Add a new product to get started.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div> <%-- End table-wrapper --%>
            </div> <%-- End content-box table-container --%>

        </main> <%-- End admin-main-content --%>

    </div> <%-- End admin-body-container --%>

</body>
</html>