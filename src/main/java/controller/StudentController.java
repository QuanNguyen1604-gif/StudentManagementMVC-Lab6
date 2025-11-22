package controller;

import dao.StudentDAO;
import model.Student;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/student")
public class StudentController extends HttpServlet {

    private StudentDAO studentDAO;

    @Override
    public void init() {
        studentDAO = new StudentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteStudent(request, response);
                break;
            case "search":
                searchStudents(request, response);
                break;
            case "sort":
                sortStudents(request, response);
                break;
            case "filter":
                filterStudents(request, response);
                break;
            default:
                listStudents(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {
            case "insert":
                insertStudent(request, response);
                break;
            case "update":
                updateStudent(request, response);
                break;
        }
    }

    // List all students
    private void listStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy "page" từ request
        String pageParam = request.getParameter("page");
        int currentPage = 1;

        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                currentPage = 1; // Nếu nhập linh tinh
            }
        }
        // Records per page
        int recordsPerPage = 10;

        int totalRecords = studentDAO.getTotalStudents();
        
        // Calculate total pages
        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        if (currentPage < 1) {
            currentPage = 1;
        }

        if (totalPages > 0 && currentPage > totalPages) {
            currentPage = totalPages;
        }

        // Calculate offset
        int offset = (currentPage - 1) * recordsPerPage;

        // Get data
        List<Student> students = studentDAO.getStudentsPaginated(offset, recordsPerPage);

        // // Set attributes
        request.setAttribute("students", students);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("views/student-list.jsp")
                .forward(request, response);
    }

    // Show form for new student
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Show form for editing student
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Student existingStudent = studentDAO.getStudentById(id);

        request.setAttribute("student", existingStudent);

        RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
        dispatcher.forward(request, response);
    }

    // Insert new student
    private void insertStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student newStudent = new Student(studentCode, fullName, email, major);
        if (!validateStudent(newStudent, request)) {
            // Set student as attribute (to preserve entered data)
            newStudent.setId(0);
            request.setAttribute("student", newStudent);
            // Forward back to form
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        if (studentDAO.addStudent(newStudent)) {
            response.sendRedirect("student?action=list&message=Student added successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to add student");
        }
    }

    // Update student
    private void updateStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        int id = Integer.parseInt(request.getParameter("id"));
        String studentCode = request.getParameter("studentCode");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String major = request.getParameter("major");

        Student student = new Student(studentCode, fullName, email, major);
        student.setId(id);
        if (!validateStudent(student, request)) {
            // Set student as attribute (to preserve entered data)
            request.setAttribute("student", student);
            // Forward back to form
            RequestDispatcher dispatcher = request.getRequestDispatcher("/views/student-form.jsp");
            dispatcher.forward(request, response);
            return;
        }
        if (studentDAO.updateStudent(student)) {
            response.sendRedirect("student?action=list&message=Student updated successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to update student");
        }
    }

    // Delete student
    private void deleteStudent(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        if (studentDAO.deleteStudent(id)) {
            response.sendRedirect("student?action=list&message=Student deleted successfully");
        } else {
            response.sendRedirect("student?action=list&error=Failed to delete student");
        }
    }

    private void searchStudents(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        String keyword = request.getParameter("keyword");
        String keyword_error = keyword != null ? keyword.trim() : "";
        List<Student> students;
        try {
            if (keyword_error.isEmpty()) {
                students = studentDAO.getAllStudents();
            } else {
                students = studentDAO.searchStudent(keyword_error);
            }
        } catch (SQLException e) {
            throw new ServletException("Unable to search students", e);
        }
        request.setAttribute("students", students);
        request.setAttribute("keyword", keyword_error);

        request.getRequestDispatcher("views/student-list.jsp").forward(request, response);
    }

    private boolean validateStudent(Student student, HttpServletRequest request) {
        boolean isValid = true;

        // Validate student code
        String studentCode = student.getStudentCode();
        if (studentCode == null || studentCode.trim().isEmpty()) {
            request.setAttribute("errorCode", "Student code is required");
            isValid = false;
        } else {
            String codePattern = "[A-Z]{2}[0-9]{3,}";
            if (!studentCode.matches(codePattern)) {
                request.setAttribute("errorCode", "Invalid format. Use 2 letters + 3+ digits (e.g., SV001)");
                isValid = false;
            }
        }

        // TODO: Validate full name
        String fullName = student.getFullName();
        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("errorName", "Student Name is required");
            isValid = false;
        } else if (fullName.trim().length() < 2) {
            request.setAttribute("errorName", "Invalid format. Minimum length: 2 characters");
            isValid = false;
        }
        // TODO: Validate email (only if provided)
        String Email = student.getEmail();
        if (Email != null && !Email.trim().isEmpty()) {
            String emailPattern = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
            if (!Email.matches(emailPattern)) {
                request.setAttribute("errorEmail", "Use regex or simple validation (contains @ and .)");
                isValid = false;
            }
        }
        // TODO: Validate major
        String Major = student.getMajor();
        if (Major == null || Major.trim().isEmpty()) {
            request.setAttribute("errorMajor", "Cannot be Empty");
            isValid = false;
        }
        return isValid;
    }

    private void sortStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        if (sortBy == null || sortBy.isEmpty()) {
            sortBy = "full_name";
        }
        if (order == null || order.isEmpty()) {
            order = "ASC";
        }
        List<Student> students = studentDAO.getStudentsSorted(sortBy, order);
        request.setAttribute("students", students);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("order", order);
        request.getRequestDispatcher("views/student-list.jsp").forward(request, response);
    }

    private void filterStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String major = request.getParameter("major");
        String sortBy = request.getParameter("sortBy");
        String order = request.getParameter("order");
        try {
            List<Student> students;
            if ((sortBy == null) || sortBy.isEmpty()) {
                sortBy = "id";
            }
            if ((order == null) || order.isEmpty()) {
                order = "asc";
            }
            if (major == null || major.isEmpty() || major.equals("all")) {
                students = studentDAO.getStudentsSorted(sortBy, order);
            } else {
                students = studentDAO.getStudentsFiltered(major, sortBy, order);
            }

            request.setAttribute("students", students);
            request.setAttribute("selectedMajor", major);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("order", order);
            request.getRequestDispatcher("/views/student-list.jsp").forward(request, response);
        } catch (SQLException e) {
            throw new ServletException("Error filtering students", e);
        }
    }
}
