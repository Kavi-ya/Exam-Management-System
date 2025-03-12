import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletContext;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import com.exam.model.Exam;
import com.exam.model.Result;

public class jsonDataManager {
    private final ServletContext context;
    private final Gson gson;

    // Implementing linked list for student records
    private static class StudentNode {
        User student;
        StudentNode next;

        StudentNode(User student) {
            this.student = student;
            this.next = null;
        }
    }

    private StudentNode head = null;

    public jsonDataManager(ServletContext context) {
        this.context = context;
        this.gson = new GsonBuilder().setPrettyPrinting().create();
        loadStudentsToLinkedList();
    }

    private String getFilePath(String fileName) {
        return context.getRealPath("/data/" + fileName);
    }

    // Authentication methods
    public User authenticateUser(String username, String password) {
        List<User> users = loadUsers();
        for (User user : users) {
            if (user.getUsername().equals(username) && user.getPassword().equals(password)) {
                return user;
            }
        }
        return null;
    }

    public User registerUser(User newUser) {
        List<User> users = loadUsers();

        // Check if username already exists
        for (User user : users) {
            if (user.getUsername().equals(newUser.getUsername())) {
                return null; // Username already exists
            }
        }

        // Add new user
        newUser.setId("U" + (users.size() + 1)); // Simple ID generation
        users.add(newUser);

        // Save updated users list
        saveUsers(users);

        // Update linked list
        addStudentToLinkedList(newUser);

        return newUser;
    }

    // JSON file operations
    public List<User> loadUsers() {
        try {
            File file = new File(getFilePath("users.json"));
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                List<User> initialUsers = new ArrayList<>();
                // Add default admin
                initialUsers.add(new User("A1", "admin", "admin123", "admin@example.com", "admin"));
                saveUsers(initialUsers);
                return initialUsers;
            }

            try (FileReader reader = new FileReader(file)) {
                return gson.fromJson(reader, new TypeToken<List<User>>() {
                }.getType());
            }
        } catch (IOException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    private void saveUsers(List<User> users) {
        try {
            File file = new File(getFilePath("users.json"));
            file.getParentFile().mkdirs();

            try (FileWriter writer = new FileWriter(file)) {
                gson.toJson(users, writer);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Linked list operations for student management
    private void loadStudentsToLinkedList() {
        List<User> users = loadUsers();
        head = null;
        StudentNode current = null;

        for (User user : users) {
            if ("student".equals(user.getRole())) {
                if (head == null) {
                    head = new StudentNode(user);
                    current = head;
                } else {
                    current.next = new StudentNode(user);
                    current = current.next;
                }
            }
        }
    }

    private void addStudentToLinkedList(User student) {
        if (!"student".equals(student.getRole())) {
            return;
        }

        StudentNode newNode = new StudentNode(student);

        if (head == null) {
            head = newNode;
        } else {
            StudentNode current = head;
            while (current.next != null) {
                current = current.next;
            }
            current.next = newNode;
        }
    }

    // Selection Sort for student scores
    public List<User> getStudentsSortedByScore() {
        List<User> sortedStudents = new ArrayList<>();
        StudentNode current = head;

        // Convert linked list to array for sorting
        while (current != null) {
            sortedStudents.add(current.student);
            current = current.next;
        }

        // Selection sort based on average score
        int n = sortedStudents.size();
        for (int i = 0; i < n - 1; i++) {
            int maxIdx = i;

            for (int j = i + 1; j < n; j++) {
                if (getAverageScore(sortedStudents.get(j)) >
                        getAverageScore(sortedStudents.get(maxIdx))) {
                    maxIdx = j;
                }
            }

            // Swap
            User temp = sortedStudents.get(maxIdx);
            sortedStudents.set(maxIdx, sortedStudents.get(i));
            sortedStudents.set(i, temp);
        }

        return sortedStudents;
    }

    private double getAverageScore(User student) {
        if (student.getResults() == null || student.getResults().isEmpty()) {
            return 0;
        }

        double totalScore = 0;
        for (Result result : student.getResults()) {
            totalScore += result.getScore();
        }

        return totalScore / student.getResults().size();
    }

    // Exam methods
    public List<Exam> loadExams() {
        try {
            File file = new File(getFilePath("exams.json"));
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                List<Exam> initialExams = new ArrayList<>();
                saveExams(initialExams);
                return initialExams;
            }

            try (FileReader reader = new FileReader(file)) {
                return gson.fromJson(reader, new TypeToken<List<Exam>>() {
                }.getType());
            }
        } catch (IOException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    public void saveExams(List<Exam> exams) {
        try {
            File file = new File(getFilePath("exams.json"));
            file.getParentFile().mkdirs();

            try (FileWriter writer = new FileWriter(file)) {
                gson.toJson(exams, writer);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // Results methods would be similar to the above patterns
}