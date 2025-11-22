<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>

<html>
<head>
<title>67th Street Grocery - Product Information</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<%//Image Styling %>
<style>
    .productImage {
        max-width: 300px;
        height: auto;
        border-radius: 10px;
        padding: 10px;
    }
</style>
<body>

<%@ include file="header.jsp" %>

<%

String productId = request.getParameter("id");

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

// Make the connection

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {

	//Filter by price instead of category
	String query = "SELECT productName, productPrice, productId, productImageURL, productDesc, productImage FROM product WHERE productId = ?";

	try (PreparedStatement stmt = con.prepareStatement(query)) {
		stmt.setString(1, productId);
		try (ResultSet product = stmt.executeQuery()) {
            if (product.next()) {
					String productName = product.getString("productName");
					double productPrice = product.getDouble("productPrice");
					int Id = product.getInt("productId");
                    String imgURL = product.getString("productImageURL");
                    String productDesc = product.getString("productDesc");
		
                    String link = "addcart.jsp?id=" + Id + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
        
                    out.println(
                        "<table border='1' style='background-color: greenyellow; width:50%; margin: auto;'>" +
                        "<tr><th colspan='2'>" + productName + "</th></tr>" +
                        "<tr><td align='center'><img src='" + product.getString("productImageURL") + "' alt='" + productName + "' class='productImage'></td>" +
                        "<td align='center'><img src='displayImage.jsp?id=" + Id + "' alt='Image from DB' class='productImage'></td></tr>" +
                        "<tr><td colspan='2'>" + productDesc + "</td></tr>" +
                        "<tr><td>Product ID</td><td>" + Id + "</td></tr>" +
                        "<tr><td>Product Price</td><td>" + currencyFormat.format(productPrice) + "</td></tr>" +
                        "<tr><td>Add to Cart:</td><td>" + "<a href='" + link + "'>Link</a>" + "</td></tr>" +
                        "<tr><td>Continue Shopping:</td><td>" + "<a href='index.jsp'>Link</a>" + "</td></tr>" +
                        "</table><br>"
                    );
            } else {
                out.println("<h2>Product not found.</h2>");
            }
	}
}   //Connection is closed with try and catch with resources
} catch (SQLException e) {
	out.println("SQLException " + e);
}

%>
</body>
</html>

