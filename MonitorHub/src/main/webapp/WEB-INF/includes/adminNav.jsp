<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %> <%-- Ensure EL is enabled --%>

<!-- Sidebar Navigation -->
<nav class="sidebar">
    <%-- Top section containing logo and links - grouped for structure --%>
    <div>
        <div class="sidebar-header">
            <a href="<%= request.getContextPath() %>/admin/dashboard" title="MonitorHub Dashboard">
                <img src="<%= request.getContextPath() %>/images/monitorhublogo.png" alt="MonitorHub Logo">
                <%-- Text only visible when expanded - styled via CSS --%>
            </a>
        </div>
        <ul class="nav-links">
            <%-- Determine active page based on servlet path --%>
            <% String currentPage = request.getServletPath(); %>
            <li>
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="<%= currentPage != null && currentPage.endsWith("/dashboard") ? "active" : "" %>" title="Home">
                    <span class="icon">🏠</span>
                    <span class="link-text">Dashboard</span>
                </a>
            </li>
            <li>
                <a href="<%= request.getContextPath() %>/admin/users" class="<%= currentPage != null && currentPage.contains("/admin/users") ? "active" : "" %>" title="Users">
                    <span class="icon">👥</span>
                    <span class="link-text">Users</span>
                </a>
            </li>
            <li>
                <a href="<%= request.getContextPath() %>/admin/products" class="<%= currentPage != null && currentPage.contains("/admin/products") ? "active" : "" %>" title="Products">
                    <span class="icon">📦</span>
                    <span class="link-text">Products</span>
                </a>
            </li>
            <li>
                <a href="<%= request.getContextPath() %>/admin/sales" class="<%= currentPage != null && currentPage.contains("/admin/sales") ? "active" : "" %>" title="Sales">
                    <span class="icon">💲</span>
                    <span class="link-text">Sales</span>
                </a>
            </li>
             <li> <%-- Added dummy orders link example based on recent orders table --%>
                 <a href="<%= request.getContextPath() %>/admin/orders" class="<%= currentPage != null && currentPage.contains("/admin/orders") ? "active" : "" %>" title="Orders">
                     <span class="icon">🛒</span>
                     <span class="link-text">Orders</span>
                 </a>
             </li>
        </ul>
    </div>

    <%-- Bottom section containing profile and logout --%>
    <div class="profile-section">
        <div class="profile-picture-wrapper" id="profile-toggle" aria-haspopup="true" aria-expanded="false" aria-controls="settings-menu">
            <%-- Use Admin User info from session, provide default --%>
            <img src="${not empty sessionScope.user.imageUrl ? sessionScope.user.imageUrl : pageContext.request.contextPath.concat('/images/defaultuserprofile.jpg')}"
                 alt="Admin Profile Picture"
                 onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultuserprofile.jpg';" >
                 <%-- Added onerror for robustness --%>
        </div>
        <div class="settings-dropdown" id="settings-menu" role="menu">
            <a href="<%= request.getContextPath() %>/home" role="menuitem" target="_blank">Customer's POV</a>
            <%-- Logout Form --%>
            <form action="<%= request.getContextPath() %>/logout" method="post" style="margin: 0;">
                <button type="submit" role="menuitem">Logout</button>
            </form>
        </div>
    </div>
</nav>

<!-- JS for Profile Dropdown Toggle (specific to this nav component) -->
<script>
    // Self-invoking function to avoid global scope pollution
    (function() {
        const profileToggle = document.getElementById('profile-toggle');
        const settingsMenu = document.getElementById('settings-menu');

        // Check if elements exist before adding listeners
        if (profileToggle && settingsMenu) {
            profileToggle.addEventListener('click', (event) => {
                const isActive = settingsMenu.classList.toggle('active');
                profileToggle.setAttribute('aria-expanded', isActive.toString()); // Use boolean directly
                // Correct transform application for smooth open/close
                 if (isActive) {
                     // Force browser repaint/reflow before adding transition class if needed,
                     // but usually toggling the class is enough if transitions are defined
                     // settingsMenu.style.display = 'block'; // Might be needed if using display none/block
                 } else {
                     // Optional: Reset styles explicitly if needed
                     // settingsMenu.style.opacity = '0';
                 }
                event.stopPropagation(); // Prevent click from immediately closing menu
            });

            // Close dropdown if clicking outside of it
            document.addEventListener('click', (event) => {
                // Check if the menu is active and the click was outside both the toggle and the menu
                if (settingsMenu.classList.contains('active') &&
                    !profileToggle.contains(event.target) &&
                    !settingsMenu.contains(event.target))
                {
                    settingsMenu.classList.remove('active');
                    profileToggle.setAttribute('aria-expanded', 'false');
                }
            });

             // Optional: Close on Escape key press
             document.addEventListener('keydown', (event) => {
                 if (event.key === 'Escape' && settingsMenu.classList.contains('active')) {
                     settingsMenu.classList.remove('active');
                     profileToggle.setAttribute('aria-expanded', 'false');
                 }
             });
        } else {
             console.warn("AdminNav: Profile toggle or settings menu element not found.");
        }
    })();
</script>