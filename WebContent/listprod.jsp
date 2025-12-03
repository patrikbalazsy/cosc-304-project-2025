<%-- listprod.jsp --%>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<div class="product-listing-container">

    <form method="get" action="home.jsp" class="search-form">
        <label for="productSearch" class="search-label">
            Shop Inventory
        </label>
        <div class="search-input-group">
            <input type="text" name="productName" id="productSearch" class="text-input" placeholder="Browse by color or finish..." value="<%= request.getParameter("productName") != null ? request.getParameter("productName") : "" %>">
            <input type="submit" value="SEARCH">
            <input type="reset" value="CLEAR" onclick="window.location.href='home.jsp'">
        </div>
    </form>

<% 
    String name = request.getParameter("productName");
    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();
            
    try {   
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("<p class=\"error-message\">ClassNotFoundException: " +e + "</p>");
    }

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try (Connection con = DriverManager.getConnection(url, uid, pw)) {

        String sql = "SELECT productName, productPrice, productId, productImageURL FROM product";
        
        // Set to price from lowest to highest first
        sql += " ORDER BY productPrice ASC";

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            
            if (name != null && !name.isEmpty()) {
                stmt.setString(1, "%" + name + "%");
            }

            try (ResultSet product = stmt.executeQuery()) {
                
                out.println("<div class=\"product-grid\">"); 

                boolean hasResults = false;
                while (product.next()) {
                    hasResults = true;
                    String productName = product.getString("productName");
                    double productPrice = product.getDouble("productPrice");
                    int productId = product.getInt("productId");
                    // Retrieve image URL from DB
                    String imageURL = product.getString("productImageURL");
                    String addCartLink = "addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + productPrice;
                    String detailLink = "product.jsp?id=" + productId;

                    out.println("<div class='product-card'>");
                    
                        out.println("<a href='" + detailLink + "' class='product-link'>");
                            
                            // UPDATE: Using Real Image Tag
                            out.println("<div class='product-image-wrapper'>");
                                out.println("<img src='" + imageURL + "' alt='" + productName + "' class='product-img-real'>");
                            out.println("</div>");
                            
                            out.println("<div class='product-info-block'>");
                                out.println("<div>"); 
                                    out.println("<h3 class='product-name'>" + productName + "</h3>");
                                    out.println("<div class='product-meta'>ITEM #" + productId + " // STOCK</div>");
                                out.println("</div>");
                                
                                out.println("<div class='product-actions'>");
                                    out.println("<span class='product-price'>" + currencyFormat.format(productPrice) + "</span>");
                                    out.println("<object><a href='" + addCartLink + "' class='button add-to-cart'>Add to cart</a></object>"); 
                                out.println("</div>");
                            out.println("</div>");
                        out.println("</a>");
                        
                    out.println("</div>"); 
                }
                out.println("</div>"); 

                if (!hasResults) {
                     out.println("<h3 class=\"no-products\">No inventory found.</h3>");
                }
            }
        }
    } catch (SQLException e) {
        out.println("<p class=\"error-message\">Database Error: " + e.getMessage() + "</p>");
    }
%>
</div>