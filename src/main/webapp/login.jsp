<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <!-- Bootstrap CSS -->
    <link href="./assets/bootstrap.min.css" rel="stylesheet">
    <link href="./assets/style.css" rel="stylesheet">
</head>
<body>
<div class="bg-image"></div>
<div class="login-container">
    <div class="login-card shadow">
        <div class="card-body">
            <h2 class="fw-bold mb-4" id="formTitle">Login</h2>
            <form id="loginForm">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" placeholder="Username">
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" placeholder="Password">
                </div>
                <button type="submit" class="btn btn-primary">Login</button>
            </form>
            <p class="text-muted small mt-3">
                Don't have an account? <a href="signup-login.jsp" class="text-decoration-underline" id="toggleButton">Sign
                Up</a>
            </p>
        </div>
    </div>
</div>

<script>
    document.getElementById('loginForm').addEventListener('submit', function (event) {
        event.preventDefault();
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value.trim();

        fetch('login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'username=' + encodeURIComponent(username) + '&password=' + encodeURIComponent(password)
        })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    window.location.href = 'Dashboard.jsp';
                } else if (data === 'admin') {
                    window.location.href = 'admin-dashboard.jsp';
                } else {
                    alert('Login failed. Please check your username and password.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Login failed. Please try again.');
            });
    });

    document.getElementById('signupForm').addEventListener('submit', function (event) {
        event.preventDefault();
        const username = document.getElementById('newUsername').value;
        const email = document.getElementById('email').value;
        const password = document.getElementById('newPassword').value;

        fetch('register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'username=' + encodeURIComponent(username) + '&email=' + encodeURIComponent(email) + '&password=' + encodeURIComponent(password)
        })
            .then(response => response.text())
            .then(data => {
                if (data === 'success') {
                    alert('Registration successful! Please login.');
                    // Switch to login form
                    document.getElementById('loginForm').style.display = 'block';
                    document.getElementById('signupForm').style.display = 'none';
                    document.getElementById('formTitle').textContent = 'Login';
                    document.getElementById('toggleButton').textContent = 'Sign Up';
                    isLogin = true;
                } else {
                    alert('Registration failed. Username may already exist.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Registration failed. Please try again.');
            });
    });

    var encodedValue = encodeURIComponent("some value here");
    console.log(encodedValue);
</script>

<!-- Bootstrap JS Bundle with Popper -->
<script src="./assets/bootstrap.bundle.min.js"></script>
</body>
</html>