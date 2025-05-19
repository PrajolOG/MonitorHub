<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>

<nav class="navbar">
    <div class="nav-left">
        <a href="<%= request.getContextPath() %>/home" class="logo-link" aria-label="Homepage">
            <img src="<%= request.getContextPath() %>/images/monitorhublogo.png" alt="Monitor Hub Logo">
        </a>
    </div>
    
    <div class="nav-middle">
        <ul class="nav-links">
            <% String requestPath = request.getServletPath(); %>
            <li><a href="<%= request.getContextPath() %>/home" class="${requestPath eq '/home' or requestPath eq '/' ? 'active' : ''}">Home</a></li>
            <li><a href="<%= request.getContextPath() %>/products" class="${requestPath eq '/products' ? 'active' : ''}">Products</a></li>
            <li><a href="<%= request.getContextPath() %>/categories" class="${requestPath eq '/categories' ? 'active' : ''}">Categories</a></li>
            <li><a href="<%= request.getContextPath() %>/about" class="${requestPath eq '/about' ? 'active' : ''}">About</a></li>
            <li><a href="<%= request.getContextPath() %>/contact" class="${requestPath eq '/contact' ? 'active' : ''}">Contact</a></li>
        </ul>
    </div>

    <div class="nav-right">
        <div class="search-container">
            <form action="<%= request.getContextPath() %>/search" method="get" role="search">
                <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" aria-hidden="true" focusable="false"><path d="M416 208c0 45.9-14.9 88.3-40 122.7L502.6 457.4c12.5 12.5 12.5 32.8 0 45.3s-32.8 12.5-45.3 0L330.7 376c-34.4 25.2-76.8 40-122.7 40C93.1 416 0 322.9 0 208S93.1 0 208 0S416 93.1 416 208zM208 352a144 144 0 1 0 0-288 144 144 0 1 0 0 288z"/></svg>
                <input type="search" name="query" placeholder="Search Monitors..." aria-label="Search website">
            </form>
        </div>

        <c:choose>
            <c:when test="${empty sessionScope.user}">
                <a href="<%= request.getContextPath() %>/login" class="nav-button login">Login</a>
            </c:when>
            <c:otherwise>
                <div class="profile-section-nav">
                    <div class="profile-picture-wrapper-nav" id="profile-toggle-nav" aria-haspopup="true" aria-expanded="false" aria-controls="settings-menu-nav">
                         <img src="<c:url value='${not empty sessionScope.user.imageUrl ? sessionScope.user.imageUrl : "/images/defaultuserprofile.jpg"}'/>"
     alt="${sessionScope.user.firstname}'s Profile Picture">
                    </div>
                    <div class="settings-dropdown-nav" id="settings-menu-nav" role="menu">
                        <a href="<%= request.getContextPath() %>/profile" role="menuitem">View Profile</a>
                        <form action="<%= request.getContextPath() %>/logout" method="post" style="margin:0; padding:0;"><button type="submit" class="dropdown-button" role="menuitem">Logout</button></form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<c:if test="${not empty sessionScope.user}">
<script>
    (function(){ 
        const profileToggleNav=document.getElementById('profile-toggle-nav');
        const settingsMenuNav=document.getElementById('settings-menu-nav');
        if(profileToggleNav&&settingsMenuNav){
            profileToggleNav.addEventListener('click',(event)=>{const t=settingsMenuNav.classList.toggle('active');profileToggleNav.setAttribute('aria-expanded',t);event.stopPropagation()});
            document.addEventListener('click',(event)=>{if(settingsMenuNav.classList.contains('active')&&!profileToggleNav.contains(event.target)&&!settingsMenuNav.contains(event.target)){settingsMenuNav.classList.remove('active');profileToggleNav.setAttribute('aria-expanded','false')}}, true); /* Use capture */
        }
    })();
</script>
</c:if>