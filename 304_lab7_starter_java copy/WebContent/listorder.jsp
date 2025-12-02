<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Order History</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style>
    /* Industrial Order List Styles */
    .order-card { border: 3px solid #000; margin-bottom: 40px; background: #fff; }
    .order-header { background-color: #000; color: #fff; padding: 15px; display: flex; justify-content: space-between; font-weight: 900; text-transform: uppercase; }
    .order-body { padding: 20px; }
    .product-table { width: 100%; border-collapse: collapse; margin-top: 15px; }
    .product-table th { border-bottom: 3px solid #000; text-align: left; padding: 10px; font-weight: 900; text-transform: uppercase; }
    .product-table td { border-bottom: 1px solid #ccc; padding: 10px; vertical-align: middle; }
    .total-row { text-align: right; font-size: 1.5rem; font-weight: 900; margin-top: 20px; text-transform: uppercase; }
    .btn { border: 3px solid #000; padding: 10px 20px; text-decoration: none; font-weight: 900; text-transform: uppercase; color: #000; display: inline-block; }
    .btn:hover { background: #000; color: #fff; }
</style>
</head>
<body>

<div class="content-container">
    <h1 style="text-align: left; text-transform: uppercase; font-weight: 900; font-size: 2.5rem; margin-bottom: 30px;">Order History</h1>

    <%
    // This is likely where your 'Duplicate local variable' error came from 
    // when you pasted this file into listprod.jsp.
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            
            String query = "SELECT orderId, orderDate, totalAmount FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId WHERE customer.userId = ? ORDER BY ordersummary.orderId DESC";
            
            try (PreparedStatement stmt = con.prepareStatement(query)) {
                stmt.setString(1, userName);
                ResultSet orders = stmt.executeQuery();

                while (orders.next()) {
                    int orderId = orders.getInt("orderId");
                    Date orderDate = orders.getDate("orderDate");
                    double totalAmount = orders.getDouble("totalAmount");
    %>
                <div class="order-card">
                    <div class="order-header">
                        <span>Order #<%= orderId %></span>
                        <span><%= orderDate %></span>
                    </div>
                    
                    <div class="order-body">
                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th style="width: 10%;">ID</th>
                                    <th style="width: 50%;">Product</th>
                                    <th style="width: 10%;">Qty</th>
                                    <th style="width: 15%;">Price</th>
                                    <th style="width: 15%;">Subtotal</th>
                                </tr>
                            </thead>
                            <tbody>
    <%
                // Updated Query to get Quantity and Price
                String query2 = "SELECT op.productId, op.quantity, op.price, p.productName FROM orderproduct op JOIN product p ON op.productId = p.productId WHERE orderId = ?";
                try (PreparedStatement pstmt = con.prepareStatement(query2)) {
                    pstmt.setInt(1, orderId);
                    try (ResultSet products = pstmt.executeQuery()) {
                        while (products.next()) {
                            int pid = products.getInt("productId");
                            String pName = products.getString("productName");
                            int qty = products.getInt("quantity");
                            double price = products.getDouble("price");
                            double sub = price * qty;
    %>
                                <tr>
                                    <td><%= pid %></td>
                                    <td><strong><%= pName %></strong></td>
                                    <td><%= qty %></td>
                                    <td><%= currFormat.format(price) %></td>
                                    <td><%= currFormat.format(sub) %></td>
                                </tr>
    <%
                        }
                    }
                }
    %>
                            </tbody>
                        </table>
                        <div class="total-row">
                            Total: <%= currFormat.format(totalAmount) %>
                        </div>
                    </div>
                </div>
    <%
                }
            }
        }
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
    %>
    <div style="text-align: center; margin-bottom: 50px;">
        <a href="index.jsp" class="btn">Return to Home</a>
    </div>
</div>
</body>
</html>