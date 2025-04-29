<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Admin Panel</title> <%-- Dynamic Title --%>

    <%-- Link CSS files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminAddEditProduct.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <%-- Base styles (copy from adminProducts.jsp or use shared CSS) --%>
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
        /* Add more base styles if needed */
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
            <h1><c:out value="${pageTitle}"/></h1> <%-- Display dynamic title --%>

            <%-- Display potential error messages from servlet --%>
            <c:if test="${not empty errorMessage}">
                <div class="status-message error form-error-msg"><c:out value="${errorMessage}"/></div>
            </c:if>

            <div class="add-edit-layout"> <%-- Flex container for form and preview --%>

                <!-- Form Section -->
                <div class="form-section">
                    <%-- The action should point to where the POST request is handled --%>
                    <form id="product-form" method="post" action="${pageContext.request.contextPath}/admin/products/save"> <%-- Using a hypothetical save URL --%>
                        <%-- Hidden fields to pass mode and ID (if editing) --%>
                        <input type="hidden" name="formMode" value="${formMode}">
                        <c:if test="${formMode == 'edit'}">
                            <input type="hidden" name="productId" value="${product.id}">
                        </c:if>

                        <div class="form-grid">
                            <%-- Monitor Name --%>
                            <div class="form-group full-width">
                                <label for="monitorName">Monitor Name <span class="required">*</span></label>
                                <input type="text" id="monitorName" name="monitorName" value="${product.name}" required>
                            </div>

                             <%-- Brand & Model --%>
                             <div class="form-group">
                                <label for="brand">Brand</label>
                                <input type="text" id="brand" name="brand" value="${product.brand}">
                            </div>
                            <div class="form-group">
                                <label for="model">Model</label>
                                <input type="text" id="model" name="model" value="${product.model}">
                            </div>

                             <%-- Image URL --%>
                             <div class="form-group full-width">
                                <label for="imageUrl">Primary Image URL <span class="required">*</span></label>
                                <input type="url" id="imageUrl" name="imageUrl" value="${product.imageUrl}" placeholder="https://example.com/image.jpg" required>
                             </div>

                             <%-- Description --%>
                             <div class="form-group full-width">
                                <label for="description">Description</label>
                                <textarea id="description" name="description" rows="4">${product.description}</textarea>
                             </div>

                             <%-- Type & Stock --%>
                             <div class="form-group">
                                <label for="type">Type (e.g., IPS, VA, QLED)</label>
                                <input type="text" id="type" name="type" value="${product.type}">
                            </div>
                            <div class="form-group">
                                <label for="stockQuantity">Stock Quantity <span class="required">*</span></label>
                                <input type="number" id="stockQuantity" name="stockQuantity" value="${product.stock_quantity}" required min="0" step="1">
                            </div>

                             <%-- Prices --%>
                             <div class="form-group">
                                <label for="originalPrice">Original Price <span class="required">*</span></label>
                                <input type="number" id="originalPrice" name="originalPrice" value="${product.original_price}" required min="0" step="0.01" placeholder="e.g., 699.99">
                            </div>
                             <div class="form-group">
                                <label for="discountedPrice">Discounted Price (Optional)</label>
                                <input type="number" id="discountedPrice" name="discountedPrice" value="${product.discounted_price}" min="0" step="0.01" placeholder="e.g., 599.99">
                            </div>

                             <%-- Delivery Info --%>
                             <div class="form-group full-width">
                                <label for="deliveryInfo">Delivery Info (Optional)</label>
                                <input type="text" id="deliveryInfo" name="deliveryInfo" value="${product.delivery_info}" placeholder="e.g., Ships in 1-2 days">
                             </div>

                        </div> <%-- End form-grid --%>

                        <%-- Form Actions --%>
                        <div class="form-actions">
                             <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-cancel">Cancel</a>
                            <button type="submit" class="btn btn-publish">
                                <i class="fas fa-cloud-upload-alt"></i> ${formMode == 'edit' ? 'Update' : 'Publish'} Product
                            </button>
                        </div>
                    </form>
                </div> <%-- End form-section --%>

                <!-- Preview Section -->
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
                            <p id="preview-description-snippet">${not empty product.description ? product.description : 'Short product description text goes here...'}</p>
                             <div class="preview-price-container">
                                 <span id="preview-price" class="price">
                                      <fmt:formatNumber value="${not empty product.discounted_price ? product.discounted_price : (not empty product.original_price ? product.original_price : 0)}" type="currency" currencySymbol="$" />
                                 </span>
                                 <span id="preview-original-price" class="original-price ${empty product.discounted_price ? 'hidden' : ''}">
                                     <fmt:formatNumber value="${not empty product.original_price ? product.original_price : 0}" type="currency" currencySymbol="$" />
                                 </span>
                            </div>
                            <button type="button" class="btn-preview-details">View Details</button>
                         </div>
                    </div>
                </div> <%-- End preview-section --%>

            </div> <%-- End add-edit-layout --%>

        </main> <%-- End admin-main-content --%>

    </div> <%-- End admin-body-container --%>

    <%-- JavaScript for Live Preview --%>
    <script>
        // Wait for the DOM to be fully loaded
        document.addEventListener('DOMContentLoaded', function() {

            // --- Get Form Elements ---
            const form = document.getElementById('product-form');
            const monitorNameInput = document.getElementById('monitorName');
            const imageUrlInput = document.getElementById('imageUrl');
            const descriptionInput = document.getElementById('description');
            const originalPriceInput = document.getElementById('originalPrice');
            const discountedPriceInput = document.getElementById('discountedPrice');
            // Add other inputs if needed for preview

            // --- Get Preview Elements ---
            const previewImage = document.getElementById('preview-image');
            const previewName = document.getElementById('preview-name');
            const previewDescription = document.getElementById('preview-description-snippet');
            const previewPrice = document.getElementById('preview-price');
            const previewOriginalPrice = document.getElementById('preview-original-price');
            const defaultImage = '${pageContext.request.contextPath}/images/defaultmonitor.png';

            // --- Helper Function to Format Currency ---
            function formatCurrency(value) {
                const number = parseFloat(value);
                if (isNaN(number)) {
                    return '$0.00'; // Default if input is not a number
                }
                return number.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
            }

            // --- Helper Function to Update Preview ---
            function updatePreview() {
                // Update Image
                const imageUrl = imageUrlInput.value.trim();
                previewImage.src = imageUrl ? imageUrl : defaultImage;
                // The onerror handler in the img tag will handle broken links

                // Update Name
                previewName.textContent = monitorNameInput.value.trim() || 'Product Name';

                // Update Description Snippet
                let desc = descriptionInput.value.trim();
                if (desc.length > 100) { // Limit snippet length
                    desc = desc.substring(0, 100) + '...';
                }
                previewDescription.textContent = desc || 'Short product description text goes here...';

                 // Update Prices
                 const originalPriceValue = originalPriceInput.value;
                 const discountedPriceValue = discountedPriceInput.value;

                 const displayPrice = discountedPriceValue && parseFloat(discountedPriceValue) > 0
                                    ? discountedPriceValue
                                    : originalPriceValue;

                 previewPrice.textContent = formatCurrency(displayPrice);

                 if (discountedPriceValue && parseFloat(discountedPriceValue) > 0 && parseFloat(discountedPriceValue) < parseFloat(originalPriceValue)) {
                     previewOriginalPrice.textContent = formatCurrency(originalPriceValue);
                     previewOriginalPrice.classList.remove('hidden');
                 } else {
                     previewOriginalPrice.textContent = ''; // Clear if no discount
                     previewOriginalPrice.classList.add('hidden');
                 }
            }

            // --- Add Event Listeners ---
            if (form) {
                 // Use 'input' event for immediate updates as user types
                 monitorNameInput.addEventListener('input', updatePreview);
                 imageUrlInput.addEventListener('input', updatePreview);
                 descriptionInput.addEventListener('input', updatePreview);
                 originalPriceInput.addEventListener('input', updatePreview);
                 discountedPriceInput.addEventListener('input', updatePreview);
                 // Add listeners for other relevant fields if needed

                 // Add listener for form submission (optional, e.g., for final validation)
                 form.addEventListener('submit', function(event) {
                     // Perform final client-side validation if needed
                     // Example: Check if discounted price > original price
                     const original = parseFloat(originalPriceInput.value);
                     const discounted = parseFloat(discountedPriceInput.value);
                     if (!isNaN(original) && !isNaN(discounted) && discounted > 0 && discounted >= original) {
                          alert('Discounted price must be less than the original price.');
                          event.preventDefault(); // Stop submission
                          discountedPriceInput.focus();
                          return false;
                     }
                     // Disable button to prevent double submission (server should handle this too)
                     const publishButton = form.querySelector('.btn-publish');
                     if (publishButton) {
                         publishButton.disabled = true;
                         publishButton.textContent = 'Processing...';
                     }
                 });
            }

            // --- Initial Update on Page Load ---
            // (Useful especially for edit mode to show initial preview)
            updatePreview();

        });
    </script>

</body>
</html>