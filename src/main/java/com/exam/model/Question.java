package com.exam.model;

import java.util.ArrayList;
import java.util.List;

public class Question {
    private String questionId;
    private String questionText;
    private String courseId;
    private String questionType;
    private int difficultyLevel;
    private int points;
    private String category;
    private List<String> options;
    private String correctAnswer;
    private String explanation;
    private String[] tags;
    private String createdBy;
    private String createdAt;
    private String modifiedAt;
    private boolean active;

    public Question() {
        // Initialize with defaults
        this.questionId = java.util.UUID.randomUUID().toString();
        this.options = new ArrayList<>();
        this.active = true;
        this.difficultyLevel = 2; // Medium difficulty by default
        this.points = 1;
    }

    // Getters and setters with null checks
    public String getQuestionId() {
        // Ensure we never return null for questionId
        if (questionId == null) {
            questionId = java.util.UUID.randomUUID().toString();
        }
        return questionId;
    }

    public void setQuestionId(String questionId) {
        // Don't allow setting a null or empty questionId
        if (questionId != null && !questionId.trim().isEmpty()) {
            this.questionId = questionId;
        } else {
            this.questionId = java.util.UUID.randomUUID().toString();
        }
    }

    public String getQuestionText() {
        return questionText;
    }

    public void setQuestionText(String questionText) {
        this.questionText = questionText;
    }

    public String getCourseId() {
        return courseId;
    }

    public void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getQuestionType() {
        return questionType;
    }

    public void setQuestionType(String questionType) {
        this.questionType = questionType;
    }

    public int getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(int difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

    public int getPoints() {
        return points;
    }

    public void setPoints(int points) {
        this.points = points;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public List<String> getOptions() {
        if (options == null) {
            options = new ArrayList<>();
        }
        return options;
    }

    public void setOptions(List<String> options) {
        this.options = options;
    }

    public String getCorrectAnswer() {
        return correctAnswer;
    }

    public void setCorrectAnswer(String correctAnswer) {
        this.correctAnswer = correctAnswer;
    }

    public String getExplanation() {
        return explanation;
    }

    public void setExplanation(String explanation) {
        this.explanation = explanation;
    }

    public String[] getTags() {
        return tags;
    }

    public void setTags(String[] tags) {
        this.tags = tags;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
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

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}