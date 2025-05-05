<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Login - Exam Management System</title>

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
        background: linear-gradient(135deg, #1a2980, #26d0ce);
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
        padding: 30px;  
        max-width: 450px;
        width: 90%;
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
        margin-bottom: 15px;  /* Reduced margin */
      }

      .login-header h2 {
        color: #1a2980;
        font-weight: 700;
        margin-bottom: 5px;  /* Reduced margin */
        font-size: 1.6rem;  /* Smaller header */
      }

      .login-header p {
        font-size: 0.85rem;  /* Smaller text */
        margin-bottom: 10px;  /* Reduced margin */
      }

      .form-floating {
        margin-bottom: 12px;  /* Reduced margin */
      }

      .form-floating > .form-control {
        padding-top: 0.95rem;  /* Smaller input padding */
        padding-bottom: 0.35rem;
        height: calc(2.8rem + 2px);  /* Smaller input height */
      }

      .form-floating > label {
        padding: 0.5rem 0.75rem;  /* Smaller label padding */
      }

      .form-control:focus {
        border-color: #1a2980;
        box-shadow: 0 0 0 0.25rem rgba(26, 41, 128, 0.25);
      }

      .btn-login {
        background: linear-gradient(135deg, #1a2980, #26d0ce);
        border: none;
        color: white;
        padding: 8px;  /* Reduced padding */
        border-radius: 50px;
        font-weight: 600;
        letter-spacing: 0.5px;
        box-shadow: 0 4px 15px rgba(26, 41, 128, 0.3);
        transition: all 0.3s ease;
        width: 100%;
        margin-top: 5px;  /* Reduced top margin */
      }

      .btn-login:hover {
        transform: translateY(-3px);
        box-shadow: 0 8px 20px rgba(26, 41, 128, 0.4);
        background: linear-gradient(135deg, #233296, #2ae7e2);
      }

      .forgot-password,
      .register-link {
        font-size: 0.85rem;  /* Smaller text */
        margin: 10px 0;  /* Reduced margin */
        text-align: center;
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
        margin: 10px 0;  /* Reduced margin */
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
        font-size: 0.85rem;  /* Smaller text */
      }

      .form-icon {
        position: absolute;
        right: 15px;
        top: 50%;
        transform: translateY(-50%);
        color: #1a2980;
        cursor: pointer;
      }

      .input-group-text {
        background-color: transparent;
        border-left: none;
      }

      @media (max-width: 480px) {
        .login-container {
          padding: 18px;  /* Smaller padding on tiny screens */
        }
        
        .login-header h2 {
          font-size: 1.3rem;  /* Even smaller heading on small screens */
        }
      }

      @media (max-width: 576px) {
        .form-control, .btn-login {
          min-height: 38px;  /* Smaller minimum height */
        }
      }

      @media (max-width: 400px) {
        .d-flex.justify-content-between {
          flex-direction: column;
          align-items: flex-start;
          gap: 8px;  /* Reduced gap */
        }
      }

      /* Alert Styles */
      .alert {
        border-radius: 8px;  /* Smaller radius */
        padding: 6px 10px;  /* Reduced padding */
        font-size: 0.8rem;  /* Smaller text */
        border-left: 3px solid;  /* Thinner border */
        margin-bottom: 12px;  /* Reduced margin */
      }

      .alert-danger {
        background-color: rgba(248, 215, 218, 0.9);
        border-color: #dc3545;
        color: #721c24;
      }

      .alert-warning {
        background-color: rgba(255, 243, 205, 0.9);
        border-color: #ffc107;
        color: #856404;
      }

      .alert i {
        font-size: 0.8rem;  /* Smaller icon */
      }

      .admin-badge {
        display: inline-block;
        background: linear-gradient(135deg, #1a2980, #26d0ce);
        color: white;
        font-size: 0.7rem;  /* Smaller text */
        padding: 3px 10px;  /* Smaller padding */
        border-radius: 50px;
        font-weight: bold;
        letter-spacing: 1px;
        margin-bottom: 8px;  /* Reduced margin */
      }

      .security-notice {
        font-size: 0.7rem;  /* Smaller text */
        color: #6c757d;
        text-align: center;
        margin-top: 10px;  /* Reduced margin */
        border-top: 1px solid #eee;
        padding-top: 8px;  /* Reduced padding */
      }

      /* Compact spacing for form elements */
      .form-check {
        margin-bottom: 0;  /* Remove bottom margin */
        min-height: auto;  /* Override Bootstrap's min-height */
      }

      .form-check-input {
        margin-top: 0.15rem;  /* Adjust checkbox position */
      }

      .d-flex.justify-content-between {
        margin-bottom: 10px !important;  /* Reduced margin */
      }

      .register-link p {
        margin-bottom: 5px;  /* Reduced margin */
      }
      
      /* Enhanced floating-back button */
      .floating-back {
        position: absolute;
        top: 20px;
        left: 20px;
        background-color: rgba(255, 255, 255, 0.8);
        border-radius: 50%;
        width: 40px;  /* Smaller size */
        height: 40px;  /* Smaller size */
        display: flex;
        justify-content: center;
        align-items: center;
        color: #1a2980;
        text-decoration: none;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
        z-index: 100;
        cursor: pointer;
      }
        
      .floating-back:hover {
        transform: translateY(-3px) scale(1.05);
        background-color: white;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        color: #26d0ce;
      }
      
      .floating-back:active {
        transform: translateY(0) scale(0.95);
      }
    </style>
  </head>
  <body>
    <!-- Enhanced back button with aria-label for accessibility -->
    <a href="index.jsp" class="floating-back" aria-label="Go back to home page" id="backButton">
      <i class="fas fa-arrow-left"></i>
    </a>
    
    <div class="particles-container" id="particles-js"></div>

    <div class="container">
      <div class="login-container animate__animated animate__fadeInUp">
        <div class="login-header">
          <span class="admin-badge"><i class="fas fa-shield-alt me-1"></i> ADMIN ACCESS</span>
          <h2><i class="fas fa-user-shield me-2"></i>Admin Portal</h2>
          <p class="text-muted">Enter administrator credentials to continue</p>
        </div>

        <!-- Alert for restricted access - made more compact -->
        <div class="alert alert-warning animate__animated animate__fadeIn">
          <i class="fas fa-exclamation-triangle me-2"></i>
          <span>Restricted area. Authorized personal only.</span>
        </div>

        <!-- Error message container (initially hidden) - made more compact -->
        <div class="alert alert-danger animate__animated animate__fadeIn" id="login-error" style="display: none;">
          <i class="fas fa-exclamation-circle me-2"></i>
          <span id="error-message">Invalid credentials</span>
        </div>

        <form id="adminLoginForm" action="adminLogin" method="post">
          <div class="form-floating position-relative">
            <input
              type="text"
              class="form-control"
              id="username"
              name="username"
              placeholder="Admin Username"
              required
            />
            <label for="username"
              ><i class="fas fa-user-tie me-2"></i>Admin Username</label
            >
          </div>

          <div class="form-floating mb-3 position-relative">
            <input
              type="password"
              class="form-control"
              id="password"
              name="password"
              placeholder="Password"
              required
            />
            <label for="password"
              ><i class="fas fa-key me-2"></i>Password</label
            >
            <span class="form-icon" onclick="togglePassword()">
              <i id="passwordToggleIcon" class="fas fa-eye"></i>
            </span>
          </div>

          <div class="d-flex justify-content-between mb-3">
            <div class="form-check">
              <input class="form-check-input" type="checkbox" id="rememberMe" />
              <label class="form-check-label" for="rememberMe"
                >Remember Me</label
              >
            </div>
            <a href="#" class="text-decoration-none" style="font-size: 0.8rem;">Forgot Password?</a>
          </div>

          <button type="submit" class="btn btn-login" id="loginBtn">
            <i class="fas fa-sign-in-alt me-2"></i>Admin Login
          </button>
        </form>

        <div class="register-link text-center mt-3">
          <p>
            Need regular user access?
            <a href="./login.jsp" class="text-decoration-none fw-bold"
              >User Login</a
            >
          </p>
        </div>

        <div class="security-notice">
          <i class="fas fa-info-circle me-1"></i>
          Login attempts are monitored and logged for security purposes.
          This portal is for authorized administrators only.
        </div>
      </div>
    </div>

    <!-- Bootstrap JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Particles.js for background effects -->
    <script src="https://cdn.jsdelivr.net/npm/particles.js@2.0.0/particles.min.js"></script>

    <!-- Custom JS -->
    <script>
      // Initialize particles background with blue theme
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

      // Form submission with animation - Fixed to use adminLoginForm ID
      document
        .getElementById("adminLoginForm")
        .addEventListener("submit", function (event) {
          event.preventDefault();
          const submitButton = document.getElementById("loginBtn");
          submitButton.innerHTML =
            '<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>Verifying...';
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
              submitButton.innerHTML = '<i class="fas fa-sign-in-alt me-2"></i>Admin Login';
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