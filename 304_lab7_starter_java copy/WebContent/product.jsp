<%-- product.jsp --%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>

<!DOCTYPE html>
<html>
<head>
    <title>Cloud Eight | Product Detail</title>
    <link rel="stylesheet" type="text/css" href="style.css?v=2">
    <style>
        .detail-container {
            display: flex;
            flex-wrap: wrap;
            gap: 50px;
            margin-top: 40px;
            border: 3px solid #000;
            padding: 40px;
            background: #fff;
        }
       .detail-image-col {
            flex: 1;
            min-width: 300px;
            border: 3px solid #000;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #e0e0e0; /* Off-white to match background */
            padding: 20px;
            height: 600px; 
        }
        .detail-image-col img {
            width: 100%;
            height: 100%;        /* Fill the container */
            object-fit: contain; 
            display: block;
        }
        .detail-info-col {
            flex: 1;
            min-width: 300px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .detail-title {
            font-size: 3.5rem;
            line-height: 1;
            margin: 0 0 20px 0;
            font-weight: 900;
            text-transform: uppercase;
        }
        .detail-desc {
            font-size: 1.1rem;
            color: #555;
            margin-bottom: 30px;
            line-height: 1.6;
            border-left: 4px solid #000;
            padding-left: 20px;
        }
        .detail-price {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 20px;
            color: #000;
        }
        .action-row {
            display: flex;
            gap: 20px;
        }
        .btn-large {
            padding: 20px 40px;
            font-size: 1.2rem;
            width: 100%;
            text-align: center;
            display: inline-block;
        }
        
    </style>
</head>
<body>

<%@ include file="header.jsp" %>

<div class="content-container">

<%
String productId = request.getParameter("id");
NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa";
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {

    String query = "SELECT productName, productPrice, productId, productImageURL, productDesc FROM product WHERE productId = ?";
    
    try (PreparedStatement stmt = con.prepareStatement(query)) {
        stmt.setString(1, productId);
        
        try (ResultSet product = stmt.executeQuery()) {
            if (product.next()) {
                String productName = product.getString("productName");
                double productPrice = product.getDouble("productPrice");
                int Id = product.getInt("productId");
                String productDesc = product.getString("productDesc");
                String imageURL = product.getString("productImageURL");

                if (imageURL == null || imageURL.isEmpty()) {
                    imageURL = "https://placehold.co/400x400/eeeeee/000000?text=No+Image";
                }
                
                String link = "addcart.jsp?id=" + Id + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
%>
                <div class="detail-container">
                    
                    <div class="detail-image-col">
                        <img src="<%= imageURL %>" alt="<%= productName %>">
                    </div>

                    <div class="detail-info-col">
                        <h1 class="detail-title"><%= productName %></h1>
                        <div class="detail-price"><%= currencyFormat.format(productPrice) %></div>
                        
                        <p class="detail-desc">
                            <%= productDesc != null ? productDesc : "No description available." %>
                        </p>
                        
                        <div class="action-row">
                            <a href="<%= link %>" class="button btn-large">Add to card</a>
                        </div>
                        <br>
                        <a href="home.jsp" style="text-decoration: underline; color: #666;">&larr; Back to shop</a>
                    </div>
                </div>
<%
            } else {
                out.println("<h2>Product not found.</h2>");
            }
        }
    }
} catch (SQLException e) {
    out.println("SQLException " + e);
}
%>
</div>
</body>
</html>