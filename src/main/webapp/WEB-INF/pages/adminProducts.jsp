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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminNav.css">
    <%-- Link to your existing adminProducts.css --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/adminProducts.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* --- START: Base Styles (Copied from your original file) --- */
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
        :root {
            --primary-purple: #9d4edd; --secondary-purple: #c77dff;
            --gradient: linear-gradient(90deg, var(--primary-purple) 0%, var(--secondary-purple) 100%);
            --bg-light-start: #f5f7fa; --bg-light-end: #c3cfe2; /* Light gradient background */
            --bg-body-gradient: linear-gradient(135deg, var(--bg-light-start) 0%, var(--bg-light-end) 100%);
            --sidebar-bg: rgba(255, 255, 255, 0.5); --sidebar-border: rgba(255, 255, 255, 0.25);
            --card-bg: var(--white, #ffffff); /* Changed to solid white for the card */
            --text-dark: #2d3748; --text-medium: #4a5568;
            --text-light: #718096; --white: #ffffff; --hover-bg: #f8f9fa; /* Light grey hover */
            --border-light: #e2e8f0; --border-medium: #cbd5e0;
            --danger-red: #e53e3e; --danger-red-dark: #c53030; /* Darker red for hover */
            --danger-red-light: #fed7d7;
            --success-green: #38a169; --success-green-light: #c6f6d5;
            --info-blue: #3182ce; --info-blue-light: #bee3f8;
            --warning-orange: #dd6b20; --warning-orange-light: #feebc8;
            --button-secondary-bg: #f1f5f9; /* Light grey for cancel */
            --button-secondary-border: #e2e8f0;
            --button-secondary-text: #4a5568;
            --button-secondary-hover-bg: #e2e8f0;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-light-start); background-image: var(--bg-body-gradient);
            color: var(--text-dark); margin: 0; display: flex; min-height: 100vh;
            background-attachment: fixed;
        }
        .admin-body-container { display: flex; width: 100%; }
        .admin-main-content { flex-grow: 1; padding: 30px; overflow-y: auto; }
        .admin-main-content > h1 { font-size: 28px; margin-bottom: 20px; color: var(--text-dark); font-weight: 600; padding-bottom: 0; border-bottom: none;}

        .status-message { padding: 10px 15px; margin-bottom: 15px; border-radius: 4px; border: 1px solid transparent; }
        .status-message.error { background-color: var(--danger-red-light); color: #a11c1c; border-color: var(--danger-red); }
        .status-message.success { background-color: var(--success-green-light); color: #2f6f4a; border-color: var(--success-green); }
         .status-message.info { background-color: var(--info-blue-light); color: #2c5282; border-color: var(--info-blue); }
         .status-message i { margin-right: 8px; }
         /* --- END: Base Styles --- */

         /* --- START: Confirmation Modal Styles (Internal) --- */
         .product-delete-modal-overlay { /* Unique class name */
             position: fixed; top: 0; left: 0; width: 100%; height: 100%;
             background-color: rgba(0, 0, 0, 0.5); /* Semi-transparent black */
             display: none; /* Hidden by default */
             justify-content: center; align-items: center;
             z-index: 1050;
             backdrop-filter: blur(3px);
             -webkit-backdrop-filter: blur(3px);
             opacity: 0; visibility: hidden;
             transition: opacity 0.3s ease, visibility 0s linear 0.3s;
         }
         .product-delete-modal-overlay.active {
             display: flex; opacity: 1; visibility: visible;
             transition: opacity 0.3s ease;
         }
         .product-delete-modal-content { /* Unique class name */
             background-color: var(--white); border-radius: 8px;
             padding: 25px 30px; width: 90%; max-width: 450px;
             box-shadow: 0 5px 20px rgba(0, 0, 0, 0.2);
             text-align: center;
             transform: scale(0.95);
             transition: transform 0.3s ease;
         }
         .product-delete-modal-overlay.active .product-delete-modal-content {
             transform: scale(1);
         }
         .product-delete-modal-content h2 {
             font-size: 20px; font-weight: 600; color: var(--text-dark);
             margin-top: 0; margin-bottom: 15px;
         }
         .product-delete-modal-content p {
             font-size: 15px; color: var(--text-medium); line-height: 1.6;
             margin-bottom: 25px;
         }
         .product-delete-modal-content p strong { /* Style the name */
             color: var(--danger-red); font-weight: 600;
         }
         .product-delete-modal-buttons { /* Unique class name */
             display: flex; justify-content: center; gap: 15px;
         }
         .product-delete-modal-buttons .btn {
             padding: 9px 25px; font-size: 14px; font-weight: 500;
             border-radius: 6px; border: 1px solid transparent;
             cursor: pointer; transition: background-color 0.2s ease, border-color 0.2s ease, transform 0.1s ease;
             min-width: 90px;
         }
          .product-delete-modal-buttons .btn:active {
             transform: scale(0.96);
         }
         .product-delete-modal-buttons .btn-secondary {
             background-color: var(--button-secondary-bg); color: var(--button-secondary-text);
             border-color: var(--button-secondary-border);
         }
         .product-delete-modal-buttons .btn-secondary:hover {
             background-color: var(--button-secondary-hover-bg);
         }
         .product-delete-modal-buttons .btn-danger {
             background-color: var(--danger-red); color: var(--white);
             border-color: var(--danger-red);
         }
         .product-delete-modal-buttons .btn-danger:hover {
             background-color: var(--danger-red-dark); border-color: var(--danger-red-dark);
         }
         /* --- END: Confirmation Modal Styles --- */

         @media (max-width: 768px) {
             body, .admin-body-container { flex-direction: column; }
             .admin-main-content { height: auto; padding: 20px; overflow-y: visible; }
             .admin-main-content > h1 { font-size: 24px; }
             /* Add other responsive styles from adminProducts.css if needed */
         }
    </style>
</head>
<body>
    <div class="admin-body-container">
        <jsp:include page="/WEB-INF/includes/adminNav.jsp" />
        <main class="admin-main-content">
            <h1>Manage Products</h1>

            <%-- Status Messages --%>
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="status-message success"><i class="fas fa-check-circle"></i> <c:out value="${sessionScope.successMessage}"/></div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="status-message error"><i class="fas fa-exclamation-triangle"></i> <c:out value="${sessionScope.errorMessage}"/></div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>
            <c:if test="${not empty requestScope.dbError}">
                <div class="status-message error"><i class="fas fa-database"></i> <c:out value="${requestScope.dbError}"/></div>
            </c:if>

            <%-- Add Product Button --%>
            <div class="actions-bar">
                <a href="${pageContext.request.contextPath}/admin/products/add" class="btn btn-add">
                    <i class="fas fa-plus"></i> Add New Product
                </a>
            </div>

            <%-- Product Table Container --%>
            <div class="content-box table-container">
                 <h2>All Monitors</h2>
                 <div class="table-wrapper">
                    <table class="data-table product-table">
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
                                <c:when test="${not empty products}">
                                    <c:forEach var="product" items="${products}">
                                        <tr>
                                            <td data-label="ID:"><c:out value="${product.id}"/></td>
                                            <td data-label="Image:" class="product-image-cell">
                                                <img class="table-product-image"
                                                     src="${not empty product.imageUrl ? product.imageUrl : pageContext.request.contextPath.concat('/images/defaultmonitor.png')}"
                                                     alt="<c:out value='${product.name}'/>"
                                                     onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultmonitor.png';">
                                            </td>
                                            <td data-label="Name:" class="product-name-cell"><c:out value="${product.name}"/></td>
                                            <td data-label="Brand:"><c:out value="${product.brand}"/></td>
                                            <td data-label="Model:"><c:out value="${product.model}"/></td>
                                            <td data-label="Price:">
                                                <fmt:setLocale value="en_US"/>
                                                <c:set var="displayPrice" value="${product.original_price}" />
                                                <c:if test="${not empty product.discounted_price and product.discounted_price > 0 and product.discounted_price < product.original_price}">
                                                    <c:set var="displayPrice" value="${product.discounted_price}" />
                                                </c:if>
                                                <fmt:formatNumber value="${displayPrice}" type="currency" currencySymbol="$" />
                                                <%-- Check if product has discount --%>
                                                <c:if test="${not empty product.discounted_price and product.discounted_price > 0 and product.discounted_price < product.original_price}">
                                                     <span class="original-price-strike">
                                                        <fmt:formatNumber value="${product.original_price}" type="currency" currencySymbol="$" />
                                                     </span>
                                                 </c:if>
                                            </td>
                                            <td data-label="Stock:">
                                                <c:choose>
                                                    <c:when test="${product.stock_quantity > 10}">
                                                        <span class="status-badge stock-high"><c:out value="${product.stock_quantity}"/> In Stock</span>
                                                    </c:when>
                                                    <c:when test="${product.stock_quantity > 0}">
                                                        <span class="status-badge stock-low"><c:out value="${product.stock_quantity}"/> Low Stock</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge stock-out">Out of Stock</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="actions-cell">
                                                <a href="${pageContext.request.contextPath}/admin/products/edit?id=${product.id}" class="btn-action btn-edit" title="Edit Product ${product.id}"><i class="fas fa-pencil-alt"></i></a>

                                                <button type="button" class="btn-action btn-delete" title="Delete Product ${product.id}"
                                                        onclick="showProductDeleteModal(this.dataset.productId, this.dataset.productName)"
                                                        data-product-id="${product.id}"
                                                        data-product-name="<c:out value='${product.name}' escapeXml='true'/>"> <%-- Added escapeXml --%>
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="8" class="no-data-message">No products found in the database. Add a new product to get started.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>
            </div>
        </main>
    </div> <%-- End admin-body-container --%>

    <%-- ****** DELETE MODAL HTML (Use unique IDs) ****** --%>
    <div class="product-delete-modal-overlay" id="productDeleteModalOverlay"> <%-- Unique ID --%>
        <div class="product-delete-modal-content"> <%-- Unique ID --%>
            <h2>Confirm Deletion</h2>
            <p>Are you sure you want to delete product <strong id="productDeleteModalName">Product Name</strong>? This action cannot be undone.</p> <%-- Unique ID --%>
            <div class="product-delete-modal-buttons"> <%-- Unique ID --%>
                <button type="button" class="btn btn-secondary" id="productModalCancelBtn">Cancel</button> <%-- Unique ID --%>
                <button type="button" class="btn btn-danger" id="productModalConfirmBtn">Yes, Delete</button> <%-- Unique ID --%>
            </div>
        </div>
    </div>

    <form id="productDeleteForm" method="post" action="${pageContext.request.contextPath}/admin/products/delete" style="display: none;">
        <input type="hidden" name="productId" id="productDeleteIdInput">
    </form>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Use specific IDs for product modal elements
            const modalOverlay = document.getElementById('productDeleteModalOverlay');
            const modalProductNameEl = document.getElementById('productDeleteModalName');
            const cancelBtn = document.getElementById('productModalCancelBtn');
            const confirmBtn = document.getElementById('productModalConfirmBtn');
            const deleteForm = document.getElementById('productDeleteForm');
            const productIdInput = document.getElementById('productDeleteIdInput');

            // Check if all modal elements were found
            if (!modalOverlay || !modalProductNameEl || !cancelBtn || !confirmBtn || !deleteForm || !productIdInput) {
                console.error("One or more product delete modal elements not found!");
                // Disable delete buttons or provide fallback if elements are missing
                document.querySelectorAll('.btn-delete').forEach(btn => btn.disabled = true);
                return;
            }

            let productIdToDelete = null; // Store the ID of the product to be deleted

            // Make the show function globally accessible for onclick
            window.showProductDeleteModal = function(id, name) {
                 if (!id || !name) {
                     console.error("Missing product ID or name for delete modal.");
                     return;
                 }
                 console.log(`Attempting to show modal for Product ID: ${id}`);
                productIdToDelete = id; // Store the ID
                productIdInput.value = id; // Set value for the hidden form
                modalProductNameEl.textContent = name; // Display the name in the modal
                modalOverlay.style.display = 'flex'; // Show overlay
                void modalOverlay.offsetWidth;
                modalOverlay.classList.add('active');
            }

            // Function to hide the modal
            function hideProductModal() {
                productIdToDelete = null; // Clear the stored ID
                modalOverlay.classList.remove('active');
                // Wait for the transition to finish before hiding completely
                setTimeout(() => {
                     if (modalOverlay && !modalOverlay.classList.contains('active')) {
                         modalOverlay.style.display = 'none';
                     }
                }, 300); // Should match CSS transition duration
            }

            // Add event listeners to modal buttons and overlay
            cancelBtn.addEventListener('click', hideProductModal);

            confirmBtn.addEventListener('click', function() {
                if (productIdInput.value && productIdInput.value === String(productIdToDelete)) {
                    console.log(`Submitting delete form for Product ID: ${productIdInput.value}`);
                    // Optional: Disable button during submission
                    confirmBtn.disabled = true;
                    confirmBtn.textContent = 'Deleting...';
                    deleteForm.submit(); // Submit the hidden form
                } else {
                    console.error("Product ID mismatch or form input not set. Aborting delete.");
                    alert("An error occurred. Could not confirm deletion."); // User feedback
                    hideProductModal(); // Close the modal
                }
            });

            modalOverlay.addEventListener('click', function(event) {
                // Close only if the click is directly on the overlay background
                if (event.target === modalOverlay) {
                    hideProductModal();
                }
            });
        });
    </script>

</body>
</html>