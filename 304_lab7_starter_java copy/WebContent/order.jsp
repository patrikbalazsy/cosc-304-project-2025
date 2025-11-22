<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
<title>67th Street Grocery Order Processing</title>
</head>
<body style="text-align: center;">

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Determine if valid customer id was entered
// Determine if there are products in the shopping cart
// If either are not true, display an error message
// Also handles the incase custId is blank

// Validate if user ID is empty 

if (custId == null || custId.trim().isEmpty() || productList == null || productList.isEmpty()) {
	out.println("<h2>Error, wrong Customer ID or your Cart is empty</h2>");
	//Send back to the home page
	out.println("<a href='shop.html'>Go back.</a>");
	return;
}


// Make connection
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)){

	// Validate if user ID is in data base

	String validateQuery = "SELECT customerId from customer WHERE customerId = ?";

	PreparedStatement pstmt = con.prepareStatement(validateQuery);

	pstmt.setString(1, custId);
	ResultSet checkSet = pstmt.executeQuery();
	
	if(checkSet.next()){
		out.println("<h1>Customer ID " + custId + " verified.</h1>");
	} else {
		out.println("<h1>Error: Customer ID " + custId + " is not in the DB.</h1>");
		return;
	}

	// End of changes

	double totalAmount = 0.0;

	NumberFormat currency = NumberFormat.getCurrencyInstance();

	Date utilDate = new Date(); 
    java.sql.Timestamp sqlOrderDate = new java.sql.Timestamp(utilDate.getTime());

	// Save order information to database

	String orderQuery = "INSERT INTO ordersummary (customerId, totalAmount, orderDate) VALUES (?, ?, ?)";

	// Use retrieval of auto-generated keys.
	PreparedStatement stmtOrder = con.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);		
	stmtOrder.setString(1, custId);
	stmtOrder.setDouble(2, 0.0);
	stmtOrder.setTimestamp(3, sqlOrderDate);
	
	stmtOrder.executeUpdate();
	ResultSet keys = stmtOrder.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	
	// Insert each item into OrderProduct table using OrderId from previous INSERT

	String itemQuery = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
	PreparedStatement stmtItems = con.prepareStatement(itemQuery);		

	// Here is the code to traverse through a HashMap
	// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = String.valueOf(product.get(3));
		double pr = Double.parseDouble(price);
		int qty = (int) Double.parseDouble(String.valueOf(product.get(2)));
			
		totalAmount += pr * qty;

		stmtItems.setInt(1, orderId);
		stmtItems.setString(2, productId);
		stmtItems.setInt(3, qty);
		stmtItems.setDouble(4, pr);

		stmtItems.addBatch();
	}

	stmtItems.executeBatch();

	//Finally update total amount into the data
	String updateQuery = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
	PreparedStatement stmtUpdate = con.prepareStatement(updateQuery);
	stmtUpdate.setDouble(1, totalAmount);
	stmtUpdate.setInt(2, orderId);
	stmtUpdate.executeUpdate();

	// Print out order summary
	out.println("<h1>Order Placed! Total amount is " + currency.format(totalAmount) + "</h1>");
	out.println("<p>Thank you, here are your details: Customer ID: " + custId + ", Order ID: " + orderId + "</p>");

	// Clear cart if order placed successfully
	session.removeAttribute("productList");

} catch (SQLException e){
	out.println("SQLException " + e);
}
%>
</BODY>
</HTML>

