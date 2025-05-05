/**
 * Admin Exams Management JavaScript
 * Handles all functionality for the admin exam management interface
 */

// Document ready
$(document).ready(function() {
    console.log("Document ready. Initializing adminExams.js");
    
    // Current date and time from server
    const CURRENT_DATETIME = "2025-04-11 08:58:06";
    const CURRENT_USER_ID = "IT24102083";
    
    console.log("System time:", CURRENT_DATETIME);
    console.log("Current user:", CURRENT_USER_ID);
    
    // Initialize Summernote editor for rich text editing
    initSummernote();
    
    // Toggle sidebar functionality - Enhanced with proper styling
    $('#menu-toggle').click(function() {
        // Toggle classes for layout changes
        $('#sidebar').toggleClass('sidebar-collapsed');
        $('#main-content').toggleClass('main-content-expanded');
        $('#logo').toggleClass('hiddenlogo');
        
        // Dynamically adjust element styles based on sidebar state
        if ($('#sidebar').hasClass('sidebar-collapsed')) {
            // Collapsed state styling
            $('.menu-item i').css('margin-right', '0');
            $('.menu-text').css('display', 'none');
            $('.sidebar-header h3 span').css('display', 'none');
        } else {
            // Expanded state styling
            $('.menu-item i').css('margin-right', '15px');
            $('.menu-text').css('display', 'inline');
            $('.sidebar-header h3 span').css('display', 'inline');
        }
    });
    
    // Filter and search functionality
    $('#statusFilter, #courseFilter, #instructorFilter').change(filterExams);
    $('#searchExam').keyup(filterExams);
    
    // View questions toggle
    $('.view-questions-btn').click(function() {
        const examId = $(this).data('exam-id');
        $(`#questionContainer-${examId}`).toggle();
    });
    
    // Edit exam button
    $('.edit-exam-btn').click(function() {
        const examId = $(this).data('exam-id');
        
        // Reset form and set title
        $('#examModalLabel').text('Edit Exam');
        
        // Fetch exam data - FIXED URL TO MATCH SERVLET MAPPING
        $.ajax({
            url: 'AdminExamMgServlet',
            type: 'GET',
            data: {
                action: 'getExam',
                examId: examId
            },
            dataType: 'json',
            success: function(exam) {
                console.log("Exam data received:", exam);
                
                // Set form values
                $('#examId').val(exam.examId);
                $('#examName').val(exam.examName || '');
                $('#courseSelect').val(exam.courseId || '');
                $('#instructorSelect').val(exam.createdBy || '');
                $('#examDescription').val(exam.description || '');
                
                // Parse date and time
                if (exam.startDate) {
                    try {
                        // Handle different date formats
                        let startDate, startTime;
                        if (exam.startDate.includes('T')) {
                            // ISO format: 2025-04-10T10:00:00Z
                            const parts = exam.startDate.split('T');
                            startDate = parts[0];
                            startTime = parts[1].substring(0, 5); // Get HH:MM
                        } else {
                            // Simple format: 2025-04-10 10:00:00
                            const parts = exam.startDate.split(' ');
                            startDate = parts[0];
                            startTime = parts[1].substring(0, 5); // Get HH:MM
                        }
                        
                        $('#examDate').val(startDate);
                        $('#startTime').val(startTime);
                    } catch (e) {
                        console.error("Error parsing date:", e);
                        // Default values
                        $('#examDate').val("2025-04-11");
                        $('#startTime').val("10:00");
                    }
                }
                
                $('#duration').val(exam.duration || 60);
                $('#totalMarks').val(exam.totalMarks || 100);
                $('#passingMarks').val(exam.passingMarks || 40);
                $('#examStatus').val(exam.status || 'draft');
                
                // Set checkboxes
                if (exam.settings) {
                    $('#shuffleQuestions').prop('checked', exam.settings.shuffleQuestions || false);
                    $('#shuffleOptions').prop('checked', exam.settings.shuffleOptions || false);
                    $('#showResults').prop('checked', exam.settings.showResults || false);
                    $('#allowReview').prop('checked', exam.settings.allowReview || false);
                    $('#preventBacktracking').prop('checked', exam.settings.preventBacktracking || false);
                    $('#requireWebcam').prop('checked', exam.settings.requireWebcam || false);
                }
                
                // Show the modal
                const examModal = new bootstrap.Modal(document.getElementById('examModal'));
                examModal.show();
            },
            error: function(xhr, status, error) {
                console.error("Error fetching exam data:");
                console.error("Status:", status);
                console.error("Error:", error);
                console.error("Response:", xhr.responseText);
                showAlert('Error loading exam: API endpoint may be unavailable', 'danger');
            }
        });
    });
    
    // Save exam button - FIXED ERROR HANDLING
    $('#saveExamBtn').click(function() {
        // Get form data
        const examId = $('#examId').val();
        const examName = $('#examName').val();
        const courseId = $('#courseSelect').val();
        const instructorId = $('#instructorSelect').val();
        const description = $('#examDescription').val();
        const examDate = $('#examDate').val();
        const startTime = $('#startTime').val();
        const duration = $('#duration').val();
        const totalMarks = $('#totalMarks').val();
        const passingMarks = $('#passingMarks').val();
        const status = $('#examStatus').val();
        
        // Validate form
        if (!examName || !courseId || !instructorId || !examDate || !startTime || !duration || !totalMarks || !passingMarks) {
            showAlert('Please fill in all required fields.', 'danger');
            return;
        }
        
        // Settings
        const settings = {
            shuffleQuestions: $('#shuffleQuestions').prop('checked'),
            shuffleOptions: $('#shuffleOptions').prop('checked'),
            showResults: $('#showResults').prop('checked'),
            allowReview: $('#allowReview').prop('checked'),
            preventBacktracking: $('#preventBacktracking').prop('checked'),
            requireWebcam: $('#requireWebcam').prop('checked')
        };
        
        // Prepare data for the server
        const examData = {
            examId: examId,
            examName: examName,
            courseId: courseId,
            description: description,
            duration: parseInt(duration),
            totalMarks: parseInt(totalMarks),
            passingMarks: parseInt(passingMarks),
            status: status,
            createdBy: instructorId,
            startDate: examDate + 'T' + startTime + ':00Z',
            settings: settings,
            modifiedAt: CURRENT_DATETIME
        };
        
        console.log("Sending exam data:", examData);
        
        // Send data to the server - CORRECT SERVLET URL
        $.ajax({
            url: 'AdminExamMgServlet',
            type: 'POST',
            data: {
                action: 'updateExam',
                examData: JSON.stringify(examData)
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    showAlert(response.message || 'Exam saved successfully!', 'success');
                    
                    // Close the modal
                    const modalElement = document.getElementById('examModal');
                    const modal = bootstrap.Modal.getInstance(modalElement);
                    modal.hide();
                    
                    // Reload the page after a delay
                    setTimeout(function() {
                        location.reload();
                    }, 1500);
                } else {
                    showAlert(response.message || 'Error saving exam.', 'danger');
                }
            },
            error: function(xhr, status, error) {
                console.error("Error updating exam:");
                console.error("Status:", status);
                console.error("Error:", error);
                console.error("Response:", xhr.responseText);
                showAlert('Error saving exam: API endpoint may be unavailable', 'danger');
            }
        });
    });
    
    // Question Type Change
    $('#questionType').change(function() {
        const type = $(this).val();
        updateQuestionTypeFields(type);
    });
    
    // Add new option
    $('#addNewOption').click(function(e) {
        e.preventDefault();
        
        const optionCount = $('#optionsList .option-item').length;
        const optionLetter = String.fromCharCode(65 + optionCount); // A, B, C, ...
        
        const html = `
            <div class="d-flex align-items-center mb-2 option-item">
                <span class="me-2">${optionLetter}.</span>
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="Enter option">
                    <div class="input-group-text">
                        <input class="form-check-input mt-0" type="radio" name="correctOption">
                    </div>
                    <button type="button" class="btn btn-outline-danger remove-option">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        `;
        
        $('#optionsList').append(html);
        setupRemoveOptionHandlers();
    });
    
    // Add Question
    $('.add-question-btn').click(function() {
        const examId = $(this).data('exam-id');
        
        // Reset form
        $('#questionForm').trigger('reset');
        $('#questionId').val('');
        $('#questionExamId').val(examId);
        $('#questionModalLabel').text('Add New Question');
        
        // Set up default options
        $('#optionsList').empty();
        addEmptyOption('A', true);
        addEmptyOption('B', false);
        
        // Set default question type
        $('#questionType').val('multiple_choice');
        updateQuestionTypeFields('multiple_choice');
        
        // Initialize Summernote
        if ($.fn.summernote) {
            $('#correctAnswer').summernote('code', '');
        }
        
        // Show the modal
        const questionModal = new bootstrap.Modal(document.getElementById('questionModal'));
        questionModal.show();
    });
    
    // Edit Question - FIXED URL
    $('.edit-question-btn').click(function() {
        const questionId = $(this).data('question-id');
        const examId = $(this).closest('.question-container').attr('id').replace('questionContainer-', '');
        
        // Reset form
        $('#questionModalLabel').text('Edit Question');
        
        // Fetch question data
        $.ajax({
            url: 'AdminExamMgServlet',
            type: 'GET',
            data: {
                action: 'getQuestionById',
                questionId: questionId
            },
            dataType: 'json',
            success: function(question) {
                console.log("Question data received:", question);
                
                $('#questionId').val(question.questionId);
                $('#questionExamId').val(examId);
                $('#questionText').val(question.questionText || question.text || '');
                $('#questionType').val(question.questionType || question.type || 'multiple_choice');
                $('#questionMarks').val(question.points || question.marks || 5);
                $('#difficultyLevel').val(question.difficultyLevel || 2);
                
                // Update UI based on question type
                const questionType = question.questionType || question.type || 'multiple_choice';
                updateQuestionTypeFields(questionType);
                
                // Handle different question types
                if (questionType === 'multiple_choice') {
                    // Clear previous options
                    $('#optionsList').empty();
                    
                    // Add options
                    if (question.options && question.options.length > 0) {
                        question.options.forEach((option, index) => {
                            // Add option with text
                            const html = `
                                <div class="d-flex align-items-center mb-2 option-item">
                                    <span class="me-2">${String.fromCharCode(65 + index)}.</span>
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder="Enter option" value="${option}">
                                        <div class="input-group-text">
                                            <input class="form-check-input mt-0" type="radio" name="correctOption">
                                        </div>
                                        <button type="button" class="btn btn-outline-danger remove-option">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </div>
                                </div>
                            `;
                            
                            $('#optionsList').append(html);
                            
                            // Set correct option
                            if (question.correctAnswer) {
                                const correctLetter = question.correctAnswer;
                                if (String.fromCharCode(65 + index) === correctLetter) {
                                    $('#optionsList .option-item:last')
                                        .find('input[type="radio"]')
                                        .prop('checked', true);
                                }
                            } else if (question.correctOptionIndex !== undefined) {
                                if (question.correctOptionIndex === index) {
                                    $('#optionsList .option-item:last')
                                        .find('input[type="radio"]')
                                        .prop('checked', true);
                                }
                            }
                        });
                    } else {
                        // Default options if none exist
                        addEmptyOption('A', true);
                        addEmptyOption('B', false);
                    }
                } else if (questionType === 'true_false') {
                    // Set the true/false radio button
                    const isTrue = question.correctAnswer === 'True';
                    $('#optionTrue').prop('checked', isTrue);
                    $('#optionFalse').prop('checked', !isTrue);
                } else {
                    // For short answer/essay
                    if ($.fn.summernote) {
                        $('#correctAnswer').summernote('code', question.correctAnswer || '');
                    } else {
                        $('#correctAnswer').val(question.correctAnswer || '');
                    }
                }
                
                setupRemoveOptionHandlers();
                
                // Show the modal
                const questionModal = new bootstrap.Modal(document.getElementById('questionModal'));
                questionModal.show();
            },
            error: function(xhr, status, error) {
                console.error("Error fetching question data:");
                console.error("Status:", status);
                console.error("Error:", error);
                console.error("Response:", xhr.responseText);
                showAlert('Error loading question: API endpoint may be unavailable', 'danger');
            }
        });
    });
    
    // Save Question - FIXED URL AND ERROR HANDLING
    $('#saveQuestionBtn').click(function() {
        // Get form data
        const questionId = $('#questionId').val();
        const examId = $('#questionExamId').val();
        const questionText = $('#questionText').val();
        const questionType = $('#questionType').val();
        const marks = $('#questionMarks').val();
        const difficultyLevel = $('#difficultyLevel').val();
        
        // Validate form
        if (!questionText || !marks) {
            showAlert('Please fill in all required fields.', 'danger');
            return;
        }
        
        // Prepare data object
        const questionData = {
            questionId: questionId || 'q' + Date.now(),
            questionText: questionText,
            questionType: questionType,
            difficultyLevel: parseInt(difficultyLevel),
            points: parseInt(marks),
            courseId: null, // Will be set by the server based on the exam
            createdBy: CURRENT_USER_ID,
            modifiedAt: CURRENT_DATETIME,
            active: true
        };
        
        // Additional data based on question type
        if (questionType === 'multiple_choice') {
            const options = [];
            let correctAnswerLetter = null;
            
            $('#optionsList .option-item').each(function(index) {
                const optionText = $(this).find('input[type="text"]').val();
                const isCorrect = $(this).find('input[type="radio"]').prop('checked');
                
                if (!optionText) {
                    showAlert('Please fill in all options.', 'danger');
                    return false;
                }
                
                options.push(optionText);
                
                if (isCorrect) {
                    correctAnswerLetter = String.fromCharCode(65 + index); // A, B, C, ...
                }
            });
            
            if (!correctAnswerLetter) {
                showAlert('Please select a correct answer.', 'danger');
                return;
            }
            
            questionData.options = options;
            questionData.correctAnswer = correctAnswerLetter;
        } else if (questionType === 'true_false') {
            const isTrue = $('input[name="trueFalseOption"]:checked').val() === 'true';
            questionData.correctAnswer = isTrue ? "True" : "False";
            questionData.options = ["True", "False"];
        } else {
            // For essay or short answer, get the rich text content
            if ($.fn.summernote) {
                questionData.correctAnswer = $('#correctAnswer').summernote('code') || "";
            } else {
                questionData.correctAnswer = $('#correctAnswer').val() || "";
            }
        }
        
        console.log("Sending question data:", questionData);
        
        // Determine if this is an add or edit operation
        const action = questionId ? 'updateQuestion' : 'addQuestion';
        
        // Send data to the server
        $.ajax({
            url: 'AdminExamMgServlet',
            type: 'POST',
            data: {
                action: action,
                questionData: JSON.stringify(questionData),
                examId: examId
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    showAlert(response.message || 'Question saved successfully!', 'success');
                    
                    // Close the modal
                    const modalElement = document.getElementById('questionModal');
                    const modal = bootstrap.Modal.getInstance(modalElement);
                    modal.hide();
                    
                    // Reload the page after a delay
                    setTimeout(function() {
                        location.reload();
                    }, 1500);
                } else {
                    showAlert(response.message || 'Error saving question.', 'danger');
                }
            },
            error: function(xhr, status, error) {
                console.error("Error saving question:");
                console.error("Status:", status);
                console.error("Error:", error);
                console.error("Response:", xhr.responseText);
                showAlert('Error saving question: API endpoint may be unavailable', 'danger');
            }
        });
    });
    
    // Delete exam button - FIXED
    $('.delete-exam-btn').click(function() {
        const examId = $(this).data('exam-id');
        const examRow = $(this).closest('tr');
        const examName = examRow.find('td:nth-child(2)').text();
        
        $('#deleteItemId').val(examId);
        $('#deleteItemType').val('exam');
        $('#deleteItemName').text(examName + ' (' + examId + ')');
        
        // Show the delete confirmation modal
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
        deleteModal.show();
    });
    
    // Delete question button
    $('.delete-question-btn').click(function() {
        const questionId = $(this).data('question-id');
        const examId = $(this).data('exam-id');
        const questionItem = $(this).closest('.question-list-item');
        const questionText = questionItem.find('.question-text').text();
        
        $('#deleteItemId').val(questionId);
        $('#deleteItemType').val('question');
        $('#deleteItemName').text(questionText);
        $('#deleteExamId').val(examId);
        
        // Show the delete confirmation modal
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
        deleteModal.show();
    });
    
    // Confirm delete button - FIXED URL AND ERROR HANDLING
    $('#confirmDelete').click(function() {
        const itemId = $('#deleteItemId').val();
        const itemType = $('#deleteItemType').val();
        
        if (itemType === 'exam') {
            // Delete exam
            $.ajax({
                url: 'AdminExamMgServlet',
                type: 'POST',
                data: {
                    action: 'deleteExam',
                    examId: itemId
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        showAlert('Exam deleted successfully!', 'success');
                        
                        // Close the modal
                        const modalElement = document.getElementById('deleteConfirmModal');
                        const modal = bootstrap.Modal.getInstance(modalElement);
                        modal.hide();
                        
                        // Remove the exam row from the table
                        $(`tr[data-exam-id="${itemId}"]`).fadeOut();
                        $(`#questionContainer-${itemId}`).fadeOut();
                        
                        // Reload after a delay
                        setTimeout(function() {
                            location.reload();
                        }, 1500);
                    } else {
                        showAlert(response.message || 'Error deleting exam.', 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error deleting exam:");
                    console.error("Status:", status);
                    console.error("Error:", error);
                    console.error("Response:", xhr.responseText);
                    showAlert('Error deleting exam: API endpoint may be unavailable', 'danger');
                }
            });
        } else if (itemType === 'question') {
            // Delete question
            const examId = $('#deleteExamId').val();
            
            $.ajax({
                url: 'AdminExamMgServlet',
                type: 'POST',
                data: {
                    action: 'deleteQuestion',
                    questionId: itemId,
                    examId: examId
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        showAlert('Question deleted successfully!', 'success');
                        
                        // Close the modal
                        const modalElement = document.getElementById('deleteConfirmModal');
                        const modal = bootstrap.Modal.getInstance(modalElement);
                        modal.hide();
                        
                        // Remove the question item
                        $(`.question-list-item:has(.delete-question-btn[data-question-id="${itemId}"])`).fadeOut();
                        
                        // Update question count in the table
                        const questionCountCell = $(`tr[data-exam-id="${examId}"] td:nth-child(6)`);
                        const currentCount = parseInt(questionCountCell.text());
                        questionCountCell.text(currentCount - 1);
                        
                        // Reload after a delay
                        setTimeout(function() {
                            location.reload();
                        }, 1500);
                    } else {
                        showAlert(response.message || 'Error deleting question.', 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error deleting question:");
                    console.error("Status:", status);
                    console.error("Error:", error);
                    console.error("Response:", xhr.responseText);
                    showAlert('Error deleting question: API endpoint may be unavailable', 'danger');
                }
            });
        }
    });
});

