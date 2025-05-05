/**
 * Exam Creation JavaScript
 * Handles all functionality for the exam creation process
 */

// Global variables
let questionCounter = 0;
let questionData = [];
let currentQuestionId = 0;
const CURRENT_DATETIME = ''; // Updated current time
const CURRENT_USER_ID = 'IT24102083'; // Current user's login


// Document ready function
$(document).ready(function() {
    // Set the current date and time
    $('#currentDateTimeSpan').text(CURRENT_DATETIME);
    
    // Initialize Rich Text Editor for description
    $('#examDescription').summernote({
        placeholder: 'Enter exam description here...',
        tabsize: 2,
        height: 120,
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
			['table', ['table']],
			['insert', ['link', 'picture', 'video']],
			['view', ['fullscreen', 'codeview', 'help']]			
        ]
    });
    
    // Toggle sidebar
    $('#menu-toggle').click(function() {
        $('#sidebar').toggleClass('sidebar-collapsed');
        $('#main-content').toggleClass('main-content-expanded');
		$('#logo').toggleClass('hiddenlogo');
    });
    
    // Navigation between steps
    $('#nextToQuestions').click(function() {
        if (validateBasicInfo()) {
            showStep(2);
        }
    });
    
    $('#backToBasic').click(function() {
        showStep(1);
    });
    
    $('#nextToSettings').click(function() {
        if (validateQuestions()) {
            showStep(3);
        }
    });
    
    $('#backToQuestions').click(function() {
        showStep(2);
    });
    
    $('#nextToReview').click(function() {
        populateReview();
        showStep(4);
    });
    
    $('#backToSettings').click(function() {
        showStep(3);
    });
    
    // Add new question button - Show modal instead of adding question directly
    $('#addQuestionBtn').click(function() {
        // Show the question type modal
        $('#questionTypeModal').modal('show');
    });
    
    // Handle question type selection from modal
    $('#questionTypeModal button[data-type]').click(function() {
        const questionType = $(this).data('type');
        
        // Hide the modal
        $('#questionTypeModal').modal('hide');
        
        // Add new question with selected type
        addNewQuestion(questionType);
    });
    
    // Submit exam
    $('#submitExam').click(function() {
        submitExam();
    });
    
    // Override the default form submission
    $('#createExamForm').submit(function(e) {
        e.preventDefault();
        submitExam();
    });
    
    // Add initial questions if none exist
    if ($('#questionsContainer').children().length === 0) {
        addNewQuestion('multiple_choice');
        addNewQuestion('true_false');
    }
});

// Generate a unique ID for questions
function generateUniqueId() {
    return 'q' + Date.now() + Math.floor(Math.random() * 1000);
}

// Show a specific step
function showStep(stepNumber) {
    // Hide all steps
    $('.step-content').hide();
    $('.step').removeClass('active completed');
    
    // Show the specified step
    $(`#step${stepNumber}`).show();
    
    // Update stepper
    for (let i = 1; i < stepNumber; i++) {
        $(`#step${i}-indicator`).addClass('completed');
    }
    $(`#step${stepNumber}-indicator`).addClass('active');
}

// Validate basic info
function validateBasicInfo() {
    // Get form values
    const title = $('#examTitle').val();
    const course = $('#courseSelect').val();
    const examDate = $('#examDate').val();
    const startTime = $('#startTime').val();
    const duration = $('#duration').val();
    const totalMarks = $('#totalMarks').val();
    const passingMarks = $('#passingMarks').val();
    
    // Check required fields
    if (!title) {
        showAlert('Please enter an exam title.', 'danger');
        return false;
    }
    
    if (!course) {
        showAlert('Please select a course.', 'danger');
        return false;
    }
    
    if (!examDate) {
        showAlert('Please select an exam date.', 'danger');
        return false;
    }
    
    if (!startTime) {
        showAlert('Please select a start time.', 'danger');
        return false;
    }
    
    if (!duration || duration < 10) {
        showAlert('Please enter a valid duration (minimum 10 minutes).', 'danger');
        return false;
    }
    
    if (!totalMarks || totalMarks < 1) {
        showAlert('Please enter valid total marks.', 'danger');
        return false;
    }
    
    if (!passingMarks || passingMarks < 1 || parseInt(passingMarks) > parseInt(totalMarks)) {
        showAlert('Please enter valid passing marks (should not exceed total marks).', 'danger');
        return false;
    }
    
    return true;
}

