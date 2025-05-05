<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Exam Management System</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.11.5/css/dataTables.bootstrap5.min.css">
    
    <!-- Toastify CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css">
    
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

/* Content Cards */
.content-card {
    background-color: white;
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
    padding: 25px;
    margin-bottom: 25px;
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

/* Status badges */
.status-badge {
    padding: 5px 10px;
    border-radius: 50px;
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

/* Action buttons container */
.action-btns {
    display: flex;
    gap: 5px;
    justify-content: center;
    align-items: center;
    white-space: nowrap;
}

/* Modal Styles */
.modal {
    display: none;
    position: fixed;
    z-index: 1000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.5);
    backdrop-filter: blur(5px);
}

.modal-content {
    background-color: #fff;
    margin: 10% auto;
    padding: 30px;
    border-radius: 15px;
    width: 70%;
    max-width: 800px;
    box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
    animation: modalFadeIn 0.4s ease-out;
    background: linear-gradient(to bottom right, #ffffff, #f8f9fa);
}

@keyframes modalFadeIn {
    from {
        opacity: 0;
        transform: translateY(-60px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes slideDown {
    from { transform: translateY(-50px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}

.close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}

.close:hover {
    color: #555;
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
select:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
    outline: none;
}

/* Updated button styling for all modal actions - 2025-04-16 19:17:35 */
.action-buttons {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    margin-top: 20px;
}

/* Make ALL buttons in action sections consistent size */
.action-buttons .btn {
    padding: 10px 20px !important;
    font-size: 0.85rem !important;
    border-radius: 5px !important;
    min-width: 140px !important;
    height: 42px !important;
    line-height: 1.4 !important;
    font-weight: 500 !important;
    display: inline-flex !important;
    align-items: center !important;
    justify-content: center !important;
}

/* Cancel button styling - consistent size */
.btn-secondary.close-modal, #cancelDelete {
    background-color: #f0f2f5 !important;
    color: #6c757d !important;
    border: 1px solid #dee2e6 !important;
    padding: 10px 20px !important;
    min-width: 140px !important;
    height: 42px !important;
    box-shadow: none !important;
}

.btn-secondary.close-modal:hover, #cancelDelete:hover {
    background-color: #e2e6ea !important;
    color: #495057 !important;
}

/* Save Changes button styling - matched to Cancel button */
.btn-primary[type="submit"], .action-buttons .btn-primary {
    background: linear-gradient(to right, #4b6cb7, #5563a3) !important;
    border: none !important;
    color: white !important;
    padding: 10px 20px !important;
    font-size: 0.85rem !important;
    min-width: 140px !important;
    height: 42px !important;
    box-shadow: none !important;
    text-align: center !important;
}

.btn-primary[type="submit"]:hover, .action-buttons .btn-primary:hover {
    background: linear-gradient(to right, #425ca5, #4c578f) !important;
    transform: translateY(-1px);
    box-shadow: 0 2px 5px rgba(75, 108, 183, 0.3) !important;
}

/* Add User button styling */
#addUserBtn, .content-action .btn-success {
    background: linear-gradient(to right, #28a745, #20c997) !important;
    border: none !important;
    color: white !important;
    padding: 6px 12px !important;
    font-size: 0.85rem !important;
    border-radius: 4px !important;
    box-shadow: none !important;
}

#addUserBtn:hover, .content-action .btn-success:hover {
    background: linear-gradient(to right, #218838, #1ba385) !important;
    transform: translateY(-1px);
    box-shadow: 0 2px 5px rgba(40, 167, 69, 0.3) !important;
}

/* Specific fix for delete confirmation modal buttons */
#deleteUserModal .modal-content {
    width: 50%;
    max-width: 400px;
    padding: 20px;
}

#deleteUserModal .action-buttons {
    justify-content: center;
    margin-top: 15px;
    display: flex;
    gap: 10px;
}

/* Make both buttons in delete modal the exact same size */
#deleteUserModal .action-buttons .btn {
    padding: 8px 20px !important;
    font-size: 0.85rem !important;
    border-radius: 5px !important;
    min-width: 120px !important;
    height: 38px !important;
    line-height: 1.4 !important;
    font-weight: 500 !important;
}

/* Fix the delete button styling */
#confirmDelete, #deleteUserForm button[type="submit"] {
    background-color: #dc3545 !important;
    border-color: #dc3545 !important;
    color: white !important;
    padding: 8px 20px !important;
    min-width: 120px !important;
    height: 38px !important;
    background-image: none !important;
}

#confirmDelete:hover, #deleteUserForm button[type="submit"]:hover {
    background-color: #c82333 !important;
    border-color: #bd2130 !important;
}

#userDetails {
    margin-top: 15px;
}

