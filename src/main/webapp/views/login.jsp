<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login</title>
    <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: Arial, sans-serif;
            background-color: #000;
            overflow: hidden;
        }

        /* Background Image and Blur */
        .bg-image {
            background: url('${pageContext.request.contextPath}/images/tan.jpg') no-repeat center center fixed;
            background-size: cover;
            filter: blur; /* Proper blur */
            height: 100%;
            width: 100%;
            position: absolute;
            top: 0;
            left: 0;
            z-index: 0;
        }

        .overlay {
            background-color: rgba(0, 0, 51, 0.5);
            position: absolute;
            top: 0;
            left: 0;
            height: 100%;
            width: 100%;
            z-index: 1;
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .login-container {
            position: relative;
            z-index: 2;
            background: rgba(0, 0, 0, 0.4);
            padding: 30px;
            border-radius: 12px;
            width: 320px;
            margin: 120px auto;
            color: #fff;
            box-shadow: 0 0 25px rgba(255, 255, 255, 0.1);
            text-align: center;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            animation: fadeInUp 1s ease-out;
        }

        .login-container h2 {
            margin-bottom: 20px;
            animation: fadeInUp 1.2s ease-out;
        }

        .login-container input[type="text"],
        .login-container input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: none;
            border-radius: 6px;
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
            transition: background-color 0.3s, transform 0.2s;
            box-sizing: border-box;
        }

        .login-container input[type="text"]:focus,
        .login-container input[type="password"]:focus {
            background-color: rgba(255, 255, 255, 0.2);
            transform: scale(1.03);
            outline: none;
        }

        .login-container input[type="submit"] {
            width: 100%;
            padding: 12px;
            background-color: #004080;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s, transform 0.2s;
        }

        .login-container input[type="submit"]:hover {
            background-color: #0066cc;
            transform: translateY(-2px);
        }

        .error-message {
            color: #ff4d4d;
            margin-top: 12px;
            animation: fadeInUp 1.3s ease-out;
        }
    </style>
</head>
<body>
    <div class="bg-image"></div>
    <div class="overlay"></div>

    <div class="login-container">
        <h2>Login</h2>
        <form action="${pageContext.request.contextPath}/login" method="post">
            <input type="text" name="email" placeholder="Email" required><br>
            <input type="password" name="password" placeholder="Password" required><br>
            <input type="submit" value="Login">
        </form>
        <c:if test="${not empty error}">
            <p class="error-message">${error}</p>
        </c:if>
    </div>
</body>
</html>