// Validate questions
function validateQuestions() {
    const questions = $('#questionsContainer .question-container');
    
    if (questions.length === 0) {
        showAlert('Please add at least one question.', 'danger');
        return false;
    }
    
    let isValid = true;
    
    // Collect and validate all questions
    questionData = [];
    
    questions.each(function(index) {
        const $question = $(this);
        const questionId = $question.data('question-id');
        const questionText = $question.find('.question-text').val();
        const questionType = $question.find('.question-type').val();
        const marks = $question.find('.form-control[placeholder="Marks"]').val();
        const difficulty = $question.find('.form-select:last').val();
        
        // Check question text
        if (!questionText || questionText.trim() === '') {
            showAlert(`Question #${index + 1} is missing text.`, 'danger');
            isValid = false;
            return false;
        }
        
        // Check marks
        if (!marks || marks < 1) {
            showAlert(`Question #${index + 1} has invalid marks.`, 'danger');
            isValid = false;
            return false;
        }
        
        // For multiple choice questions, check options and correct answer
        if (questionType === 'multiple_choice') {
            const options = [];
            let hasCorrectAnswer = false;
            let correctOptionIndex = -1;
            
            $question.find('.option-item').each(function(optIndex) {
                const optionText = $(this).find('input[type="text"]').val();
                const isCorrect = $(this).find('input[type="radio"]').prop('checked');
                
                if (!optionText || optionText.trim() === '') {
                    showAlert(`Question #${index + 1} has an empty option.`, 'danger');
                    isValid = false;
                    return false;
                }
                
                options.push(optionText);
                
                if (isCorrect) {
                    hasCorrectAnswer = true;
                    correctOptionIndex = optIndex;
                }
            });
            
            if (!hasCorrectAnswer) {
                showAlert(`Question #${index + 1} has no correct answer selected.`, 'danger');
                isValid = false;
                return false;
            }
            
            // Add question data to our collection
            questionData.push({
                id: questionId,
                text: questionText,
                type: questionType,
                marks: marks,
                difficulty: difficulty,
                options: options,
                correctOptionIndex: correctOptionIndex
            });
        }
        // For true/false questions
        else if (questionType === 'true_false') {
            const isTrue = $question.find('input[name="correctOption' + questionId + '"]:first').prop('checked');
            
            questionData.push({
                id: questionId,
                text: questionText,
                type: questionType,
                marks: marks,
                difficulty: difficulty,
                correctAnswer: isTrue ? "True" : "False"
            });
        }
        // For short answer or essay questions
        else {
            const correctAnswer = $question.find('.option-container input[type="text"]').val() || "";
            
            questionData.push({
                id: questionId,
                text: questionText,
                type: questionType,
                marks: marks,
                difficulty: difficulty,
                correctAnswer: correctAnswer
            });
        }
    });
    
    return isValid;
}