// Initialize Summernote editor
function initSummernote() {
    if ($.fn.summernote && $('#correctAnswer').length) {
        $('#correctAnswer').summernote({
            height: 150,
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'italic', 'underline', 'clear']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['table', ['table']],
                ['insert', ['link']],
                ['view', ['fullscreen', 'codeview', 'help']]
            ],
            placeholder: 'Enter the model answer or grading criteria here...'
        });
    }
}

// Helper function to add empty option
function addEmptyOption(letter, isChecked) {
    const html = `
        <div class="d-flex align-items-center mb-2 option-item">
            <span class="me-2">${letter}.</span>
            <div class="input-group">
                <input type="text" class="form-control" placeholder="Enter option">
                <div class="input-group-text">
                    <input class="form-check-input mt-0" type="radio" name="correctOption" ${isChecked ? 'checked' : ''}>
                </div>
                <button type="button" class="btn btn-outline-danger remove-option">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    `;
    
    $('#optionsList').append(html);
    setupRemoveOptionHandlers();
}

// Set up remove option handlers
function setupRemoveOptionHandlers() {
    $('.remove-option').off('click').on('click', function(e) {
        e.preventDefault();
        
        if ($('#optionsList .option-item').length <= 2) {
            showAlert('A multiple choice question must have at least 2 options.', 'warning');
            return;
        }
        
        // Remove this option
        $(this).closest('.option-item').remove();
        
        // Update option letters
        $('#optionsList .option-item').each(function(index) {
            const letter = String.fromCharCode(65 + index);
            $(this).find('span').first().text(letter + '.');
        });
    });
}

