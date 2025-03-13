<%--
  Created by IntelliJ IDEA.
  User: Admin
  Date: 3/10/2025
  Time: 8:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Exam Management Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="./assets/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="./assets/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .dashboard-container {
            background-color: white;
            padding: 2rem;
            border-radius: 0.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
            width: 100%;
            max-width: 768px;
        }

        .avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1rem;
        }

        .avatar img {
            width: 100%;
            height: 100%;
            border-radius: 50%;
            object-fit: cover;
        }

        .card {
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
<div class="dashboard-container">
    <!-- Dashboard View -->
    <div id="dashboardView">
        <div class="card mb-4">
            <div class="card-header">
                <h5 class="card-title">User Profile</h5>
            </div>
            <div class="card-body">
                <div class="d-flex align-items-center mb-4">
                    <div class="avatar">
                        <img src="https://via.placeholder.com/150" alt="Profile" id="profileImage">
                    </div>
                    <div>
                        <h2 class="fs-4 fw-bold" id="userName">John Doe</h2>
                        <p>Basic Information</p>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button class="btn btn-primary" onclick="showLeaderboard()">
                        <i class="bi bi-trophy me-2"></i>Leaderboard
                    </button>
                    <button class="btn btn-primary" onclick="showResults()">Results</button>
                    <button class="btn btn-danger" onclick="logout()">
                        <i class="bi bi-box-arrow-right me-2"></i>Log Out
                    </button>
                </div>
            </div>
        </div>
        <div class="card">
            <div class="card-header">
                <h5 class="card-title">Upcoming Exams</h5>
            </div>
            <div class="card-body">
                <ul class="list-group" id="upcomingExamsList">
                    <!-- Exams will be loaded dynamically -->
                </ul>
            </div>
        </div>
    </div>

    <!-- Leaderboard View -->
    <div id="leaderboardView" style="display: none;">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title">
                    <button class="btn btn-outline-secondary me-2" onclick="showDashboard()">
                        <i class="bi bi-arrow-left"></i>
                    </button>
                    Leaderboard
                </h5>
            </div>
            <div class="card-body">
                <ul class="list-group" id="leaderboardList">
                    <!-- Leaderboard will be loaded dynamically -->
                </ul>
            </div>
        </div>
    </div>

    <!-- Results View -->
    <div id="resultsView" style="display: none;">
        <div class="card">
            <div class="card-header">
                <h5 class="card-title">
                    <button class="btn btn-outline-secondary me-2" onclick="showDashboard()">
                        <i class="bi bi-arrow-left"></i>
                    </button>
                    Results
                </h5>
            </div>
            <div class="card-body">
                <p>Your Score: <span id="userScore">0</span> / <span id="totalScore">0</span></p>
            </div>
        </div>
    </div>
</div>

<%
    // Check if user is logged in
    Boolean isAuthenticated = (Boolean) session.getAttribute("authenticated");
    if (isAuthenticated == null || !isAuthenticated) {
        response.sendRedirect("signup-login.jsp");
        return;
    }
    String username = (String) session.getAttribute("username");
%>
<!-- Bootstrap JS Bundle with Popper -->
<script src="./assets/bootstrap.bundle.min.js"></script>

<script>
    // Client-side JavaScript to manage view changes
    let currentUser = {};
    let upcomingExams = [];
    let leaderboardData = [];
    let resultsData = {};

    // Initialize the dashboard
    document.addEventListener('DOMContentLoaded', function () {
        fetchUserData();
        fetchUpcomingExams();
        fetchLeaderboard();
        fetchResults();
    });

    function showDashboard() {
        document.getElementById('dashboardView').style.display = 'block';
        document.getElementById('leaderboardView').style.display = 'none';
        document.getElementById('resultsView').style.display = 'none';
    }

    function showLeaderboard() {
        document.getElementById('dashboardView').style.display = 'none';
        document.getElementById('leaderboardView').style.display = 'block';
        document.getElementById('resultsView').style.display = 'none';
    }

    function showResults() {
        document.getElementById('dashboardView').style.display = 'none';
        document.getElementById('leaderboardView').style.display = 'none';
        document.getElementById('resultsView').style.display = 'block';
    }

    function logout() {
        // Send request to server to invalidate session
        fetch('logout', {
            method: 'POST',
            credentials: 'same-origin'
        })
            .then(response => {
                if (response.ok) {
                    window.location.href = 'login.html';
                } else {
                    alert('Logout failed. Please try again.');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Logout failed. Please try again.');
            });
    }

    // API calls to backend
    function fetchUserData() {
        fetch('api/user/profile')
            .then(response => response.json())
            .then(data => {
                currentUser = data;
                document.getElementById('userName').textContent = data.name;
                document.getElementById('profileImage').src = data.imageUrl || 'https://via.placeholder.com/150';
            })
            .catch(error => console.error('Error fetching user data:', error));
    }

    function fetchUpcomingExams() {
        fetch('api/exams/upcoming')
            .then(response => response.json())
            .then(data => {
                upcomingExams = data;
                renderUpcomingExams();
            })
            .catch(error => console.error('Error fetching upcoming exams:', error));
    }

    function renderUpcomingExams() {
        const examsList = document.getElementById('upcomingExamsList');
        examsList.innerHTML = '';

        upcomingExams.forEach(exam => {
            const li = document.createElement('li');
            li.className = 'list-group-item d-flex justify-content-between align-items-center';
            li.innerHTML = `
                    <div class="d-flex align-items-center">
                        <i class="bi bi-calendar me-2"></i>
                        <span>${exam.name}</span>
                    </div>
                    <span>${exam.date}</span>
                `;
            examsList.appendChild(li);
        });
    }

    function fetchLeaderboard() {
        fetch('api/leaderboard')
            .then(response => response.json())
            .then(data => {
                leaderboardData = data;
                renderLeaderboard();
            })
            .catch(error => console.error('Error fetching leaderboard:', error));
    }

    function renderLeaderboard() {
        const leaderboardList = document.getElementById('leaderboardList');
        leaderboardList.innerHTML = '';

        leaderboardData.forEach((user, index) => {
            const li = document.createElement('li');
            li.className = 'list-group-item d-flex justify-content-between align-items-center';
            li.innerHTML = `
                    <div class="d-flex align-items-center">
                        <div class="avatar">
                            <img src="https://via.placeholder.com/50?text=${user.name[0]}" alt="${user.name}">
                        </div>
                        <span>${user.name}</span>
                    </div>
                    <span>${user.score}</span>
                `;
            leaderboardList.appendChild(li);
        });
    }

    function fetchResults() {
        fetch('api/results')
            .then(response => response.json())
            .then(data => {
                resultsData = data;
                document.getElementById('userScore').textContent = data.score;
                document.getElementById('totalScore').textContent = data.total;
            })
            .catch(error => console.error('Error fetching results:', error));
    }
</script>
</body>
</html>