/**
 * Question form logic
 */

// Show/hide form sections based on question type
function showRelevantFields() {
    const questionType = document.getElementById('questionType').value;
    
    // Hide all sections first
    document.getElementById('multipleChoiceSection').style.display = 'none';
    document.getElementById('trueFalseSection').style.display = 'none';
    document.getElementById('shortAnswerSection').style.display = 'none';
    
    // Show relevant section based on question type
    if (questionType === 'multiple_choice') {
        document.getElementById('multipleChoiceSection').style.display = 'block';
        updateOptionDisplay(); // Make sure options are displayed correctly
        
        // Make options required
        const optionInputs = document.querySelectorAll('#multipleChoiceSection .option-group:not([style*="display: none"]) input[type="text"]');
        optionInputs.forEach(input => {
            input.required = true;
        });
        document.getElementById('correctAnswer').required = false;
        
    } else if (questionType === 'true_false') {
        document.getElementById('trueFalseSection').style.display = 'block';
        document.getElementById('correctAnswer').required = false;
        
        // Make options not required
        const optionInputs = document.querySelectorAll('#multipleChoiceSection input[type="text"]');
        optionInputs.forEach(input => {
            input.required = false;
        });
        
    } else if (questionType === 'short_answer' || questionType === 'essay') { // Added essay
        document.getElementById('shortAnswerSection').style.display = 'block';
        document.getElementById('correctAnswer').required = true;
        
        // Make options not required
        const optionInputs = document.querySelectorAll('#multipleChoiceSection input[type="text"]');
        optionInputs.forEach(input => {
            input.required = false;
        });
        
    } else {
        // For any other question types
        const optionInputs = document.querySelectorAll('#multipleChoiceSection input[type="text"]');
        optionInputs.forEach(input => {
            input.required = false;
        });
        document.getElementById('correctAnswer').required = false;
    }
}

// Update option display based on option count selection
function updateOptionDisplay() {
    const optionCount = parseInt(document.getElementById('optionCount').value);
    
    // Show/hide options based on selected count
    for (let i = 1; i <= 6; i++) {
        const optionElements = document.getElementsByClassName('option-' + i);
        for (let j = 0; j < optionElements.length; j++) {
            if (i <= optionCount) {
                optionElements[j].style.display = 'block';
                const inputElement = optionElements[j].querySelector('input[type="text"]');
                if (inputElement) inputElement.required = true;
            } else {
                optionElements[j].style.display = 'none';
                const inputElement = optionElements[j].querySelector('input[type="text"]');
                if (inputElement) inputElement.required = false;
            }
        }
    }
}

// Handle form submission
function handleFormSubmit(event) {
    event.preventDefault();
    
    // Basic validation
    const questionType = document.getElementById('questionType').value;
    let isValid = true;
    
    // Check if question text is empty
    const questionText = $('#questionText').summernote('code');
    if (!questionText || questionText.trim() === '' || questionText === '<p><br></p>') {
        alert("Please enter question text");
        $('#questionText').summernote('focus');
        isValid = false;
        return;
    }
    
    // Get form data
    const formData = new FormData(this);
    
    // Process options for multiple choice
    if (questionType === 'multiple_choice') {
        // Get selected option count
        const optionCount = parseInt(document.getElementById('optionCount').value);
        
        // Create array of options
        const options = [];
        for (let i = 0; i < optionCount; i++) {
            const optionValue = formData.get('option' + i);
            
            // Validate each option
            if (!optionValue || optionValue.trim() === '') {
                alert("Please enter text for option " + String.fromCharCode(65 + i));
                document.querySelector('input[name="option' + i + '"]').focus();
                isValid = false;
                return;
            }
            
            options.push(optionValue);
        }
        
        // Check if a correct option is selected
        const correctOption = document.querySelector('input[name="correctOption"]:checked');
        if (!correctOption) {
            alert("Please select a correct option");
            isValid = false;
            return;
        }
        
        // Get correct answer index and convert to letter
        const correctOptionIndex = parseInt(correctOption.value);
        const correctAnswer = String.fromCharCode(65 + correctOptionIndex);
        
        // Add to form as hidden fields
        addHiddenField(this, 'optionsJson', JSON.stringify(options));
        addHiddenField(this, 'correctAnswer', correctAnswer);
        
    } else if (questionType === 'true_false') {
        // Create options array with True/False
        const options = ['True', 'False'];
        const trueFalseOption = document.querySelector('input[name="trueFalseOption"]:checked').value;
        const correctAnswer = (trueFalseOption === 'true') ? 'A' : 'B';
        
        // Add to form as hidden fields
        addHiddenField(this, 'optionsJson', JSON.stringify(options));
        addHiddenField(this, 'correctAnswer', correctAnswer);
        
    } else if (questionType === 'short_answer' || questionType === 'essay') { // Added essay
        // Validate correct answer for short answer questions
        const correctAnswer = document.getElementById('correctAnswer').value;
        if (!correctAnswer || correctAnswer.trim() === '') {
            alert("Please enter a correct answer for the " + questionType + " question");
            document.getElementById('correctAnswer').focus();
            isValid = false;
            return;
        }
    }
    
    // Process tags
    const tagsInput = formData.get('tags');
    if (tagsInput && tagsInput.trim() !== '') {
        const tagsArray = processTagsString(tagsInput);
        addHiddenField(this, 'tagsJson', JSON.stringify(tagsArray));
    }
    
    // Submit form if valid
    if (isValid) {
        this.submit();
    }
}

