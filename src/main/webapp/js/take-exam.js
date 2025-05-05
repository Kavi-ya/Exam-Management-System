/**
 * JavaScript for the Exam Taking Page
 * Handles timer, navigation, answer saving, and submission
 * Enhanced with stronger linked list implementation for tracking answers
 */

// Debug mode - set to true to see console logs
const DEBUG = true;

// Global state variables
let currentQuestion = 1;
let totalQuestions = 0; // Will be determined based on DOM
let answeredQuestions = {};
let flaggedQuestions = {};
let timeRemaining = 7200; // Default 2 hours in seconds
let examId = ""; // Will be loaded from the DOM
let ajaxSaveEnabled = true; // Whether to save answers via AJAX
const CURRENT_USER_ID = "IT24102083"; // Current user's ID
const CURRENT_DATE_TIME = "2025-05-04 09:07:53"; // Updated current date and time

// ---------- ENHANCED LINKED LIST IMPLEMENTATION ----------
// Define the linked list structure
class AnswerNode {
    constructor(questionId, answer) {
        this.questionId = questionId;
        this.answer = answer;
        this.isCorrect = false; // Will be determined on server
        this.next = null;
        this.prev = null;
        this.timestamp = new Date().toISOString();
    }
}

class AnswerLinkedList {
    constructor() {
        this.head = null;
        this.tail = null;
        this.size = 0;
        this.map = {}; // For O(1) lookups by questionId
    }
    
    // Add or update an answer in the linked list
    addOrUpdate(questionId, answer) {
        // If questionId already exists, update it
        if (this.map[questionId]) {
            const node = this.map[questionId];
            node.answer = answer;
            node.timestamp = new Date().toISOString();
            return;
        }
        
        // Create new node
        const newNode = new AnswerNode(questionId, answer);
        
        // If list is empty, create first node
        if (!this.head) {
            this.head = newNode;
            this.tail = newNode;
        } else {
            // Add to the end
            this.tail.next = newNode;
            newNode.prev = this.tail;
            this.tail = newNode;
        }
        
        // Add to map for O(1) lookups
        this.map[questionId] = newNode;
        this.size++;
        
        if (DEBUG) console.log(`Added answer for ${questionId} to linked list. Size: ${this.size}`);
    }
    
    // Get an answer by questionId (O(1) lookup)
    getAnswer(questionId) {
        const node = this.map[questionId];
        return node ? node.answer : null;
    }
    
    // Remove an answer from the linked list
    remove(questionId) {
        const node = this.map[questionId];
        if (!node) return false;
        
        // Handle pointers
        if (node.prev) node.prev.next = node.next;
        else this.head = node.next; // Removing head
        
        if (node.next) node.next.prev = node.prev;
        else this.tail = node.prev; // Removing tail
        
        // Remove from map
        delete this.map[questionId];
        this.size--;
        
        return true;
    }
    
    // Print the linked list for debugging
    printList() {
        let current = this.head;
        let count = 0;
        const result = [];
        
        while (current !== null && count < 10) { // Print up to 10 nodes
            result.push(`[${count}] ${current.questionId}: ${current.answer}`);
            current = current.next;
            count++;
        }
        
        console.log("Linked List Contents:", result.join(' -> '));
        console.log("Total Size:", this.size);
    }
    
    // Convert the linked list to a JSON object for submission
    toJSON() {
        const result = {};
        let current = this.head;
        
        while (current) {
            result[current.questionId] = current.answer;
            current = current.next;
        }
        
        return result;
    }
}

// Initialize global linked list
let linkedListAnswers = new AnswerLinkedList();

// ---------- INITIALIZATION FUNCTIONS ----------
// Initialize when document is ready
document.addEventListener('DOMContentLoaded', function() {
    console.log("Initializing take-exam.js with enhanced linked list");
    
    // Check if we're on the exam taking page
    if (document.getElementById('examTakingSection')) {
        
        // Get exam ID from hidden field
        const examIdField = document.getElementById('examIdField');
        if (examIdField) {
            examId = examIdField.value;
            if (DEBUG) console.log("Loaded exam ID: " + examId);
        }
        
        // Count total questions from DOM
        totalQuestions = document.querySelectorAll('.question-card').length;
        if (DEBUG) console.log("Found " + totalQuestions + " questions");
        
        // Get timer data from data attribute
        const timerElement = document.getElementById('timer');
        if (timerElement && timerElement.dataset.timeRemaining) {
            timeRemaining = parseInt(timerElement.dataset.timeRemaining);
            if (DEBUG) console.log("Loaded time remaining: " + timeRemaining + " seconds");
        }
        
        // Update the timer display
        updateTimerDisplay(timeRemaining);
        
        // Start timer updates
        startTimerUpdates();
        
        // Load any previously saved answers
        loadSavedAnswers();
        
        // Set up the data-question-id attribute for each question card that doesn't have it
        document.querySelectorAll('.question-card').forEach((card, index) => {
            if (!card.dataset.questionId) {
                card.dataset.questionId = "Q" + (index + 1);
            }
        });
        
        // Update navigation initially
        updateNavigation();
        
        // Log initial linked list state
        if (DEBUG) {
            console.log("Initial Linked List State:");
            linkedListAnswers.printList();
        }
    }
});

