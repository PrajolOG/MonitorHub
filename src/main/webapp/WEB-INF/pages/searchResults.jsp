<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Search Results <c:if test="${not empty searchQuery}">for "<c:out value="${searchQuery}"/>"</c:if> - MonitorHub</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
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
        }

        .main-search-content {
            max-width: 1140px;
            margin: 30px auto;
            padding: 20px;
            min-height: 60vh;
        }

        .search-results-heading {
            text-align: center;
            margin-bottom: 30px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e0e0e0;
        }

        .search-results-heading h1 {
            font-size: 2em;
            color: #333;
            margin-bottom: 5px;
        }

        .search-results-heading p {
            font-size: 1.1em;
            color: #555;
        }

        .status-message-search {
            text-align: center;
            padding: 15px;
            margin: 20px auto;
            border-radius: 6px;
            max-width: 700px;
            font-size: 1em;
        }

        .status-message-search.error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .status-message-search.info {
            background-color: #fff;
            color: #383d41;
            border: 1px solid #d6d8db;
        }

        .search-results-list-container {
            background-color: var(--card-bg, rgba(255, 255, 255, 0.75));
            border: 1px solid #d1d5db;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
            padding: 10px 0;
        }

        .search-results-list-container ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .search-results-list-container li a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            text-decoration: none;
            color: #1f2937;
            border-bottom: 1px solid #e5e7eb;
            transition: background-color 0.2s ease-in-out;
        }

        .search-results-list-container li:last-child a {
            border-bottom: none;
        }

        .search-results-list-container li a:hover {
            background-color: #eaf0f6;
        }

        .search-result-item-image {
            width: 50px;
            height: 50px;
            object-fit: contain;
            margin-right: 15px;
            border-radius: 6px;
            flex-shrink: 0;
            background-color: #f3f4f6;
        }

        .search-result-item-details .name {
            font-weight: 600;
            font-size: 1em;
            color: #111827;
            margin-bottom: 3px;
        }

        .search-result-item-details .model {
            font-size: 0.85em;
            color: #6b7280;
        }
    </style>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-search-content">
        <div class="search-results-heading">
            <h1>Search Results</h1>
            <c:if test="${not empty searchQuery}">
                <p>For query: <strong>"<c:out value="${searchQuery}"/>"</strong></p>
            </c:if>
        </div>

        <c:if test="${not empty pageErrorMessage}">
            <div class="status-message-search error"><p><c:out value="${pageErrorMessage}"/></p></div>
        </c:if>

        <c:if test="${not empty userMessage}">
            <div class="status-message-search info"><p><c:out value="${userMessage}"/></p></div>
        </c:if>

        <c:if test="${empty pageErrorMessage and not empty searchResults}">
            <div class="search-results-list-container">
                <ul>
                    <c:forEach var="product" items="${searchResults}">
                        <li>
                            <a href="${pageContext.request.contextPath}/product-detail?id=${product.id}">
                                <img src="${not empty product.imageUrl ? product.imageUrl : pageContext.request.contextPath.concat('/images/defaultmonitor.png')}"
                                     alt="" class="search-result-item-image"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/images/defaultmonitor.png';">
                                <div class="search-result-item-details">
                                    <div class="name"><c:out value="${product.name}"/></div>
                                    <c:if test="${not empty product.model}">
                                        <div class="model">Model: <c:out value="${product.model}"/></div>
                                    </c:if>
                                </div>
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>