#userDetails div {
    margin-bottom: 10px;
    padding: 10px;
    border-bottom: 1px solid #eee;
}

#userDetails strong {
    display: inline-block;
    width: 120px;
    font-weight: bold;
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

/* Modal Header Styling */
.modal-content h2 {
    color: #344767;
    font-size: 1.5rem;
    font-weight: 700;
    margin-bottom: 25px;
    padding-bottom: 15px;
    border-bottom: 2px solid #f0f2f5;
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

.form-column-divider {
    width: 1px;
    background: linear-gradient(to bottom, transparent, #e0e0e0, transparent);
    margin: 0 15px;
}

/* View Modal Specific Styles */
.detail-group {
    margin-bottom: 20px;
    padding: 15px;
    background: linear-gradient(to right, #f8f9fa, #ffffff);
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.02);
    transition: all 0.3s ease;
    animation: fadeInUp 0.3s ease;
}

.detail-group:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.05);
}

.detail-group label {
    color: #666;
    font-size: 0.85rem;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-bottom: 5px;
    display: block;
}

.detail-value {
    color: #344767;
    font-size: 1rem;
    font-weight: 600;
    padding: 5px 0;
}

/* Status Indicators */
.detail-value.status {
    display: inline-block;
    padding: 5px 15px;
    border-radius: 50px;
    font-size: 0.875rem;
    font-weight: 600;
}

.detail-value.status-active {
    background-color: rgba(40, 167, 69, 0.1);
    color: var(--success-color);
}

.detail-value.status-inactive {
    background-color: rgba(108, 117, 125, 0.1);
    color: #6c757d;
}

/* Role Badge */
.detail-value.role {
    display: inline-block;
    padding: 5px 15px;
    border-radius: 50px;
    background-color: rgba(102, 126, 234, 0.1);
    color: var(--primary-color);
}

/* View Modal Layout */
#viewUserModal .form-columns {
    display: flex;
    gap: 30px;
    margin-top: 20px;
}

#viewUserModal .form-column {
    flex: 1;
    min-width: 0;
}

/* Toast Notification */
#toast-container {
    position: fixed;
    top: 15px;
    right: 15px;
    z-index: 9999;
}

.toast {
    max-width: 350px;
    overflow: hidden;
    font-size: 0.875rem;
    background-color: rgba(255, 255, 255, 0.9);
    border-radius: 0.5rem;
    box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.15);
    border-left: 4px solid #4b6cb7;
    margin-bottom: 10px;
    animation: slideInRight 0.3s ease-out;
}

@keyframes slideInRight {
    from {
        transform: translateX(100%);
    }
    to {
        transform: translateX(0);
    }
}

@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Center align action buttons */
.text-center {
    text-align: center !important;
}

/* Responsive Layout Adjustments */
@media (max-width: 992px) {
    .sidebar {
        width: 70px;
    }
    
    .main-content {
        margin-left: 70px;
    }
    
    .sidebar-header h3 {
        display: none;
    }
    
    .menu-text {
        display: none;
    }
    
    .menu-item i {
        margin-right: 0;
    }
}

