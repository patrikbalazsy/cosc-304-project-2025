<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>User Profile</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style>
    /* Industrial Profile Styles */
    .profile-card { border: 3px solid #000; padding: 40px; max-width: 800px; margin: 0 auto; background: #fff; }
    .data-row { display: flex; border-bottom: 1px solid #ccc; padding: 15px 0; }
    .data-label { width: 30%; font-weight: 900; text-transform: uppercase; color: #666; }
    .data-value { width: 70%; font-weight: bold; }
    .btn { border: 3px solid #000; padding: 10px 20px; text-decoration: none; font-weight: 900; text-transform: uppercase; color: #000; display: inline-block; margin-top: 20px;}
    .btn:hover { background: #000; color: #fff; }
</style>
</head>
<body>

<div class="content-container">
    <%
    String userName = (String) session.getAttribute("authenticatedUser");
    if(userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            String sql = "SELECT * FROM customer WHERE userid = ?";
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, userName);
                ResultSet rs = stmt.executeQuery();
                if (rs.next()) {
    %>
        <h1 style="text-align: center; text-transform: uppercase; font-weight: 900; margin-bottom: 30px;">Customer Profile</h1>
        
        <div class="profile-card">
            <div class="data-row"><div class="data-label">Customer ID</div><div class="data-value"><%= rs.getInt("customerId") %></div></div>
            <div class="data-row"><div class="data-label">User ID</div><div class="data-value"><%= rs.getString("userId") %></div></div>
            <div class="data-row"><div class="data-label">Full Name</div><div class="data-value"><%= rs.getString("firstName") %> <%= rs.getString("lastName") %></div></div>
            <div class="data-row"><div class="data-label">Email</div><div class="data-value"><%= rs.getString("email") %></div></div>
            <div class="data-row"><div class="data-label">Phone</div><div class="data-value"><%= rs.getString("phonenum") %></div></div>
            <div class="data-row"><div class="data-label">Address</div><div class="data-value"><%= rs.getString("address") %></div></div>
            <div class="data-row"><div class="data-label">City / State</div><div class="data-value"><%= rs.getString("city") %>, <%= rs.getString("state") %></div></div>
            <div class="data-row"><div class="data-label">Country</div><div class="data-value"><%= rs.getString("country") %></div></div>

            <div style="display: flex; gap: 20px; justify-content: center;">
                <a href="home.jsp" class="btn">Return Home</a>
                <a href="userProfile.jsp" class="btn" style="background: #000; color: #fff;">Edit Profile</a>
            </div>
        </div>
    <%
                }
            }
        }
    } catch (Exception e) { out.println(e); }
    %>
</div>
</body>
</html>