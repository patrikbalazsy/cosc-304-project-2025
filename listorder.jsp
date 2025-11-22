<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>67th Street Grocery Order List</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body style="text-align: center;">

<h1>Order List</h1><br>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " + e);
}

// Useful code for formatting currency values:
// out.println(currFormat.format(5.0));  // Prints $5.00
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

// Load orders db http://localhost/shop/loaddata.jsp *Already did once*

// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {

	// Write query to retrievea all order summary records
	String query = "SELECT orderId, orderDate, totalAmount, ordersummary.customerId, firstName, lastName FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId ORDER BY ordersummary.orderId Desc";

	try (Statement stmt = con.createStatement())
		{
			ResultSet orders = stmt.executeQuery(query);

			// For each order in the ResultSet
			while (orders.next()) {
				int orderId = orders.getInt("orderId");
				Date orderDate = orders.getDate("orderDate");
				double totalAmount = orders.getDouble("totalAmount");
				//String shiptoAddress = orders.getString("shiptoAddress");
				//String shiptoCity = orders.getString("shiptoCity");
				//String shiptoState = orders.getString("shiptoState");
				//String shiptoPostalCode = orders.getString("shiptoPostalCode");
				//String shiptoCountry = orders.getString("shiptoCountry");
				int customerId = orders.getInt("customerId");
				String firstName = orders.getString("firstName");
				String lastName = orders.getString("lastName");

				// Print out the order summary information
				out.println(
   					 "<table class='order-table'>" +
  					  "<tr><th colspan='2'>Order Summary</th></tr>" +
  					  "<tr><td>Order ID</td><td>" + orderId + "</td></tr>" +
   					 "<tr><td>Order Date</td><td>" + orderDate + "</td></tr>" +
   					 "<tr><td>Total Amount</td><td>" + currFormat.format(totalAmount) + "</td></tr>" +
    				"<tr><td>Customer ID</td><td>" + customerId + "</td></tr>" +
    				"<tr><td>Customer Name</td><td>" + firstName + " " + lastName + "</td></tr>" +
    				"</table>"
					 //"<tr><td>Address</td><td>" + shiptoAddress + "</td></tr>" +
  				     //"<tr><td>City</td><td>" + shiptoCity + "</td></tr>" +
    				 //"<tr><td>State</td><td>" + shiptoState + "</td></tr>" +
   					 //"<tr><td>Postal Code</td><td>" + shiptoPostalCode + "</td></tr>" +
    				 //"<tr><td>Country</td><td>" + shiptoCountry + "</td></tr>" +
				);

				// Write a query to retrieve the products in the order
				//   - Use a PreparedStatement as will repeat this query many times
				// For each product in the order
				// Write out product information 

				String query2 = "SELECT productName, productImage FROM orderproduct JOIN product ON orderproduct.productId = product.productId WHERE orderId = ?";
				try (PreparedStatement pstmt = con.prepareStatement(query2)) {
					pstmt.setInt(1, orderId);
					try (ResultSet products = pstmt.executeQuery()) {
						out.println("<table class='product-detail-table'>");
						out.println("<tr><th colspan='2'>Product Details</th></tr>");
						while (products.next()) {
                            String productName = products.getString("productName");
                            
							//Bonus: Print chai product image
                            // Get the blob data from productImage data
                            byte[] imgData = products.getBytes("productImage");
                            String chaiImage = "";
                            
                            if (imgData != null && productName.equals("Chai")) {

                                // Use Base64 encoder from Java util
                                String base64Image = java.util.Base64.getEncoder().encodeToString(imgData);
                                
                                // BLOB data header information with base64 embedded
                                chaiImage = "<img src='data:image/jpeg;base64," + base64Image + "' style='width: 478px; height: 478px;' alt=''>";
                            }

                            out.println("<tr><td>" + productName + "</td><td>Product</td></tr>");
                            
                            if (!chaiImage.isEmpty()) {
                                out.println("<tr><td>Mmm</td><td>" + chaiImage + "</td></tr>");
                            }
                        }
                        out.println("</table><br>");
					}
				}
			}

			// Close connection
			// The try and catch block will automatically close all connections when exited

		} 
		
	} catch (SQLException e) {
			out.println("SQLException " + e);
	}
%>
</body>
</html>