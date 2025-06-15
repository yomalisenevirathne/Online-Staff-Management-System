<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>Task Minds</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/admin.css" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />
<script>
  		function confirmDelete(name) {
    		return confirm("Are you sure you want to delete " + name + "?");
  		}
	</script>

</head>
<body>
	<div class="app-container">
		<!-- Sidebar -->
		<aside class="sidebar">
			<div class="sidebar-header">
				<i class="fas fa-user-friends sidebar-icon"></i> <span
					class="sidebar-title">Task Minds</span>
			</div>
			<nav class="sidebar-nav">
				<a href="${pageContext.request.contextPath}/dashboard"
					class="nav-link"> <i class="fas fa-th-large"></i> Dashboard
				</a> <a href="${pageContext.request.contextPath}/admin"
					class="nav-link active" aria-current="page"> <i
					class="fas fa-user-friends"></i> Staff Management
				</a> <a href="${pageContext.request.contextPath}/payroll"
					class="nav-link"> <i class="fas fa-dollar-sign"></i> Payroll
				</a> <a href="${pageContext.request.contextPath}/attendance-approve"
					class="nav-link"> <i class="fas fa-clock"></i>
					Attendance
				</a> <a href="${pageContext.request.contextPath}/Approve-Leave"
					class="nav-link"> <i class="fas fa-calendar-alt"></i>
					Leave Management
				</a> <a href="${pageContext.request.contextPath}/views/login.jsp"
					class="nav-link"> <i class="fas fa-sign-out-alt"></i> Log out
				</a>

			</nav>
		</aside>

		<!-- Main content -->
		<main class="main-content">
			<!-- Top bar -->
			<header class="top-bar">
				<div class="card-header">
					<h2 class="page-title">Staff Management</h2>
					<p class="card-subtitle">Manage your organization's staff
						members.</p>
				</div>
				<div class="top-bar-actions">
					<button aria-label="Notifications" class="action-btn">
						<i class="far fa-bell"></i>
					</button>
					<button aria-label="User Profile" class="action-btn">
						<i class="far fa-user"></i>
					</button>
				</div>
			</header>

			<!-- Content -->
			<section class="content-section">
				<div class="content-card">
					<!-- Modified quick add form with two rows -->
					<div class="quick-add-form-container">
						<h3 class="quick-add-title">
							<i class="fas fa-user-plus"></i> Quick Add Staff
						</h3>
						<form id="quickAddEmployeeForm" class="quick-add-form"
							action="admin" method="post">

							<div class="form-grid">
								<!-- Column 1: Name, Email, Salary -->
								<div class="form-column">
									<div class="form-field">
										<input type="text" id="quickName" name="name" required
											value="${editUser.name}" class="modern-input"
											placeholder="Name" style="width: 280px; height: 22px" />
									</div>
									<div class="form-field">
										<input type="email" id="quickEmail" name="email" required
											value="${editUser.email}" class="modern-input"
											placeholder="Email" style="width: 280px; height: 22px" />
									</div>
									<div class="form-field">
										<input type="number" id="quickSalary" name="salary" required
											value="${editUser.salary}" class="modern-input"
											placeholder="Salary" min="20000" step="1000"
											style="width: 280px; height: 22px" />
									</div>
								</div>

								<!-- Column 2: Position, Phone Number, OT Rate -->
								<div class="form-column">
									<div class="form-field">
										<select id="quickPosition" name="position" required
											class="modern-input" style="width: 305px; height: 38px">
											<option value="${editUser.position}" disabled selected>Position</option>
											<option>Manager</option>
											<option>Worker</option>
											<option>Staff Assistant</option>
											<option>Executive</option>
										</select>
									</div>
									<div class="form-field">
										<input type="tel" id="quickContactno" name="contactno"
											required value="${editUser.contactno}" class="modern-input"
											placeholder="Phone Number"
											pattern="^\+94\s\d{2}\s\d{3}\s\d{4}$"
											title="Format: +94 23 456 7890"
											style="width: 280px; height: 22px" />
									</div>
									<div class="form-field">
										<input type="number" id="quickOTperHour" name="OTperHour"
											required value="${editUser.otPerHour}" class="modern-input"
											placeholder="OT Rate Per Hour" min="0" step="10"
											style="width: 280px; height: 22px" />
									</div>
								</div>

								<!-- Column 3: Department, Password, Add Button -->
								<div class="form-column">
									<div class="form-field">
										<input type="text" id="quickDepartment" name="department"
											required value="${editUser.department}" class="modern-input"
											placeholder="Department" style="width: 280px; height: 22px" />
									</div>
									<div class="form-field">
										<input type="password" id="quickPassword" name="password"
											required value="${editUser.password}" class="modern-input"
											placeholder="Password" style="width: 280px; height: 22px" />

										<small id="passwordError" style="color: red; display: none;">
											Password must be at least 8 characters long and include a
											special character. </small>
									</div>
									<div class="form-field form-field-submit">
										<c:choose>
											<c:when test="${not empty editUser}">
												<input type="hidden" name="action" value="update" />
												<input type="hidden" name="editUserId"
													value="${editUser.id}" />
												<button type="submit" class="quick-add-btn">Update
													Staff</button>
												<a href="admin" class="quick-add-btn cancel-btn">Cancel</a>
											</c:when>
											<c:otherwise>
												<input type="hidden" name="action" value="add" />
												<button type="submit" class="quick-add-btn">Add
													Staff</button>
											</c:otherwise>
										</c:choose>
									</div>

								</div>
							</div>
						</form>

						<div class="search-container">
							<label for="search" class="sr-only">Search Staff</label>
							<div class="search-input-wrapper">
								<input type="search" id="search" placeholder="Search staff..."
									class="search-input" /> <i
									class="fas fa-search search-icon"></i>
							</div>
						</div>

						<table class="employee-table" id="employeeTable">
							<thead>
								<tr>
									<th>Name</th>
									<th>Position</th>
									<th>Department</th>
									<th>Status</th>
									<th>Contact</th>
									<th class="text-right">Actions</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="user" items="${userList}">
									<tr class="employee-row">
										<td class="employee-name">${user.name}</td>
										<td>${user.position}</td>
										<td>${user.department}</td>
										<td><span class="status-badge">
												Active </span></td>
										<td class="contact-info">
											<div class="contact-item">
												<i class="far fa-envelope"></i> <a
													href="mailto:${user.email}" class="contact-link">${user.email}</a>
											</div>
											<div class="contact-item">
												<i class="fas fa-phone"></i> <a href="tel:${user.contactno}"
													class="contact-link">${user.contactno}</a>
											</div>
										</td>
										<td class="actions-cell">

											<form method="get" action="admin" style="display: inline;">
												<input type="hidden" name="action" value="update" /> <input
													type="hidden" name="editUserId" value="${user.id}" />
												<button type="submit" class="action-icon"
													aria-label="Edit ${user.name}">
													<i class="far fa-edit"></i>
												</button>
											</form>

											<form action="admin" method="post" style="display: inline;"
												onsubmit="return confirmDelete('${user.name}')">
												<input type="hidden" name="action" value="delete" /> <input
													type="hidden" name="userId" value="${user.id}" />
												<button type="submit" class="action-icon delete-btn"
													aria-label="Delete ${user.name}">
													<i class="fas fa-trash-alt"></i>
												</button>
											</form>

										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</section>
		</main>
	</div>

	<script>
	  document.getElementById("search").addEventListener("keyup", function () {
	    const searchTerm = this.value.toLowerCase();
	    const rows = document.querySelectorAll("#employeeTable tbody tr");
	
	    rows.forEach(row => {
	      const name = row.querySelector(".employee-name").textContent.toLowerCase();
	      if (name.includes(searchTerm)) {
	        row.style.display = "";
	      } else {
	        row.style.display = "none";
	      }
	    });
	  });
	    
	    //Password validation
	    document.getElementById("quickAddEmployeeForm").addEventListener("submit", function (e) {
		    const passwordInput = document.getElementById("quickPassword");
		    const errorText = document.getElementById("passwordError");
		    const password = passwordInput.value;
		    const isValid = password.length >= 8 && /[!@#$%^&*(),.?":{}|<>]/.test(password);
	
		    if (!isValid) {
		      e.preventDefault();
		      errorText.style.display = "block";
		    } else {
		      errorText.style.display = "none";
		    }
	    });	
</script>

</body>
</html>