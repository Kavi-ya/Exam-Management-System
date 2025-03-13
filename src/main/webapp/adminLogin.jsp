<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login</title>
    <!-- Bootstrap CSS -->
    <link href="./assets/bootstrap.min.css" rel="stylesheet">
    <link href="./assets/style.css" rel="stylesheet">
    <style>
        .admin-login-container {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }

        .admin-login-card {
            width: 100%;
            max-width: 400px;
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .bg-image {
            background-image: url('https://picsum.photos/2000/1000');
            background-size: cover;
            background-position: center;
            height: 100vh;
            width: 100%;
            position: absolute;
            filter: blur(4px);
            -webkit-filter: blur(4px);
        }

        .admin-header {
            color: #343a40;
            text-align: center;
            margin-bottom: 25px;
        }

        .error-message {
            color: #dc3545;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
<div class="admin-bg-image"></div>
<div class="admin-login-container">
    <div class="admin-login-card shadow">
        <div class="card-body p-4">
            <h2 class="admin-header fw-bold">Administrator Login</h2>

            <% if(request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
            <% } %>

            <form id="adminLoginForm" action="adminLogin" method="post">
                <div class="mb-3">
                    <label for="username" class="form-label">Admin Username</label>
                    <input type="text" class="form-control" id="username" name="username" placeholder="Username"
                           required>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Admin Password</label>
                    <input type="password" class="form-control" id="password" name="password"
                           placeholder="Password" required>
                </div>
                <div class="d-grid">
                    <button type="submit" class="btn btn-primary">Login as Administrator</button>
                </div>
            </form>
            <p class="text-muted small mt-3 text-center">
                <a href="login.jsp" class="text-decoration-underline">Return to User Login</a>
            </p>
            <%
                String errorMessage = (String) request.getAttribute("errorMessage");
                if (errorMessage != null && !errorMessage.isEmpty()) {
            %>
            <p style="color: red;"><%= errorMessage %>
            </p>
            <%
                }
            %>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="./assets/bootstrap.bundle.min.js"></script>
</body>
</html>