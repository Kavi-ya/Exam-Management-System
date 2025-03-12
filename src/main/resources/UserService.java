// UserService.java
package com.exam.service;

public class UserService {
    private UserRepository userRepo = new UserRepository();

    public boolean registerUser(User user) {
        if (!userExists(user.getUsername())) {
            userRepo.saveUser(user);
            return true;
        }
        return false;
    }

    private boolean userExists(String username) {
        return userRepo.getAllUsers().stream()
                .anyMatch(u -> u.getUsername().equals(username));
    }
}