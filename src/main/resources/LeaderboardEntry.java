// LeaderboardEntry.java
package com.management.model;

public class LeaderboardEntry {
    private String userId;
    private String name;
    private int score;

    public LeaderboardEntry() {
    }

    public LeaderboardEntry(String userId, String name, int score) {
        this.userId = userId;
        this.name = name;
        this.score = score;
    }

    // Getters and setters
    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }
}