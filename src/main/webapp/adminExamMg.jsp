<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.*" %>

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
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Summernote CSS -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">

    <!-- Summernote JS -->
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    
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
        
        /* Exam Management Table */
        .data-table {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-bottom: 30px;
        }
        
        .table thead th {
            font-weight: 600;
            border-top: none;
            background-color: #f8f9fa;
        }
        
        .table td {
            vertical-align: middle;
        }
        
        .table-striped tbody tr:nth-of-type(odd) {
            background-color: #f8f9fa;
        }
        
        /* UPDATED: Action buttons - always horizontal */
        .action-buttons {
            display: flex;
            align-items: center;
            justify-content: flex-start;
            white-space: nowrap;
        }
        
        .action-buttons button {
            padding: 0.25rem 0.5rem;
            margin-right: 5px;
        }
        
        .action-buttons button:last-child {
            margin-right: 0;
        }
        
        /* Status Badges */
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .status-published {
            background-color: rgba(40, 167, 69, 0.15);
            color: #28a745;
        }
        
        .status-draft {
            background-color: rgba(128, 128, 128, 0.15);
            color: #808080;
        }
        
        .status-pending {
            background-color: rgba(23, 162, 184, 0.15);
            color: #17a2b8;
        }
        
        .status-closed {
            background-color: rgba(108, 117, 125, 0.15);
            color: #6c757d;
        }
        
        /* UPDATED: Search and Filter Bar */
        .search-filter-bar {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            align-items: center;
        }
        
        .search-box {
            position: relative;
            width: 250px;
            min-width: 200px;
        }
        
        .search-box input {
            padding-right: 40px;
        }
        
        .search-box i {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
        }
        
        /* UPDATED: Filter group - horizontal layout */
        .filter-group {
            display: flex;
            align-items: center;
            white-space: nowrap;
            flex-wrap: nowrap;
        }
        
        .filter-group select {
            margin-left: 8px;
            width: auto;
            min-width: 150px;
        }
        
        /* Modal Styles */
        .modal-content {
            border-radius: 10px;
            border: none;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
            padding: 15px 20px;
        }
        
        .modal-body {
            padding: 20px;
        }
        
        .modal-footer {
            padding: 15px 20px;
            border-top: 1px solid #eee;
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
        
        /* Responsive */
        @media (max-width: 1200px) {
            /* UPDATED: For smaller screens but larger than mobile */
            .filter-group select {
                min-width: 120px;
            }
        }
        
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
            
            /* UPDATED: Make search bar and filters stack on medium screens */
            .search-filter-bar {
                flex-direction: column;
                align-items: stretch;
            }
            
            .search-box {
                width: 100%;
                margin-bottom: 15px;
            }
            
            .filter-group {
                width: 100%;
                overflow-x: auto;
                padding-bottom: 5px;
            }
        }
        
        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr 1fr;
            }
            
            /* UPDATED: Keep action buttons in a row even on small screens */
            .action-buttons {
                flex-wrap: nowrap;
                overflow-x: auto;
                padding-bottom: 2px;
            }
            
            .action-buttons button {
                flex-shrink: 0;
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
            
            /* UPDATED: Make the filter elements scrollable on very small screens */
            .filter-group {
                overflow-x: scroll;
                -webkit-overflow-scrolling: touch;
                padding-bottom: 10px;
                width: 100%;
            }
        }
        
        /* Question List Style */
        .question-list {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 10px;
            max-height: 300px;
            overflow-y: auto;
        }
        
        .question-list-item {
            padding: 10px;
            border-bottom: 1px solid #e9ecef;
            background-color: white;
            margin-bottom: 8px;
            border-radius: 5px;
        }
        
        .question-list-item:last-child {
            border-bottom: none;
        }
        
        .question-text {
            font-weight: 500;
            margin-bottom: 5px;
        }
        
        .question-meta {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            color: #6c757d;
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
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .instructor-info {
            display: flex;
            align-items: center;
        }
        
        .instructor-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            margin-right: 10px;
        }
        
        .table-responsive {
            overflow-x: auto;
        }
        
        /* Status message */
        #statusMessage {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: none;
        }

        /* Active/Inactive toggle */
        .form-switch .form-check-input {
            width: 3em;
            height: 1.5em;
        }
        
        .form-switch .form-check-input:checked {
            background-color: #28a745;
            border-color: #28a745;
        }

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
    </style>
</head>

