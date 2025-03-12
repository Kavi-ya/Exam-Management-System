// Result.java
package com.exammanagement.model;

public class Result {
    private String userId;
    private int score;
    private int total;

    public Result() {
    }

    public Result(String userId, int score, int total) {
        this.userId = userId;
        this.score = score;
        this.total = total;
    }

    // Getters and setters
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public int getTotal() {
        return total;
    }

    public void setTotal(int total) {
        this.total = total;
    }
}