// Reset form to initial state
function resetForm() {
    setTimeout(function() {
        $('#questionText').summernote('code', '');
        $('#explanation').summernote('code', '');
        document.getElementById('questionType').value = 'multiple_choice';
        document.getElementById('formTitle').textContent = 'Create New Question';
        document.getElementById('questionId').value = '';
        showRelevantFields();
        updateOptionDisplay();
    }, 100);
}

// Edit question - populate form with question data
function editQuestion(questionId) {
    $.ajax({
        url: 'QuestionServlet',
        type: 'GET',
        data: { action: 'get', id: questionId },
        success: function(response) {
            try {
                // Parse the response if it's a string
                const question = typeof response === 'string' ? JSON.parse(response) : response;
                
                // Populate form with question data
                document.getElementById('questionId').value = question.questionId || '';
                document.getElementById('courseId').value = question.courseId || '';
                document.getElementById('questionType').value = question.questionType || 'multiple_choice';
                document.getElementById('difficultyLevel').value = question.difficultyLevel || '2';
                document.getElementById('points').value = question.points || '1';
                document.getElementById('category').value = question.category || '';
                
                // Set question text in summernote
                $('#questionText').summernote('code', question.questionText || '');
                $('#explanation').summernote('code', question.explanation || '');
                
                // Set tags
                if (question.tags && Array.isArray(question.tags)) {
                    document.getElementById('tags').value = question.tags.join(', ');
                }
                
                // Handle options based on question type
                showRelevantFields();
                
                if (question.questionType === 'multiple_choice') {
                    if (question.options && question.options.length > 0) {
                        // Set option count
                        const optionCount = Math.min(question.options.length, 6);
                        document.getElementById('optionCount').value = optionCount;
                        updateOptionDisplay();
                        
                        // Fill in options
                        question.options.forEach((option, index) => {
                            if (index < 6) {
                                document.querySelector('input[name="option' + index + '"]').value = option;
                            }
                        });
                        
                        // Set correct answer
                        if (question.correctAnswer) {
                            // Calculate index from letter (A=0, B=1, etc.)
                            const correctIndex = question.correctAnswer.charCodeAt(0) - 65;
                            const correctRadio = document.querySelector('input[name="correctOption"][value="' + correctIndex + '"]');
                            if (correctRadio) correctRadio.checked = true;
                        }
                    }
                } else if (question.questionType === 'true_false') {
                    if (question.correctAnswer === 'A') {
                        document.getElementById('optionTrue').checked = true;
                    } else {
                        document.getElementById('optionFalse').checked = true;
                    }
                } else if (question.questionType === 'short_answer' || question.questionType === 'essay') { // Added essay
                    document.getElementById('correctAnswer').value = question.correctAnswer || '';
                }
                
                // Update form title
                document.getElementById('formTitle').textContent = 'Edit Question';
                
                // Scroll to form top
                window.scrollTo({
                    top: document.getElementById('questionForm').offsetTop - 100,
                    behavior: 'smooth'
                });
                
            } catch (e) {
                alert("Error loading question data: " + e.message);
            }
        },
        error: function() {
            alert("Error loading question. Please try again.");
        }
    });
}

