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
<title>Order Processing</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style>
    /* Industrial Order Confirmation Styles */
    .confirm-container {
        border: 3px solid #000;
        padding: 40px;
        background: #fff;
        max-width: 600px;
        margin: 0 auto;
        text-align: center;
    }
    .confirm-title {
        text-transform: uppercase;
        font-weight: 900;
        font-size: 2rem;
        margin-bottom: 20px;
    }
    .confirm-details {
        text-align: left;
        margin: 20px 0;
        border-top: 2px dashed #000;
        border-bottom: 2px dashed #000;
        padding: 20px 0;
    }
    .detail-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 10px;
        font-size: 1.1rem;
    }
    .label { font-weight: 900; text-transform: uppercase; }
    
    .btn {
        display: block;
        width: 100%;
        padding: 15px;
        margin-top: 10px;
        border: 3px solid #000;
        text-decoration: none;
        text-transform: uppercase;
        font-weight: 900;
        box-sizing: border-box;
    }
    .btn-primary { background: #000; color: #fff; }
    .btn-secondary { background: #fff; color: #000; }
    .btn:hover { opacity: 0.8; }
</style>
</head>
<body>

<div class="content-container">

<% 
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (custId == null || custId.trim().isEmpty() || productList == null || productList.isEmpty()) {
%>
    <div class="confirm-container">
        <h2 class="confirm-title" style="color:red;">Error</h2>
        <p>Invalid Customer ID or Empty Cart.</p>
        <a href="index.jsp" class="btn btn-secondary">Return Home</a>
    </div>
<%
    return;
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)){

    String validateQuery = "SELECT customerId, firstName, lastName from customer WHERE customerId = ?";
    PreparedStatement pstmt = con.prepareStatement(validateQuery);
    pstmt.setString(1, custId);
    ResultSet checkSet = pstmt.executeQuery();
    
    String customerName = "";
    
    if(checkSet.next()){
        customerName = checkSet.getString("firstName") + " " + checkSet.getString("lastName");
    } else {
%>
        <div class="confirm-container">
            <h2 class="confirm-title" style="color:red;">Invalid ID</h2>
            <p>Customer ID <%= custId %> not found.</p>
            <a href="checkout.jsp" class="btn btn-secondary">Try Again</a>
        </div>
<%
        return;
    }

    double totalAmount = 0.0;
    NumberFormat currency = NumberFormat.getCurrencyInstance();
    
    String orderQuery = "INSERT INTO ordersummary (customerId, totalAmount, orderDate) VALUES (?, ?, GETDATE())";
    PreparedStatement stmtOrder = con.prepareStatement(orderQuery, Statement.RETURN_GENERATED_KEYS);       
    stmtOrder.setString(1, custId);
    stmtOrder.setDouble(2, 0.0);
    
    stmtOrder.executeUpdate();
    ResultSet keys = stmtOrder.getGeneratedKeys();
    keys.next();
    int orderId = keys.getInt(1);
    
    String itemQuery = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?, ?, ?, ?)";
    PreparedStatement stmtItems = con.prepareStatement(itemQuery);        

    Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
    while (iterator.hasNext()) { 
        Map.Entry<String, ArrayList<Object>> entry = iterator.next();
        ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
        
        String productId = (String) product.get(0);
        String priceStr = (String) product.get(2);
        int qty = ((Integer) product.get(3)).intValue();
        
        // CRITICAL FIX: This removes '$' or ',' so the loop doesn't crash!
        if (priceStr != null) {
            priceStr = priceStr.replaceAll("[^\\d.]", "");
        }
        
        double pr = 0.0;
        try {
            pr = Double.parseDouble(priceStr);
        } catch (NumberFormatException e) {
            pr = 0.0; // Prevent crash if price is still bad
        }
            
        totalAmount += pr * qty;

        stmtItems.setInt(1, orderId);
        stmtItems.setString(2, productId);
        stmtItems.setInt(3, qty);
        stmtItems.setDouble(4, pr);

        stmtItems.addBatch();
    }

    stmtItems.executeBatch();

    String updateQuery = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
    PreparedStatement stmtUpdate = con.prepareStatement(updateQuery);
    stmtUpdate.setDouble(1, totalAmount);
    stmtUpdate.setInt(2, orderId);
    stmtUpdate.executeUpdate();

    session.removeAttribute("productList");

%>
    <div class="confirm-container">
        <h1 class="confirm-title" style="color: green;">Order Confirmed</h1>
        
        <div class="confirm-details">
            <div class="detail-row">
                <span class="label">Order Ref:</span>
                <span>#<%= orderId %></span>
            </div>
            <div class="detail-row">
                <span class="label">Customer:</span>
                <span><%= customerName %> (ID: <%= custId %>)</span>
            </div>
            <div class="detail-row">
                <span class="label">Total Paid:</span>
                <span style="font-size: 1.5rem; font-weight: bold;"><%= currency.format(totalAmount) %></span>
            </div>
        </div>

        <p style="margin-bottom: 20px;">Your products are being processed for shipment.</p>

        <a href="listorder.jsp" class="btn btn-primary">View Order History</a>
        <a href="index.jsp" class="btn btn-secondary">Return to Catalog</a>
    </div>
<%

} catch (SQLException e){
%>
    <div class="confirm-container">
        <h3 style="color:red">Processing Error</h3>
        <p><%= e.getMessage() %></p>
        <a href="index.jsp" class="btn btn-secondary">Return Home</a>
    </div>
<%
}
%>
</div> 
</body>
</html>