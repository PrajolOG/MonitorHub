<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Removed JSTL taglib import --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details - MonitorHub</title> <%-- Static Title --%>
    <%-- Link necessary CSS files - Adjust paths as needed --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/product_desc.css">
</head>
<body>

    <!-- Include Navigation Bar -->
    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">

        <%-- Static Product Detail Container --%>
        <div class="product-detail-container">
            <!-- Left Column: Image -->
            <div class="product-image-column">
                <!-- Static Image -->
                <img src="https://images.samsung.com/is/image/samsung/p6pim/hk_en/ls32bg750ncxxk/gallery/hk-en-odyssey-neo-g7-g75nb-ls32bg750ncxxk-thumb-532845951"
                     alt="Samsung Odyssey G7 32 Inch Monitor"> <%-- Static Alt Text --%>
            </div>

            <!-- Right Column: Details -->
            <div class="product-details-column">
                <!-- Static Title -->
                <h1>Samsung Odyssey G7 32"</h1>

                <!-- Static Rating Placeholder -->
                <div class="product-rating">
                    <span>⭐⭐⭐⭐⭐</span>
                    <span class="review-count">(120 Reviews)</span>
                </div>

                <div class="price-section">
                    <!-- Static Prices -->
                    <span class="current-price">$599.99</span>
                    <span class="old-price">$699.99</span>
                </div>

                <!-- Static Overview -->
                <p class="product-overview">
                   Experience immersive gaming with this stunning QHD curved monitor featuring a blazing fast refresh rate and response time. Perfect for competitive gamers and enthusiasts seeking top-tier performance.
                </p>

                <!-- Static Key Features -->
                <ul class="key-features">
                    <li>240Hz Refresh Rate</li>
                    <li>QHD (2560x1440) Resolution</li>
                    <li>1ms Response Time (GtG)</li>
                    <li>1000R Curved VA Panel</li>
                    <li>G-Sync & FreeSync Premium Pro</li>
                </ul>

                <div class="quantity-selector">
                    <label for="quantity">Quantity:</label>
                    <input type="number" id="quantity" name="quantity" value="1" min="1" max="10">
                </div>

                <!-- Static Stock Status -->
                <p class="stock-status in-stock">In Stock</p>
                <%-- <p class="stock-status out-of-stock">Out of Stock</p> --%>

                <!-- Static Add to Cart Button -->
                <button type="button" class="add-to-cart-btn">Add to Cart</button>

            </div>
        </div>

        <!-- Full Description / Specifications Section -->
        <section class="product-full-details">
            <h2>Product Description</h2>
            <!-- Static Description -->
            <p>Dive deeper into the world of high-fidelity gaming. This monitor boasts Quantum Dot technology for vibrant colors and deep contrasts. The 1000R curve matches the contour of the human eye for maximum immersion and reduced eye strain during long sessions. Adaptive-Sync technology ensures smooth, tear-free gameplay, compatible with both NVIDIA G-Sync and AMD FreeSync Premium Pro.</p>
            <p>With its ultra-fast refresh rate and response time, motion blur is virtually eliminated, giving you the edge in fast-paced games. The sleek design and customizable CoreSync lighting add a stylish touch to any gaming setup.</p>

            <h2>Specifications</h2>
            <!-- Static Specs Table -->
            <table class="spec-table">
                <tbody>
                    <tr><th>Screen Size</th><td>32 Inches</td></tr>
                    <tr><th>Resolution</th><td>2560 x 1440 (QHD)</td></tr>
                    <tr><th>Refresh Rate</th><td>240 Hz</td></tr>
                    <tr><th>Response Time</th><td>1ms (GtG)</td></tr>
                    <tr><th>Panel Type</th><td>VA</td></tr>
                    <tr><th>Curvature</th><td>1000R</td></tr>
                    <tr><th>Aspect Ratio</th><td>16:9</td></tr>
                    <tr><th>Brightness</th><td>350 cd/m² (Typical)</td></tr>
                    <tr><th>Contrast Ratio</th><td>2500:1 (Typical)</td></tr>
                    <tr><th>Color Gamut</th><td>95% DCI-P3</td></tr>
                    <tr><th>HDR</th><td>VESA DisplayHDR 600</td></tr>
                    <tr><th>Ports</th><td>1x DisplayPort 1.4, 2x HDMI 2.0, 2x USB 3.0, Headphone Jack</td></tr>
                    <tr><th>VESA Mountable</th><td>Yes (100x100mm)</td></tr>
                </tbody>
            </table>
        </section>

    </main>

    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>