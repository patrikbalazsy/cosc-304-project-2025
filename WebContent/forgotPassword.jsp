<!DOCTYPE html>
<html>
<head>
<title>Reset Password</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head>
<body style="text-align:center;">

    <div class="content-container">
        <h1>Account Recovery</h1>
        
        <%
        // Display error message if it exists in session
        String msg = (String) session.getAttribute("resetMessage");
        if (msg != null) {
            out.println("<div style='background-color:#ffe6e6; border:2px solid red; padding:10px; color:red; font-weight:bold; margin-bottom:20px;'>" + msg + "</div>");
            session.removeAttribute("resetMessage"); // Clear after showing
        }
        %>

        <div style="border: 3px solid #000; width: 50%; margin: 0 auto; padding: 40px; background:#fff;">
            <h3>Reset Password Protocol</h3>
            <p>Enter your username and the email associated with your account.</p>
            
            <form method="post" action="validateForgotPassword.jsp">
                <div style="text-align: left; margin-bottom: 20px;">
                    <label style="font-weight: 900; text-transform: uppercase;">Username:</label>
                    <input type="text" name="username" required style="width: 100%; padding: 10px; border: 3px solid #000; margin-top: 5px;">
                </div>
                
                <div style="text-align: left; margin-bottom: 20px;">
                    <label style="font-weight: 900; text-transform: uppercase;">Email Address:</label>
                    <input type="email" name="email" required style="width: 100%; padding: 10px; border: 3px solid #000; margin-top: 5px;">
                </div>
                
                <input type="submit" value="Retrieve Password" style="width: 100%; font-weight: 900; text-transform: uppercase; padding: 15px; background: #000; color: #fff; border: none; cursor: pointer;">
            </form>
            
            <br>
            <a href="login.jsp" style="color: #000; font-weight: bold; text-decoration: none;">Return to Login</a>
        </div>
    </div>

</body>
</html>