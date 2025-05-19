<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Admin Panel</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminAddEditProduct.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

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
         .status-message { /* Base for messages */
            padding: 10px 15px; margin-bottom: 15px; border-radius: 4px;
            border: 1px solid transparent;
        }
        .status-message.error, .form-error-msg {
            background-color: rgba(229, 62, 62, 0.1); color: var(--danger-red, #e53e3e);
            border-color: rgba(229, 62, 62, 0.3);
        }
        .status-message.success, .form-success-msg { /* Added for consistency */
            background-color: rgba(56, 161, 105, 0.1); color: var(--success-green, #38a169);
            border-color: rgba(56, 161, 105, 0.3);
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
            <h1><c:out value="${pageTitle}"/></h1>
            <c:if test="${not empty errorMessage}">
                <div class="status-message error form-error-msg"><c:out value="${errorMessage}"/></div>
            </c:if>
            <div class="add-edit-layout">
                <div class="form-section">
                    <form id="product-form" method="post" action="${pageContext.request.contextPath}/admin/products/save">
                        <input type="hidden" name="formMode" value="${formMode}">
                        <c:if test="${formMode == 'edit'}">
                            <input type="hidden" name="productId" value="${product.id}">
                        </c:if>
                        <div class="form-grid">
                            <div class="form-group full-width">
                                <label for="monitorName">Monitor Name <span class="required">*</span></label>
                                <input type="text" id="monitorName" name="monitorName" value="<c:out value='${product.name}'/>" required>
                            </div>
                             <div class="form-group">
                                <label for="brand">Brand</label>
                                <input type="text" id="brand" name="brand" value="<c:out value='${product.brand}'/>">
                            </div>
                            <div class="form-group">
                                <label for="model">Model</label>
                                <input type="text" id="model" name="model" value="<c:out value='${product.model}'/>">
                            </div>
                             <div class="form-group full-width">
                                <label for="imageUrl">Primary Image URL <span class="required">*</span></label>
                                <input type="url" id="imageUrl" name="imageUrl" value="<c:out value='${product.imageUrl}'/>" placeholder="https://example.com/image.jpg" required>
                             </div>
                             <div class="form-group full-width">
                                <label for="description">Description</label>
                                <textarea id="description" name="description" rows="4"><c:out value='${product.description}'/></textarea>
                             </div>
                             <div class="form-group">
                                <label for="type">Type (e.g., Gaming, Professional)</label>
                                <input type="text" id="type" name="type" value="<c:out value='${product.type}'/>">
                            </div>
                            <div class="form-group">
                                <label for="stockQuantity">Stock Quantity <span class="required">*</span></label>
                                <input type="number" id="stockQuantity" name="stockQuantity" value="${product.stock_quantity}" required min="0" step="1">
                            </div>
                             <div class="form-group">
                                <label for="originalPrice">Original Price <span class="required">*</span></label>
                                <input type="number" id="originalPrice" name="originalPrice" value="${product.original_price}" required min="0" step="0.01" placeholder="e.g., 699.99">
                            </div>
                             <div class="form-group">
                                <label for="discountedPrice">Discounted Price (Optional)</label>
                                <input type="number" id="discountedPrice" name="discountedPrice" value="${product.discounted_price}" min="0" step="0.01" placeholder="e.g., 599.99">
                            </div>
                             <div class="form-group full-width">
                                <label for="deliveryInfo">Delivery Info (Optional)</label>
                                <input type="text" id="deliveryInfo" name="deliveryInfo" value="<c:out value='${product.delivery_info}'/>" placeholder="e.g., Ships in 1-2 days">
                             </div>
                        </div>
                        <div class="form-actions">
                             <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-cancel">Cancel</a>
                            <button type="submit" class="btn btn-publish">
                                <i class="fas fa-cloud-upload-alt"></i> ${formMode == 'edit' ? 'Update' : 'Publish'} Product
                            </button>
                        </div>
                    </form>
                </div>
                <div class="preview-section">
                    <h3>Product Card Preview</h3>
                    <div class="product-card-preview">
                         <div class="preview-image-wrapper">
                            <img id="preview-image"
                                 src="${not empty product.imageUrl ? product.imageUrl : pageContext.request.contextPath.concat('/images/defaultmonitor.png')}"
                                 alt="Product Preview"
                                 onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultmonitor.png';">
                         </div>
                         <div class="preview-content">
                            <h4 id="preview-name">${not empty product.name ? product.name : 'Product Name'}</h4>
                            <p id="preview-description-snippet">
                                <c:choose>
                                    <c:when test="${not empty product.description}">
                                        <c:set var="descPreview" value="${product.description}"/>
                                        <c:out value="${descPreview.length() > 100 ? descPreview.substring(0, 97).concat('...') : descPreview}"/>
                                    </c:when>
                                    <c:otherwise>Short product description text goes here...</c:otherwise>
                                </c:choose>
                            </p>
                             <div class="preview-price-container">
                                 <span id="preview-price" class="price">
                                      <fmt:formatNumber value="${product.price}" type="currency" currencySymbol="$" />
                                 </span>
                                 <span id="preview-original-price" class="original-price ${product.hasDiscount() ? '' : 'hidden'}">
                                     <fmt:formatNumber value="${product.original_price}" type="currency" currencySymbol="$" />
                                 </span>
                            </div>
                            <button type="button" class="btn-preview-details">View Details</button>
                         </div>
                    </div>
                </div>
            </div>
        </main>
    </div>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('product-form');
            const monitorNameInput = document.getElementById('monitorName');
            const imageUrlInput = document.getElementById('imageUrl');
            const descriptionInput = document.getElementById('description');
            const originalPriceInput = document.getElementById('originalPrice');
            const discountedPriceInput = document.getElementById('discountedPrice');

            const previewImage = document.getElementById('preview-image');
            const previewName = document.getElementById('preview-name');
            const previewDescription = document.getElementById('preview-description-snippet');
            const previewPrice = document.getElementById('preview-price');
            const previewOriginalPrice = document.getElementById('preview-original-price');
            const defaultImage = '${pageContext.request.contextPath}/images/defaultmonitor.png';

            function formatCurrency(value) {
                const number = parseFloat(value);
                if (isNaN(number)) return '$0.00';
                return number.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
            }

            function updatePreview() {
                const imageUrl = imageUrlInput.value.trim();
                previewImage.src = imageUrl ? imageUrl : defaultImage;
                previewName.textContent = monitorNameInput.value.trim() || 'Product Name';
                let desc = descriptionInput.value.trim();
                previewDescription.textContent = desc.length > 100 ? desc.substring(0, 97) + '...' : (desc || 'Short product description text goes here...');

                const originalPriceStr = originalPriceInput.value.trim();
                const discountedPriceStr = discountedPriceInput.value.trim();
                let origPrice = parseFloat(originalPriceStr);
                if (isNaN(origPrice) || origPrice < 0) origPrice = 0;
                let discPrice = parseFloat(discountedPriceStr);
                if (isNaN(discPrice) || discPrice <= 0) discPrice = 0;

                if (discPrice > 0 && discPrice < origPrice) {
                    previewPrice.textContent = formatCurrency(discPrice);
                    previewOriginalPrice.textContent = formatCurrency(origPrice);
                    previewOriginalPrice.classList.remove('hidden');
                } else {
                    previewPrice.textContent = formatCurrency(origPrice);
                    previewOriginalPrice.textContent = '';
                    previewOriginalPrice.classList.add('hidden');
                }
            }

            if (form) {
                 [monitorNameInput, imageUrlInput, descriptionInput, originalPriceInput, discountedPriceInput].forEach(input => {
                    if(input) input.addEventListener('input', updatePreview);
                 });
                 form.addEventListener('submit', function(event) {
                     const original = parseFloat(originalPriceInput.value);
                     const discounted = parseFloat(discountedPriceInput.value);
                     if (!isNaN(discounted) && discounted > 0 && !isNaN(original) && discounted >= original) {
                          alert('Discounted price must be less than the original price.');
                          event.preventDefault();
                          discountedPriceInput.focus();
                          return false;
                     }
                     const publishButton = form.querySelector('.btn-publish');
                     if (publishButton) {
                         publishButton.disabled = true;
                         publishButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
                     }
                 });
            }
            updatePreview(); // Initial preview update
        });
    </script>
</body>
</html>