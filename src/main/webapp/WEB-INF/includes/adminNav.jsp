<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<!-- Sidebar Navigation -->
<nav class="sidebar">
    <div>
        <div class="sidebar-header">
            <a href="<%= request.getContextPath() %>/admin/dashboard" title="MonitorHub Dashboard">
                <img src="<%= request.getContextPath() %>/images/monitorhublogo.png" alt="MonitorHub Logo">
            </a>
        </div>
        <ul class="nav-links">
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
        </ul>
    </div>

    <div class="profile-section">
        <div class="profile-picture-wrapper" id="profile-toggle" aria-haspopup="true" aria-expanded="false" aria-controls="settings-menu">
            <img src="${not empty sessionScope.user.imageUrl ? sessionScope.user.imageUrl : pageContext.request.contextPath.concat('/images/defaultuserprofile.jpg')}"
                 alt="Admin Profile Picture"
                 onerror="this.onerror=null; this.src='<%= request.getContextPath() %>/images/defaultuserprofile.jpg';" >
        </div>
        <div class="settings-dropdown" id="settings-menu" role="menu">
            <a href="<%= request.getContextPath() %>/home" role="menuitem" target="_blank">Customer's POV</a>
            <form action="<%= request.getContextPath() %>/logout" method="post" style="margin: 0;">
                <button type="submit" role="menuitem">Logout</button>
            </form>
        </div>
    </div>
</nav>

<script>

    (function() {
        const profileToggle = document.getElementById('profile-toggle');
        const settingsMenu = document.getElementById('settings-menu');

        if (profileToggle && settingsMenu) {
            profileToggle.addEventListener('click', (event) => {
                const isActive = settingsMenu.classList.toggle('active');
                profileToggle.setAttribute('aria-expanded', isActive.toString());
                event.stopPropagation();
            });
            document.addEventListener('click', (event) => {
                if (settingsMenu.classList.contains('active') &&
                    !profileToggle.contains(event.target) &&
                    !settingsMenu.contains(event.target))
                {
                    settingsMenu.classList.remove('active');
                    profileToggle.setAttribute('aria-expanded', 'false');
                }
            });
        } else {
             console.warn("AdminNav: Profile toggle or settings menu element not found.");
        }
    })();
</script>