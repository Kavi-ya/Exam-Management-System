<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Settings - Exam Management System</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Toastify CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
    
    <style>
        :root {
            --primary-color: #4b6cb7;
            --primary-dark: #3b5998;
            --secondary-color: #6c757d;
            --secondary-dark: #5a6268;
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
        .hiddenlogo {
            display: none !important;
            visibility: hidden;
            width: 0;
            height: 0;
            opacity: 0;
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
            transition: all 0.3s ease;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        
        .sidebar-collapsed {
            width: 70px !important;
        }
        
        .sidebar-header {
            padding: 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
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
            transition: all 0.3s;
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
            transition: all 0.3s ease;
        }
        
        .menu-text {
            transition: all 0.3s ease;
        }
        
        .sidebar-collapsed .menu-text {
            opacity: 0;
            width: 0;
            height: 0;
            overflow: hidden;
            display: none;
        }
        
        .sidebar-collapsed .menu-item i {
            margin-right: 0;
        }
        
        /* Added rule to hide the logo text when sidebar is collapsed */
        .sidebar-collapsed .logo-text {
            display: none !important;
            visibility: hidden;
            width: 0;
            height: 0;
            opacity: 0;
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
        
        /* Main Content */
        .main-content {
            margin-left: 250px;
            padding: 20px;
            transition: all 0.3s ease;
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
                
        /* Admin specific styling */
        .admin-badge {
            background-color: #4b6cb7;
            color: white;
            font-size: 0.7rem;
            padding: 3px 8px;
            border-radius: 10px;
            margin-left: 5px;
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
        
        /* Form Styles */
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        
        .form-group label {
            color: #344767;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 8px;
            display: block;
        }
        
        input[type="text"], 
        input[type="email"],
        input[type="password"],
        input[type="number"],
        input[type="date"],
        select {
            width: 100%;
            height: 45px;
            padding: 10px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s ease;
        }
        
        input[type="text"]:focus, 
        input[type="email"]:focus,
        input[type="password"]:focus,
        input[type="number"]:focus,
        input[type="date"]:focus,
        select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
        }
        
        /* Two Column Form Layout */
        .form-columns {
            display: flex;
            gap: 30px;
            margin-bottom: 20px;
        }
        
        .form-column {
            flex: 1;
            min-width: 0; /* Prevents flex items from overflowing */
        }
        
        /* Form Section Headers */
        .form-section-header {
            color: #344767;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f0f2f5;
            margin-top: 20px;
            position: relative;
        }
        
        .form-section-header::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 50px;
            height: 2px;
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
        }
        
        /* Profile picture upload */
        .profile-pic-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .profile-pic {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            border: 5px solid #f0f2f5;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 15px;
        }
        
        .upload-btn-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
            cursor: pointer;
        }
        
        .btn-upload {
            background-color: #f0f2f5;
            color: #344767;
            padding: 8px 15px;
            border-radius: 30px;
            font-size: 0.8rem;
            font-weight: 600;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }
        
        .btn-upload i {
            margin-right: 5px;
        }
        
        .btn-upload:hover {
            background-color: #e0e4e9;
        }
        
        .upload-btn-wrapper input[type=file] {
            font-size: 100px;
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
            cursor: pointer;
        }
        
        /* Progress bar for password strength */
        .password-strength-meter {
            height: 5px;
            width: 100%;
            background-color: #ddd;
            margin-top: 10px;
            border-radius: 3px;
            position: relative;
        }
        
        .password-strength-meter::before {
            content: '';
            height: 100%;
            background-color: var(--danger-color);
            border-radius: 3px;
            position: absolute;
            transition: width 0.3s ease, background-color 0.3s ease;
            width: 0;
        }
        
        .password-strength-meter.weak::before {
            background-color: var(--danger-color);
            width: 25%;
        }
        
        .password-strength-meter.medium::before {
            background-color: var(--warning-color);
            width: 50%;
        }
        
        .password-strength-meter.strong::before {
            background-color: var(--success-color);
            width: 100%;
        }
        
        .password-feedback {
            font-size: 0.75rem;
            margin-top: 5px;
            color: #6c757d;
        }
        
        /* Save button styling */
        .btn-primary {
            background: linear-gradient(to right, var(--primary-color), var(--secondary-color));
            border: none;
            border-radius: 50px;
            padding: 10px 25px;
            font-size: 0.9rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
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
        
        /* Toast Notification */
        #toast-container {
            position: fixed;
            top: 15px;
            right: 15px;
            z-index: 9999;
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
        
        /* Responsive Layout Adjustments */
        @media (max-width: 992px) {
            .sidebar {
                width: 250px; /* Keep the default width */
            }
            
            .main-content {
                margin-left: 250px; /* Keep the default margin */
            }
            
            /* Only apply these styles when sidebar is collapsed */
            .sidebar.sidebar-collapsed {
                width: 70px;
            }
            
            .main-content.main-content-expanded {
                margin-left: 70px;
            }
        }
        
        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 10px;
            }
            
            .sidebar {
                left: -250px; /* Start with sidebar hidden on mobile */
                transition: all 0.3s ease;
            }
            
            /* When active class is added, show the sidebar */
            .sidebar.active {
                left: 0;
            }
            
            /* For collapsed sidebar on mobile */
            .sidebar.sidebar-collapsed {
                left: -70px; /* Hide collapsed sidebar on mobile by default */
            }
            
            /* When active class is added, show the collapsed sidebar */
            .sidebar.sidebar-collapsed.active {
                left: 0;
            }
            
            .form-columns {
                flex-direction: column;
                gap: 20px;
            }
            
            .profile-pic {
                width: 120px;
                height: 120px;
            }
        }
    </style>
</head>
<body>
    <div class="" id="currentDateTime">
        <i class="fas fa-calendar-alt"></i>
        <span></span>
    </div>

    <!-- Toast container for notifications -->
    <div id="toast-container"></div>

    <!-- Sidebar -->
    <nav class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3>
                <i class="fas fa-graduation-cap me-2"></i>
                <span class="logo-text">ExamPro</span>
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
            <li class="menu-item active">
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
            <button class="menu-toggle" id="menu-toggle">
                <i class="fas fa-bars"></i>
            </button>
            
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
        
        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% session.removeAttribute("message"); %>
            <% session.removeAttribute("messageType"); %>
        </c:if>
        
        <!-- Welcome Message -->
        <div class="dashboard-card welcome-message">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4>User Settings</h4>
                <div class="d-flex align-items-center">
                    <div class="status-indicator status-active"></div>
                    <span>Account status: <strong>Active</strong></span>
                </div>
            </div>
            <p>Manage your personal information and account settings.</p>
        </div>
        
        <!-- Content Card - Personal Information -->
        <div class="dashboard-card">
            <div class="card-title">
                <i class="fas fa-user"></i>
                Personal Information
            </div>
            
            <form id="personalInfoForm" action="${pageContext.request.contextPath}/UserSettings" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="updatePersonalInfo">
                <input type="hidden" name="userId" value="${sessionScope.user.userId}">
                
                <!-- Profile Picture Upload -->
                <div class="profile-pic-container">
                    <img src="<c:out value='${sessionScope.user.profileImage}' default='./assets/images/admin-avatar.jpg'/>" alt="Profile Picture" class="profile-pic" id="profilePreview">
                    <div class="upload-btn-wrapper">
                        <button type="button" class="btn-upload"><i class="fas fa-camera"></i> Change Photo</button>
                        <input type="file" name="profileImage" id="profileImageInput" accept="image/*"/>
                    </div>
                </div>
                
                <div class="form-columns">
                    <!-- Left Column -->
                    <div class="form-column">
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" class="form-control" id="firstName" name="firstName" value="${sessionScope.user.firstName}" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="email">Email Address</label>
                            <input type="email" class="form-control" id="email" name="email" value="${sessionScope.user.email}" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="username">Username</label>
                            <input type="text" class="form-control" id="username" name="username" value="${sessionScope.user.username}" readonly>
                            <small class="text-muted">Username cannot be changed</small>
                        </div>
                    </div>
                    
                    <!-- Right Column -->
                    <div class="form-column">
                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" class="form-control" id="lastName" name="lastName" value="${sessionScope.user.lastName}" required>
                        </div>
                        
                        <div class="form-group">
                            <label>User ID</label>
                            <input type="text" class="form-control" value="${sessionScope.user.userId}" readonly>
                        </div>
                        
                        <div class="form-group">
                            <label>Role</label>
                            <input type="text" class="form-control" value="${sessionScope.user.role}" readonly>
                        </div>
                    </div>
                </div>
                
                <!-- Role-specific information section -->
                <c:choose>
                    <c:when test="${sessionScope.user.role eq 'student'}">
                        <div class="form-section-header">Student Details</div>
                        <div class="form-columns">
                            <div class="form-column">
                                <div class="form-group">
                                    <label for="enrollmentNumber">Enrollment Number</label>
                                    <input type="text" class="form-control" id="enrollmentNumber" name="enrollmentNumber" 
                                           value="${sessionScope.user.studentDetails.enrollmentNumber}" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="course">Course</label>
                                    <input type="text" class="form-control" id="course" name="course" 
                                           value="${sessionScope.user.studentDetails.course}" readonly>
                                </div>
                            </div>
                            <div class="form-column">
                                <div class="form-group">
                                    <label for="semester">Semester</label>
                                    <input type="text" class="form-control" id="semester" name="semester" 
                                           value="${sessionScope.user.studentDetails.semester}" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="batchId">Batch ID</label>
                                    <input type="text" class="form-control" id="batchId" name="batchId" 
                                           value="${sessionScope.user.studentDetails.batchId}" readonly>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    
                    <c:when test="${sessionScope.user.role eq 'teacher'}">
                        <div class="form-section-header">Teacher Details</div>
                        <div class="form-columns">
                            <div class="form-column">
                                <div class="form-group">
                                    <label for="employeeId">Employee ID</label>
                                    <input type="text" class="form-control" id="employeeId" name="employeeId" 
                                           value="${sessionScope.user.teacherDetails.employeeId}" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="department">Department</label>
                                    <input type="text" class="form-control" id="department" name="department" 
                                           value="${sessionScope.user.teacherDetails.department}" readonly>
                                </div>
                            </div>
                            <div class="form-column">
                                <div class="form-group">
                                    <label for="specialization">Specialization</label>
                                    <input type="text" class="form-control" id="specialization" name="specialization" 
                                           value="${sessionScope.user.teacherDetails.specialization}" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="designation">Designation</label>
                                    <input type="text" class="form-control" id="designation" name="designation" 
                                           value="${sessionScope.user.teacherDetails.designation}" readonly>
                                </div>
                            </div>
                        </div>
                    </c:when>
                </c:choose>
                
                <div class="d-flex justify-content-end mt-4">
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save me-2"></i> Save Changes
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Content Card - Security Settings -->
        <div class="dashboard-card">
            <div class="card-title">
                <i class="fas fa-lock"></i>
                Security Settings
            </div>
            
            <form id="securityForm" action="${pageContext.request.contextPath}/UserSettings" method="post">
                <input type="hidden" name="action" value="updatePassword">
                <input type="hidden" name="userId" value="${sessionScope.user.userId}">
                
                <div class="form-columns">
                    <!-- Left Column -->
                    <div class="form-column">
                        <div class="form-group">
                            <label for="currentPassword">Current Password</label>
                            <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                        </div>
                    </div>
                    
                    <!-- Right Column -->
                    <div class="form-column">
                        <div class="form-group">
                            <label for="newPassword">New Password</label>
                            <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                            <div class="password-strength-meter" id="passwordStrengthMeter"></div>
                            <div class="password-feedback" id="passwordFeedback">Password strength: Not set</div>
                        </div>
                        
                        <div class="form-group">
                            <label for="confirmPassword">Confirm New Password</label>
                            <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                            <div id="passwordMatch" class="password-feedback"></div>
                        </div>
                    </div>
                </div>
                
                <div class="d-flex justify-content-end mt-4">
                    <button type="submit" class="btn btn-primary" id="changePasswordBtn">
                        <i class="fas fa-lock me-2"></i> Change Password
                    </button>
                </div>
            </form>
        </div>
        
        <!-- Login History Card -->
        <div class="dashboard-card">
            <div class="card-title">
                <i class="fas fa-history"></i>
                Login History
            </div>
            
            <table class="table table-hover">
                <thead>
                    <tr>
                        <th>Date & Time</th>
                        <th>IP Address</th>
                        <th>Device</th>
                        <th>Location</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>2025-04-30 19:25:35</td>
                        <td>192.168.1.101</td>
                        <td>Chrome / Windows</td>
                        <td>Local Network</td>
                        <td><span class="badge bg-success">Success</span></td>
                    </tr>
                    <tr>
                        <td>2025-04-28 09:15:22</td>
                        <td>192.168.1.101</td>
                        <td>Chrome / Windows</td>
                        <td>Local Network</td>
                        <td><span class="badge bg-success">Success</span></td>
                    </tr>
                    <tr>
                        <td>2025-04-25 14:42:05</td>
                        <td>192.168.1.105</td>
                        <td>Safari / macOS</td>
                        <td>Local Network</td>
                        <td><span class="badge bg-success">Success</span></td>
                    </tr>
                </tbody>
            </table>
            
            <div class="mt-3 text-center">
                <a href="#" class="btn btn-outline-primary btn-sm">View All Login Activity</a>
            </div>
        </div>
        
        <!-- Notification Preferences -->
        <div class="dashboard-card">
            <div class="card-title">
                <i class="fas fa-bell"></i>
                Notification Preferences
            </div>
            
            <div class="mb-4">
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" id="emailNotifications" checked>
                    <label class="form-check-label" for="emailNotifications">Email Notifications</label>
                    <small class="form-text text-muted d-block">Receive notifications about exams, results, and important updates via email.</small>
                </div>
                
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" id="browserNotifications" checked>
                    <label class="form-check-label" for="browserNotifications">Browser Notifications</label>
                    <small class="form-text text-muted d-block">Receive push notifications in your browser when logged in.</small>
                </div>
                
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" id="examReminders" checked>
                    <label class="form-check-label" for="examReminders">Exam Reminders</label>
                    <small class="form-text text-muted d-block">Get reminders about upcoming exams and deadlines.</small>
                </div>
                
                <div class="form-check form-switch mb-3">
                    <input class="form-check-input" type="checkbox" id="resultAlerts" checked>
                    <label class="form-check-label" for="resultAlerts">Result Alerts</label>
                    <small class="form-text text-muted d-block">Be notified when new results are published.</small>
                </div>
            </div>
            
            <div class="d-flex justify-content-end">
                <button type="button" class="btn btn-primary" id="saveNotificationPreferences">
                    <i class="fas fa-save me-2"></i> Save Preferences
                </button>
            </div>
        </div>
        
        <!-- Footer -->
        <div class="footer">
            <p class="mb-0">&copy; 2025 Exam Management System</p>
            <p class="mb-0 small">Version 1.0.0</p>
        </div>
    </div>
    
    <!-- JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        // Set current date and time based on parameter
        document.getElementById('currentDateTime').innerHTML = '<i class="fas fa-calendar-alt"></i><span></span>';
        
        // FIXED sidebar toggle functionality
        document.getElementById('menu-toggle').addEventListener('click', function() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('main-content');
            const logoText = document.querySelector('.sidebar-header .logo-text');
            
            // Toggle classes for both the sidebar and main content
            sidebar.classList.toggle('sidebar-collapsed');
            mainContent.classList.toggle('main-content-expanded');
            
            // Toggle visibility of the logo text
            if (logoText) {
                if (sidebar.classList.contains('sidebar-collapsed')) {
                    logoText.classList.add('hiddenlogo');
                } else {
                    logoText.classList.remove('hiddenlogo');
                }
            }
            
            // For mobile: toggle active class to show/hide sidebar
            if (window.innerWidth <= 768) {
                sidebar.classList.toggle('active');
            }
        });
        
        // Handle window resize to reset sidebar state on larger screens
        window.addEventListener('resize', function() {
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('main-content');
            const logoText = document.querySelector('.sidebar-header .logo-text');
            
            if (window.innerWidth > 768) {
                if (!sidebar.classList.contains('sidebar-collapsed')) {
                    mainContent.classList.remove('main-content-expanded');
                    if (logoText) logoText.classList.remove('hiddenlogo');
                } else {
                    mainContent.classList.add('main-content-expanded');
                    if (logoText) logoText.classList.add('hiddenlogo');
                }
                sidebar.classList.remove('active'); // Remove active class on larger screens
            } else {
                // On mobile, reset to default (sidebar hidden)
                if (!sidebar.classList.contains('active')) {
                    mainContent.classList.remove('main-content-expanded');
                }
            }
        });
        
        // Profile Image Preview
        document.getElementById('profileImageInput').addEventListener('change', function(event) {
            if (event.target.files && event.target.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    document.getElementById('profilePreview').src = e.target.result;
                }
                reader.readAsDataURL(event.target.files[0]);
            }
        });
        
        // Password Strength Meter
        const newPasswordInput = document.getElementById('newPassword');
        const passwordStrengthMeter = document.getElementById('passwordStrengthMeter');
        const passwordFeedback = document.getElementById('passwordFeedback');
        
        newPasswordInput.addEventListener('input', function() {
            const password = newPasswordInput.value;
            
            if (!password) {
                passwordStrengthMeter.className = 'password-strength-meter';
                passwordFeedback.textContent = 'Password strength: Not set';
                return;
            }
            
            const strength = calculatePasswordStrength(password);
            
            if (strength < 5) {
                passwordStrengthMeter.className = 'password-strength-meter weak';
                passwordFeedback.textContent = 'Password strength: Weak';
                passwordFeedback.style.color = '#dc3545';
            } else if (strength < 8) {
                passwordStrengthMeter.className = 'password-strength-meter medium';
                passwordFeedback.textContent = 'Password strength: Medium';
                passwordFeedback.style.color = '#ffc107';
            } else {
                passwordStrengthMeter.className = 'password-strength-meter strong';
                passwordFeedback.textContent = 'Password strength: Strong';
                passwordFeedback.style.color = '#28a745';
            }
        });
        
        // Password Match Validation
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const passwordMatch = document.getElementById('passwordMatch');
        
        confirmPasswordInput.addEventListener('input', function() {
            if (newPasswordInput.value !== confirmPasswordInput.value) {
                passwordMatch.textContent = 'Passwords do not match';
                passwordMatch.style.color = '#dc3545';
                document.getElementById('changePasswordBtn').disabled = true;
            } else {
                passwordMatch.textContent = 'Passwords match';
                passwordMatch.style.color = '#28a745';
                document.getElementById('changePasswordBtn').disabled = false;
            }
        });
        
        // Form Submission and Validation
        // FIXED: Removed event.preventDefault() to allow forms to submit to servlet
        
        // Save notification preferences
        document.getElementById('saveNotificationPreferences').addEventListener('click', function() {
            // Simulate saving preferences
            showToast('Notification preferences saved successfully!', 'success');
        });
        
        // Function to calculate password strength (simple version)
        function calculatePasswordStrength(password) {
            let strength = 0;
            
            // Length
            if (password.length >= 8) strength += 2;
            if (password.length >= 12) strength += 2;
            
            // Contains lowercase letters
            if (/[a-z]/.test(password)) strength += 1;
            
            // Contains uppercase letters
            if (/[A-Z]/.test(password)) strength += 2;
            
            // Contains numbers
            if (/\d/.test(password)) strength += 2;
            
            // Contains special characters
            if (/[^A-Za-z0-9]/.test(password)) strength += 3;
            
            return strength;
        }
        
        // Toast Notification Function
        function showToast(message, type) {
            const backgroundColor = type === 'success' ? 'linear-gradient(to right, #28a745, #20c997)' : 
                                  type === 'error' ? 'linear-gradient(to right, #dc3545, #c82333)' :
                                  'linear-gradient(to right, #17a2b8, #138496)';
            
            Toastify({
                text: message,
                duration: 3000,
                close: true,
                gravity: "top",
                position: "right",
                backgroundColor: backgroundColor,
                stopOnFocus: true
            }).showToast();
        }
    });
    </script>
</body>
</html>