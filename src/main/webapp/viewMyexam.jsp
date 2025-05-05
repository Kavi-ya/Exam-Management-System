<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Exams - Exam Management System</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Summernote CSS -->
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.css" rel="stylesheet">

	<!-- Summernote JS -->
	<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-lite.min.js"></script>
    
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <!-- Same styles as before -->
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
        
        /* Exam Cards */
        .exam-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-bottom: 20px;
            transition: all 0.3s;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .exam-card:hover {
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            transform: translateY(-3px);
        }
        
        .exam-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #f1f1f1;
        }
        
        .exam-title {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--dark-color);
            margin: 0;
        }
        
        .exam-course {
            font-size: 0.9rem;
            color: var(--secondary-color);
            font-weight: 600;
        }
        
        .exam-actions .btn {
            margin-left: 5px;
            padding: 5px 10px;
        }
        
        .exam-stats {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 15px;
        }
        
        .stat-item {
            display: flex;
            align-items: center;
            padding: 8px 12px;
            border-radius: 8px;
            background-color: #f8f9fa;
            font-size: 0.85rem;
        }
        
        .stat-item i {
            margin-right: 8px;
            color: var(--primary-color);
        }
        
        .exam-description {
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 15px;
            line-height: 1.5;
        }
        
        .exam-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 15px;
            padding-top: 15px;
            border-top: 1px solid #f1f1f1;
            font-size: 0.85rem;
            color: #777;
        }
        
        .created-date {
            display: flex;
            align-items: center;
        }
        
        .created-date i {
            margin-right: 5px;
            color: var(--primary-color);
        }
        
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
            background-color: rgba(255, 193, 7, 0.15);
            color: #ffc107;
        }
        
        .status-pending {
            background-color: rgba(23, 162, 184, 0.15);
            color: #17a2b8;
        }
        
        .status-closed {
            background-color: rgba(108, 117, 125, 0.15);
            color: #6c757d;
        }
        
        /* Filter and Search */
        .filter-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }
        
        .filter-group {
            display: flex;
            gap: 10px;
        }
        
        .search-box {
            position: relative;
            max-width: 300px;
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
        
        /* Status Messages */
        #statusMessage {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            display: none;
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
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 50px 20px;
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
        }
        
        .empty-state i {
            font-size: 4rem;
            color: #ddd;
            margin-bottom: 20px;
        }
        
        .empty-state h3 {
            font-weight: 600;
            margin-bottom: 10px;
        }
        
        .empty-state p {
            color: #777;
            margin-bottom: 20px;
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
            
            .sidebar {
                left: -70px;
            }
            
            .sidebar.active {
                left: 0;
            }
            
            .filter-row {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
            
            .filter-group {
                width: 100%;
            }
            
            .search-box {
                width: 100%;
                max-width: none;
            }
            
            .exam-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .exam-actions {
                margin-top: 10px;
                display: flex;
                gap: 5px;
            }
        }
        
        /* Question list styles */
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
        
        .action-buttons button {
            padding: 2px 5px;
            font-size: 0.75rem;
        }
        
    </style>
        
    <link rel="stylesheet" href="css/viewMyExams.css">
    
</head>
<body>
    <%
    // Get attributes from the servlet
    String currentDateTime = (String) request.getAttribute("currentDateTime");
    String currentUserId = (String) request.getAttribute("currentUserId");
    List<JsonObject> exams = (List<JsonObject>) request.getAttribute("exams");
    Map<String, List<JsonObject>> questionsByExam = 
        (Map<String, List<JsonObject>>) request.getAttribute("questionsByExam");
    String error = (String) request.getAttribute("error");
    
    // Default values if attributes are null
    if (currentDateTime == null) {
        currentDateTime = "";
    }
    
    if (currentUserId == null) {
        currentUserId = "IT24102083";
    }
    
    // Map of course names
    Map<String, String> courseNames = new HashMap<>();
    courseNames.put("CSE303", "Database Management Systems");
    courseNames.put("CSE405", "Computer Networks");
    courseNames.put("ECE202", "Digital Electronics");
    courseNames.put("CSE201", "Object Oriented Programming");
    
    // Default empty collections
    if (exams == null) {
        exams = new ArrayList<>();
    }
    
    if (questionsByExam == null) {
        questionsByExam = new HashMap<>();
    }
    %>
    
    <!-- Status message for feedback -->
    <div id="statusMessage" class="alert" role="alert" style="display:none;"></div>

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
            
            <li class="menu-item">
            <a href="create-exam.jsp" style="color: white; text-decoration: none;">
                <i class="fas fa-edit"></i>
                <span class="menu-text">Create Exam</span>
                </a>
            </li>
                        
            <li class="menu-item active">
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
                    <i class=""></i>
                    
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
        
        <!-- Page Header -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0"><i class="fas fa-folder me-2 text-primary"></i> My Exams</h2>
            <a href="create-exam.jsp" class="btn btn-primary">
                <i class="fas fa-plus me-2"></i> Create New Exam
            </a>
        </div>
        
        <% if (error != null && !error.isEmpty()) { %>
            <!-- Error Message -->
            <div class="alert alert-danger mb-4">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <%= error %>
            </div>
        <% } %>
        
        <!-- Filter and Search -->
        <div class="filter-row">
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
                    <option value="CSE303">CSE-303: Database Management Systems</option>
                    <option value="CSE405">CSE-405: Computer Networks</option>
                    <option value="ECE202">ECE-202: Digital Electronics</option>
                    <option value="CSE201">CSE-201: Object Oriented Programming</option>
                </select>
            </div>
            
            <div class="search-box">
                <input type="text" class="form-control" id="searchExam" placeholder="Search exams...">
                <i class="fas fa-search"></i>
            </div>
        </div>
        
        <!-- Debug Information -->
        <div class="alert alert-info mb-4">
            <p><strong>Debug Info:</strong></p>
            <p>Loaded Exams: <%= exams.size() %></p>
            <p>Exams with Questions: <%= questionsByExam.size() %></p>
            <% for (Map.Entry<String, List<JsonObject>> entry : questionsByExam.entrySet()) { %>
                <p>Exam <%= entry.getKey() %>: <%= entry.getValue().size() %> questions</p>
            <% } %>
        </div>
        
        <!-- Exam List -->
        <div id="examList">
            <% 
            if (exams.isEmpty()) { 
            %>
                <!-- Empty State -->
                <div class="empty-state" id="emptyState">
                    <i class="fas fa-folder-open"></i>
                    <h3>No Exams Found</h3>
                    <p>You haven't created any exams yet or no exams match your search criteria.</p>
                    <a href="create-exam.jsp" class="btn btn-primary">Create Your First Exam</a>
                </div>
            <% 
            } else {
                // Display exams
                for (JsonObject exam : exams) {
                    String examId = exam.has("examId") ? exam.get("examId").getAsString() : "";
                    String examName = exam.has("examName") ? exam.get("examName").getAsString() : "Untitled Exam";
                    String courseId = exam.has("courseId") ? exam.get("courseId").getAsString() : "";
                    String courseName = courseNames.getOrDefault(courseId, courseId);
                    String description = exam.has("description") ? exam.get("description").getAsString() : "";
                    String createdAt = exam.has("createdAt") ? exam.get("createdAt").getAsString() : "";
                    String status = exam.has("status") ? exam.get("status").getAsString() : "draft";
                    
                    int duration = exam.has("duration") ? exam.get("duration").getAsInt() : 60;
                    int totalMarks = exam.has("totalMarks") ? exam.get("totalMarks").getAsInt() : 100;
                    
                    // Get questions for this exam
                    List<JsonObject> questions = questionsByExam.getOrDefault(examId, new ArrayList<>());
                    int questionCount = questions.size();
            %>
            <div class="exam-card" data-course="<%= courseId %>" data-status="<%= status %>">
                <div class="exam-header">
                    <div>
                        <h4 class="exam-title"><%= examName %></h4>
                        <div class="exam-course">
                            <i class="fas fa-book-open me-1"></i>
                            <%= courseId %>: <%= courseName %>
                        </div>
                    </div>
                    <div class="exam-actions">
                        <button type="button" class="btn btn-sm btn-outline-primary view-questions-btn" data-exam-id="<%= examId %>">
                            <i class="fas fa-eye me-1"></i> View Questions
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-success add-question-btn ms-1" data-exam-id="<%= examId %>">
    						<i class="fas fa-plus me-1"></i> Add Question
						</button>
                        <button type="button" class="btn btn-sm btn-outline-warning edit-exam-btn" data-exam-id="<%= examId %>">
                            <i class="fas fa-edit me-1"></i> Edit
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-danger delete-exam-btn" data-exam-id="<%= examId %>">
                            <i class="fas fa-trash-alt me-1"></i> Delete
                        </button>
                    </div>
                </div>
                
                <div class="exam-stats">
                    <div class="stat-item">
                        <i class="fas fa-question-circle"></i>
                        <span><%= questionCount %> Questions</span>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-check-circle"></i>
                        <span><%= totalMarks %> Total Marks</span>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-clock"></i>
                        <span><%= duration %> Minutes</span>
                    </div>
                    <div class="stat-item">
                        <i class="fas fa-calendar-alt"></i>
                        <span><%= exam.has("startDate") ? exam.get("startDate").getAsString().substring(0, 10) : "N/A" %></span>
                    </div>
                </div>
                
                <div class="exam-description">
                    <%= description %>
                </div>
                
                <div class="exam-footer">
                    <div class="created-date">
                        <i class="fas fa-calendar-plus"></i>
                        <span>Created on: <%= createdAt %></span>
                    </div>
                    <div>
                        <span class="status-badge status-<%= status %>">
                            <%= status.substring(0, 1).toUpperCase() + status.substring(1) %>
                        </span>
                    </div>
                </div>
                
                <!-- Questions Container (hidden by default) -->
                <div class="question-list mt-3" style="display: none;" id="questionList-<%= examId %>">
                    <h6><i class="fas fa-list-ul me-2"></i>Questions:</h6>
                    <% 
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
                            
                            // Use questionText if available, otherwise fall back to text
                            String questionText = "";
                            if (question.has("questionText")) {
                                questionText = question.get("questionText").getAsString();
                            } else if (question.has("text")) {
                                questionText = question.get("text").getAsString();
                            } else {
                                questionText = "Question " + questionNum;
                            }
                            
                            // Use questionType if available, otherwise fall back to type
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
                            
                            // Use points if available, otherwise fall back to marks
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
                            <div>Type: <%= formattedType %></div>
                            <div>Marks: <%= marks %></div>
                            <div class="action-buttons">
                                <button type="button" class="btn btn-sm btn-outline-info edit-question-btn" data-question-id="<%= questionId %>">Edit</button>
                                <button type="button" class="btn btn-sm btn-outline-danger delete-question-btn" data-question-id="<%= questionId %>">Delete</button>
                            </div>
                        </div>
                    </div>
                    <% 
                            questionNum++;
                        }
                    }
                    %>
                </div>
            </div>
            <% 
                }
            }
            %>
        </div>
    </div>
    
    <!-- Add Question Modal -->
    <div class="modal fade" id="addQuestionModal" tabindex="-1" aria-labelledby="addQuestionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addQuestionModalLabel">Add New Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addQuestionForm">
                        <input type="hidden" id="addQuestionExamId">
                        
                        <div class="mb-3">
                            <label for="addQuestionText" class="form-label">Question Text</label>
                            <textarea class="form-control" id="addQuestionText" rows="3" required></textarea>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="addQuestionType" class="form-label">Question Type</label>
                                <select class="form-select" id="addQuestionType">
                                    <option value="multiple_choice">Multiple Choice</option>
                                    <option value="true_false">True/False</option>
                                    <option value="short_answer">Short Answer</option>
                                    <option value="essay">Essay</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="addQuestionMarks" class="form-label">Marks</label>
                                <input type="number" class="form-control" id="addQuestionMarks" min="1" value="5" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="addQuestionDifficulty" class="form-label">Difficulty Level</label>
                            <select class="form-select" id="addQuestionDifficulty">
                                <option value="1">Easy</option>
                                <option value="2" selected>Medium</option>
                                <option value="3">Hard</option>
                            </select>
                        </div>
                        
                        <!-- Options for multiple choice questions -->
                        <div id="addOptionsContainer">
                            <div class="mb-3">
                                <label class="form-label">Answer Options</label>
                                <div id="addOptionsList">
                                    <!-- Options will be populated dynamically -->
                                    <div class="d-flex align-items-center mb-2 add-option-item">
                                        <span class="me-2">A.</span>
                                        <div class="input-group">
                                            <input type="text" class="form-control" placeholder="Enter option" value="Option A">
                                            <div class="input-group-text">
                                                <input class="form-check-input mt-0" type="radio" name="addCorrectOption" checked>
                                            </div>
                                            <button type="button" class="btn btn-outline-danger remove-add-option">
                                                <i class="fas fa-times"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-center mb-2 add-option-item">
                                        <span class="me-2">B.</span>
                                        <div class="input-group">
                                            <input type="text" class="form-control" placeholder="Enter option" value="Option B">
                                            <div class="input-group-text">
                                                <input class="form-check-input mt-0" type="radio" name="addCorrectOption">
                                            </div>
                                            <button type="button" class="btn btn-outline-danger remove-add-option">
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
                        <div id="addTrueFalseContainer" style="display:none;">
                            <div class="mb-3">
                                <label class="form-label">Correct Answer</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="addTrueFalseOption" id="addOptionTrue" value="true" checked>
                                    <label class="form-check-label" for="addOptionTrue">True</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="addTrueFalseOption" id="addOptionFalse" value="false">
                                    <label class="form-check-label" for="addOptionFalse">False</label>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Short answer / Essay -->
                        <div id="addShortAnswerContainer" style="display:none;">
                            <div class="mb-3">
                                <label for="addCorrectAnswer" class="form-label">Model Answer / Grading Criteria</label>
                                <textarea class="form-control" id="addCorrectAnswer" rows="5" placeholder="Enter the model answer or grading criteria here..."></textarea>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveNewQuestion">Add Question</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Exam Modal -->
    <div class="modal fade" id="editExamModal" tabindex="-1" aria-labelledby="editExamModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editExamModalLabel">Edit Exam</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editExamForm">
                        <input type="hidden" id="editExamId">
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="editExamTitle" class="form-label">Exam Title</label>
                                <input type="text" class="form-control" id="editExamTitle" required>
                            </div>
                            <div class="col-md-6">
                                <label for="editCourseSelect" class="form-label">Course</label>
                                <select class="form-select" id="editCourseSelect" required>
                                    <option value="CSE303">CSE-303: Database Management Systems</option>
                                    <option value="CSE405">CSE-405: Computer Networks</option>
                                    <option value="ECE202">ECE-202: Digital Electronics</option>
                                    <option value="CSE201">CSE-201: Object Oriented Programming</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label for="editExamDescription" class="form-label">Description</label>
                            <textarea class="form-control" id="editExamDescription" rows="3"></textarea>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-4">
                                <label for="editExamDate" class="form-label">Exam Date</label>
                                <input type="date" class="form-control" id="editExamDate" required>
                            </div>
                            <div class="col-md-4">
                                <label for="editStartTime" class="form-label">Start Time</label>
                                <input type="time" class="form-control" id="editStartTime" required>
                            </div>
                            <div class="col-md-4">
                                <label for="editDuration" class="form-label">Duration (minutes)</label>
                                <input type="number" class="form-control" id="editDuration" min="10" required>
                            </div>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="editTotalMarks" class="form-label">Total Marks</label>
                                <input type="number" class="form-control" id="editTotalMarks" min="1" required>
                            </div>
                            <div class="col-md-6">
                                <label for="editPassingMarks" class="form-label">Passing Marks</label>
                                <input type="number" class="form-control" id="editPassingMarks" min="1" required>
                            </div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" id="editExamStatus">
                                <option value="published">Published</option>
                                <option value="draft">Draft</option>
                                <option value="pending">Pending</option>
                                <option value="closed">Closed</option>
                            </select>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveExamChanges">Save Changes</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Edit Question Modal -->
    <div class="modal fade" id="editQuestionModal" tabindex="-1" aria-labelledby="editQuestionModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editQuestionModalLabel">Edit Question</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="editQuestionForm">
                        <input type="hidden" id="editQuestionId">
                        <input type="hidden" id="editQuestionExamId">
                        
                        <div class="mb-3">
                            <label for="editQuestionText" class="form-label">Question Text</label>
                            <textarea class="form-control" id="editQuestionText" rows="3" required></textarea>
                        </div>
                        
                        <div class="row mb-3">
                            <div class="col-md-6">
                                <label for="editQuestionType" class="form-label">Question Type</label>
                                <select class="form-select" id="editQuestionType">
                                    <option value="multiple_choice">Multiple Choice</option>
                                    <option value="true_false">True/False</option>
                                    <option value="short_answer">Short Answer</option>
                                    <option value="essay">Essay</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="editQuestionMarks" class="form-label">Marks</label>
                                <input type="number" class="form-control" id="editQuestionMarks" min="1" required>
                            </div>
                        </div>
                        
                        <!-- Options for multiple choice questions -->
                        <div id="editOptionsContainer">
                            <div class="mb-3">
                                <label class="form-label">Answer Options</label>
                                <div id="editOptionsList">
                                    <!-- Options will be populated dynamically -->
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-primary mt-2" id="addEditOption">
                                    <i class="fas fa-plus me-2"></i> Add Option
                                </button>
                            </div>
                        </div>
                        
                        <!-- True/False options -->
                        <div id="editTrueFalseContainer" style="display:none;">
                            <div class="mb-3">
                                <label class="form-label">Correct Answer</label>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="editTrueFalseOption" id="editOptionTrue" value="true">
                                    <label class="form-check-label" for="editOptionTrue">True</label>
                                </div>
                                <div class="form-check">
                                    <input class="form-check-input" type="radio" name="editTrueFalseOption" id="editOptionFalse" value="false">
                                    <label class="form-check-label" for="editOptionFalse">False</label>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Short answer / Essay -->
                        <div id="editShortAnswerContainer" style="display:none;">
                            <div class="mb-3">
                                <label for="editCorrectAnswer" class="form-label">Correct Answer</label>
                                <textarea class="form-control" id="editCorrectAnswer" rows="5" placeholder="Enter the model answer or grading criteria here..."></textarea>
                                <!--  <input type="text" class="form-control" id="editCorrectAnswer" placeholder="Enter the correct answer"> -->
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" id="saveQuestionChanges">Save Changes</button>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteConfirmModalLabel">Confirm Delete</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete <span id="deleteItemName"></span>? This action cannot be undone.</p>
                    <input type="hidden" id="deleteItemId">
                    <input type="hidden" id="deleteItemType">
                    <input type="hidden" id="deleteExamId">
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
    
    <!-- Custom JS -->
    <script src="js/viewMyExams.js"></script>
</body>
</html>