/**
 * Question form handling
 */

// Variables to store the current state
let questionCounter = 0;
let examQuestions = [];

// Initialize when document loads
document.addEventListener('DOMContentLoaded', function() {
    // Initialize question form if it exists
    initQuestionForm();
    
    // Update datetime display
    updateCurrentDateTime();
    
    // Initialize any existing questions
    initExistingQuestions();
});

// Initialize the question form
function initQuestionForm() {
    // Add event listener to question type selection
    const questionTypeSelect = document.getElementById('questionType');
    if (questionTypeSelect) {
        questionTypeSelect.addEventListener('change', showRelevantFields);
    }
    
    // Add event listener to option count
    const optionCountSelect = document.getElementById('optionCount');
    if (optionCountSelect) {
        optionCountSelect.addEventListener('change', updateOptionDisplay);
    }
    
    // Add handlers for question form buttons
    const saveQuestionBtn = document.getElementById('saveQuestionBtn');
    if (saveQuestionBtn) {
        saveQuestionBtn.addEventListener('click', function() {
            saveQuestion(true); // Save and add another
        });
    }
    
    const saveAndReturnBtn = document.getElementById('saveAndReturnBtn');
    if (saveAndReturnBtn) {
        saveAndReturnBtn.addEventListener('click', function() {
            saveQuestion(false); // Save and return
        });
    }
    
    const cancelQuestionBtn = document.getElementById('cancelQuestionBtn');
    if (cancelQuestionBtn) {
        cancelQuestionBtn.addEventListener('click', hideQuestionForm);
    }
    
    // Initialize form fields
    showRelevantFields();
    updateOptionDisplay();
}

// Show/hide form sections based on question type
function showRelevantFields() {
    const questionType = document.getElementById('questionType').value;
    
    // Hide all sections first
    document.getElementById('multipleChoiceSection').style.display = 'none';
    document.getElementById('trueFalseSection').style.display = 'none';
    document.getElementById('shortAnswerSection').style.display = 'none';
    
    // Show relevant section based on question type
    if (questionType === 'multiple_choice') {
        document.getElementById('multipleChoiceSection').style.display = 'block';
        updateOptionDisplay(); // Make sure options are displayed correctly
        
        // Make options required
        const optionInputs = document.querySelectorAll('#multipleChoiceSection .option-group:not([style*="display: none"]) input[type="text"]');
        optionInputs.forEach(input => {
            input.required = true;
        });
        
        if (document.getElementById('correctAnswer')) {
            document.getElementById('correctAnswer').required = false;
        }
        
    } else if (questionType === 'true_false') {
        document.getElementById('trueFalseSection').style.display = 'block';
        
        if (document.getElementById('correctAnswer')) {
            document.getElementById('correctAnswer').required = false;
        }
        
        // Make options not required
        const optionInputs = document.querySelectorAll('#multipleChoiceSection input[type="text"]');
        optionInputs.forEach(input => {
            input.required = false;
        });
        
    } else if (questionType === 'short_answer' || questionType === 'essay') { // Added essay
        document.getElementById('shortAnswerSection').style.display = 'block';
        
        if (document.getElementById('correctAnswer')) {
            document.getElementById('correctAnswer').required = true;
        }
        
        // Make options not required
        const optionInputs = document.querySelectorAll('#multipleChoiceSection input[type="text"]');
        optionInputs.forEach(input => {
            input.required = false;
        });
        
    } else {
        // Essay questions don't have additional inputs
        const optionInputs = document.querySelectorAll('#multipleChoiceSection input[type="text"]');
        optionInputs.forEach(input => {
            input.required = false;
        });
        
        if (document.getElementById('correctAnswer')) {
            document.getElementById('correctAnswer').required = false;
        }
    }
}

