<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        body {
            font-family: 'Nunito', sans-serif;
            background-color: #f5f7fa;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .error-card {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            padding: 30px;
            max-width: 500px;
            text-align: center;
        }
        
        .error-icon {
            font-size: 3rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        
        .error-title {
            font-weight: 700;
            margin-bottom: 15px;
            font-size: 1.5rem;
        }
        
        .error-message {
            color: #6c757d;
            margin-bottom: 25px;
        }
        
        .btn-back {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 50px;
            font-weight: 600;
            transition: all 0.3s;
        }
        
        .btn-back:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            color: white;
        }
    </style>
</head>
<body>
    <div class="error-card">
        <div class="error-icon">
            <i class="fas fa-exclamation-circle"></i>
        </div>
        <h1 class="error-title">Oops! Something went wrong</h1>
        <p class="error-message">${error}</p>
        <a href="${pageContext.request.contextPath}/" class="btn btn-back">
            <i class="fas fa-home me-2"></i> Back to Home
        </a>
    </div>
</body>
</html>