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
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div class="login-card" style="max-width: 600px;">

<% 
// Get customer id
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// Validate if user ID is empty or cart is empty
if (custId == null || custId.trim().isEmpty() || productList == null || productList.isEmpty()) {
	out.println("<h2 style='color: #e74c3c;'>Error</h2>");
    out.println("<p>Invalid Customer ID or your Cart is empty.</p>");
	// Styled button
	out.println("<a href='index.jsp' class='button'>Return Home</a>");
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
        // Display verification quietly
		out.println("<p style='color: green; font-size: 0.9rem;'>Customer ID " + custId + " verified.</p>");
	} else {
		out.println("<h2 style='color: #e74c3c;'>Error</h2>");
        out.println("<p>Customer ID " + custId + " is not in the database.</p>");
        out.println("<a href='checkout.jsp' class='button'>Try Again</a>");
		return;
	}

	double totalAmount = 0.0;
	NumberFormat currency = NumberFormat.getCurrencyInstance();
	Date utilDate = new Date();
	java.sql.Timestamp sqlOrderDate = new java.sql.Timestamp(utilDate.getTime());

	// Save order information to database
	String orderQuery = "INSERT INTO ordersummary (customerId, totalAmount, orderDate) VALUES (?, ?, ?)";
	PreparedStatement stmtOrder = con.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);		
	stmtOrder.setString(1, custId);
	stmtOrder.setDouble(2, 0.0);
	stmtOrder.setTimestamp(3, sqlOrderDate);
	
	stmtOrder.executeUpdate();
	ResultSet keys = stmtOrder.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	
	// Insert each item into OrderProduct table
	String itemQuery = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
	PreparedStatement stmtItems = con.prepareStatement(itemQuery);		

	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        
        // FIXED BUG: Indexes were swapped in original file. 
        // Index 2 is Price (String), Index 3 is Quantity (Integer) based on addcart.jsp
		String priceStr = (String) product.get(2);
        double pr = Double.parseDouble(priceStr);
        int qty = ((Integer) product.get(3)).intValue();
			
		totalAmount += pr * qty;

		stmtItems.setInt(1, orderId);
		stmtItems.setString(2, productId);
		stmtItems.setInt(3, qty);
		stmtItems.setDouble(4, pr);

		stmtItems.addBatch();
	}

	stmtItems.executeBatch();

	//Finally update total amount
	String updateQuery = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
	PreparedStatement stmtUpdate = con.prepareStatement(updateQuery);
	stmtUpdate.setDouble(1, totalAmount);
	stmtUpdate.setInt(2, orderId);
	stmtUpdate.executeUpdate();

	// Print out order summary
    // Using the 'smooth' card look
	out.println("<h1 style='color: #27ae60;'>Order Placed!</h1>");
    out.println("<h3>Total: " + currency.format(totalAmount) + "</h3>");
    
    // Summary Table
    out.println("<table class='order-table' style='margin-top: 20px;'>");
    out.println("<tr><td>Order Reference ID</td><td>" + orderId + "</td></tr>");
    out.println("<tr><td>Customer ID</td><td>" + custId + "</td></tr>");
    out.println("<tr><td>Date</td><td>" + utilDate + "</td></tr>");
    out.println("</table>");

	// Clear cart
	session.removeAttribute("productList");
    
    out.println("<br><a href='index.jsp' class='button'>Return to Home</a>");

} catch (SQLException e){
	out.println("<h3 style='color:red'>Error Processing Order</h3>");
    out.println("<p>"+e+"</p>");
}
%>
</div> </body>
</html>