// Populate review page
function populateReview() {
    // Basic info
    $('#reviewTitle').text($('#examTitle').val());
    $('#reviewCourse').text($('#courseSelect option:selected').text());
    $('#reviewDescription').html($('#examDescription').summernote('code'));
    
    const examDate = $('#examDate').val();
    const startTime = $('#startTime').val();
    $('#reviewDateTime').text(`${examDate} at ${startTime}`);
    
    $('#reviewDuration').text(`${$('#duration').val()} minutes`);
    $('#reviewMarks').text(`Total: ${$('#totalMarks').val()}, Passing: ${$('#passingMarks').val()}`);
    
    // Questions summary
    $('#reviewQuestionCount').text(questionData.length);
    
    // Count question types
    const typeCount = {};
    let totalPoints = 0;
    
    questionData.forEach(question => {
        const type = question.type;
        typeCount[type] = (typeCount[type] || 0) + 1;
        totalPoints += parseInt(question.marks);
    });
    
    let typeText = '';
    for (const type in typeCount) {
        const readableType = type.replace('_', ' ').replace(/\b\w/g, l => l.toUpperCase());
        typeText += `${readableType}: ${typeCount[type]}, `;
    }
    typeText = typeText.slice(0, -2); // Remove trailing comma and space
    
    $('#reviewQuestionTypes').text(typeText);
    $('#reviewTotalPoints').text(totalPoints);
    
    // Settings
    const settings = [
        { id: 'shuffleQuestions', label: 'Shuffle Questions' },
        { id: 'shuffleOptions', label: 'Shuffle Answer Options' },
        { id: 'showResults', label: 'Show Results Immediately' },
        { id: 'allowReview', label: 'Allow Review' },
        { id: 'preventBacktracking', label: 'Prevent Backtracking' },
        { id: 'requireWebcam', label: 'Require Webcam' },
        { id: 'limitAttempts', label: 'Limit Attempts' }
    ];
    
    let settingsHtml = '<ul class="list-group list-group-flush">';
    
    settings.forEach(setting => {
        const isChecked = $(`#${setting.id}`).prop('checked');
        const icon = isChecked ? 'fa-check text-success' : 'fa-times text-danger';
        
        settingsHtml += `
            <li class="list-group-item d-flex justify-content-between align-items-center">
                <span>${setting.label}</span>
                <i class="fas ${icon}"></i>
            </li>
        `;
        
        if (setting.id === 'limitAttempts' && isChecked) {
            settingsHtml += `
                <li class="list-group-item ps-4">
                    Maximum attempts: ${$('#maxAttempts').val()}
                </li>
            `;
        }
    });
    
    settingsHtml += '</ul>';
    $('#reviewSettings').html(settingsHtml);
}

// Add new question
function addNewQuestion(type = 'multiple_choice') {
    questionCounter++;
    const questionId = generateUniqueId();
    currentQuestionId = questionId;
    
    let html = '';
    
    html += '<div class="question-container" data-question-id="' + questionId + '">';
    html += '    <div class="question-header">';
    html += '        <div class="question-number">';
    html += '            <i class="fas fa-grip-vertical drag-handle"></i>';
    html += '            Question ' + questionCounter;
    html += '        </div>';
    html += '        <div class="question-actions">';
    html += '            <button type="button" class="action-btn duplicate-question" title="Duplicate">';
    html += '                <i class="fas fa-copy"></i>';
    html += '            </button>';
    html += '            <button type="button" class="action-btn delete-question" title="Delete">';
    html += '                <i class="fas fa-trash-alt"></i>';
    html += '            </button>';
    html += '        </div>';
    html += '    </div>';
    html += '    <div class="form-group">';
    html += '        <textarea class="form-control question-text" placeholder="Enter question text" rows="2"></textarea>';
    html += '    </div>';
    html += '    <div class="row mb-3">';
    html += '        <div class="col-md-6">';
    html += '            <select class="form-select question-type" onchange="changeQuestionType(this, \'' + questionId + '\')">';
    html += '                <option value="multiple_choice"' + (type == 'multiple_choice' ? ' selected' : '') + '>Multiple Choice</option>';
    html += '                <option value="true_false"' + (type == 'true_false' ? ' selected' : '') + '>True/False</option>';
    html += '                <option value="short_answer"' + (type == 'short_answer' ? ' selected' : '') + '>Short Answer</option>';
    html += '                <option value="essay"' + (type == 'essay' ? ' selected' : '') + '>Essay</option>';
    html += '            </select>';
    html += '        </div>';
    html += '        <div class="col-md-3">';
    html += '            <input type="number" class="form-control" placeholder="Marks" value="5">';
    html += '        </div>';
    html += '        <div class="col-md-3">';
    html += '            <select class="form-select">';
    html += '                <option value="easy">Easy</option>';
    html += '                <option value="medium" selected>Medium</option>';
    html += '                <option value="hard">Hard</option>';
    html += '            </select>';
    html += '        </div>';
    html += '    </div>';
    html += '    <div class="option-container">';
    
    // Different content based on question type
    if (type == 'multiple_choice') {
        html += generateMultipleChoiceOptions(questionId);
    } else if (type == 'true_false') {
        html += generateTrueFalseOptions(questionId);
    } else if (type == 'short_answer') {
        html += '<div class="form-group">';
        html += '    <label class="form-label">Correct Answer</label>';
        html += '    <input type="text" class="form-control" placeholder="Enter the correct answer">';
        html += '</div>';
    } else if (type == 'essay') {
        html += '<div class="form-group">';
        html += '    <label class="form-label">Answer Guidelines</label>';
        html += '    <textarea class="form-control" rows="3" placeholder="Enter any guidelines for essay answers (optional)"></textarea>';
        html += '</div>';
    }
    
    html += '    </div>';
    html += '</div>';
        
    $('#questionsContainer').append(html);
    
    // Attach event handlers to the new question
    attachQuestionEventHandlers(questionId);
}

