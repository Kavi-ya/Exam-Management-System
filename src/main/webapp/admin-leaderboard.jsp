<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*, java.time.*, java.time.format.DateTimeFormatter, com.exam.model.Result" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leaderboard - Exam Management System</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <!-- AOS - Animate On Scroll Library -->
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <!-- Chart.js CDN -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    
    <!-- Custom CSS -->
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
        
        html {
            scroll-behavior: smooth;
        }
        
        body {
            font-family: 'Nunito', sans-serif;
            margin: 0;
            padding: 0;
            overflow-x: hidden;
            background-color: #f5f7fa;
        }
        
        /* Logo */
        .hiddenlogo {
            display: none;
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
            color: white;
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
        
        /* Top Navbar for toggle button only */
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
        
        /* Leaderboard Styles */
        .leaderboard-header {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            padding: 50px 0 80px;
            text-align: center;
            border-radius: 0 0 50% 50% / 20px;
            margin-bottom: 30px;
        }
        
        .leaderboard-title {
            font-weight: 800;
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .leaderboard-subtitle {
            opacity: 0.9;
            max-width: 600px;
            margin: 0 auto;
        }
        
        .leaderboard-container {
            margin-top: -50px;
            z-index: 10;
            position: relative;
        }
        
        .leaderboard-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        
        .chart-container {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
            min-height: 450px;
            position: relative;
        }
        
        .chart-header {
            font-weight: 700;
            font-size: 1.5rem;
            margin-bottom: 20px;
            color: var(--primary-color);
            text-align: center;
        }
        
        .chart-canvas-container {
            position: relative;
            height: 300px;
            width: 100%;
            margin-top: 20px;
        }
        
        .table {
            margin-bottom: 0;
        }
        
        .table th {
            font-weight: 700;
            color: var(--primary-color);
            border-top: none;
            padding: 15px;
        }
        
        .table td {
            vertical-align: middle;
            padding: 15px;
            border-color: rgba(0, 0, 0, 0.05);
        }
        
        .rank {
            font-weight: 800;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            margin: 0 auto;
        }
        
        .rank-1 {
            background: linear-gradient(135deg, #FFD700, #FFA500);
            box-shadow: 0 5px 15px rgba(255, 215, 0, 0.3);
        }
        
        .rank-2 {
            background: linear-gradient(135deg, #C0C0C0, #A9A9A9);
            box-shadow: 0 5px 15px rgba(192, 192, 192, 0.3);
        }
        
        .rank-3 {
            background: linear-gradient(135deg, #CD7F32, #A0522D);
            box-shadow: 0 5px 15px rgba(205, 127, 50, 0.3);
        }
        
        .rank-other {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            box-shadow: 0 5px 15px rgba(75, 108, 183, 0.2);
        }
        
        .score-badge {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            font-weight: 700;
            padding: 8px 15px;
            border-radius: 30px;
        }
        
        .passed-badge {
            background-color: #28a745;
            color: white;
            font-weight: 700;
            padding: 8px 15px;
            border-radius: 30px;
        }
        
        .failed-badge {
            background-color: #dc3545;
            color: white;
            font-weight: 700;
            padding: 8px 15px;
            border-radius: 30px;
        }
        
        .exam-filter {
            padding: 15px 30px;
            background-color: white;
            border-radius: 50px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        
        .filter-btn {
            border-radius: 30px;
            padding: 8px 20px;
            font-weight: 600;
            margin: 5px;
        }
        
        .filter-btn.active {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            border: none;
            color: white;
            box-shadow: 0 5px 15px rgba(75, 108, 183, 0.3);
        }
        
        .back-to-top {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            box-shadow: 0 5px 15px rgba(75, 108, 183, 0.3);
            cursor: pointer;
            z-index: 1000;
            transition: all 0.3s ease;
            opacity: 0;
            pointer-events: none;
        }
        
        .back-to-top.active {
            opacity: 1;
            pointer-events: auto;
        }
        
        .back-to-top:hover {
            transform: translateY(-5px);
        }
        
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
        
        .user-badge {
            position: fixed;
            top: 30px;
            right: 30px;
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
        
        .user-badge i {
            margin-right: 5px;
            color: var(--primary-color);
        }
        
        .chart-types {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .chart-type-btn {
            border-radius: 30px;
            padding: 8px 20px;
            font-weight: 600;
            margin: 0 5px;
            background-color: var(--light-color);
            color: var(--dark-color);
            border: none;
            transition: all 0.3s ease;
            min-width: 120px;
        }
        
        .chart-type-btn.active {
            background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
            color: white;
            box-shadow: 0 5px 15px rgba(75, 108, 183, 0.3);
        }
        
        /* Empty row styling */
        .no-data {
            color: #888;
            font-style: italic;
        }
        
        /* Enhanced table styling */
        .table-striped > tbody > tr:nth-of-type(odd) {
            background-color: rgba(0, 0, 0, 0.02);
        }
        
        .table-hover tbody tr:hover {
            background-color: rgba(75, 108, 183, 0.05);
        }
        
        /* User info styling */
        .user-avatar {
            width: 30px;
            height: 30px;
            border-radius: 50%;
            margin-right: 10px;
            border: 2px solid var(--primary-color);
        }
        
        /* Loading indicator styles */
        #chartLoadingIndicator {
            z-index: 10;
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
            
            .chart-type-btn {
                min-width: 100px;
                padding: 6px 15px;
                font-size: 0.9rem;
            }
        }

        /* Fix for links in sidebar */
        .menu-item a {
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
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

    <!-- User Badge Display -->
    <div class="user-badge" id="currentUser">
        <img src="<c:out value='${sessionScope.user.profileImage}' default='./assets/images/admin-avatar.jpg'/>" alt="Admin_User" class="user-avatar">
        <span class="text-muted"><c:out value="${sessionScope.user.userId}" default="IT24102083"/></span>
    </div>

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
            <li class="menu-item active">
                <a href="${pageContext.request.contextPath}/leaderboard.jsp">
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
        <!-- Top navbar with menu toggle -->
        <div class="top-navbar">
            <div class="d-flex align-items-center">
                <button class="menu-toggle me-3" id="menu-toggle">
                    <i class="fas fa-bars"></i>
                </button>
                <h4 class="mb-0">Leaderboard</h4>
            </div>
            <div></div> <!-- Empty div to maintain space-between alignment -->
        </div>

        <!-- Leaderboard Header -->
        <div class="leaderboard-header">
            <div class="container">
                <h1 class="leaderboard-title animate__animated animate__fadeInUp">Exam Leaderboard</h1>
                <p class="leaderboard-subtitle animate__animated animate__fadeInUp animate__delay-1s">
                    See how students rank among each other. Track the progress and identify top performers!
                </p>
            </div>
        </div>

        <!-- Leaderboard Content -->
        <div class="container leaderboard-container">
            <!-- Exam Filter Section -->
            <div class="exam-filter d-flex justify-content-between align-items-center flex-wrap mb-4">
                <div>
                    <h5 class="mb-0">Filter by Exam:</h5>
                </div>
                <div class="d-flex flex-wrap" id="exam-filters">
                    <button class="btn btn-light filter-btn active" data-exam="all">All Exams</button>
                    <!-- Dynamic exam filters will be added by JavaScript -->
                </div>
            </div>

            <!-- Performance Chart -->
            <div class="row mb-4">
                <div class="col-md-12">
                    <div class="chart-container">
                        <h3 class="chart-header">Performance Overview</h3>
                        <div class="chart-types mb-3">
                            <button class="chart-type-btn active" data-type="bar">Bar Chart</button>
                            <button class="chart-type-btn" data-type="pie">Pie Chart</button>
                        </div>
                        
                        <!-- Loading indicator -->
                        <div id="chartLoadingIndicator" class="text-center" style="position:absolute; left:0; right:0; top:130px; display:none;">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-2 text-muted">Loading chart data...</p>
                        </div>
                        
                        <!-- Error message container -->
                        <div id="chartErrorMessage" class="alert alert-warning mt-3" style="display:none;">
                            No chart data available. Try another exam filter.
                        </div>
                        
                        <!-- Chart canvas with proper container -->
                        <div class="chart-canvas-container" style="position: relative; height:300px; width:100%;">
                            <canvas id="performanceChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Leaderboard Card -->
            <div class="leaderboard-card animate__animated animate__fadeInUp">
                <%
                    // Define passing threshold as a constant
                    final double PASSING_THRESHOLD = 60.0;
                
                    // Create a list to hold our result objects
                    List<Result> results = new ArrayList<>();
                    
                    // Create a set to track unique exam IDs
                    Set<String> uniqueExams = new HashSet<>();
                    
                    // Track unique student IDs for chart data organization
                    Map<String, Double> studentBestScores = new HashMap<>();
                    
                    try {
                        // Get the path to the results.json file
                        String filePath = application.getRealPath("/WEB-INF/data/results.json");
                        File file = new File(filePath);
                        
                        if (file.exists()) {
                            // Read the file contents
                            BufferedReader reader = new BufferedReader(new FileReader(file));
                            StringBuilder jsonContent = new StringBuilder();
                            String line;
                            while ((line = reader.readLine()) != null) {
                                jsonContent.append(line);
                            }
                            reader.close();
                            
                            // Manual parsing of the JSON data
                            // This is a simplified approach without requiring a JSON library
                            String json = jsonContent.toString().trim();
                            
                            // Check if it's a JSON array
                            if (json.startsWith("[") && json.endsWith("]")) {
                                // Remove the outer brackets
                                json = json.substring(1, json.length() - 1);
                                
                                // Split by closing and opening braces to get individual objects
                                // This is a simplified approach that works for well-formatted JSON
                                String[] jsonObjects = json.split("\\},\\s*\\{");
                                
                                for (int i = 0; i < jsonObjects.length; i++) {
                                    String jsonObj = jsonObjects[i];
                                    
                                    // Fix the first and last items
                                    if (i == 0) {
                                        jsonObj = jsonObj + "}";
                                    } else if (i == jsonObjects.length - 1) {
                                        jsonObj = "{" + jsonObj;
                                    } else {
                                        jsonObj = "{" + jsonObj + "}";
                                    }
                                    
                                    // Extract data using string operations
                                    String resultId = extractField(jsonObj, "resultId");
                                    String examId = extractField(jsonObj, "examId");
                                    String userId = extractField(jsonObj, "userId");
                                    String submittedAt = extractField(jsonObj, "submittedAt");
                                    
                                    // Skip entries with missing key data
                                    if (examId == null || examId.isEmpty() || userId == null || userId.isEmpty()) {
                                        continue;
                                    }
                                    
                                    // Parse score - handle potential formatting issues
                                    double scoreValue = 0.0;
                                    String scoreStr = extractField(jsonObj, "score");
                                    if (scoreStr != null && !scoreStr.isEmpty()) {
                                        try {
                                            scoreValue = Double.parseDouble(scoreStr);
                                        } catch (NumberFormatException e) {
                                            // Default to 0 if parsing fails
                                            scoreValue = 0.0;
                                        }
                                    }
                                    
                                    // Parse earned points
                                    int earnedPoints = 0;
                                    String earnedPointsStr = extractField(jsonObj, "earnedPoints");
                                    if (earnedPointsStr != null && !earnedPointsStr.isEmpty()) {
                                        try {
                                            earnedPoints = Integer.parseInt(earnedPointsStr);
                                        } catch (NumberFormatException e) {
                                            // Default to 0 if parsing fails
                                            earnedPoints = 0;
                                        }
                                    }
                                    
                                    // Parse total points
                                    int totalPoints = 0;
                                    String totalPointsStr = extractField(jsonObj, "totalPoints");
                                    if (totalPointsStr != null && !totalPointsStr.isEmpty()) {
                                        try {
                                            totalPoints = Integer.parseInt(totalPointsStr);
                                        } catch (NumberFormatException e) {
                                            // Default to 0 if parsing fails
                                            totalPoints = 0;
                                        }
                                    }
                                    
                                    // Skip entries with zero total points to avoid NaN percentages
                                    if (totalPoints == 0) {
                                        continue;
                                    }
                                    
                                    // Calculate percentage for determining passed status
                                    double percentage = 0.0;
                                    if (totalPoints > 0) {
                                        // Use earnedPoints for calculations if available
                                        if (earnedPoints > 0) {
                                            percentage = (double) earnedPoints / totalPoints * 100;
                                        } else {
                                            percentage = scoreValue * 100 / totalPoints;
                                        }
                                    }
                                    
                                    // Determine passed status based on percentage threshold
                                    boolean passed = percentage >= PASSING_THRESHOLD;
                                    
                                    // Create the Result object
                                    Result result = new Result();
                                    result.setResultId(resultId);
                                    result.setExamId(examId);
                                    result.setStudentId(userId);
                                    result.setScore(earnedPoints > 0 ? earnedPoints : (int) Math.round(scoreValue));
                                    result.setMaxScore(totalPoints);
                                    result.setPassed(passed);
                                    result.setSubmissionTime(submittedAt);
                                    
                                    // Track best scores per student for chart
                                    String studentKey = userId + "-" + examId;
                                    if (!studentBestScores.containsKey(studentKey) || 
                                        studentBestScores.get(studentKey) < percentage) {
                                        studentBestScores.put(studentKey, percentage);
                                    }
                                    
                                    // Add to our list
                                    results.add(result);
                                    
                                    // Track unique exam IDs
                                    if (examId != null && !examId.isEmpty()) {
                                        uniqueExams.add(examId);
                                    }
                                }
                            }
                        }
                    } catch (Exception e) {
                        // Log the error or display it in the page
                        out.println("<div class='alert alert-danger'>Error loading results: " + e.getMessage() + "</div>");
                    }
                    
                    // Selection Sort implementation - sort by percentage score (highest to lowest)
                    for (int i = 0; i < results.size() - 1; i++) {
                        int maxIndex = i;
                        
                        for (int j = i + 1; j < results.size(); j++) {
                            double currentPercentage = results.get(j).getPercentage();
                            double maxPercentage = results.get(maxIndex).getPercentage();
                            
                            if (currentPercentage > maxPercentage) {
                                maxIndex = j;
                            }
                        }
                        
                        // Swap elements
                        if (maxIndex != i) {
                            Result temp = results.get(i);
                            results.set(i, results.get(maxIndex));
                            results.set(maxIndex, temp);
                        }
                    }
                    
                    // Ensure we have valid entries in positions 1, 2, 3
                    // This prevents empty spaces in the leaderboard
                    while (results.size() < 3) {
                        Result placeholderResult = new Result();
                        placeholderResult.setResultId("placeholder-" + results.size());
                        placeholderResult.setStudentId("N/A");
                        placeholderResult.setExamId("N/A");
                        placeholderResult.setScore(0);
                        placeholderResult.setMaxScore(100);
                        placeholderResult.setPassed(false);
                        placeholderResult.setSubmissionTime("N/A");
                        results.add(placeholderResult);
                    }
                %>
                
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle" id="leaderboardTable">
                        <thead>
                            <tr class="text-center">
                                <th>Rank</th>
                                <th>Student ID</th>
                                <th>Exam ID</th>
                                <th>Score</th>
                                <th>Percentage</th>
                                <th>Status</th>
                                <th>Submission Time</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                                int rank = 1;
                                boolean hasResults = false;
                                for (Result result : results) {
                                    String rankClass = "";
                                    if (rank == 1) rankClass = "rank-1";
                                    else if (rank == 2) rankClass = "rank-2";
                                    else if (rank == 3) rankClass = "rank-3";
                                    else rankClass = "rank-other";
                                    
                                    // Flag to mark placeholder rows
                                    boolean isPlaceholder = result.getStudentId().equals("N/A");
                                    if (!isPlaceholder) hasResults = true;
                                    
                                    // Get percentage for pass/fail determination
                                    double percentage = result.getPercentage();
                            %>
                            <tr class="text-center <%= isPlaceholder ? "placeholder-row" : "" %>" data-exam="<%= result.getExamId() %>">
                                <td class="rank-cell">
                                    <div class="rank <%= rankClass %>"><%= rank %></div>
                                </td>
                                <td><strong><%= result.getStudentId() %></strong></td>
                                <td><%= result.getExamId() %></td>
                                <td><strong><%= result.getScoreDisplay() %></strong></td>
                                <td>
                                    <span class="score-badge">
                                        <%= String.format("%.1f", percentage) %>%
                                    </span>
                                </td>
                                <td>
                                    <% if (percentage >= PASSING_THRESHOLD) { %>
                                        <span class="passed-badge">
                                            <i class="fas fa-check-circle me-1"></i> Passed
                                        </span>
                                    <% } else { %>
                                        <span class="failed-badge">
                                            <i class="fas fa-times-circle me-1"></i> Failed
                                        </span>
                                    <% } %>
                                </td>
                                <td><%= isPlaceholder ? "N/A" : result.getFormattedSubmissionTime() %></td>
                            </tr>
                            <% 
                                rank++;
                                } 
                                // Add a "no data" row to show when filtering yields no results
                                if (hasResults) {
                            %>
                            <tr class="text-center no-data-row" style="display: none;">
                                <td colspan="7" class="no-data">No results match the selected filter</td>
                            </tr>
                            <% } else { %>
                            <tr class="text-center no-data-row">
                                <td colspan="7" class="no-data">No exam results available</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- Back to top button -->
        <div class="back-to-top" id="backToTop">
            <i class="fas fa-arrow-up"></i>
        </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- AOS - Animate On Scroll Library -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>

    <!-- Helper function to extract JSON fields - placed at the end -->
    <%!
        // Define a helper method to extract fields from JSON
        private String extractField(String json, String fieldName) {
            try {
                // Simple pattern matching to extract field values
                String pattern = "\"" + fieldName + "\"\\s*:\\s*\"?([^\"^,^}]*)\"?";
                java.util.regex.Pattern r = java.util.regex.Pattern.compile(pattern);
                java.util.regex.Matcher m = r.matcher(json);
                if (m.find()) {
                    return m.group(1);
                }
            } catch (Exception e) {
                // Silent fail and return empty string
            }
            return "";
        }
    %>

    <!-- Custom JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Show loading indicator while chart initializes
            const loadingIndicator = document.getElementById('chartLoadingIndicator');
            loadingIndicator.style.display = 'block';
            
            // Hide any error messages
            document.getElementById('chartErrorMessage').style.display = 'none';
            
            // Set a timeout to prevent infinite loading
            const loadTimeout = setTimeout(function() {
                if (loadingIndicator.style.display !== 'none') {
                    loadingIndicator.style.display = 'none';
                    document.getElementById('chartErrorMessage').style.display = 'block';
                    document.getElementById('chartErrorMessage').textContent = 
                        'Chart loading timed out. Please refresh the page.';
                }
            }, 5000); // 5 second timeout
            
            try {
                // Initialize exam filters
                const examFilters = document.getElementById('exam-filters');
                const uniqueExams = [
                    <% 
                    Iterator<String> iterator = uniqueExams.iterator();
                    while (iterator.hasNext()) {
                        String examId = iterator.next();
                        out.print("'" + examId + "'");
                        if (iterator.hasNext()) {
                            out.print(", ");
                        }
                    }
                    %>
                ];
                
                // Create a button for each unique exam
                uniqueExams.forEach(function(examId) {
                    const button = document.createElement('button');
                    button.className = 'btn btn-light filter-btn';
                    button.setAttribute('data-exam', examId);
                    button.textContent = examId;
                    examFilters.appendChild(button);
                });
                
                // Enhanced vibrant colors for charts
                const vibrantColors = [
                    'rgba(255, 99, 132, 0.7)',    // Pink
                    'rgba(54, 162, 235, 0.7)',    // Blue
                    'rgba(255, 206, 86, 0.7)',    // Yellow
                    'rgba(75, 192, 192, 0.7)',    // Teal
                    'rgba(153, 102, 255, 0.7)',   // Purple
                    'rgba(255, 159, 64, 0.7)',    // Orange
                    'rgba(199, 0, 57, 0.7)',      // Red
                    'rgba(46, 204, 113, 0.7)',    // Green
                    'rgba(52, 152, 219, 0.7)',    // Light Blue
                    'rgba(155, 89, 182, 0.7)'     // Violet
                ];
                
                const vibrantBorders = [
                    'rgba(255, 99, 132, 1)',      // Pink
                    'rgba(54, 162, 235, 1)',      // Blue
                    'rgba(255, 206, 86, 1)',      // Yellow
                    'rgba(75, 192, 192, 1)',      // Teal
                    'rgba(153, 102, 255, 1)',     // Purple
                    'rgba(255, 159, 64, 1)',      // Orange
                    'rgba(199, 0, 57, 1)',        // Red
                    'rgba(46, 204, 113, 1)',      // Green
                    'rgba(52, 152, 219, 1)',      // Light Blue
                    'rgba(155, 89, 182, 1)'       // Violet
                ];
                
                // Special colors for top ranks
                const topRankColors = [
                    'rgba(255, 215, 0, 0.7)',     // Gold for 1st
                    'rgba(192, 192, 192, 0.7)',    // Silver for 2nd
                    'rgba(205, 127, 50, 0.7)'      // Bronze for 3rd
                ];
                
                const topRankBorders = [
                    'rgba(255, 215, 0, 1)',        // Gold for 1st
                    'rgba(192, 192, 192, 1)',      // Silver for 2nd
                    'rgba(205, 127, 50, 1)'        // Bronze for 3rd
                ];
                
                // Prepare chart data
                const chartData = {
                    labels: [],
                    datasets: [{
                        label: 'Score Percentage',
                        data: [],
                        backgroundColor: [],
                        borderColor: [],
                        borderWidth: 1
                    }]
                };
                
                <% 
                // Take top 10 results for the chart - with error handling
                try {
                    int chartLimit = Math.min(10, results.size());
                    for(int i = 0; i < chartLimit; i++) {
                        Result r = results.get(i);
                        // Skip placeholder results for the chart
                        if (r.getStudentId().equals("N/A")) continue;
                        %>
                        chartData.labels.push('<%= r.getStudentId() %> - <%= r.getExamId() %>');
                        chartData.datasets[0].data.push(<%= String.format("%.1f", r.getPercentage()) %>);
                        
                        // Add colors based on rank
                        if (<%= i %> < 3) {
                            chartData.datasets[0].backgroundColor.push(topRankColors[<%= i %>]);
                            chartData.datasets[0].borderColor.push(topRankBorders[<%= i %>]);
                        } else {
                            const colorIndex = (<%= i %> - 3) % vibrantColors.length;
                            chartData.datasets[0].backgroundColor.push(vibrantColors[colorIndex]);
                            chartData.datasets[0].borderColor.push(vibrantBorders[colorIndex]);
                        }
                        <%
                    }
                } catch(Exception e) {
                    // Handle error gracefully
                    out.println("console.error('Error loading chart data: " + e.getMessage().replace("'", "\\'") + "');");
                }
                %>
                
                // Check if we have valid data before creating the chart
                if (chartData.labels.length === 0) {
                    throw new Error('No valid chart data available');
                }
                
                // Clear loading timeout since we're ready to create the chart
                clearTimeout(loadTimeout);
                
                // Create chart with a small delay to ensure DOM is ready
                setTimeout(() => {
                    try {
                        const ctx = document.getElementById('performanceChart').getContext('2d');
                        let myChart = new Chart(ctx, {
                            type: 'bar',
                            data: chartData,
                            options: {
                                responsive: true,
                                maintainAspectRatio: false,
                                plugins: {
                                    legend: {
                                        display: false,
                                        position: 'top',
                                    },
                                    title: {
                                        display: false
                                    },
                                    tooltip: {
                                        callbacks: {
                                            label: function(context) {
                                                return context.dataset.label + ': ' + context.raw + '%';
                                            }
                                        }
                                    }
                                },
                                scales: {
                                    y: {
                                        beginAtZero: true,
                                        max: 100,
                                        ticks: {
                                            callback: function(value) {
                                                return value + '%';
                                            }
                                        }
                                    }
                                }
                            }
                        });
                        
                        // Hide loading indicator once chart is created
                        loadingIndicator.style.display = 'none';
                        
                        // Chart type buttons functionality
                        document.querySelectorAll('.chart-type-btn').forEach(button => {
                            button.addEventListener('click', function() {
                                const chartType = this.getAttribute('data-type');
                                
                                // Show loading during chart change
                                loadingIndicator.style.display = 'block';
                                
                                // Small delay to prevent UI freeze
                                setTimeout(() => {
                                    try {
                                        // Remove active class from all buttons
                                        document.querySelectorAll('.chart-type-btn').forEach(btn => {
                                            btn.classList.remove('active');
                                        });
                                        
                                        // Add active class to clicked button
                                        this.classList.add('active');
                                        
                                        // Destroy previous chart
                                        myChart.destroy();
                                        
                                        // Create new chart with selected type
                                        myChart = new Chart(ctx, {
                                            type: chartType,
                                            data: chartData,
                                            options: {
                                                responsive: true,
                                                maintainAspectRatio: false,
                                                plugins: {
                                                    legend: {
                                                        display: chartType === 'pie',
                                                        position: 'top',
                                                    },
                                                    title: {
                                                        display: false
                                                    },
                                                    tooltip: {
                                                        callbacks: {
                                                            label: function(context) {
                                                                return chartType === 'pie' ? 
                                                                    context.label + ': ' + context.raw + '%' : 
                                                                    context.dataset.label + ': ' + context.raw + '%';
                                                            }
                                                        }
                                                    }
                                                },
                                                scales: chartType !== 'pie' ? {
                                                    y: {
                                                        beginAtZero: true,
                                                        max: 100,
                                                        ticks: {
                                                            callback: function(value) {
                                                                return value + '%';
                                                            }
                                                        }
                                                    }
                                                } : {}
                                            }
                                        });
                                        
                                        // Hide loading
                                        loadingIndicator.style.display = 'none';
                                    } catch (err) {
                                        console.error('Error changing chart type:', err);
                                        loadingIndicator.style.display = 'none';
                                        document.getElementById('chartErrorMessage').style.display = 'block';
                                        document.getElementById('chartErrorMessage').textContent = 
                                            'Error changing chart type: ' + err.message;
                                    }
                                }, 100);
                            });
                        });
                        
                        // Function to update chart based on exam filter with error handling
                        window.updateChart = function(examId) {
                            // Show loading
                            loadingIndicator.style.display = 'block';
                            
                            // Wrap in timeout to prevent UI freeze
                            setTimeout(() => {
                                try {
                                    // Get filtered results
                                    const rows = document.querySelectorAll('#leaderboardTable tbody tr:not(.no-data-row)');
                                    const filteredLabels = [];
                                    const filteredData = [];
                                    const filteredColors = [];
                                    const filteredBorders = [];
                                    
                                    // Count visible rows (max 10 for chart)
                                    let visibleCount = 0;
                                    
                                    rows.forEach((row, index) => {
                                        if (visibleCount >= 10) return;
                                        
                                        const rowExamId = row.getAttribute('data-exam');
                                        if ((examId === 'all' || rowExamId === examId) && !row.classList.contains('placeholder-row')) {
                                            const studentId = row.querySelector('td:nth-child(2)').textContent.trim();
                                            
                                            // Skip if studentId is "N/A"
                                            if (studentId === "N/A") return;
                                            
                                            const rowExam = row.querySelector('td:nth-child(3)').textContent.trim();
                                            const percentageText = row.querySelector('.score-badge').textContent.trim();
                                            const percentage = parseFloat(percentageText);
                                            
                                            // Skip invalid percentages
                                            if (isNaN(percentage)) return;
                                            
                                            filteredLabels.push(studentId + ' - ' + rowExam);
                                            filteredData.push(percentage);
                                            
                                            // Add color based on rank
                                            if (visibleCount < 3) {
                                                filteredColors.push(topRankColors[visibleCount]);
                                                filteredBorders.push(topRankBorders[visibleCount]);
                                            } else {
                                                const colorIndex = (visibleCount - 3) % vibrantColors.length;
                                                filteredColors.push(vibrantColors[colorIndex]);
                                                filteredBorders.push(vibrantBorders[colorIndex]);
                                            }
                                            
                                            visibleCount++;
                                        }
                                    });
                                    
                                    // Check if we have valid filtered data
                                    if (filteredLabels.length === 0) {
                                        document.getElementById('chartErrorMessage').style.display = 'block';
                                        document.getElementById('chartErrorMessage').textContent = 
                                            'No data available for the selected filter.';
                                    } else {
                                        document.getElementById('chartErrorMessage').style.display = 'none';
                                    }
                                    
                                    // Get current chart type
                                    const activeChartTypeBtn = document.querySelector('.chart-type-btn.active');
                                    const chartType = activeChartTypeBtn ? activeChartTypeBtn.getAttribute('data-type') : 'bar';
                                    
                                    // Update chart data
                                    myChart.data.labels = filteredLabels;
                                    myChart.data.datasets[0].data = filteredData;
                                    myChart.data.datasets[0].backgroundColor = filteredColors;
                                    myChart.data.datasets[0].borderColor = filteredBorders;
                                    
                                    // Update chart type if needed
                                    myChart.config.type = chartType;
                                    
                                    // Update legend visibility based on chart type
                                    myChart.options.plugins.legend.display = chartType === 'pie';
                                    
                                    // Update the chart
                                    myChart.update();
                                    
                                    // Hide loading
                                    loadingIndicator.style.display = 'none';
                                } catch (err) {
                                    console.error('Error updating chart:', err);
                                    loadingIndicator.style.display = 'none';
                                    document.getElementById('chartErrorMessage').style.display = 'block';
                                    document.getElementById('chartErrorMessage').textContent = 
                                        'Error updating chart: ' + err.message;
                                }
                            }, 100);
                        };
                        
                        // Add click event to all filter buttons
                        const filterButtons = document.querySelectorAll('.filter-btn');
                        filterButtons.forEach(button => {
                            button.addEventListener('click', function() {
                                // Remove active class from all buttons
                                filterButtons.forEach(btn => btn.classList.remove('active'));
                                
                                // Add active class to clicked button
                                this.classList.add('active');
                                
                                // Get the exam ID to filter by
                                const examId = this.getAttribute('data-exam');
                                
                                // Filter the table rows
                                filterResults(examId);
                                
                                // Update the chart
                                updateChart(examId);
                            });
                        });
                    } catch (err) {
                        console.error('Error initializing chart:', err);
                        loadingIndicator.style.display = 'none';
                        document.getElementById('chartErrorMessage').style.display = 'block';
                        document.getElementById('chartErrorMessage').textContent = 
                            'Failed to initialize chart: ' + err.message;
                    }
                }, 200);
            } catch (err) {
                clearTimeout(loadTimeout);
                console.error('Chart setup error:', err);
                loadingIndicator.style.display = 'none';
                document.getElementById('chartErrorMessage').style.display = 'block';
                document.getElementById('chartErrorMessage').textContent = 
                    'Failed to setup chart: ' + err.message;
            }
            
            // Initialize AOS animation library
            AOS.init({
                duration: 800,
                easing: 'ease-in-out',
                once: true,
                mirror: false
            });
            
            // Back to top button functionality
            const backToTopButton = document.getElementById('backToTop');
            
            window.addEventListener('scroll', function() {
                if (window.pageYOffset > 300) {
                    backToTopButton.classList.add('active');
                } else {
                    backToTopButton.classList.remove('active');
                }
            });
            
            backToTopButton.addEventListener('click', function() {
                window.scrollTo({
                    top: 0,
                    behavior: 'smooth'
                });
            });
            
            // Toggle sidebar - FIXED VERSION
            document.getElementById('menu-toggle').addEventListener('click', function() {
                const sidebar = document.getElementById('sidebar');
                const mainContent = document.getElementById('main-content');
                const logoText = document.querySelector('.sidebar-header .logo-text');
                
                sidebar.classList.toggle('sidebar-collapsed');
                mainContent.classList.toggle('main-content-expanded');
                
                // Toggle the visibility of the ExamPro text
                if (logoText) {
                    logoText.classList.toggle('hiddenlogo');
                }
            });
            
            // Set current date and time
            const currentDateTime = document.getElementById('currentDateTime');
            if (currentDateTime) {
                currentDateTime.innerHTML = `
                    <i class="far fa-calendar-alt"></i>
                    <span>2025-05-04 23:42:44</span>
                `;
            }
            
            // Set current user
            const currentUser = document.getElementById('currentUser');
            if (currentUser) {
                currentUser.innerHTML = `
                    <img src="./assets/images/admin-avatar.jpg" alt="Admin_User" class="user-avatar">
                    <span class="text-muted">IT24102083</span>
                `;
            }
        });
        
        // Function to filter results by exam ID
        function filterResults(examId) {
            try {
                const rows = document.querySelectorAll('#leaderboardTable tbody tr:not(.no-data-row)');
                let visibleRank = 1;
                let visibleCount = 0;
                
                rows.forEach(row => {
                    const rowExamId = row.getAttribute('data-exam');
                    
                    // Show/hide based on filter
                    if (examId === 'all' || rowExamId === examId) {
                        row.style.display = '';
                        
                        // Update rank
                        const rankEl = row.querySelector('.rank');
                        if (rankEl) {
                            rankEl.textContent = visibleRank;
                            
                            // Update rank styling
                            rankEl.className = 'rank';
                            if (visibleRank === 1) {
                                rankEl.classList.add('rank-1');
                            } else if (visibleRank === 2) {
                                rankEl.classList.add('rank-2');
                            } else if (visibleRank === 3) {
                                rankEl.classList.add('rank-3');
                            } else {
                                rankEl.classList.add('rank-other');
                            }
                        }
                        
                        visibleRank++;
                        visibleCount++;
                    } else {
                        row.style.display = 'none';
                    }
                });
                
                // Check if no results are shown
                const noDataRow = document.querySelector('.no-data-row');
                if (noDataRow) {
                    noDataRow.style.display = visibleCount === 0 ? '' : 'none';
                }
            } catch (error) {
                console.error("Error filtering results:", error);
            }
        }
    </script>
</body>
</html>