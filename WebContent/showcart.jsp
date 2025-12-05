<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<!DOCTYPE html>
<html>
<head>
<title>Your Shopping Cart</title>
<link rel="stylesheet" type="text/css" href="style.css">
<style>
    /* Industrial Cart Styles */
    .cart-container { border: 3px solid #000; padding: 40px; background: #fff; max-width: 1000px; margin: 0 auto; }
    .cart-header { font-size: 2rem; font-weight: 900; text-transform: uppercase; border-bottom: 3px solid #000; padding-bottom: 20px; margin-bottom: 20px; text-align: left; }
    .cart-table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
    .cart-table th { background-color: #000; color: #fff; text-align: left; padding: 15px; text-transform: uppercase; font-weight: 900; border: 3px solid #000; }
    .cart-table td { border: 3px solid #000; padding: 15px; font-size: 1.1rem; }
    .total-section { text-align: right; font-size: 1.5rem; font-weight: 900; text-transform: uppercase; margin-top: 20px; padding-top: 20px; border-top: 3px double #000; }
    
    .action-buttons { display: flex; justify-content: flex-end; gap: 20px; margin-top: 40px; }
    
    .btn { 
        padding: 15px 30px; 
        text-decoration: none; 
        text-transform: uppercase; 
        font-weight: 900; 
        border: 3px solid #000; 
        display: inline-block; 
        cursor: pointer; 
        transition: none; /* Removed transition to prevent flicker */
    }

    /* Primary Button (Black) */
    .btn-primary { background-color: #000; color: #fff; }
    .btn-primary:hover { background-color: #fff; color: #000; }

    /* Secondary Button (White) - FIXED HOVER STATE */
    .btn-secondary { 
        background-color: #ffffff; 
        color: #000000; 
    }
    
    .btn-secondary:hover { 
        background-color: #000000 !important; 
        color: #ffffff !important; /* Forces white text so it doesn't disappear */
    }
</style>
</head>
<body>

<div class="content-container">
<%
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
%>
        <div class="cart-container" style="text-align: center;">
            <h1 class="cart-header">Access Denied</h1>
            <p style="margin-bottom: 20px;">You must be logged in to view your cart.</p>
            <a href="login.jsp" class="btn btn-primary">Login</a>
            <a href="home.jsp" class="btn btn-primary">Home</a>
        </div>
<%
    } else {
        Object sessionCart = session.getAttribute("productList");
        HashMap<String, ArrayList<Object>> productList = null;

        if (sessionCart instanceof HashMap) {
            productList = (HashMap<String, ArrayList<Object>>) sessionCart;
        } else {
            productList = new HashMap<String, ArrayList<Object>>();
        }
%>
    <div class="cart-container">
        <h1 class="cart-header">Current Items In Your Cart (<%= userName %>)</h1>

        <%
            if (productList.isEmpty()) {
        %>
                <h3 style="text-align:center; padding: 50px;">System Status: Empty Load</h3>
                <div style="text-align:center;">
                    <a href="home.jsp" class="btn btn-secondary">Return to Catalog</a>
                </div>
        <%
            } else {
        %>
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th style="width: 10%;">ID</th>
                            <th style="width: 40%;">Product Name</th>
                            <th style="width: 15%;">Quantity</th>
                            <th style="width: 15%;">Price</th>
                            <th style="width: 20%;">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            double total = 0;
                            NumberFormat currFormat = NumberFormat.getCurrencyInstance();

                            Iterator<ArrayList<Object>> iterator = productList.values().iterator();
                            while (iterator.hasNext()) {
                                ArrayList<Object> product = (ArrayList<Object>) iterator.next();
                                String productId = (String) product.get(0);
                                String productName = (String) product.get(1);
                                String priceStr = (String) product.get(2);
                                int quantity = (Integer) product.get(3);
                                
                                double price = 0;
                                try { 
                                    // Safety clean
                                    String cleanPrice = priceStr.replaceAll("[^\\d.]", ""); 
                                    price = Double.parseDouble(cleanPrice); 
                                } catch (Exception e) {}
                                
                                double subtotal = price * quantity;
                                total += subtotal;
                        %>
                                <tr>
                                    <td><%= productId %></td>
                                    <td><%= productName %></td>
                                    <td style="text-align: center; font-weight:bold;"><%= quantity %></td>
                                    <td><%= currFormat.format(price) %></td>
                                    <td><%= currFormat.format(subtotal) %></td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>

                <div class="total-section">
                    Total Amount: <%= currFormat.format(total) %>
                </div>

                <div class="action-buttons">
                    <a href="home.jsp" class="btn btn-secondary">Continue Shopping</a>
                    <a href="checkout.jsp" class="btn btn-primary">Proceed to Checkout</a>
                </div>
        <%
            }
        %>
    </div>
<%
    } 
%>
</div>
</body>
</html>