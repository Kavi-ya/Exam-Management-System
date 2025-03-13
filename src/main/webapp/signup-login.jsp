<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login/Signup Page</title>
    <!-- Bootstrap CSS -->
    <link href="./assets/bootstrap.min.css" rel="stylesheet">
    <link href="./assets/style.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="card">
        <div class="card-header">
            <h2 class="card-title" id="formTitle">Login</h2>
        </div>
        <div class="card-body">
            <!-- Login Form -->
            <form id="loginForm">
                <div class="mb-3">
                    <label for="username" class="form-label">Username</label>
                    <input type="text" class="form-control" id="username" placeholder="Enter username">
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" id="password" placeholder="Enter password">
                </div>
                <button type="submit" class="btn btn-primary">Login</button>
            </form>

            <!-- Sign Up Form (Hidden by default) -->
            <form id="signupForm" style="display: none;" action="register" method="post">
                <div class="mb-3">
                    <label for="newUsername" class="form-label">Username</label>
                    <input type="text" class="form-control" id="newUsername" placeholder="Choose username">
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" id="email" placeholder="Enter email">
                </div>
                <div class="mb-3">
                    <label for="newPassword" class="form-label">Password</label>
                    <input type="password" class="form-control" id="newPassword" placeholder="Choose password">
                </div>
                <button type="submit" class="btn btn-primary">Sign Up</button>
            </form>
        </div>
        <div class="card-footer d-flex justify-content-between align-items-center">
            <p class="text-muted small mt-3">
                Don't have an account?
                <button id="toggleForm" class="btn btn-outline-secondary">Sign Up</button>
            </p>
            <p class="text-muted small mt-3">
                <a href="adminLogin.jsp">Admin Login</a>
            </p>
        </div>
    </div>
</div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="./assets/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const loginForm = document.getElementById('loginForm');
        const signupForm = document.getElementById('signupForm');
        const formTitle = document.getElementById('formTitle');
        const toggleButton = document.getElementById('toggleForm');
        let isLogin = true;

        // Toggle between login and signup forms
        toggleButton.addEventListener('click', function () {
            isLogin = !isLogin;

            if (isLogin) {
                loginForm.style.display = 'block';
                signupForm.style.display = 'none';
                formTitle.textContent = 'Login';
                toggleButton.textContent = 'Sign Up';
            } else {
                loginForm.style.display = 'none';
                signupForm.style.display = 'block';
                formTitle.textContent = 'Sign Up';
                toggleButton.textContent = 'Login';
            }

            // Apply animation effect on toggle
            const card = document.querySelector('.card');
            card.style.animation = 'none';
            setTimeout(() => {
                card.style.animation = 'fadeIn 0.5s ease-in-out';
            }, 10);
        });

        // Handle login form submission
        loginForm.addEventListener('submit', function (event) {
            event.preventDefault();
            const username = document.getElementById('username').value;
            const password = document.getElementById('password').value;

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

        // Handle signup form submission
        signupForm.addEventListener('submit', function (event) {
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
                        loginForm.style.display = 'block';
                        signupForm.style.display = 'none';
                        formTitle.textContent = 'Login';
                        toggleButton.textContent = 'Sign Up';
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

        // Add custom animations
        const cards = document.querySelectorAll('.card');
        cards.forEach(card => {
            card.addEventListener('mouseover', () => {
                card.classList.add('shadow-lg');
            });
            card.addEventListener('mouseout', () => {
                card.classList.remove('shadow-lg');
            });
        });
    });
</script>
</body>
</html>