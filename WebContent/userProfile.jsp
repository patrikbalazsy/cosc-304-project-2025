<!DOCTYPE html>
<html>
<head>
<title>Edit Profile</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style>
    /* Industrial Form Styling matching createUser.jsp */
    .form-container {
        border: 3px solid #000;
        padding: 40px;
        max-width: 700px;
        margin: 0 auto;
        background: #fff;
    }

    h1 {
        text-align: left;
        margin-left: 0;
        margin-bottom: 20px;
        font-size: 2rem;
        font-weight: 900;
        text-transform: uppercase;
    }

    h3 {
        margin-top: 30px;
        margin-bottom: 10px;
        font-size: 1.1rem;
        font-weight: 800;
        text-transform: uppercase;
        border-bottom: 2px solid #000;
        padding-bottom: 5px;
    }

    .input-row {
        display: flex;
        gap: 20px;
        margin-bottom: 15px;
    }

    .input-full {
        width: 100%;
        margin-bottom: 15px;
        box-sizing: border-box; 
    }

    .input-row input {
        flex: 1;
        width: 100%; 
    }
    
    input[type="text"], input[type="password"], input[type="email"] {
        border: 3px solid #000;
        padding: 15px;
        font-size: 1rem;
        border-radius: 0;
        outline: none;
        background: #fff;
    }

    /* Read-only inputs look different */
    input[readonly] {
        background-color: #e0e0e0;
        color: #666;
        cursor: not-allowed;
    }

    input[type="submit"] {
        width: 100%;
        margin-top: 30px;
        font-size: 1.2rem;
        font-weight: 900;
        text-transform: uppercase;
        background-color: #000;
        color: #fff;
        border: 3px solid #000;
        padding: 15px;
        cursor: pointer;
    }
    
    input[type="submit"]:hover {
        background-color: #fff;
        color: #000;
    }

    .message {
        padding: 15px;
        margin-bottom: 20px;
        border: 3px solid #000;
        font-weight: bold;
        text-align: center;
    }
    .success { background-color: #e6ffe6; color: green; }
    .error { background-color: #ffe6e6; color: red; }
    
    .return-link {
        display: block;
        margin-top: 20px;
        text-align: center;
        font-weight: 900;
        color: #000;
        text-decoration: none;
        text-transform: uppercase;
    }
</style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>

<%
    String user = (String) session.getAttribute("authenticatedUser");
    String msg = "";
    String msgType = "";

    // 1. HANDLE FORM SUBMISSION (UPDATE)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        try {
            getConnection();
            String updateSql = "UPDATE customer SET password=?, firstName=?, lastName=?, email=?, phonenum=?, address=?, city=?, state=?, postalCode=?, country=? WHERE userId=?";
            PreparedStatement ps = con.prepareStatement(updateSql);
            ps.setString(1, request.getParameter("password"));
            ps.setString(2, request.getParameter("firstName"));
            ps.setString(3, request.getParameter("lastName"));
            ps.setString(4, request.getParameter("email"));
            ps.setString(5, request.getParameter("phonenum"));
            ps.setString(6, request.getParameter("address"));
            ps.setString(7, request.getParameter("city"));
            ps.setString(8, request.getParameter("state"));
            ps.setString(9, request.getParameter("postalCode"));
            ps.setString(10, request.getParameter("country"));
            ps.setString(11, user);
            
            int rows = ps.executeUpdate();
            if(rows > 0) {
                msg = "Profile updated successfully.";
                msgType = "success";
            } else {
                msg = "Update failed. User not found.";
                msgType = "error";
            }
        } catch (SQLException e) {
            msg = "Database Error: " + e.getMessage();
            msgType = "error";
        } finally {
            closeConnection();
        }
    }

    // 2. LOAD CURRENT DATA
    // Variables to hold current data
    String password="", firstName="", lastName="", email="", phonenum="", address="", city="", state="", postalCode="", country="";
    
    try {
        getConnection();
        String sql = "SELECT * FROM customer WHERE userId = ?";
        PreparedStatement stmt = con.prepareStatement(sql);
        stmt.setString(1, user);
        ResultSet rs = stmt.executeQuery();
        if (rs.next()) {
            password = rs.getString("password");
            firstName = rs.getString("firstName");
            lastName = rs.getString("lastName");
            email = rs.getString("email");
            phonenum = rs.getString("phonenum");
            address = rs.getString("address");
            city = rs.getString("city");
            state = rs.getString("state");
            postalCode = rs.getString("postalCode");
            country = rs.getString("country");
        }
    } catch (SQLException e) {
        msg = "Error loading profile: " + e.getMessage();
        msgType = "error";
    } finally {
        closeConnection();
    }
%>

<div class="content-container">
    <h1>Modify User Settings</h1>
    
    <div class="form-container">
        <% if(!msg.isEmpty()) { %>
            <div class="message <%= msgType %>"><%= msg %></div>
        <% } %>

        <form method="post" action="userProfile.jsp">
            
            <h3>Security & Identity</h3>
            <input class="input-full" type="text" value="User ID: <%= user %>" readonly title="Username cannot be changed">
            
            <div class="input-row">
                <input type="password" name="password" value="<%= password %>" required placeholder="Password">
                </div>

            <h3>Personal Data</h3>
            <div class="input-row">
                <input type="text" name="firstName" value="<%= firstName %>" required placeholder="First Name">
                <input type="text" name="lastName" value="<%= lastName %>" required placeholder="Last Name">
            </div>

            <input class="input-full" type="email" name="email" value="<%= email %>" required placeholder="Email Address">

            <div class="input-row">
                <input type="text" name="phonenum" value="<%= phonenum %>" placeholder="Phone Number">
                <input type="text" name="address" value="<%= address %>" required placeholder="Address">
            </div>

            <div class="input-row">
                <input type="text" name="city" value="<%= city %>" required placeholder="City">
                <input type="text" name="state" value="<%= state %>" required placeholder="State">
            </div>

            <div class="input-row">
                <input type="text" name="postalCode" value="<%= postalCode %>" required placeholder="Postal Code">
                <input type="text" name="country" value="<%= country %>" required placeholder="Country">
            </div>
            
            <input type="submit" value="Save Changes">
        </form>
    </div>
    
    <a href="customer.jsp" class="return-link">&lt; Return to Profile View</a>
</div>

</body>
</html>