<body>
    <%
    // Get attributes from the servlet
    String currentDateTime = (String) request.getAttribute("currentDateTime");
    String currentUserId = (String) request.getAttribute("currentUserId");
    List<JsonObject> exams = (List<JsonObject>) request.getAttribute("exams");
    Map<String, List<JsonObject>> questionsByExam = (Map<String, List<JsonObject>>) request.getAttribute("questionsByExam");
    Map<String, JsonObject> userMap = (Map<String, JsonObject>) request.getAttribute("userMap");
    Map<String, Integer> stats = (Map<String, Integer>) request.getAttribute("stats");
    String error = (String) request.getAttribute("error");
    List<JsonObject> courses = (List<JsonObject>) request.getAttribute("courses");
    
    // Default values if attributes are null - UPDATED WITH NEW DATE
    if (currentDateTime == null) {
        currentDateTime = "2025-05-04 11:22:08";
    }
    
    if (currentUserId == null) {
        currentUserId = "IT24102083";
    }
    
    Map<String, String> courseNames = new HashMap<>();
    if (courses != null && !courses.isEmpty()) {
        for (JsonObject course : courses) {
            if (course.has("courseId") && course.has("courseName")) {
                courseNames.put(course.get("courseId").getAsString(), course.get("courseName").getAsString());
            }
        }
    } else {
        // Fallback to default courses if none provided
        courseNames.put("CSE303", "Database Management Systems");
        courseNames.put("CSE405", "Computer Networks");
        courseNames.put("ECE202", "Digital Electronics");
        courseNames.put("CSE201", "Object Oriented Programming");
    }
    
    // Default empty collections
    if (exams == null) {
        exams = new ArrayList<>();
    }
    
    if (questionsByExam == null) {
        questionsByExam = new HashMap<>();
    }
    
    if (userMap == null) {
        userMap = new HashMap<>();
    }
    
    if (stats == null) {
        stats = new HashMap<>();
        stats.put("totalExams", exams.size());
        stats.put("publishedExams", 0);
        stats.put("draftExams", 0);
        stats.put("pendingExams", 0);
        stats.put("closedExams", 0);
        stats.put("instructorCount", 0);
        stats.put("courseCount", 0);
    }
    %>
    
    <!-- Status message for feedback -->
    <div id="statusMessage" class="alert" role="alert" style="display:none;"></div>

    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3>
                <i class="fas fa-graduation-cap me-2"></i>
                <span>ExamPro</span>
            </h3>
        </div>
        
        <ul class="menu-list">
            <li class="menu-item">
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
                <a href="${pageContext.request.contextPath}#">
                    <i class="fas fa-book"></i>
                    <span class="menu-text">Course Management</span>
                </a>
            </li>
            <li class="menu-item active">
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
                <h4 class="mb-0"><i class="fas me-2 text-primary"></i> Exam Management</h4>
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
        
              
        <% if (error != null && !error.isEmpty()) { %>
            <!-- Error Message -->
            <div class="alert alert-danger mb-4">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <%= error %>
            </div>
        <% } %>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stats-card">
                <div class="stat-icon" style="background-color: #4b6cb7;">
                    <i class="fas fa-file-alt"></i>
                </div>
                <div class="stat-title">Total Exams</div>
                <div class="stat-value"><%= stats.getOrDefault("totalExams", 0) %></div>
            </div>
            
            <div class="stats-card">
                <div class="stat-icon" style="background-color: #28a745;">
                    <i class="fas fa-check-circle"></i>
                </div>
                <div class="stat-title">Published Exams</div>
                <div class="stat-value"><%= stats.getOrDefault("publishedExams", 0) %></div>
            </div>
            
            <div class="stats-card">
                <div class="stat-icon" style="background-color: #ffc107;">
                    <i class="fas fa-pencil-alt"></i>
                </div>
                <div class="stat-title">Pending Exams</div>
                <div class="stat-value"><%= stats.getOrDefault("pendingExams", 0) + stats.getOrDefault("draftExams", 0) %></div>
            </div>
            
            <div class="stats-card">
                <div class="stat-icon" style="background-color: #17a2b8;">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-title">Active Instructors</div>
                <div class="stat-value"><%= stats.getOrDefault("instructorCount", 0) %></div>
            </div>
        </div>
        
        <!-- Exam Management Section -->
        <div class="data-table">
            
            <!-- UPDATED: Search and Filters - Changed structure to maintain horizontal layout -->
            <div class="search-filter-bar">
                <div class="search-box">
                    <input type="text" class="form-control" id="searchExam" placeholder="Search exams...">
                    <i class="fas fa-search"></i>
                </div>
                
                <div class="filter-group">
                    <select class="form-select" id="statusFilter">
                        <option value="all">All Status</option>
                        <option value="published">Published</option>
                        <option value="draft">Draft</option>
                        <option value="pending">Pending</option>
                        <option value="closed">Closed</option>
                    </select>
                    
                    <select class="form-select" id="courseFilter">
                        <option value="all">All Courses</option>
    					<% 
    					// Dynamically generate course options based on the courses from servlet
    					for (Map.Entry<String, String> course : courseNames.entrySet()) {
       					String courseId = course.getKey();
        				String courseName = course.getValue();
   						 %>
    					<option value="<%= courseId %>"><%= courseId %>: <%= courseName %></option>
    					<% } %>
                    </select>
                    
                    <select class="form-select" id="instructorFilter">
                        <option value="all">All Instructors</option>
                        <% 
                        Set<String> instructorIds = new HashSet<>();
                        for (JsonObject exam : exams) {
                            if (exam.has("createdBy")) {
                                instructorIds.add(exam.get("createdBy").getAsString());
                            }
                        }
                        
                        for (String instructorId : instructorIds) {
                            String instructorName = "Instructor";
                            
                            if (userMap.containsKey(instructorId)) {
                                JsonObject user = userMap.get(instructorId);
                                if (user.has("fullName")) {
                                    instructorName = user.get("fullName").getAsString();
                                }
                            }
                        %>
                        <option value="<%= instructorId %>"><%= instructorName %> (<%= instructorId %>)</option>
                        <% } %>
                    </select>
                </div>
            </div>
            
            <!-- UPDATED: Exams Table with fixed action buttons -->
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead>
                        <tr>
                            <th>Exam ID</th>
                            <th>Exam Name</th>
                            <th>Course</th>
                            <th>Instructor</th>
                            <th>Status</th>
                            <th>Questions</th>
                            <th>Created Date</th>
                            <th width="120">Actions</th>
                        </tr>
                    </thead>
                    <tbody id="examTableBody">
                        <% 
                        if (exams.isEmpty()) { 
                        %>
                            <tr>
                                <td colspan="8" class="text-center py-4">
                                    <i class="fas fa-folder-open text-muted mb-3" style="font-size: 3rem;"></i>
                                    <p class="mb-0">No exams found. Click "Create New Exam" to get started.</p>
                                </td>
                            </tr>
                        <% 
                        } else {
                            // Display exams
                            for (JsonObject exam : exams) {
                                String examId = exam.has("examId") ? exam.get("examId").getAsString() : "";
                                String examName = exam.has("examName") ? exam.get("examName").getAsString() : "Untitled Exam";
                                String courseId = exam.has("courseId") ? exam.get("courseId").getAsString() : "";
                                String courseName = courseNames.getOrDefault(courseId, courseId);
                                String createdAt = exam.has("createdAt") ? exam.get("createdAt").getAsString() : "";
                                String status = exam.has("status") ? exam.get("status").getAsString() : "draft";
                                String createdBy = exam.has("createdBy") ? exam.get("createdBy").getAsString() : "";
                                
                                // Get instructor name from userMap
                                String instructorName = "";
                                if (userMap.containsKey(createdBy)) {
                                    JsonObject user = userMap.get(createdBy);
                                    if (user.has("fullName")) {
                                        instructorName = user.get("fullName").getAsString();
                                    }
                                }
                                
                                // Get question count
                                int questionCount = 0;
                                if (questionsByExam.containsKey(examId)) {
                                    questionCount = questionsByExam.get(examId).size();
                                }
                        %>
                        <tr data-exam-id="<%= examId %>" data-course="<%= courseId %>" data-instructor="<%= createdBy %>" data-status="<%= status %>">
                            <td><span class="fw-bold"><%= examId %></span></td>
                            <td><%= examName %></td>
                            <td><%= courseId %>: <%= courseName %></td>
                            <td>
                                <div class="d-flex align-items-center">
                                    <span><%= instructorName %> <%= createdBy %></span>
                                </div>
                            </td>
                            <td>
                                <span class="status-badge status-<%= status %>">
                                    <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                                </span>
                            </td>
                            <td><%= questionCount %></td>
                            <td><%= createdAt %></td>
                            <td>
                                <!-- UPDATED: Horizontal action buttons with fixed width -->
                                <div class="action-buttons">
                                    <button type="button" class="btn btn-sm btn-outline-primary view-questions-btn" data-exam-id="<%= examId %>" title="View Questions">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-warning edit-exam-btn" data-exam-id="<%= examId %>" title="Edit Exam">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <button type="button" class="btn btn-sm btn-outline-danger delete-exam-btn" data-exam-id="<%= examId %>" title="Delete Exam">
                                        <i class="fas fa-trash-alt"></i>
                                    </button>
                                </div>
                            </td>
                        </tr>
                        <!-- Questions Container (hidden by default) -->
                        <tr class="question-container" id="questionContainer-<%= examId %>" style="display: none;">
                            <td colspan="8">
                                <div class="question-list">
                                    <div class="d-flex justify-content-between align-items-center mb-3">
                                        <h6 class="mb-0"><i class="fas fa-list-ul me-2"></i>Questions for <%= examName %>:</h6>
                                        <button class="btn btn-sm btn-outline-primary add-question-btn" data-exam-id="<%= examId %>">
                                            <i class="fas fa-plus me-1"></i> Add Question
                                        </button>
                                    </div>
                                    <% 
                                    List<JsonObject> questions = questionsByExam.getOrDefault(examId, new ArrayList<>());
                                    if (questions.isEmpty()) {
                                    %>
                                    <div class="text-center p-3 text-muted">
                                        <em>No questions found for this exam.</em>
                                    </div>
                                    <% 
                                    } else {
                                        int questionNum = 1;
                                        for (JsonObject question : questions) {
                                            String questionId = question.has("questionId") ? question.get("questionId").getAsString() : 
                                                             (question.has("id") ? question.get("id").getAsString() : "");
                                            
                                            // Get question text
                                            String questionText = "";
                                            if (question.has("questionText")) {
                                                questionText = question.get("questionText").getAsString();
                                            } else if (question.has("text")) {
                                                questionText = question.get("text").getAsString();
                                            } else {
                                                questionText = "Question " + questionNum;
                                            }
                                            
                                            // Get question type
                                            String questionType = "";
                                            if (question.has("questionType")) {
                                                questionType = question.get("questionType").getAsString();
                                            } else if (question.has("type")) {
                                                questionType = question.get("type").getAsString();
                                            } else {
                                                questionType = "multiple_choice";
                                            }
                                            
                                            // Format question type for display
                                            String formattedType = questionType.replace('_', ' ');
                                            formattedType = formattedType.substring(0, 1).toUpperCase() + formattedType.substring(1);
                                            
                                            // Get marks/points
                                            int marks = 0;
                                            if (question.has("points")) {
                                                marks = question.get("points").getAsInt();
                                            } else if (question.has("marks")) {
                                                marks = question.get("marks").getAsInt();
                                            } else {
                                                marks = 5;
                                            }
                                    %>
                                    <div class="question-list-item">
                                        <div class="question-text"><%= questionNum %>. <%= questionText %></div>
                                        <div class="question-meta">
                                            <div>Type: <%= formattedType %> | Marks: <%= marks %></div>
                                            <div class="action-buttons">
                                                <button type="button" class="btn btn-sm btn-outline-info edit-question-btn" data-question-id="<%= questionId %>">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                                <button type="button" class="btn btn-sm btn-outline-danger delete-question-btn" 
                                                        data-question-id="<%= questionId %>" data-exam-id="<%= examId %>">
                                                    <i class="fas fa-trash-alt"></i> Delete
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                    <% 
                                            questionNum++;
                                        }
                                    }
                                    %>
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
            <p class="mb-0 small">Version 1.0.0</p>
        </div>
    </div>
    
    <!-- Edit Exam Modal -->
    <div class="modal fade" id="examModal" tabindex="-1" aria-labelledby="examModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="examModalLabel">Edit Exam</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="examForm">
                        <input type="hidden" id="examId">
                        
                        <div class="mb-3">
                            <label for="examName" class="form-label">Exam Name</label>
                            <input type="text" class="form-control" id="examName" required>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="courseSelect" class="form-label">Course</label>
                                <select class="form-select" id="courseSelect" required>
                                    <% 
    						// Dynamically generate course options based on the courses from servlet
    						for (Map.Entry<String, String> course : courseNames.entrySet()) {
       						String courseId = course.getKey();
        					String courseName = course.getValue();
    								%>
   							<option value="<%= courseId %>"><%= courseId %>: <%= courseName %></option>
    						<% } %>
                                </select>
                                
                            </div>
                            <div class="col-md-6">
                                <label for="instructorSelect" class="form-label">Assigned Instructor</label>
                                <select class="form-select" id="instructorSelect" required>
                                    <option value="">Select Instructor</option>
                                    <% 
                                    for (String instructorId : instructorIds) {
                                        String instructorName = "Instructor";
                                        
                                        if (userMap.containsKey(instructorId)) {
                                            JsonObject user = userMap.get(instructorId);
                                            if (user.has("fullName")) {
                                                instructorName = user.get("fullName").getAsString();
                                            }
                                        }
                                    %>
                                    <option value="<%= instructorId %>"><%= instructorName %> (<%= instructorId %>)</option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="examDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="examDescription" rows="3"></textarea>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="examDate" class="form-label">Exam Date</label>
                                <input type="date" class="form-control" id="examDate" required>
                            </div>
                            <div class="col-md-6">
                                <label for="startTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="startTime" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="duration" class="form-label">Duration (minutes)</label>
                                <input type="number" class="form-control" id="duration" min="10" value="60" required>
                            </div>
                            <div class="col-md-4">
                                <label for="totalMarks" class="form-label">Total Marks</label>
                                <input type="number" class="form-control" id="totalMarks" min="10" value="100" required>
                            </div>
                            <div class="col-md-4">
                                <label for="passingMarks" class="form-label">Passing Marks</label>
                                <input type="number" class="form-control" id="passingMarks" min="1" value="40" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="examStatus" class="form-label">Status</label>
                                <select class="form-select" id="examStatus" required>
                                    <option value="draft">Draft</option>
                                    <option value="pending">Pending</option>
                                    <option value="published">Published</option>
                                    <option value="closed">Closed</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Exam Settings</label>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="shuffleQuestions">
                                        <label class="form-check-label" for="shuffleQuestions">Shuffle Questions</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="shuffleOptions">
                                        <label class="form-check-label" for="shuffleOptions">Shuffle Answer Options</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="showResults">
                                        <label class="form-check-label" for="showResults">Show Results After Submission</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="allowReview">
                                        <label class="form-check-label" for="allowReview">Allow Review of Answers</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="preventBacktracking">
                                        <label class="form-check-label" for="preventBacktracking">Prevent Backtracking</label>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" id="requireWebcam">
                                        <label class="form-check-label" for="requireWebcam">Require Webcam</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveExamBtn">Save Exam</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add/Edit Question Modal -->
    <div class="modal fade" id="questionModal" tabindex="-1" aria-labelledby="questionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="questionModalLabel">Add New Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="questionForm">
                        <input type="hidden" id="questionId">
                        <input type="hidden" id="questionExamId">
                        
                        <div class="mb-3">
                            <label for="questionText" class="form-label">Question Text</label>
                            <textarea class="form-control" id="questionText" rows="3" required></textarea>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="questionType" class="form-label">Question Type</label>
                                <select class="form-select" id="questionType">
                                    <option value="multiple_choice">Multiple Choice</option>
                                    <option value="true_false">True/False</option>
                                    <option value="short_answer">Short Answer</option>
                                    <option value="essay">Essay</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label for="questionMarks" class="form-label">Marks</label>
                                <input type="number" class="form-control" id="questionMarks" min="1" value="5" required>
                            </div>
                            <div class="col-md-3">
                                <label for="difficultyLevel" class="form-label">Difficulty</label>
                                <select class="form-select" id="difficultyLevel">
                                    <option value="1">Easy</option>
                                    <option value="2" selected>Medium</option>
                                    <option value="3">Hard</option>
                                </select>
                            </div>
                        </div>
                        
                        <!-- Options for multiple choice questions -->
                        <div id="optionsContainer">
                            <div class="mb-3">
                                <label class="form-label">Answer Options</label>
                                <div id="optionsList">
                                    <!-- Options will be populated dynamically -->
                                    <div class="d-flex align-items-center mb-2 option-item">
                                        <span class="me-2">A.</span>
                                        <div class="input-group">
                                            <input type="text" class="form-control" placeholder="Enter option" value="Option A">
                                            <div class="input-group-text">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption" checked>
                                            </div>
                                            <button type="button" class="btn btn-outline-danger remove-option">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center mb-2 option-item">
                                        <span class="me-2">B.</span>
                                        <div class="input-group">
                                            <input type="text" class="form-control" placeholder="Enter option" value="Option B">
                                            <div class="input-group-text">
                                                <input class="form-check-input mt-0" type="radio" name="correctOption">
                                            </div>
                                            <button type="button" class="btn btn-outline-danger remove-option">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-primary mt-2" id="addNewOption">
                                    <i class="fas fa-plus me-2"></i> Add Option
                                </button>
                            </div>
                        </div>
                        
                        <!-- True/False options -->
                        <div id="trueFalseContainer" style="display:none;">
                            <div class="mb-3">
                                <label class="form-label">Correct Answer</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="trueFalseOption" id="optionTrue" value="true" checked>
                                    <label class="form-check-label" for="optionTrue">True</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="trueFalseOption" id="optionFalse" value="false">
                                    <label class="form-check-label" for="optionFalse">False</label>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Short answer / Essay -->
                        <div id="shortAnswerContainer" style="display:none;">
                            <div class="mb-3">
                                <label for="correctAnswer" class="form-label">Model Answer / Grading Criteria</label>
                                <textarea class="form-control" id="correctAnswer" rows="5" placeholder="Enter the model answer or grading criteria here..."></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveQuestionBtn">Save Question</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" id="deleteItemId">
                    <input type="hidden" id="deleteItemType">
                    <input type="hidden" id="deleteExamId">
                    
                    <div class="text-center mb-4">
                        <i class="fas fa-exclamation-triangle text-warning" style="font-size: 4rem;"></i>
                    </div>
                    
                    <p>Are you sure you want to delete the following item?</p>
                    <p class="fw-bold" id="deleteItemName">Item Name</p>
                    <p>This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDelete">Delete</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Admin Dashboard JavaScript -->
    <script>
    // Fixed, direct implementation of sidebar toggle function
    document.addEventListener('DOMContentLoaded', function() {
        console.log("DOM loaded - initializing sidebar toggle");
        
        // Define the toggle function
        function toggleSidebar() {
            console.log("Toggle sidebar clicked");
            var sidebar = document.getElementById('sidebar');
            var mainContent = document.getElementById('main-content');
            
            // Toggle the collapsed class
            sidebar.classList.toggle('sidebar-collapsed');
            mainContent.classList.toggle('main-content-expanded');
            
            // Update styles based on state
            if (sidebar.classList.contains('sidebar-collapsed')) {
                console.log("Sidebar is now collapsed");
                // Update menu items
                var menuItems = document.querySelectorAll('.menu-item i');
                for (var i = 0; i < menuItems.length; i++) {
                    menuItems[i].style.marginRight = '0';
                }
                
                // Hide text elements
                var menuTexts = document.querySelectorAll('.menu-text');
                for (var i = 0; i < menuTexts.length; i++) {
                    menuTexts[i].style.display = 'none';
                }
                
                // Hide logo text
                var headerSpans = document.querySelectorAll('.sidebar-header h3 span');
                for (var i = 0; i < headerSpans.length; i++) {
                    headerSpans[i].style.display = 'none';
                }
            } else {
                console.log("Sidebar is now expanded");
                // Restore menu items
                var menuItems = document.querySelectorAll('.menu-item i');
                for (var i = 0; i < menuItems.length; i++) {
                    menuItems[i].style.marginRight = '15px';
                }
                
                // Show text elements
                var menuTexts = document.querySelectorAll('.menu-text');
                for (var i = 0; i < menuTexts.length; i++) {
                    menuTexts[i].style.display = 'inline';
                }
                
                // Show logo text
                var headerSpans = document.querySelectorAll('.sidebar-header h3 span');
                for (var i = 0; i < headerSpans.length; i++) {
                    headerSpans[i].style.display = 'inline';
                }
            }
        }
        
        // Attach the event listener
        var menuToggle = document.getElementById('menu-toggle');
        if (menuToggle) {
            console.log("Menu toggle button found, attaching event listener");
            menuToggle.addEventListener('click', toggleSidebar);
        } else {
            console.error("Menu toggle button not found");
        }
        
        // Also try jQuery approach as fallback
        if (typeof jQuery !== 'undefined') {
            console.log("jQuery is available, adding alternate toggle handler");
            $('#menu-toggle').on('click', function() {
                console.log("jQuery toggle handler fired");
                toggleSidebar();
            });
        }
    });
    </script>
    
    <!-- Load the regular admin functionality -->
    <script src="${pageContext.request.contextPath}/js/adminExams.js"></script>
</body>
</html>