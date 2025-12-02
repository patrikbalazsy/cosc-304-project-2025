<!DOCTYPE html>
<html>
<head>
<title>Create Account</title>
<link rel="stylesheet" type="text/css" href="style.css">
<script>
function validate() {
    var p1 = document.forms["reg"]["password"].value;
    var p2 = document.forms["reg"]["repass"].value;
    if(p1 != p2) {
        alert("Passwords do not match!");
        return false;
    }
    return true;
}
</script>
<style>
    /* Specific styles to match the mockup image layout */
    .form-container {
        border: 3px solid #000;
        padding: 40px;
        max-width: 700px;
        margin: 0 auto;
        background: #fff;
    }

    h1 {
        text-align: left;
        margin-left: 0;
        margin-bottom: 20px;
        font-size: 2rem;
        font-weight: 900;
        text-transform: uppercase;
    }

    h3 {
        margin-top: 30px;
        margin-bottom: 10px;
        font-size: 1.1rem;
        font-weight: 800;
        text-transform: uppercase;
    }

    /* Row layout for side-by-side inputs */
    .input-row {
        display: flex;
        gap: 20px;
        margin-bottom: 15px;
    }

    /* Full width inputs */
    .input-full {
        width: 100%;
        margin-bottom: 15px;
        box-sizing: border-box; 
    }

    .input-row input {
        flex: 1;
        width: 100%; 
    }
    
    input[type="text"], input[type="password"], input[type="email"] {
        border: 3px solid #000;
        padding: 15px;
        font-size: 1rem;
        border-radius: 0;
        outline: none;
    }

    /* Primary Action Button */
    input[type="submit"] {
        width: 100%;
        margin-top: 30px;
        font-size: 1.2rem;
        font-weight: 900;
        text-transform: uppercase;
        background-color: #000; /* Black background for emphasis */
        color: #fff;
        border: 3px solid #000;
    }
    
    input[type="submit"]:hover {
        background-color: #fff;
        color: #000;
    }

    /* Return Button Styling */
    .return-btn {
        display: block;
        width: 100%;
        max-width: 700px; /* Match form width */
        margin: 20px auto 0; /* Center it */
        padding: 15px;
        text-align: center;
        border: 3px solid #000;
        background-color: #fff;
        color: #000;
        font-weight: 900;
        text-decoration: none;
        text-transform: uppercase;
        font-size: 1rem;
        box-sizing: border-box;
    }

    .return-btn:hover {
        background-color: #e0e0e0;
    }
</style>
</head>
<body>

    <div class="content-container">
        <h1>Initialize User Protocol</h1>
        
        <div class="form-container">
            <form name="reg" method="post" action="validateCreateUser.jsp" onsubmit="return validate()">
                
                <h3>Account Credentials</h3>
                <input class="input-full" type="text" name="username" placeholder="Username (Required)" required>
                <input class="input-full" type="password" name="password" placeholder="Password (Required)" required>
                <input class="input-full" type="password" name="repass" placeholder="Repeat Password" required>
                
                <h3>Personal Data</h3>
                
                <div class="input-row">
                    <input type="text" name="firstName" placeholder="First Name" required>
                    <input type="text" name="lastName" placeholder="Last Name" required>
                </div>

                <input class="input-full" type="email" name="email" placeholder="Email Address" required>

                <div class="input-row">
                    <input type="text" name="phonenum" placeholder="Phone Number">
                    <input type="text" name="address" placeholder="Address" required>
                </div>

                <div class="input-row">
                    <input type="text" name="city" placeholder="City" required>
                    <input type="text" name="state" placeholder="State" required>
                </div>

                <div class="input-row">
                    <input type="text" name="postalCode" placeholder="Postal Code" required>
                    <input type="text" name="country" placeholder="Country" required>
                </div>
                
                <input type="submit" value="Register User">
            </form>
        </div>
        
        <a href="login.jsp" class="return-btn">Return to Login</a>
    </div>

</body>
</html>