package com.exam.model;

import java.util.List;

public class Exam {
    private String examId;
    private String title;
    private String courseId;
    private String description;
    private String createdBy;
    private String status;
    private int maxScore;
    private int passingScore;
    private int durationMinutes;
    private String startDateTime;
    private String endDateTime;
    private boolean shuffleQuestions;
    private boolean shuffleOptions;
    private boolean showResults;
    private boolean showAnswers;
    private String accessCode;
    private String availableFrom;
    private String availableUntil;
    private String createdAt;
    private String modifiedAt;
    private List<String> questionIds;
    
    // Getters and setters
    public String getExamId() {
        return examId;
    }
    
    public void setExamId(String examId) {
        this.examId = examId;
    }
    
    public String getTitle() {
        return title;
    }
    
    public void setTitle(String title) {
        this.title = title;
    }
    
    public String getCourseId() {
        return courseId;
    }
    
    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getCreatedBy() {
        return createdBy;
    }
    
    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public int getMaxScore() {
        return maxScore;
    }
    
    public void setMaxScore(int maxScore) {
        this.maxScore = maxScore;
    }
    
    public int getPassingScore() {
        return passingScore;
    }
    
    public void setPassingScore(int passingScore) {
        this.passingScore = passingScore;
    }
    
    public int getDurationMinutes() {
        return durationMinutes;
    }
    
    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }
    
    public String getStartDateTime() {
        return startDateTime;
    }
    
    public void setStartDateTime(String startDateTime) {
        this.startDateTime = startDateTime;
    }
    
    public String getEndDateTime() {
        return endDateTime;
    }
    
    public void setEndDateTime(String endDateTime) {
        this.endDateTime = endDateTime;
    }
    
    public boolean isShuffleQuestions() {
        return shuffleQuestions;
    }
    
    public void setShuffleQuestions(boolean shuffleQuestions) {
        this.shuffleQuestions = shuffleQuestions;
    }
    
    public boolean isShuffleOptions() {
        return shuffleOptions;
    }
    
    public void setShuffleOptions(boolean shuffleOptions) {
        this.shuffleOptions = shuffleOptions;
    }
    
    public boolean isShowResults() {
        return showResults;
    }
    
    public void setShowResults(boolean showResults) {
        this.showResults = showResults;
    }
    
    public boolean isShowAnswers() {
        return showAnswers;
    }
    
    public void setShowAnswers(boolean showAnswers) {
        this.showAnswers = showAnswers;
    }
    
    public String getAccessCode() {
        return accessCode;
    }
    
    public void setAccessCode(String accessCode) {
        this.accessCode = accessCode;
    }
    
    public String getAvailableFrom() {
        return availableFrom;
    }
    
    public void setAvailableFrom(String availableFrom) {
        this.availableFrom = availableFrom;
    }
    
    public String getAvailableUntil() {
        return availableUntil;
    }
    
    public void setAvailableUntil(String availableUntil) {
        this.availableUntil = availableUntil;
    }
    
    public String getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
    
    public String getModifiedAt() {
        return modifiedAt;
    }
    
    public void setModifiedAt(String modifiedAt) {
        this.modifiedAt = modifiedAt;
    }
    
    public List<String> getQuestionIds() {
        return questionIds;
    }
    
    public void setQuestionIds(List<String> questionIds) {
        this.questionIds = questionIds;
    }
    
    // Helper methods
    public boolean isActive() {
        // TODO: Implement based on start/end times
        return true;
    }
    
    public boolean isUpcoming() {
        // TODO: Implement based on start/end times
        return false;
    }
    
    public boolean isCompleted() {
        // TODO: Implement based on start/end times
        return false;
    }
    
    public String getFormattedStartDate() {
        // TODO: Implement date formatting logic
        return startDateTime;
    }
    
    public String getFormattedStartTime() {
        // TODO: Implement time formatting logic
        return startDateTime;
    }
}