// Update option display based on selected option count
function updateOptionDisplay() {
    const optionCount = parseInt(document.getElementById('optionCount').value);
    
    // Show/hide options based on selected count
    for (let i = 1; i <= 6; i++) {
        const optionElements = document.getElementsByClassName('option-' + i);
        for (let j = 0; j < optionElements.length; j++) {
            if (i <= optionCount) {
                optionElements[j].style.display = 'block';
                const inputElement = optionElements[j].querySelector('input[type="text"]');
                if (inputElement) inputElement.required = true;
            } else {
                optionElements[j].style.display = 'none';
                const inputElement = optionElements[j].querySelector('input[type="text"]');
                if (inputElement) inputElement.required = false;
            }
        }
    }
}

// Show the question form
function showQuestionForm() {
    // Hide the questions section
    document.getElementById('questionsContainer').style.display = 'none';
    document.getElementById('addQuestionBtn').style.display = 'none';
    
    // Show the form
    document.getElementById('questionFormSection').style.display = 'block';
    
    // Set the course ID to match the exam's course
    const courseSelect = document.getElementById('courseSelect');
    const courseId = document.getElementById('courseId');
    if (courseSelect && courseId) {
        courseId.value = courseSelect.value;
    }
    
    // Initialize rich text editor for question text
    if ($('#questionText').summernote) {
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
    }
    
    if ($('#explanation').summernote) {
        $('#explanation').summernote({
            placeholder: 'Enter explanation here...',
            height: 120,
            toolbar: [
                ['style', ['bold', 'italic', 'underline']],
                ['para', ['ul', 'ol']],
                ['insert', ['link']]
            ]
        });
    }
}

// Hide the question form and show questions list
function hideQuestionForm() {
    // Destroy summernote instances to prevent memory leaks
    if ($('#questionText').summernote) {
        $('#questionText').summernote('destroy');
    }
    
    if ($('#explanation').summernote) {
        $('#explanation').summernote('destroy');
    }
    
    // Reset the form
    document.getElementById('questionForm').reset();
    document.getElementById('questionId').value = '';
    document.getElementById('formTitle').textContent = 'Add New Question';
    
    // Hide the form and show questions section
    document.getElementById('questionFormSection').style.display = 'none';
    document.getElementById('questionsContainer').style.display = 'block';
    document.getElementById('addQuestionBtn').style.display = 'flex';
}

// Save a question
function saveQuestion(addAnother) {
    // Basic validation
    if (!validateQuestionForm()) {
        return false;
    }
    
    // Get form data
    const questionId = document.getElementById('questionId').value || 'new_' + Date.now();
    const questionType = document.getElementById('questionType').value;
    const questionText = $('#questionText').summernote('code');
    const difficultyLevel = document.getElementById('difficultyLevel').value;
    const points = document.getElementById('points').value;
    const category = document.getElementById('category').value;
    const explanation = $('#explanation').summernote('code');
    const tags = document.getElementById('tags').value;
    
    // Create question object
    const question = {
        questionId: questionId,
        questionType: questionType,
        questionText: questionText,
        difficultyLevel: difficultyLevel,
        points: points,
        category: category,
        explanation: explanation,
        tags: processTagsString(tags)
    };
    
    // Get answers based on question type
    if (questionType === 'multiple_choice') {
        const optionCount = parseInt(document.getElementById('optionCount').value);
        const options = [];
        
        for (let i = 0; i < optionCount; i++) {
            options.push(document.querySelector(`input[name="option${i}"]`).value);
        }
        
        const correctOptionIndex = parseInt(document.querySelector('input[name="correctOption"]:checked').value);
        const correctAnswer = String.fromCharCode(65 + correctOptionIndex);
        
        question.options = options;
        question.correctAnswer = correctAnswer;
        
    } else if (questionType === 'true_false') {
        question.options = ['True', 'False'];
        question.correctAnswer = document.getElementById('optionTrue').checked ? 'A' : 'B';
        
    } else if (questionType === 'short_answer' || questionType === 'essay') { // Added essay
        question.correctAnswer = document.getElementById('correctAnswer').value;
    }
    
    // Check if editing an existing question or adding a new one
    const existingIndex = examQuestions.findIndex(q => q.questionId === questionId);
    if (existingIndex !== -1) {
        // Update existing question
        examQuestions[existingIndex] = question;
    } else {
        // Add new question
        examQuestions.push(question);
    }
    
    // Update the questions container
    updateQuestionsContainer();
    
    // Show success message
    showMessage('Question saved successfully!', 'success');
    
    // Reset form or hide it
    if (addAnother) {
        // Reset form but keep course selection
        const courseId = document.getElementById('courseId').value;
        document.getElementById('questionForm').reset();
        document.getElementById('courseId').value = courseId;
        document.getElementById('questionId').value = '';
        $('#questionText').summernote('code', '');
        $('#explanation').summernote('code', '');
        showRelevantFields();
        updateOptionDisplay();
    } else {
        // Hide form and show questions
        hideQuestionForm();
    }
    
    return true;
}