@media (max-width: 768px) {
    .main-content {
        margin-left: 0;
        padding: 10px;
    }
    
    .sidebar {
        left: -70px;
    }
    
    .sidebar.active {
        left: 0;
    }
    
    .modal-content {
        width: 95%;
        padding: 20px;
        margin: 20px auto;
    }
    
    .form-group input,
    .form-group select {
        height: 40px;
    }
    
    .form-columns {
        flex-direction: column;
        gap: 20px;
    }
    
    .form-column-divider {
        height: 1px;
        width: 100%;
        margin: 10px 0;
    }
    
    #viewUserModal .form-columns {
        flex-direction: column;
        gap: 15px;
    }
    
    .detail-group {
        margin-bottom: 15px;
        padding: 12px;
    }
    
    .detail-value {
        font-size: 0.9rem;
    }
    
    .form-section-header {
        font-size: 1rem;
        margin-top: 15px;
        margin-bottom: 10px;
    }
}
    </style>
</head>
<body>
    <!-- Toast container for notifications -->
    <div id="toast-container"></div>

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
            <li class="menu-item active">
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
                <h4 class="mb-0"><i class="fas fa-users me-2 text-primary"></i> User Management</h4>
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
        
        <!-- Alert Messages -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-${sessionScope.messageType} alert-dismissible fade show" role="alert">
                ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
            <% session.removeAttribute("message"); %>
            <% session.removeAttribute("messageType"); %>
        </c:if>
        
        <!-- Content Card -->
        <div class="content-card">
            <div class="content-header">
                <h5 class="content-title">User Management</h5>
                <div class="content-action">
                    <button id="refreshBtn" class="btn btn-sm btn-primary me-2"><i class="fas fa-sync me-1"></i> Refresh</button>
                    <button id="addUserBtn" class="btn btn-sm btn-success"><i class="fas fa-user-plus me-1"></i> Add User</button>
                </div>
            </div>
            
            <!-- User Table -->
            <div class="table-responsive">
                <table class="table table-striped table-hover align-middle" id="usersTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Full Name</th>
                            <th>Role</th>
                            <th>Status</th>
                            <th>Last Login</th>
                            <th class="text-center">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Table content will be loaded dynamically via DataTables -->
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

    <!-- View User Modal -->
    <div id="viewUserModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>User Details</h2>
            <div class="form-columns">
                <!-- Left Column -->
                <div class="form-column">
                    <div class="form-section-header">Basic Information</div>
                    <div class="detail-group">
                        <label>User ID</label>
                        <div class="detail-value" id="viewUserId"></div>
                    </div>
                    <div class="detail-group">
                        <label>Username</label>
                        <div class="detail-value" id="viewUsername"></div>
                    </div>
                    <div class="detail-group">
                        <label>Email</label>
                        <div class="detail-value" id="viewEmail"></div>
                    </div>
                    <div class="detail-group">
                        <label>First Name</label>
                        <div class="detail-value" id="viewFirstName"></div>
                    </div>
                    <div class="detail-group">
                        <label>Last Name</label>
                        <div class="detail-value" id="viewLastName"></div>
                    </div>
                </div>

                <!-- Right Column -->
                <div class="form-column">
                    <div class="form-section-header">Role Information</div>
                    <div class="detail-group">
                        <label>Role</label>
                        <div class="detail-value" id="viewRole"></div>
                    </div>
                    <div class="detail-group">
                        <label>Status</label>
                        <div class="detail-value" id="viewStatus"></div>
                    </div>
                    <div class="detail-group">
                        <label>Last Login</label>
                        <div class="detail-value" id="viewLastLogin"></div>
                    </div>

                    <!-- Student Details Section -->
                    <div id="viewStudentFields" style="display: none;">
                        <div class="form-section-header">Student Details</div>
                        <div class="detail-group">
                            <label>Course</label>
                            <div class="detail-value" id="viewCourse"></div>
                        </div>
                        <div class="detail-group">
                            <label>Semester</label>
                            <div class="detail-value" id="viewSemester"></div>
                        </div>
                        <div class="detail-group">
                            <label>Enrollment Number</label>
                            <div class="detail-value" id="viewEnrollmentNo"></div>
                        </div>
                        <div class="detail-group">
                            <label>Graduation Year</label>
                            <div class="detail-value" id="viewGradYear"></div>
                        </div>
                    </div>

                    <!-- Teacher Details Section -->
                    <div id="viewTeacherFields" style="display: none;">
                        <div class="form-section-header">Instructor Details</div>
                        <div class="detail-group">
                            <label>Instructor ID</label>
                            <div class="detail-value" id="viewEmployeeId"></div>
                        </div>
                        <div class="detail-group">
                            <label>Department</label>
                            <div class="detail-value" id="viewDepartment"></div>
                        </div>
                        <div class="detail-group">
                            <label>Designation</label>
                            <div class="detail-value" id="viewDesignation"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit User Modal -->
    <div id="editUserModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Edit User</h2>
            <form id="editUserForm" method="post" action="${pageContext.request.contextPath}/userManagement">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" id="editUserId" name="userId">
                
                <div class="form-columns">
                    <!-- Left Column -->
                    <div class="form-column">
                        <div class="form-section-header">Basic Information</div>
                        <div class="form-group">
                            <label for="editUsername">Username</label>
                            <input type="text" id="editUsername" name="username" required>
                        </div>
                        <div class="form-group">
                            <label for="editEmail">Email</label>
                            <input type="email" id="editEmail" name="email" required>
                        </div>
                        <div class="form-group">
                            <label for="editFirstName">First Name</label>
                            <input type="text" id="editFirstName" name="firstName" required>
                        </div>
                        <div class="form-group">
                            <label for="editLastName">Last Name</label>
                            <input type="text" id="editLastName" name="lastName" required>
                        </div>
                        <div class="form-group">
                            <label for="editPassword">New Password (leave blank to keep current)</label>
                            <input type="password" id="editPassword" name="password">
                        </div>
                    </div>

                    <!-- Right Column -->
                    <div class="form-column">
                        <div class="form-section-header">Role Details</div>
                        <div class="form-group">
                            <label for="editRole">Role</label>
                            <select id="editRole" name="role" onchange="toggleRoleFields('edit')">
                                <option value="admin">Admin</option>
                                <option value="teacher">Teacher</option>
                                <option value="student">Student</option>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="editStatus">Status</label>
                            <select id="editStatus" name="status">
                                <option value="active">Active</option>
                                <option value="inactive">Inactive</option>
                            </select>
                        </div>
                        
                        <!-- Student Fields -->
                        <div id="editStudentFields" style="display: none;">
                            <div class="form-group">
                                <label for="editCourse">Course</label>
                                <input type="text" id="editCourse" name="course">
                            </div>
                            <div class="form-group">
                                <label for="editSemester">Semester</label>
                                <input type="number" id="editSemester" name="semester" min="1" max="8">
                            </div>
                            <div class="form-group">
                                <label for="editEnrollmentNo">Enrollment Number</label>
                                <input type="text" id="editEnrollmentNo" name="enrollmentNumber">
                            </div>
                            <div class="form-group">
                                <label for="editGradYear">Graduation Year</label>
                                <input type="number" id="editGradYear" name="graduationYear" min="2025" max="2035">
                            </div>
                        </div>

                        <!-- Teacher Fields -->
                        <div id="editTeacherFields" style="display: none;">
                            <div class="form-group">
                                <label for="editEmployeeId">Instructor ID</label>
                                <input type="text" id="editEmployeeId" name="employeeId">
                            </div>
                            <div class="form-group">
                                <label for="editDepartment">Department</label>
                                <input type="text" id="editDepartment" name="department">
                            </div>
                            <div class="form-group">
                                <label for="editDesignation">Designation</label>
                                <input type="text" id="editDesignation" name="designation">
                            </div>
                        </div>
                    </div>
                </div>

                <div class="action-buttons">
                    <button type="button" class="btn btn-secondary close-modal">Cancel</button>
                    <button type="submit" class="btn btn-primary ">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Add User Modal -->
    <div id="addUserModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Add New User</h2>
            <form id="addUserForm" method="post" action="${pageContext.request.contextPath}/userManagement">
                <input type="hidden" name="action" value="add">
                
                <!-- Common fields like username, email, etc. -->
                <div class="form-group">
                    <label for="addUsername">Username</label>
                    <input type="text" id="addUsername" name="username" required>
                </div>
                <div class="form-group">
                    <label for="addPassword">Password</label>
                    <input type="password" id="addPassword" name="password" required>
                </div>
                <div class="form-group">
                    <label for="addEmail">Email</label>
                    <input type="email" id="addEmail" name="email" required>
                </div>
                <div class="form-group">
                    <label for="addFirstName">First Name</label>
                    <input type="text" id="addFirstName" name="firstName" required>
                </div>
                <div class="form-group">
                    <label for="addLastName">Last Name</label>
                    <input type="text" id="addLastName" name="lastName" required>
                </div>
                
                <!-- Role selection -->
                <div class="form-group">
                    <label for="addRole">Role</label>
                    <select id="addRole" name="role" class="form-control" required onchange="toggleRoleFields('add')">
                        <option value="">Select Role</option>
                        <option value="admin">Admin</option>
                        <option value="teacher">Teacher</option>
                        <option value="student">Student</option>
                    </select>
                </div>
                
                <!-- Student-specific fields -->
                <div id="addStudentFields" style="display: none;">
                    <div class="form-section-header">Student Details</div>
                    <div class="form-group">
                        <label for="addCourse">Course</label>
                        <input type="text" id="addCourse" name="course">
                    </div>
                    <div class="form-group">
                        <label for="addSemester">Semester</label>
                        <input type="number" id="addSemester" name="semester" min="1" max="8">
                    </div>
                    <div class="form-group">
                        <label for="addEnrollmentNo">Enrollment Number</label>
                        <input type="text" id="addEnrollmentNo" name="enrollmentNumber">
                    </div>
                    <div class="form-group">
                        <label for="addGradYear">Graduation Year</label>
                        <input type="number" id="addGradYear" name="graduationYear" min="2025" max="2035">
                    </div>
                </div>
                
                <!-- Teacher-specific fields -->
                <div id="addTeacherFields" style="display: none;">
                    <div class="form-section-header">Instructor Details</div>
                    <div class="form-group">
                        <label for="addEmployeeId">Instructor ID</label>
                        <input type="text" id="addEmployeeId" name="employeeId">
                    </div>
                    <div class="form-group">
                        <label for="addDepartment">Department</label>
                        <input type="text" id="addDepartment" name="department">
                    </div>
                    <div class="form-group">
                        <label for="addDesignation">Designation</label>
                        <input type="text" id="addDesignation" name="designation">
                    </div>
                </div>
                
                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button type="button" class="btn btn-secondary close-modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Add User</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div id="deleteUserModal" class="modal">
        <div class="modal-content">
            <span class="close">&times;</span>
            <h2>Confirm Delete</h2>
            <p>Are you sure you want to delete this user? This action cannot be undone.</p>
            <form id="deleteUserForm" method="post" action="${pageContext.request.contextPath}/userManagement">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" id="deleteUserId" name="userId">
                <div class="action-buttons">
                    <button type="button" id="cancelDelete" class="btn btn-sm btn-secondary">Cancel</button>
                    <button type="submit" id="confirmDelete" class="btn btn-sm btn-danger">Delete</button>
                </div>
            </form>
        </div>
    </div>

    <!-- Include jQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    
    <!-- Include Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Include DataTables -->
    <script src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.11.5/js/dataTables.bootstrap5.min.js"></script>
    
    <!-- Include Toastify JS -->
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    
    <!-- Include the JavaScript file -->
    <script src="${pageContext.request.contextPath}/js/userManagement.js"></script>
    
    <!-- Sidebar toggle functionality -->
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        console.log("DOM loaded - initializing sidebar toggle");
        
        // Update session timestamp
        const sessionInfoEl = document.querySelector('.session-info');
        if (sessionInfoEl) {
            sessionInfoEl.innerHTML = '<i class="fas fa-clock me-1"></i> Session: 2025-04-16 18:39:39';
        }
        
        const userLoginEl = document.querySelector('.text-muted');
        if (userLoginEl) {
            userLoginEl.textContent = 'IT24102083';
        }
        
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
    });
    </script>
</body>
</html>