// Generate multiple choice options
function generateMultipleChoiceOptions(questionId) {
    let html = '';
    html += '<div class="option-item">';
    html += '    <div class="option-prefix">A</div>';
    html += '    <div class="option-text">';
    html += '        <div class="input-group">';
    html += '            <input type="text" class="form-control" placeholder="Enter option">';
    html += '            <div class="input-group-text">';
    html += '                <input class="form-check-input mt-0" type="radio" name="correctOption' + questionId + '" checked>';
    html += '            </div>';
    html += '            <button type="button" class="btn btn-outline-danger remove-option" title="Remove option">';
    html += '                <i class="fas fa-times"></i>';
    html += '            </button>';
    html += '        </div>';
    html += '    </div>';
    html += '</div>';
    
    html += '<div class="option-item">';
    html += '    <div class="option-prefix">B</div>';
    html += '    <div class="option-text">';
    html += '        <div class="input-group">';
    html += '            <input type="text" class="form-control" placeholder="Enter option">';
    html += '            <div class="input-group-text">';
    html += '                <input class="form-check-input mt-0" type="radio" name="correctOption' + questionId + '">';
    html += '            </div>';
    html += '            <button type="button" class="btn btn-outline-danger remove-option" title="Remove option">';
    html += '                <i class="fas fa-times"></i>';
    html += '            </button>';
    html += '        </div>';
    html += '    </div>';
    html += '</div>';
    
    html += '<div class="option-item">';
    html += '    <div class="option-prefix">C</div>';
    html += '    <div class="option-text">';
    html += '        <div class="input-group">';
    html += '            <input type="text" class="form-control" placeholder="Enter option">';
    html += '            <div class="input-group-text">';
    html += '                <input class="form-check-input mt-0" type="radio" name="correctOption' + questionId + '">';
    html += '            </div>';
    html += '            <button type="button" class="btn btn-outline-danger remove-option" title="Remove option">';
    html += '                <i class="fas fa-times"></i>';
    html += '            </button>';
    html += '        </div>';
    html += '    </div>';
    html += '</div>';
    
    html += '<div class="option-item">';
    html += '    <div class="option-prefix">D</div>';
    html += '    <div class="option-text">';
    html += '        <div class="input-group">';
    html += '            <input type="text" class="form-control" placeholder="Enter option">';
    html += '            <div class="input-group-text">';
    html += '                <input class="form-check-input mt-0" type="radio" name="correctOption' + questionId + '">';
    html += '            </div>';
    html += '            <button type="button" class="btn btn-outline-danger remove-option" title="Remove option">';
    html += '                <i class="fas fa-times"></i>';
    html += '            </button>';
    html += '        </div>';
    html += '    </div>';
    html += '</div>';
    
    html += '<div class="add-option-btn" onclick="addOption(\'' + questionId + '\')">';
    html += '    <i class="fas fa-plus me-2"></i> Add Option';
    html += '</div>';
    
    return html;
}

