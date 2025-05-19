<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monitor Categories - Monitor Hub</title>



    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/category.css">

</head>
<body>

    <!-- Include Navigation Bar -->
    <jsp:include page="/WEB-INF/includes/nav.jsp" />
    <%-- Adjust path "/WEB-INF/includes/nav.jsp" as needed --%>

    <main class="main-content">

        <!-- Category Page Header -->
        <div class="page-header category-page-intro">
            <h1>Explore Monitor Categories</h1>
            <p>Find the right type of monitor for your needs. We've grouped our selection by primary use case, from immersive gaming to professional creative work and beyond.</p>
            <!-- Optional: Quick jump links (uncomment and style if desired) -->
            <!-- <div class="quick-category-links">
                <a href="#gaming-monitors">Gaming</a>
                <a href="#ultrawide-monitors">Ultrawide</a>
                <a href="#professional-monitors">Professional</a>
                <a href="#portable-monitors">Portable</a>
            </div> -->
        </div>

        <!-- Gaming Monitors Section -->
        <%-- In a real application, this section and the cards within would likely be generated dynamically --%>
        <section class="category-section" id="gaming-monitors" aria-labelledby="gaming-heading">
            <div class="category-header">
                <h2 id="gaming-heading">Gaming Monitors</h2>
                <a href="<%= request.getContextPath() %>/products" class="view-all-link">View All Monitors →</a> <%-- Replace # with actual link (e.g., using <c:url>) --%>
            </div>
            <div class="grid-container">
                <%-- Static Example Card 1 (Replace with dynamic data loop) --%>
                <div class="product-card">
                    <img src="https://images.samsung.com/is/image/samsung/p6pim/hk_en/ls32bg750ncxxk/gallery/hk-en-odyssey-neo-g7-g75nb-ls32bg750ncxxk-thumb-532845951" alt="Samsung Odyssey G7">
                    <div class="product-content">
                        <h3>Samsung Odyssey G7 32"</h3>
                        <p class="product-description">240Hz, 1ms, QHD, Curved Gaming Monitor with G-Sync & FreeSync Premium Pro.</p>
                        <p class="price">$599.99 <span class="old-price">$699.99</span></p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                <%-- Static Example Card 2 --%>
                <div class="product-card">
                     <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ1kyIplsuUaF_kojubbDd75I74KurKoP0ZSQ&s" alt="LG UltraGear 27GP850-B 27-inch Gaming Monitor">
                    <div class="product-content">
                        <h3>LG UltraGear 27GP850-B 27"</h3>
                        <p class="product-description">165Hz (O/C 180Hz), 1ms, QHD Nano IPS, G-Sync Compatible.</p>
                        <p class="price">$379.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                 <%-- Static Example Card 3 --%>
                 <div class="product-card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVN_tQ0AMfJNwIGjVjrFlKpnlcOCEFkmfL7g&s" alt="Dell Alienware AW2521HFL 24.5-inch Gaming Monitor">
                    <div class="product-content">
                        <h3>Dell Alienware AW2521HFL 24.5"</h3>
                        <p class="product-description">240Hz, 1ms, FHD, IPS, FreeSync Premium & G-Sync Compatible.</p>
                        <p class="price">$319.99 <span class="old-price">$399.99</span></p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                 <%-- Static Example Card 4 --%>
                 <div class="product-card">
                    <img src="https://qualitycomputer.com.np/web/image/product.template/49392/image_1024?unique=4b7855e" alt="MSI Optix G273QF 27-inch Gaming Monitor">
                    <div class="product-content">
                        <h3>MSI Optix G273QF 27" WQHD</h3>
                        <p class="product-description">165Hz Refresh Rate, 1ms GTG, WQHD (2560x1440), Rapid IPS.</p>
                        <p class="price">$299.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                <%-- Static Example Card 5 --%>
                <div class="product-card">
                    <img src="https://m.media-amazon.com/images/I/81n5ADeWLAL._AC_UF1000,1000_QL80_.jpg" alt="LG 32GQ950">
                    <div class="product-content">
                        <h3>LG UltraGear 32GQ950 32" 4K Gaming</h3>
                        <p class="product-description">4K UHD, 160Hz, 1ms, Nano IPS, HDMI 2.1, G-Sync Compatible.</p>
                        <p class="price">$899.99 <span class="old-price">$999.99</span></p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                <%-- Static Example Card 6 --%>
                <div class="product-card">
                    <img src="data:image/jpeg;base64,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" alt="ViewSonic VX2718">
                    <div class="product-content">
                        <h3>ViewSonic VX2718-PC-MHD 27" Curved</h3>
                        <p class="product-description">165Hz, 1ms, Full HD, 1500R Curved, AMD FreeSync Premium.</p>
                        <p class="price">$249.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
            </div>
        </section>

        <!-- Ultrawide Monitors Section -->
        <section class="category-section" id="ultrawide-monitors" aria-labelledby="ultrawide-heading">
            <div class="category-header">
                <h2 id="ultrawide-heading">Ultrawide Monitors</h2>
                <a href="<%= request.getContextPath() %>/products" class="view-all-link">View All Monitors →</a> <%-- Replace # with actual link (e.g., using <c:url>) --%>
            </div>
            <div class="grid-container">
                <%-- Static Example Card --%>
                 <div class="product-card">
                    <img src="https://my-store.msi.com/cdn/shop/files/ARTYMIS343CQR_5_700x700.png?v=1702461651" alt="MSI MPG ARTYMIS 343CQR 34-inch Ultrawide Gaming Monitor">
                    <div class="product-content">
                        <h3>MSI MPG ARTYMIS 343CQR 34"</h3>
                        <p class="product-description">165Hz, 1ms, WQHD, 1000R Curved, FreeSync Premium.</p>
                        <p class="price">$479.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                <%-- Static Example Card --%>
                 <div class="product-card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRnqF9bHC7PE_Pa4K5lVnHrNvjSK_LYyBM2A&s" alt="Samsung Odyssey G9 49-inch Super Ultrawide Monitor">
                    <div class="product-content">
                        <h3>Samsung Odyssey G9 49" Super Ultrawide</h3>
                        <p class="product-description">240Hz, 1ms, DQHD (5120x1440), 1000R Curved, QLED, G-Sync & FreeSync.</p>
                        <p class="price">$1199.99 <span class="old-price">$1399.99</span></p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                 <%-- Static Example Card --%>
                 <div class="product-card">
                    <img src="https://compujordan.com/image/cache/catalog/products/Monitor%20and%20Display/LG%20Monitors/27UP850-W/lg_27UP850-W_1-1200x1200.jpg" alt="LG UltraFine 27UP850-W 27-inch 4K Monitor">
                    <div class="product-content">
                        <h3>LG UltraFine 27UP850-W 27" 4K</h3>
                        <p class="product-description">IPS Display, 95% DCI-P3, USB-C with 96W Power Delivery, HDR400.</p>
                        <p class="price">$449.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                <%-- Static Example Card --%>
                <div class="product-card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR2bYPjRjVQDgcghkZxXFc9-gkzkT_S57E5Jg&s" alt="LG 49WL95C">
                    <div class="product-content">
                        <h3>LG 49WL95C-W 49" Ultrawide</h3>
                        <p class="product-description">5120x1440, 32:9, USB-C, HDR10, Dual Controller.</p>
                        <p class="price">$1,299.99 <span class="old-price">$1,499.99</span></p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
            </div>
        </section>

        <!-- Professional Monitors Section -->
        <section class="category-section" id="professional-monitors" aria-labelledby="professional-heading">
            <div class="category-header">
                <h2 id="professional-heading">Professional Monitors</h2>
                <a href="<%= request.getContextPath() %>/products" class="view-all-link">View All Monitors →</a> <%-- Replace # with actual link (e.g., using <c:url>) --%>
            </div>
            <div class="grid-container">
                <%-- Static Example Card --%>
                <div class="product-card">
                    <img src="https://onlineit.com.np/wp-content/uploads/2024/01/RPmyhBmwuLJEomDRbiHxnZImNovWuvQbdmoxQyv9.jpg" alt="Dell S2722QC 27-inch 4K USB-C Monitor">
                    <div class="product-content">
                        <h3>Dell S2722QC 27" 4K USB-C</h3>
                        <p class="product-description">4K UHD, IPS, USB-C with 65W Power Delivery, Built-in Speakers.</p>
                        <p class="price">$399.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                <%-- Static Example Card --%>
                <div class="product-card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIUMmXlnOjiBDgJzMv4N9M_LO5GsN16gIsVQ&s" alt="HP U27 4K Wireless Monitor">
                    <div class="product-content">
                        <h3>HP U27 4K Wireless Monitor</h3>
                        <p class="product-description">4K UHD, IPS, Wireless Screen Sharing, Integrated Speakers.</p>
                        <p class="price">$479.00</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                <%-- Static Example Card --%>
                <div class="product-card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfWJJ8ut3UPa4b10ewZrQje7nN5djwu7WlBA&s" alt="ASUS ProArt PA278CV 27-inch Professional Monitor">
                    <div class="product-content">
                        <h3>ASUS ProArt PA278CV 27" WQHD</h3>
                        <p class="product-description">WQHD (2560x1440), IPS, 100% sRGB, Calman Verified, USB-C Docking.</p>
                        <p class="price">$329.00</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                 <%-- Static Example Card --%>
                 <div class="product-card">
                    <img src="https://in-media.apjonlinecdn.com/catalog/product/cache/b3b166914d87ce343d4dc5ec5117b502/2/H/2H1B1AA-1_T1705905873.png" alt="HP M27fw 27-inch FHD Monitor">
                    <div class="product-content">
                        <h3>HP M27fw 27" FHD Monitor</h3>
                        <p class="product-description">Full HD (1920x1080), IPS, AMD FreeSync, 99% sRGB, Eyesafe Certified.</p>
                        <p class="price">$199.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                <%-- Static Example Card --%>
                <div class="product-card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcToPX0LDs1mkeBssss-eTk1Oe7En5lPGTTAdg&s" alt="BenQ SW271C">
                    <div class="product-content">
                        <h3>BenQ SW271C 27" 4K Professional</h3>
                        <p class="product-description">4K UHD, 100% AdobeRGB, HDR10, Hardware Calibration.</p>
                        <p class="price">$1,499.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                <%-- Static Example Card --%>
                <div class="product-card">
                    <img src="https://s3-ap-southeast-2.amazonaws.com/transforms.imagescience.com.au/_202306_imager-transforms/s3images/Products/Eizo/CG279X/43431/EIZO-CG279X-27-Inch-ColorEdge-Monitor-Side-View_d7b77cf7cb7a1fcf2c4222aa81ae8cda.jpg" alt="EIZO ColorEdge">
                    <div class="product-content">
                        <h3>EIZO ColorEdge CG2740 27" 4K</h3>
                        <p class="product-description">4K UHD, Built-in Calibration Sensor, 99% Adobe RGB.</p>
                        <p class="price">$2,099.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
            </div>
        </section>

        <!-- Portable Monitors Section -->
        <section class="category-section" id="portable-monitors" aria-labelledby="portable-heading">
            <div class="category-header">
                <h2 id="portable-heading">Portable Monitors</h2>
                <a href="<%= request.getContextPath() %>/products" class="view-all-link">View All Monitors →</a> <%-- Replace # with actual link (e.g., using <c:url>) --%>
            </div>
            <div class="grid-container">
                <%-- Static Example Card --%>
                <div class="product-card">
                    <img src="https://images-cdn.ubuy.co.id/666c175bba873516b93a62a2-asus-zenscreen-mb16ace-15-6-full-hd.jpg" alt="ASUS ZenScreen">
                    <div class="product-content">
                        <h3>ASUS ZenScreen MB16ACE 15.6"</h3>
                        <p class="product-description">Full HD, IPS, USB-C, Lightweight and Portable Design with Smart Cover.</p>
                        <p class="price">$269.00</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                 <%-- Static Example Card (Duplicate) --%>
                 <div class="product-card">
                    <img src="https://images-cdn.ubuy.co.id/666c175bba873516b93a62a2-asus-zenscreen-mb16ace-15-6-full-hd.jpg" alt="ASUS ZenScreen MB16ACE 15.6-inch Portable Monitor">
                    <div class="product-content">
                        <h3>ASUS ZenScreen MB16ACE 15.6" (Duplicate)</h3>
                        <p class="product-description">Full HD, IPS, USB-C, Lightweight and Portable Design with Smart Cover.</p>
                        <p class="price">$269.00</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                 <%-- Static Example Card --%>
                <div class="product-card">
                    <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQRR55IIW4kGPTzt0wq-4GLdtC7sP_o4IdqjA&s" alt="Lenovo M14t">
                    <div class="product-content">
                        <h3>Lenovo ThinkVision M14t 14" Touch</h3>
                        <p class="product-description">Full HD, Touch Screen, USB-C, Built-in Stand.</p>
                        <p class="price">$299.99</p>
                    </div>
                    <a href="#" class="cta-button">View Details</a> <%-- Replace # --%>
                </div>
                 <!-- Add more portable monitors here if available -->
            </div>
        </section>

    </main>

    <!-- Include Footer -->
    <jsp:include page="/WEB-INF/includes/footer.jsp" />
    <%-- Adjust path "/WEB-INF/includes/footer.jsp" as needed --%>

    <!-- Optional: Script block for page-specific JS if needed -->
    <script>
        // Page-specific JavaScript can go here
    </script>

</body>
</html>