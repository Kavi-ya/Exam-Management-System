// Format date and time for display
function formatDateTime(date, time) {
    if (!date) return '';
    
    try {
        const dateObj = new Date(date);
        const month = dateObj.toLocaleString('default', { month: 'long' });
        const day = dateObj.getDate();
        const year = dateObj.getFullYear();
        
        if (!time) return `${month} ${day}, ${year}`;
        
        return `${month} ${day}, ${year} at ${formatTime(time)}`;
    } catch (e) {
        console.error('Error formatting date:', e);
        return date + (time ? ' ' + time : '');
    }
}

// Format time from 24h to 12h format
function formatTime(time24) {
    if (!time24) return '';
    
    try {
        const [hours, minutes] = time24.split(':');
        const hour = parseInt(hours, 10);
        const suffix = hour >= 12 ? 'PM' : 'AM';
        const hour12 = hour % 12 || 12;
        return `${hour12}:${minutes} ${suffix}`;
    } catch (e) {
        console.error('Error formatting time:', e);
        return time24;
    }
}

// Get difficulty level label
function getDifficultyLabel(level) {
    level = parseInt(level) || 2;
    switch (level) {
        case 1: return 'Easy';
        case 2: return 'Medium';
        case 3: return 'Hard';
        default: return 'Medium';
    }
}

// Get CSS class for difficulty badge
function getDifficultyBadgeClass(level) {
    level = parseInt(level) || 2;
    switch (level) {
        case 1: return 'bg-success';
        case 2: return 'bg-warning text-dark';
        case 3: return 'bg-danger';
        default: return 'bg-warning text-dark';
    }
}

// Get readable question type label
function getQuestionTypeLabel(type) {
    switch (type) {
        case 'multiple_choice': return 'Multiple Choice';
        case 'true_false': return 'True/False';
        case 'short_answer': return 'Short Answer';
        case 'essay': return 'Essay';
        default: return 'Multiple Choice';
    }
}

// Show an alert message
function showMessage(message, type = 'success', timeout = 5000) {
    console.log(`Showing message: ${message} (${type})`);
    
    // Create alert element
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
    alertDiv.role = 'alert';
    
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `;
    
    // Insert at top of main content
    const mainContent = document.querySelector('.main-content');
    if (mainContent) {
        mainContent.insertBefore(alertDiv, mainContent.firstChild);
    
        // Auto dismiss after timeout
        if (timeout > 0) {
            setTimeout(() => {
                alertDiv.classList.remove('show');
                setTimeout(() => alertDiv.remove(), 150);
            }, timeout);
        }
    }
}

// Update stepper UI
function updateStepper(currentStep) {
    // Remove active/completed class from all steps
    const stepElements = document.querySelectorAll('.stepper .step');
    stepElements.forEach((stepElement, index) => {
        stepElement.classList.remove('active', 'completed');
        if (index + 1 < currentStep) {
            stepElement.classList.add('completed');
        } else if (index + 1 === currentStep) {
            stepElement.classList.add('active');
        }
    });
}

// Show a specific step and hide others
function showStep(stepNumber) {
    console.log(`Showing step ${stepNumber}`);
    
    // Hide all steps
    const steps = document.querySelectorAll('.step-content');
    steps.forEach(step => {
        step.style.display = 'none';
    });
    
    // Show selected step
    const currentStep = document.getElementById('step' + stepNumber);
    if (currentStep) {
        currentStep.style.display = 'block';
    } else {
        console.error(`Step element with ID step${stepNumber} not found`);
    }
    
    // Update stepper UI
    updateStepper(stepNumber);
}