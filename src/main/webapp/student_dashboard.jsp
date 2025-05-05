<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - Exam Management System</title>
    
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
            --primary-color: #667eea;
            --primary-dark: #5a6ecd;
            --secondary-color: #764ba2;
            --secondary-dark: #6a439a;
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
            display: none;
        }
        
        /* Sidebar */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: 250px;
            background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
            color: white;
            z-index: 1000;
            transition: all 0.3s ease;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        
        .sidebar-collapsed {
            width: 70px;
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
            display: none; /* Added to ensure text doesn't take space when collapsed */
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
        }
        
        .main-content-expanded {
            margin-left: 70px;
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
            background-color: rgba(102, 126, 234, 0.05);
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
            background-color: rgba(102, 126, 234, 0.05);
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
                margin-left: 0;
                padding: 10px;
            }
            
            .sidebar {
                left: -70px;
                transition: left 0.3s ease;
            }
            
            .sidebar.active {
                left: 0;
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
        
        .exam-countdown {
            font-size: 0.9rem;
            color: var(--info-color);
            font-weight: 600;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    
 <!-- Sidebar -->
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3><i class="fas fa-graduation-cap me-2"></i></h3>
            <h3 id="logo">Exam Pro</h3>
        </div>
        
        <ul class="menu-list">
            <li class="menu-item active">
                <a href="student_dashboard.jsp" class="nav-link">
                    <i class="fas fa-tachometer-alt"></i>
                    <span class="menu-text">Dashboard</span>
                </a>
            </li>
            
            <li class="menu-item">
                <a href="exams" class="nav-link">
                    <i class="fas fa-book"></i>
                    <span class="menu-text">My Exams</span>
                </a>
            </li>
           
            <li class="menu-item">
                <a href="leaderboard.jsp" class="nav-link">
                    <i class="fas fa-trophy"></i>
                    <span class="menu-text">Leaderboard</span>
                </a>
            </li>
            
            <li class="menu-item">
                <i class="fas fa-file-alt"></i>
                <span class="menu-text">Study Materials</span>
            </li>
            
            <li class="menu-item">
                <a href="user_settings.jsp" style="color: white; text-decoration: none;">
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
                        <div class="user-name"><c:out value="${sessionScope.fullName}" default="Student"/></div>
                       <small class="text-muted"><c:out value="${sessionScope.user.userId}" default="IT24102083"/></small>
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
                    <p>Your student account has been successfully created. Start exploring the platform to manage your exams and track your academic progress.</p>
                    <div class="d-flex align-items-center mb-3">
                        <div class="status-indicator status-active"></div>
                        <span>Account status: <strong>Active</strong></span>
                    </div>
                    
                    <div class="quick-actions">
                        <div class="quick-action-btn">
                            <div class="quick-action-icon">
                                <i class="fas fa-edit"></i>
                            </div>
                            <div class="quick-action-text">Complete Profile</div>
                        </div>
                        
                        <div class="quick-action-btn">
                            <div class="quick-action-icon">
                                <i class="fas fa-book"></i>
                            </div>
                            <div class="quick-action-text">View Exams</div>
                        </div>
                        
                        <div class="quick-action-btn">
                            <div class="quick-action-icon">
                                <i class="fas fa-trophy"></i>
                            </div>
                            <div class="quick-action-text">Leader board</div>
                        </div>
                        
                        <div class="quick-action-btn">
                            <div class="quick-action-icon">
                                <i class="fas fa-file-alt"></i>
                            </div>
                            <div class="quick-action-text">Study Materials</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Upcoming Exams -->
            <div class="col-lg-8">
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-clipboard-list"></i>
                        Upcoming Exams
                    </div>
                    
                    <div class="exam-list">
                        <div class="exam-item">
                            <div class="exam-icon">
                                <i class="fas fa-database"></i>
                            </div>
                            <div class="exam-info">
                                <div class="exam-title">Introduction to ${sessionScope.user.studentDetails.course}</div>
                                <div class="exam-subtitle">CSE-101 • Prof. Sarah Johnson</div>
                                <div class="exam-countdown">Registration open: 5 days remaining</div>
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
                                <div class="exam-title">Programming Fundamentals</div>
                                <div class="exam-subtitle">CSE-102 • Prof. Michael Lee</div>
                                <div class="exam-countdown">Registration open: 2 weeks remaining</div>
                            </div>
                            <div class="exam-time">
                                <span class="badge badge-custom badge-upcoming">Upcoming</span>
                                <div>2025-04-05</div>
                                <div>02:00 - 04:30 PM</div>
                            </div>
                        </div>
                        
                        <div class="exam-item">
                            <div class="exam-icon">
                                <i class="fas fa-calculator"></i>
                            </div>
                            <div class="exam-info">
                                <div class="exam-title">Mathematics for ${sessionScope.user.studentDetails.course}</div>
                                <div class="exam-subtitle">MTH-101 • Prof. Robert Miller</div>
                                <div class="exam-countdown">Registration open: 3 weeks remaining</div>
                            </div>
                            <div class="exam-time">
                                <span class="badge badge-custom badge-upcoming">Upcoming</span>
                                <div>2025-04-12</div>
                                <div>10:00 - 12:00 PM</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mt-3 text-center">
                        <a href="#" class="btn btn-sm btn-outline-primary">View All Exams</a>
                    </div>
                </div>
                
                <!-- Recommended Materials -->
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-book"></i>
                        Recommended Study Materials
                    </div>
                    
                    <div class="exam-list">
                        <div class="exam-item">
                            <div class="exam-icon">
                                <i class="fas fa-book-open"></i>
                            </div>
                            <div class="exam-info">
                                <div class="exam-title">Getting Started with ${sessionScope.user.studentDetails.course}</div>
                                <div class="exam-subtitle">Orientation Materials • Semester ${sessionScope.user.studentDetails.semester}</div>
                            </div>
                            <div class="exam-time">
                                <a href="#" class="btn btn-sm btn-outline-primary">View</a>
                            </div>
                        </div>
                        
                        <div class="exam-item">
                            <div class="exam-icon">
                                <i class="fas fa-video"></i>
                            </div>
                            <div class="exam-info">
                                <div class="exam-title">Video Tutorials: Core Concepts</div>
                                <div class="exam-subtitle">Foundation Series • 12 Videos</div>
                            </div>
                            <div class="exam-time">
                                <a href="#" class="btn btn-sm btn-outline-primary">Watch</a>
                            </div>
                        </div>
                        
                        <div class="exam-item">
                            <div class="exam-icon">
                                <i class="fas fa-file-pdf"></i>
                            </div>
                            <div class="exam-info">
                                <div class="exam-title">Course Handbook</div>
                                <div class="exam-subtitle">Department of ${sessionScope.user.studentDetails.course} • 2025 Edition</div>
                            </div>
                            <div class="exam-time">
                                <a href="#" class="btn btn-sm btn-outline-primary">Download</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Side Widgets -->
            <div class="col-lg-4">
                <!-- Student Information -->
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-user-graduate"></i>
                        Student Information
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
                            <td><strong>Program:</strong></td>
                            <td>${sessionScope.user.studentDetails.course}</td>
                        </tr>
                        <tr>
                            <td><strong>Semester:</strong></td>
                            <td>${sessionScope.user.studentDetails.semester}</td>
                        </tr>
                        <tr>
                            <td><strong>Enrollment:</strong></td>
                            <td>${sessionScope.user.studentDetails.enrollmentNumber}</td>
                        </tr>
                        <tr>
                            <td><strong>Batch:</strong></td>
                            <td>${sessionScope.user.studentDetails.batchId}</td>
                        </tr>
                    </table>
                    
                    <div class="mt-3 text-center">
                        <a href="user_settings.jsp" class="btn btn-sm btn-outline-primary">Edit Profile</a>
                    </div>
                </div>
                
            
                <!-- To-Do List -->
                <div class="dashboard-card">
                    <div class="card-title">
                        <i class="fas fa-tasks"></i>
                        Getting Started
                    </div>
                    
                    <div class="todo-list">
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo1">
                            <div class="todo-text">Complete your profile</div>
                            <div class="todo-date">Today</div>
                        </div>
                        
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo2">
                            <div class="todo-text">Verify your email address</div>
                            <div class="todo-date">Today</div>
                        </div>
                        
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo3">
                            <div class="todo-text">Set up notification preferences</div>
                            <div class="todo-date">2025-03-20</div>
                        </div>
                        
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo4">
                            <div class="todo-text">View course schedule</div>
                            <div class="todo-date">2025-03-21</div>
                        </div>
                        
                        <div class="todo-item">
                            <input type="checkbox" class="todo-checkbox" id="todo5">
                            <div class="todo-text">Join discussion groups</div>
                            <div class="todo-date">2025-03-22</div>
                        </div>
                    </div>
                    
                    <div class="progress-bar-container mt-3">
                        <div class="progress-label">
                            <span>Account Setup Progress</span>
                            <span>20%</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-success" role="progressbar" style="width: 20%" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100"></div>
                        </div>
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
                                    <h5 class="card-title"><i class="fas fa-book-open me-2 text-primary"></i>User Guide</h5>
                                    <p class="card-text">Learn how to use the Exam Management System with our comprehensive guides.</p>
                                    <a href="#" class="btn btn-sm btn-outline-primary">View Guides</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-question-circle me-2 text-warning"></i>FAQ</h5>
                                    <p class="card-text">Find answers to frequently asked questions about exams, results, and more.</p>
                                    <a href="#" class="btn btn-sm btn-outline-primary">View FAQs</a>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card h-100">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-headset me-2 text-info"></i>Support</h5>
                                    <p class="card-text">Need help? Contact our support team for assistance with any issues.</p>
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
        
        // Initialize date/time on page load
        document.addEventListener('DOMContentLoaded', function() {
            updateDateTime();
        });
        
        // Improved sidebar toggle functionality
        document.getElementById('menu-toggle').addEventListener('click', function() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('main-content');
            
            // Toggle classes for sidebar and main content
            sidebar.classList.toggle('sidebar-collapsed');
            mainContent.classList.toggle('main-content-expanded');
            
            // For mobile: toggle active class to show/hide sidebar
            if (window.innerWidth <= 768) {
                sidebar.classList.toggle('active');
            }
        });
        
        // Handle responsive behavior
        function handleWindowResize() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('main-content');
            
            if (window.innerWidth <= 768) {
                // On mobile, sidebar should be hidden by default
                if (!sidebar.classList.contains('active')) {
                    sidebar.classList.add('sidebar-collapsed');
                    sidebar.classList.remove('active');
                    mainContent.classList.add('main-content-expanded');
                }
            } else if (window.innerWidth <= 992) {
                // On tablets, sidebar should be collapsed but visible
                sidebar.classList.add('sidebar-collapsed');
                mainContent.classList.add('main-content-expanded');
            } else {
                // On desktop, it depends on user preference (preserved)
            }
        }
        
        // Initialize responsive behavior
        window.addEventListener('resize', handleWindowResize);
        document.addEventListener('DOMContentLoaded', handleWindowResize);
        
        // To-Do List functionality
        const todoCheckboxes = document.querySelectorAll('.todo-checkbox');
        todoCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                const todoText = this.nextElementSibling;
                if (this.checked) {
                    todoText.classList.add('todo-completed');
                    
                    // Update progress bar
                    updateProgressBar();
                } else {
                    todoText.classList.remove('todo-completed');
                    
                    // Update progress bar
                    updateProgressBar();
                }
            });
        });
        
        // Update progress bar function
        function updateProgressBar() {
            const totalTodos = document.querySelectorAll('.todo-checkbox').length;
            const completedTodos = document.querySelectorAll('.todo-checkbox:checked').length;
            const progressPercentage = Math.round((completedTodos / totalTodos) * 100);
            
            document.querySelector('.progress-bar').style.width = progressPercentage + '%';
            document.querySelector('.progress-label span:last-child').textContent = progressPercentage + '%';
        }
        
        // Add animation to quick action buttons
        const quickActionBtns = document.querySelectorAll('.quick-action-btn');
        quickActionBtns.forEach(btn => {
            btn.addEventListener('mouseover', function() {
                this.querySelector('.quick-action-icon').classList.add('animate__animated', 'animate__heartBeat');
            });
            
            btn.addEventListener('mouseout', function() {
                this.querySelector('.quick-action-icon').classList.remove('animate__animated', 'animate__heartBeat');
            });
            
            // Add click event
            btn.addEventListener('click', function() {
                const action = this.querySelector('.quick-action-text').textContent;
                console.log('Quick action clicked: ' + action);
                
                // Example redirect based on action
                if (action === 'Complete Profile') {
                    window.location.href = 'user_settings.jsp';
                } else if (action === 'View Exams') {
                    window.location.href = 'exams';
                } else if (action === 'Leaderboard') {
                    window.location.href = 'leaderboard.jsp';
                } else if (action === 'Study Materials') {
                    window.location.href = '#';
                }
            });
        });
        
        // Welcome message animation
        document.addEventListener('DOMContentLoaded', function() {
            const welcomeMessage = document.querySelector('.welcome-message');
            if (welcomeMessage) {
                welcomeMessage.classList.add('animate__animated', 'animate__fadeInDown');
            }
            
            // Show welcome toast for new users
            const toastContainer = document.createElement('div');
            toastContainer.className = 'position-fixed bottom-0 end-0 p-3';
            toastContainer.style.zIndex = '5';
            
            toastContainer.innerHTML = `
                <div class="toast show" role="alert" aria-live="assertive" aria-atomic="true">
                    <div class="toast-header">
                        <i class="fas fa-check-circle text-success me-2"></i>
                        <strong class="me-auto">Registration Successful</strong>
                        <small>Just now</small>
                        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                    <div class="toast-body">
                        Welcome to ExamPro! Your account has been created successfully.
                    </div>
                </div>
            `;
            
            document.body.appendChild(toastContainer);
            
            // Auto-dismiss toast after 5 seconds
            setTimeout(() => {
                const toast = document.querySelector('.toast');
                if (toast) {
                    const bsToast = new bootstrap.Toast(toast);
                    bsToast.hide();
                }
            }, 5000);
        });
    </script>
</body>
</html>