// Generate true/false options
function generateTrueFalseOptions(questionId) {
    let html = '';
    html += '<div class="option-item">';
    html += '    <div class="option-prefix">T</div>';
    html += '    <div class="option-text">';
    html += '        <div class="input-group">';
    html += '            <input type="text" class="form-control" value="True" readonly>';
    html += '            <div class="input-group-text">';
    html += '                <input class="form-check-input mt-0" type="radio" name="correctOption' + questionId + '" checked>';
    html += '            </div>';
    html += '        </div>';
    html += '    </div>';
    html += '</div>';
    
    html += '<div class="option-item">';
    html += '    <div class="option-prefix">F</div>';
    html += '    <div class="option-text">';
    html += '        <div class="input-group">';
    html += '            <input type="text" class="form-control" value="False" readonly>';
    html += '            <div class="input-group-text">';
    html += '                <input class="form-check-input mt-0" type="radio" name="correctOption' + questionId + '">';
    html += '            </div>';
    html += '        </div>';
    html += '    </div>';
    html += '</div>';
    
    return html;
}

// Add new option to multiple choice question
function addOption(questionId) {
    const optionContainer = $('.question-container[data-question-id="' + questionId + '"] .option-container');
    const optionCount = optionContainer.find('.option-item').length;
    const nextLetter = String.fromCharCode(65 + optionCount); // A, B, C, ...
    
    let html = '';
    html += '<div class="option-item">';
    html += '    <div class="option-prefix">' + nextLetter + '</div>';
    html += '    <div class="option-text">';
    html += '        <div class="input-group">';
    html += '            <input type="text" class="form-control" placeholder="Enter option">';
    html += '            <div class="input-group-text">';
    html += '                <input class="form-check-input mt-0" type="radio" name="correctOption' + questionId + '">';
    html += '            </div>';
    html += '            <button type="button" class="btn btn-outline-danger remove-option" title="Remove option">';
    html += '                <i class="fas fa-times"></i>';
    html += '            </button>';
    html += '        </div>';
    html += '    </div>';
    html += '</div>';
    
    // Insert before the "Add Option" button
    const $newOption = $(html);
    $newOption.insertBefore(optionContainer.find('.add-option-btn'));
    
    // Attach event handler to the new remove button
    $newOption.find('.remove-option').click(function() {
        removeOption($(this), questionId);
    });
}

// Remove an option from a multiple choice question
function removeOption(buttonElement, questionId) {
    const $optionItem = $(buttonElement).closest('.option-item');
    const $optionContainer = $optionItem.closest('.option-container');
    
    // Make sure we have at least 2 options
    const totalOptions = $optionContainer.find('.option-item').length;
    if (totalOptions <= 2) {
        showAlert('A multiple choice question must have at least 2 options.', 'warning');
        return;
    }
    
    // Check if we're removing the option with the checked radio button
    const isChecked = $optionItem.find('input[type="radio"]').prop('checked');
    
    // Remove the option
    $optionItem.remove();
    
    // If we removed the checked option, select the first option
    if (isChecked) {
        $optionContainer.find('input[type="radio"]:first').prop('checked', true);
    }
    
    // Update the letter prefixes (A, B, C, etc.)
    $optionContainer.find('.option-item').each(function(index) {
        const letter = String.fromCharCode(65 + index); // A, B, C, ...
        $(this).find('.option-prefix').text(letter);
    });
}

// Change question type
function changeQuestionType(selectElement, questionId) {
    const selectedType = $(selectElement).val();
    const optionContainer = $('.question-container[data-question-id="' + questionId + '"] .option-container');
    
    // Clear option container
    optionContainer.empty();
    
    // Add appropriate content based on question type
    if (selectedType == 'multiple_choice') {
        optionContainer.html(generateMultipleChoiceOptions(questionId));
        
        // Attach event handlers to remove option buttons
        optionContainer.find('.remove-option').click(function() {
            removeOption($(this), questionId);
        });
    } else if (selectedType == 'true_false') {
        optionContainer.html(generateTrueFalseOptions(questionId));
    } else if (selectedType == 'short_answer') {
        optionContainer.html('<div class="form-group"><label class="form-label">Correct Answer</label><input type="text" class="form-control" placeholder="Enter the correct answer"></div>');
    } else if (selectedType == 'essay') {
        optionContainer.html('<div class="form-group"><label class="form-label">Answer Guidelines</label><textarea class="form-control" rows="3" placeholder="Enter any guidelines for essay answers (optional)"></textarea></div>');
    }
}

