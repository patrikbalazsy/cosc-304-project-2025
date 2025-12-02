<%@ page import="java.sql.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%
    String username = request.getParameter("username");
    String email = request.getParameter("email");

    // Database connection parameters matching your other files
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        // Load the SQL Server driver
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        con = DriverManager.getConnection(url, uid, pw);

        // Query to find the password for the given userId and email
        // Note: Assuming 'userId' is the column name for username based on your validateLogin.jsp
        String sql = "SELECT password FROM customer WHERE userId = ? AND email = ?";
        ps = con.prepareStatement(sql);
        ps.setString(1, username);
        ps.setString(2, email);
        
        rs = ps.executeQuery();

        if (rs.next()) {
            // Success: User found
            String retrievedPassword = rs.getString("password");
%>
            <!DOCTYPE html>
            <html>
            <head>
                <title>Password Retrieved</title>
                <link rel="stylesheet" type="text/css" href="style.css">
            </head>
            <body>
                <div class="content-container" style="text-align: center;">
                    <h1>Access Credentials Retrieved</h1>
                    <div style="border: 3px solid #000; padding: 40px; width: 50%; margin: 0 auto; background: #e6ffe6;">
                        <h2 style="color: green;">Success</h2>
                        <p>Your current password is:</p>
                        <h1 style="background: #fff; border: 2px dashed #000; padding: 20px; display: inline-block;">
                            <%= retrievedPassword %>
                        </h1>
                        <p style="margin-top: 20px;"><em>(In a real production system, this would be emailed to <%= email %>)</em></p>
                        <br><br>
                        <a href="login.jsp" class="button">Proceed to Login</a>
                    </div>
                </div>
            </body>
            </html>
<%
        } else {
            // Failure: No match found
            session.setAttribute("resetMessage", "Error: Username and Email combination not found.");
            response.sendRedirect("forgotPassword.jsp");
        }

    } catch (Exception e) {
        // Handle database errors
        session.setAttribute("resetMessage", "System Error: " + e.getMessage());
        response.sendRedirect("forgotPassword.jsp");
    } finally {
        // Close resources
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }
%>