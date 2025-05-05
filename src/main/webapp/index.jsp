<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Exam Management System</title>
    
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
    
    <!-- Custom CSS -->
    <style>
        :root {
            --primary-color: #667eea;
            --primary-dark: #5a6ecd;
            --secondary-color: #764ba2;
            --secondary-dark: #6a439a;
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
        
        /* Navigation */
        .navbar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            padding: 15px 0;
        }
        
        .navbar.scrolled {
            padding: 8px 0;
            background: rgba(255, 255, 255, 0.98);
        }
        
        .navbar-brand {
            font-weight: 800;
            font-size: 1.5rem;
            color: var(--primary-color);
            transition: all 0.3s ease;
        }
        
        .navbar-brand:hover {
            transform: translateY(-3px);
            color: var(--secondary-color);
        }
        
        .nav-link {
            font-weight: 600;
            color: var(--dark-color);
            margin: 0 10px;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .nav-link:before {
            content: "";
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 0;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            transition: all 0.3s ease;
            opacity: 0;
        }
        
        .nav-link:hover:before {
            width: 100%;
            opacity: 1;
        }
        
        .nav-link:hover {
            color: var(--primary-color);
        }
        
        .nav-link.active:before {
            width: 100%;
            opacity: 1;
        }
        
        .auth-buttons .btn {
            border-radius: 50px;
            padding: 8px 20px;
            margin-left: 10px;
            font-weight: 600;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            transition: all 0.3s ease;
        }
        
        .btn-login {
            background-color: transparent;
            border: 1px solid var(--primary-color);
            color: var(--primary-color);
        }
        
        .btn-login:hover {
            background-color: var(--primary-color);
            color: white;
            transform: translateY(-3px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-register {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border: none;
            color: white;
        }
        
        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(118, 75, 162, 0.4);
        }
        
        /* Hero Section */
        .hero-section {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 150px 0 100px;
            position: relative;
            overflow: hidden;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
        }
        
        .hero-title {
            font-weight: 800;
            font-size: 3.5rem;
            margin-bottom: 20px;
        }
        
        .hero-subtitle {
            font-size: 1.2rem;
            margin-bottom: 30px;
            opacity: 0.9;
        }
        
        .hero-buttons .btn {
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            margin-right: 15px;
            margin-bottom: 10px;
        }
        
        .btn-light-outline {
            background-color: transparent;
            border: 2px solid white;
            color: white;
        }
        
        .btn-light-outline:hover {
            background-color: white;
            color: var(--primary-color);
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(255, 255, 255, 0.3);
        }
        
        .hero-image {
            position: relative;
            left: 150px;
            z-index: 1;
        }
        
        .hero-image img {
            max-width: 80%;
            border-radius: 15px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
        }
        
        .particles-container {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
            overflow: hidden;
        }
        
        .shape {
            position: absolute;
            opacity: 0.3;
        }
        
        .shape1 {
            top: -50px;
            right: -50px;
            width: 300px;
            height: 300px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
        }
        
        .shape2 {
            bottom: -100px;
            left: -100px;
            width: 500px;
            height: 500px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
        }
        
        /* Features Section */
        .features-section {
            padding: 100px 0;
            background-color: white;
        }
        
        .section-title {
            margin-bottom: 60px;
            position: relative;
            text-align: center;
        }
        
        .section-title h2 {
            font-weight: 700;
            font-size: 2.5rem;
            margin-bottom: 20px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: inline-block;
        }
        
        .section-title p {
            max-width: 700px;
            margin: 0 auto;
            color: #6c757d;
        }
        
        .feature-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05);
            height: 100%;
        }
        
        .feature-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }
        
        .feature-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 25px;
            font-size: 1.8rem;
            color: white;
            box-shadow: 0 10px 20px rgba(118, 75, 162, 0.3);
        }
        
        .feature-title {
            font-weight: 700;
            margin-bottom: 15px;
            font-size: 1.4rem;
        }
        
        /* How It Works */
        .how-it-works {
            padding: 100px 0;
            background-color: #f8f9fa;
        }
        
        .step-card {
            background-color: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            margin-bottom: 30px;
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05);
            height: 100%;
        }
        
        .step-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }
        
        .step-img {
            height: 200px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 4rem;
            color: white;
            overflow: hidden;
        }
        
        .step-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .step-content {
            padding: 30px;
        }
        
        .step-number {
            display: inline-block;
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            border-radius: 50%;
            text-align: center;
            line-height: 40px;
            font-weight: 700;
            margin-bottom: 15px;
            box-shadow: 0 10px 20px rgba(118, 75, 162, 0.3);
        }
        
        .step-title {
            font-weight: 700;
            margin-bottom: 15px;
            font-size: 1.4rem;
        }
        
        /* Stats Section */
        .stats-section {
            padding: 100px 0;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            position: relative;
            overflow: hidden;
        }
        
        .stat-card {
            text-align: center;
            padding: 20px;
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            margin-bottom: 30px;
            backdrop-filter: blur(5px);
            transition: all 0.3s ease;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }
        
        .stat-card:hover {
            transform: translateY(-10px);
            background-color: rgba(255, 255, 255, 0.2);
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            margin-bottom: 10px;
        }
        
        .stat-title {
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            opacity: 0.8;
        }
        
        /* Testimonials */
        .testimonials-section {
            padding: 100px 0;
            background-color: white;
        }
        
        .testimonial-card {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            padding: 30px;
            margin-bottom: 30px;
            transition: all 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05);
            height: 100%;
        }
        
        .testimonial-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }
        
        .testimonial-content {
            margin-bottom: 20px;
            font-style: italic;
            color: #6c757d;
            position: relative;
        }
        
        .testimonial-content:before {
            content: "\201C";
            font-size: 5rem;
            position: absolute;
            top: -40px;
            left: -20px;
            color: #f0f0f0;
            z-index: -1;
            font-family: Georgia, serif;
            opacity: 0.6;
        }
        
        .testimonial-user {
            display: flex;
            align-items: center;
        }
        
        .testimonial-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin-right: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }
        
        .testimonial-info h5 {
            margin: 0;
            font-weight: 700;
        }
        
        .testimonial-info small {
            color: #6c757d;
        }
        
        /* CTA Section */
        .cta-section {
            padding: 100px 0;
            background: linear-gradient(135deg, #43cea2, #185a9d);
            color: white;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .cta-content {
            position: relative;
            z-index: 2;
            max-width: 700px;
            margin: 0 auto;
        }
        
        .cta-title {
            font-weight: 800;
            font-size: 2.5rem;
            margin-bottom: 20px;
        }
        
        .cta-subtitle {
            margin-bottom: 30px;
            opacity: 0.9;
            font-size: 1.1rem;
        }
        
        .cta-buttons .btn {
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            margin: 0 10px 10px;
        }
        
        /* Footer */
        .footer {
            background-color: var(--dark-color);
            color: rgba(255, 255, 255, 0.7);
            padding: 70px 0 30px;
        }
        
        .footer-logo {
            font-weight: 800;
            font-size: 1.8rem;
            margin-bottom: 20px;
            color: white;
        }
        
        .footer-description {
            margin-bottom: 30px;
            font-size: 0.9rem;
            line-height: 1.7;
        }
        
        .footer-title {
            font-weight: 700;
            font-size: 1.2rem;
            margin-bottom: 25px;
            color: white;
        }
        
        .footer-links {
            list-style: none;
            padding: 0;
        }
        
        .footer-links li {
            margin-bottom: 15px;
        }
        
        .footer-links a {
            color: rgba(255, 255, 255, 0.7);
            text-decoration: none;
            transition: all 0.3s ease;
        }
        
        .footer-links a:hover {
            color: white;
            padding-left: 5px;
        }
        
        .footer-social {
            display: flex;
            margin-top: 20px;
        }
        
        .social-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: rgba(255, 255, 255, 0.1);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 10px;
            color: rgba(255, 255, 255, 0.7);
            transition: all 0.3s ease;
        }
        
        .social-icon:hover {
            background-color: var(--primary-color);
            color: white;
            transform: translateY(-3px);
        }
        
        .footer-contact li {
            margin-bottom: 15px;
            display: flex;
            align-items: center;
        }
        
        .footer-contact li i {
            margin-right: 10px;
            width: 20px;
        }
        
        .copyright {
            text-align: center;
            padding-top: 30px;
            margin-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            font-size: 0.9rem;
        }
        
        /* Responsive */
        @media (max-width: 992px) {
            .hero-title {
                font-size: 2.8rem;
            }
            
            .hero-image {
                margin-top: 30px;
            }
        }
        
        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            
            .section-title h2 {
                font-size: 2rem;
            }
            
            .footer {
                text-align: center;
            }
            
            .footer-social {
                justify-content: center;
            }
            
            .footer-contact li {
                justify-content: center;
            }
        }
        
        /* Animated Counter */
        .counter-container {
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }
        
        /* Float Animation */
        .float {
            animation: float 6s ease-in-out infinite;
        }
        
        @keyframes float {
            0% {
                transform: translateY(0);
            }
            50% {
                transform: translateY(-20px);
            }
            100% {
                transform: translateY(0);
            }
        }
        
        /* Scroll down indicator */
        .scroll-down {
            position: absolute;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            flex-direction: column;
            align-items: center;
            color: white;
            opacity: 0.8;
            transition: all 0.3s ease;
        }
        
        .scroll-down:hover {
            opacity: 1;
        }
        
        .scroll-down span {
            font-size: 0.8rem;
            margin-bottom: 5px;
        }
        
        .mouse {
            width: 30px;
            height: 50px;
            border: 2px solid white;
            border-radius: 20px;
            display: flex;
            justify-content: center;
            padding-top: 10px;
        }
        
        .wheel {
            width: 4px;
            height: 8px;
            background-color: white;
            border-radius: 2px;
            animation: scroll 1.5s infinite;
        }
        
        @keyframes scroll {
            0% {
                transform: translateY(0);
                opacity: 1;
            }
            100% {
                transform: translateY(15px);
                opacity: 0;
            }
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

        /* Toast container */
        .toast-container {
            z-index: 9999;
        }
    </style>
</head>
<body>
    <div class="current-date" id="currentDateTime">
        <i class="fas fa-calendar-alt"></i>
        <span>2025-05-04 00:03:24</span>
    </div>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-light fixed-top">
        <div class="container">
            <a class="navbar-brand" href="index.jsp">
                <i class="fas fa-graduation-cap me-2"></i>ExamPro
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link active" href="#home">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#features">Features</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#how-it-works">How It Works</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#testimonials">Testimonials</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="#contact">Contact</a>
                    </li>
                </ul>
                <div class="auth-buttons">
                    <a href="./adminLogin" class="btn btn-login">Admin</a>
                    <a href="./login" class="btn btn-login">Login</a>
                    <a href="./register.jsp" class="btn btn-register">Sign Up</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Hero Section -->
    <section class="hero-section" id="home">
        <div class="particles-container" id="particles-js"></div>
        <div class="shape shape1"></div>
        <div class="shape shape2"></div>
        
        <div class="container">
            <div class="row align-items-center">
                <div class="col-lg-6 hero-content">
                    <h1 class="hero-title animate__animated animate__fadeInUp">
                        Streamline Your Exam Management Process
                    </h1>
                    <p class="hero-subtitle animate__animated animate__fadeInUp animate__delay-1s">
                        A comprehensive solution for creating, conducting, and evaluating exams. 
                        Save time, reduce errors, and improve student performance.
                    </p>
                    <div class="hero-buttons animate__animated animate__fadeInUp animate__delay-2s">
                        <a href="register.jsp" class="btn btn-light">Get Started</a>
                        <a href="#features" class="btn btn-light-outline">Learn More</a>
                    </div>
                </div>
                <div class="col-lg-6 hero-image animate__animated animate__fadeInRight animate__delay-1s">
                    <img src="https://images.unsplash.com/photo-1606326608690-4e0281b1e588?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80" alt="Exam Management" class="img-fluid float">
                </div>
            </div>
        </div>
        
        <a href="#features" class="scroll-down">
            <span>Scroll Down</span>
            <div class="mouse">
                <div class="wheel"></div>
            </div>
        </a>
    </section>

    <!-- Features Section -->
    <section class="features-section" id="features">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>Key Features</h2>
                <p>Our exam management system offers powerful tools to streamline the entire examination process, from creation to evaluation.</p>
            </div>
            
            <div class="row">
                <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-edit"></i>
                        </div>
                        <h3 class="feature-title">Exam Creation</h3>
                        <p>Create and customize exams with different question types including multiple choice, true/false, short answer, and essays.</p>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <h3 class="feature-title">Scheduled Exams</h3>
                        <p>Schedule exams ahead of time with customizable time limits, availability windows, and attempt restrictions.</p>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <h3 class="feature-title">Results Analysis</h3>
                        <p>Generate detailed reports and analytics to track student performance and identify areas for improvement.</p>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="400">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-lock"></i>
                        </div>
                        <h3 class="feature-title">Secure Testing</h3>
                        <p>Ensure the integrity of exams with browser lockdown, randomized questions, and plagiarism prevention.</p>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="500">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-mobile-alt"></i>
                        </div>
                        <h3 class="feature-title">Mobile Friendly</h3>
                        <p>Access exams and results on any device with our responsive design that works on desktops, tablets, and smartphones.</p>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="600">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <h3 class="feature-title">User Management</h3>
                        <p>Easily manage students, teachers, and administrators with role-based access control and permissions.</p>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- How It Works Section -->
    <section class="how-it-works" id="how-it-works">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>How It Works</h2>
                <p>Get started with our exam management system in just a few simple steps.</p>
            </div>
            
            <div class="row">
                <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="step-card">
                        <div class="step-img">
                            <img src="https://images.unsplash.com/photo-1516321318423-f06f85e504b3?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1740&q=80" alt="Create Account" class="img-fluid">
                        </div>
                        <div class="step-content"><a href="./register.jsp" style="text-decoration: none; color: inherit;">
                            <div class="step-number">1</div>
                            <h3 class="step-title">Create an Account</h3>
                            <p>Sign up as a student, teacher, or administrator to access features tailored to your role.</p>
                        </a></div>
                    </div>
                </div>
                
                <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="step-card">
                        <div class="step-img">
                            <img src="https://images.unsplash.com/photo-1488190211105-8b0e65b80b4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80" alt="Create or Join Exams" class="img-fluid">
                        </div>
                        <div class="step-content">
                            <div class="step-number">2</div>
                            <h3 class="step-title">Create or Join Exams</h3>
                            <p>Teachers can create and schedule exams while students can join assigned exams with a unique access code.</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4 mb-4" data-aos="fade-up" data-aos-delay="300">
                    <div class="step-card">
                        <div class="step-img">
                            <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1770&q=80" alt="Access Results" class="img-fluid">
                        </div>
                        <div class="step-content">
                            <div class="step-number">3</div>
                            <h3 class="step-title">Access Results & Analytics</h3>
                            <p>Get instant results, detailed feedback, and performance analytics to track progress over time.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="particles-container" id="particles-js-stats"></div>
        <div class="container">
            <div class="row">
                <div class="col-md-3 col-6">
                    <div class="stat-card" data-aos="fade-up">
                        <div class="counter-container">
                            <div class="stat-number" data-count="50000">0</div>
                            <div class="stat-title">Students</div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-3 col-6">
                    <div class="stat-card" data-aos="fade-up" data-aos-delay="100">
                        <div class="counter-container">
                            <div class="stat-number" data-count="5000">0</div>
                            <div class="stat-title">Teachers</div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-3 col-6">
                    <div class="stat-card" data-aos="fade-up" data-aos-delay="200">
                        <div class="counter-container">
                            <div class="stat-number" data-count="100000">0</div>
                            <div class="stat-title">Exams Conducted</div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-3 col-6">
                    <div class="stat-card" data-aos="fade-up" data-aos-delay="300">
                        <div class="counter-container">
                            <div class="stat-number" data-count="500">0</div>
                            <div class="stat-title">Institutions</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Testimonials Section -->
    <section class="testimonials-section" id="testimonials">
        <div class="container">
            <div class="section-title" data-aos="fade-up">
                <h2>What Our Users Say</h2>
                <p>Discover why educators and students love our exam management system.</p>
            </div>
            
            <div class="row">
                <div class="col-md-4 mb-4" data-aos="fade-up">
                    <div class="testimonial-card">
                        <div class="testimonial-content">
                            <p>"This system has transformed how we conduct exams. The automated grading saves us hours of work, and the analytics help us improve our teaching methods."</p>
                        </div>
                        <div class="testimonial-user">
                            <div class="testimonial-avatar">
                                <img src="https://randomuser.me/api/portraits/women/44.jpg" alt="User" class="img-fluid">
                            </div>
                            <div class="testimonial-info">
                                <h5>Sarah Johnson</h5>
                                <small>Professor, Computer Science</small>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="100">
                    <div class="testimonial-card">
                        <div class="testimonial-content">
                            <p>"As a student, I appreciate getting immediate feedback on my exams. The performance tracking helps me focus on areas where I need improvement."</p>
                        </div>
                        <div class="testimonial-user">
                            <div class="testimonial-avatar">
                                <img src="https://randomuser.me/api/portraits/men/32.jpg" alt="User" class="img-fluid">
                            </div>
                            <div class="testimonial-info">
                                <h5>Michael Rodriguez</h5>
                                <small>Engineering Student</small>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-4 mb-4" data-aos="fade-up" data-aos-delay="200">
                    <div class="testimonial-card">
                        <div class="testimonial-content">
                            <p>"The administrative features have streamlined our entire examination process. Setting up departments, courses, and user roles is intuitive and efficient."</p>
                        </div>
                        <div class="testimonial-user">
                            <div class="testimonial-avatar">
                                <img src="https://randomuser.me/api/portraits/women/68.jpg" alt="User" class="img-fluid">
                            </div>
                            <div class="testimonial-info">
                                <h5>Dr. Lisa Chen</h5>
                                <small>Academic Director</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Call to Action Section -->
    <section class="cta-section">
        <div class="container">
            <div class="cta-content" data-aos="zoom-in">
                <h2 class="cta-title">Ready to Transform Your Exam Process?</h2>
                <p class="cta-subtitle">Join thousands of institutions that are already using our platform to streamline their examination workflows.</p>
                <div class="cta-buttons">
                    <a href="register.jsp" class="btn btn-light">Get Started for Free</a>
                    <a href="#contact" class="btn btn-light-outline">Contact Sales</a>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer" id="contact">
        <div class="container">
            <div class="row">
                <div class="col-lg-4 mb-4">
                    <div class="footer-logo">
                        <i class="fas fa-graduation-cap me-2"></i>ExamPro
                    </div>
                    <p class="footer-description">
                        A comprehensive exam management platform designed to streamline the creation, administration, and evaluation of academic assessments.
                    </p>
                    <div class="footer-social">
                        <a href="#" class="social-icon"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-twitter"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-icon"><i class="fab fa-linkedin-in"></i></a>
                    </div>
                </div>
                
                <div class="col-lg-2 col-md-4 mb-4">
                    <h4 class="footer-title">Quick Links</h4>
                    <ul class="footer-links">
                        <li><a href="#home">Home</a></li>
                        <li><a href="#features">Features</a></li>
                        <li><a href="#how-it-works">How It Works</a></li>
                        <li><a href="#testimonials">Testimonials</a></li>
                        <li><a href="login.jsp">Login</a></li>
                        <li><a href="register.jsp">Sign Up</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-2 col-md-4 mb-4">
                    <h4 class="footer-title">Resources</h4>
                    <ul class="footer-links">
                        <li><a href="#">Documentation</a></li>
                        <li><a href="#">API</a></li>
                        <li><a href="#">Blog</a></li>
                        <li><a href="#">Support</a></li>
                        <li><a href="#">FAQ</a></li>
                        <li><a href="#">Privacy Policy</a></li>
                    </ul>
                </div>
                
                <div class="col-lg-4 col-md-4 mb-4">
                    <h4 class="footer-title">Contact Us</h4>
                    <ul class="footer-links footer-contact">
                        <li><i class="fas fa-map-marker-alt"></i> 123 Education Street, Academic City</li>
                        <li><i class="fas fa-phone"></i> +1 (555) 123-4567</li>
                        <li><i class="fas fa-envelope"></i> info@exampro.edu</li>
                    </ul>
                    
                    <form class="mt-4">
                        <div class="input-group mb-3">
                            <input type="email" class="form-control" placeholder="Enter your email" aria-label="Email" aria-describedby="subscribe-btn">
                            <button class="btn btn-primary" type="button" id="subscribe-btn">Subscribe</button>
                        </div>
                    </form>
                </div>
            </div>
            
            <div class="copyright">
                <p>&copy; 2025 ExamPro All rights reserved</p>
            </div>
        </div>
    </footer>

    <!-- Toast container for notifications -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3"></div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Particles.js for background effects -->
    <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>
    
    <!-- AOS - Animate On Scroll Library -->
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Initialize AOS animation library
        AOS.init({
            duration: 800,
            easing: 'ease-in-out',
            once: true,
            mirror: false
        });
        
        // Initialize particles background for hero section
        document.addEventListener('DOMContentLoaded', function() {
            if (typeof particlesJS !== 'undefined') {
                particlesJS('particles-js', {
                    particles: {
                        number: {
                            value: 80,
                            density: {
                                enable: true,
                                value_area: 800
                            }
                        },
                        color: {
                            value: "#ffffff"
                        },
                        shape: {
                            type: "circle",
                            stroke: {
                                width: 0,
                                color: "#000000"
                            },
                        },
                        opacity: {
                            value: 0.5,
                            random: false,
                            anim: {
                                enable: false
                            }
                        },
                        size: {
                            value: 3,
                            random: true,
                            anim: {
                                enable: false
                            }
                        },
                        line_linked: {
                            enable: true,
                            distance: 150,
                            color: "#ffffff",
                            opacity: 0.4,
                            width: 1
                        },
                        move: {
                            enable: true,
                            speed: 3,
                            direction: "none",
                            random: false,
                            straight: false,
                            out_mode: "out",
                            bounce: false,
                        }
                    },
                    interactivity: {
                        detect_on: "canvas",
                        events: {
                            onhover: {
                                enable: true,
                                mode: "grab"
                            },
                            onclick: {
                                enable: true,
                                mode: "push"
                            },
                            resize: true
                        },
                        modes: {
                            grab: {
                                distance: 140,
                                line_linked: {
                                    opacity: 1
                                }
                            },
                            push: {
                                particles_nb: 4
                            }
                        }
                    },
                    retina_detect: true
                });
                
                // Initialize particles for stats section
                particlesJS('particles-js-stats', {
                    particles: {
                        number: {
                            value: 80,
                            density: {
                                enable: true,
                                value_area: 800
                            }
                        },
                        color: {
                            value: "#ffffff"
                        },
                        shape: {
                            type: "circle",
                            stroke: {
                                width: 0,
                                color: "#000000"
                            },
                        },
                        opacity: {
                            value: 0.5,
                            random: true,
                            anim: {
                                enable: false
                            }
                        },
                        size: {
                            value: 3,
                            random: true,
                            anim: {
                                enable: false
                            }
                        },
                        line_linked: {
                            enable: true,
                            distance: 150,
                            color: "#ffffff",
                            opacity: 0.2,
                            width: 1
                        },
                        move: {
                            enable: true,
                            speed: 2,
                            direction: "none",
                            random: true,
                            straight: false,
                            out_mode: "out",
                            bounce: false,
                        }
                    },
                    interactivity: {
                        detect_on: "canvas",
                        events: {
                            onhover: {
                                enable: true,
                                mode: "bubble"
                            },
                            onclick: {
                                enable: true,
                                mode: "repulse"
                            },
                            resize: true
                        },
                        modes: {
                            bubble: {
                                distance: 200,
                                size: 6,
                                duration: 0.4
                            },
                            repulse: {
                                distance: 100,
                                duration: 0.4
                            }
                        }
                    },
                    retina_detect: true
                });
            }
        });
        
        // Update current date and time
        function updateDateTime() {
            document.getElementById('currentDateTime').innerHTML = 
                '<i class="fas fa-calendar-alt"></i> <span>2025-05-04 00:03:23</span>';
        }
        updateDateTime();

        // Navbar scroll effect
        window.addEventListener('scroll', function() {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
        
        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                
                const targetId = this.getAttribute('href');
                if (targetId === '#') return;
                
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    targetElement.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });
        
        // Animated counter
        function animateCounters() {
            const counters = document.querySelectorAll('.stat-number');
            const speed = 200; // The higher the slower
            
            counters.forEach(counter => {
                const animate = () => {
                    const target = +counter.getAttribute('data-count');
                    const count = +counter.innerText.replace(/,/g, '');
                    
                    // Lower inc for slower animations
                    const inc = target / speed;
                    
                    if (count < target) {
                        // Format with commas
                        counter.innerText = Math.ceil(count + inc).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                        setTimeout(animate, 1);
                    } else {
                        counter.innerText = target.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                    }
                };
                
                animate();
            });
        }
        
        // Intersection Observer for counters
        document.addEventListener('DOMContentLoaded', function() {
            const statsSection = document.querySelector('.stats-section');
            
            if (statsSection) {
                const observer = new IntersectionObserver((entries) => {
                    entries.forEach(entry => {
                        if (entry.isIntersecting) {
                            animateCounters();
                            observer.unobserve(entry.target);
                        }
                    });
                });
                
                observer.observe(statsSection);
            }
        });
        
        // Toast notification for subscription
        document.getElementById('subscribe-btn').addEventListener('click', function() {
            const email = this.previousElementSibling.value;
            if (email && /\S+@\S+\.\S+/.test(email)) {
                showToast('Thank you for subscribing!', 'success');
                this.previousElementSibling.value = '';
            } else {
                showToast('Please enter a valid email address', 'error');
            }
        });
        
        // Toast notification function
       function showToast(message, type = 'info') {
            // Create toast container if it doesn't exist
            let toastContainer = document.querySelector('.toast-container');
            
            if (!toastContainer) {
                toastContainer = document.createElement('div');
                toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
                document.body.appendChild(toastContainer);
            }
            
            // Create toast element
            const toastEl = document.createElement('div');
            
            // Set class name based on type
            toastEl.className = 'toast align-items-center text-white border-0';
            if (type === 'success') {
                toastEl.classList.add('bg-success');
            } else if (type === 'error') {
                toastEl.classList.add('bg-danger');
            } else {
                toastEl.classList.add('bg-primary');
            }
            
            toastEl.setAttribute('role', 'alert');
            toastEl.setAttribute('aria-live', 'assertive');
            toastEl.setAttribute('aria-atomic', 'true');
            
            // Set icon based on type
            let iconClass = 'fa-info-circle';
            if (type === 'success') {
                iconClass = 'fa-check-circle';
            } else if (type === 'error') {
                iconClass = 'fa-exclamation-circle';
            }
            
            // Toast content without template literals
            toastEl.innerHTML = 
                '<div class="d-flex">' +
                '    <div class="toast-body">' +
                '        <i class="fas ' + iconClass + ' me-2"></i>' +
                '        ' + message +
                '    </div>' +
                '    <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>' +
                '</div>';
            
            // Add toast to container
            toastContainer.appendChild(toastEl);
            
            // Initialize Bootstrap toast
            const toast = new bootstrap.Toast(toastEl, {
                animation: true,
                autohide: true,
                delay: 3000
            });
            
            // Show toast
            toast.show();
        }
    </script>
</body>
</html>