// Attach event handlers to question
function attachQuestionEventHandlers(questionId) {
    // Delete question
    $('.question-container[data-question-id="' + questionId + '"] .delete-question').click(function() {
        $(this).closest('.question-container').remove();
        // Update question numbers
        updateQuestionNumbers();
    });
    
    // Duplicate question
    $('.question-container[data-question-id="' + questionId + '"] .duplicate-question').click(function() {
        // Clone the question
        const $originalQuestion = $(this).closest('.question-container');
        const $clonedQuestion = $originalQuestion.clone(true);
        
        // Generate a new ID for the cloned question
        const newQuestionId = generateUniqueId();
        $clonedQuestion.attr('data-question-id', newQuestionId);
        
        // Update question counter
        questionCounter++;
        $clonedQuestion.find('.question-number').html(
            '<i class="fas fa-grip-vertical drag-handle"></i> Question ' + questionCounter
        );
        
        // Update radio input names
        $clonedQuestion.find('input[type="radio"]').attr('name', 'correctOption' + newQuestionId);
        
        // Update onchange handlers for question type dropdown
        $clonedQuestion.find('.question-type').attr('onchange', 'changeQuestionType(this, \'' + newQuestionId + '\')');
        
        // Update onclick handlers for add option buttons
        $clonedQuestion.find('.add-option-btn').attr('onclick', 'addOption(\'' + newQuestionId + '\')');
        
        // Clear text inputs for new options
        if ($clonedQuestion.find('.question-type').val() == 'multiple_choice') {
            $clonedQuestion.find('.option-text input[type="text"]').val('');
        }
        
        // Reset question text but keep the type
        $clonedQuestion.find('.question-text').val('');
        
        // Insert the cloned question after the original
        $originalQuestion.after($clonedQuestion);
        
        // Re-attach event handlers to the cloned question
        attachQuestionEventHandlers(newQuestionId);
    });
    
    // Attach event handlers to remove option buttons
    $('.question-container[data-question-id="' + questionId + '"] .remove-option').click(function() {
        removeOption($(this), questionId);
    });
}

// Update question numbers
function updateQuestionNumbers() {
    $('#questionsContainer .question-container').each(function(index) {
        $(this).find('.question-number').html(
            '<i class="fas fa-grip-vertical drag-handle"></i> Question ' + (index + 1)
        );
    });
    
    // Update counter
    questionCounter = $('#questionsContainer .question-container').length;
}

// Show alert message
function showAlert(message, type) {
    $('#statusMessage').removeClass().addClass('alert alert-' + type).text(message).fadeIn();
    setTimeout(function() {
        $('#statusMessage').fadeOut();
    }, 3000);
}

