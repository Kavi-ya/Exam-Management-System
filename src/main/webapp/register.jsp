<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Exam Management System</title>
    
    <!-- Bootstrap 5 CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Animate.css for animations -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
    
    <!-- Custom CSS -->
    <style>
        body {
            background: linear-gradient(135deg, #43cea2, #185a9d);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow-x: hidden;
            margin: 0;
            padding: 20px 0;
        }
        
        .register-container {
            background-color: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            padding: 25px;
            max-width: 550px; /* Increased for additional fields */
            width: 90%;
            position: relative;
            z-index: 10;
            backdrop-filter: blur(10px);
            transform: translateY(0);
            transition: transform 0.5s;
            margin: 0 auto;
        }
        
        .register-container:hover {
            transform: translateY(-5px);
        }
        
        .register-header {
            text-align: center;
            margin-bottom: 20px;
        }
        
        .register-header h2 {
            color: #4a4a4a;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .form-floating {
            margin-bottom: 15px;
        }
        
        .form-control:focus {
            border-color: #43cea2;
            box-shadow: 0 0 0 0.25rem rgba(67, 206, 162, 0.25);
        }
        
        .btn-register {
            background: linear-gradient(135deg, #43cea2, #185a9d);
            border: none;
            color: white;
            padding: 12px;
            border-radius: 50px;
            font-weight: 600;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 15px rgba(67, 206, 162, 0.3);
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(67, 206, 162, 0.4);
            background: linear-gradient(135deg, #39b890, #1a6cb4);
        }
        
        .login-link {
            font-size: 0.9rem;
            margin: 15px 0;
            text-align: center;
        }
        
        .social-register {
            display: flex;
            justify-content: center;
            margin-top: 20px;
            gap: 20px;
        }
        
        .social-icon {
            height: 45px;
            width: 45px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: white;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .social-icon:hover {
            transform: scale(1.1);
        }
        
        .facebook {
            background-color: #3b5998;
        }
        
        .google {
            background-color: #db4a39;
        }
        
        .twitter {
            background-color: #00acee;
        }
        
        .particles-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
            overflow: hidden;
        }
        
        .divider {
            display: flex;
            align-items: center;
            text-align: center;
            margin: 20px 0;
        }

        .divider::before, .divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px solid #dddddd;
        }

        .divider span {
            padding: 0 10px;
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .form-icon {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #43cea2;
            cursor: pointer;
        }
        
        .role-selection {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        
        .role-card {
            flex: 1;
            text-align: center;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .role-card.selected {
            border-color: #43cea2;
            background-color: rgba(67, 206, 162, 0.1);
        }
        
        .role-card i {
            font-size: 24px;
            margin-bottom: 10px;
            color: #6c757d;
            transition: all 0.3s ease;
        }
        
        .role-card.selected i {
            color: #43cea2;
        }
        
        .role-card h5 {
            margin: 0;
            font-size: 1rem;
        }
        
        .password-strength-meter {
            height: 5px;
            background-color: #eee;
            border-radius: 3px;
            margin-top: 10px;
            position: relative;
            overflow: hidden;
        }
        
        .password-strength-meter span {
            display: block;
            height: 100%;
            width: 0%;
            transition: width 0.3s ease;
        }
        
        .strength-text {
            font-size: 0.8rem;
            margin-top: 5px;
            text-align: right;
        }
        
        .role-specific-fields {
            background-color: rgba(67, 206, 162, 0.05);
            border-radius: 10px;
            padding: 15px;
            border: 1px solid rgba(67, 206, 162, 0.2);
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        
        .role-specific-fields h5 {
            color: #43cea2;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .is-invalid {
            border-color: #dc3545 !important;
        }
        
        .invalid-feedback {
            display: block;
            width: 100%;
            margin-top: 0.25rem;
            font-size: 0.875em;
            color: #dc3545;
        }
        
        .system-info {
            font-size: 12px;
            color: #6c757d;
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="particles-container" id="particles-js"></div>
    
    <div class="container">
        <div class="register-container animate__animated animate__fadeInUp">
            <div class="register-header">
                <h2><i class="fas fa-user-plus me-2"></i>Create Account</h2>
                <p class="text-muted">Join our exam management system</p>
            </div>
            
            <!-- Success Message Display -->
            <% if (request.getParameter("message") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <%= request.getParameter("message") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <!-- Error Message Display -->
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <%= request.getAttribute("errorMessage") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <div class="role-selection">
                <div class="role-card" onclick="selectRole(this, 'student')">
                    <i class="fas fa-user-graduate"></i>
                    <h5>Student</h5>
                </div>
                <div class="role-card" onclick="selectRole(this, 'teacher')">
                    <i class="fas fa-chalkboard-teacher"></i>
                    <h5>Teacher</h5>
                </div>
            </div>
            
            <form id="registerForm" method="post" action="register" class="animate__animated animate__fadeIn">
                <input type="hidden" id="role" name="role" value="">
                
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("firstName") != null ? "is-invalid" : "" %>" 
                                id="firstName" name="firstName" placeholder="First Name" 
                                value="${firstName != null ? firstName : ''}" required>
                            <label for="firstName"><i class="fas fa-user me-2"></i>First Name</label>
                            <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("firstName") != null) { %>
                                <div class="invalid-feedback">
                                    <%= ((java.util.Map)request.getAttribute("errors")).get("firstName") %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-floating mb-3">
                            <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("lastName") != null ? "is-invalid" : "" %>" 
                                id="lastName" name="lastName" placeholder="Last Name" 
                                value="${lastName != null ? lastName : ''}" required>
                            <label for="lastName"><i class="fas fa-user me-2"></i>Last Name</label>
                            <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("lastName") != null) { %>
                                <div class="invalid-feedback">
                                    <%= ((java.util.Map)request.getAttribute("errors")).get("lastName") %>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <div class="form-floating mb-3">
                    <input type="email" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("email") != null ? "is-invalid" : "" %>" 
                        id="email" name="email" placeholder="Email Address" 
                        value="${email != null ? email : ''}" required>
                    <label for="email"><i class="fas fa-envelope me-2"></i>Email Address</label>
                    <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("email") != null) { %>
                        <div class="invalid-feedback">
                            <%= ((java.util.Map)request.getAttribute("errors")).get("email") %>
                        </div>
                    <% } %>
                </div>
                
                <div class="form-floating mb-3">
    <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("username") != null ? "is-invalid" : "" %>" 
        id="username" name="username" placeholder="Username" 
        value="" required>
    <label for="username"><i class="fas fa-user-tag me-2"></i>Username</label>
    <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("username") != null) { %>
        <div class="invalid-feedback">
            <%= ((java.util.Map)request.getAttribute("errors")).get("username") %>
        </div>
    <% } %>
</div>
                
                <!-- Student-specific fields -->
                <div id="studentFields" class="role-specific-fields" style="display: none;">
                    <h5><i class="fas fa-user-graduate me-2"></i>Student Information</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("enrollmentNumber") != null ? "is-invalid" : "" %>" 
                                    id="enrollmentNumber" name="enrollmentNumber" placeholder="Enrollment Number" 
                                    value="${enrollmentNumber != null ? enrollmentNumber : ''}">
                                <label for="enrollmentNumber"><i class="fas fa-id-card me-2"></i>Enrollment Number</label>
                                <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("enrollmentNumber") != null) { %>
                                    <div class="invalid-feedback">
                                        <%= ((java.util.Map)request.getAttribute("errors")).get("enrollmentNumber") %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("semester") != null ? "is-invalid" : "" %>" 
                                    id="semester" name="semester" placeholder="Current Semester" 
                                    value="${semester != null ? semester : ''}">
                                <label for="semester"><i class="fas fa-calendar-alt me-2"></i>Current Semester</label>
                                <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("semester") != null) { %>
                                    <div class="invalid-feedback">
                                        <%= ((java.util.Map)request.getAttribute("errors")).get("semester") %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("course") != null ? "is-invalid" : "" %>" 
                            id="course" name="course" placeholder="Course/Program" 
                            value="${course != null ? course : ''}">
                        <label for="course"><i class="fas fa-graduation-cap me-2"></i>Course/Program</label>
                        <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("course") != null) { %>
                            <div class="invalid-feedback">
                                <%= ((java.util.Map)request.getAttribute("errors")).get("course") %>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- Teacher-specific fields -->
                <div id="teacherFields" class="role-specific-fields" style="display: none;">
                    <h5><i class="fas fa-chalkboard-teacher me-2"></i>Teacher Information</h5>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("department") != null ? "is-invalid" : "" %>" 
                                    id="department" name="department" placeholder="Department" 
                                    value="${department != null ? department : ''}">
                                <label for="department"><i class="fas fa-building me-2"></i>Department</label>
                                <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("department") != null) { %>
                                    <div class="invalid-feedback">
                                        <%= ((java.util.Map)request.getAttribute("errors")).get("department") %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("designation") != null ? "is-invalid" : "" %>" 
                                    id="designation" name="designation" placeholder="Designation" 
                                    value="${designation != null ? designation : ''}">
                                <label for="designation"><i class="fas fa-user-tie me-2"></i>Designation</label>
                                <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("designation") != null) { %>
                                    <div class="invalid-feedback">
                                        <%= ((java.util.Map)request.getAttribute("errors")).get("designation") %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("employeeId") != null ? "is-invalid" : "" %>" 
                                    id="employeeId" name="employeeId" placeholder="Employee ID" 
                                    value="${employeeId != null ? employeeId : ''}">
                                <label for="employeeId"><i class="fas fa-id-badge me-2"></i>Employee ID</label>
                                <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("employeeId") != null) { %>
                                    <div class="invalid-feedback">
                                        <%= ((java.util.Map)request.getAttribute("errors")).get("employeeId") %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-floating mb-3">
                                <input type="text" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("specialization") != null ? "is-invalid" : "" %>" 
                                    id="specialization" name="specialization" placeholder="Specialization" 
                                    value="${specialization != null ? specialization : ''}">
                                <label for="specialization"><i class="fas fa-star me-2"></i>Specialization</label>
                                <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("specialization") != null) { %>
                                    <div class="invalid-feedback">
                                        <%= ((java.util.Map)request.getAttribute("errors")).get("specialization") %>
                                    </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="form-floating mb-2 position-relative">
                    <input type="password" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("password") != null ? "is-invalid" : "" %>" 
                        id="password" name="password" placeholder="Password" required onkeyup="checkPasswordStrength()">
                    <label for="password"><i class="fas fa-lock me-2"></i>Password</label>
                    <span class="form-icon" onclick="togglePassword('password', 'passwordToggleIcon')">
                        <i id="passwordToggleIcon" class="fas fa-eye"></i>
                    </span>
                    <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("password") != null) { %>
                        <div class="invalid-feedback">
                            <%= ((java.util.Map)request.getAttribute("errors")).get("password") %>
                        </div>
                    <% } %>
                </div>
                
                <div class="password-strength-meter mb-3">
                    <span id="strength-meter"></span>
                </div>
                <div class="strength-text text-muted mb-3" id="strength-text">Password strength</div>
                
                <div class="form-floating mb-4 position-relative">
                    <input type="password" class="form-control <%= request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("confirmPassword") != null ? "is-invalid" : "" %>" 
                        id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
                    <label for="confirmPassword"><i class="fas fa-lock me-2"></i>Confirm Password</label>
                    <span class="form-icon" onclick="togglePassword('confirmPassword', 'confirmPasswordToggleIcon')">
                        <i id="confirmPasswordToggleIcon" class="fas fa-eye"></i>
                    </span>
                    <% if (request.getAttribute("errors") != null && ((java.util.Map)request.getAttribute("errors")).get("confirmPassword") != null) { %>
                        <div class="invalid-feedback">
                            <%= ((java.util.Map)request.getAttribute("errors")).get("confirmPassword") %>
                        </div>
                    <% } %>
                </div>
                
                <div class="mb-4 form-check">
                    <input class="form-check-input" type="checkbox" id="termsCheck" required>
                    <label class="form-check-label" for="termsCheck">
                        I agree to the <a href="#" class="text-decoration-none">Terms of Service</a> and <a href="#" class="text-decoration-none">Privacy Policy</a>
                    </label>
                </div>
                
                <button type="submit" class="btn btn-register" id="registerBtn">
                    <i class="fas fa-user-plus me-2"></i>Create Account
                </button>
            </form>
            
            <div class="divider">
                <span>OR SIGN UP WITH</span>
            </div>
            
            <div class="social-register">
                <div class="social-icon facebook">
                    <i class="fab fa-facebook-f"></i>
                </div>
                <div class="social-icon google">
                    <i class="fab fa-google"></i>
                </div>
                <div class="social-icon twitter">
                    <i class="fab fa-twitter"></i>
                </div>
            </div>
            
            <div class="login-link text-center mt-4">
                <p>Already have an account? <a href="login" class="text-decoration-none fw-bold">Login</a></p>
            </div>
			<div class="system-info">
				<p>&copy; 2025 Exam Management System. All rights reserved.</p>
				
				<!--  <div class="system-info mt-4">
					<p>System Version: 1.3.0</p>
					<p>Current Time: 2025-03-19 19:32:18</p>
					<p>System ID: IT24102083</p>
				</div>-->
			</div>
		</div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Particles.js for background effects -->
    <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>
    
    <!-- Custom JS -->
    <script>
        // Initialize particles background
        document.addEventListener('DOMContentLoaded', function() {
            particlesJS('particles-js', {
                particles: {
                    number: { value: 80, density: { enable: true, value_area: 800 } },
                    color: { value: "#ffffff" },
                    shape: { type: "circle" },
                    opacity: { value: 0.5, random: false },
                    size: { value: 3, random: true },
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
                        bounce: false
                    }
                },
                interactivity: {
                    detect_on: "canvas",
                    events: {
                        onhover: { enable: true, mode: "repulse" },
                        onclick: { enable: true, mode: "push" },
                        resize: true
                    },
                    modes: {
                        repulse: { distance: 100, duration: 0.4 },
                        push: { particles_nb: 4 }
                    }
                },
                retina_detect: true
            });
            
            // Check if a role is preselected (for when returning from failed validation)
            const preselectedRole = '<%= request.getAttribute("preselectedRole") != null ? request.getAttribute("preselectedRole") : "" %>';
            if (preselectedRole === 'student') {
                const studentCard = document.querySelector('.role-card:first-child');
                selectRole(studentCard, 'student');
            } else if (preselectedRole === 'teacher') {
                const teacherCard = document.querySelector('.role-card:nth-child(2)');
                selectRole(teacherCard, 'teacher');
            }
        });

        // Toggle password visibility
        function togglePassword(inputId, iconId) {
            const passwordInput = document.getElementById(inputId);
            const passwordIcon = document.getElementById(iconId);
            
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                passwordIcon.classList.replace('fa-eye', 'fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                passwordIcon.classList.replace('fa-eye-slash', 'fa-eye');
            }
        }

        // Form input animations
        const formInputs = document.querySelectorAll('.form-control');
        formInputs.forEach(input => {
            input.addEventListener('focus', function() {
                this.parentElement.classList.add('animate__animated', 'animate__pulse');
            });
            
            input.addEventListener('blur', function() {
                this.parentElement.classList.remove('animate__animated', 'animate__pulse');
            });
        });

        // Role selection
        function selectRole(element, role) {
            // Remove selected class from all role cards
            document.querySelectorAll('.role-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selected class to clicked card
            element.classList.add('selected');
            
            // Set the hidden input value
            document.getElementById('role').value = role;
            
            // Update form action based on role
            const form = document.getElementById('registerForm');
            if (role === 'student') {
                form.action = 'register-student';
                document.getElementById('studentFields').style.display = 'block';
                document.getElementById('teacherFields').style.display = 'none';
            } else if (role === 'teacher') {
                form.action = 'register-teacher';
                document.getElementById('studentFields').style.display = 'none';
                document.getElementById('teacherFields').style.display = 'block';
            }
            
            // Add animation to the selected role
            element.classList.add('animate__animated', 'animate__pulse');
            setTimeout(() => {
                element.classList.remove('animate__animated', 'animate__pulse');
            }, 1000);
        }
        
        // Check password strength
        function checkPasswordStrength() {
            const password = document.getElementById('password').value;
            const meter = document.getElementById('strength-meter');
            const strengthText = document.getElementById('strength-text');
            
            // Reset
            meter.style.width = '0%';
            meter.style.backgroundColor = '#eee';
            
            if (password.length === 0) {
                strengthText.textContent = 'Password strength';
                return;
            }
            
            // Check strength
            let strength = 0;
            
            // Length check
            if (password.length >= 8) strength += 1;
            if (password.length >= 12) strength += 1;
            
            // Complexity checks
            if (/[A-Z]/.test(password)) strength += 1; // Has uppercase
            if (/[a-z]/.test(password)) strength += 1; // Has lowercase
                    if (/[0-9]/.test(password)) strength += 1; // Has number
        if (/[^A-Za-z0-9]/.test(password)) strength += 1; // Has special char
        
        // Calculate percentage and set text
        let strengthPercentage = (strength / 6) * 100;
        meter.style.width = strengthPercentage + '%';
        
        // Set color and text based on strength
        if (strengthPercentage < 33) {
            meter.style.backgroundColor = '#ff4d4d'; // Red
            strengthText.textContent = 'Weak password';
            strengthText.style.color = '#ff4d4d';
        } else if (strengthPercentage < 66) {
            meter.style.backgroundColor = '#ffd633'; // Yellow
            strengthText.textContent = 'Moderate password';
            strengthText.style.color = '#ffd633';
        } else {
            meter.style.backgroundColor = '#47d147'; // Green
            strengthText.textContent = 'Strong password';
            strengthText.style.color = '#47d147';
        }
    }
    
    // Button animation
    const registerBtn = document.getElementById('registerBtn');
    registerBtn.addEventListener('mousedown', function() {
        this.style.transform = 'scale(0.95)';
    });
    
    registerBtn.addEventListener('mouseup', function() {
        this.style.transform = 'scale(1)';
    });
    
 // Form submission with validation
    document.getElementById('registerForm').addEventListener('submit', function(event) {
        event.preventDefault();
        
        // Create an array to store validation errors
        const errors = [];
        
        // Get form values
        const role = document.getElementById('role').value;
        const firstName = document.getElementById('firstName').value.trim();
        const lastName = document.getElementById('lastName').value.trim();
        const email = document.getElementById('email').value.trim();
        const username = document.getElementById('username').value.trim();
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirmPassword').value;
        const termsCheck = document.getElementById('termsCheck').checked;
        
        // Validate role selection
        if (!role) {
            errors.push("Please select a role (Student or Teacher).");
        }
        
        // Validate common fields
        if (!firstName) {
            errors.push("First name is required.");
        }
        
        if (!lastName) {
            errors.push("Last name is required.");
        }
        
        if (!email) {
            errors.push("Email address is required.");
        } else if (!/^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email)) {
            errors.push("Please enter a valid email address.");
        }
        
        if (!username) {
            errors.push("Username is required.");
        } else if (username.length < 5) {
            errors.push("Username must be at least 5 characters long.");
        }
        
        if (!password) {
            errors.push("Password is required.");
        } else if (password.length < 8) {
            errors.push("Password must be at least 8 characters long.");
        }
        
        if (password !== confirmPassword) {
            errors.push("Passwords do not match.");
        }
        
        if (!termsCheck) {
            errors.push("You must agree to the Terms of Service and Privacy Policy.");
        }
        
        // Validate role-specific fields
        if (role === 'student') {
            const enrollmentNumber = document.getElementById('enrollmentNumber').value.trim();
            const course = document.getElementById('course').value.trim();
            const semester = document.getElementById('semester').value.trim();
            
            if (!enrollmentNumber) {
                errors.push("Enrollment number is required for students.");
            }
            
            if (!course) {
                errors.push("Course/Program is required for students.");
            }
            
            if (!semester) {
                errors.push("Semester is required for students.");
            } else if (!/^\d+$/.test(semester) || parseInt(semester) < 1 || parseInt(semester) > 8) {
                errors.push("Semester must be a number between 1 and 8.");
            }
        } else if (role === 'teacher') {
            const department = document.getElementById('department').value.trim();
            const designation = document.getElementById('designation').value.trim();
            const employeeId = document.getElementById('employeeId').value.trim();
            
            if (!department) {
                errors.push("Department is required for teachers.");
            }
            
            if (!designation) {
                errors.push("Designation is required for teachers.");
            }
            
            if (!employeeId) {
                errors.push("Employee ID is required for teachers.");
            }
        }
        
        // If there are validation errors, show them
        if (errors.length > 0) {
            // Completely different approach to show errors
            // Remove any existing error message first
            const existingError = document.querySelector('.alert-danger');
            if (existingError) {
                existingError.remove();
            }
            
            // Create a container for the error message
            const errorContainer = document.createElement('div');
            errorContainer.className = 'alert alert-danger alert-dismissible fade show';
            
            // Add heading
            const errorHeading = document.createElement('strong');
            errorHeading.textContent = 'Please fix the following errors:';
            errorContainer.appendChild(errorHeading);
            
            // Create error list
            const errorList = document.createElement('ul');
            errorList.className = 'mb-0 mt-2';
            
            // Add each error as a list item
            errors.forEach(function(error) {
                const errorItem = document.createElement('li');
                errorItem.textContent = error;
                errorList.appendChild(errorItem);
            });
            
            // Add the list to container
            errorContainer.appendChild(errorList);
            
            // Add dismiss button
            const dismissButton = document.createElement('button');
            dismissButton.type = 'button';
            dismissButton.className = 'btn-close';
            dismissButton.setAttribute('data-bs-dismiss', 'alert');
            dismissButton.setAttribute('aria-label', 'Close');
            errorContainer.appendChild(dismissButton);
            
            // Add the error container to the form
            const form = document.getElementById('registerForm');
            form.insertBefore(errorContainer, form.firstChild);
            
            // Scroll to the top of the form
            errorContainer.scrollIntoView({ behavior: 'smooth', block: 'start' });
            
            return;
        }
        
        // If validation passes, proceed with submission
        const submitButton = document.getElementById('registerBtn');
        submitButton.innerHTML = '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Creating account...';
        submitButton.disabled = true;
        
        // Submit the form after a short delay to show the animation
        setTimeout(() => {
            this.submit();
            
            // Show confetti effect if library is loaded
            if (typeof confetti === 'function') {
                confetti({
                    particleCount: 100,
                    spread: 70,
                    origin: { y: 0.6 }
                });
            }
        }, 1000);
    });
    
    // Social icons hover effect
    const socialIcons = document.querySelectorAll('.social-icon');
    socialIcons.forEach(icon => {
        icon.addEventListener('mouseover', function() {
            this.classList.add('animate__animated', 'animate__heartBeat');
        });
        
        icon.addEventListener('mouseout', function() {
            this.classList.remove('animate__animated', 'animate__heartBeat');
        });
    });

    // Load confetti effect library
    document.addEventListener('DOMContentLoaded', function() {
        // Add script dynamically
        const script = document.createElement('script');
        script.src = 'https://cdn.jsdelivr.net/npm/canvas-confetti@1.5.1/dist/confetti.browser.min.js';
        document.head.appendChild(script);
    });

    // Scroll effects (for page with potential scrolling)
    window.addEventListener('scroll', function() {
        const scrollPosition = window.scrollY;
        const registerContainer = document.querySelector('.register-container');
        if (scrollPosition > 50) {
            registerContainer.style.boxShadow = '0 25px 50px rgba(0, 0, 0, 0.3)';
        } else {
            registerContainer.style.boxShadow = '0 15px 30px rgba(0, 0, 0, 0.2)';
        }
    });
    
    // Update system time display
    document.addEventListener('DOMContentLoaded', function() {
        const systemInfoElement = document.querySelector('.system-info p:nth-child(2)');
        if (systemInfoElement) {
            systemInfoElement.textContent = 'Current Time: 2025-03-19 19:34:21';
        }
        
        // Pre-select role if coming back from validation errors
        const preselectedRole = '<%= request.getAttribute("preselectedRole") %>';
        if (preselectedRole === 'student') {
            selectRole(document.querySelector('.role-card:first-child'), 'student');
        } else if (preselectedRole === 'teacher') {
            selectRole(document.querySelector('.role-card:last-child'), 'teacher');
        }
    });
</script>

</body>
</html>