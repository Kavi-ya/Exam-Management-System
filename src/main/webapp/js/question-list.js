/**
 * Question list management
 */

// Load questions from server
function loadQuestions(courseFilter = '') {
    $('#questionsList').html(`
        <div class="text-center py-4">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-2">Loading questions...</p>
        </div>
    `);
    
    // Fetch questions from server
    $.ajax({
        url: 'QuestionListServlet',
        type: 'GET',
        data: { courseId: courseFilter },
        success: function(response) {
            try {
                // Parse the response if it's a string
                const questions = typeof response === 'string' ? JSON.parse(response) : response;
                
                // If questions is empty, display placeholder
                if (!questions || questions.length === 0) {
                    $('#questionsList').html(`
                        <div class="text-center py-4">
                            <i class="fas fa-question-circle fa-3x text-muted mb-3"></i>
                            <p>No questions found. Create your first question!</p>
                        </div>
                    `);
                    return;
                }
                
                displayQuestions(questions);
            } catch (e) {
                $('#questionsList').html(`
                    <div class="alert alert-danger">
                        Error loading questions: ${e.message}
                    </div>
                `);
            }
        },
        error: function() {
            $('#questionsList').html(`
                <div class="alert alert-danger">
                    Error loading questions. Please try again.
                </div>
            `);
        }
    });
}

// Display questions in the list
function displayQuestions(questions) {
    let html = '';
    
    questions.forEach(function(question) {
        // Create a safer version of the question text for display
        let displayText = question.questionText || '';
        // Remove HTML tags
        displayText = displayText.replace(/<[^>]*>/g, '');
        // Truncate long text
        if (displayText.length > 150) {
            displayText = displayText.substring(0, 150) + '...';
        }
        
        html += `
            <div class="question-preview" data-id="${question.questionId || ''}">
                <div class="d-flex justify-content-between mb-2">
                    <span class="badge ${getDifficultyBadgeClass(question.difficultyLevel || 2)}">
                        ${getDifficultyLabel(question.difficultyLevel || 2)}
                    </span>
                    <span class="badge bg-primary">${question.points || 1} pts</span>
                </div>
                <div class="question-text mb-2">
                    ${displayText}
                </div>
                <div class="d-flex justify-content-between align-items-center">
                    <small class="text-muted">${getQuestionTypeLabel(question.questionType || 'multiple_choice')}</small>
                    <div>
                        <button class="btn btn-sm btn-outline-primary edit-question" onclick="editQuestion('${question.questionId || ''}')">
                            <i class="fas fa-edit"></i>
                        </button>
                        <button class="btn btn-sm btn-outline-danger delete-question" onclick="deleteQuestion('${question.questionId || ''}')">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </div>
                </div>
            </div>
        `;
    });
    
    $('#questionsList').html(html);
}

// Delete question
function deleteQuestion(questionId) {
    if (confirm('Are you sure you want to delete this question?')) {
        $.ajax({
            url: 'QuestionServlet',
            type: 'POST',
            data: { action: 'delete', id: questionId },
            success: function() {
                alert("Question deleted successfully!");
                loadQuestions(document.getElementById('filterCourse').value); // Refresh the question list
            },
            error: function() {
                alert("Error deleting question. Please try again.");
            }
        });
    }
}