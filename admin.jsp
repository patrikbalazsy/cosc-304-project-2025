<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat" %>

<h2>Admin Sales Report by Day</h2>

<%
    String sql = "SELECT YEAR(orderDate) AS year, MONTH(orderDate) AS month, DAY(orderDate) AS day, SUM(totalAmount) AS totalAmount " +
                 "FROM orderSummary " +
                 "GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate) " +
                 "ORDER BY year DESC, month DESC, day DESC";

    // Connect to the databasee

    NumberFormat currencyFormat = NumberFormat.getCurrencyInstance();

    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
    } catch (java.lang.ClassNotFoundException e) {
        out.println("ClassNotFoundException: " + e);
    }

    out.println("<table border='1'>");
    out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");

    try (Connection con = DriverManager.getConnection(url, uid, pw);
         Statement stmt = con.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {

        while (rs.next()) {
            String date = rs.getInt("year") + "-" + rs.getInt("month") + "-" + rs.getInt("day");
            double total = rs.getDouble("totalAmount");
            
            out.println("<tr>");
            out.println("<td style='padding: 10px;'>" + date + "</td>");
            out.println("<td style='padding: 10px;'>" + currencyFormat.format(total) + "</td>");
            out.println("</tr>");
        }

    } catch (SQLException e) {
        out.println("SQLException: " + e);
    }
    
    out.println("</table>");
%>

<p><a href="index.jsp">Home</a></p>

</body>
</html>

