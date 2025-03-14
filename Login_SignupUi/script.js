document.addEventListener('DOMContentLoaded', function() {
    // Elements
    const bookCover = document.querySelector('.book-cover');
    const bookPages = document.querySelector('.book-pages');
    const openBookBtn = document.getElementById('open-book');
    const flipToSignupBtn = document.getElementById('flip-to-signup');
    const flipToLoginBtn = document.getElementById('flip-to-login');
    const backToCoverBtn = document.getElementById('back-to-cover');
    const backToLoginBtn = document.getElementById('back-to-login');
    const loginForm = document.getElementById('login-form');
    const signupForm = document.getElementById('signup-form');
    const loginResponse = document.getElementById('login-response');
    const signupResponse = document.getElementById('signup-response');
    const confirmPassword = document.getElementById('confirmPassword');
    const signupPassword = document.getElementById('signupPassword');

    // Initialize the page effect div
    const pageEffect = document.createElement('div');
    pageEffect.className = 'page-turning-effect';
    document.body.appendChild(pageEffect);

    // Creates particles in background
    createParticles();

    // Open book animation
    openBookBtn.addEventListener('click', function(event) {
        bookCover.classList.add('open');
        createRippleEffect(event);
    });

    // Back to cover (from login page)
    backToCoverBtn.addEventListener('click', function(event) {
        createRippleEffect(event, true);
        setTimeout(() => {
            bookCover.classList.remove('open');
        }, 100);
    });

    // Flip to signup page
    flipToSignupBtn.addEventListener('click', function(event) {
        createPageTurningEffect(event);
        setTimeout(() => {
            bookPages.classList.add('flipped');
        }, 100);
    });

    // Back to login page (from signup page)
    backToLoginBtn.addEventListener('click', function(event) {
        createPageTurningEffect(event, true);
        setTimeout(() => {
            bookPages.classList.remove('flipped');
        }, 100);
    });

    // Directly go to signup page from cover (for convenience)
    // This simulates clicking "Get Started" and then "Create Account"
    function goDirectlyToSignup() {
        bookCover.classList.add('open');
        setTimeout(() => {
            bookPages.classList.add('flipped');
        }, 1200); // Wait for cover animation
    }

    // Uncomment this to automatically go to signup when the page loads
    // setTimeout(goDirectlyToSignup, 1000);
    
    // You can also expose this function globally to call it from a button or link
    window.goToSignup = goDirectlyToSignup;

    // Create ripple effect function
    function createRippleEffect(event, reverse = false) {
        const ripple = document.createElement('div');
        ripple.className = 'ripple';
        
        const x = event.clientX;
        const y = event.clientY;
        
        const style = `
            position: fixed;
            top: ${y}px;
            left: ${x}px;
            width: 0;
            height: 0;
            background: rgba(255, 255, 255, 0.7);
            border-radius: 50%;
            transform: translate(-50%, -50%);
            pointer-events: none;
            animation: ${reverse ? 'rippleReverse' : 'ripple'} 1s ease-out forwards;
            z-index: 1000;
        `;
        
        ripple.style = style;
        
        // Add keyframe animation dynamically if not already there
        if (!document.querySelector('style#ripple-style')) {
            const styleEl = document.createElement('style');
            styleEl.id = 'ripple-style';
            styleEl.innerHTML = `
                @keyframes ripple {
                    0% { width: 0; height: 0; opacity: 0.5; }
                    100% { width: 500px; height: 500px; opacity: 0; }
                }
                @keyframes rippleReverse {
                    0% { width: 500px; height: 500px; opacity: 0; }
                    50% { opacity: 0.5; }
                    100% { width: 0; height: 0; opacity: 0; }
                }
            `;
            document.head.appendChild(styleEl);
        }
        
        document.body.appendChild(ripple);
        setTimeout(() => ripple.remove(), 1000);
    }

    // Page turning effect function
    function createPageTurningEffect(event, reverse = false) {
        const x = event.clientX;
        const y = event.clientY;
        
        pageEffect.style.top = `${y}px`;
        pageEffect.style.right = reverse ? 'auto' : '0';
        pageEffect.style.left = reverse ? '0' : 'auto';
        
        pageEffect.classList.add('active');
        
        setTimeout(() => {
            pageEffect.classList.remove('active');
        }, 800);
    }

    // Create background particles
    function createParticles() {
        const particlesContainer = document.querySelector('.particles-background');
        if (!particlesContainer) return;

        // Create 50 particles with random positions, sizes and delays
        for (let i = 0; i < 50; i++) {
            const particle = document.createElement('div');
            particle.className = 'particle';
            
            const size = Math.random() * 3 + 1; // 1-4px
            const posX = Math.random() * 100; // 0-100%
            const posY = Math.random() * 100; // 0-100%
            const delay = Math.random() * 20; // 0-20s
            const duration = 15 + Math.random() * 10; // 15-25s
            const opacity = Math.random() * 0.6 + 0.2; // 0.2-0.8
            
            particle.style.cssText = `
                position: absolute;
                width: ${size}px;
                height: ${size}px;
                background-color: white;
                border-radius: 50%;
                left: ${posX}%;
                top: ${posY}%;
                opacity: ${opacity};
                animation: floatParticle ${duration}s linear infinite;
                animation-delay: ${delay}s;
            `;
            
            particlesContainer.appendChild(particle);
        }
        
        // Add animation keyframe if not already added
        if (!document.querySelector('style#particle-style')) {
            const styleEl = document.createElement('style');
            styleEl.id = 'particle-style';
            styleEl.innerHTML = `
                @keyframes floatParticle {
                    0% { transform: translateY(0) translateX(0); }
                    25% { transform: translateY(-20px) translateX(10px); }
                    50% { transform: translateY(-40px) translateX(-10px); }
                    75% { transform: translateY(-60px) translateX(10px); }
                    100% { transform: translateY(-100px) translateX(0); opacity: 0; }
                }
            `;
            document.head.appendChild(styleEl);
        }
    }

    // Form validation for both forms
    [loginForm, signupForm].forEach(form => {
        form.addEventListener('submit', function(event) {
            if (!form.checkValidity()) {
                event.preventDefault();
                event.stopPropagation();
            } else {
                event.preventDefault(); // Always prevent default to handle with AJAX
                
                // If signup form, check if passwords match
                if (form.id === 'signup-form') {
                    if (signupPassword.value !== confirmPassword.value) {
                        confirmPassword.setCustomValidity("Passwords don't match");
                        form.classList.add('was-validated');
                        return;
                    } else {
                        confirmPassword.setCustomValidity('');
                    }
                }
                
                // Handle form submission with AJAX
                handleFormSubmit(form);
            }
            
            form.classList.add('was-validated');
        }, false);
    });

    // Password confirmation validation
    confirmPassword.addEventListener('input', function() {
        if (signupPassword.value !== confirmPassword.value) {
            confirmPassword.setCustomValidity("Passwords don't match");
        } else {
            confirmPassword.setCustomValidity('');
        }
    });

    // AJAX form submission handler
    function handleFormSubmit(form) {
        const formId = form.id;
        const isLogin = formId === 'login-form';
        const responseElement = isLogin ? loginResponse : signupResponse;
        const formData = new FormData(form);
        
        // Show loading indicator
        const loadingDiv = document.createElement('div');
        loadingDiv.className = 'loading active';
        loadingDiv.innerHTML = '<div class="loading-spinner"></div>';
        form.appendChild(loadingDiv);
        
        // In a real application, you would send this to your server
        // This simulates an AJAX call
        $.ajax({
            url: isLogin ? '/api/login' : '/api/register',
            type: 'POST',
            data: formDataToJson(formData),
            contentType: 'application/json',
            processData: false,
            // This is just a simulation - in reality, this would be handled by your server
            beforeSend: function() {
                console.log("Sending " + (isLogin ? "login" : "signup") + " request...");
            },
            // Since we're not connecting to a real API, we'll simulate success after delay
            success: function(response) {
                simulateResponse(true);
            },
            error: function(xhr, status, error) {
                simulateResponse(false);
            }
        });
        
        // Simulate server response - in real app, this would be determined by actual API response
        function simulateResponse(success) {
            setTimeout(() => {
                // Remove loading indicator
                loadingDiv.remove();
                
                // Simulate server response
                let message = isLogin 
                    ? 'Login successful. Redirecting to dashboard...' 
                    : 'Account created successfully. Please check your email for verification.';
                    
                // For demo purposes, show an error sometimes
                if (isLogin && formData.get('loginEmail') === 'error@example.com') {
                    success = false;
                    message = 'Invalid email or password. Please try again.';
                }
                
                // Show response message
                responseElement.textContent = message;
                responseElement.classList.remove('d-none', 'alert-success', 'alert-danger');
                responseElement.classList.add(success ? 'alert-success' : 'alert-danger');
                
                // Reset form if successful
                if (success) {
                    form.reset();
                    form.classList.remove('was-validated');
                    
                    // Redirect after successful login (in real app)
                    if (isLogin) {
                        setTimeout(() => {
                            // In a real app, redirect to dashboard
                            alert('In a real application, you would be redirected to the dashboard.');
                        }, 2000);
                    }
                }
            }, 1500); // Simulate network delay
        }
        
        // Helper function to convert FormData to JSON
        function formDataToJson(formData) {
            const json = {};
            formData.forEach((value, key) => {
                json[key] = value;
            });
            return JSON.stringify(json);
        }
    }
});