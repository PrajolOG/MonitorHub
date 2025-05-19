<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Monitor Hub - Find Your Perfect Display</title>

    <%-- Link External CSS Files --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/home.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <%-- Minimal Global Layout Styles + Animations --%>
    <style>
        /* Global Body Layout */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: #eef2f7;
            background-image: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            background-attachment: fixed; /* Keep fixed background for parallax effect */
            color: #343a40;
            line-height: 1.6;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
             /* IMPORTANT padding for fixed navbar! Adjust value as needed. */
            padding-top: 125px; /* Example: Adjust this! */
            margin: 0;
        }
        .main-content { /* Renamed from 'main' tag selector for clarity */
             max-width: 1340px; /* Max width for home content */
             width: 100%;
             margin: 0 auto; /* Center */
             padding: 20px; /* Padding around content */
             flex-grow: 1; /* Push footer down */
             animation: fadeIn 0.6s ease-in-out; /* Fade in for main content */
        }
        /* Responsive adjustment for body padding */
        @media (max-width: 768px) {
             body { padding-top: 0; } /* Remove padding when nav is static */
             .main-content { animation: none; } /* Optional */
        }

        /* --- Page Load Animation --- */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* --- Image Slider Styles --- */
        .image-slider-container {
            width: 100%; /* Adjust width as needed */
            margin: 30px auto; /* Center the slider */
            overflow: hidden; /* Hide parts of images outside the container */
            border-radius: 8px;
            background-color: #ffffff;
            padding: 15px 0; /* Padding top/bottom */
        }

        .image-slider-track {
            display: flex;
            /* Width will be set by JS based on image count */
            /* Animation properties */
            animation: scrollLeft 12s linear infinite; /* 6 images * 2s/image = 12s duration */
        }


        .image-slider-track img {
            height: 90px; /* Adjust height as needed */
            width: auto; /* Maintain aspect ratio */
            margin: 0 70px; /* Spacing between images */
            object-fit: contain; /* Ensure logo fits well */
            flex-shrink: 0; /* Prevent images from shrinking */
        }

        /* Keyframes for the continuous scroll */
        @keyframes scrollLeft {
            0% { transform: translateX(0); }
            100% { transform: translateX(-70%); } /* Move by the width of the original image set */
        }

    </style>

