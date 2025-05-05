<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.google.gson.JsonObject, com.google.gson.JsonArray" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%
    // Get attributes
    JsonObject exam = (JsonObject) request.getAttribute("exam");
    List<JsonObject> questions = (List<JsonObject>) request.getAttribute("questions");
    JsonObject result = (JsonObject) request.getAttribute("result");
    String currentDateTime = (String) request.getAttribute("currentDateTime");
    String currentUserId = (String) request.getAttribute("currentUserId");
    
    // Default values if attributes are null
    if (exam == null) exam = new JsonObject();
    if (questions == null) questions = java.util.Collections.emptyList();
    if (result == null) result = new JsonObject();
    if (currentDateTime == null) currentDateTime = "2025-05-04 20:38:53"; // Updated current date/time
    if (currentUserId == null) currentUserId = "IT24102083"; // Default user ID
    
    // Extract result data
    double score = result.has("score") ? result.get("score").getAsDouble() : 0.0;
    int earnedPoints = result.has("earnedPoints") ? result.get("earnedPoints").getAsInt() : 0;
    int totalPoints = result.has("totalPoints") ? result.get("totalPoints").getAsInt() : 0;
    boolean passed = result.has("passed") ? result.get("passed").getAsBoolean() : false;
    String submittedAt = result.has("submittedAt") ? result.get("submittedAt").getAsString() : currentDateTime;
    long timeTakenSeconds = result.has("timeTakenSeconds") ? result.get("timeTakenSeconds").getAsLong() : 0;
    JsonArray answers = result.has("answers") ? result.getAsJsonArray("answers") : new JsonArray();
    
    // Get exam details
    String examName = exam.has("examName") ? exam.get("examName").getAsString() : "Exam";
    String courseId = exam.has("courseId") ? exam.get("courseId").getAsString() : "";
    %>
    <title>Exam Results - <%= examName %></title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <!-- AOS - Animate on Scroll Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
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
            --blue-color: #007bff;
            --blue-dark: #0056b3;
            --purple-color: #6f42c1;
            --purple-dark: #5e35b1;
        }
        
        body {
            font-family: 'Nunito', sans-serif;
            background-color: #f5f7fa;
            min-height: 100vh;
            overflow-x: hidden;
        }
        
        /* Header */
        .result-header {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: 40px 0;
            margin-bottom: 40px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        
        .result-header::before {
            content: '';
            position: absolute;
            top: -50%;
            left: -50%;
            width: 200%;
            height: 200%;
            background: radial-gradient(rgba(255,255,255,0.1), transparent);
            transform: rotate(-30deg);
            z-index: 1;
        }
        
        .result-title {
            font-weight: 800;
            margin-bottom: 15px;
            position: relative;
            z-index: 2;
            text-shadow: 0 2px 5px rgba(0,0,0,0.2);
            animation: fadeInDown 1s;
        }
        
        .result-subtitle {
            font-weight: 600;
            opacity: 0.9;
            position: relative;
            z-index: 2;
            animation: fadeIn 1.2s;
        }
        
        /* Score Section */
        .score-card {
            background-color: white;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-bottom: 30px;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .score-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.12);
        }
        
        .score-circle-container {
            position: relative;
            width: 220px;
            height: 220px;
            margin: 0 auto 30px;
        }
        
        .score-circle-bg {
            position: absolute;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            background: #f0f0f0;
        }
        
        .score-circle {
            position: relative;
            width: 100%;
            height: 100%;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: conic-gradient(
                <%= passed ? "var(--success-color)" : "var(--danger-color)" %> 0%,
                <%= passed ? "var(--success-color)" : "var(--danger-color)" %> <%= score %>%,
                #f0f0f0 <%= score %>%,
                #f0f0f0 100%
            );
            box-shadow: 0 10px 25px <%= passed ? "rgba(40, 167, 69, 0.25)" : "rgba(220, 53, 69, 0.25)" %>;
            color: white;
            font-size: 3rem;
            font-weight: 800;
            animation: fadeIn 1s, scoreAnimation 1.5s ease-out;
        }
        
        @keyframes scoreAnimation {
            0% {
                background: conic-gradient(
                    <%= passed ? "var(--success-color)" : "var(--danger-color)" %> 0%,
                    <%= passed ? "var(--success-color)" : "var(--danger-color)" %> 0%,
                    #f0f0f0 0%,
                    #f0f0f0 100%
                );
            }
            100% {
                background: conic-gradient(
                    <%= passed ? "var(--success-color)" : "var(--danger-color)" %> 0%,
                    <%= passed ? "var(--success-color)" : "var(--danger-color)" %> <%= score %>%,
                    #f0f0f0 <%= score %>%,
                    #f0f0f0 100%
                );
            }
        }
        
        .score-inner {
            position: absolute;
            width: 80%;
            height: 80%;
            background-color: white;
            border-radius: 50%;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        
        .score-percent {
            font-size: 3.2rem;
            font-weight: 800;
            color: <%= passed ? "var(--success-color)" : "var(--danger-color)" %>;
            margin-bottom: 0;
            line-height: 1;
        }
        
        .score-label {
            font-size: 1rem;
            font-weight: 600;
            color: var(--dark-color);
            opacity: 0.8;
        }
        
        .score-details {
            margin-top: 25px;
            border-top: 1px solid #eee;
            padding-top: 25px;
        }
        
        .score-detail-item {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #f2f2f2;
            transition: all 0.3s;
        }
        
        .score-detail-item:hover {
            background-color: rgba(0,0,0,0.01);
            padding-left: 5px;
            padding-right: 5px;
        }
        
        .score-detail-item:last-child {
            border-bottom: none;
        }
        
        .score-detail-item strong {
            color: var(--primary-color);
        }
        
        .score-status {
            font-size: 1.5rem;
            font-weight: 700;
            margin-top: 15px;
            margin-bottom: 10px;
            padding: 15px 25px;
            border-radius: 50px;
            display: inline-block;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.03);
            }
            100% {
                transform: scale(1);
            }
        }
        
        .score-status.pass {
            background-color: rgba(40, 167, 69, 0.1);
            color: var(--success-color);
        }
        
        .score-status.fail {
            background-color: rgba(220, 53, 69, 0.1);
            color: var(--danger-color);
        }
        
        /* Questions Review */
        .questions-header {
            margin-bottom: 25px;
            position: relative;
            padding-bottom: 15px;
        }
        
        .questions-header::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 70px;
            height: 4px;
            background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
            border-radius: 2px;
        }
        
        .review-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: all 0.3s;
        }
        
        .accordion-item {
            border: none;
            margin-bottom: 15px;
            border-radius: 15px !important;
            overflow: hidden;
            transition: all 0.3s;
        }
        
        .accordion-item:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        }
        
        .accordion-button {
            padding: 18px 25px;
            font-weight: 600;
            background-color: #ffffff;
            border: none;
            border-radius: 15px !important;
        }
        
        .accordion-button:not(.collapsed) {
            color: var(--primary-color);
            background-color: rgba(102, 126, 234, 0.05);
        }
        
        .accordion-button:focus {
            box-shadow: none;
            border-color: #dee2e6;
        }
        
        .accordion-button::after {
            background-size: 18px;
            transition: all 0.3s;
        }
        
        .accordion-body {
            padding: 20px 25px;
            background-color: #ffffff;
        }
        
        .review-content {
            margin-bottom: 20px;
            font-size: 1.05rem;
        }
        
        .review-answer-label {
            font-size: 0.9rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: var(--dark-color);
        }
        
        .review-answer {
            background-color: #f8f9fa;
            padding: 15px 18px;
            border-radius: 10px;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        
        .review-answer:hover {
            transform: translateX(5px);
        }
        
        .review-answer.correct {
            background-color: rgba(40, 167, 69, 0.08);
            border-left: 4px solid var(--success-color);
        }
        
        .review-answer.incorrect {
            background-color: rgba(220, 53, 69, 0.08);
            border-left: 4px solid var(--danger-color);
        }
        
        .review-answer.correct-answer {
            background-color: rgba(23, 162, 184, 0.08);
            border-left: 4px solid var(--info-color);
        }
        
        .review-status-icon {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 28px;
            height: 28px;
            line-height: 28px;
            text-align: center;
            border-radius: 50%;
            margin-right: 10px;
        }
        
        .icon-correct {
            background-color: var(--success-color);
            color: white;
            box-shadow: 0 3px 8px rgba(40, 167, 69, 0.25);
        }
        
        .icon-incorrect {
            background-color: var(--danger-color);
            color: white;
            box-shadow: 0 3px 8px rgba(220, 53, 69, 0.25);
        }
        
        /* Action Buttons */
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-top: 30px;
            margin-bottom: 60px;
        }
        
        .btn-action {
            padding: 14px 28px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1rem;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            z-index: 1;
            background: linear-gradient(135deg, var(--blue-color), var(--blue-dark));
            color: white;
            border: none;
        }
        
        .btn-action:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }
        
        .btn-action::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: 50px;
            z-index: -2;
            background: linear-gradient(135deg, var(--blue-color), var(--blue-dark));
        }
        
        .btn-action::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
            border-radius: 50px;
            z-index: -1;
        }
        
        .btn-action:hover::before {
            width: 100%;
        }
        
        .btn-dark {
            padding: 14px 28px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1rem;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            transition: all 0.3s;
            position: relative;
            overflow: hidden;
            z-index: 1;
            background: linear-gradient(135deg, var(--purple-color), var(--purple-dark));
            color: white;
            border: none;
        }
        
        .btn-dark:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
        }
        
        .btn-dark::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: 50px;
            z-index: -2;
            background: linear-gradient(135deg, var(--purple-color), var(--purple-dark));
        }
        
        .btn-dark::before {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
            border-radius: 50px;
            z-index: -1;
        }
        
        .btn-dark:hover::before {
            width: 100%;
        }
        
        /* Current Date Display */
        .info-badge {
            position: fixed;
            background-color: rgba(255, 255, 255, 0.95);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 12px 18px;
            border-radius: 50px;
            font-size: 0.9rem;
            font-weight: 600;
            color: var(--dark-color);
            display: flex;
            align-items: center;
            z-index: 1000;
            backdrop-filter: blur(5px);
            -webkit-backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: slideInRight 0.5s;
        }
        
        .current-date {
            top: 20px;
            right: 20px;
        }
        
        .user-info {
            top: 75px;
            right: 20px;
        }
        
        .info-badge i {
            margin-right: 10px;
            color: var(--primary-color);
            font-size: 1.1rem;
        }
        
        /* Animation */
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes fadeInDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes slideInRight {
            from {
                transform: translateX(50px);
                opacity: 0;
            }
            to {
                transform: translateX(0);
                opacity: 1;
            }
        }
        
        /* Container animations */
        .fade-in {
            animation: fadeIn 0.8s;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .action-buttons {
                flex-direction: column;
                gap: 15px;
            }
            
            .btn-action {
                width: 100%;
            }
            
            .score-circle-container {
                width: 180px;
                height: 180px;
            }
            
            .score-percent {
                font-size: 2.5rem;
            }
        }
    </style>
