<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Teacher Dashboard - Exam Management System</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <style>
        :root {
            --primary-color: #4e73df;
            --primary-dark: #3a56c5;
            --secondary-color: #6d5cae;
            --secondary-dark: #5a4a90;
            --light-color: #f8f9fa;
            --dark-color: #343a40;
            --success-color: #28a745;
            --warning-color: #ffc107;
            --danger-color: #dc3545;
            --info-color: #17a2b8;
        }
        
        body {
            font-family: 'Nunito', sans-serif;
            background-color: #f5f7fa;
            overflow-x: hidden;
        }
        
        /* Logo */
        #logo {
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
        
        .sidebar-collapsed #logo {
            opacity: 0;
            visibility: hidden;
            display: none !important;
        }
        
        /* IMPORTANT: Add these CSS fixes to ensure the toggle works properly */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 250px;
            background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
            color: white;
            z-index: 1050; /* Make sure it's above other elements */
            transition: width 0.3s ease, left 0.3s ease, transform 0.3s ease;
            will-change: width, left, transform; /* Performance optimization */
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        
        .sidebar-collapsed {
            width: 70px !important; /* Use !important to override any conflicts */
        }
        
        .sidebar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }
        
        .sidebar-header h3 {
            margin: 0;
            font-weight: 700;
            transition: all 0.3s ease;
        }
        
        .menu-list {
            padding: 0;
            list-style: none;
        }
        
        .menu-item {
            padding: 12px 20px;
            transition: all 0.3s ease;
            border-left: 3px solid transparent;
            display: flex;
            align-items: center;
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
            transition: all 0.3s ease;
            white-space: nowrap;
        }
        
        .sidebar-collapsed .menu-text {
            opacity: 0;
            width: 0;
            height: 0;
            overflow: hidden;
            display: none !important; /* Added important to ensure text doesn't take space when collapsed */
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
            transition: margin-left 0.3s ease;
            will-change: margin-left; /* Performance optimization */
        }
        
        .main-content-expanded {
            margin-left: 70px !important; /* Use !important to override any conflicts */
        }
        
        /* Navbar */
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
        
        .notification-bell {
            position: relative;
            margin-right: 20px;
            cursor: pointer;
        }
        
        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: var(--danger-color);
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
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
        
        /* Dashboard Cards */
        .dashboard-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-bottom: 30px;
            transition: all 0.3s;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .dashboard-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        
        .card-title {
            font-weight: 700;
            margin-bottom: 15px;
            color: #333;
            display: flex;
            align-items: center;
        }
        
        .card-title i {
            margin-right: 10px;
            color: var(--primary-color);
        }
        
        .badge-custom {
            padding: 5px 10px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.7rem;
        }
        
        .badge-upcoming {
            background-color: rgba(23, 162, 184, 0.2);
            color: var(--info-color);
        }
        
        .badge-ongoing {
            background-color: rgba(255, 193, 7, 0.2);
            color: var(--warning-color);
        }
        
        .badge-completed {
            background-color: rgba(40, 167, 69, 0.2);
            color: var(--success-color);
        }
        
        .badge-draft {
            background-color: rgba(108, 117, 125, 0.2);
            color: #6c757d;
        }
        
        /* Exam List */
        .exam-item {
            display: flex;
            align-items: center;
            padding: 15px;
            border-left: 3px solid transparent;
            transition: all 0.3s;
            margin-bottom: 10px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        
        .exam-item:hover {
            background-color: rgba(78, 115, 223, 0.05);
            border-left-color: var(--primary-color);
        }
        
        .exam-icon {
            width: 45px;
            height: 45px;
            border-radius: 10px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            margin-right: 15px;
            font-size: 1.2rem;
        }
        
        .exam-info {
            flex: 1;
        }
        
        .exam-title {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .exam-subtitle {
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        .exam-time {
            text-align: right;
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        /* Performance Card */
        .performance-stats {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        
        .stat-item {
            text-align: center;
            padding: 10px;
            flex: 1;
            border-right: 1px solid #eee;
        }
        
        .stat-item:last-child {
            border-right: none;
        }
        
        .stat-value {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .stat-label {
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        /* Announcements */
        .announcement-item {
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }
        
        .announcement-item:last-child {
            border-bottom: none;
        }
        
        .announcement-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        
        .announcement-title {
            font-weight: 600;
        }
        
        .announcement-date {
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        .announcement-content {
            font-size: 0.9rem;
            color: #555;
        }
        
        /* To-Do List */
        .todo-item {
            display: flex;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #eee;
        }
        
        .todo-item:last-child {
            border-bottom: none;
        }
        
        .todo-checkbox {
            margin-right: 10px;
        }
        
        .todo-text {
            flex: 1;
        }
        
        .todo-date {
            font-size: 0.8rem;
            color: #6c757d;
        }
        
        .todo-completed {
            text-decoration: line-through;
            color: #6c757d;
        }
        
        /* Progress Bars */
        .progress {
            height: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
        }
        
        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 0.8rem;
            margin-bottom: 5px;
        }
        
        .progress-subject {
            font-weight: 600;
        }
        
        /* Quick Action Buttons */
        .quick-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .quick-action-btn {
            flex: 1;
            min-width: 120px;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 10px;
            transition: all 0.3s;
            border: 1px solid #eee;
            cursor: pointer;
        }
        
        .quick-action-btn:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            background-color: rgba(78, 115, 223, 0.05);
        }
        
        .quick-action-icon {
            font-size: 1.5rem;
            margin-bottom: 10px;
            color: var(--primary-color);
        }
        
        .quick-action-text {
            font-size: 0.85rem;
            font-weight: 600;
            text-align: center;
        }
        
        /* Current Date Display */
        .current-date {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: rgba(255, 255, 255, 0.95);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 10px 15px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            z-index: 1000;
        }
        
        .current-date i {
            margin-right: 5px;
            color: var(--primary-color);
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
                display: none;
            }
            
            .main-content {
                margin-left: 70px;
            }
            
            .sidebar-header h3 {
                display: none;
            }
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0 !important; /* Always full width on mobile */
                padding: 10px;
            }
            
            .sidebar:not(.active) {
                left: -70px !important; /* Force sidebar offscreen on mobile when not active */
            }
            
            .sidebar.active {
                left: 0 !important; /* Force sidebar onscreen when active */
            }
            
            .top-navbar {
                margin-bottom: 20px;
            }
            
            .dashboard-card {
                margin-bottom: 20px;
            }
            
            .performance-stats {
                flex-direction: column;
            }
            
            .stat-item {
                border-right: none;
                border-bottom: 1px solid #eee;
                padding: 10px 0;
            }
            
            .stat-item:last-child {
                border-bottom: none;
            }
        }

        /* Welcome animation */
        .welcome-message {
            animation: fadeInUp 1s ease-out;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* Status indicators */
        .status-indicator {
            display: inline-block;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            margin-right: 5px;
        }
        
        .status-active {
            background-color: var(--success-color);
        }
        
        .exam-deadline {
            font-size: 0.9rem;
            color: var(--info-color);
            font-weight: 600;
            margin-top: 5px;
        }
        
        /* Custom teacher dashboard styles */
        .student-count {
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 5px;
        }
        
        .status-draft {
            background-color: #6c757d;
        }
        
        .status-published {
            background-color: var(--success-color);
        }
        
        .status-in-progress {
            background-color: var(--warning-color);
        }
        
        .status-completed {
            background-color: var(--info-color);
        }
        
        .course-card {
            border-radius: 10px;
            overflow: hidden;
            transition: all 0.3s;
            margin-bottom: 20px;
            position: relative;
        }
        
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        
        .course-banner {
            height: 100px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            position: relative;
            overflow: hidden;
        }
        
        .course-banner i {
            position: absolute;
            font-size: 120px;
            opacity: 0.1;
            right: -20px;
            bottom: -40px;
            color: white;
        }
        
        .course-content {
            padding: 15px;
            background-color: white;
        }
        
        .course-title {
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .course-students {
            font-size: 0.8rem;
            color: #6c757d;
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .course-students i {
            margin-right: 5px;
        }
        
        .stat-card {
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
            position: relative;
            overflow: hidden;
            background-color: white;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            transition: all 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        
        .stat-card-icon {
            position: absolute;
            top: 20px;
            right: 20px;
            font-size: 40px;
            opacity: 0.2;
        }
        
        .stat-card-value {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .stat-card-title {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 0;
        }
    </style>
</head>
<body>

    <!-- Sidebar -->
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3><i class="fas fa-graduation-cap me-2 "></i></h3>
            <h3 id="logo">Exam Pro</h3>
        </div>
        
        <ul class="menu-list">
            <li class="menu-item active">
             <a href="teacher_dashboard.jsp" style="color: white; text-decoration: none;">
                <i class="fas fa-tachometer-alt"></i>
                <span class="menu-text">Dashboard</span>
                </a>
            </li>
            
            <li class="menu-item">
            <a href="create-exam.jsp" style="color: white; text-decoration: none;">
                <i class="fas fa-edit"></i>
                <span class="menu-text">Create Exam</span>
                </a>
            </li>
                        
            <li class="menu-item">
            <a href="ViewExamsServlet" style="color: white; text-decoration: none;">
                <i class="fas fa-tasks"></i>
                <span class="menu-text">Manage Exams</span>
                </a>
            </li>
        
            <li class="menu-item">
            <a href="teacheruser_settings.jsp" style="color: white; text-decoration: none;">
                <i class="fas fa-trophy"></i>
                <span class="menu-text">Leader Board</span>
                </a>
            </li>
                      
            <li class="menu-item">
             <a href="teacheruser_settings.jsp" style="color: white; text-decoration: none;">
                <i class="fas fa-cog"></i>
                <span class="menu-text">Settings</span>
                </a>
            </li>   
        </ul>
        
        <div class="sidebar-footer">
            <a href="login.jsp?action=logout" style="color: white; text-decoration: none;">
                <i class="fas fa-sign-out-alt"></i>
                <span class="menu-text">Logout</span>
            </a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content" id="main-content">
        <!-- Top Navbar -->
        <div class="top-navbar">
            <button class="menu-toggle" id="menu-toggle">
                <i class="fas fa-bars"></i>
            </button>
            
            <div class="user-menu">
                <div class="notification-bell">
                    
                </div>
                
                <div class="user-info">
                    <img src="<c:out value='${sessionScope.user.profileImage}' default='./assets/images/student/default.jpg'/>" alt="User" class="user-avatar">
                    <div>
                        <div class="user-name">${sessionScope.fullName}</div>
                        <small class="text-muted">${sessionScope.userId}</small>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Dashboard Content -->
        <div class="row">
            <!-- Welcome Message -->
            <div class="col-12">
                <div class="dashboard-card welcome-message">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h4>Welcome to ExamPro, ${sessionScope.user.firstName}!</h4>
                        <span class="badge bg-success">New</span>
                    </div>
                    <p>Your teacher account has been successfully created. Start creating exams and managing your courses from this dashboard.</p>
                    <div class="d-flex align-items-center mb-3">
                        <div class="status-indicator status-active"></div>
                        <span>Account status: <strong>Active</strong></span>
                    </div>
                    
                    <div class="quick-actions">
                        <div class="quick-action-btn"><a href="./create-exam.jsp" style="text-decoration: none; color: inherit; display: flex; flex-direction: column; align-items: center; width: 100%;">
                            <div class="quick-action-icon">
                                <i class="fas fa-edit"></i>
                            </div>
                        <div class="quick-action-text">Create Exam</div>
                        </a>
                    </div>
                        
                        <div class="quick-action-btn">
                             <a href="./ViewExamsServlet" style="text-decoration: none; color: inherit; display: flex; flex-direction: column; align-items: center; width: 100%;">
            					<div class="quick-action-icon">
                				<i class="fas fa-book"></i>
            				</div>
            				<div class="quick-action-text">Manage Exams</div>
        				</a>
    				</div>                                       
                        <div class="quick-action-btn">
                            <div class="quick-action-icon">
                                <i class="fas fa-chart-bar"></i>
                            </div>
                            <div class="quick-action-text">Leader Board</div>
                        </div>
                        
                        <div class="quick-action-btn">
                            <div class="quick-action-icon">
                                <i class="fas fa-file-alt"></i>
                            </div>
                            <div class="quick-action-text">Question Bank</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Stats Row -->
            <div class="col-12">
                <div class="row">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card" style="border-left: 5px solid #4e73df;">
                            <div class="stat-card-value">4</div>
                            <div class="stat-card-title">Active Courses</div>
                            <div class="stat-card-icon" style="color: #4e73df;">
                                <i class="fas fa-book"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card" style="border-left: 5px solid #1cc88a;">
                            <div class="stat-card-value">126</div>
                            <div class="stat-card-title">Total Students</div>
                            <div class="stat-card-icon" style="color: #1cc88a;">
                                <i class="fas fa-users"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card" style="border-left: 5px solid #f6c23e;">
                            <div class="stat-card-value">12</div>
                            <div class="stat-card-title">Upcoming Exams</div>
                            <div class="stat-card-icon" style="color: #f6c23e;">
                                <i class="fas fa-clipboard-list"></i>
                            </div>
                        </div>
                    </div>
                    
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="stat-card" style="border-left: 5px solid #36b9cc;">
                            <div class="stat-card-value">28</div>
                            <div class="stat-card-title">Exams to Grade</div>
                            <div class="stat-card-icon" style="color: #36b9cc;">
                                <i class="fas fa-clipboard-check"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Exam Management -->
            <div class="col-lg-8">
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-tasks"></i>
                        Exam Management
                    </div>
                    
                    <div class="exam-list">
                        <div class="exam-item">
                            <div class="exam-icon">
                                <i class="fas fa-database"></i>
                            </div>
                            <div class="exam-info">
                                <div class="exam-title">Database Systems Midterm</div>
                                <div class="exam-subtitle">CS-301 • 42 students enrolled</div>
                                <div class="exam-deadline">Published: Ready for students</div>
                            </div>
                            <div class="exam-time">
                                <span class="badge badge-custom badge-upcoming">Upcoming</span>
                                <div>2025-03-25</div>
                                <div>09:00 - 11:00 AM</div>
                            </div>
                        </div>
                        
                        <div class="exam-item">
                            <div class="exam-icon">
                                <i class="fas fa-laptop-code"></i>
                            </div>
                            <div class="exam-info">
                                <div class="exam-title">Java Programming Final</div>
                                <div class="exam-subtitle">CS-205 • 36 students enrolled</div>
                                <div class="exam-deadline">Draft: Not yet published</div>
                            </div>
                            <div class="exam-time">
                                <span class="badge badge-custom badge-draft">Draft</span>
                                <div>2025-04-15</div>
                                <div>02:00 - 04:30 PM</div>
                            </div>
                        </div>
                        
                        <div class="exam-item">
                            <div class="exam-icon">
                                <i class="fas fa-network-wired"></i>
                            </div>
                            <div class="exam-info">
                                <div class="exam-title">Computer Networks Quiz</div>
                                <div class="exam-subtitle">CS-420 • 28 students enrolled</div>
                                <div class="exam-deadline">In Progress: 15 submissions received</div>
                            </div>
                            <div class="exam-time">
                                <span class="badge badge-custom badge-ongoing">In Progress</span>
                                <div>Ends Today</div>
                                <div>11:59 PM</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-3 text-center">
                        <a href="#" class="btn btn-sm btn-outline-primary">View All Exams</a>
                    </div>
                </div>
                
                <!-- My Courses Section -->
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-chalkboard"></i>
                        My Courses
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="course-card">
                                <div class="course-banner">
                                    <i class="fas fa-database"></i>
                                </div>
                                <div class="course-content">
                                    <div class="course-title">Database Systems</div>
                                    <div class="course-students">
                                        <i class="fas fa-users"></i> 42 Students
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span class="badge bg-success">Active</span>
                                        <button class="btn btn-sm btn-outline-primary">Manage</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="course-card">
                                <div class="course-banner">
                                    <i class="fas fa-laptop-code"></i>
                                </div>
                                <div class="course-content">
                                    <div class="course-title">Java Programming</div>
                                    <div class="course-students">
                                        <i class="fas fa-users"></i> 36 Students
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span class="badge bg-success">Active</span>
                                        <button class="btn btn-sm btn-outline-primary">Manage</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="course-card">
                                <div class="course-banner">
                                    <i class="fas fa-network-wired"></i>
                                </div>
                                <div class="course-content">
                                    <div class="course-title">Computer Networks</div>
                                    <div class="course-students">
                                        <i class="fas fa-users"></i> 28 Students
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span class="badge bg-success">Active</span>
                                        <button class="btn btn-sm btn-outline-primary">Manage</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="course-card">
                                <div class="course-banner">
                                    <i class="fas fa-shield-alt"></i>
                                </div>
                                <div class="course-content">
                                    <div class="course-title">Cybersecurity Fundamentals</div>
                                    <div class="course-students">
                                        <i class="fas fa-users"></i> 20 Students
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <span class="badge bg-success">Active</span>
                                        <button class="btn btn-sm btn-outline-primary">Manage</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-3 text-center">
                        <a href="#" class="btn btn-sm btn-outline-primary">View All Courses</a>
                    </div>
                </div>
            </div>
            
            <!-- Side Widgets -->
            <div class="col-lg-4">
                <!-- Teacher Information -->
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-chalkboard-teacher"></i>
                        Teacher Information
                    </div>
                    
                    <table class="table table-borderless">
                        <tr>
                            <td><strong>Name:</strong></td>
                            <td>${sessionScope.user.firstName} ${sessionScope.user.lastName}</td>
                        </tr>
                        <tr>
                            <td><strong>ID:</strong></td>
                            <td>${sessionScope.userId}</td>
                        </tr>
                        <tr>
                            <td><strong>Department:</strong></td>
                            <td>${sessionScope.user.teacherDetails.department}</td>
                        </tr>
                        <tr>
                            <td><strong>Designation:</strong></td>
                            <td>${sessionScope.user.teacherDetails.designation}</td>
                        </tr>
                        <tr>
                            <td><strong>Employee ID:</strong></td>
                            <td>${sessionScope.user.teacherDetails.employeeId}</td>
                        </tr>
                        <tr>
                            <td><strong>Specialization:</strong></td>
                            <td>${sessionScope.user.teacherDetails.specialization}</td>
                        </tr>
                    </table>
                    
                    <div class="mt-3 text-center">
                        <a href="teacheruser_settings.jsp" class="btn btn-sm btn-outline-primary">Edit Profile</a>
                    </div>
                </div>
                
                <!-- Pending Actions -->
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-clipboard-check"></i>
                        Pending Actions
                    </div>
                    
                    <div class="todo-list">
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo1">
                            <div class="todo-text">Grade Computer Networks Quiz (28 submissions)</div>
                            <div class="todo-date">Today</div>
                        </div>
                        
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo2">
                            <div class="todo-text">Finalize Java Programming Final Exam</div>
                            <div class="todo-date">2025-03-21</div>
                        </div>
                        
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo3">
                            <div class="todo-text">Submit midterm grades to administration</div>
                            <div class="todo-date">2025-03-22</div>
                        </div>
                        
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo4">
                            <div class="todo-text">Create review materials for Database Systems</div>
                            <div class="todo-date">2025-03-24</div>
                        </div>
                        
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo5">
                            <div class="todo-text">Department meeting - Exam standardization</div>
                            <div class="todo-date">2025-03-25</div>
                        </div>
                    </div>
                    
                    <div class="progress-bar-container mt-3">
                        <div class="progress-label">
                            <span>Tasks Completion</span>
                            <span>20%</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-success" role="progressbar" style="width: 20%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Academic Calendar -->
            <div class="col-12">
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-calendar-alt"></i>
                        Academic Calendar - Important Dates
                    </div>
                    
                    <div class="row">
                        <div class="col-md-3 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">Midterm Exams</h5>
                                    <p class="card-text">2025-04-10 to 2025-04-20</p>
                                    <div class="d-flex align-items-center">
                                        <div class="status-indicator" style="background-color: #f6c23e;"></div>
                                        <span class="small text-muted">21 days remaining</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">Result Declaration</h5>
                                    <p class="card-text">2025-05-01</p>
                                    <div class="d-flex align-items-center">
                                        <div class="status-indicator" style="background-color: #4e73df;"></div>
                                        <span class="small text-muted">42 days remaining</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">Final Exams</h5>
                                    <p class="card-text">2025-07-01 to 2025-07-15</p>
                                    <div class="d-flex align-items-center">
                                        <div class="status-indicator" style="background-color: #36b9cc;"></div>
                                        <span class="small text-muted">103 days remaining</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title">Summer Break</h5>
                                    <p class="card-text">2025-07-20 to 2025-08-31</p>
                                    <div class="d-flex align-items-center">
                                        <div class="status-indicator" style="background-color: #1cc88a;"></div>
                                        <span class="small text-muted">122 days remaining</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-3 text-center">
                        <a href="#" class="btn btn-sm btn-outline-primary">View Full Calendar</a>
                    </div>
                </div>
            </div>
            
            <!-- Help & Resources -->
            <div class="col-12 mb-4">
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-info-circle"></i>
                        Help & Resources
                    </div>
                    
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-book-open me-2 text-primary"></i>Teacher Guides</h5>
                                    <p class="card-text">Learn how to create and manage exams, grade submissions, and utilize the question bank.</p>
                                    <a href="#" class="btn btn-sm btn-outline-primary">View Guides</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-question-circle me-2 text-warning"></i>FAQ</h5>
                                    <p class="card-text">Find answers to frequently asked questions about exam creation, student management, and more.</p>
                                    <a href="#" class="btn btn-sm btn-outline-primary">View FAQs</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-headset me-2 text-info"></i>Support</h5>
                                    <p class="card-text">Need help? Contact our support team for assistance with any technical issues or questions.</p>
                                    <a href="#" class="btn btn-sm btn-outline-primary">Contact Support</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- Custom JS -->
<script>
    // SPECIAL FIX: Direct sidebar toggle implementation
    document.addEventListener('DOMContentLoaded', function() {
        console.log('DOM loaded - initializing sidebar functionality');
        
        // Direct sidebar toggle - guaranteed to work approach
        const menuToggle = document.getElementById('menu-toggle');
        if (menuToggle) {
            menuToggle.addEventListener('click', function(event) {
                event.preventDefault();
                console.log('Menu toggle clicked');
                
                const sidebar = document.getElementById('sidebar');
                const mainContent = document.getElementById('main-content');
                const logo = document.getElementById('logo');
                
                // Forcefully toggle classes regardless of previous state
                if (sidebar.classList.contains('sidebar-collapsed')) {
                    sidebar.classList.remove('sidebar-collapsed');
                    mainContent.classList.remove('main-content-expanded');
                    if (logo) logo.style.display = '';
                } else {
                    sidebar.classList.add('sidebar-collapsed');
                    mainContent.classList.add('main-content-expanded');
                    if (logo) logo.style.display = 'none';
                }
                
                // For mobile specific behavior
                if (window.innerWidth <= 768) {
                    sidebar.classList.toggle('active');
                }
                
                console.log('Sidebar toggle complete. Collapsed:', sidebar.classList.contains('sidebar-collapsed'));
            });
        } else {
            console.error('Menu toggle button not found');
        }
        
        // Initialize responsive behavior
        handleWindowResize();
        
        // Initialize date/time
        updateDateTime();
        
        // Initialize welcome animation
        const welcomeMessage = document.querySelector('.welcome-message');
        if (welcomeMessage) {
            welcomeMessage.classList.add('animate__animated', 'animate__fadeInDown');
        }
        
        // Initialize charts
        initializeCharts();
        
        // Initialize todo checkboxes
        initializeTodos();
        
        // Show welcome toast
        showWelcomeToast();
    });

    // Current Date and Time
    function updateDateTime() {
        const now = new Date();
        const year = now.getFullYear();
        const month = String(now.getMonth() + 1).padStart(2, '0');
        const day = String(now.getDate()).padStart(2, '0');
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const seconds = String(now.getSeconds()).padStart(2, '0');
        
        const formattedDate = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
        
        // Make sure the element exists before updating it
        const dateTimeElement = document.getElementById('currentDateTime');
        if (dateTimeElement) {
            dateTimeElement.innerHTML = '<i class="fas fa-calendar-alt"></i> <span>' + formattedDate + '</span>';
        }
        
        // Update every second
        setTimeout(updateDateTime, 1000);
    }

    // Simplified window resize handler
    function handleWindowResize() {
        const sidebar = document.getElementById('sidebar');
        const mainContent = document.getElementById('main-content');
        const logo = document.getElementById('logo');
        
        if (!sidebar || !mainContent) return;
        
        if (window.innerWidth <= 768) {
            // On mobile: hide sidebar by default
            sidebar.classList.add('sidebar-collapsed');
            mainContent.classList.add('main-content-expanded');
            if (logo) logo.style.display = 'none';
            sidebar.style.left = '-70px'; // Force sidebar off-screen
        } else if (window.innerWidth <= 992) {
            // On tablet: show collapsed sidebar
            sidebar.classList.add('sidebar-collapsed');
            mainContent.classList.add('main-content-expanded');
            if (logo) logo.style.display = 'none';
            sidebar.style.left = '0'; // Ensure sidebar is visible
        } else {
            // On desktop: expanded sidebar
            sidebar.classList.remove('sidebar-collapsed');
            mainContent.classList.remove('main-content-expanded');
            if (logo) logo.style.display = '';
            sidebar.style.left = '0'; // Ensure sidebar is visible
        }
    }
    
    // Initialize resize listener
    window.addEventListener('resize', handleWindowResize);
    
    // To-Do List functionality
    function initializeTodos() {
        const todoCheckboxes = document.querySelectorAll('.todo-checkbox');
        todoCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const todoText = this.nextElementSibling;
                if (this.checked) {
                    todoText.classList.add('todo-completed');
                } else {
                    todoText.classList.remove('todo-completed');
                }
                
                // Update progress bar
                updateProgressBar();
            });
        });
    }
    
    // Update progress bar function
    function updateProgressBar() {
        const totalTodos = document.querySelectorAll('.todo-checkbox').length;
        const completedTodos = document.querySelectorAll('.todo-checkbox:checked').length;
        const progressPercentage = Math.round((completedTodos / totalTodos) * 100);
        
        const progressBar = document.querySelector('.progress-bar');
        if (progressBar) {
            progressBar.style.width = progressPercentage + '%';
        }
        
        const progressLabel = document.querySelector('.progress-label span:last-child');
        if (progressLabel) {
            progressLabel.textContent = progressPercentage + '%';
        }
    }
    
    // Initialize charts
    function initializeCharts() {
        // Check if elements exist before initializing charts
        const questionTypeChartElement = document.getElementById('questionTypeChart');
        const difficultyChartElement = document.getElementById('questionDifficultyChart');
        
        if (questionTypeChartElement) {
            // Question Types Chart
            const ctxQuestionTypes = questionTypeChartElement.getContext('2d');
            const questionTypeChart = new Chart(ctxQuestionTypes, {
                type: 'pie',
                data: {
                    labels: ['Multiple Choice', 'Short Answer', 'Essay', 'True/False', 'Coding'],
                    datasets: [{
                        data: [45, 25, 10, 15, 5],
                        backgroundColor: [
                            '#4e73df',
                            '#1cc88a',
                            '#36b9cc',
                            '#f6c23e',
                            '#e74a3b'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        },
                        title: {
                            display: true,
                            text: 'Question Types Distribution'
                        }
                    }
                }
            });
        }
        
        if (difficultyChartElement) {
            // Question Difficulty Chart
            const ctxDifficulty = difficultyChartElement.getContext('2d');
            const difficultyChart = new Chart(ctxDifficulty, {
                type: 'bar',
                data: {
                    labels: ['Easy', 'Medium', 'Hard', 'Expert'],
                    datasets: [{
                        label: 'Question Count',
                        data: [120, 210, 90, 30],
                        backgroundColor: [
                            '#1cc88a',
                            '#4e73df',
                            '#f6c23e',
                            '#e74a3b'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: false
                        },
                        title: {
                            display: true,
                            text: 'Question Difficulty Distribution'
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
    }
    
    // Initialize quick action buttons
    document.addEventListener('DOMContentLoaded', function() {
        const quickActionBtns = document.querySelectorAll('.quick-action-btn');
        quickActionBtns.forEach(btn => {
            btn.addEventListener('mouseover', function() {
                const iconElement = this.querySelector('.quick-action-icon');
                if (iconElement) {
                    iconElement.classList.add('animate__animated', 'animate__heartBeat');
                }
            });
            
            btn.addEventListener('mouseout', function() {
                const iconElement = this.querySelector('.quick-action-icon');
                if (iconElement) {
                    iconElement.classList.remove('animate__animated', 'animate__heartBeat');
                }
            });
        });
    });
</script>
</body>
</html>