</head>
<body>

    <%-- Include Navigation Bar --%>
    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <%-- Use class instead of main tag selector --%>
    <main class="main-content">

        <!-- Hero Section -->
        <section class="hero" aria-labelledby="hero-heading">
            <h1 id="hero-heading">Find Your Perfect View at MonitorHub</h1>
            <p>Explore the latest monitors for gaming, productivity, and everything in between, styled with a fresh look.</p>
            <a href="#featured-products" class="cta-button">Shop Now</a>
        </section>

        <!-- Featured Categories -->
        <section class="categories" aria-labelledby="categories-heading">
            <h2 id="categories-heading">Shop by Category</h2>
            <div class="grid-container">
                <%-- Static examples - Replace with dynamic data --%>
                <div class="category-card"> <div> <img src="https://media.itechstore.com.np/w_3072&f_png/img/product/5089bc13-f000-4008-9baf-5586866e92e0/LG%20UltraGear%20Curved%20Gaming%20Monitor-01.png" alt="Gaming Monitors Icon"> <h3>Gaming Monitors</h3> <p>High refresh rates and low response times for the competitive edge.</p> </div> <a href="${pageContext.request.contextPath}/categories?type=gaming" class="cta-button">Explore Gaming</a> </div>
                <div class="category-card"> <div> <img src="https://s3.us-east-1.amazonaws.com/product-image-bucket-prod-us/523119-Product-0-I-637683472085521055.jpg" alt="Ultrawide Monitors Icon"> <h3>Ultrawide Monitors</h3> <p>Immersive viewing and enhanced multitasking capabilities.</p> </div> <a href="${pageContext.request.contextPath}/categories?type=ultrawide" class="cta-button">Explore Ultrawide</a> </div>
                <div class="category-card"> <div> <img src="https://pro.sony/s3/2019/03/02114303/Pro_Monitors_TMV_v2.png" alt="Professional Monitors Icon"> <h3>Professional Monitors</h3> <p>Color accuracy and clarity for creative and technical work.</p> </div> <a href="${pageContext.request.contextPath}/categories?type=professional" class="cta-button">Explore Professional</a> </div>
                <div class="category-card"> <div> <img src="https://gizmodo.com/app/uploads/2024/11/portable-monitor-15.jpg" alt="Portable Monitors Icon"> <h3>Portable Monitors</h3> <p>Extend your screen real estate anywhere, anytime.</p> </div> <a href="${pageContext.request.contextPath}/categories?type=portable" class="cta-button">Explore Portable</a> </div>
            </div>
        </section>

        <!-- Image Slider Section -->
        <section class="brand-slider" aria-labelledby="brand-slider-heading">
             <h2 id="brand-slider-heading" style="text-align: center; margin-bottom: 15px;">Our Partnered Brands</h2>
             <div class="image-slider-container">
                 <div class="image-slider-track">
                    <a href="https://www.samsung.com/" target="_blank" rel="noopener noreferrer" aria-label="Samsung Website"><img src="${pageContext.request.contextPath}/images/samsunglogo.jpg" alt="Samsung Logo"></a>
                    <a href="https://www.hp.com/" target="_blank" rel="noopener noreferrer" aria-label="HP Website"><img src="${pageContext.request.contextPath}/images/hplogo.jpg" alt="HP Logo"></a>
                    <a href="https://www.lg.com/" target="_blank" rel="noopener noreferrer" aria-label="LG Website"><img src="${pageContext.request.contextPath}/images/lglogo.png" alt="LG Logo"></a>
                    <a href="https://www.dell.com/" target="_blank" rel="noopener noreferrer" aria-label="Dell Website"><img src="${pageContext.request.contextPath}/images/delllogo.png" alt="Dell Logo"></a>
                    <a href="https://www.msi.com/" target="_blank" rel="noopener noreferrer" aria-label="MSI Website"><img src="${pageContext.request.contextPath}/images/msilogo.png" alt="MSI Logo"></a>
                    <a href="https://www.asus.com/" target="_blank" rel="noopener noreferrer" aria-label="ASUS Website"><img src="${pageContext.request.contextPath}/images/asuslogo.jpg" alt="ASUS Logo"></a>
                    <%-- Duplicated for seamless loop --%>
                    <a href="https://www.samsung.com/" target="_blank" rel="noopener noreferrer" aria-label="Samsung Website"><img src="${pageContext.request.contextPath}/images/samsunglogo.jpg" alt="Samsung Logo"></a>
                    <a href="https://www.hp.com/" target="_blank" rel="noopener noreferrer" aria-label="HP Website"><img src="${pageContext.request.contextPath}/images/hplogo.jpg" alt="HP Logo"></a>
                    <a href="https://www.lg.com/" target="_blank" rel="noopener noreferrer" aria-label="LG Website"><img src="${pageContext.request.contextPath}/images/lglogo.png" alt="LG Logo"></a>
                    <a href="https://www.dell.com/" target="_blank" rel="noopener noreferrer" aria-label="Dell Website"><img src="${pageContext.request.contextPath}/images/delllogo.png" alt="Dell Logo"></a>
                    <a href="https://www.msi.com/" target="_blank" rel="noopener noreferrer" aria-label="MSI Website"><img src="${pageContext.request.contextPath}/images/msilogo.png" alt="MSI Logo"></a>
                    <a href="https://www.asus.com/" target="_blank" rel="noopener noreferrer" aria-label="ASUS Website"><img src="${pageContext.request.contextPath}/images/asuslogo.jpg" alt="ASUS Logo"></a>
                 </div>
             </div>
        </section>

        <!-- Featured Products Section -->
        <section id="featured-products" aria-labelledby="featured-heading">
            <h2 id="featured-heading">Featured Monitors</h2>
            <div class="grid-container"> <%-- Grid container for product cards --%>

                <div class="product-card">
                    <img src="https://images.samsung.com/is/image/samsung/p6pim/hk_en/ls32bg750ncxxk/gallery/hk-en-odyssey-neo-g7-g75nb-ls32bg750ncxxk-thumb-532845951" alt="Samsung Odyssey G7 32-inch Gaming Monitor">
                    <div class="product-content"> <%-- Content wrapper --%>
                        <h3>Samsung Odyssey G7 32"</h3>
                        <p class="product-description">240Hz, 1ms, QHD, Curved Gaming Monitor with G-Sync & FreeSync Premium Pro.</p>
                        <p class="price">$599.99 <span class="old-price">$699.99</span></p>
                    </div>
                    <a href="${pageContext.request.contextPath}/product-details" class="cta-button">View Details</a>
                </div>

                <div class="product-card">
                     <img src="https://compujordan.com/image/cache/catalog/products/Monitor%20and%20Display/LG%20Monitors/27UP850-W/lg_27UP850-W_1-1200x1200.jpg" alt="LG UltraFine 27UP850-W 27-inch Professional Monitor">
                     <div class="product-content"> <%-- Content wrapper --%>
                         <h3>LG UltraFine 27UP850-W 27" 4K</h3>
                         <p class="product-description">IPS Display, 95% DCI-P3, USB-C with 96W Power Delivery, HDR400.</p>
                         <p class="price">$449.99</p>
                     </div>
                     <a href="https://www.lg.com/us/monitors/lg-27up850-w" class="cta-button">View Details</a>
                 </div>

                <div class="product-card">
                     <img src="https://my-store.msi.com/cdn/shop/files/ARTYMIS343CQR_5_700x700.png?v=1702461651" alt="MSI MPG ARTYMIS 343CQR 34-inch Ultrawide Gaming Monitor">
                     <div class="product-content"> <%-- Content wrapper --%>
                         <h3>MSI MPG ARTYMIS 343CQR 34" Ultrawide</h3>
                         <p class="product-description">165Hz, 1ms, WQHD, 1000R Curved, FreeSync Premium.</p>
                         <p class="price">$479.99</p>
                     </div>
                     <a href="https://www.msi.com/Monitor/MPG-ARTYMIS-343CQR" class="cta-button">View Details</a>
                 </div>

                <div class="product-card">
                     <img src="https://images-cdn.ubuy.co.id/666c175bba873516b93a62a2-asus-zenscreen-mb16ace-15-6-full-hd.jpg" alt="ASUS ZenScreen MB16ACE 15.6-inch Portable Monitor">
                     <div class="product-content"> <%-- Content wrapper --%>
                         <h3>ASUS ZenScreen MB16ACE 15.6" Portable</h3>
                         <p class="product-description">Full HD, IPS, USB-C, Lightweight and Portable Design with Smart Cover.</p>
                         <p class="price">$269.00</p>
                     </div>
                     <a href="https://asus.com/Displays-Desktops/Monitors/ZenScreen/ZenScreen-MB16ACE/" class="cta-button">View Details</a>
                 </div>

                <div class="product-card">
                     <img src="https://onlineit.com.np/wp-content/uploads/2024/01/RPmyhBmwuLJEomDRbiHxnZImNovWuvQbdmoxQyv9.jpg" alt="Dell S2722QC 27-inch 4K USB-C Monitor">
                     <div class="product-content"> <%-- Content wrapper --%>
                         <h3>Dell S2722QC 27" 4K USB-C</h3>
                         <p class="product-description">4K UHD, IPS, USB-C with 65W Power Delivery, Built-in Speakers.</p>
                         <p class="price">$399.99</p>
                     </div>
                     <a href="https://www.dell.com/en-us/shop/dell-27-4k-uhd-usb-c-monitor-s2722qc/apd/210-ayoz/monitors-monitor-accessories" class="cta-button">View Details</a>
                 </div>

                <div class="product-card">
                     <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSIUMmXlnOjiBDgJzMv4N9M_LO5GsN16gIsVQ&s" alt="HP U27 4K Wireless Monitor">
                     <div class="product-content"> <%-- Content wrapper --%>
                         <h3>HP U27 4K Wireless Monitor</h3>
                         <p class="product-description">4K UHD, IPS, Wireless Screen Sharing, Integrated Speakers.</p>
                         <p class="price">$479.00</p>
                     </div>
                     <a href="https://www.hp.com/us-en/shop/pdp/hp-u27-4k-wireless-monitor" class="cta-button">View Details</a>
                 </div>

                 <div class="product-card">
                      <img src="https://www.neostore.com.np/assets/uploads/g9_31.jpg" alt="Samsung Odyssey G9 49-inch Super Ultrawide Monitor">
                      <div class="product-content"> <%-- Content wrapper --%>
                          <h3>Samsung Odyssey G9 49" Super Ultrawide</h3>
                          <p class="product-description">240Hz, 1ms, DQHD (5120x1440), 1000R Curved, QLED, G-Sync & FreeSync Premium Pro.</p>
                          <p class="price">$1199.99 <span class="old-price">$1399.99</span></p>
                      </div>
                      <a href="https://www.samsung.com/us/computing/monitors/gaming/49-odyssey-g9-gaming-monitor-lc49g95tssnxza/" class="cta-button">View Details</a>
                  </div>

                  <div class="product-card">
                      <img src="https://media.extra.com/s/aurora/100305504_800/LG-27-inch-Monitor-UltraGear-QHD-Nano-IPS-Panel-with-AMD-FreeSync-Premium?locale=en-GB,en-*,*" alt="LG UltraGear 27GP850-B 27-inch QHD Gaming Monitor">
                      <div class="product-content"> <%-- Content wrapper --%>
                          <h3>LG UltraGear 27GP850-B 27" QHD</h3>
                          <p class="product-description">165Hz (O/C 180Hz), 1ms, QHD Nano IPS, G-Sync Compatible, FreeSync Premium.</p>
                          <p class="price">$379.99</p>
                      </div>
                      <a href="https://www.lg.com/us/monitors/lg-27gp850-b-gaming-monitor" class="cta-button">View Details</a>
                  </div>

                  <div class="product-card">
                      <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRfWJJ8ut3UPa4b10ewZrQje7nN5djwu7WlBA&s" alt="ASUS ProArt PA278CV 27-inch Professional Monitor">
                      <div class="product-content"> <%-- Content wrapper --%>
                          <h3>ASUS ProArt PA278CV 27" WQHD</h3>
                          <p class="product-description">WQHD (2560x1440), IPS, 100% sRGB, Calman Verified, USB-C Docking.</p>
                          <p class="price">$329.00</p>
                      </div>
                      <a href="https://www.asus.com/displays-desktops/monitors/proart/proart-display-pa278cv/" class="cta-button">View Details</a>
                  </div>

                  <div class="product-card">
                      <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSVN_tQ0AMfJNwIGjVjrFlKpnlcOCEFkmfL7g&s" alt="Dell Alienware AW2521HFL 24.5-inch Gaming Monitor">
                      <div class="product-content"> <%-- Content wrapper --%>
                          <h3>Dell Alienware AW2521HFL 24.5"</h3>
                          <p class="product-description">240Hz, 1ms, FHD, IPS, G-Sync Compatible, FreeSync Premium (Lunar Light).</p>
                          <p class="price">$319.99 <span class="old-price">$399.99</span></p>
                      </div>
                      <a href="https://www.dell.com/en-us/shop/alienware-25-gaming-monitor-aw2521hfl/apd/210-awdy/monitors-monitor-accessories" class="cta-button">View Details</a>
                  </div>

                   <div class="product-card">
                      <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT9SYkdwYleklHttu041jiKhz5eKP37Cwv53Q&s" alt="HP M27fw 27-inch FHD Monitor">
                      <div class="product-content"> <%-- Content wrapper --%>
                          <h3>HP M27fw 27" FHD Monitor</h3>
                          <p class="product-description">Full HD (1920x1080), IPS, AMD FreeSync, 99% sRGB, Eyesafe Certified Display.</p>
                          <p class="price">$199.99</p>
                      </div>
                      <a href="https://www.hp.com/us-en/shop/pdp/hp-m27fw-fhd-monitor" class="cta-button">View Details</a>
                  </div>

                  <div class="product-card">
                      <img src="https://qualitycomputer.com.np/web/image/product.template/49392/image_1024?unique=4b7855e" alt="MSI Optix G273QF 27-inch WQHD Gaming Monitor">
                      <div class="product-content"> <%-- Content wrapper --%>
                          <h3>MSI Optix G273QF 27" WQHD</h3>
                          <p class="product-description">165Hz Refresh Rate, 1ms GTG Response Time, WQHD (2560x1440), Rapid IPS Panel.</p>
                          <p class="price">$299.99</p>
                      </div>
                      <a href="https://www.msi.com/Monitor/Optix-G273QF" class="cta-button">View Details</a>
                  </div>

            </div> <%-- End grid-container --%>
        </section>

        <!-- Promotion/Special Offer Section -->
        <section class="promo" aria-labelledby="promo-heading">
            <h2 id="promo-heading">Limited Time Offer!</h2>
            <p>Get <strong>10% OFF</strong> all 4K Monitors this week only! Use code: <strong>4KSALE</strong></p>
             <a href="${pageContext.request.contextPath}/products?filter=4k&promo=4KSALE" class="cta-button">Shop 4K Deals</a>
        </section>

        <section class="why-us" aria-labelledby="why-us-heading">
                <h2 id="why-us-heading" class="text-gray-800">Why Choose Monitor Hub?</h2>
                <div class="grid-container"> <%-- Reusing grid-container for features --%>
                     <div class="feature-item">
                         <span class="fas fa-desktop fa-2x"></span> <h3 class="text-gray-900">Wide Selection</h3>
                         <p>Explore a vast range of monitors. From budget-friendly options for everyday use to high-performance gaming displays and professional-grade screens for creative work, we have it all.</p>
                     </div>
                     <div class="feature-item">
                         <span class="fas fa-search fa-2x"></span> <h3 class="text-gray-900">Expert Advice</h3>
                         <p>Not sure which monitor is right for you? Read our detailed reviews, comprehensive buying guides, and comparison tools to make an informed decision tailored to your needs.</p>
                     </div>
                     <div class="feature-item">
                         <span class="fas fa-shipping-fast fa-2x"></span> <h3 class="text-gray-900">Fast & Reliable Shipping</h3>
                         <p>We know you're excited! Get your new monitor delivered quickly and reliably right to your doorstep with our efficient shipping partners.</p>
                     </div>
                     <div class="feature-item">
                         <span class="fas fa-lock fa-2x"></span> <h3 class="text-gray-900">Secure Checkout</h3>
                         <p>Your security is our priority. Shop with confidence using our encrypted and secure payment gateways for a safe transaction every time.</p>
                     </div>
                     <div class="feature-item">
                         <span class="fas fa-tags fa-2x"></span> <h3 class="text-gray-900">Competitive Pricing</h3>
                         <p>Get the best value for your money. We strive to offer competitive prices and great deals on top monitor brands and models.</p>
                     </div>
                     <div class="feature-item">
                         <span class="fas fa-headset fa-2x"></span> <h3 class="text-gray-900">Excellent Customer Support</h3>
                         <p>Have questions or need assistance? Our friendly and knowledgeable customer support team is here to help you before, during, and after your purchase.</p>
                     </div>
                     <div class="feature-item">
                         <span class="fas fa-undo-alt fa-2x"></span> <h3 class="text-gray-900">Easy Returns</h3>
                         <p>Not completely satisfied? Our hassle-free return policy ensures you can shop with peace of mind.</p>
                     </div>
                     <div class="feature-item">
                         <span class="fas fa-shield-alt fa-2x"></span> <h3 class="text-gray-900">Warranty Support</h3>
                         <p>All monitors come with manufacturer warranties, and we're here to assist with any warranty claims or questions.</p>
                     </div>
                </div>
            </section>

    </main>

    <%-- Include Footer --%>
    <jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>