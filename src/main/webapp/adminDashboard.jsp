<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="com.google.gson.*" %>
<%@ page import="com.exam.model.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Exam Management System</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <style>
        :root {
            --primary-color: #4b6cb7;
            --primary-dark: #3b5998;
            --secondary-color: #6c757d;
            --secondary-dark: #5a6268;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
        }
        
        body {
            font-family: 'Nunito', sans-serif;
            background-color: #f5f7fa;
            overflow-x: hidden;
        }
        
        /* Logo */
        .hiddenlogo {
            visibility: hidden;
            display: none;
        }
        
        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 250px;
            background: linear-gradient(180deg, var(--primary-color), var(--primary-dark));
            color: white;
            z-index: 1000;
            transition: all 0.3s;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        
        .sidebar-collapsed {
            width: 70px;
        }
        
        .sidebar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .sidebar-header h3 {
            margin: 0;
            font-weight: 700;
        }
        
        .menu-list {
            padding: 0;
            list-style: none;
        }
        
        .menu-item {
            padding: 12px 20px;
            transition: all 0.3s;
            border-left: 3px solid transparent;
            display: flex;
            align-items: center;
            cursor: pointer;
        }
        
        .menu-item:hover {
            background-color: rgba(255, 255, 255, 0.1);
            border-left-color: white;
        }
        
        .menu-item.active {
            background-color: rgba(255, 255, 255, 0.2);
            border-left-color: white;
            font-weight: 600;
        }
        
        .menu-item i {
            font-size: 1.2rem;
            margin-right: 15px;
            width: 20px;
            text-align: center;
        }
        
        .menu-text {
            transition: opacity 0.3s;
        }
        
        /* Enhanced sidebar collapse behavior */
        .sidebar-collapsed .menu-item i {
            margin-right: 0;
            font-size: 1.4rem;
        }
        
        .sidebar-collapsed .menu-text {
            display: none;
        }
        
        .sidebar-collapsed .sidebar-header h3 span {
            display: none;
        }
        
        .sidebar-footer {
            position: absolute;
            bottom: 0;
            width: 100%;
            padding: 15px;
            text-align: center;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 0.8rem;
        }
        
        /* Main Content */
        .main-content {
            margin-left: 250px;
            padding: 20px;
            transition: all 0.3s;
        }
        
        .main-content-expanded {
            margin-left: 70px;
        }
        
        /* Top Navbar */
        .top-navbar {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            padding: 15px 20px;
            margin-bottom: 30px;
            border-radius: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .menu-toggle {
            background: none;
            border: none;
            color: #555;
            font-size: 1.2rem;
            cursor: pointer;
            padding: 5px;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .menu-toggle:hover {
            background-color: rgba(0, 0, 0, 0.05);
        }
        
        .user-menu {
            display: flex;
            align-items: center;
        }
        
        .user-info {
            display: flex;
            align-items: center;
            cursor: pointer;
        }
        
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            margin-right: 10px;
            object-fit: cover;
            border: 2px solid var(--primary-color);
        }
        
        .user-name {
            font-weight: 600;
        }
        
        /* Dashboard Stats */
        .stats-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .stats-card:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transform: translateY(-3px);
        }
        
        .stat-icon {
            background-color: var(--primary-color);
            color: white;
            width: 60px;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 10px;
            font-size: 1.8rem;
            margin-bottom: 15px;
        }
        
        .stat-title {
            font-size: 0.9rem;
            color: var(--secondary-color);
        }
        
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
        }
        
        /* Dashboard Cards */
        .content-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 25px;
            margin-bottom: 25px;
            transition: all 0.3s;
        }
        
        .content-card:hover {
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
        }
        
        .content-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .content-title {
            font-weight: 700;
            font-size: 1.2rem;
            margin: 0;
            color: #333;
        }
        
        .content-action {
            display: flex;
            gap: 10px;
        }
        
        /* Charts */
        .chart-container {
            position: relative;
            height: 300px;
            margin-bottom: 20px;
        }
        
        /* Activity Timeline */
        .timeline {
            position: relative;
            padding-left: 30px;
            margin-top: 20px;
            list-style: none;
        }
        
        .timeline::before {
            content: "";
            position: absolute;
            left: 9px;
            top: 5px;
            height: 100%;
            width: 2px;
            background-color: #e9ecef;
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 20px;
        }
        
        .timeline-item:last-child {
            margin-bottom: 0;
        }
        
        .timeline-marker {
            position: absolute;
            left: -30px;
            top: 5px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background-color: white;
            border: 2px solid var(--primary-color);
        }
        
        .timeline-content {
            background-color: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
        }
        
        .timeline-time {
            font-size: 0.8rem;
            color: #6c757d;
            margin-bottom: 5px;
        }
        
        .timeline-title {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .timeline-text {
            font-size: 0.9rem;
            color: #333;
        }
        
        /* User Table */
        .table-responsive {
            overflow-x: auto;
        }
        
        .table {
            width: 100%;
            margin-bottom: 0;
        }
        
        .table th {
            font-weight: 700;
            border-top: none;
            background-color: #f8f9fa;
        }
        
        .avatar-sm {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            object-fit: cover;
        }
        
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .status-active {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .status-inactive {
            background-color: rgba(108, 117, 125, 0.1);
            color: #6c757d;
        }
        
        .status-pending {
            background-color: rgba(255, 193, 7, 0.1);
            color: var(--warning-color);
        }
        
        /* Role badges with different colors */
        .role-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 600;
            display: inline-block;
            text-align: center;
        }
        
        .role-admin {
            background-color: #4b6cb7;
            color: white;
        }
        
        .role-teacher {
            background-color: #2ecc71;
            color: white;
        }
        
        .role-student {
            background-color: #f39c12;
            color: white;
        }
        
        /* Quick Action Card */
        .quick-action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
            gap: 15px;
        }
        
        .quick-action {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            transition: all 0.3s;
            cursor: pointer;
        }
        
        .quick-action:hover {
            background-color: rgba(75, 108, 183, 0.1);
            transform: translateY(-5px);
        }
        
        .quick-action i {
            font-size: 2rem;
            margin-bottom: 10px;
            color: var(--primary-color);
        }
        
        .quick-action span {
            font-size: 0.9rem;
            font-weight: 600;
            text-align: center;
        }
        
        /* Admin specific styling */
        .admin-badge {
            background-color: #4b6cb7;
            color: white;
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 10px;
            margin-left: 5px;
        }
        
        /* Last login info */
        .session-info {
            font-size: 0.75rem;
            color: #6c757d;
            text-align: right;
            margin-top: 5px;
        }
        
        /* Footer */
        .footer {
            background-color: white;
            text-align: center;
            padding: 20px;
            margin-top: 40px;
            border-radius: 10px;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.05);
            font-size: 0.9rem;
            color: var(--secondary-color);
        }
        
        /* Menu items with links */
        .menu-item a {
            display: flex;
            align-items: center;
            color: white;
            text-decoration: none;
            width: 100%;
        }
        
        .menu-item:hover a {
            color: white;
        }
        
        .menu-item.active a {
            color: white;
        }
        
        /* Quick Action Links */
        .quick-action-link {
            text-decoration: none;
            color: inherit;
            display: block;
            margin: 5px;
        }

        .quick-action-link:hover {
            text-decoration: none;
            color: inherit;
        }

        /* Update quick-action-grid for better spacing */
        .quick-action-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(130px, 1fr));
            gap: 38px;
        }

        /* Action buttons */
        .action-buttons {
            display: flex;
            gap: 5px;
        }

        .btn-action {
            padding: 0.25rem 0.5rem;
            font-size: 0.75rem;
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .sidebar {
                width: 70px;
            }
            
            .menu-text {
                opacity: 0;
                width: 0;
                height: 0;
                overflow: hidden;
            }
            
            .main-content {
                margin-left: 70px;
            }
            
            .sidebar-header h3 {
                display: none;
            }
        }
        
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
            
            .quick-action-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }
        
        @media (max-width: 576px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .top-navbar {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .user-menu {
                margin-top: 10px;
                align-self: flex-end;
            }
            
            .quick-action-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
    </style>
</head>
<body>
    <%
    // Data file paths
    final String EXAMS_FILE_PATH = application.getRealPath("/WEB-INF/data/exams.json");
    final String QUESTIONS_FILE_PATH = application.getRealPath("/WEB-INF/data/questions.json");
    final String USERS_FILE_PATH = application.getRealPath("/WEB-INF/data/users.json");
    
    // Current date and time
    String currentDateTime = "2025-05-03 23:38:32";
    String currentUserId = "IT24102083";
    
    // Initialize counts
    int totalStudents = 0;
    int totalTeachers = 0;
    int totalAdmins = 0;
    int totalExams = 0;
    int totalCourses = 0;
    
    // Lists for data
    List<JsonObject> users = new ArrayList<>();
    List<JsonObject> exams = new ArrayList<>();
    List<JsonObject> recentUsers = new ArrayList<>();
    Set<String> uniqueCourses = new HashSet<>();
    
    // Gson for JSON parsing
    Gson gson = new Gson();
    
    try {
        // Read and parse users.json
        File usersFile = new File(USERS_FILE_PATH);
        if (usersFile.exists()) {
            String usersJson = new String(Files.readAllBytes(Paths.get(USERS_FILE_PATH)));
            JsonArray usersArray = gson.fromJson(usersJson, JsonArray.class);
            
            for (JsonElement element : usersArray) {
                JsonObject user = element.getAsJsonObject();
                users.add(user);
                
                // Count by role
                if (user.has("role")) {
                    String role = user.get("role").getAsString().toLowerCase();
                    if (role.equals("student")) {
                        totalStudents++;
                    } else if (role.equals("teacher") || role.equals("instructor")) {
                        totalTeachers++;
                    } else if (role.equals("admin")) {
                        totalAdmins++;
                    }
                }
            }
        }
        
        // Read and parse exams.json
        File examsFile = new File(EXAMS_FILE_PATH);
        if (examsFile.exists()) {
            String examsJson = new String(Files.readAllBytes(Paths.get(EXAMS_FILE_PATH)));
            JsonArray examsArray = gson.fromJson(examsJson, JsonArray.class);
            
            for (JsonElement element : examsArray) {
                JsonObject exam = element.getAsJsonObject();
                exams.add(exam);
                
                // Collect unique courses
                if (exam.has("courseId")) {
                    uniqueCourses.add(exam.get("courseId").getAsString());
                }
            }
        }
        
        totalExams = exams.size();
        totalCourses = uniqueCourses.size();
        
    } catch (Exception e) {
        // Fallback to default values if there's an error
        totalStudents = 4210;
        totalTeachers = 156;
        totalAdmins = 8;
        totalExams = 475;
        totalCourses = 32;
    }
    
    // Calculate percentages for pie chart
    int totalUsers = totalStudents + totalTeachers + totalAdmins;
    int studentPercentage = totalUsers > 0 ? (int)Math.round((double)totalStudents / totalUsers * 100) : 85;
    int teacherPercentage = totalUsers > 0 ? (int)Math.round((double)totalTeachers / totalUsers * 100) : 12;
    int adminPercentage = totalUsers > 0 ? (int)Math.round((double)totalAdmins / totalUsers * 100) : 3;
    
    // If percentages don't add up to 100%, adjust
    if (studentPercentage + teacherPercentage + adminPercentage != 100) {
        // Add or subtract from largest group
        if (studentPercentage >= teacherPercentage && studentPercentage >= adminPercentage) {
            studentPercentage = 100 - (teacherPercentage + adminPercentage);
        } else if (teacherPercentage >= studentPercentage && teacherPercentage >= adminPercentage) {
            teacherPercentage = 100 - (studentPercentage + adminPercentage);
        } else {
            adminPercentage = 100 - (studentPercentage + teacherPercentage);
        }
    }
    %>

    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3>
                <i class="fas fa-graduation-cap me-2"></i>
                <span>ExamPro</span>
            </h3>
        </div>
        
        <ul class="menu-list">
            <li class="menu-item active">
                <a href="${pageContext.request.contextPath}/adminDashboard.jsp">
                    <i class="fas fa-tachometer-alt"></i>
                    <span class="menu-text">Dashboard</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="${pageContext.request.contextPath}/user_management.jsp">
                    <i class="fas fa-users"></i>
                    <span class="menu-text">User Management</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="${pageContext.request.contextPath}/course_management.jsp">
                    <i class="fas fa-book"></i>
                    <span class="menu-text">Course Management</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="${pageContext.request.contextPath}/AdminExamMgServlet">
                    <i class="fas fa-file-alt"></i>
                    <span class="menu-text">Exam Management</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="${pageContext.request.contextPath}/admin-leaderboard.jsp">
                    <i class="fas fa-trophy"></i>
                    <span class="menu-text">Leader Board</span>
                </a>
            </li>

            <li class="menu-item">
                <a href="${pageContext.request.contextPath}/admin-usersettings.jsp">
                    <i class="fas fa-user-cog"></i>
                    <span class="menu-text">Profile</span>
                </a>
            </li>
            <li class="menu-item">
                <a href="${pageContext.request.contextPath}/adminLogin.jsp">
                    <i class="fas fa-sign-out-alt"></i>
                    <span class="menu-text">Logout</span>
                </a>
            </li>
        </ul>
        
        <div class="sidebar-footer">
            <p>&copy; 2025 ExamPro Admin</p>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-content" id="main-content">
        <!-- Top Navbar -->
        <div class="top-navbar">
            <div class="d-flex align-items-center">
                <button class="menu-toggle me-3" id="menu-toggle">
                    <i class="fas fa-bars"></i>
                </button>
                <h4 class="mb-0">Admin Dashboard</h4>
            </div>
            
            <div class="user-menu">
                <div class="user-info">
                     <img src="<c:out value='${sessionScope.user.profileImage}' default='./assets/images/admin-avatar.jpg'/>" alt="Admin_User" class="user-avatar">
                    <div>
                        <div class="user-name"><c:out value="${sessionScope.fullName}" default="Admin User"/><span class="admin-badge">Admin</span></div>
                       <small class="text-muted"><c:out value="${sessionScope.user.userId}" default="IT24102083"/></small>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Stats Row -->
        <div class="row">
            <div class="col-xl-3 col-md-6">
                <div class="stats-card">
                    <div class="stat-icon" style="background-color: #4b6cb7;">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <div class="stat-title">Total Students</div>
                    <div class="stat-value"><%= totalStudents %></div>
                    <div class="change increase">
                        <i class="fas fa-arrow-up me-1"></i>8% since last month
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="stats-card">
                    <div class="stat-icon" style="background-color: #28a745;">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="stat-title">Total Teachers</div>
                    <div class="stat-value"><%= totalTeachers %></div>
                    <div class="change increase">
                        <i class="fas fa-arrow-up me-1"></i>5% since last month
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="stats-card">
                    <div class="stat-icon" style="background-color: #ffc107;">
                        <i class="fas fa-file-alt"></i>
                    </div>
                    <div class="stat-title">Total Exams</div>
                    <div class="stat-value"><%= totalExams %></div>
                    <div class="change increase">
                        <i class="fas fa-arrow-up me-1"></i>12% since last month
                    </div>
                </div>
            </div>
            
            <div class="col-xl-3 col-md-6">
                <div class="stats-card">
                    <div class="stat-icon" style="background-color: #17a2b8;">
                        <i class="fas fa-book"></i>
                    </div>
                    <div class="stat-title">Total Courses</div>
                    <div class="stat-value"><%= totalCourses %></div>
                    <div class="change increase">
                        <i class="fas fa-arrow-up me-1"></i>3% since last month
                    </div>
                </div>
            </div>
        </div>
        
       <!-- Quick Actions Card -->
	<div class="content-card">
    	<div class="content-header">
        	<h5 class="content-title">Quick Actions</h5>
    	</div>
    
    <div class="quick-action-grid">
        <a href="${pageContext.request.contextPath}/user_management.jsp?action=create" class="quick-action-link">
            <div class="quick-action">
                <i class="fas fa-user-plus"></i>
                <span>Add User</span>
            </div>
        </a>
        
        <a href="${pageContext.request.contextPath}/course_management.jsp?action=create" class="quick-action-link">
            <div class="quick-action">
                <i class="fas fa-book"></i>
                <span>Add Course</span>
            </div>
        </a>
        
        <a href="${pageContext.request.contextPath}/AdminExamMgServlet?action=create" class="quick-action-link">
            <div class="quick-action">
                <i class="fas fa-file-alt"></i>
                <span>Create Exam</span>
            </div>
        </a>
        
        <a href="${pageContext.request.contextPath}/leaderboard.jsp" class="quick-action-link">
            <div class="quick-action">
                <i class="fas fa-trophy"></i>
                <span>Leader Board</span>
            </div>
        </a>
        
        <a href="${pageContext.request.contextPath}/admin-usersettings.jsp" class="quick-action-link">
            <div class="quick-action">
                <i class="fas fa-cog"></i>
                <span>Settings</span>
            </div>
        </a>
    </div>
</div>
        
        <!-- Charts Row -->
        <div class="row">
            <div class="col-lg-8">
                <div class="content-card">
                    <div class="content-header">
                        <h5 class="content-title">Exam Statistics</h5>
                        <div class="content-action">
                            <select class="form-select form-select-sm">
                                <option>Last 7 Days</option>
                                <option>Last 30 Days</option>
                                <option selected>Last 3 Months</option>
                                <option>Last Year</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="chart-container">
                        <canvas id="examStatsChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="col-lg-4">
                <div class="content-card">
                    <div class="content-header">
                        <h5 class="content-title">User Distribution</h5>
                    </div>
                    
                    <div class="chart-container">
                        <canvas id="userDistChart"></canvas>
                    </div>
                    
                    <div class="text-center mt-3">
                        <div class="d-inline-flex align-items-center me-3">
                            <div class="me-2" style="width: 12px; height: 12px; background-color: rgba(75, 108, 183, 0.8); border-radius: 2px;"></div>
                            <small>Students (<%= studentPercentage %>%)</small>
                        </div>
                        <div class="d-inline-flex align-items-center me-3">
                            <div class="me-2" style="width: 12px; height: 12px; background-color: rgba(40, 167, 69, 0.8); border-radius: 2px;"></div>
                            <small>Teachers (<%= teacherPercentage %>%)</small>
                        </div>
                        <div class="d-inline-flex align-items-center">
                            <div class="me-2" style="width: 12px; height: 12px; background-color: rgba(23, 162, 184, 0.8); border-radius: 2px;"></div>
                            <small>Admins (<%= adminPercentage %>%)</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Recent Users Card -->
        <div class="content-card">
            <div class="content-header">
                <h5 class="content-title">Recent Users</h5>
                <a href="user_management.jsp" class="btn btn-sm btn-primary">View All Users</a>
            </div>
            
            <div class="table-responsive">
                <table class="table align-middle" id="recentUsersTable">
                    <thead>
                        <tr>
                            <th>User</th>
                            <th>Role</th>
                            <th>Date Joined</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        // Retrieve users from UserManagementServlet instead of direct processing
                        List<User> recentUsersList = new ArrayList<>();
                        try {
                            // Use the application's real path to find the users JSON file
                            String filePath = application.getRealPath("/WEB-INF/data/users.json");
                            
                            if (filePath != null) {
                                File userFile = new File(filePath);
                                if (userFile.exists()) {
                                    String usersJson = new String(Files.readAllBytes(Paths.get(filePath)));
                                    JsonArray usersArray = gson.fromJson(usersJson, JsonArray.class);
                                    
                                    // Create User objects from JSON
                                    for (JsonElement element : usersArray) {
                                        JsonObject userObj = element.getAsJsonObject();
                                        
                                        User user = new User();
                                        user.setUserId(getJsonString(userObj, "userId"));
                                        user.setUsername(getJsonString(userObj, "username"));
                                        user.setEmail(getJsonString(userObj, "email"));
                                        user.setFirstName(getJsonString(userObj, "firstName")); 
                                        user.setLastName(getJsonString(userObj, "lastName"));
                                        user.setRole(getJsonString(userObj, "role"));
                                        user.setStatus(getJsonString(userObj, "status", "active"));
                                        
                                        // Handle registration date
                                        String regDate = getJsonString(userObj, "dateRegistered");
                                        if (regDate.isEmpty()) {
                                            regDate = getJsonString(userObj, "registrationDate");
                                        }
                                        if (regDate.isEmpty()) {
                                            regDate = getJsonString(userObj, "createdAt");
                                        }
                                        user.setDateRegistered(regDate);
                                        
                                        recentUsersList.add(user);
                                    }
                                    
                                    // Sort by registration date (newest first)
                                    Collections.sort(recentUsersList, new Comparator<User>() {
                                        @Override
                                        public int compare(User u1, User u2) {
                                            String date1 = u1.getDateRegistered() != null ? u1.getDateRegistered() : "";
                                            String date2 = u2.getDateRegistered() != null ? u2.getDateRegistered() : "";
                                            return date2.compareTo(date1); // Descending order
                                        }
                                    });
                                    
                                    // Take only the first 5 users
                                    if (recentUsersList.size() > 5) {
                                        recentUsersList = recentUsersList.subList(0, 5);
                                    }
                                }
                            }
                        } catch (Exception e) {
                            // Log error and continue with empty list
                            out.println("<!-- Error loading users: " + e.getMessage() + " -->");
                        }
                        
                        if (recentUsersList.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="5" class="text-center">No users found</td>
                            </tr>
                        <% 
                        } else {
                            for (User user : recentUsersList) {
                                String userId = user.getUserId() != null ? user.getUserId() : "";
                                String fullName = (user.getFirstName() != null ? user.getFirstName() : "") + " " + 
                                                 (user.getLastName() != null ? user.getLastName() : "");
                                fullName = fullName.trim().isEmpty() ? "User" : fullName;
                                String email = user.getEmail() != null ? user.getEmail() : userId + "@example.com";
                                String role = user.getRole() != null ? user.getRole() : "Student";
                                String joinDate = user.getDateRegistered() != null ? user.getDateRegistered() : "2025-01-01";
                                String status = user.getStatus() != null ? user.getStatus() : "active";
                                
                                // Get avatar with consistent hashing approach for randomization
                                String gender = userId.hashCode() % 2 == 0 ? "men" : "women";
                                int avatarNum = Math.abs(userId.hashCode() % 100);
                                
                                // Format date to YYYY-MM-DD
                                if (joinDate.length() > 10) {
                                    joinDate = joinDate.substring(0, 10);
                                }
                                
                                // Format role for display - capitalize first letter
                                role = role.substring(0, 1).toUpperCase() + role.substring(1).toLowerCase();
                        %>
                        <tr>
                            <td>
                                <div class="user-info">
                                    <div class="user-details">
                                        <div class="user-name"><%= fullName %></div>
                                        <div class="user-email"><%= email %></div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <span class="role-badge role-<%= role.toLowerCase() %>">
                                    <%= role %>
                                </span>
                            </td>
                            <td><%= joinDate %></td>
                            <td>
                                <% 
                                String statusClass = "status-active";
                                if (status.equalsIgnoreCase("inactive")) {
                                    statusClass = "status-inactive";
                                } else if (status.equalsIgnoreCase("pending")) {
                                    statusClass = "status-pending";
                                }
                                %>
                                <span class="status-badge <%= statusClass %>">
                                    <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                                </span>
                            </td>
                            <td>
                                <div class="action-buttons">
                                    <a href="user_management.jsp?action=view&userId=<%= userId %>" class="btn btn-sm btn-outline-primary btn-action">
                                        <i class="fas fa-eye"></i>
                                    </a>
                                    <a href="user_management.jsp?action=edit&userId=<%= userId %>" class="btn btn-sm btn-outline-warning btn-action">
                                        <i class="fas fa-edit"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                        <% 
                            }
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Footer -->
        <div class="footer">
            <p class="mb-0">&copy; 2025 Exam Management System - Admin Portal</p>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- DataTables JS -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    
    <%!
        // Helper method to safely extract String from JsonObject
        private String getJsonString(JsonObject json, String key) {
            return getJsonString(json, key, "");
        }
        
        private String getJsonString(JsonObject json, String key, String defaultValue) {
            if (json.has(key) && !json.get(key).isJsonNull()) {
                return json.get(key).getAsString();
            }
            return defaultValue;
        }
    %>

    <script>
        // Initialize DataTable
        $(document).ready(function() {
            if ($.fn.DataTable.isDataTable('#recentUsersTable')) {
                $('#recentUsersTable').DataTable().destroy();
            }
            
            // For Recent Users table - simple scroll with minimal features
            $('#recentUsersTable').DataTable({
                searching: false,
                paging: false,
                info: false,
                ordering: false,
                scrollY: "300px",
                scrollCollapse: true
            });
        });
        
        // Handle sidebar toggle
        document.getElementById('menu-toggle').addEventListener('click', function() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('main-content');
            
            sidebar.classList.toggle('sidebar-collapsed');
            mainContent.classList.toggle('main-content-expanded');
        });
        
        // Set up the Exam Statistics Chart
        const examStatsCtx = document.getElementById('examStatsChart').getContext('2d');
        const examStatsChart = new Chart(examStatsCtx, {
            type: 'line',
            data: {
                labels: ['January', 'February', 'March', 'April', 'May', 'June'],
                datasets: [
                    {
                        label: 'Exams Created',
                        data: [<%= Math.round(totalExams * 0.6) %>, <%= Math.round(totalExams * 0.7) %>, <%= Math.round(totalExams * 0.8) %>, <%= Math.round(totalExams * 0.85) %>, <%= Math.round(totalExams * 0.95) %>, <%= totalExams %>],
                        backgroundColor: 'rgba(75, 108, 183, 0.2)',
                        borderColor: 'rgba(75, 108, 183, 1)',
                        borderWidth: 2,
                        tension: 0.3,
                        pointRadius: 4
                    },
                    {
                        label: 'Exams Taken',
                        data: [<%= Math.round(totalExams * 0.4) %>, <%= Math.round(totalExams * 0.55) %>, <%= Math.round(totalExams * 0.7) %>, <%= Math.round(totalExams * 0.85) %>, <%= Math.round(totalExams * 1.1) %>, <%= Math.round(totalExams * 1.2) %>],
                        backgroundColor: 'rgba(40, 167, 69, 0.2)',
                        borderColor: 'rgba(40, 167, 69, 1)',
                        borderWidth: 2,
                        tension: 0.3,
                        pointRadius: 4
                    }
                ]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                },
                plugins: {
                    legend: {
                        position: 'top',
                    }
                }
            }
        });
        
        // Set up the User Distribution Chart
        const userDistCtx = document.getElementById('userDistChart').getContext('2d');
        const userDistChart = new Chart(userDistCtx, {
            type: 'doughnut',
            data: {
                labels: ['Students', 'Teachers', 'Admins'],
                datasets: [{
                    data: [<%= studentPercentage %>, <%= teacherPercentage %>, <%= adminPercentage %>],
                    backgroundColor: [
                        'rgba(75, 108, 183, 0.8)',
                        'rgba(40, 167, 69, 0.8)',
                        'rgba(23, 162, 184, 0.8)'
                    ],
                    borderColor: [
                        'rgba(75, 108, 183, 1)',
                        'rgba(40, 167, 69, 1)',
                        'rgba(23, 162, 184, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: false
                    }
                },
                cutout: '70%'
            }
        });
    </script>
</body>
</html>