<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Cloud Eight Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
    String orderIdParam = request.getParameter("orderId");
    int orderId = -1; 
    
    if (orderIdParam == null || orderIdParam.trim().isEmpty()) {
        out.println("<h2>No Order ID provided.</h2>");
        return;
    }

    try {
        orderId = Integer.parseInt(orderIdParam);
    } catch (Exception e) {
        out.println("<h2>Invalid Order ID.</h2>");
        return;
    }

    try{
        getConnection();
        con.setAutoCommit(false);
        Statement stmt = con.createStatement();

        String sql = "SELECT COUNT(*) FROM orderproduct op LEFT JOIN productinventory pi ON op.productId = pi.productId AND pi.warehouseId = 1 WHERE op.orderId = " + orderId + " AND (pi.quantity < op.quantity OR pi.quantity IS NULL)";
        
        ResultSet rs = stmt.executeQuery(sql);
        rs.next();
        int noStock = rs.getInt(1);
        rs.close();
        
        boolean sufficientStock = (noStock == 0);
    
        if (sufficientStock) 
        {
            String shipDate = new java.sql.Timestamp(new Date().getTime()).toString();
            String shipDesc = "Shipment for Order ID: " + orderId;
            String sql2 = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES ('" + shipDate + "', '" + shipDesc + "', 1)";
            stmt.executeUpdate(sql2);
            
            String sql3 = "SELECT productId, quantity FROM orderproduct WHERE orderId = " + orderId;
            ResultSet rsItems = stmt.executeQuery(sql3);
            
            while (rsItems.next()) {
                int productId = rsItems.getInt("productId");
                int quantity = rsItems.getInt("quantity");
				out.println("<h2>" + productId + "</h2>");
				out.println("<h2>" + quantity + "</h2>");

                
                String sqlUpdateInv = "UPDATE productinventory SET quantity = quantity - " + quantity + " WHERE productId = " + productId + " AND warehouseId = 1";
                stmt.executeUpdate(sqlUpdateInv);
            }
            rsItems.close();
            
            con.commit();
            out.println("<h2>Shipment Succesfully Processed</h2>");
        } 
        else 
        {
            out.println("<h2>Insufficient stock.</h2>");
            con.rollback();
        }
        
        stmt.close();

    } 
    catch (SQLException ex) {
        if (con != null) con.rollback(); 
    } 
    finally 
    {
        if (con != null) {
            con.setAutoCommit(true);
            closeConnection();
        }
    }
%>                                      

<p><a href="home.jsp">Back to Home</a></p>

</body>
</html>