// Validate the question form
function validateQuestionForm() {
    let isValid = true;
    const questionType = document.getElementById('questionType').value;
    
    // Check question text
    const questionText = $('#questionText').summernote('code');
    if (!questionText || questionText.trim() === '' || questionText === '<p><br></p>') {
        alert('Please enter question text');
        $('#questionText').summernote('focus');
        return false;
    }
    
    // Check options for multiple choice
    if (questionType === 'multiple_choice') {
        const optionCount = parseInt(document.getElementById('optionCount').value);
        
        for (let i = 0; i < optionCount; i++) {
            const optionValue = document.querySelector(`input[name="option${i}"]`).value;
            if (!optionValue || optionValue.trim() === '') {
                alert(`Please enter text for option ${String.fromCharCode(65 + i)}`);
                document.querySelector(`input[name="option${i}"]`).focus();
                return false;
            }
        }
        
        // Check if a correct option is selected
        if (!document.querySelector('input[name="correctOption"]:checked')) {
            alert('Please select a correct option');
            return false;
        }
    } 
    // Check correct answer for short answer or essay
    else if (questionType === 'short_answer' || questionType === 'essay') { // Added essay
        const correctAnswer = document.getElementById('correctAnswer').value;
        if (!correctAnswer || correctAnswer.trim() === '') {
            alert('Please enter a correct answer');
            document.getElementById('correctAnswer').focus();
            return false;
        }
    }
    
    return isValid;
}

// Update the questions container with all questions
function updateQuestionsContainer() {
    const container = document.getElementById('questionsContainer');
    container.innerHTML = '';
    
    examQuestions.forEach((question, index) => {
        const questionElement = createQuestionElement(question, index + 1);
        container.appendChild(questionElement);
    });
    
    // Initialize events for the new elements
    initExistingQuestions();
}

// Create a question element
function createQuestionElement(question, number) {
    const questionElement = document.createElement('div');
    questionElement.className = 'question-container';
    questionElement.dataset.questionId = question.questionId;
    
    // Truncate text for display
    let displayText = question.questionText;
    if (displayText.length > 100) {
        // Strip HTML tags for display
        displayText = displayText.replace(/<[^>]*>/g, '');
        if (displayText.length > 100) {
            displayText = displayText.substring(0, 100) + '...';
        }
    }
    
    questionElement.innerHTML = `
        <div class="question-header">
            <div class="question-number">
                <i class="fas fa-grip-vertical drag-handle"></i>
                Question ${number}
            </div>
            <div class="question-actions">
                <button type="button" class="action-btn edit-question" title="Edit" data-id="${question.questionId}">
                    <i class="fas fa-edit"></i>
                </button>
                <button type="button" class="action-btn duplicate-question" title="Duplicate" data-id="${question.questionId}">
                    <i class="fas fa-copy"></i>
                </button>
                <button type="button" class="action-btn delete-question" title="Delete" data-id="${question.questionId}">
                    <i class="fas fa-trash-alt"></i>
                </button>
            </div>
        </div>
        
        <div class="form-group">
            <div class="question-text-preview">${displayText}</div>
        </div>
        
        <div class="row mb-3">
            <div class="col-md-6">
                <span class="badge bg-primary">${getQuestionTypeLabel(question.questionType)}</span>
            </div>
            <div class="col-md-3">
                <span class="badge bg-secondary">${question.points} pts</span>
            </div>
            <div class="col-md-3">
                <span class="badge ${getDifficultyBadgeClass(question.difficultyLevel)}">
                    ${getDifficultyLabel(question.difficultyLevel)}
                </span>
            </div>
        </div>
    `;
    
    return questionElement;
}

