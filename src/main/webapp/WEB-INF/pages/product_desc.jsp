<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:choose><c:when test="${not empty product}">${product.name} - MonitorHub</c:when><c:otherwise>Product Not Found - MonitorHub</c:otherwise></c:choose></title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/product_desc.css">
    <script>
        let modalOverlay, modalTitleEl, modalMessageEl, modalCloseButtonEl;

        document.addEventListener('DOMContentLoaded', () => {
            modalOverlay = document.getElementById('customModal');
            modalTitleEl = document.getElementById('modalTitle');
            modalMessageEl = document.getElementById('modalMessage');
            modalCloseButtonEl = document.getElementById('modalCloseButton');
            
            if (modalOverlay) { // Check if modalOverlay itself exists
                if (modalCloseButtonEl) {
                    modalCloseButtonEl.addEventListener('click', hideCustomModal);
                }
                modalOverlay.addEventListener('click', function(event) {
                    if (modalOverlay && event.target === modalOverlay) { 
                        hideCustomModal();
                    }
                });
            } else {
                console.error("Modal element #customModal not found in the DOM.");
            }
        });

        function showCustomModal(title, message, type = 'info') {
            // Ensure elements are found
            if (!modalOverlay || !modalTitleEl || !modalMessageEl) {
                console.error("Modal elements not properly initialized. Falling back to alert.");
                alert(title + "\n" + message);
                return;
            }
            
            modalTitleEl.textContent = title;
            modalMessageEl.textContent = message;
            const modalContent = modalOverlay.querySelector('.modal-content');
            if (modalContent) {
                modalContent.className = 'modal-content'; // Reset classes, then add type
                modalContent.classList.add(type);
            }
            
            modalOverlay.style.display = 'flex';
            void modalOverlay.offsetWidth; // Force reflow for transition
            modalOverlay.classList.add('visible');
        }

        function hideCustomModal() {
            if (modalOverlay) {
                modalOverlay.classList.remove('visible');
                setTimeout(() => {
                    if (modalOverlay && !modalOverlay.classList.contains('visible')) { 
                        modalOverlay.style.display = 'none';
                    }
                }, 300); // Match transition-duration in CSS
            }
        }

        function handleBuyNow(productId, productName) {
            console.log("handleBuyNow called for product ID:", productId);
            const isLoggedIn = <%= session.getAttribute("user") != null %>;
            console.log("isLoggedIn (client-side):", isLoggedIn);

            // Always ensure the modal close button defaults to just hiding, unless specifically overridden
            if (modalCloseButtonEl) modalCloseButtonEl.onclick = hideCustomModal;

            if (!isLoggedIn) {
                showCustomModal("Login Required", "Please Login/Signup to make an order.", "info");
                if(modalCloseButtonEl) {
                    modalCloseButtonEl.onclick = function() { // Override for this specific case
                        hideCustomModal();
                        window.location.href = "${pageContext.request.contextPath}/login?redirect=" + encodeURIComponent("/product-detail?id=" + productId);
                    };
                }
                return;
            }

            const quantityInput = document.getElementById('quantity');
            let quantity = 1; 
            
            if (quantityInput) {
                quantity = parseInt(quantityInput.value);
                if (isNaN(quantity) || quantity <= 0) {
                    showCustomModal("Invalid Input", "Please enter a valid quantity (must be 1 or more).", "error");
                    if(quantityInput) quantityInput.focus();
                    return;
                }
                if (quantityInput.hasAttribute('max')) {
                    const maxQuantity = parseInt(quantityInput.getAttribute('max'));
                    if (quantity > maxQuantity) {
                        showCustomModal("Limit Reached", "You cannot order more than the allowed limit (" + maxQuantity + "). Stock will be verified.", "error");
                        if(quantityInput) quantityInput.focus();
                        return;
                    }
                }
            }

            const formData = new URLSearchParams();
            formData.append('productId', productId);
            formData.append('quantity', quantity);

            const buyButton = document.querySelector('.add-to-cart-btn');
            let originalButtonText = '';
            if (buyButton) {
                originalButtonText = buyButton.textContent;
                buyButton.disabled = true;
                buyButton.textContent = 'Processing...';
            }

            console.log("Attempting to fetch /order/place with data:", formData.toString());
            fetch("${pageContext.request.contextPath}/order/place", {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: formData.toString()
            })
            .then(response => {
                console.log("Fetch response status:", response.status);
                const contentType = response.headers.get("content-type");
                if (contentType && contentType.includes("application/json")) {
                    return response.json().then(data => ({ ok: response.ok, status: response.status, data }));
                }
                // If not JSON, it's likely an unexpected server error page or simple text
                return response.text().then(text => {
                    console.warn("Server response was not JSON. Text:", text);
                    // Try to provide a more specific message if it's an HTML error page
                    if (text.toLowerCase().includes("<html")) {
                         return { ok: false, status: response.status, data: { message: `Server error (Status: ${response.status}). Please try again.` } };
                    }
                    return { ok: false, status: response.status, data: { message: text || `Server responded with status ${response.status}` } };
                });
            })
            .then(result => {
                console.log("Fetch result data:", result.data);
                if (result.ok && result.data.success) {
                    showCustomModal("Order Placed!", result.data.message || "Your order is on its way!", "success");
                    if(buyButton) {
                        buyButton.textContent = 'Order Placed'; // Keep disabled
                    }
                } else {
                    showCustomModal("Order Problem", result.data.message || "Could not place your order. Please try again.", "error");
                    if(buyButton) {
                        if (result.status !== 409) { // Not a stock conflict (409 is SC_CONFLICT)
                            buyButton.disabled = false;
                            buyButton.textContent = originalButtonText;
                        } else { // Stock issue
                            buyButton.textContent = 'Out of Stock';
                            if(quantityInput) quantityInput.closest('.quantity-selector').style.display = 'none';
                            const stockStatusP = document.querySelector('.stock-status');
                            if(stockStatusP) {
                                stockStatusP.textContent = 'Out of Stock';
                                stockStatusP.classList.remove('in-stock');
                                stockStatusP.classList.add('out-of-stock');
                            }
                        }
                    }
                }
            })
            .catch(error => { // Catches network errors or JS errors in .then()
                console.error('Fetch/Processing Error in handleBuyNow:', error);
                showCustomModal("Network Error", "A network or system connection error occurred. Please check your connection and try again later.", "error");
                if(buyButton) {
                    buyButton.disabled = false;
                    buyButton.textContent = originalButtonText;
                }
            });
        }
    </script>
