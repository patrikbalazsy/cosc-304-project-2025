<!DOCTYPE html>
<html>
<head>
<title>Customer Profile</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style>
    /* Page-specific styles to ensure the table looks good */
    .profile-header {
        text-align: left;
        font-size: 2rem;
        font-weight: 900;
        text-transform: uppercase;
        margin-bottom: 20px;
    }

    .profile-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }

    .profile-table td {
        border: 3px solid #000;
        padding: 15px;
        font-size: 1rem;
    }

    .label-col {
        background-color: #f0f0f0;
        font-weight: 900;
        text-transform: uppercase;
        width: 30%;
    }

    .data-col {
        background-color: #fff;
    }

    .action-bar {
        margin-top: 30px;
        display: flex;
        gap: 20px;
    }

    .btn {
        flex: 1;
        padding: 15px;
        text-align: center;
        border: 3px solid #000;
        text-decoration: none;
        font-weight: 900;
        text-transform: uppercase;
        color: #000;
        display: block;
    }

    .btn-primary {
        background-color: #000;
        color: #fff;
    }

    .btn-primary:hover {
        background-color: #333;
    }

    .btn-secondary:hover {
        background-color: #e0e0e0;
    }
</style>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>

<div class="content-container">
    
    <div class="form-container" style="max-width: 800px; margin: 0 auto; padding: 40px; border: 3px solid #000;">
        <h2 class="profile-header">Customer Profile</h2>

        <%
        String userName = (String) session.getAttribute("authenticatedUser");
        String sql = "SELECT * FROM customer WHERE userid = ?";
        
        try {
            getConnection();
            try (PreparedStatement stmt = con.prepareStatement(sql)) {
                stmt.setString(1, userName);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        // Retrieve data
                        int customerId = rs.getInt("customerId");
                        String userid = rs.getString("userid");
                        String firstName = rs.getString("firstName");
                        String lastName = rs.getString("lastName");
                        String email = rs.getString("email");
                        String phonenum = rs.getString("phonenum");
                        String address = rs.getString("address");
                        String city = rs.getString("city");
                        String state = rs.getString("state");
                        String postalCode = rs.getString("postalCode");
                        String country = rs.getString("country");
        %>
                        <table class="profile-table">
                            <tr>
                                <td class="label-col">Customer ID</td>
                                <td class="data-col"><%= customerId %></td>
                            </tr>
                            <tr>
                                <td class="label-col">User ID</td>
                                <td class="data-col"><%= userid %></td>
                            </tr>
                            <tr>
                                <td class="label-col">Full Name</td>
                                <td class="data-col"><%= firstName %> <%= lastName %></td>
                            </tr>
                            <tr>
                                <td class="label-col">Email</td>
                                <td class="data-col"><%= email %></td>
                            </tr>
                            <tr>
                                <td class="label-col">Phone</td>
                                <td class="data-col"><%= phonenum %></td>
                            </tr>
                            <tr>
                                <td class="label-col">Address</td>
                                <td class="data-col"><%= address %></td>
                            </tr>
                            <tr>
                                <td class="label-col">City</td>
                                <td class="data-col"><%= city %></td>
                            </tr>
                            <tr>
                                <td class="label-col">State</td>
                                <td class="data-col"><%= state %></td>
                            </tr>
                            <tr>
                                <td class="label-col">Postal Code</td>
                                <td class="data-col"><%= postalCode %></td>
                            </tr>
                            <tr>
                                <td class="label-col">Country</td>
                                <td class="data-col"><%= country %></td>
                            </tr>
                        </table>

                        <div class="action-bar">
                            <a href="index.jsp" class="btn btn-secondary">&lt; Return Home</a>
                            <a href="userProfile.jsp" class="btn btn-primary">Edit Information</a>
                        </div>
        <%
                    } else {
                        out.println("<h2 style='color:red;'>Error: Customer profile not found.</h2>");
                    }
                }
            }
        } catch (SQLException e) {
            out.println("<h3 style='color:red;'>Database Error: " + e.getMessage() + "</h3>");
        } finally {
            closeConnection();
        }
        %>
    </div>
</div>

</body>
</html>