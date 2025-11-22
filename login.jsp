<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div class="login-card">
    <h3>Please Login to System</h3>

    <%
    // Print prior error login message if present
    if (session.getAttribute("loginMessage") != null)
        out.println("<p style='color:red'>" + session.getAttribute("loginMessage").toString() + "</p>");
    %>

    <form name="MyForm" method="post" action="validateLogin.jsp">
        
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" name="username" id="username" size="10" maxlength="10" placeholder="Enter Username">
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" name="password" id="password" size="10" maxlength="10" placeholder="Enter Password">
        </div>

        <input class="submit" type="submit" name="Submit2" value="Log In">
    </form>
</div>

</body>
</html>