// ---------- TIMER FUNCTIONS ----------
// Start periodic timer updates
function startTimerUpdates() {
    // Update every second
    setInterval(function() {
        if (timeRemaining > 0) {
            timeRemaining--;
            updateTimerDisplay(timeRemaining);
        } else {
            // Time's up - auto submit
            alert("Time's up! Your exam will be submitted automatically.");
            submitExam();
        }
    }, 1000);
}

// Update the timer display
function updateTimerDisplay(secondsRemaining) {
    if (!secondsRemaining || isNaN(secondsRemaining) || secondsRemaining < 0) {
        if (DEBUG) console.log("Invalid time: " + secondsRemaining);
        return;
    }
    
    const hours = Math.floor(secondsRemaining / 3600);
    const minutes = Math.floor((secondsRemaining % 3600) / 60);
    const seconds = secondsRemaining % 60;
    
    const formattedTime = 
        hours.toString().padStart(2, '0') + ':' + 
        minutes.toString().padStart(2, '0') + ':' + 
        seconds.toString().padStart(2, '0');
    
    const timerElement = document.getElementById('timer');
    if (timerElement) {
        timerElement.textContent = formattedTime;
    }
    
    const timeSummaryElement = document.getElementById('timeSummary');
    if (timeSummaryElement) {
        timeSummaryElement.innerHTML = '<strong>' + formattedTime + '</strong> time remaining';
    }
    
    // Add visual warning when time is running low
    if (timerElement) {
        timerElement.classList.remove('timer-danger', 'timer-warning');
        if (secondsRemaining < 300) { // Less than 5 minutes
            timerElement.classList.add('timer-danger');
        } else if (secondsRemaining < 600) { // Less than 10 minutes
            timerElement.classList.add('timer-warning');
        }
    }
}

// ---------- QUESTION NAVIGATION FUNCTIONS ----------
// Select option
function selectOption(element) {
    // Deselect all options in the same question
    const optionsContainer = element.closest('.options-container');
    const allOptions = optionsContainer.querySelectorAll('.option-item');
    allOptions.forEach(option => {
        option.classList.remove('selected');
    });
    
    // Select the clicked option
    element.classList.add('selected');
    
    // Check the radio button
    const radio = element.querySelector('input[type="radio"]');
    radio.checked = true;
    
    // Mark question as answered
    const questionCard = element.closest('.question-card');
    const questionNumber = parseInt(questionCard.querySelector('.question-number').textContent.replace('Question ', ''));
    answeredQuestions[questionNumber] = true;
    
    // Save answer to linked list
    saveAnswerToLinkedList(questionCard);
    
    // Update the navigation
    updateNavigation();
}

// Toggle flag for review
function toggleFlag(button) {
    button.classList.toggle('flagged');
    
    if (button.classList.contains('flagged')) {
        button.innerHTML = '<i class="fas fa-flag"></i> Flagged for review';
    } else {
        button.innerHTML = '<i class="far fa-flag"></i> Flag for review';
    }
    
    // Update flagged questions
    const questionCard = button.closest('.question-card');
    const questionNumber = parseInt(questionCard.querySelector('.question-number').textContent.replace('Question ', ''));
    flaggedQuestions[questionNumber] = button.classList.contains('flagged');
    
    // Update the navigation
    updateNavigation();
}