// Update question fields based on type
function updateQuestionTypeFields(type) {
    // Hide all option containers first
    $('#optionsContainer, #trueFalseContainer, #shortAnswerContainer').hide();
    
    // Show the appropriate container based on question type
    if (type === 'multiple_choice') {
        $('#optionsContainer').show();
    } else if (type === 'true_false') {
        $('#trueFalseContainer').show();
    } else {
        $('#shortAnswerContainer').show();
        
        // Reinitialize summernote if needed
        if ($.fn.summernote) {
            $('#correctAnswer').summernote({
                height: 150,
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'italic', 'underline', 'clear']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['table', ['table']],
                    ['insert', ['link']],
                    ['view', ['fullscreen', 'codeview', 'help']]
                ],
                placeholder: 'Enter the model answer or grading criteria here...'
            });
        }
    }
}

// Filter exams based on status, course, instructor, and search input
function filterExams() {
    const statusFilter = $('#statusFilter').val();
    const courseFilter = $('#courseFilter').val();
    const instructorFilter = $('#instructorFilter').val();
    const searchText = $('#searchExam').val().toLowerCase();
    
    $('tr[data-exam-id]').each(function() {
        const statusMatch = statusFilter === 'all' || $(this).data('status') === statusFilter;
        const courseMatch = courseFilter === 'all' || $(this).data('course') === courseFilter;
        const instructorMatch = instructorFilter === 'all' || $(this).data('instructor') === instructorFilter;
        
        // Search across all columns
        const rowText = $(this).text().toLowerCase();
        const searchMatch = !searchText || rowText.includes(searchText);
        
        if (statusMatch && courseMatch && instructorMatch && searchMatch) {
            $(this).show();
            // Also show the corresponding question container if it was already visible
            const examId = $(this).data('exam-id');
            const questionContainer = $(`#questionContainer-${examId}`);
            if (questionContainer.is(':visible')) {
                questionContainer.show();
            }
        } else {
            $(this).hide();
            // Always hide the question container
            const examId = $(this).data('exam-id');
            $(`#questionContainer-${examId}`).hide();
        }
    });
    
    // Show "no exams found" message if all rows are hidden
    const visibleRows = $('tr[data-exam-id]:visible').length;
    if (visibleRows === 0) {
        if ($('#noExamsRow').length === 0) {
            $('#examTableBody').append(`
                <tr id="noExamsRow">
                    <td colspan="8" class="text-center py-4">
                        <i class="fas fa-search text-muted mb-3" style="font-size: 3rem;"></i>
                        <p class="mb-0">No exams match your search criteria.</p>
                    </td>
                </tr>
            `);
        } else {
            $('#noExamsRow').show();
        }
    } else {
        $('#noExamsRow').hide();
    }
}

// Show alert message - improved visibility
function showAlert(message, type) {
    $('#statusMessage').removeClass().addClass('alert alert-' + type).text(message).fadeIn();
    
    // Position fixed in viewport
    $('#statusMessage').css({
        'position': 'fixed',
        'top': '20px',
        'right': '20px',
        'z-index': '9999',
        'max-width': '400px'
    });
    
    setTimeout(function() {
        $('#statusMessage').fadeOut();
    }, 3000);
}