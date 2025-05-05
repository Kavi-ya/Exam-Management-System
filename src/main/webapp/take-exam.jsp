<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.google.gson.JsonObject, com.google.gson.JsonArray" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
    // Get view mode from request attribute
    String viewMode = (String) request.getAttribute("viewMode");
    if (viewMode == null) viewMode = "list"; // Default to list view
    
    // Get list of exams if in list mode
    List<JsonObject> publishedExams = null;
    if ("list".equals(viewMode)) {
        publishedExams = (List<JsonObject>) request.getAttribute("publishedExams");
        if (publishedExams == null) publishedExams = new java.util.ArrayList<JsonObject>();
    }
    
    // Get exam if in take mode
    JsonObject currentExam = null;
    if ("take".equals(viewMode)) {
        currentExam = (JsonObject) request.getAttribute("exam");
        if (currentExam == null) currentExam = new JsonObject();
    }
    
    // Current date time and user ID (updated with current values)
    String currentDateTime = "2025-05-04 09:19:43";
    String currentUserId = "IT24102083";
    
    // Get exam details if in take mode
    String examTitleName = "Database Management Systems Mid-Term";
    String examCourseId = "CSE-303";
    String examCreatedBy = "Robert Smith";
    int examTotalMarks = 100;
    int examDuration = 120;
    
    if (currentExam != null) {
        examTitleName = currentExam.has("examName") ? currentExam.get("examName").getAsString() : examTitleName;
        examCourseId = currentExam.has("courseId") ? currentExam.get("courseId").getAsString() : examCourseId;
        examCreatedBy = currentExam.has("createdBy") ? currentExam.get("createdBy").getAsString() : examCreatedBy;
        examTotalMarks = currentExam.has("totalMarks") ? currentExam.get("totalMarks").getAsInt() : examTotalMarks;
        examDuration = currentExam.has("duration") ? currentExam.get("duration").getAsInt() : examDuration;
    }
    
    // Get time remaining in seconds if in take mode
    Integer timeRemainingSeconds = (Integer) request.getAttribute("timeRemainingSeconds");
    if (timeRemainingSeconds == null) timeRemainingSeconds = 7200; // Default 2 hours
    %>
    
    <title><%= "take".equals(viewMode) ? "Take Exam - " + examTitleName : "Available Exams" %></title>
    
    <!-- Store context path for JavaScript -->
    <meta name="contextPath" content="${pageContext.request.contextPath}">
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        /* CSS styles remain unchanged */
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
            min-height: 100vh;
        }
        
        /* Header */
        .exam-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 20px 0;
            margin-bottom: 30px;
        }
        
        .exam-title {
            font-weight: 700;
            margin-bottom: 5px;
        }
        
        .exam-info {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        /* Timer */
        .timer-container {
            position: sticky;
            top: 20px;
            z-index: 100;
        }
        
        .timer-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .timer {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark-color);
            text-align: center;
        }
        
        .timer-warning {
            color: var(--warning-color);
        }
        
        .timer-danger {
            color: var(--danger-color);
            animation: pulse 1s infinite;
        }
        
        @keyframes pulse {
            0% {
                opacity: 1;
            }
            50% {
                opacity: 0.7;
            }
            100% {
                opacity: 1;
            }
        }
        
        /* Progress */
        .progress-container {
            margin-bottom: 15px;
        }
        
        .progress {
            height: 10px;
            border-radius: 5px;
        }
        
        .progress-label {
            display: flex;
            justify-content: space-between;
            font-size: 0.85rem;
            margin-top: 5px;
        }
        
        /* Question Navigation */
        .nav-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 15px;
            margin-bottom: 20px;
        }
        
        .nav-title {
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
        
        .question-nav {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 10px;
        }
        
        .nav-item {
            width: 100%;
            aspect-ratio: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .nav-item:hover {
            border-color: var(--primary-color);
            background-color: rgba(102, 126, 234, 0.05);
        }
        
        .nav-item.active {
            background-color: var(--primary-color);
            color: white;
            border-color: var(--primary-color);
        }
        
        .nav-item.answered {
            background-color: rgba(40, 167, 69, 0.1);
            border-color: var(--success-color);
            color: var(--success-color);
        }
        
        .nav-item.flagged {
            background-color: rgba(255, 193, 7, 0.1);
            border-color: var(--warning-color);
            color: var(--warning-color);
        }
        
        /* Question Container */
        .question-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 25px;
            margin-bottom: 30px;
        }
        
        .question-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }
        
        .question-number {
            font-weight: 700;
            font-size: 1.1rem;
        }
        
        .question-marks {
            color: var(--primary-color);
            font-weight: 600;
        }
        
        .question-text {
            font-size: 1.1rem;
            margin-bottom: 25px;
        }
        
        /* Options */
        .options-container {
            margin-bottom: 25px;
        }
        
        .option-item {
            display: flex;
            padding: 12px 15px;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            margin-bottom: 12px;
            cursor: pointer;
            transition: all 0.2s;
        }
        
        .option-item:hover {
            border-color: var(--primary-color);
            background-color: rgba(102, 126, 234, 0.02);
        }
        
        .option-item.selected {
            border-color: var(--primary-color);
            background-color: rgba(102, 126, 234, 0.05);
        }
        
        .option-input {
            margin-right: 15px;
        }
        
        .option-text {
            flex: 1;
        }
        
        /* Flag Button */
        .flag-btn {
            display: flex;
            align-items: center;
            color: #6c757d;
            background: none;
            border: none;
            cursor: pointer;
            padding: 5px 10px;
            border-radius: 5px;
            transition: all 0.2s;
        }
        
        .flag-btn:hover {
            color: var(--warning-color);
            background-color: rgba(255, 193, 7, 0.1);
        }
        
        .flag-btn.flagged {
            color: var(--warning-color);
        }
        
        .flag-btn i {
            margin-right: 5px;
        }
        
        /* Navigation Buttons */
        .nav-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        
        .btn-prev, .btn-next, .btn-submit {
            display: flex;
            align-items: center;
            padding: 10px 20px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-prev i, .btn-next i {
            transition: transform 0.3s;
        }
        
        .btn-prev:hover i {
            transform: translateX(-3px);
        }
        
        .btn-next:hover i {
            transform: translateX(3px);
        }
        
        .btn-submit {
            background: linear-gradient(135deg, var(--success-color), #1e7e34);
            border: none;
            color: white;
        }
        
        .btn-submit:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.3);
        }
        
        /* Short Answer & Essay */
        .answer-textarea {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            min-height: 150px;
            width: 100%;
            transition: all 0.2s;
        }
        
        .answer-textarea:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            outline: none;
        }
        
        .word-count {
            text-align: right;
            font-size: 0.85rem;
            color: #6c757d;
            margin-top: 5px;
        }
        
        /* Submit Confirmation Modal */
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
        
        /* User Info Display */
        .user-info {
            position: fixed;
            top: 30px;
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
        
        .user-info i {
            margin-right: 5px;
            color: var(--primary-color);
        }
        
        /* Exam Card for List View */
        .exam-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 25px;
            transition: transform 0.3s ease;
            overflow: hidden;
        }
        
        .exam-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        }
        
        .exam-card-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 20px 25px;
        }
        
        .exam-card-title {
            font-weight: 700;
            font-size: 1.35rem;
            margin-bottom: 0;
        }
        
        .exam-card-body {
            padding: 25px;
        }
        
        .exam-card-info {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
        }
        
        .info-item {
            display: flex;
            align-items: center;
            font-size: 0.95rem;
        }
        
        .info-item i {
            margin-right: 8px;
            color: var(--primary-color);
        }
        
        .status-badge {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 50px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        
        .badge-published {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .btn-start {
            padding: 12px 25px;
            font-weight: 700;
            border-radius: 50px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
            transition: all 0.3s;
        }
        
        .btn-start:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 15px rgba(102, 126, 234, 0.35);
        }
        
        /* Linked List Visualization Styles */
        .linked-list-container {
            margin-top: 40px;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 10px;
            border: 1px solid #dee2e6;
        }

        .linked-list-title {
            font-weight: 700;
            margin-bottom: 15px;
            color: #343a40;
        }

        .node-container {
            display: flex;
            flex-wrap: nowrap;
            overflow-x: auto;
            padding-bottom: 20px;
        }

        .list-node {
            min-width: 180px;
            height: 100px;
            margin-right: 30px;
            padding: 10px;
            border-radius: 8px;
            border: 2px solid #6f42c1;
            background-color: white;
            position: relative;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }

        .list-node::after {
            content: "→";
            position: absolute;
            right: -25px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 24px;
            color: #6f42c1;
        }

        .list-node:last-child::after {
            display: none;
        }

        .node-id {
            font-weight: 700;
            color: #007bff;
            margin-bottom: 5px;
        }

        .node-answer {
            font-size: 0.9rem;
            color: #212529;
            word-break: break-word;
            max-height: 40px;
            overflow: hidden;
        }

        .node-timestamp {
            font-size: 0.75rem;
            color: #6c757d;
            position: absolute;
            bottom: 5px;
            right: 10px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .timer-container {
                position: static;
            }
            
            .question-card {
                padding: 20px;
            }
            
            .nav-buttons {
                flex-direction: column;
                gap: 10px;
            }
            
            .btn-prev, .btn-next, .btn-submit {
                width: 100%;
                justify-content: center;
            }
            
            .question-nav {
                grid-template-columns: repeat(4, 1fr);
            }
            
            .list-node {
                min-width: 150px;
                height: 90px;
            }
        }
        
        @media (max-width: 576px) {
            .list-node {
                min-width: 130px;
                height: 85px;
            }
            
            .node-timestamp {
                font-size: 0.7rem;
            }
        }
    </style>
</head>
<body>

    <div class="user-info" id="userInfo">
        <i class="fas fa-user"></i>
        <span class="text-muted"><c:out value="${sessionScope.user.userId}" default="IT24102083"/></span>
    </div>

    <% if ("list".equals(viewMode)) { %>
    <!-- EXAM LIST VIEW -->
    <header class="exam-header">
        <div class="container">
            <h2 class="exam-title">Available Exams</h2>
            <div class="exam-info">Select an exam to begin</div>
        </div>
    </header>
    
    <div class="container mb-5">
        <div class="row">
            <% if (publishedExams != null && !publishedExams.isEmpty()) { 
                for (JsonObject listExam : publishedExams) {
                    String listExamId = listExam.has("examId") ? listExam.get("examId").getAsString() : "";
                    String listExamName = listExam.has("examName") ? listExam.get("examName").getAsString() : "Untitled Exam";
                    String listCourseId = listExam.has("courseId") ? listExam.get("courseId").getAsString() : "";
                    String listCreatedBy = listExam.has("createdBy") ? listExam.get("createdBy").getAsString() : "";
                    int listDuration = listExam.has("duration") ? listExam.get("duration").getAsInt() : 60;
                    int listTotalMarks = listExam.has("totalMarks") ? listExam.get("totalMarks").getAsInt() : 0;
            %>
                <div class="col-md-6 col-lg-4">
                    <div class="exam-card">
                        <div class="exam-card-header">
                            <h3 class="exam-card-title"><%= listExamName %></h3>
                        </div>
                        <div class="exam-card-body">
                            <div class="exam-card-info">
                                <div class="info-item">
                                    <i class="fas fa-book"></i>
                                    <span><%= listCourseId %></span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-user-tie"></i>
                                    <span>Prof. <%= listCreatedBy %></span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-clock"></i>
                                    <span><%= listDuration %> minutes</span>
                                </div>
                                <div class="info-item">
                                    <i class="fas fa-star"></i>
                                    <span><%= listTotalMarks %> marks</span>
                                </div>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="status-badge badge-published">
                                    <i class="fas fa-check-circle me-1"></i> Published
                                </span>
                                <a href="${pageContext.request.contextPath}/exam/take/<%= listExamId %>" class="btn btn-start">
                                    Start Exam
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            <% }
            } else { %>
                <div class="col-12">
                    <div class="alert alert-info text-center">
                        <i class="fas fa-info-circle me-2"></i>
                        No published exams available at this time.
                    </div>
                </div>
            <% } %>
        </div>
    </div>
    <% } else if ("take".equals(viewMode)) { %>
    <!-- EXAM TAKING VIEW -->
    <div id="examTakingSection">
        <!-- Exam Header -->
        <header class="exam-header">
            <div class="container">
                <h2 class="exam-title"><%= examTitleName %></h2>
                <div class="exam-info"><%= examCourseId %> • Prof. <%= examCreatedBy %> • Total Marks: <%= examTotalMarks %> • Duration: <%= examDuration %> minutes</div>
            </div>
        </header>
        
        <div class="container mb-5">
            <!-- The main form that wraps all exam questions -->
            <form id="examForm" method="post" action="${pageContext.request.contextPath}/exam/submit">
                <!-- Hidden field for exam ID -->
                <input type="hidden" id="examIdField" name="examId" value="<%= currentExam.has("examId") ? currentExam.get("examId").getAsString() : "" %>">
                <!-- Hidden field for saved answers - this was missing -->
                <input type="hidden" id="savedAnswersField" name="savedAnswers" value="{}">
                
                <div class="row">
                    <!-- Left Side: Question Content -->
                    <div class="col-lg-9">
                    <% 
                    // Iterate through questions from the database
                    List<JsonObject> questions = (List<JsonObject>) request.getAttribute("questions");
                    if (questions != null && !questions.isEmpty()) {
                        for (int i = 0; i < questions.size(); i++) {
                            JsonObject question = questions.get(i);
                            String questionId = question.has("questionId") ? question.get("questionId").getAsString() : "Q" + (i+1);
                            String questionText = question.has("questionText") ? question.get("questionText").getAsString() : "Question " + (i+1);
                            int points = question.has("points") ? question.get("points").getAsInt() : 0;
                            String questionType = question.has("questionType") ? question.get("questionType").getAsString() : "multiple_choice";
                    %>
                        <div class="question-card" id="question<%= i+1 %>" data-question-id="<%= questionId %>" <%= i > 0 ? "style=\"display: none;\"" : "" %>>
                            <div class="question-header">
                                <div class="question-number">Question <%= i+1 %></div>
                                <div class="question-marks"><%= points %> Marks</div>
                            </div>
                            
                            <div class="question-text">
                                <%= questionText %>
                            </div>
                            
                            <% if ("multiple_choice".equals(questionType) || "true_false".equals(questionType)) { %>
                                <div class="options-container">
                                <% 
                                JsonArray options = question.has("options") ? question.getAsJsonArray("options") : new JsonArray();
                                boolean isTrueFalse = "true_false".equals(questionType);
                                
                                for (int j = 0; j < options.size(); j++) {
                                    String option = options.get(j).getAsString();
                                    String optionValue = isTrueFalse ? option : String.valueOf((char)('A' + j));
                                %>
                                    <div class="option-item" onclick="selectOption(this)">
                                        <div class="option-input">
                                            <input type="radio" name="<%= questionId %>" id="<%= questionId %>_<%= optionValue.toLowerCase() %>" 
                                                   class="form-check-input" value="<%= optionValue %>">
                                        </div>
                                        <label for="<%= questionId %>_<%= optionValue.toLowerCase() %>" class="option-text">
                                            <%= isTrueFalse ? option : optionValue + ". " + option %>
                                        </label>
                                    </div>
                                <% } %>
                                </div>
                            <% } else { // Short answer or essay %>
                                <div class="options-container">
                                    <textarea name="<%= questionId %>" class="answer-textarea" 
                                              placeholder="Enter your answer here..." oninput="countWords(this)"></textarea>
                                    <div class="word-count">0 words</div>
                                </div>
                            <% } %>
                            
                            <button type="button" class="flag-btn" onclick="toggleFlag(this)">
                                <i class="far fa-flag"></i> Flag for review
                            </button>
                            
                            <div class="nav-buttons">
                                <button type="button" class="btn btn-outline-secondary btn-prev" onclick="loadQuestion(<%= i %>)" <%= i == 0 ? "disabled" : "" %>>
                                    <i class="fas fa-arrow-left me-2"></i> Previous
                                </button>
                                
                                <% if (i < questions.size() - 1) { %>
                                    <button type="button" class="btn btn-primary btn-next" onclick="loadQuestion(<%= i+2 %>)">
                                        Next <i class="fas fa-arrow-right ms-2"></i>
                                    </button>
                                <% } else { %>
                                    <button type="button" class="btn btn-success btn-submit" data-bs-toggle="modal" data-bs-target="#submitModal">
                                        Submit Exam
                                    </button>
                                <% } %>
                            </div>
                        </div>
                    <% 
                        } // End for loop
                    } else { // If no questions from database, show default questions
                    %>
                        <div class="question-card" id="question1" data-question-id="Q1">
                            <div class="question-header">
                                <div class="question-number">Question 1</div>
                                <div class="question-marks">5 Marks</div>
                            </div>
                            
                            <div class="question-text">
                                What is a primary key in a relational database?
                            </div>
                            
                            <div class="options-container">
                                <div class="option-item" onclick="selectOption(this)">
                                    <div class="option-input">
                                        <input type="radio" name="Q1" id="Q1_a" class="form-check-input" value="A">
                                    </div>
                                    <label for="Q1_a" class="option-text">A. A field that uniquely identifies each record in a table</label>
                                </div>
                                
                                <div class="option-item" onclick="selectOption(this)">
                                    <div class="option-input">
                                        <input type="radio" name="Q1" id="Q1_b" class="form-check-input" value="B">
                                    </div>
                                    <label for="Q1_b" class="option-text">B. A field that contains text data</label>
                                </div>
                                
                                <div class="option-item" onclick="selectOption(this)">
                                    <div class="option-input">
                                        <input type="radio" name="Q1" id="Q1_c" class="form-check-input" value="C">
                                    </div>
                                    <label for="Q1_c" class="option-text">C. A field that can be deleted</label>
                                </div>
                                
                                <div class="option-item" onclick="selectOption(this)">
                                    <div class="option-input">
                                        <input type="radio" name="Q1" id="Q1_d" class="form-check-input" value="D">
                                    </div>
                                    <label for="Q1_d" class="option-text">D. A field that contains numeric values only</label>
                                </div>
                            </div>
                            
                            <button type="button" class="flag-btn" onclick="toggleFlag(this)">
                                <i class="far fa-flag"></i> Flag for review
                            </button>
                            
                            <div class="nav-buttons">
                                <button type="button" class="btn btn-outline-secondary btn-prev" disabled>
                                    <i class="fas fa-arrow-left me-2"></i> Previous
                                </button>
                                
                                <button type="button" class="btn btn-primary btn-next" onclick="loadQuestion(2)">
                                    Next <i class="fas fa-arrow-right ms-2"></i>
                                </button>
                            </div>
                        </div>
                        
                        <!-- Other default questions here -->
                        <!-- (Skipping the rest of the default questions as they are similar to the first one) -->
                    <% } %>
                    
                    <!-- Linked List Visualization Section (Debug Mode) -->
                    <div class="linked-list-container" id="linkedListVisualizer">
                        <h4 class="linked-list-title">Answer Linked List Visualization</h4>
                        <div class="node-container" id="nodeContainer">
                            <!-- Nodes will be added dynamically by JavaScript -->
                        </div>
                    </div>
                    </div>
                    
                    <!-- Right Side: Timer and Navigation -->
                    <div class="col-lg-3">
                        <div class="timer-container">
                            <div class="timer-card">
                                <h5 class="text-center mb-2">Time Remaining</h5>
                                <div class="timer" id="timer" data-time-remaining="<%= timeRemainingSeconds %>">01:59:59</div>
                            </div>
                            
                            <div class="nav-card">
                                <div class="nav-title">Questions</div>
                                
                                <div class="progress-container">
                                    <div class="progress">
                                        <div class="progress-bar bg-success" role="progressbar" style="width: 0%" 
                                             aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                                    </div>
                                    <div class="progress-label">
                                        <span>0 of <%= questions != null ? questions.size() : 4 %> answered</span>
                                        <span>0%</span>
                                    </div>
                                </div>
                                
                                <div class="question-nav">
                                    <% 
                                    int totalQs = questions != null ? questions.size() : 4;
                                    for (int i = 1; i <= totalQs; i++) {
                                    %>
                                    <div class="nav-item <%= i == 1 ? "active" : "" %>" onclick="loadQuestion(<%= i %>)"><%= i %></div>
                                    <% } %>
                                </div>
                                
                                <div class="mt-4">
                                    <div class="d-flex align-items-center mb-2">
                                        <div class="nav-item me-2" style="width: 30px; height: 30px;"></div>
                                        <small>Not answered</small>
                                    </div>
                                    
                                    <div class="d-flex align-items-center mb-2">
                                        <div class="nav-item active me-2" style="width: 30px; height: 30px;"></div>
                                        <small>Current question</small>
                                    </div>
                                    
                                    <div class="d-flex align-items-center mb-2">
                                        <div class="nav-item answered me-2" style="width: 30px; height: 30px;"></div>
                                        <small>Answered</small>
                                    </div>
                                    
                                    <div class="d-flex align-items-center">
                                        <div class="nav-item flagged me-2" style="width: 30px; height: 30px;"></div>
                                        <small>Flagged for review</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
            
            <!-- Submit Confirmation Modal -->
            <div class="modal fade" id="submitModal" tabindex="-1" aria-labelledby="submitModalLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="submitModalLabel">Submit Exam</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Are you sure you want to submit this exam?
                            </div>
                            
                            <p>You have:</p>
                            <ul>
                                <li id="answeredSummary">Answered <strong>0 of <%= questions != null ? questions.size() : 4 %></strong> questions</li>
                                <li id="flaggedSummary">Flagged <strong>0</strong> questions for review</li>
                                <li id="timeSummary"><strong>01:59:59</strong> time remaining</li>
                            </ul>
                            
                            <p class="mb-0">Once submitted, you will not be able to make any changes.</p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                                Continue Exam
                            </button>
                            <button type="button" class="btn btn-success" onclick="submitExam()">
                                Submit Exam
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <% if ("take".equals(viewMode)) { %>
    <!-- Custom JavaScript for exam taking functionality -->
    <script src="${pageContext.request.contextPath}/js/take-exam.js"></script>
    
    <!-- Additional script for linked list visualization -->
    <script>
        // Check if in debug mode 
        const debugMode = true;
        
        // Function to update the linked list visualization
        function updateLinkedListVisualizer() {
            if (!debugMode || !linkedListAnswers) return;
            
            const container = document.getElementById('nodeContainer');
            if (!container) return;
            
            // Clear current visualization
            container.innerHTML = '';
            
            // Get nodes from linked list
            let current = linkedListAnswers.head;
            let count = 0;
            
            // Show message if list is empty
            if (!current) {
                const emptyMessage = document.createElement('div');
                emptyMessage.className = 'text-muted';
                emptyMessage.textContent = 'No answers in linked list yet.';
                container.appendChild(emptyMessage);
                return;
            }
            
            // Add nodes to visualization (limit to 10)
            while (current && count < 10) {
                const nodeElement = document.createElement('div');
                nodeElement.className = 'list-node';
                
                const nodeId = document.createElement('div');
                nodeId.className = 'node-id';
                nodeId.textContent = current.questionId;
                
                const nodeAnswer = document.createElement('div');
                nodeAnswer.className = 'node-answer';
                nodeAnswer.textContent = current.answer || '(empty)';
                
                const nodeTimestamp = document.createElement('div');
                nodeTimestamp.className = 'node-timestamp';
                
                // Format timestamp if available
                if (current.timestamp) {
                    const date = new Date(current.timestamp);
                    nodeTimestamp.textContent = date.toLocaleTimeString();
                } else {
                    nodeTimestamp.textContent = 'No timestamp';
                }
                
                nodeElement.appendChild(nodeId);
                nodeElement.appendChild(nodeAnswer);
                nodeElement.appendChild(nodeTimestamp);
                container.appendChild(nodeElement);
                
                current = current.next;
                count++;
            }
            
            // Show more indicator if there are more nodes
            if (current) {
                const moreIndicator = document.createElement('div');
                moreIndicator.className = 'list-node';
                moreIndicator.style.justifyContent = 'center';
                moreIndicator.style.alignItems = 'center';
                moreIndicator.style.display = 'flex';
                moreIndicator.textContent = '...more';
                container.appendChild(moreIndicator);
            }
        }
        
        // Override saveAnswerToLinkedList to update visualization
        const originalSaveAnswerToLinkedList = window.saveAnswerToLinkedList;
        window.saveAnswerToLinkedList = function(questionCard) {
            // Call original function
            if (originalSaveAnswerToLinkedList) {
                originalSaveAnswerToLinkedList(questionCard);
            }
            
            // Update visualization
            updateLinkedListVisualizer();
        };
        
        // Initialize visualization when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Check if we should show the visualizer in non-debug mode
            if (!debugMode) {
                const visualizer = document.getElementById('linkedListVisualizer');
                if (visualizer) {
                    visualizer.style.display = 'none';
                }
            }
            
            // Initially update after a short delay to give time for linked list to initialize
            setTimeout(updateLinkedListVisualizer, 500);
        });
    </script>
    <% } %>
</body>
</html>