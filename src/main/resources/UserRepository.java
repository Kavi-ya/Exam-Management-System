// UserRepository.java (File Operations)
package com.exam.repository;

public class UserRepository {
    private static final String FILE_PATH = "users.json";
    private LinkedList<User> users = new LinkedList<>();

    public UserRepository() {
        loadUsers();
    }

    private void loadUsers() {
        try (BufferedReader reader = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] data = line.split(",");
                users.add(new User(data[0], data[1], data[2], data[3]));
            }
        }
    }

    public void saveUser(User user) {
        users.add(user);
        saveToFile();
    }

    private void saveToFile() {
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(FILE_PATH))) {
            for (User user : users) {
                writer.write(userToCsv(user));
                writer.newLine();
            }
        }
    }

    private String userToCsv(User user) {
        return String.join(",",
                user.getId(),
                user.getUsername(),
                user.getPassword(),
                user.getRole()
        );
    }
}