</head>
<body>
    
    <!-- User Info Display -->
    <div class="info-badge user-info">
        <i class="fas fa-user"></i>
        <!-- <span><%= currentUserId %></span> -->
        <c:out value="${sessionScope.user.userId}" default="IT24102083"/>
    </div>
    
    <!-- Result Header -->
    <header class="result-header">
        <div class="container">
            <h1 class="result-title">Exam Results</h1>
            <div class="result-subtitle"><%= examName %> • <%= courseId %></div>
        </div>
    </header>
    
    <div class="container">
        <div class="row">
            <!-- Score Card -->
            <div class="col-lg-4 mb-4" data-aos="fade-right" data-aos-duration="800">
                <div class="score-card">
                    <div class="score-circle-container">
                        <div class="score-circle">
                            <div class="score-inner">
                                <div class="score-percent"><%= score %>%</div>
                                <div class="score-label">Score</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="score-status <%= passed ? "pass" : "fail" %>">
                        <i class="fas <%= passed ? "fa-check-circle" : "fa-times-circle" %> me-2"></i>
                        <%= passed ? "PASSED" : "FAILED" %>
                    </div>
                    
                    <div class="score-details">
                        <div class="score-detail-item">
                            <div>Total Questions</div>
                            <div><strong><%= questions.size() %></strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Total Marks</div>
                            <div><strong><%= totalPoints %></strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Marks Obtained</div>
                            <div><strong><%= earnedPoints %></strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Time Taken</div>
                            <div><strong><%= Math.floor(timeTakenSeconds / 60) %>m <%= timeTakenSeconds % 60 %>s</strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Date</div>
                            <div><strong><%= submittedAt %></strong></div>
                        </div>
                        
                        <div class="score-detail-item">
                            <div>Student ID</div>
                            <strong><c:out value="${sessionScope.user.userId}" default="IT24102083"/></strong>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Questions Review -->
            <div class="col-lg-8" data-aos="fade-left" data-aos-duration="800" data-aos-delay="200">
                <h3 class="questions-header">Question Review</h3>
                
                <div class="accordion" id="questionReviewAccordion">
                    <% 
                    // Create a map for efficient answer lookup
                    Map<String, JsonObject> answerMap = new java.util.HashMap<>();
                    for (int j = 0; j < answers.size(); j++) {
                        JsonObject answer = answers.get(j).getAsJsonObject();
                        if (answer.has("questionId")) {
                            answerMap.put(answer.get("questionId").getAsString(), answer);
                        }
                    }
                    
                    // Display each question with answers
                    for (int i = 0; i < questions.size(); i++) {
                        JsonObject question = questions.get(i);
                        String questionId = question.has("questionId") ? question.get("questionId").getAsString() : "";
                        String questionText = question.has("questionText") ? question.get("questionText").getAsString() : "";
                        int points = question.has("points") ? question.get("points").getAsInt() : 0;
                        
                        // Find matching answer
                        JsonObject answerObj = answerMap.get(questionId);
                        boolean isCorrect = answerObj != null && answerObj.has("isCorrect") ? 
                            answerObj.get("isCorrect").getAsBoolean() : false;
                        String studentAnswer = answerObj != null && answerObj.has("answer") ? 
                            answerObj.get("answer").getAsString() : "";
                        String correctAnswer = answerObj != null && answerObj.has("correctAnswer") ? 
                            answerObj.get("correctAnswer").getAsString() : "";
                    %>
                        <div class="accordion-item" data-aos="fade-up" data-aos-duration="500" data-aos-delay="<%= 100 * i %>">
                            <h2 class="accordion-header" id="heading<%= i %>">
                                <button class="accordion-button <%= i == 0 ? "" : "collapsed" %>" type="button" 
                                        data-bs-toggle="collapse" data-bs-target="#collapse<%= i %>" 
                                        aria-expanded="<%= i == 0 ? "true" : "false" %>" aria-controls="collapse<%= i %>">
                                    <div class="d-flex justify-content-between w-100 align-items-center pe-3">
                                        <div>
                                            <span class="review-status-icon <%= isCorrect ? "icon-correct" : "icon-incorrect" %>">
                                                <i class="fas <%= isCorrect ? "fa-check" : "fa-times" %>"></i>
                                            </span>
                                            Question <%= i + 1 %>
                                        </div>
                                        <div class="text-muted"><%= points %> Marks</div>
                                    </div>
                                </button>
                            </h2>
                            <div id="collapse<%= i %>" class="accordion-collapse collapse <%= i == 0 ? "show" : "" %>" 
                                 aria-labelledby="heading<%= i %>" data-bs-parent="#questionReviewAccordion">
                                <div class="accordion-body">
                                    <div class="review-content">
                                        <p><%= questionText %></p>
                                    </div>
                                    
                                    <div class="review-answer-label">Your Answer:</div>
                                    <div class="review-answer <%= isCorrect ? "correct" : "incorrect" %>">
                                        <%= studentAnswer.isEmpty() ? "<em>No answer provided</em>" : studentAnswer %>
                                    </div>
                                    
                                    <% if (!isCorrect) { %>
                                        <div class="review-answer-label">Correct Answer:</div>
                                        <div class="review-answer correct-answer">
                                            <%= correctAnswer %>
                                        </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    <% } %>
                </div>
            </div>
        </div>
        
        <!-- Action Buttons -->
        <div class="action-buttons" data-aos="fade-up" data-aos-duration="800">
            <a href="${pageContext.request.contextPath}/exams" class="btn btn-action btn-exams">
                <i class="fas fa-home me-2"></i> Back to Exams
            </a>
            <a href="${pageContext.request.contextPath}/student_dashboard.jsp" class="btn btn-action btn-dashboard">
                <i class="fas fa-tachometer-alt me-2"></i> Dashboard
            </a>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- AOS - Animate on Scroll -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    <!-- Initialize animations -->
    <script>
        // Initialize AOS
        document.addEventListener('DOMContentLoaded', function() {
            AOS.init({
                once: true, // whether animation should happen only once - while scrolling down
                duration: 800 // values from 0 to 3000, with step 50ms
            });
            
            // Animated counting for the score
            const countElement = document.querySelector('.score-percent');
            const targetScore = <%= score %>;
            let currentCount = 0;
            
            const interval = setInterval(() => {
                currentCount += 1;
                countElement.textContent = currentCount + "%";
                
                if (currentCount >= targetScore) {
                    clearInterval(interval);
                }
            }, 15);
            
            // Accordion item highlighting
            const accordionItems = document.querySelectorAll('.accordion-item');
            accordionItems.forEach(item => {
                item.addEventListener('mouseenter', () => {
                    item.style.transform = 'translateY(-5px)';
                });
                
                item.addEventListener('mouseleave', () => {
                    item.style.transform = '';
                });
            });
        });
    </script>
</body>
</html>