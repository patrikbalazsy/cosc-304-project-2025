<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>67th Street Grocery</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body style="text-align: center;">

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% // Get product name to search for
String name = request.getParameter("productName");
//Add %% to name
name = "%" + name + "%";

NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Variable name now contains the search string the user entered
// Use it to build a query and print out the resultset.  Make sure to use PreparedStatement!

// Make the connection

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {

	//Filter by price instead of category
	String query = "SELECT productName, productPrice, productId FROM product WHERE productName LIKE ? ORDER BY productPrice Asc";

	//Allow for scrolling to track number of rows to print number of items
	try (PreparedStatement stmt = con.prepareStatement(query, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
		stmt.setString(1, name);
		try (ResultSet product = stmt.executeQuery()) {

			//Get the item count by scrolling
			product.last();
			int count = product.getRow();
			product.beforeFirst();

			if (count > 0) {

				out.println("<h2>" + count + " Products Found:</h2>");
		
				while (product.next()) {
					String productName = product.getString("productName");
					double productPrice = product.getDouble("productPrice");
					int productId = product.getInt("productId");

					String link = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
		
					// Print out the ResultSet
					// For each product create a link of the form
					// addcart.jsp?id=productId&name=productName&price=productPrice
					out.println(
						"<table class='product-table'>" +
   						"<tr><th colspan='2'><a href='product.jsp?id=" + productId + "'>" + productName + "</a></th></tr>" +
   						"<tr><td>Product Name</td><td>" + productName + "</td></tr>" +
    					"<tr><td>Product Price</td><td>" + currencyFormat.format(productPrice) + "</td></tr>" +
    					"<tr><td>Action</td><td><a href='" + link + "' class='button'>Add to Cart</a></td></tr>" +
  	  					"</table>"
					);
				}
			} else {
				out.println("<h3>404 no products found, try a search!</h3>");
			}
		}
	}
	//Connection is closed with try and catch with resources
} catch (SQLException e) {
	out.println("SQLException " + e);
}
%>
</body>
</html>