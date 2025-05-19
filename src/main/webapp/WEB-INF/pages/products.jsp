<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - MonitorHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/products.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">
        <section class="products-header">
            <h1>Our Monitor Collection</h1>
            <p>Discover our wide range of high-quality monitors for gaming, professional work, and everyday use.</p>
        </section>

        <div class="products-grid">
            <c:choose>
                <c:when test="${not empty productList}">
                    <c:forEach var="product" items="${productList}">
                        <div class="product-card">
                            <c:if test="${product.stock_quantity <= 0}">
                                <div class="product-stock-status out-of-stock">
                                    Out of Stock
                                </div>
                            </c:if>

                            <div class="product-image-container">
                                <img src="${not empty product.imageUrl ? product.imageUrl : pageContext.request.contextPath.concat('/images/defaultmonitor.png')}"
                                     alt="<c:out value='${product.name}'/>"
                                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultmonitor.png';">
                            </div>

                            <div class="product-content">
                                <h3><c:out value="${product.name}"/></h3>
                                <p class="product-description">
                                    <c:choose>
                                        <c:when test="${not empty product.description}">
                                            <c:set var="desc" value="${product.description}" />
                                            <c:out value="${desc.length() > 120 ? desc.substring(0, 117).concat('...') : desc}" />
                                        </c:when>
                                        <c:otherwise>A great choice for your display needs.</c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="price">
                                    <fmt:setLocale value="en_US"/>
                                    <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" />
                                    <c:if test="${product.hasDiscount()}">
                                        <span class="old-price">
                                            <fmt:formatNumber value="${product.original_price}" type="currency" currencySymbol="$" />
                                        </span>
                                    </c:if>
                                </p>
                            </div>
                            <c:choose>
                                <c:when test="${product.stock_quantity <= 0}">
                                    <button class="cta-button" disabled>View Details</button>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}" class="cta-button">View Details</a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="grid-column: 1 / -1; text-align: center; padding: 20px;">
                        No products currently available. Please check back later!
                    </p>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>