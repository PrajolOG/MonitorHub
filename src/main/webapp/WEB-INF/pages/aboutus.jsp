<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About MonitorHub - Your Display Experts</title> <%-- Change title per page --%>

    <%-- Link the combined external CSS --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/includes.css">

    <%-- Add necessary global layout styles and page-specific styles --%>
    <style>
        /* Global Body Layout Styles */
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif; /* Base font */
            background-color: #eef2f7; /* Base background */
            background-image: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            color: #333; /* Base text color */
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            /* IMPORTANT padding for fixed navbar! Adjust value as needed. */
            padding-top: 125px; /* Example: Adjust this! */
            margin: 0; /* Ensure no default body margin */
        }

        .main-content {
            width: 100%;
            max-width: 1000px; /* Max width for About Us content */
            margin: 0 auto; /* Center content */
            padding: 20px; /* Padding around content */
            flex-grow: 1; /* Push footer down */
            animation: fadeIn 0.8s ease-in-out; /* Page content fade */
        }

        /* Responsive adjustment for body padding */
        @media (max-width: 768px) {
            body {
                padding-top: 0; /* Remove padding when nav is static */
            }
            .main-content {
                animation: none; /* Optional */
            }
        }

        /* --- Styles ONLY for About Us Page --- */
        .about-container {
            background-color: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.25);
            box-shadow: 0 12px 35px rgba(31, 38, 135, 0.1);
            border-radius: 20px;
            padding: 50px 45px;
            text-align: left;
            margin-bottom: 40px; /* Space before footer */
        }

        .about-section {
            margin-bottom: 45px;
            padding-bottom: 30px;
            border-bottom: 1px solid rgba(157, 78, 221, 0.15);
        }

        .about-section:last-child {
            margin-bottom: 0;
            padding-bottom: 0;
            border-bottom: none;
        }

		.about-container h1 {
		    font-size: 36px;
		    font-weight: 700;
		    margin-bottom: 15px;
		    color: #000000; /* This sets the text color directly to black */
		    text-align: center;
		    padding-bottom: 10px;
		}

        .intro-paragraph {
            text-align: center;
            font-size: 18px;
            color: #555;
            margin-bottom: 40px;
            line-height: 1.7;
            max-width: 800px;
            margin-left: auto;
            margin-right: auto;
        }

        .about-container h2 {
            font-size: 26px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #343a40;
            position: relative;
            padding-left: 15px;
        }

        .about-container h2::before {
            content: '';
            position: absolute;
            left: 0;
            top: 5px;
            bottom: 5px;
            width: 5px;
            background-color: #9d4edd;
            border-radius: 3px;
        }

        .about-container p,
        .about-container li {
            font-size: 16px;
            color: #495057;
            line-height: 1.8;
            margin-bottom: 15px;
        }

        .about-container strong {
            color: #5a189a;
            font-weight: 600;
        }

        .difference-list {
            list-style: none;
            padding-left: 5px;
            margin-top: 20px;
        }

        .difference-list li {
            margin-bottom: 15px;
        }

        .brand-logos {
            text-align: center;
        }

        .brand-logos h2 {
            margin-bottom: 30px;
            padding-left: 0;
            text-align: center;
        }

        .brand-logos h2::before {
            display: none;
        }

        .logo-grid {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
            gap: 40px;
        }

        .logo-grid a {
            display: inline-block;
            line-height: 0;
            text-decoration: none;
            border-radius: 4px;
            transition: transform 0.2s ease;
        }

        .logo-grid a:active {
            transform: scale(0.97);
        }

        .logo-grid img {
            height: 55px;
            max-width: 130px;
            width: auto;
            display: block;
            transition: none;
        }

        .faq-section {
            margin-top: 30px;
        }

        .faq-item {
            border-bottom: 1px solid rgba(0, 0, 0, 0.08);
        }

        .faq-item:last-child {
            border-bottom: none;
        }

        .faq-item details {
            width: 100%;
        }

        .faq-item summary {
            padding: 20px 10px 20px 0;
            font-size: 17px;
            font-weight: 600;
            color: #333;
            cursor: pointer;
            position: relative;
            list-style: none;
            transition: background-color 0.2s ease;
            outline: none;
        }

        .faq-item summary:hover {
            background-color: rgba(157, 78, 221, 0.05);
        }

        .faq-item summary::after {
            content: '+';
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 24px;
            font-weight: 400;
            color: #9d4edd;
            transition: transform 0.3s ease;
        }

        .faq-item details[open] summary::after {
            content: '−';
            transform: translateY(-50%);
        }

        .faq-item summary::-webkit-details-marker {
            display: none;
        }

        .faq-answer {
            padding: 10px 15px 25px 0;
            font-size: 15px;
            line-height: 1.7;
            color: #555;
        }

        /* About Us Page Responsive */
        @media (max-width: 768px) {
            .about-container {
                padding: 35px 25px;
                border-radius: 15px;
            }
            .about-container h1 {
                font-size: 30px;
            }
            .intro-paragraph {
                font-size: 16px;
            }
            .about-container h2 {
                font-size: 22px;
                padding-left: 12px;
            }
            .about-container h2::before {
                width: 4px;
                top: 4px;
                bottom: 4px;
            }
            .about-container p,
            .about-container li {
                font-size: 15px;
            }
            .logo-grid {
                gap: 30px;
            }
            .logo-grid img {
                height: 45px;
            }
            .faq-item summary {
                font-size: 16px;
                padding: 18px 5px 18px 0;
            }
            .faq-answer {
                font-size: 14px;
            }
        }

        @media (max-width: 576px) {
            .about-container {
                padding: 30px 15px;
                border-radius: 10px;
                margin-bottom: 30px;
            }
            .about-container h1 {
                font-size: 26px;
            }
            .intro-paragraph {
                font-size: 15px;
                margin-bottom: 30px;
            }
            .about-container h2 {
                font-size: 20px;
                margin-bottom: 15px;
            }
            .about-section {
                padding-bottom: 25px;
                margin-bottom: 35px;
            }
            .difference-list li {
                margin-bottom: 15px;
            }
            .logo-grid {
                gap: 25px;
            }
            .logo-grid img {
                height: 40px;
            }
            .faq-item summary {
                font-size: 15px;
                padding: 15px 0px 15px 0;
            }
            .faq-item summary::after {
                right: 0px;
                font-size: 22px;
            }
            .faq-answer {
                padding: 5px 10px 20px 0;
            }
        }

        /* --- Page Load Animation --- */
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

    </style>

