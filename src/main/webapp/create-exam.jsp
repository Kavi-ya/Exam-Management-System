<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
// Session validation - Check if user is logged in and is a teacher
String userRole = (String) session.getAttribute("userRole");
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");

// If user is not logged in or is not a teacher, redirect to login page
if (userId == null || userRole == null || !userRole.equalsIgnoreCase("teacher")) {
    response.sendRedirect("login.jsp?error=unauthorized&message=You must be logged in as a teacher to access this page");
    return;
}

// Current date and time
String currentDateTime = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Exam - Exam Management System</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Summernote Rich Text Editor -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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
            background: linear-gradient(180deg, var(--primary-color), var(--secondary-color));
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
        
        .sidebar-collapsed .menu-text {
            opacity: 0;
            width: 0;
            height: 0;
            overflow: hidden;
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
        
        /* Exam Creation Form */
        .exam-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 30px;
            margin-bottom: 30px;
            transition: all 0.3s;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .exam-card:hover {
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.1);
        }
        
        .card-title {
            font-weight: 700;
            margin-bottom: 20px;
            color: #333;
            display: flex;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .card-title i {
            margin-right: 10px;
            color: var(--primary-color);
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-label {
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .form-control:focus {
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            border-color: var(--primary-color);
        }
        
        .btn-primary {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-primary:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.3);
        }
        
        /* Question Section */
        .question-container {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            position: relative;
            border: 1px dashed #ddd;
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
        }
        
        .question-number {
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .question-actions {
            display: flex;
        }
        
        .action-btn {
            background: none;
            border: none;
            color: #6c757d;
            font-size: 1rem;
            margin-left: 10px;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .action-btn:hover {
            color: var(--primary-color);
        }
        
        .question-type {
            position: center;
            top: 20px;
            right: 20px;
        }
        
        .option-container {
            margin-top: 15px;
        }
        
        .option-item {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
        }
        
        .option-prefix {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-right: 10px;
        }
        
        .option-text {
            flex: 1;
        }
        
        .correct-option {
            background-color: rgba(40, 167, 69, 0.2);
        }
        
        .add-option-btn {
            background-color: white;
            border: 1px dashed #ccc;
            color: #6c757d;
            border-radius: 5px;
            padding: 8px 15px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            margin-top: 10px;
        }
        
        .add-option-btn:hover {
            background-color: #f8f9fa;
            color: var(--primary-color);
        }
        
        .add-question-btn {
            background-color: white;
            border: 2px dashed var(--primary-color);
            color: var(--primary-color);
            border-radius: 10px;
            padding: 15px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-bottom: 30px;
        }
        
        .add-question-btn:hover {
            background-color: rgba(102, 126, 234, 0.05);
            transform: translateY(-3px);
        }
        
        .add-question-btn i {
            margin-right: 10px;
            font-size: 1.2rem;
        }
        
        /* Modal Styles */
        .modal-content {
            border-radius: 10px;
            border: none;
        }
        
        .modal-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-top-left-radius: 10px;
            border-top-right-radius: 10px;
        }
        
        .modal-title {
            font-weight: 700;
        }
        
        /* Settings Section */
        .settings-row {
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .settings-title {
            font-weight: 600;
            margin-bottom: 5px;
        }
        
        .settings-description {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        /* Rich Text Editor */
        .note-editor.note-frame {
            border-radius: 5px;
        }
        
        .note-editor .note-toolbar {
            background-color: #f8f9fa;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
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
        
        /* Drag & Drop */
        .draggable {
            cursor: move;
        }
        
        .drag-handle {
            cursor: move;
            color: #adb5bd;
            margin-right: 10px;
            font-size: 1.1rem;
            transition: all 0.3s;
        }
        
        .drag-handle:hover {
            color: var(--primary-color);
        }
        
        .question-container.dragging {
            opacity: 0.5;
        }
        
        .question-container.drag-over {
            border: 2px dashed var(--primary-color);
        }
        
        /* Progress Stepper */
        .stepper {
            display: flex;
            justify-content: space-between;
            margin-bottom: 30px;
        }
        
        .step {
            display: flex;
            flex-direction: column;
            align-items: center;
            flex: 1;
            position: relative;
        }
        
        .step:not(:last-child)::after {
            content: "";
            position: absolute;
            top: 20px;
            width: 100%;
            height: 2px;
            background-color: #e9ecef;
            left: 50%;
        }
        
        .step.completed:not(:last-child)::after {
            background-color: var(--primary-color);
        }
        
        .step-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #e9ecef;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            margin-bottom: 10px;
            color: #6c757d;
            z-index: 1;
        }
        
        .step.active .step-icon {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            box-shadow: 0 5px 15px rgba(118, 75, 162, 0.3);
        }
        
        .step.completed .step-icon {
            background-color: var(--success-color);
            color: white;
        }
        
        .step-label {
            text-align: center;
            font-weight: 600;
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .step.active .step-label {
            color: var(--primary-color);
        }
        
        .step.completed .step-label {
            color: var(--success-color);
        }
        
        /* Form Field Animations */
        .form-control, .form-select {
            transition: all 0.3s;
        }
        
        .form-control:focus, .form-select:focus {
            transform: translateY(-3px);
        }
        
        /* Status Messages */
        #statusMessage {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: none;
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
            .main-content {
                margin-left: 0;
                padding: 10px;
            }
            
            .main-content-expanded {
            margin-left: 70px;
            display: sticky;
            }
                    
            .sidebar {
                left: -70px;
            }
            
            .sidebar.active {
                left: 0;
            }
            
            .top-navbar {
                margin-bottom: 20px;
            }
            
            .exam-card {
                padding: 20px;
            }
            
            .stepper {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .step {
                flex-direction: row;
                margin-bottom: 15px;
                width: 100%;
            }
            
            .step:not(:last-child)::after {
                display: none;
            }
            
            .step-icon {
                margin-bottom: 0;
                margin-right: 10px;
            }
        }
    </style>
</head>
<body>
        
    <!-- Status message for feedback -->
    <div id="statusMessage" class="alert" role="alert"></div>

   <!-- Sidebar -->
    <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
            <h3><i class="fas fa-graduation-cap me-2 "></i></h3>
            <h3 id="logo">Exam Pro</h3>
        </div>
        
        <ul class="menu-list">
            <li class="menu-item">
             <a href="teacher_dashboard.jsp" style="color: white; text-decoration: none;">
                <i class="fas fa-tachometer-alt"></i>
                <span class="menu-text">Dashboard</span>
                </a>
            </li>
            
            <li class="menu-item active">
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
                <div class="notification-bell toast-container position-fixed bottom-0 end-0 p-3">
                    
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
        
        <!-- Progress Stepper -->
        <div class="stepper">
            <div class="step active" id="step1-indicator">
                <div class="step-icon">1</div>
                <div class="step-label">Basic Info</div>
            </div>
            <div class="step" id="step2-indicator">
                <div class="step-icon">2</div>
                <div class="step-label">Questions</div>
            </div>
            <div class="step" id="step3-indicator">
                <div class="step-icon">3</div>
                <div class="step-label">Settings</div>
            </div>
            <div class="step" id="step4-indicator">
                <div class="step-icon">4</div>
                <div class="step-label">Review</div>
            </div>
        </div>
        
        <!-- Exam Creation Form -->
        <div class="exam-card">
            <h4 class="card-title">
                <i class="fas fa-edit"></i>
                Create New Exam
            </h4>
            
            <form id="createExamForm">
                <!-- Basic Information Section -->
                <div id="step1" class="step-content">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="examTitle" class="form-label">Exam Title</label>
                                <input type="text" class="form-control" id="examTitle" placeholder="Enter exam title" required>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="courseSelect" class="form-label">Course</label>
                                <select class="form-select" id="courseSelect" required>
                                    <option value="" selected disabled>Select course</option>
                                    <option value="CSE303">CSE-303: Database Management Systems</option>
                                    <option value="CSE405">CSE-405: Computer Networks</option>
                                    <option value="ECE202">ECE-202: Digital Electronics</option>
                                    <option value="CSE201">CSE-201: Object Oriented Programming</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="examDescription" class="form-label">Description</label>
                        <textarea class="form-control" id="examDescription" rows="4" placeholder="Enter exam description"></textarea>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="examDate" class="form-label">Exam Date</label>
                                <input type="date" class="form-control" id="examDate" required>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="startTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="startTime" required>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="form-group">
                                <label for="duration" class="form-label">Duration (minutes)</label>
                                <input type="number" class="form-control" id="duration" min="10" placeholder="e.g. 60" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="totalMarks" class="form-label">Total Marks</label>
                                <input type="number" class="form-control" id="totalMarks" min="1" placeholder="e.g. 100" required>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="form-group">
                                <label for="passingMarks" class="form-label">Passing Marks</label>
                                <input type="number" class="form-control" id="passingMarks" min="1" placeholder="e.g. 40" required>
                            </div>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-end mt-4">
                        <button type="button" class="btn btn-primary" id="nextToQuestions">
                            Next: Add Questions <i class="fas fa-arrow-right ms-2"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Questions Section -->
                <div id="step2" class="step-content" style="display: none;">
                    <div id="questionsContainer">
                        <!-- Questions will be added here dynamically -->
                    </div>
                    
                    <div class="add-question-btn" id="addQuestionBtn">
                        <i class="fas fa-plus"></i> Add New Question
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <button type="button" class="btn btn-outline-secondary" id="backToBasic">
                            <i class="fas fa-arrow-left me-2"></i> Back to Basic Info
                        </button>
                        <button type="button" class="btn btn-primary" id="nextToSettings">
                            Next: Exam Settings <i class="fas fa-arrow-right ms-2"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Settings Section -->
                <div id="step3" class="step-content" style="display: none;">
                    <div class="settings-row">
                        <div class="form-check form-switch mb-3">
                            <input class="form-check-input" type="checkbox" id="shuffleQuestions" checked>
                            <label class="form-check-label" for="shuffleQuestions">Shuffle Questions</label>
                        </div>
                        <div class="settings-description">Questions will be presented in random order to each student.</div>
                    </div>
                    
                    <div class="settings-row">
                        <div class="form-check form-switch mb-3">
                            <input class="form-check-input" type="checkbox" id="shuffleOptions" checked>
                            <label class="form-check-label" for="shuffleOptions">Shuffle Answer Options</label>
                        </div>
                        <div class="settings-description">Answer choices for multiple choice questions will be randomly ordered.</div>
                    </div>
                    
                    <div class="settings-row">
                        <div class="form-check form-switch mb-3">
                            <input class="form-check-input" type="checkbox" id="showResults">
                            <label class="form-check-label" for="showResults">Show Results Immediately</label>
                        </div>
                        <div class="settings-description">Students will see their results as soon as they submit the exam.</div>
                    </div>
                    
                    <div class="settings-row">
                        <div class="form-check form-switch mb-3">
                            <input class="form-check-input" type="checkbox" id="allowReview">
                            <label class="form-check-label" for="allowReview">Allow Review</label>
                        </div>
                        <div class="settings-description">Students can review their answers and see correct solutions after the exam.</div>
                    </div>
                    
                    <div class="settings-row">
                        <div class="form-check form-switch mb-3">
                            <input class="form-check-input" type="checkbox" id="preventBacktracking">
                            <label class="form-check-label" for="preventBacktracking">Prevent Backtracking</label>
                        </div>
                        <div class="settings-description">Students cannot return to previous questions once answered.</div>
                    </div>
                    
                    <div class="settings-row">
                        <div class="form-check form-switch mb-3">
                            <input class="form-check-input" type="checkbox" id="requireWebcam">
                            <label class="form-check-label" for="requireWebcam">Require Webcam</label>
                        </div>
                        <div class="settings-description">Students must enable webcam for proctoring during the exam.</div>
                    </div>
                    
                    <div class="settings-row">
                        <div class="form-check form-switch mb-3">
                            <input class="form-check-input" type="checkbox" id="limitAttempts">
                            <label class="form-check-label" for="limitAttempts">Limit Attempts</label>
                        </div>
                        <div class="input-group mb-3" style="max-width: 200px;">
                            <input type="number" class="form-control" id="maxAttempts" value="1" min="1">
                            <span class="input-group-text">attempts</span>
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <button type="button" class="btn btn-outline-secondary" id="backToQuestions">
                            <i class="fas fa-arrow-left me-2"></i> Back to Questions
                        </button>
                        <button type="button" class="btn btn-primary" id="nextToReview">
                            Next: Review <i class="fas fa-arrow-right ms-2"></i>
                        </button>
                    </div>
                </div>
                
                <!-- Review Section -->
                <div id="step4" class="step-content" style="display: none;">
                    <div class="alert alert-info mb-4">
                        <i class="fas fa-info-circle me-2"></i>
                        Review your exam details before submitting. Make sure everything is correct.
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <strong>Basic Information</strong>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-3"><strong>Exam Title:</strong></div>
                                <div class="col-md-9" id="reviewTitle"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3"><strong>Course:</strong></div>
                                <div class="col-md-9" id="reviewCourse"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3"><strong>Description:</strong></div>
                                <div class="col-md-9" id="reviewDescription"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3"><strong>Date & Time:</strong></div>
                                <div class="col-md-9" id="reviewDateTime"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3"><strong>Duration:</strong></div>
                                <div class="col-md-9" id="reviewDuration"></div>
                            </div>
                            <div class="row">
                                <div class="col-md-3"><strong>Marks:</strong></div>
                                <div class="col-md-9" id="reviewMarks"></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <strong>Questions Summary</strong>
                        </div>
                        <div class="card-body">
                            <div class="row mb-3">
                                <div class="col-md-3"><strong>Total Questions:</strong></div>
                                <div class="col-md-9" id="reviewQuestionCount"></div>
                            </div>
                            <div class="row mb-3">
                                <div class="col-md-3"><strong>Question Types:</strong></div>
                                <div class="col-md-9" id="reviewQuestionTypes"></div>
                            </div>
                            <div class="row">
                                <div class="col-md-3"><strong>Total Points:</strong></div>
                                <div class="col-md-9" id="reviewTotalPoints"></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <strong>Exam Settings</strong>
                        </div>
                        <div class="card-body" id="reviewSettings">
                            <!-- Settings will be populated by JavaScript -->
                        </div>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-4">
                        <button type="button" class="btn btn-outline-secondary" id="backToSettings">
                            <i class="fas fa-arrow-left me-2"></i> Back to Settings
                        </button>
                        <button type="button" class="btn btn-success" id="submitExam">
                            <i class="fas fa-check me-2"></i> Create Exam
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Add user ID and current date as data attributes to the body for JavaScript access -->
    <input type="hidden" id="currentUserID" value="<%= userId %>">
    <input type="hidden" id="systemDateTime" value="<%= currentDateTime %>">
    
    <!-- Question Type Modal -->
<div class="modal fade" id="questionTypeModal" tabindex="-1" aria-labelledby="questionTypeModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="questionTypeModalLabel">Add New Question</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <div class="card h-100">
                            <div class="card-body text-center py-4">
                                <i class="fas fa-list-ul fa-3x mb-3 text-primary"></i>
                                <h5>Multiple Choice</h5>
                                <p class="card-text">Create a question with multiple options.</p>
                                <button type="button" class="btn btn-outline-primary mt-2" data-type="multiple_choice">Select</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="card h-100">
                            <div class="card-body text-center py-4">
                                <i class="fas fa-check-square fa-3x mb-3 text-primary"></i>
                                <h5>True/False</h5>
                                <p class="card-text">Create a true or false statement.</p>
                                <button type="button" class="btn btn-outline-primary mt-2" data-type="true_false">Select</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="card h-100">
                            <div class="card-body text-center py-4">
                                <i class="fas fa-comment-alt fa-3x mb-3 text-primary"></i>
                                <h5>Short Answer</h5>
                                <p class="card-text">Student types a brief response.</p>
                                <button type="button" class="btn btn-outline-primary mt-2" data-type="short_answer">Select</button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <div class="card h-100">
                            <div class="card-body text-center py-4">
                                <i class="fas fa-file-alt fa-3x mb-3 text-primary"></i>
                                <h5>Essay</h5>
                                <p class="card-text">Student writes a longer response.</p>
                                <button type="button" class="btn btn-outline-primary mt-2" data-type="essay">Select</button>
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

    <!-- Summernote JS -->
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>

    <!-- Exam Creation JS -->
    <script src="js/examCreation.js"></script>
    
    <script>
        // Update current date/time and user info on page load
        document.addEventListener('DOMContentLoaded', function() {
                        
            // Set current user ID for form submission
            const currentUserID = document.getElementById('currentUserID').value;
            console.log('Logged in teacher ID:', currentUserID);
            
            // Default exam date to tomorrow
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            const formattedDate = tomorrow.toISOString().substring(0, 10);
            document.getElementById('examDate').value = formattedDate;
        });
    </script>
</body>
</html>