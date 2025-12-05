<!DOCTYPE html>
<html>
<head>
<title>Login Screen</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body>

<div class="content-container">
    <div class="form-container">
        <h3 style="text-align: center;">Login</h3>

        <%
        String msg = (String) session.getAttribute("loginMessage");
        if (msg != null) {
            out.println("<div class='error-message'>" + msg + "</div>");
        }
        %>

        <form name="MyForm" method="post" action="validateLogin.jsp">
            <div class="search-label">Username:</div>
            <input type="text" name="username" required>
            
            <div class="search-label" style="margin-top: 15px;">Password:</div>
            <input type="password" name="password" required>

            <div style="margin-top: 20px; display: flex; gap: 10px;">
                <input type="submit" value="Log In">
                <input type="reset" value="Clear">
            </div>
        </form>

        <div style="margin-top: 20px; padding-top: 20px; border-top: 3px solid #000; text-align: center;">
            <p>New User? <a href="createUser.jsp" style="font-weight: 900; color: #000;">Create Account</a></p>
            <p><a href="forgotPassword.jsp" style="color: #666;">Forgot Password?</a></p>
            <br>
            <p><a href="home.jsp" style="font-weight: 900;font-size: 20px; color: #000;">Home</a></p>
        </div>
    </div>
</div>

</body>
</html>