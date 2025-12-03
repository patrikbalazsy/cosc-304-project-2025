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
    .order-card {
        border: 3px solid #000;
        margin-bottom: 40px;
        background: #fff;
        page-break-inside: avoid;
    }

    .order-header {
        background-color: #000;
        color: #fff;
        padding: 15px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .order-title {
        font-size: 1.2rem;
        font-weight: 900;
        text-transform: uppercase;
        margin: 0;
    }

    .order-meta {
        font-family: monospace;
        font-size: 1rem;
    }

    .order-body {
        padding: 20px;
    }

    /* Summary Section */
    .summary-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 20px;
        border-bottom: 2px dashed #000;
        padding-bottom: 20px;
    }

    .summary-item label {
        display: block;
        font-weight: 900;
        text-transform: uppercase;
        font-size: 0.8rem;
        color: #666;
    }

    .summary-item span {
        font-size: 1.1rem;
        font-weight: bold;
    }

    /* Product Table */
    .product-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }

    .product-table th {
        text-align: left;
        border-bottom: 3px solid #000;
        padding: 10px;
        text-transform: uppercase;
        font-weight: 900;
    }

    .product-table td {
        padding: 15px 10px;
        border-bottom: 1px solid #ccc;
        vertical-align: middle;
    }

    .total-row {
        text-align: right;
        font-size: 1.5rem;
        font-weight: 900;
        margin-top: 20px;
        text-transform: uppercase;
    }
    
    .return-btn {
        display: inline-block;
        border: 3px solid #000;
        padding: 10px 30px;
        color: #000;
        text-decoration: none;
        font-weight: 900;
        text-transform: uppercase;
        margin-top: 20px;
    }
    
    .return-btn:hover {
        background: #000;
        color: #fff;
    }
</style>
</head>
<body>

<div class="content-container">
    <h1 style="text-align: left; text-transform: uppercase; font-weight: 900; font-size: 2.5rem; margin-bottom: 30px;">Order History</h1>

    <%
    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("<div class='error'>ClassNotFoundException: " + e + "</div>");
    }

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {
        String query = "SELECT orderId, orderDate, totalAmount, ordersummary.customerId, firstName, lastName FROM ordersummary JOIN customer ON ordersummary.customerId = customer.customerId ORDER BY ordersummary.orderId DESC";
        
        try (Statement stmt = con.createStatement()) {
            ResultSet orders = stmt.executeQuery(query);

            while (orders.next()) {
                int orderId = orders.getInt("orderId");
                Date orderDate = orders.getDate("orderDate");
                double totalAmount = orders.getDouble("totalAmount");
                int customerId = orders.getInt("customerId");
                String firstName = orders.getString("firstName");
                String lastName = orders.getString("lastName");
    %>
                <div class="order-card">
                    <div class="order-header">
                        <h3 class="order-title">Order #<%= orderId %></h3>
                        <span class="order-meta"><%= orderDate %></span>
                    </div>
                    
                    <div class="order-body">
                        <div class="summary-grid">
                            <div class="summary-item">
                                <label>Customer Name</label>
                                <span><%= firstName %> <%= lastName %></span>
                            </div>
                            <div class="summary-item">
                                <label>Customer ID</label>
                                <span><%= customerId %></span>
                            </div>
                        </div>

                        <table class="product-table">
                            <thead>
                                <tr>
                                    <th style="width: 70%;">Product Item</th>
                                    <th style="width: 30%;">Preview</th>
                                </tr>
                            </thead>
                            <tbody>
    <%
                // Updated Query: Selects 'productImageURL' instead of 'productImage'
                String query2 = "SELECT productName, productImageURL FROM orderproduct JOIN product ON orderproduct.productId = product.productId WHERE orderId = ?";
                try (PreparedStatement pstmt = con.prepareStatement(query2)) {
                    pstmt.setInt(1, orderId);
                    try (ResultSet products = pstmt.executeQuery()) {
                        while (products.next()) {
                            String productName = products.getString("productName");
                            
                            // Updated Image Logic: Uses the URL string directly
                            String imageURL = products.getString("productImageURL");
                            String displayImage = "";
                            
                            if (imageURL != null && !imageURL.isEmpty()) {
                                displayImage = "<img src='" + imageURL + "' style='max-width: 100px; max-height: 100px; border: 1px solid #000;'>";
                            } else {
                                displayImage = "<span style='color:#999; font-size:0.8rem;'>No Preview</span>";
                            }
    %>
                                <tr>
                                    <td><strong><%= productName %></strong></td>
                                    <td><%= displayImage %></td>
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
    } catch (SQLException e) {
        out.println("<h3 style='color:red'>Error loading orders: " + e.getMessage() + "</h3>");
    }
    %>

    <div style="text-align: center; margin-bottom: 50px;">
        <a href="index.jsp" class="return-btn">Return to Home</a>
    </div>
</div>

</body>
</html>