// Initialize existing questions
function initExistingQuestions() {
    // Add question button
    const addQuestionBtn = document.getElementById('addQuestionBtn');
    if (addQuestionBtn) {
        addQuestionBtn.addEventListener('click', showQuestionForm);
    }
    
    // Edit question buttons
    document.querySelectorAll('.edit-question').forEach(button => {
        button.addEventListener('click', function() {
            const questionId = this.dataset.id;
            editQuestion(questionId);
        });
    });
    
    // Delete question buttons
    document.querySelectorAll('.delete-question').forEach(button => {
        button.addEventListener('click', function() {
            const questionId = this.dataset.id;
            deleteQuestion(questionId);
        });
    });
    
    // Duplicate question buttons
    document.querySelectorAll('.duplicate-question').forEach(button => {
        button.addEventListener('click', function() {
            const questionId = this.dataset.id;
            duplicateQuestion(questionId);
        });
    });
}

// Edit a question
function editQuestion(questionId) {
    const question = examQuestions.find(q => q.questionId === questionId);
    if (!question) return;
    
    // Show the form
    showQuestionForm();
    
    // Populate form with question data
    document.getElementById('questionId').value = question.questionId;
    document.getElementById('questionType').value = question.questionType;
    document.getElementById('difficultyLevel').value = question.difficultyLevel;
    document.getElementById('points').value = question.points;
    document.getElementById('category').value = question.category || '';
    $('#questionText').summernote('code', question.questionText || '');
    $('#explanation').summernote('code', question.explanation || '');
    
    if (question.tags && Array.isArray(question.tags)) {
        document.getElementById('tags').value = question.tags.join(', ');
    }
    
    // Update form title
    document.getElementById('formTitle').textContent = 'Edit Question';
    
    // Show relevant fields for the question type
    showRelevantFields();
    
    // Set options based on question type
    if (question.questionType === 'multiple_choice') {
        if (question.options && question.options.length > 0) {
            // Set option count
            const optionCount = Math.min(question.options.length, 6);
            document.getElementById('optionCount').value = optionCount;
            updateOptionDisplay();
            
            // Fill in options
            question.options.forEach((option, index) => {
                if (index < 6) {
                    document.querySelector(`input[name="option${index}"]`).value = option;
                }
            });
            
            // Set correct answer
            if (question.correctAnswer) {
                // Calculate index from letter (A=0, B=1, etc.)
                const correctIndex = question.correctAnswer.charCodeAt(0) - 65;
                const correctRadio = document.querySelector(`input[name="correctOption"][value="${correctIndex}"]`);
                if (correctRadio) correctRadio.checked = true;
            }
        }
    } else if (question.questionType === 'true_false') {
        if (question.correctAnswer === 'A') {
            document.getElementById('optionTrue').checked = true;
        } else {
            document.getElementById('optionFalse').checked = true;
        }
    } else if (question.questionType === 'short_answer' || question.questionType === 'essay') { // Added essay
        document.getElementById('correctAnswer').value = question.correctAnswer || '';
    }
}

// Delete a question
function deleteQuestion(questionId) {
    if (!confirm('Are you sure you want to delete this question?')) {
        return;
    }
    
    const index = examQuestions.findIndex(q => q.questionId === questionId);
    if (index !== -1) {
        examQuestions.splice(index, 1);
        updateQuestionsContainer();
        showMessage('Question deleted successfully!', 'success');
    }
}

// Duplicate a question
function duplicateQuestion(questionId) {
    const question = examQuestions.find(q => q.questionId === questionId);
    if (!question) return;
    
    // Create a deep copy of the question
    const newQuestion = JSON.parse(JSON.stringify(question));
    newQuestion.questionId = 'new_' + Date.now();
    
    // Add to questions array
    examQuestions.push(newQuestion);
    updateQuestionsContainer();
    showMessage('Question duplicated successfully!', 'success');
}

// Submit all questions to servlet
function submitQuestionsToServlet(examId) {
    // Create form data
    const formData = new FormData();
    formData.append('action', 'save_questions');
    formData.append('examId', examId);
    formData.append('questionsData', JSON.stringify(examQuestions));
    
    // Submit via fetch API
    return fetch('ExamCreateServlet', {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.status !== 'success') {
            throw new Error(data.message || 'Failed to save questions');
        }
        return data;
    });
}