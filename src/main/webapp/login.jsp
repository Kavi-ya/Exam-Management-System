<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Login - Exam Management System</title>

    <!-- Bootstrap 5 CDN -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />

    <!-- Font Awesome Icons -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />

    <!-- Animate.css for animations -->
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
    />

    <!-- Custom CSS -->
    <style>
      body {
        background: linear-gradient(135deg, #667eea, #764ba2);
        min-height: 100vh;
        display: flex;
        align-items: center;
        justify-content: center;
        overflow-x: hidden;
        margin: 0;
        padding: 0;
      }

      .container {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        width: 100%;
      }

      .login-container {
        background-color: rgba(255, 255, 255, 0.95);
        border-radius: 15px;
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
        padding: 30px;  /* Reduced padding from 40px to 30px */
        max-width: 450px;  /* Reduced max-width from 500px to 400px */
        width: 90%;  /* Reduced width from 90% to 85% */
        position: relative;
        z-index: 10;
        backdrop-filter: blur(10px);
        transform: translateY(0);
        transition: transform 0.5s;
      }

      .login-container:hover {
        transform: translateY(-5px);
      }

      .login-header {
        text-align: center;
        margin-bottom: 25px;  /* Reduced from 30px to 25px */
      }

      .login-header h2 {
        color: #4a4a4a;
        font-weight: 700;
        margin-bottom: 10px;
        font-size: 1.8rem;  /* Slightly smaller header */
      }

      .form-floating {
        margin-bottom: 18px;  /* Reduced from 20px to 18px */
      }

      .form-control:focus {
        border-color: #764ba2;
        box-shadow: 0 0 0 0.25rem rgba(118, 75, 162, 0.25);
      }

      .btn-login {
        background: linear-gradient(135deg, #667eea, #764ba2);
        border: none;
        color: white;
        padding: 10px;  /* Reduced from 12px to 10px */
        border-radius: 50px;
        font-weight: 600;
        letter-spacing: 0.5px;
        box-shadow: 0 4px 15px rgba(118, 75, 162, 0.3);
        transition: all 0.3s ease;
        width: 100%;
      }

      .btn-login:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(118, 75, 162, 0.4);
        background: linear-gradient(135deg, #7687e0, #8b5db9);
      }

      .forgot-password,
      .register-link {
        font-size: 0.9rem;
        margin: 15px 0;
        text-align: center;
      }

      .social-login {
        display: flex;
        justify-content: center;
        margin-top: 20px;
        gap: 15px;  /* Reduced from 20px to 15px */
      }

      .social-icon {
        height: 40px;  /* Reduced from 45px to 40px */
        width: 40px;  /* Reduced from 45px to 40px */
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.1rem;  /* Reduced from 1.2rem to 1.1rem */
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
        margin: 15px 0;  /* Reduced from 20px to 15px */
      }

      .divider::before,
      .divider::after {
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
        color: #764ba2;
        cursor: pointer;
      }

      .input-group-text {
        background-color: transparent;
        border-left: none;
      }

      @media (max-width: 480px) {
        .login-container {
          padding: 20px;  /* Smaller padding on tiny screens */
        }
        
        .login-header h2 {
          font-size: 1.4rem;  /* Even smaller heading on small screens */
        }
        
        .social-login {
          gap: 10px;  /* Tighter spacing between social icons */
        }
      }

      @media (max-width: 576px) {
        .form-control, .btn-login, .social-icon {
          min-height: 40px;  /* Reduced from 44px to 40px */
        }
      }

      @media (max-width: 400px) {
        .d-flex.justify-content-between {
          flex-direction: column;
          align-items: flex-start;
          gap: 10px;
        }
      }

      /* Alert Styles */
      .alert {
        border-radius: 10px;
        padding: 10px 12px;  /* Reduced from 12px 15px to 10px 12px */
        font-size: 0.85rem;  /* Reduced from 0.9rem to 0.85rem */
        border-left: 4px solid;
      }

      .alert-danger {
        background-color: rgba(248, 215, 218, 0.9);
        border-color: #dc3545;
        color: #721c24;
      }

      .alert i {
        font-size: 0.9rem;  /* Reduced from 1rem to 0.9rem */
      }
      
      /* Enhanced floating-back button */
      .floating-back {
        position: absolute;
        top: 20px;
        left: 20px;
        background-color: rgba(255, 255, 255, 0.8);
        border-radius: 50%;
        width: 45px;
        height: 45px;
        display: flex;
        justify-content: center;
        align-items: center;
        color: #4a4a4a; /* Specific color instead of var(--dark-color) */
        text-decoration: none;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
        z-index: 100; /* Ensure it's above other elements */
        cursor: pointer; /* Add pointer cursor to indicate it's clickable */
      }
        
      .floating-back:hover {
        transform: translateY(-3px) scale(1.05);
        background-color: white;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        color: #764ba2; /* Change color on hover */
      }
      
      .floating-back:active {
        transform: translateY(0) scale(0.95);
      }
        
    </style>
  </head>
  <body>
  <%
    // Check if this is a logout action
    String action = request.getParameter("action");
    if ("logout".equals(action)) {
        // Invalidate the session
        session.invalidate();
        // Create a new session for the message
        session = request.getSession(true);
        session.setAttribute("message", "You have been successfully logged out.");
        session.setAttribute("messageType", "success");
    }
%>

  <!-- Enhanced back button with aria-label for accessibility -->
  <a href="index.jsp" class="floating-back" aria-label="Go back to home page" id="backButton">
    <i class="fas fa-arrow-left"></i>
  </a>
  
    <div class="particles-container" id="particles-js"></div>
    <div class="container">
      <div class="login-container animate__animated animate__fadeInUp">
        <div class="login-header">
          <h2><i class="fas fa-graduation-cap me-2"></i>Exam Management</h2>
          <p class="text-muted">Welcome back! Please login to your account</p>
        </div>

        <!-- Error message container (initially hidden) -->
        <div class="alert alert-danger mb-4 animate__animated animate__fadeIn" id="login-error" style="display: none;">
          <i class="fas fa-exclamation-circle me-2"></i>
          <span id="error-message">Invalid username or password</span>
        </div>

        <form action="login" method="post" id="loginForm">
          <div class="form-floating mb-4 position-relative">
            <input
              type="text"
              class="form-control"
              id="username"
              name="username"
              placeholder="Username"
              required
            />
            <label for="username"
              ><i class="fas fa-user me-2"></i>Username</label
            >
          </div>

          <div class="form-floating mb-4 position-relative">
            <input
              type="password"
              class="form-control"
              id="password"
              name="password"
              placeholder="Password"
              required
            />
            <label for="password"
              ><i class="fas fa-lock me-2"></i>Password</label
            >
            <span class="form-icon" onclick="togglePassword()">
              <i id="passwordToggleIcon" class="fas fa-eye"></i>
            </span>
          </div>

          <div class="d-flex justify-content-between mb-4">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="rememberMe" />
              <label class="form-check-label" for="rememberMe"
                >Remember Me</label
              >
            </div>
            <a href="#" class="text-decoration-none">Forgot Password?</a>
          </div>

          <button type="submit" class="btn btn-login" id="loginBtn">
            <i class="fas fa-sign-in-alt me-2"></i>Login
          </button>
        </form>

        <div class="divider">
          <span>OR</span>
        </div>

        <div class="social-login">
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

        <div class="register-link text-center mt-4">
          <p>
            Don't have an account?
            <a href="./register.jsp" class="text-decoration-none fw-bold"
              >Register</a
            >
          </p>
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Particles.js for background effects -->
    <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>

    <!-- Custom JS -->
    <script>
      // Initialize particles background
      document.addEventListener("DOMContentLoaded", function () {
        particlesJS("particles-js", {
          particles: {
            number: {
              value: 80,
              density: {
                enable: true,
                value_area: 800,
              },
            },
            color: {
              value: "#ffffff",
            },
            shape: {
              type: "circle",
              stroke: {
                width: 0,
                color: "#000000",
              },
              polygon: {
                nb_sides: 5,
              },
            },
            opacity: {
              value: 0.5,
              random: false,
              anim: {
                enable: false,
              },
            },
            size: {
              value: 3,
              random: true,
              anim: {
                enable: false,
              },
            },
            line_linked: {
              enable: true,
              distance: 150,
              color: "#ffffff",
              opacity: 0.4,
              width: 1,
            },
            move: {
              enable: true,
              speed: 3,
              direction: "none",
              random: false,
              straight: false,
              out_mode: "out",
              bounce: false,
            },
          },
          interactivity: {
            detect_on: "canvas",
            events: {
              onhover: {
                enable: true,
                mode: "grab",
              },
              onclick: {
                enable: true,
                mode: "push",
              },
              resize: true,
            },
            modes: {
              grab: {
                distance: 140,
                line_linked: {
                  opacity: 1,
                },
              },
              push: {
                particles_nb: 4,
              },
            },
          },
          retina_detect: true,
        });
        
        // Enhanced back button functionality
        const backButton = document.getElementById('backButton');
        backButton.addEventListener('mouseover', function() {
          this.classList.add('animate__animated', 'animate__pulse');
        });
        
        backButton.addEventListener('mouseout', function() {
          this.classList.remove('animate__animated', 'animate__pulse');
        });
        
        backButton.addEventListener('click', function(e) {
          // Add a ripple effect when clicked
          e.currentTarget.style.overflow = 'hidden';
          const ripple = document.createElement('span');
          ripple.style.position = 'absolute';
          ripple.style.backgroundColor = 'rgba(255,255,255,0.7)';
          ripple.style.borderRadius = '50%';
          ripple.style.width = '100%';
          ripple.style.height = '100%';
          ripple.style.transform = 'scale(0)';
          ripple.style.opacity = '1';
          ripple.style.animation = 'ripple 0.6s linear';
          ripple.style.pointerEvents = 'none';
          
          e.currentTarget.appendChild(ripple);
          
          setTimeout(() => {
            ripple.remove();
          }, 600);
        });
      });

      // Add ripple animation
      document.head.insertAdjacentHTML('beforeend', `
        <style>
          @keyframes ripple {
            to {
              transform: scale(2.5);
              opacity: 0;
            }
          }
        </style>
      `);

      // Toggle password visibility
      function togglePassword() {
        const passwordInput = document.getElementById("password");
        const passwordIcon = document.getElementById("passwordToggleIcon");

        if (passwordInput.type === "password") {
          passwordInput.type = "text";
          passwordIcon.classList.replace("fa-eye", "fa-eye-slash");
        } else {
          passwordInput.type = "password";
          passwordIcon.classList.replace("fa-eye-slash", "fa-eye");
        }
      }

      // Form input animations
      const formInputs = document.querySelectorAll(".form-control");
      formInputs.forEach((input) => {
        input.addEventListener("focus", function () {
          this.parentElement.classList.add(
            "animate__animated",
            "animate__pulse"
          );
        });

        input.addEventListener("blur", function () {
          this.parentElement.classList.remove(
            "animate__animated",
            "animate__pulse"
          );
        });
      });

      // Button animation
      const loginBtn = document.getElementById("loginBtn");
      loginBtn.addEventListener("mousedown", function () {
        this.style.transform = "scale(0.95)";
      });

      loginBtn.addEventListener("mouseup", function () {
        this.style.transform = "scale(1)";
      });

      // Form submission with animation
      document
        .getElementById("loginForm")
        .addEventListener("submit", function (event) {
          event.preventDefault();
          const submitButton = document.getElementById("loginBtn");
          submitButton.innerHTML =
            '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Logging in...';
          submitButton.disabled = true;

          // Get form data
          const username = document.getElementById("username").value;
          const password = document.getElementById("password").value;

          // Simulate form validation (replace with your actual validation logic)
          setTimeout(() => {
            // This is where you would normally check credentials with your backend
            // For demo purposes, let's just check if username and password are not empty
            if (username.trim() === "" || password.trim() === "") {
              // Show error message
              showLoginError("Please enter both username and password");
              // Reset button state
              submitButton.innerHTML = '<i class="fas fa-sign-in-alt me-2"></i>Login';
              submitButton.disabled = false;
            } else {
              // Success - submit the form
              this.submit();
            }
          }, 1500);
        });

      // Function to show login error
      function showLoginError(message) {
        const errorElement = document.getElementById("login-error");
        const errorMessageElement = document.getElementById("error-message");
        
        errorMessageElement.textContent = message;
        errorElement.style.display = "block";
        
        // Automatically hide the error after 5 seconds
        setTimeout(() => {
          errorElement.classList.add("animate__fadeOut");
          setTimeout(() => {
            errorElement.style.display = "none";
            errorElement.classList.remove("animate__fadeOut");
          }, 1000);
        }, 5000);
      }

      // Social icons hover effect
      const socialIcons = document.querySelectorAll(".social-icon");
      socialIcons.forEach((icon) => {
        icon.addEventListener("mouseover", function () {
          this.classList.add("animate__animated", "animate__heartBeat");
        });

        icon.addEventListener("mouseout", function () {
          this.classList.remove("animate__animated", "animate__heartBeat");
        });
      });

      // Scroll effects (for page with potential scrolling)
      window.addEventListener("scroll", function () {
        const scrollPosition = window.scrollY;
        const loginContainer = document.querySelector(".login-container");
        if (scrollPosition > 50) {
          loginContainer.style.boxShadow = "0 25px 50px rgba(0, 0, 0, 0.3)";
        } else {
          loginContainer.style.boxShadow = "0 15px 30px rgba(0, 0, 0, 0.2)";
        }
      });
    </script>
  </body>
</html>