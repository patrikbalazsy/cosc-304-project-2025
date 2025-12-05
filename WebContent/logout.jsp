<%
    // Invalidate the whole session to fully log out
    session.invalidate();
    response.sendRedirect("home.jsp");
%>