</head>
<body>

    <jsp:include page="/WEB-INF/includes/nav.jsp" />

    <main class="main-content">
        <div class="about-container"> <%-- Keep page-specific content wrapper --%>
            <h1>Discover MonitorHub</h1>
            <p class="intro-paragraph">
                Your crystal-clear view into the world of displays. We're not just selling monitors; we're connecting you with the perfect visual experience tailored to your needs.
            </p>
            <div class="about-section"> <%-- Mission --%>
                <h2>Our Mission</h2>
                <p>To simplify the search for the perfect display. We strive to empower every customer – from casual users to hardcore gamers and creative professionals – with the knowledge and selection needed to find a monitor that enhances their digital life.</p>
            </div>
            <div class="about-section"> <%-- Difference --%>
                 <h2>The MonitorHub Difference</h2>
                 <ul class="difference-list">
                     <li><span><strong>Curated Selection:</strong> We handpick the best monitors from leading brands, focusing on quality, performance, and value. From bleeding-edge gaming displays to color-accurate professional screens, find exactly what you need.</span></li>
                     <li><span><strong>Expert Guidance:</strong> Confused by refresh rates, panel types, or resolutions? Our resources and support team break down the tech specs, helping you make an informed choice without the jargon.</span></li>
                     <li><span><strong>Competitive Value:</strong> We work directly with manufacturers to offer competitive pricing and exclusive deals, ensuring you get the best possible value for your investment.</span></li>
                     <li><span><strong>Dedicated Support:</strong> Our commitment doesn't end at checkout. We provide responsive customer service and support to ensure you're satisfied with your purchase long after it arrives.</span></li>
                 </ul>
            </div>
            <div class="about-section brand-logos"> <%-- Brands --%>
                <h2>Trusted Brands We Partner With</h2>
                 <div class="logo-grid">
                     <a href="https://www.samsung.com/" target="_blank" rel="noopener noreferrer" aria-label="Samsung Website"><img src="${pageContext.request.contextPath}/images/samsunglogo.jpg" alt="Samsung Logo"></a>
                     <a href="https://www.hp.com/" target="_blank" rel="noopener noreferrer" aria-label="HP Website"><img src="${pageContext.request.contextPath}/images/hplogo.jpg" alt="HP Logo"></a>
                     <a href="https://www.lg.com/" target="_blank" rel="noopener noreferrer" aria-label="LG Website"><img src="${pageContext.request.contextPath}/images/lglogo.png" alt="LG Logo"></a>
                     <a href="https://www.dell.com/" target="_blank" rel="noopener noreferrer" aria-label="Dell Website"><img src="${pageContext.request.contextPath}/images/delllogo.png" alt="Dell Logo"></a>
                     <a href="https://www.msi.com/" target="_blank" rel="noopener noreferrer" aria-label="MSI Website"><img src="${pageContext.request.contextPath}/images/msilogo.png" alt="MSI Logo"></a>
                     <a href="https://www.asus.com/" target="_blank" rel="noopener noreferrer" aria-label="ASUS Website"><img src="${pageContext.request.contextPath}/images/asuslogo.jpg" alt="ASUS Logo"></a>
                 </div>
            </div>
             <div class="about-section faq-section"> <%-- FAQ --%>
                 <h2>Frequently Asked Questions</h2>
                 <div class="faq-item">
                     <details>
                         <summary>How do I choose the right monitor for gaming?</summary>
                         <div class="faq-answer">
                             <p>For gaming, prioritize high refresh rates (144Hz or higher) and low response times (1ms GTG is ideal). Consider the resolution (1440p or 4K for detail, 1080p for higher frame rates) and panel type (IPS for colors, TN for speed, VA for contrast). Adaptive Sync (G-Sync/FreeSync) is also crucial to prevent screen tearing.</p>
                         </div>
                     </details>
                 </div>
                 <div class="faq-item">
                     <details>
                         <summary>What's important for a professional/creative monitor?</summary>
                         <div class="faq-answer">
                             <p>Creative professionals should look for monitors with excellent color accuracy (high sRGB, Adobe RGB, or DCI-P3 coverage), good brightness and contrast, and potentially features like hardware calibration support. IPS panels are generally preferred for color work. Resolution (1440p or 4K) is important for detail.</p>
                         </div>
                     </details>
                 </div>
                 <div class="faq-item">
                     <details>
                         <summary>What is your shipping policy?</summary>
                         <div class="faq-answer">
                             <p>We offer various shipping options detailed during checkout. Standard shipping typically takes 3-7 business days within the continental US. Expedited options are available. Please refer to our dedicated Shipping Policy page for full details, including international shipping information.</p>
                         </div>
                     </details>
                 </div>
                 <div class="faq-item">
                     <details>
                         <summary>What is your return policy?</summary>
                         <div class="faq-answer">
                             <p>We offer a 30-day return policy for most monitors, provided they are in their original condition with all accessories and packaging. Some restrictions may apply (e.g., open-box items). Please review our full Return Policy on our website or contact customer support for specific inquiries.</p>
                         </div>
                     </details>
                 </div>
                 <div class="faq-item">
                     <details>
                         <summary>Do monitors come with a warranty?</summary>
                         <div class="faq-answer">
                             <p>Yes, all new monitors sold by MonitorHub come with the standard manufacturer's warranty. Warranty duration and terms vary by brand and model. Details can typically be found on the product page or the manufacturer's website. We can assist with warranty claims if needed.</p>
                         </div>
                     </details>
                 </div>
             </div>
        </div>
    </main>

    <jsp:include page="/WEB-INF/includes/footer.jsp" />

</body>
</html>