// Load question
function loadQuestion(questionNumber) {
    // Make sure it's a valid question number
    if (questionNumber < 1 || questionNumber > totalQuestions) {
        console.error("Invalid question number:", questionNumber);
        return;
    }
    
    // Hide all questions
    document.querySelectorAll('.question-card').forEach(card => {
        card.style.display = 'none';
    });
    
    // Show the selected question
    const questionElement = document.getElementById('question' + questionNumber);
    if (questionElement) {
        questionElement.style.display = 'block';
    } else {
        console.error("Question element not found:", 'question' + questionNumber);
        return;
    }
    
    // Update current question
    currentQuestion = questionNumber;
    
    // Update question navigation
    updateNavigation();
}

// Count words in textarea
function countWords(textarea) {
    const text = textarea.value.trim();
    const wordCount = text === '' ? 0 : text.split(/\s+/).length;
    
    // Update word count display
    const wordCountElement = textarea.parentElement.querySelector('.word-count');
    if (wordCountElement) {
        wordCountElement.textContent = wordCount + ' word' + (wordCount == 1 ? '' : 's');
    }
    
    // Mark question as answered if there's text
    if (text.length > 0) {
        const questionCard = textarea.closest('.question-card');
        const questionNumber = parseInt(questionCard.querySelector('.question-number').textContent.replace('Question ', ''));
        answeredQuestions[questionNumber] = true;
        
        // Save answer to linked list
        saveAnswerToLinkedList(questionCard);
    }
    
    // Update navigation
    updateNavigation();
}

// Update navigation state
function updateNavigation() {
    // Update question navigation buttons
    const navItems = document.querySelectorAll('.question-nav .nav-item');
    navItems.forEach((item, index) => {
        const questionNumber = index + 1;
        
        // Remove all status classes
        item.classList.remove('active', 'answered', 'flagged');
        
        // Add appropriate status class
        if (questionNumber === currentQuestion) {
            item.classList.add('active');
        }
        
        if (answeredQuestions[questionNumber]) {
            item.classList.add('answered');
        }
        
        if (flaggedQuestions[questionNumber]) {
            item.classList.add('flagged');
        }
    });
    
    // Update progress bar
    const answeredCount = Object.keys(answeredQuestions).length;
    const progressPercentage = Math.round((answeredCount / totalQuestions) * 100);
    
    const progressBar = document.querySelector('.progress-bar');
    if (progressBar) {
        progressBar.style.width = progressPercentage + '%';
        progressBar.setAttribute('aria-valuenow', progressPercentage);
    }
    
    const progressLabelFirst = document.querySelector('.progress-label span:first-child');
    if (progressLabelFirst) {
        progressLabelFirst.textContent = answeredCount + ' of ' + totalQuestions + ' answered';
    }
    
    const progressLabelLast = document.querySelector('.progress-label span:last-child');
    if (progressLabelLast) {
        progressLabelLast.textContent = progressPercentage + '%';
    }
    
    // Update summary in modal
    const answeredSummary = document.getElementById('answeredSummary');
    if (answeredSummary) {
        answeredSummary.innerHTML = 'Answered <strong>' + answeredCount + ' of ' + totalQuestions + '</strong> questions';
    }
    
    // Update flagged summary
    const flaggedCount = Object.values(flaggedQuestions).filter(Boolean).length;
    const flaggedSummary = document.getElementById('flaggedSummary');
    if (flaggedSummary) {
        flaggedSummary.innerHTML = 'Flagged <strong>' + flaggedCount + '</strong> questions for review';
    }
    
    // Update prev/next button states
    updateNavigationButtons();
}

// Update the previous and next button states
function updateNavigationButtons() {
    // Get current question card
    const questionCard = document.querySelector('.question-card:not([style*="display: none"])');
    if (!questionCard) return;
    
    const questionNumber = parseInt(questionCard.querySelector('.question-number').textContent.replace('Question ', ''));
    
    // Update previous button
    const prevButton = questionCard.querySelector('.btn-prev');
    if (prevButton) {
        if (questionNumber <= 1) {
            prevButton.disabled = true;
        } else {
            prevButton.disabled = false;
        }
    }
    
    // Update next button
    const nextButton = questionCard.querySelector('.btn-next');
    if (nextButton) {
        if (questionNumber >= totalQuestions) {
            nextButton.style.display = 'none';
        } else {
            nextButton.style.display = 'block';
        }
    }
    
    // Show or hide submit button
    const submitButton = questionCard.querySelector('.btn-submit');
    if (submitButton) {
        if (questionNumber < totalQuestions) {
            submitButton.style.display = 'none';
        } else {
            submitButton.style.display = 'block';
        }
    }
}