// Submit exam data
function submitExam() {
    // Display loading message
    showAlert('Processing your request...', 'info');
    
    // Collect exam data
    const examData = {
        examId: 'EX' + Date.now().toString().substr(-6), // Generate a unique exam ID
        examName: $('#examTitle').val(),
        courseId: $('#courseSelect').val(),
        description: $('#examDescription').summernote('code'),
        duration: parseInt($('#duration').val()),
        totalMarks: parseInt($('#totalMarks').val()),
        passingMarks: parseInt($('#passingMarks').val()),
        settings: {
            shuffleQuestions: $('#shuffleQuestions').prop('checked'),
            shuffleOptions: $('#shuffleOptions').prop('checked'),
            showResults: $('#showResults').prop('checked'),
            allowReview: $('#allowReview').prop('checked'),
            preventBacktracking: $('#preventBacktracking').prop('checked'),
            requireWebcam: $('#requireWebcam').prop('checked'),
            limitAttempts: $('#limitAttempts').prop('checked'),
            maxAttempts: parseInt($('#maxAttempts').val())
        },
        questions: questionData.map(function(q) { return q.id; }), // Store question IDs for reference
        createdBy: CURRENT_USER_ID,
        createdAt: CURRENT_DATETIME,
        startDate: $('#examDate').val() + 'T' + $('#startTime').val() + ':00Z',
        endDate: calculateEndTime($('#examDate').val(), $('#startTime').val(), parseInt($('#duration').val()))
    };
    
    // Use XMLHttpRequest to send exam data
    const xhr = new XMLHttpRequest();
    xhr.open('POST', 'ExamCreateServlet', true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                try {
                    const response = JSON.parse(xhr.responseText);
                    if (response.success) {
                        // Successfully saved exam, now save questions
                        saveQuestionsToFile(examData.examId);
                    } else {
                        showAlert('Error creating exam: ' + (response.message || 'Unknown error'), 'danger');
                    }
                } catch (e) {
                    // If response isn't valid JSON, just save questions anyway
                    saveQuestionsToFile(examData.examId);
                }
            } else {
                showAlert('Error saving exam data: ' + (xhr.responseText || xhr.statusText), 'danger');
            }
        }
    };
    xhr.send('action=saveExam&examData=' + encodeURIComponent(JSON.stringify(examData)));
}

// Function to save questions to file using our existing servlet
function saveQuestionsToFile(examId) {
    // Make a copy of the question data for processing
    const questionsToProcess = [...questionData];
    
    // Process questions one by one sequentially
    function processNextQuestion() {
        if (questionsToProcess.length === 0) {
            // All questions processed successfully
            showAlert('Exam and all questions created successfully!', 'success');
            setTimeout(function() {
                window.location.href = 'create-exam.jsp'; // Redirect to Create-exam.jsp
            }, 2000);
            return;
        }
        
        // Get the next question to process
        const question = questionsToProcess.shift();
        
        // Prepare form data for this question
        const formData = new FormData();
        formData.append('action', 'create');
        formData.append('questionId', question.id);
        formData.append('questionText', question.text);
        formData.append('questionType', question.type);
        formData.append('points', question.marks);
        formData.append('courseId', $('#courseSelect').val());
        formData.append('examId', examId);
        
        // Set difficulty level (convert from string to numeric value)
        let difficultyLevel = 2; // Default to medium
        if (question.difficulty === 'easy') difficultyLevel = 1;
        if (question.difficulty === 'hard') difficultyLevel = 3;
        formData.append('difficultyLevel', difficultyLevel);
        
        // Handle question-type specific data
        if (question.type === 'multiple_choice') {
            // Add each option
            question.options.forEach((option, i) => {
                formData.append('option' + i, option);
            });
            
            // Set which option is correct
            formData.append('correctOption', question.correctOptionIndex);
        } else if (question.type === 'true_false') {
            // True/False options
            formData.append('trueFalseOption', question.correctAnswer === "True" ? "true" : "false");
        } else if (question.type === 'short_answer' || question.type === 'essay') {
            // Correct answer for short answer/essay
            formData.append('correctAnswer', question.correctAnswer || "");
        }
        
        // Use XMLHttpRequest to send this question
        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'QuestionCreateServlet', true);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    // Question saved successfully, process the next one
                    processNextQuestion();
                } else {
                    console.error('Error saving question', xhr.responseText);
                    // Try to continue with the next question
                    processNextQuestion();
                }
            }
        };
        
        // Convert FormData to URL encoded format
        const params = new URLSearchParams();
        for(const pair of formData) {
            params.append(pair[0], pair[1]);
        }
        
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.send(params.toString());
    }
    
    // Start processing the first question
    processNextQuestion();
}

// Calculate end time based on start time and duration
function calculateEndTime(date, startTime, durationMinutes) {
    const startDateTime = new Date(date + 'T' + startTime + ':00');
    const endDateTime = new Date(startDateTime.getTime() + durationMinutes * 60000);
    return endDateTime.toISOString().replace('T', 'T').split('.')[0] + 'Z';
}