</head>
<body>
    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">
        <c:choose>
            <c:when test="${not empty product}">
                <div class="product-detail-container">
                    <div class="product-image-column">
                        <img src="${not empty product.imageUrl ? product.imageUrl : pageContext.request.contextPath.concat('/images/defaultmonitor.png')}"
                             alt="<c:out value='${product.name}'/>"
                             onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultmonitor.png';">
                    </div>

                    <div class="product-details-column">
                        <h1><c:out value="${product.name}"/></h1>
                        <c:if test="${not empty product.brand || not empty product.model}">
                            <p class="product-brand-model">
                                <c:if test="${not empty product.brand}">Brand: <c:out value="${product.brand}"/></c:if>
                                <c:if test="${not empty product.brand && not empty product.model}"> | </c:if>
                                <c:if test="${not empty product.model}">Model: <c:out value="${product.model}"/></c:if>
                            </p>
                        </c:if>

                        <div class="product-rating">
                            <span>⭐⭐⭐⭐⭐</span>
                            <span class="review-count">( Reviews)</span>
                        </div>

                        <div class="price-section">
                            <fmt:setLocale value="en_US"/>
                            <span class="current-price">
                                <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" />
                            </span>
                            <c:if test="${product.hasDiscount()}">
                                <span class="old-price">
                                    <fmt:formatNumber value="${product.original_price}" type="currency" currencySymbol="$" />
                                </span>
                            </c:if>
                        </div>

                        <p class="product-overview">
                            <c:out value="${product.description}"/>
                        </p>

                        <ul class="key-features">
                            <c:if test="${not empty product.type}"><li>Type: <c:out value="${product.type}"/></li></c:if>
                            <li>High Quality Display</li>
                            <li>Excellent Performance</li>
                        </ul>

                        <c:if test="${product.stock_quantity > 0}">
                            <div class="quantity-selector">
                                <label for="quantity">Quantity:</label>
                                <c:set var="maxOrderable" value="${product.stock_quantity > 10 ? 10 : product.stock_quantity}" />
                                <input type="number" id="quantity" name="quantity" value="1" min="1" max="${maxOrderable}">
                            </div>
                        </c:if>

                        <p class="stock-status ${product.stock_quantity > 0 ? 'in-stock' : 'out-of-stock'}">
                            ${product.stock_quantity > 0 ? 'In Stock' : 'Out of Stock'}
                            <c:if test="${product.stock_quantity > 0 && product.stock_quantity <= 10}">
                                (Only ${product.stock_quantity} left!)
                            </c:if>
                        </p>
                        
                        <button type="button" class="add-to-cart-btn"
                                onclick="handleBuyNow(${product.id}, '<c:out value="${product.name}" escapeXml="true"/>')"
                                <c:if test="${product.stock_quantity <= 0}">disabled</c:if>>
                            ${product.stock_quantity > 0 ? 'Buy Now' : 'Out of Stock'}
                        </button>
                        <c:if test="${not empty product.delivery_info}">
                            <p class="delivery-info-productpage">Delivery: <c:out value="${product.delivery_info}"/></p>
                        </c:if>
                    </div>
                </div>

                <section class="product-full-details">
                    <h2>Product Description</h2>
                    <p><c:out value="${product.description}" escapeXml="true"/></p> 

                    <h2>Specifications</h2>
                    <table class="spec-table">
                        <tbody>
                            <tr><th>Product Name</th><td><c:out value="${product.name}"/></td></tr>
                            <c:if test="${not empty product.brand}"><tr><th>Brand</th><td><c:out value="${product.brand}"/></td></tr></c:if>
                            <c:if test="${not empty product.model}"><tr><th>Model</th><td><c:out value="${product.model}"/></td></tr></c:if>
                            <c:if test="${not empty product.type}"><tr><th>Type</th><td><c:out value="${product.type}"/></td></tr></c:if>
                            <tr><th>Price</th><td><fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" /></td></tr>
                            <tr><th>Availability</th><td>${product.stock_quantity > 0 ? 'In Stock' : 'Out of Stock'} (<c:out value="${product.stock_quantity}"/> units)</td></tr>
                        </tbody>
                    </table>
                </section>

            </c:when>
            <c:otherwise>
                <div style="text-align: center; padding: 50px;">
                    <h2>Product Not Found</h2>
                    <p><c:out value="${requestScope.errorMessage != null ? requestScope.errorMessage : 'The product you are looking for is currently unavailable or does not exist.'}"/></p>
                    <a href="${pageContext.request.contextPath}/products" class="cta-button">Back to Products</a>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />

    <div id="customModal" class="modal-overlay" style="display: none;">
        <div class="modal-content">
            <img src="${pageContext.request.contextPath}/images/monitorhublogo.png" alt="MonitorHub Logo" class="modal-logo">
            <h3 id="modalTitle">Notification</h3>
            <p id="modalMessage">Your message here.</p>
            <button id="modalCloseButton" class="modal-button">OK</button>
        </div>
    </div>

</body>
</html>