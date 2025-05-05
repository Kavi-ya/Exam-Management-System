package com.exam.model;

import java.util.Map;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Result {
    private String resultId;
    private String studentId;
    private String examId;
    private int score;
    private int maxScore;
    private boolean passed;
    private String submissionTime;
    private Map<String, String> answers;  // Map of questionId -> studentAnswer
    private String feedback;
    private String gradedBy;  // Teacher ID if manually graded
    private String gradedAt;  // Time of grading
    private String comments;  // Teacher comments
    
    // Constructors
    public Result() {
    }
    
    public Result(String resultId, String studentId, String examId, int score, int maxScore, boolean passed, String submissionTime) {
        this.resultId = resultId;
        this.studentId = studentId;
        this.examId = examId;
        this.score = score;
        this.maxScore = maxScore;
        this.passed = passed;
        this.submissionTime = submissionTime;
    }
    
    // Getters and Setters
    public String getResultId() {
        return resultId;
    }
    
    public void setResultId(String resultId) {
        this.resultId = resultId;
    }
    
    public String getStudentId() {
        return studentId;
    }
    
    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }
    
    public String getExamId() {
        return examId;
    }
    
    public void setExamId(String examId) {
        this.examId = examId;
    }
    
    public int getScore() {
        return score;
    }
    
    public void setScore(int score) {
        this.score = score;
    }
    
    public int getMaxScore() {
        return maxScore;
    }
    
    public void setMaxScore(int maxScore) {
        this.maxScore = maxScore;
    }
    
    public boolean isPassed() {
        return passed;
    }
    
    public void setPassed(boolean passed) {
        this.passed = passed;
    }
    
    public String getSubmissionTime() {
        return submissionTime;
    }
    
    public void setSubmissionTime(String submissionTime) {
        this.submissionTime = submissionTime;
    }
    
    public Map<String, String> getAnswers() {
        return answers;
    }
    
    public void setAnswers(Map<String, String> answers) {
        this.answers = answers;
    }
    
    public String getFeedback() {
        return feedback;
    }
    
    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }
    
    public String getGradedBy() {
        return gradedBy;
    }
    
    public void setGradedBy(String gradedBy) {
        this.gradedBy = gradedBy;
    }
    
    public String getGradedAt() {
        return gradedAt;
    }
    
    public void setGradedAt(String gradedAt) {
        this.gradedAt = gradedAt;
    }
    
    public String getComments() {
        return comments;
    }
    
    public void setComments(String comments) {
        this.comments = comments;
    }
    
    // Utility methods
    public String getScoreDisplay() {
        return score + " / " + maxScore;
    }
    
    public double getPercentage() {
        return (double) score / maxScore * 100;
    }
    
    public String getFormattedSubmissionTime() {
        try {
            LocalDateTime dateTime = LocalDateTime.parse(submissionTime);
            return dateTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
        } catch (Exception e) {
            return submissionTime;
        }
    }
    
    public String getGradeStatus() {
        if (gradedBy != null && !gradedBy.isEmpty()) {
            return "Graded";
        } else {
            return "Auto-graded";
        }
    }
    
    @Override
    public String toString() {
        return "Result{" +
                "resultId='" + resultId + '\'' +
                ", studentId='" + studentId + '\'' +
                ", examId='" + examId + '\'' +
                ", score=" + score +
                ", maxScore=" + maxScore +
                ", passed=" + passed +
                '}';
    }
}