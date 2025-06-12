# 🎓 Online Examination and Result Management System

A dynamic web-based application for managing online examinations and student results in educational institutions. Designed for admin, teacher, and student interactions, this system ensures smooth handling of question banks, student records, exam sessions, and result management using JSP, Servlets, and JSON file storage.

---

## 🚀 Technologies & Tools

[![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=java&logoColor=white)](https://www.java.com/) 
[![IntelliJ IDEA](https://img.shields.io/badge/IntelliJ%20IDEA-000000?style=for-the-badge&logo=intellijidea&logoColor=white)](https://www.jetbrains.com/idea/) 
[![Eclipse](https://img.shields.io/badge/Eclipse-2C2255?style=for-the-badge&logo=eclipse&logoColor=white)](https://www.eclipse.org/) 
[![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/HTML) 
[![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)](https://developer.mozilla.org/en-US/docs/Web/CSS) 
[![Bootstrap](https://img.shields.io/badge/Bootstrap-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white)](https://getbootstrap.com/) 
[![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)](https://developer.mozilla.org/en-US/docs/Web/JavaScript) 
![JSON](https://img.shields.io/badge/JSON-000000?style=for-the-badge&logo=json&logoColor=white)

---

## 📌 Features

- 🧑‍💼 **Admin Module**
  - Secure Admin Authentication
  - Oversee system and user management

- 👩‍🏫 **Teacher Module**
  - Teacher Registration and Login
  - Add and manage exams
  - Add and manage questions
  - View student results for their exams

- 🧑‍🎓 **Student Module**
  - Student Registration and Login
  - Available Exam Listing
  - Online Exam Interface
  - Instant Result Display
  - Performance Analysis

- 🛠️ **System Features**
  - JSON-based Data Persistence
  - Linked List for maintaining student records dynamically
  - Selection Sort to sort students by scores (leaderboard, analytics)
  - Role-based Access Control (Admin, Teacher, Student)
  - Responsive UI Design
  - Session Management
  - Data Validation

---

<details>
  <summary><b>📂 Project Structure (click to expand)</b></summary>

  
  <pre>

Exam-Management-System/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/
│       │       └── exam/
│       │           ├── model/
│       │           │   ├── Admin.java
│       │           │   ├── Teacher.java
│       │           │   ├── Exam.java
│       │           │   ├── Question.java
│       │           │   ├── Result.java
│       │           │   └── User.java
│       │           ├── services/
│       │           │   ├── AdminAuthService.java
│       │           │   ├── TeacherAuthService.java
│       │           │   └── UserAuthService.java
│       │           └── servlets/
│       │               └── [Servlet Classes]
│       └── webapp/
│           ├── assets/
│           ├── css/
│           ├── js/
│           ├── META-INF/
│           ├── WEB-INF/
│           │   ├── data/
│           │   │   ├── admin.json
│           │   │   ├── teachers.json
│           │   │   ├── exams.json
│           │   │   ├── questions.json
│           │   │   ├── results.json
│           │   │   └── users.json
│           │   ├── lib/
│           │   │   ├── gson-2.10.1.jar
│           │   │   ├── javax.servlet-api-4.0.1.jar
│           │   │   ├── jstl-1.2.jar
│           │   │   ├── jstl-api-1.2.jar
│           │   │   └── servlet-api.jar
│           │   └── web.xml
│           ├── adminDashboard.jsp
│           ├── teacherDashboard.jsp
│           ├── adminExamMg.jsp
│           ├── teacherExamMg.jsp
│           ├── admin-leaderboard.jsp
│           ├── teacher-leaderboard.jsp
│           ├── adminLogin.jsp
│           ├── teacherLogin.jsp
│           ├── adminUserSettings.jsp
│           ├── checkservlet.jsp
│           ├── create-exam.jsp
│           └── [Other JSP Files]

  </pre>
</details>

---

## 🔧 Advanced Data Handling

### Linked List for Student Records

- **Data Structure Used**: Linked List
- **Purpose**: To dynamically maintain student scores, allowing efficient addition and traversal of student data.
- **Example Usage**:
  - Adding a new student mark when they finish an exam.
  - Traversing the list to display all students' marks.

### Selection Sort for Sorting Results

- **Algorithm Used**: Selection Sort
- **Purpose**: To sort students by their exam scores in ascending or descending order for leaderboard generation.
- **Example Usage**:
  - Sorting student results before displaying the leaderboard.
  - Generating performance rankings for analytics.

---

## 🧩 System Design Highlights

### Model-View-Controller (MVC) Pattern

- **Model**: Java classes in `com.exam.model` represent data entities.
- **View**: JSP files in `webapp` for the user interface.
- **Controller**: Servlets in `com.exam.servlets` for handling requests.

### Data Management

All data is stored persistently in JSON files under `WEB-INF/data/`:
- `admin.json`: Admin credentials and profiles
- `teachers.json`: Teacher information and credentials
- `users.json`: Student information and credentials
- `questions.json`: Question bank with all questions and answers
- `exams.json`: Exam configurations and schedules
- `results.json`: Student exam results and analytics

---

## 🖥️ User Interfaces

<details>
  <summary><b>Home Page</b></summary>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Index.png" alt="Home Page" width="700">
  </p>
</details>

<details>
  <summary><b>Admin Module</b></summary>
  
  <p align="center"><i>Admin Login</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Admin%20Login.jpeg" alt="Admin Login" width="700">
  </p>
  
  <p align="center"><i>Admin Dashboard</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Admin%20Dashboard.jpeg" alt="Admin Dashboard" width="700">
  </p>
  
  <p align="center"><i>User Management</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/User%20Management.jpeg" alt="User Management" width="700">
  </p>

  <p align="center"><i>Exam Management</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Exam%20Management.jpeg" alt="Exam Management" width="700">
  </p>
</details>

<details>
  <summary><b>Teacher Module</b></summary>
  
  <p align="center"><i>Create Exam & Add Questions</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Create%20Exam%20%26%20Questions.jpeg" alt="Create Exam & Questions" width="700">
  </p>
  
  <p align="center"><i>Manage Examinations</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Manage%20Examinations.jpeg" alt="Manage Examinations" width="700">
  </p>
</details>

<details>
  <summary><b>Student Module</b></summary>
  <p align="center"><i>User Registration</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/User%20Registration.jpeg" alt="User Registration" width="700">
  </p>

  <p align="center"><i>User Login</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/User%20Login.jpeg" alt="User Login" width="700">
  </p>
  
  <p align="center"><i>Exam Enrolling Interface</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Student%20Exam%20Enrolling.jpeg" alt="Exam Enrolling Interface" width="700">
  </p>

  <p align="center"><i>Exam Interface</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Exam%20Interface.jpeg" alt="Exam Interface" width="700">
  </p>
  
  <p align="center"><i>Result Display</i></p>
  <p align="center">
    <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Results.jpeg" alt="Result Display" width="700">
  </p>
  
  <p align="center"><i>Leaderboard</i></p>
  <p align="center">
     <img src="https://github.com/IT24102083/Exam-Management-System/blob/main/User%20Interfaces/Student%20Leaderboard.jpeg" alt="Leaderboard" width="700">
  </p>
</details>

---

## 🚀 Getting Started

### Prerequisites
- Java JDK 8 or later
- Apache Tomcat 9 or later
- IntelliJ IDEA or Eclipse IDE
- Git

### Installation Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/IT24102083/Exam-Management-System.git
   ```
2. Import the project into your IDE as a "Dynamic Web Project."
3. Deploy on a configured Apache Tomcat server.
4. Access the application at: `http://localhost:8080/Exam-Management-System/`

---

## 📬 Contact

- GitHub: [Kavi-ya](https://github.com/Kavi-ya)
- Email: kavindusahansilva@example.com

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

> ✨ Built with Java Servlets, JSP, and 💙 for education.
