<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- Removed JSTL taglib import as it's not needed for static content --%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Products - MonitorHub</title>
    <%-- Link CSS - Use appropriate pathing for your project --%>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/products.css">
</head>
<body>
    <!-- Include Navigation Bar -->
    <jsp:include page="/WEB-INF/includes/nav.jsp" />
    <%-- Adjust path if nav.jsp is elsewhere --%>

    <main class="main-content">
        <!-- Products Header -->
        <section class="products-header">
            <h1>Our Monitor Collection</h1>
            <p>Discover our wide range of high-quality monitors for gaming, professional work, and everyday use.</p>
        </section>

        <!-- Filters Section -->
        <section class="filters-section">
             <%-- No form needed for static version --%>
                <div class="filter-group">
                    <%-- Static dropdowns - selected state removed --%>
                    <select class="filter-select" name="category" aria-label="Category filter">
                        <option value="">All Categories</option>
                        <option value="gaming">Gaming</option>
                        <option value="professional">Professional</option>
                        <option value="ultrawide">Ultrawide</option>
                        <option value="portable">Portable</option>
                    </select>
                    <select class="filter-select" name="brand" aria-label="Brand filter">
                        <option value="">All Brands</option>
                        <option value="samsung">Samsung</option>
                        <option value="lg">LG</option>
                        <option value="dell">Dell</option>
                        <option value="asus">ASUS</option>
                        <option value="msi">MSI</option>
                        <option value="hp">HP</option>
                    </select>
                    <select class="filter-select" name="sort" aria-label="Price filter">
                        <option value="">Price Range</option>
                        <option value="price_desc">Price: High to Low</option>
                        <option value="price_asc">Price: Low to High</option>
                    </select>
                </div>
        </section>

        <!-- Products Grid -->
        <div class="products-grid">
            <!-- Static Product Cards -->
            <div class="product-card">
                <img src="https://images.samsung.com/is/image/samsung/p6pim/hk_en/ls32bg750ncxxk/gallery/hk-en-odyssey-neo-g7-g75nb-ls32bg750ncxxk-thumb-532845951" alt="Samsung Odyssey G7 32-inch Gaming Monitor">
                <div class="product-content">
                    <h3>Samsung Odyssey G7 32"</h3>
                    <p class="product-description">240Hz, 1ms, QHD, Curved Gaming Monitor with G-Sync & FreeSync Premium Pro.</p>
                    <p class="price">$599.99 <span class="old-price">$699.99</span></p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
            <div class="product-card">
                <img src="https://compujordan.com/image/cache/catalog/products/Monitor%20and%20Display/LG%20Monitors/27UP850-W/lg_27UP850-W_1-1200x1200.jpg" alt="LG UltraFine 27UP850-W">
                <div class="product-content">
                    <h3>LG UltraFine 27UP850-W 27" 4K</h3>
                    <p class="product-description">IPS Display, 95% DCI-P3, USB-C with 96W Power Delivery, HDR400.</p>
                    <p class="price">$449.99</p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
            <div class="product-card">
                <img src="https://my-store.msi.com/cdn/shop/files/ARTYMIS343CQR_5_700x700.png?v=1702461651" alt="MSI MPG ARTYMIS 343CQR">
                <div class="product-content">
                    <h3>MSI MPG ARTYMIS 343CQR 34" Ultrawide</h3>
                    <p class="product-description">165Hz, 1ms, WQHD, 1000R Curved, FreeSync Premium.</p>
                    <p class="price">$479.99</p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
             <div class="product-card">
                <img src="https://images-cdn.ubuy.co.id/666c175bba873516b93a62a2-asus-zenscreen-mb16ace-15-6-full-hd.jpg" alt="ASUS ZenScreen MB16ACE">
                <div class="product-content">
                    <h3>ASUS ZenScreen MB16ACE 15.6" Portable</h3>
                    <p class="product-description">Full HD, IPS, USB-C, Lightweight and Portable Design with Smart Cover.</p>
                    <p class="price">$269.00</p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
            <div class="product-card">
                <img src="https://onlineit.com.np/wp-content/uploads/2024/01/RPmyhBmwuLJEomDRbiHxnZImNovWuvQbdmoxQyv9.jpg" alt="Dell S2722QC">
                <div class="product-content">
                    <h3>Dell S2722QC 27" 4K USB-C</h3>
                    <p class="product-description">4K UHD, IPS, USB-C with 65W Power Delivery, Built-in Speakers.</p>
                    <p class="price">$399.99</p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
            <div class="product-card">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIUMmXlnOjiBDgJzMv4N9M_LO5GsN16gIsVQ&s" alt="HP U27 4K Wireless">
                <div class="product-content">
                    <h3>HP U27 4K Wireless Monitor</h3>
                    <p class="product-description">4K UHD, IPS, Wireless Screen Sharing, Integrated Speakers.</p>
                    <p class="price">$479.00</p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
            <div class="product-card">
                <img src="https://www.neostore.com.np/assets/uploads/g9_31.jpg" alt="Samsung Odyssey G9">
                <div class="product-content">
                    <h3>Samsung Odyssey G9 49" Super Ultrawide</h3>
                    <p class="product-description">240Hz, 1ms, DQHD, 1000R Curved, QLED, G-Sync & FreeSync Premium Pro.</p>
                    <p class="price">$1199.99 <span class="old-price">$1399.99</span></p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
            <div class="product-card">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1kyIplsuUaF_kojubbDd75I74KurKoP0ZSQ&s" alt="LG UltraGear">
                <div class="product-content">
                    <h3>LG UltraGear 27GP850-B 27" QHD</h3>
                    <p class="product-description">165Hz (O/C 180Hz), 1ms, QHD Nano IPS, G-Sync Compatible.</p>
                    <p class="price">$379.99</p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
            <div class="product-card">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfWJJ8ut3UPa4b10ewZrQje7nN5djwu7WlBA&s" alt="ASUS ProArt">
                <div class="product-content">
                    <h3>ASUS ProArt PA278CV 27" WQHD</h3>
                    <p class="product-description">WQHD (2560x1440), IPS, 100% sRGB, Calman Verified, USB-C Docking.</p>
                    <p class="price">$329.00</p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
            <div class="product-card">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVN_tQ0AMfJNwIGjVjrFlKpnlcOCEFkmfL7g&s" alt="Dell Alienware">
                <div class="product-content">
                    <h3>Dell Alienware AW2521HFL 24.5"</h3>
                    <p class="product-description">240Hz, 1ms, FHD, IPS, G-Sync Compatible, FreeSync Premium.</p>
                    <p class="price">$319.99 <span class="old-price">$399.99</span></p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
             <div class="product-card">
                <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9SYkdwYleklHttu041jiKhz5eKP37Cwv53Q&s" alt="HP M27fw">
                <div class="product-content">
                    <h3>HP M27fw 27" FHD Monitor</h3>
                    <p class="product-description">Full HD (1920x1080), IPS, AMD FreeSync, 99% sRGB, Eyesafe Certified Display.</p>
                    <p class="price">$199.99</p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
            <div class="product-card">
                <img src="https://qualitycomputer.com.np/web/image/product.template/49392/image_1024?unique=4b7855e" alt="MSI Optix">
                <div class="product-content">
                    <h3>MSI Optix G273QF 27" WQHD</h3>
                    <p class="product-description">165Hz Refresh Rate, 1ms GTG Response Time, WQHD (2560x1440), Rapid IPS Panel.</p>
                    <p class="price">$299.99</p>
                </div>
                <a href="#" class="cta-button">View Details</a>
            </div>
        </div>

        <!-- Pagination -->
        <div class="pagination">
            <!-- Static Pagination -->
            <button class="page-button active">1</button>
            <button class="page-button">2</button>
            <button class="page-button">3</button>
            <button class="page-button">Next →</button>
        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/includes/footer.jsp" />
     <%-- Adjust path if footer.jsp is elsewhere --%>

</body>
</html>