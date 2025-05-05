/**
 * View My Exams JavaScript
 * Handles all functionality for the exam viewing and management
 */

// Document ready
$(document).ready(function() {
    console.log("Document ready. Initializing viewMyExams.js");
    
    // Current date and user constants
    const CURRENT_DATETIME = "2025-03-24 16:06:51";
    const CURRENT_USER_ID = "IT24102083";
    
    // Update the displayed date and time
    $('#currentDateTimeSpan').text(CURRENT_DATETIME);
    
    // Initialize Summernote editor for rich text editing
    initSummernote();
    
    // Toggle sidebar
    $('#menu-toggle').click(function() {
        $('#sidebar').toggleClass('sidebar-collapsed');
        $('#main-content').toggleClass('main-content-expanded');
        $('#logo').toggleClass('hiddenlogo');
    });
    
    // Filter and search functionality
    $('#statusFilter, #courseFilter').change(filterExams);
    $('#searchExam').keyup(filterExams);
    
    // View questions toggle
    $('.view-questions-btn').click(function() {
        console.log("View questions button clicked");
        const examId = $(this).data('exam-id');
        console.log("Toggling questions for exam:", examId);
        $(`#questionList-${examId}`).slideToggle();
    });
    
    // Add Question button (new functionality)
    $('.add-question-btn').click(function() {
        console.log("Add question button clicked");
        const examId = $(this).data('exam-id');
        const examCard = $(this).closest('.exam-card');
        const courseId = examCard.data('course');
        
        console.log("Adding question to exam:", examId, "Course:", courseId);
        
        // Reset the form
        $('#addQuestionForm').trigger('reset');
        
        // Set default values
        $('#addQuestionExamId').val(examId);
        $('#addQuestionType').val('multiple_choice');
        $('#addQuestionMarks').val(5);
        $('#addQuestionDifficulty').val(2);
        
        // Clear previous options and add empty default options
        $('#addOptionsList').empty();
        
        // Add two empty options
        addEmptyOption('A', true);  // First option selected by default
        addEmptyOption('B', false);
        
        // Setup the options container
        $('#addOptionsContainer').show();
        $('#addTrueFalseContainer').hide();
        $('#addShortAnswerContainer').hide();
        
        // Initialize the Summernote editor if needed
        if ($.fn.summernote) {
            $('#addCorrectAnswer').summernote({
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
            $('#addCorrectAnswer').summernote('code', '');
        }
        
        // Setup option removal handlers for add question
        setupAddQuestionRemoveButtons();
        
        // Show the modal
        const addModal = new bootstrap.Modal(document.getElementById('addQuestionModal'));
        addModal.show();
    });
    
    // Helper function to add an empty option with a given letter
    function addEmptyOption(letter, isChecked) {
        const html = `
            <div class="d-flex align-items-center mb-2 add-option-item">
                <span class="me-2">${letter}.</span>
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="Enter option">
                    <div class="input-group-text">
                        <input class="form-check-input mt-0" type="radio" name="addCorrectOption" ${isChecked ? 'checked' : ''}>
                    </div>
                    <button type="button" class="btn btn-outline-danger remove-add-option">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        `;
        
        $('#addOptionsList').append(html);
    }
    
    // Question type change for add question
    $('#addQuestionType').change(function() {
        const type = $(this).val();
        console.log("Add question type changed to:", type);
        
        // Hide all option containers first
        $('#addOptionsContainer, #addTrueFalseContainer, #addShortAnswerContainer').hide();
        
        // Show the appropriate container based on question type
        if (type === 'multiple_choice') {
            $('#addOptionsContainer').show();
        } else if (type === 'true_false') {
            $('#addTrueFalseContainer').show();
        } else {
            $('#addShortAnswerContainer').show();
            
            // Reinitialize summernote if needed
            if ($.fn.summernote) {
                $('#addCorrectAnswer').summernote({
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
    });
    
    // Add new option for add question form
    $('#addNewOption').click(function(e) {
        e.preventDefault();
        console.log("Add new option button clicked");
        
        const optionCount = $('#addOptionsList .add-option-item').length;
        const optionLetter = String.fromCharCode(65 + optionCount); // A, B, C, ...
        
        const html = `
            <div class="d-flex align-items-center mb-2 add-option-item">
                <span class="me-2">${optionLetter}.</span>
                <div class="input-group">
                    <input type="text" class="form-control" placeholder="Enter option">
                    <div class="input-group-text">
                        <input class="form-check-input mt-0" type="radio" name="addCorrectOption">
                    </div>
                    <button type="button" class="btn btn-outline-danger remove-add-option">
                        <i class="fas fa-times"></i>
                    </button>
                </div>
            </div>
        `;
        
        $('#addOptionsList').append(html);
        
        // Setup remove handlers for the new button
        setupAddQuestionRemoveButtons();
    });
    
    // Setup the remove option buttons for add question form
    function setupAddQuestionRemoveButtons() {
        // First, unbind any existing handlers to avoid duplicates
        $('.remove-add-option').off('click');
        
        // Now add the new handlers directly to each button
        $('.remove-add-option').on('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            console.log("Remove add option button clicked");
            
            if ($('#addOptionsList .add-option-item').length <= 2) {
                showAlert('A multiple choice question must have at least 2 options.', 'warning');
                return;
            }
            
            // Remove this option
            $(this).closest('.add-option-item').remove();
            
            // Update option letters for remaining options
            $('#addOptionsList .add-option-item').each(function(index) {
                const letter = String.fromCharCode(65 + index);
                $(this).find('span').first().text(letter + '.');
            });
        });
    }
    
    // Save new question
    $('#saveNewQuestion').click(function() {
        console.log("Save new question button clicked");
        
        // Get form data
        const examId = $('#addQuestionExamId').val();
        const questionText = $('#addQuestionText').val();
        const questionType = $('#addQuestionType').val();
        const marks = $('#addQuestionMarks').val();
        const difficultyLevel = $('#addQuestionDifficulty').val();
        
        // Validate form
        if (!questionText || !marks) {
            showAlert('Please fill in all required fields.', 'danger');
            return;
        }
        
        // Generate a new unique question ID
        const questionId = 'q' + Date.now().toString();
        
        // Prepare data object
        const questionData = {
            questionId: questionId,
            questionText: questionText,
            examId: examId,
            courseId: $(`[data-exam-id='${examId}']`).closest('.exam-card').data('course'),
            questionType: questionType,
            difficultyLevel: parseInt(difficultyLevel),
            points: parseInt(marks),
            createdBy: CURRENT_USER_ID,
            createdAt: CURRENT_DATETIME,
            modifiedAt: CURRENT_DATETIME,
            active: true
        };
        
        // Additional data based on question type
        if (questionType === 'multiple_choice') {
            const options = [];
            let correctAnswerLetter = null;
            
            $('#addOptionsList .add-option-item').each(function(index) {
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
            const isTrue = $('input[name="addTrueFalseOption"]:checked').val() === 'true';
            questionData.correctAnswer = isTrue ? "True" : "False";
            questionData.options = ["True", "False"];
        } else {
            // For essay or short answer, get the rich text content
            questionData.correctAnswer = $('#addCorrectAnswer').summernote('code') || "";
        }
        
        console.log("Sending new question data:", questionData);
        
        // Send data to the server
        $.ajax({
            url: 'ViewExamsServlet',
            type: 'POST',
            data: {
                action: 'addQuestion',
                questionData: JSON.stringify(questionData),
                examId: examId
            },
            dataType: 'json',
            success: function(response) {
                console.log("Add question response:", response);
                if (response.success) {
                    // Show success message
                    showAlert(response.message || 'Question added successfully!', 'success');
                    
                    // Close the modal
                    const modalElement = document.getElementById('addQuestionModal');
                    const modal = bootstrap.Modal.getInstance(modalElement);
                    modal.hide();
                    
                    // Reload the page after a delay
                    setTimeout(function() {
                        location.reload();
                    }, 1500);
                } else {
                    showAlert(response.message || 'Error adding question.', 'danger');
                }
            },
            error: function(xhr, status, error) {
                console.error("Error adding question:", error);
                showAlert('Error adding question: ' + error, 'danger');
            }
        });
    });
    
    // Edit exam
    $('.edit-exam-btn').click(function() {
        console.log("Edit exam button clicked");
        const examId = $(this).data('exam-id');
        console.log("Editing exam:", examId);
        
        // Find the exam card
        const examCard = $(this).closest('.exam-card');
        
        // Get basic data from the card
        const title = examCard.find('.exam-title').text();
        const courseId = examCard.data('course');
        const description = examCard.find('.exam-description').text();
        
        // Get exam stats
        const durationText = examCard.find('.stat-item:has(i.fa-clock) span').text();
        const duration = parseInt(durationText) || 60;
        
        const marksText = examCard.find('.stat-item:has(i.fa-check-circle) span').text();
        const totalMarks = parseInt(marksText) || 100;
        const passingMarks = Math.floor(totalMarks * 0.4); // default to 40%
        
        const dateText = examCard.find('.stat-item:has(i.fa-calendar-alt) span').text();
        
        // Get status from badge
        const statusBadge = examCard.find('.status-badge');
        let status = "draft";
        if (statusBadge.hasClass('status-published')) status = "published";
        else if (statusBadge.hasClass('status-pending')) status = "pending";
        else if (statusBadge.hasClass('status-closed')) status = "closed";
        
        // Populate the edit form with exam data
        $('#editExamId').val(examId);
        $('#editExamTitle').val(title);
        $('#editCourseSelect').val(courseId);
        $('#editExamDescription').val(description);
        
        // Try to parse date and time from the exam card
        try {
            const startDate = dateText || "2025-04-15";
            $('#editExamDate').val(startDate);
            $('#editStartTime').val("10:00");
        } catch (e) {
            console.error("Error parsing date:", e);
            $('#editExamDate').val("2025-04-15");
            $('#editStartTime').val("10:00");
        }
        
        $('#editDuration').val(duration);
        $('#editTotalMarks').val(totalMarks);
        $('#editPassingMarks').val(passingMarks);
        $('#editExamStatus').val(status);
        
        // Show the modal
        const editModal = new bootstrap.Modal(document.getElementById('editExamModal'));
        editModal.show();
    });
    
    // Save exam changes
    $('#saveExamChanges').click(function() {
        console.log("Save exam changes button clicked");
        
        // Get form data
        const examId = $('#editExamId').val();
        const examTitle = $('#editExamTitle').val();
        const course = $('#editCourseSelect').val();
        const description = $('#editExamDescription').val();
        const examDate = $('#editExamDate').val();
        const startTime = $('#editStartTime').val();
        const duration = $('#editDuration').val();
        const totalMarks = $('#editTotalMarks').val();
        const passingMarks = $('#editPassingMarks').val();
        const status = $('#editExamStatus').val();
        
        // Validate form
        if (!examTitle || !course || !examDate || !startTime || !duration || !totalMarks || !passingMarks) {
            showAlert('Please fill in all required fields.', 'danger');
            return;
        }
        
        // Prepare data for the server
        const examData = {
            examId: examId,
            examName: examTitle,
            courseId: course,
            description: description,
            duration: parseInt(duration),
            totalMarks: parseInt(totalMarks),
            passingMarks: parseInt(passingMarks),
            status: status,
            startDate: examDate + 'T' + startTime + ':00Z'
        };
        
        console.log("Sending exam data:", examData);
        
        // Send data to the server
        $.ajax({
            url: 'ViewExamsServlet',
            type: 'POST',
            data: {
                action: 'updateExam',
                examData: JSON.stringify(examData)
            },
            dataType: 'json',
            success: function(response) {
                console.log("Update exam response:", response);
                if (response.success) {
                    // Show success message
                    showAlert(response.message || 'Exam updated successfully!', 'success');
                    
                    // Close the modal
                    const modalElement = document.getElementById('editExamModal');
                    const modal = bootstrap.Modal.getInstance(modalElement);
                    modal.hide();
                    
                    // Reload the page after a delay
                    setTimeout(function() {
                        location.reload();
                    }, 1500);
                } else {
                    showAlert(response.message || 'Error updating exam.', 'danger');
                }
            },
            error: function(xhr, status, error) {
                console.error("Error updating exam:", error);
                showAlert('Error updating exam: ' + error, 'danger');
            }
        });
    });
    
    // Edit question
    $('.edit-question-btn').click(function() {
        console.log("Edit question button clicked");
        const questionId = $(this).data('question-id');
        console.log("Editing question:", questionId);
        
        // Get the question item and exam ID
        const questionItem = $(this).closest('.question-list-item');
        const examId = $(this).closest('.exam-card').find('.view-questions-btn').data('exam-id');
        
        // Fetch the full question data from the server
        $.ajax({
            url: 'ViewExamsServlet',
            type: 'GET',
            data: {
                action: 'getQuestionById',
                questionId: questionId
            },
            dataType: 'json',
            success: function(question) {
                console.log("Loaded question data:", question);
                
                // Store original question format for later use
                $('#originalQuestionFormat').remove();
                $('<input>').attr({
                    type: 'hidden',
                    id: 'originalQuestionFormat',
                    value: JSON.stringify(question)
                }).appendTo('#editQuestionForm');
                
                // Get question data
                const id = question.questionId || question.id;
                const text = question.questionText || question.text || '';
                const type = question.questionType || question.type || 'multiple_choice';
                const marks = question.points || question.marks || 5;
                
                // Set question data in the form
                $('#editQuestionId').val(id);
                $('#editQuestionExamId').val(question.examId || examId);
                $('#editQuestionText').val(text);
                $('#editQuestionType').val(type);
                $('#editQuestionMarks').val(marks);
                
                // Show appropriate fields based on question type
                updateQuestionTypeFields(type);
                
                // Handle different question types
                if (type === 'multiple_choice') {
                    // Clear previous options
                    $('#editOptionsList').empty();
                    
                    // Add options
                    if (question.options && question.options.length > 0) {
                        question.options.forEach((option, index) => {
                            addEditOption(option);
                            
                            // Set correct option
                            let isCorrect = false;
                            
                            if (question.correctAnswer) {
                                // If using correctAnswer letter format (A, B, C)
                                const correctLetter = question.correctAnswer;
                                isCorrect = String.fromCharCode(65 + index) === correctLetter;
                            } else if (question.correctOptionIndex !== undefined) {
                                // For backward compatibility with correctOptionIndex
                                isCorrect = question.correctOptionIndex === index;
                            }
                            
                            if (isCorrect) {
                                $('#editOptionsList .edit-option-item:last')
                                    .find('input[type="radio"]')
                                    .prop('checked', true);
                            }
                        });
                    } else {
                        // Default options if none exist
                        addEditOptionEmpty('A', true);
                        addEditOptionEmpty('B', false);
                    }
                } else if (type === 'true_false') {
                    // Set the true/false radio button
                    const isTrue = question.correctAnswer === 'True';
                    $('#editOptionTrue').prop('checked', isTrue);
                    $('#editOptionFalse').prop('checked', !isTrue);
                } else {
                    // For short answer/essay
                    $('#editCorrectAnswer').summernote('code', question.correctAnswer || '');
                }
                
                // Show the modal
                const editModal = new bootstrap.Modal(document.getElementById('editQuestionModal'));
                editModal.show();
            },
            error: function(xhr, status, error) {
                console.error("Error fetching question:", error);
                showAlert('Error loading question: ' + error, 'danger');
                
                // Fall back to loading from DOM (less accurate)
                loadQuestionFromDom(questionId, questionItem, examId);
            }
        });
    });
    
    // Fallback function to load question data from DOM
    function loadQuestionFromDom(questionId, questionItem, examId) {
        // Get basic info from the DOM
        const questionTextElement = questionItem.find('.question-text');
        let questionText = questionTextElement.text() || '';
        
        // Extract the text after the question number (e.g., "1. What is...")
        const dotIndex = questionText.indexOf('.');
        if (dotIndex !== -1) {
            questionText = questionText.substring(dotIndex + 1).trim();
        }
        
        const metaElements = questionItem.find('.question-meta div');
        let questionType = 'multiple_choice';
        let marks = 5;
        
        // Parse meta information
        metaElements.each(function() {
            const text = $(this).text();
            if (text.startsWith('Type:')) {
                const typeParts = text.split(':');
                if (typeParts.length > 1) {
                    const typeText = typeParts[1].trim().toLowerCase();
                    questionType = typeText.replace(' ', '_');
                }
            } else if (text.startsWith('Marks:')) {
                const marksParts = text.split(':');
                if (marksParts.length > 1) {
                    marks = parseInt(marksParts[1].trim()) || 5;
                }
            }
        });
        
        // Set values in the modal
        $('#editQuestionId').val(questionId);
        $('#editQuestionExamId').val(examId);
        $('#editQuestionText').val(questionText);
        $('#editQuestionType').val(questionType);
        $('#editQuestionMarks').val(marks);
        
        // Update form fields based on question type
        updateQuestionTypeFields(questionType);
        
        // For multiple choice, add sample options
        if (questionType === 'multiple_choice') {
            $('#editOptionsList').empty();
            addEditOptionEmpty('A', true);
            addEditOptionEmpty('B', false);
            addEditOptionEmpty('C', false);
            addEditOptionEmpty('D', false);
        } else if (questionType === 'true_false') {
            $('#editOptionTrue').prop('checked', true);
        } else {
            $('#editCorrectAnswer').summernote('code', '');
        }
        
        // Show the modal
        const editModal = new bootstrap.Modal(document.getElementById('editQuestionModal'));
        editModal.show();
    }
    
    // Question type change event
    $('#editQuestionType').change(function() {
        const type = $(this).val();
        console.log("Question type changed to:", type);
        updateQuestionTypeFields(type);
    });
    
    // Add option button for edit question form
    $('#addEditOption').click(function(e) {
        e.preventDefault();
        console.log("Add option button clicked");
        
        const optionCount = $('#editOptionsList .edit-option-item').length;
        const optionLetter = String.fromCharCode(65 + optionCount); // A, B, C, ...
        
        addEditOptionEmpty(optionLetter, false);
    });
    
    // Save question changes
    $('#saveQuestionChanges').click(function() {
        console.log("Save question changes button clicked");
        
        // Get form data
        const questionId = $('#editQuestionId').val();
        const examId = $('#editQuestionExamId').val();
        const questionText = $('#editQuestionText').val();
        const questionType = $('#editQuestionType').val();
        const marks = $('#editQuestionMarks').val();
        
        // Validate form
        if (!questionText || !marks) {
            showAlert('Please fill in all required fields.', 'danger');
            return;
        }
        
        // Get original question format (if available)
        let originalFormat = {};
        try {
            if ($('#originalQuestionFormat').length) {
                originalFormat = JSON.parse($('#originalQuestionFormat').val());
            }
        } catch (e) {
            console.error("Error parsing original question format:", e);
        }
        
        // Prepare data object with proper format
        const questionData = {
            questionId: questionId,
            questionText: questionText,
            examId: examId,
            questionType: questionType,
            points: parseInt(marks),
            difficultyLevel: originalFormat.difficultyLevel || 2,
            createdBy: CURRENT_USER_ID,
            modifiedAt: CURRENT_DATETIME,
            active: true
        };
        
        // Additional data based on question type
        if (questionType === 'multiple_choice') {
            const options = [];
            let correctAnswerLetter = null;
            
            $('#editOptionsList .edit-option-item').each(function(index) {
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
            const isTrue = $('input[name="editTrueFalseOption"]:checked').val() === 'true';
            questionData.correctAnswer = isTrue ? "True" : "False";
            questionData.options = ["True", "False"];
        } else {
            // For essay or short answer, get the rich text content
            questionData.correctAnswer = $('#editCorrectAnswer').summernote('code') || "";
        }
        
        console.log("Sending question data:", questionData);
        
        // Send data to the server
        $.ajax({
            url: 'ViewExamsServlet',
            type: 'POST',
            data: {
                action: 'updateQuestion',
                questionData: JSON.stringify(questionData)
            },
            dataType: 'json',
            success: function(response) {
                console.log("Update question response:", response);
                if (response.success) {
                    // Show success message
                    showAlert(response.message || 'Question updated successfully!', 'success');
                    
                    // Close the modal
                    const modalElement = document.getElementById('editQuestionModal');
                    const modal = bootstrap.Modal.getInstance(modalElement);
                    modal.hide();
                    
                    // Reload the page after a delay
                    setTimeout(function() {
                        location.reload();
                    }, 1500);
                } else {
                    showAlert(response.message || 'Error updating question.', 'danger');
                }
            },
            error: function(xhr, status, error) {
                console.error("Error updating question:", error);
                showAlert('Error updating question: ' + error, 'danger');
            }
        });
    });
    
    // Delete exam button
    $('.delete-exam-btn').click(function() {
        console.log("Delete exam button clicked");
        const examId = $(this).data('exam-id');
        const examTitle = $(this).closest('.exam-card').find('.exam-title').text();
        
        console.log("Deleting exam:", examId, examTitle);
        
        $('#deleteItemId').val(examId);
        $('#deleteItemType').val('exam');
        $('#deleteItemName').text(examTitle);
        
        // Show the modal
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
        deleteModal.show();
    });
    
    // Delete question button
    $('.delete-question-btn').click(function() {
        console.log("Delete question button clicked");
        const questionId = $(this).data('question-id');
        const questionItem = $(this).closest('.question-list-item');
        const questionText = questionItem.find('.question-text').text();
        const examId = $(this).closest('.exam-card').find('.view-questions-btn').data('exam-id');
        
        console.log("Deleting question:", questionId, "from exam:", examId);
        
        $('#deleteItemId').val(questionId);
        $('#deleteItemType').val('question');
        $('#deleteItemName').text(questionText);
        $('#deleteExamId').val(examId); // Store exam ID for question deletion
        
        // Show the modal
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
        deleteModal.show();
    });
    
    // Confirm delete
    $('#confirmDelete').click(function() {
        console.log("Confirm delete button clicked");
        const itemId = $('#deleteItemId').val();
        const itemType = $('#deleteItemType').val();
        
        console.log("Confirming deletion of", itemType, "with ID:", itemId);
        
        if (itemType === 'exam') {
            // Delete exam
            $.ajax({
                url: 'ViewExamsServlet',
                type: 'POST',
                data: {
                    action: 'deleteExam',
                    examId: itemId
                },
                dataType: 'json',
                success: function(response) {
                    console.log("Delete exam response:", response);
                    if (response.success) {
                        // Visual delete (remove from DOM)
                        $(`.view-questions-btn[data-exam-id='${itemId}']`).closest('.exam-card').fadeOut();
                        showAlert('Exam deleted successfully!', 'success');
                        
                        // Close the modal
                        const modalElement = document.getElementById('deleteConfirmModal');
                        const modal = bootstrap.Modal.getInstance(modalElement);
                        modal.hide();
                        
                        // Check if we need to show empty state
                        setTimeout(checkEmptyState, 500);
                    } else {
                        showAlert(response.message || 'Error deleting exam.', 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error deleting exam:", error);
                    showAlert('Error deleting exam: ' + error, 'danger');
                }
            });
        } else if (itemType === 'question') {
            // Delete question
            const examId = $('#deleteExamId').val();
            
            $.ajax({
                url: 'ViewExamsServlet',
                type: 'POST',
                data: {
                    action: 'deleteQuestion',
                    questionId: itemId,
                    examId: examId
                },
                dataType: 'json',
                success: function(response) {
                    console.log("Delete question response:", response);
                    if (response.success) {
                        // Visual delete (remove from DOM)
                        $(`.delete-question-btn[data-question-id='${itemId}']`).closest('.question-list-item').fadeOut();
                        showAlert('Question deleted successfully!', 'success');
                        
                        // Close the modal
                        const modalElement = document.getElementById('deleteConfirmModal');
                        const modal = bootstrap.Modal.getInstance(modalElement);
                        modal.hide();
                    } else {
                        showAlert(response.message || 'Error deleting question.', 'danger');
                    }
                },
                error: function(xhr, status, error) {
                    console.error("Error deleting question:", error);
                    showAlert('Error deleting question: ' + error, 'danger');
                }
            });
        }
    });
    
    // Add Delete Exam ID input to delete confirmation modal if it doesn't exist
    if ($('#deleteExamId').length === 0) {
        $('#deleteItemType').after('<input type="hidden" id="deleteExamId">');
    }
    
    // Initial check for empty state
    checkEmptyState();
    
    // Handle option removal when modal is loaded/shown
    $('#editQuestionModal').on('shown.bs.modal', function() {
        // Rebind the remove option functionality
        console.log("Modal shown, rebinding remove option functionality");
        setupRemoveOptionHandlers();
    });
    
    // Handle option removal when add question modal is loaded/shown
    $('#addQuestionModal').on('shown.bs.modal', function() {
        // Rebind the remove option functionality
        console.log("Add question modal shown, ensuring remove option functionality");
        setupAddQuestionRemoveButtons();
    });
});

// Setup the remove option handlers correctly
function setupRemoveOptionHandlers() {
    console.log("Setting up remove option handlers");
    
    // First, unbind any existing handlers to avoid duplicates
    $('.remove-edit-option').off('click');
    
    // Now add the new handlers directly to each button
    $('.remove-edit-option').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        console.log("Remove option button clicked");
        
        const parentList = $('#editOptionsList');
        
        if (parentList.find('.edit-option-item').length <= 2) {
            showAlert('A multiple choice question must have at least 2 options.', 'warning');
            return;
        }
        
        // Remove this option
        $(this).closest('.edit-option-item').remove();
        
        // Update option letters for remaining options
        parentList.find('.edit-option-item').each(function(index) {
            const letter = String.fromCharCode(65 + index);
            $(this).find('span').first().text(letter + '.');
        });
    });
}

// Initialize Summernote editor
function initSummernote() {
    // Initialize summernote if the element exists and the library is loaded
    if ($.fn.summernote && $('#editCorrectAnswer').length) {
        $('#editCorrectAnswer').summernote({
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
    
    // Also initialize for the add question form if it exists
    if ($.fn.summernote && $('#addCorrectAnswer').length) {
        $('#addCorrectAnswer').summernote({
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

// Filter exams based on status, course, and search input
function filterExams() {
    const statusFilter = $('#statusFilter').val();
    const courseFilter = $('#courseFilter').val();
    const searchText = $('#searchExam').val().toLowerCase();
    
    console.log("Filtering exams - Status:", statusFilter, "Course:", courseFilter, "Search:", searchText);
    
    let visibleCount = 0;
    
    $('.exam-card').each(function() {
        const statusMatch = statusFilter === 'all' || $(this).data('status') === statusFilter;
        const courseMatch = courseFilter === 'all' || $(this).data('course') === courseFilter;
        
        const examTitle = $(this).find('.exam-title').text().toLowerCase();
        const examCourse = $(this).find('.exam-course').text().toLowerCase();
        const examDesc = $(this).find('.exam-description').text().toLowerCase();
        
        const searchMatch = !searchText || 
                         examTitle.includes(searchText) || 
                         examCourse.includes(searchText) || 
                         examDesc.includes(searchText);
        
        if (statusMatch && courseMatch && searchMatch) {
            $(this).show();
            visibleCount++;
        } else {
            $(this).hide();
        }
    });
    
    console.log("Visible exams after filtering:", visibleCount);
    
    // Show/hide empty state based on filter results
    if (visibleCount === 0) {
        $('#emptyState').show();
    } else {
        $('#emptyState').hide();
    }
}

// Check if we need to show the empty state
function checkEmptyState() {
    const visibleExams = $('.exam-card:visible').length;
    console.log("Checking empty state. Visible exams:", visibleExams);
    
    if (visibleExams === 0) {
        $('#emptyState').show();
    } else {
        $('#emptyState').hide();
    }
}

// Show alert message
function showAlert(message, type) {
    console.log("Showing alert:", message, "Type:", type);
    
    $('#statusMessage').removeClass().addClass('alert alert-' + type).text(message).fadeIn();
    setTimeout(function() {
        $('#statusMessage').fadeOut();
    }, 3000);
}

// Update question fields based on type
function updateQuestionTypeFields(type) {
    console.log("Updating question fields for type:", type);
    
    // Hide all option containers first
    $('#editOptionsContainer, #editTrueFalseContainer, #editShortAnswerContainer').hide();
    
    // Show the appropriate container based on question type
    if (type === 'multiple_choice') {
        $('#editOptionsContainer').show();
    } else if (type === 'true_false') {
        $('#editTrueFalseContainer').show();
    } else {
        $('#editShortAnswerContainer').show();
        
        // Reinitialize summernote if we just switched to this type
        if ($.fn.summernote) {
            $('#editCorrectAnswer').summernote({
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

// Add a new option to the edit question form with text
function addEditOption(text = '') {
    const optionCount = $('#editOptionsList .edit-option-item').length;
    const optionLetter = String.fromCharCode(65 + optionCount); // A, B, C, ...
    
    console.log("Adding option:", optionLetter, "with text:", text);
    
    const html = `
        <div class="d-flex align-items-center mb-2 edit-option-item">
            <span class="me-2">${optionLetter}.</span>
            <div class="input-group">
                <input type="text" class="form-control" placeholder="Enter option" value="${text}">
                <div class="input-group-text">
                    <input class="form-check-input mt-0" type="radio" name="editCorrectOption">
                </div>
                <button type="button" class="btn btn-outline-danger remove-edit-option">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    `;
    
    $('#editOptionsList').append(html);
    
    // Directly attach the handler to the newly added button
    $('#editOptionsList .edit-option-item:last-child .remove-edit-option').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        console.log("Remove option button clicked (direct handler)");
        
        if ($('#editOptionsList .edit-option-item').length <= 2) {
            showAlert('A multiple choice question must have at least 2 options.', 'warning');
            return;
        }
        
        // Remove this option
        $(this).closest('.edit-option-item').remove();
        
        // Update option letters for remaining options
        $('#editOptionsList .edit-option-item').each(function(index) {
            const letter = String.fromCharCode(65 + index);
            $(this).find('span').first().text(letter + '.');
        });
    });
}

// Add a new empty option to the edit question form
function addEditOptionEmpty(letter, isChecked) {
    console.log("Adding empty option:", letter);
    
    const html = `
        <div class="d-flex align-items-center mb-2 edit-option-item">
            <span class="me-2">${letter}.</span>
            <div class="input-group">
                <input type="text" class="form-control" placeholder="Enter option">
                <div class="input-group-text">
                    <input class="form-check-input mt-0" type="radio" name="editCorrectOption" ${isChecked ? 'checked' : ''}>
                </div>
                <button type="button" class="btn btn-outline-danger remove-edit-option">
                    <i class="fas fa-times"></i>
                </button>
            </div>
        </div>
    `;
    
    $('#editOptionsList').append(html);
    
    // Directly attach the handler to the newly added button
    $('#editOptionsList .edit-option-item:last-child .remove-edit-option').on('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        
        console.log("Remove option button clicked (direct handler)");
        
        if ($('#editOptionsList .edit-option-item').length <= 2) {
            showAlert('A multiple choice question must have at least 2 options.', 'warning');
            return;
        }
        
        // Remove this option
        $(this).closest('.edit-option-item').remove();
        
        // Update option letters for remaining options
        $('#editOptionsList .edit-option-item').each(function(index) {
            const letter = String.fromCharCode(65 + index);
            $(this).find('span').first().text(letter + '.');
        });
    });
}