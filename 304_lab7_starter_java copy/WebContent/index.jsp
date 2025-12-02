<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cloud Eight</title>
    
    <style>
        
        body, html {
            height: 100%;
            margin: 0;
            padding: 0;
            font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
        }

        .hero-container {
            /* Use the specific file path provided */
            background-image: url('img/pexels_aleksandar_southbank_skatepark.jpg');
            height: 100%; 
            background-position: center;
            background-repeat: no-repeat;
            background-size: cover;
            
            /* Flexbox centers the button */
            display: flex;
            justify-content: center;
            align-items: center;
            
            /* This is crucial for positioning the footer text relative to this container */
            position: relative;
        }

        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.4); 
            z-index: 1;
        }

        .drop-in-btn {
            z-index: 2; 
            color: #ffffff;
            text-decoration: none;
            font-size: 2rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 4px; 
            padding: 20px 50px;
            border: 5px solid #ffffff; 
            background-color: transparent;
            transition: all 0.3s ease;
        }

        .drop-in-btn:hover {
            background-color: #ffffff;
            color: #000000;
            cursor: pointer;
        }

        .landing-footer {
            position: absolute; 
            bottom: 30px;       
            width: 100%;        
            text-align: center; 
            color: rgba(255, 255, 255, 0.8); 
            font-size: 0.75rem; 
            letter-spacing: 1px;
            z-index: 2;         /* Sits on top of overlay */
        }
    </style>
</head>
<body>

    <div class="hero-container">
        <div class="overlay"></div>
        
        <a href="home.jsp" class="drop-in-btn">Start Creating</a>

        <div class="landing-footer">
            Cloud Eight Spray Paint &copy; 2025 &nbsp;|&nbsp; Photo: CC license pexels aleksandar-pasaric "Southbank London"
        </div>
    </div>

</body>
</html>