/**
 * Main application initialization
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize server errors if available
    const serverErrors = parseServerErrors();
    
    // Initialize summernote editors
    try {
        $('#questionText').summernote({
            placeholder: 'Enter your question text here...',
            height: 150,
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'underline', 'clear']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['insert', ['link', 'picture', 'table']],
                ['view', ['fullscreen', 'codeview']]
            ]
        });
        
        $('#explanation').summernote({
            placeholder: 'Enter explanation here...',
            height: 120,
            toolbar: [
                ['style', ['bold', 'italic', 'underline']],
                ['para', ['ul', 'ol']],
                ['insert', ['link']]
            ]
        });
    } catch (e) {
        console.error("Error initializing Summernote:", e);
    }
    
    // Question type change handler
    document.getElementById('questionType').addEventListener('change', showRelevantFields);
    
    // Options count change handler
    document.getElementById('optionCount').addEventListener('change', updateOptionDisplay);
    
    // Reset button handler
    document.getElementById('resetBtn').addEventListener('click', resetForm);
    
    // Form submission handler
    document.getElementById('questionForm').addEventListener('submit', handleFormSubmit);
    
    // Refresh question list button
    document.getElementById('refreshQuestionList').addEventListener('click', function() {
        loadQuestions(document.getElementById('filterCourse').value);
    });
    
    // Filter by course
    document.getElementById('filterCourse').addEventListener('change', function() {
        loadQuestions(this.value);
    });
    
    // Initialize form sections
    showRelevantFields();
    updateOptionDisplay();
    
    // Load questions on page load
    loadQuestions();
    
    // Auto-dismiss alerts after 5 seconds
    setTimeout(function() {
        var successAlerts = document.querySelectorAll('.alert-success');
        successAlerts.forEach(function(alert) {
            alert.style.display = 'none';
        });
    }, 5000);
});