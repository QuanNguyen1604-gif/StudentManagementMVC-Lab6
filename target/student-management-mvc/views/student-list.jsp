<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student List - MVC</title>

    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        /* ---------------- NAVBAR ---------------- */
        .navbar {
            width: 100%;
            background: rgba(255,255,255,0.9);
            padding: 15px 25px;
            border-radius: 10px;
            margin-bottom: 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 6px 20px rgba(0,0,0,0.15);
        }

        .navbar h2 {
            color: #333;
            font-size: 22px;
        }

        .navbar-right {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .user-info {
            font-weight: 500;
            color: #333;
        }

        .role-badge {
            padding: 4px 8px;
            border-radius: 5px;
            font-size: 12px;
            margin-left: 8px;
        }

        .role-admin { background: #dc3545; color: white; }
        .role-user  { background: #28a745; color: white; }

        .btn-nav, .btn-logout {
            padding: 10px 18px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: 500;
            color: white;
        }

        .btn-nav { background: #667eea; }
        .btn-logout { background: #dc3545; }

        /* ---------------- MAIN CONTAINER ---------------- */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        h1 { color: #333; margin-bottom: 10px; font-size: 32px; }
        .subtitle { color: #666; margin-bottom: 30px; font-style: italic; }

        .btn {
            padding: 12px 24px;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 500;
            transition: 0.3s;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-danger { background-color: #dc3545; color: white; padding: 8px 16px; }
        .btn-secondary { background-color: #6c757d; color: white; }

        table {
            width: 100%; border-collapse: collapse; margin-top: 20px;
        }

        thead {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        th, td {
            padding: 15px; border-bottom: 1px solid #ddd; text-align: left;
        }

        tbody tr:hover { background: #f8f9fa; }

        .actions { display: flex; gap: 10px; }

        /* Pagination */
        .pagination { text-align: center; margin: 25px 0; }
        .pagination a, .pagination strong {
            padding: 8px 14px; margin: 0 4px; border: 1px solid #ddd;
            border-radius: 5px; text-decoration: none; font-size: 14px;
        }
        .pagination strong { background: #667eea; color: white; }

    </style>
</head>

<body>
    <!-- ====================== NAVIGATION BAR ====================== -->
    <div class="navbar">
        <h2>📚 Student Management System</h2>

        <div class="navbar-right">
            <div class="user-info">
                Welcome, ${sessionScope.fullName}
                <span class="role-badge role-${sessionScope.role}">
                    ${sessionScope.role}
                </span>
            </div>

            <a href="dashboard" class="btn-nav">Dashboard</a>
            <a href="logout" class="btn-logout">Logout</a>
        </div>
    </div>

    <!-- ====================== MAIN CONTENT ====================== -->
    <div class="container">

        <h1>📚 Student List</h1>
        <p class="subtitle">MVC Pattern with Jakarta EE & JSTL</p>

        <!-- Add Button (Admin only) -->
        <c:if test="${sessionScope.role eq 'admin'}">
            <div style="margin-bottom: 20px;">
                <a href="student?action=new" class="btn btn-primary">➕ Add New Student</a>
            </div>
        </c:if>

        <!-- ================= SEARCH ================= -->
        <div class="search-box">
            <form action="student" method="get">
                <input type="hidden" name="action" value="search"/>
                <input type="text" name="keyword" value="${keyword}" placeholder="Input information: "/>
                <button type="submit">🔍Search</button>

                <c:if test="${not empty keyword}">
                    <a href="student?action=list">Clear/Show All</a>
                </c:if>
            </form>
        </div>

        <c:if test="${not empty keyword}">
            <div>Search results for: "<strong>${keyword}</strong>"</div>
        </c:if>

        <!-- ================= FILTER BY MAJOR ================= -->
        <div style="margin: 20px 0;">
            <form action="student" method="get">
                <input type="hidden" name="action" value="filter">

                <label><strong>Filter by Major:</strong></label>
                <select name="major">
                    <option value="">All Majors</option>

                    <option value="Computer Science" ${selectedMajor == 'Computer Science' ? 'selected' : ''}>Computer Science</option>
                    <option value="Information Systems" ${selectedMajor == 'Information Systems' ? 'selected' : ''}>Information Systems</option>
                    <option value="Software Engineering" ${selectedMajor == 'Software Engineering' ? 'selected' : ''}>Software Engineering</option>
                    <option value="Data Science" ${selectedMajor == 'Data Science' ? 'selected' : ''}>Data Science</option>
                </select>

                <button type="submit" class="btn btn-primary" style="padding: 6px 14px;">Apply Filter</button>

                <c:if test="${not empty selectedMajor}">
                    <a href="student?action=list" style="margin-left: 10px;">Clear Filter</a>
                </c:if>
            </form>
        </div>

        <!-- ================= STUDENT TABLE ================= -->
        <c:choose>
            <c:when test="${not empty students}">
                <table>
                    <thead>
                        <tr>
                            <th>
                                <a href="student?action=sort&sortBy=id&order=${sortBy == 'id' && order == 'asc' ? 'desc' : 'asc'}">ID</a>
                                <c:if test="${sortBy == 'id'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                            </th>

                            <th>
                                <a href="student?action=sort&sortBy=student_code&order=${sortBy == 'student_code' && order == 'asc' ? 'desc' : 'asc'}">Student Code</a>
                                <c:if test="${sortBy == 'student_code'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                            </th>

                            <th>
                                <a href="student?action=sort&sortBy=full_name&order=${sortBy == 'full_name' && order == 'asc' ? 'desc' : 'asc'}">Full Name</a>
                                <c:if test="${sortBy == 'full_name'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                            </th>

                            <th>Email</th>

                            <th>
                                <a href="student?action=sort&sortBy=major&order=${sortBy == 'major' && order == 'asc' ? 'desc' : 'asc'}">Major</a>
                                <c:if test="${sortBy == 'major'}">${order == 'asc' ? '▲' : '▼'}</c:if>
                            </th>

                            <c:if test="${sessionScope.role eq 'admin'}">
                                <th>Actions</th>
                            </c:if>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="student" items="${students}">
                            <tr>
                                <td>${student.id}</td>
                                <td><strong>${student.studentCode}</strong></td>
                                <td>${student.fullName}</td>
                                <td>${student.email}</td>
                                <td>${student.major}</td>

                                <c:if test="${sessionScope.role eq 'admin'}">
                                    <td>
                                        <div class="actions">
                                            <a href="student?action=edit&id=${student.id}" class="btn-secondary">✏️ Edit</a>
                                            <a href="student?action=delete&id=${student.id}" class="btn-danger"
                                               onclick="return confirm('Are you sure you want to delete this student?')">🗑️ Delete</a>
                                        </div>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <!-- Pagination -->
                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="student?action=list&page=${currentPage - 1}">« Previous</a>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${i == currentPage}">
                                <strong>${i}</strong>
                            </c:when>
                            <c:otherwise>
                                <a href="student?action=list&page=${i}">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="student?action=list&page=${currentPage + 1}">Next »</a>
                    </c:if>
                </div>

                <p style="text-align: center; margin-top: 10px;">
                    Showing page <strong>${currentPage}</strong> of <strong>${totalPages}</strong>
                </p>

            </c:when>

            <c:otherwise>
                <div class="empty-state">
                    <h3>No students found</h3>
                    <p>Start by adding a new student</p>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</body>
</html>