// ---------- EXAM SUBMISSION AND ANSWER FUNCTIONS ----------
// Load any previously saved answers
function loadSavedAnswers() {
    try {
        const savedAnswersField = document.getElementById('savedAnswersField');
        if (!savedAnswersField) {
            console.error("savedAnswersField not found");
            return;
        }
        
        const savedAnswers = JSON.parse(savedAnswersField.value || "{}");
        if (DEBUG) console.log("Loading saved answers:", savedAnswers);
        
        // For each saved answer, restore it
        Object.keys(savedAnswers).forEach(questionId => {
            const answer = savedAnswers[questionId];
            if (!answer) return;
            
            // Add to linked list
            linkedListAnswers.addOrUpdate(questionId, answer);
            
            // Find the question element
            const questionElement = document.querySelector(`.question-card[data-question-id="${questionId}"]`);
            if (!questionElement) {
                console.warn("Question element not found for ID:", questionId);
                return;
            }
            
            const questionNumber = parseInt(questionElement.querySelector('.question-number').textContent.replace('Question ', ''));
            
            // Restore the answer based on question type
            if (questionElement.querySelector('.option-item')) {
                // Multiple choice or True/False
                const radio = questionElement.querySelector(`input[type="radio"][value="${answer}"]`);
                if (radio) {
                    radio.checked = true;
                    
                    // Also select the option item
                    const optionItem = radio.closest('.option-item');
                    if (optionItem) {
                        optionItem.classList.add('selected');
                    }
                    
                    // Mark as answered
                    answeredQuestions[questionNumber] = true;
                }
            } else {
                // Short answer or essay
                const textarea = questionElement.querySelector('textarea');
                if (textarea) {
                    textarea.value = answer;
                    
                    // Update word count
                    countWords(textarea);
                    
                    // Mark as answered if there's content
                    if (answer.trim().length > 0) {
                        answeredQuestions[questionNumber] = true;
                    }
                }
            }
        });
        
        // Update the navigation
        updateNavigation();
        
        if (DEBUG) {
            console.log("After loading saved answers:");
            linkedListAnswers.printList();
        }
        
    } catch (e) {
        console.error("Error loading saved answers:", e);
    }
}

// Save answer to linked list
function saveAnswerToLinkedList(questionCard) {
    try {
        const questionId = questionCard.dataset.questionId;
        if (!questionId) {
            console.error("Question card missing data-question-id attribute");
            return;
        }
        
        // Get the selected answer
        let answer = "";
        const selectedOption = questionCard.querySelector('.option-item.selected');
        
        if (selectedOption) {
            const radio = selectedOption.querySelector('input[type="radio"]');
            if (radio) {
                answer = radio.value;
            }
        } else {
            const textarea = questionCard.querySelector('textarea');
            if (textarea) {
                answer = textarea.value;
            }
        }
        
        if (DEBUG) console.log("Saving answer for question " + questionId + ": " + answer);
        
        // Add to linked list
        linkedListAnswers.addOrUpdate(questionId, answer);
        
        // Update the hidden field for form submission
        const savedAnswersField = document.getElementById('savedAnswersField');
        if (savedAnswersField) {
            savedAnswersField.value = JSON.stringify(linkedListAnswers.toJSON());
        } else {
            console.error("No hidden field for saved answers found");
        }
        
        if (DEBUG) {
            linkedListAnswers.printList();
        }
        
    } catch (e) {
        console.error("Error saving answer:", e);
    }
}

// Submit exam
function submitExam() {
    try {
        // Disable auto-saving
        ajaxSaveEnabled = false;
        
        // Make sure all answers are saved to the linked list
        document.querySelectorAll('.question-card').forEach(questionCard => {
            saveAnswerToLinkedList(questionCard);
        });
        
        // Update the hidden field with all answers from linked list
        const savedAnswersField = document.getElementById('savedAnswersField');
        if (savedAnswersField) {
            savedAnswersField.value = JSON.stringify(linkedListAnswers.toJSON());
        }
        
        if (DEBUG) {
            console.log("Final Linked List State Before Submission:");
            linkedListAnswers.printList();
            console.log("Submitting exam with answers:", savedAnswersField.value);
        }
        
        // Submit the form
        const examForm = document.getElementById('examForm');
        if (examForm) {
            examForm.submit();
        } else {
            console.error("Exam form not found");
            alert("Error: Form not found. Please contact support.");
        }
    } catch (e) {
        console.error("Error submitting exam:", e);
        alert("There was an error submitting your exam. Please try again.");
    }
}