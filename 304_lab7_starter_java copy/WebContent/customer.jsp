<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>


<%
	String userName = (String) session.getAttribute("authenticatedUser");

	out.println("<h2>Customer Profile</h2>");


	// TODO: Print Customer information
	String sql = "SELECT * FROM customer WHERE userid = ?";

	try 
    {
        getConnection(); 

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            
            stmt.setString(1, userName); 
            
            try (ResultSet rs = stmt.executeQuery()) {
                
               if (rs.next()) {
                    // Retrieve all customer data
                    String firstName = rs.getString("firstName");
                    String lastName = rs.getString("lastName");
                    String email = rs.getString("email");
                    String phonenum = rs.getString("phonenum");
                    String address = rs.getString("address");
                    String city = rs.getString("city");
                    String state = rs.getString("state");
                    String postalCode = rs.getString("postalCode");
                    String country = rs.getString("country");
                    String userid = rs.getString("userid");
                    int customerId = rs.getInt("customerId");

                    // Display the information in a simple table
                    out.println("<table border='1'>");
                    out.println("<tr><td>Customer id:</td><td>" + customerId + "</td></tr>");
                    out.println("<tr><td>User id:</td><td>" + userid + "</td></tr>");
                    out.println("<tr><td>Name:</td><td>" + firstName + " " + lastName + "</td></tr>");
                    out.println("<tr><td>Email:</td><td>"+ email + "</td></tr>");
                    out.println("<tr><td>Phone Number:</td><td>" + phonenum + "</td></tr>");
                    out.println("<tr><td>Address:</td><td>" + address + "</td></tr>");
                    out.println("<tr><td>City:</td><td>" + city + "</td></tr>");
                    out.println("<tr><td>State:</td><td>" + state + "</td></tr>");
                    out.println("<tr><td>Postal Code:</td><td>" + postalCode + "</td></tr>");
                    out.println("<tr><td>Country:</td><td>" + country + "</td></tr>");
                    out.println("</table>");
                } else {
                    out.println("<h2 >Error: Customer not found.</h2>");
                }
            }
        }
    } 
    catch (SQLException e) {
        out.println("SQLException: " + e.getMessage());
    } 
    finally {
        closeConnection();
    }
%>

<p><a href="index.jsp">Back to Home</a></p>

</body>
</html>

