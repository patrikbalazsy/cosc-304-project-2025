<%-- header.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%-- Check authentication status once --%>
<% String userName = (String) session.getAttribute("authenticatedUser"); %>

<div class="main-nav-bar">
    
    <a href="home.jsp" class="logo-link">
        <img src="img/cloud_eight_logo_black.png" alt="Cloud Eight Spray Paint" class="nav-logo">
    </a>
    
    <nav class="nav-links">
        
        <a href="customer.jsp">Profile</a>
        <a href="listorder.jsp">Orders</a>
        <a href="admin.jsp">Admin</a>
        
        <%
            if (userName != null) {
                // Show username and Logout button if authenticated
                out.println("<span class=\"user-info\">LOGGED IN: "+userName+"</span>");
                out.println("<a href=\"logout.jsp\">Logout</a>");
            } else {
                // Show Login button if not authenticated
                out.println("<a href=\"login.jsp\">Login</a>");
            }
        %>
        
    </nav>
</div>