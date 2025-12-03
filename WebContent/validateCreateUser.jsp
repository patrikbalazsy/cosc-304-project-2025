<%@ page import="java.sql.*" %>
<%
    String u = request.getParameter("username");
    String p = request.getParameter("password");
    String fn = request.getParameter("firstName");
    String ln = request.getParameter("lastName");
    String em = request.getParameter("email");
    String ph = request.getParameter("phonenum");
    String ad = request.getParameter("address");
    String ci = request.getParameter("city");
    String st = request.getParameter("state");
    String pc = request.getParameter("postalCode");
    String co = request.getParameter("country");

    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    try {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        try (Connection con = DriverManager.getConnection(url, uid, pw)) {
            // Check if user exists
            String check = "SELECT userId FROM customer WHERE userId = ?";
            PreparedStatement psCheck = con.prepareStatement(check);
            psCheck.setString(1, u);
            ResultSet rs = psCheck.executeQuery();
            
            if(rs.next()) {
                session.setAttribute("loginMessage", "Username already taken.");
                response.sendRedirect("createUser.jsp");
            } else {
                String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userId, password) VALUES (?,?,?,?,?,?,?,?,?,?,?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, fn); ps.setString(2, ln); ps.setString(3, em);
                ps.setString(4, ph); ps.setString(5, ad); ps.setString(6, ci);
                ps.setString(7, st); ps.setString(8, pc); ps.setString(9, co);
                ps.setString(10, u); ps.setString(11, p);
                
                ps.executeUpdate();
                session.setAttribute("loginMessage", "Account created! Please Login.");
                response.sendRedirect("login.jsp");
            }
        }
    } catch (Exception e) {
        out.println("Error: " + e);
    }
%>