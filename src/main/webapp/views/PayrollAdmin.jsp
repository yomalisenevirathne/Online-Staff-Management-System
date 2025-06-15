<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Payroll Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/payroll.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
    />
    
     
  </head>
  <body>
    <div class="app-container">
      <!-- Sidebar -->
      <aside class="sidebar">
        <div class="sidebar-header">
          <i class="fas fa-user-friends sidebar-icon"></i>
          <span class="sidebar-title">Task Minds</span>
        </div>
        <nav class="sidebar-nav">
         <a href="${pageContext.request.contextPath}/dashboard" class="nav-link">
            <i class="fas fa-th-large"></i>
            Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/admin" class="nav-link">
            <i class="fas fa-user-friends"></i>
            Staff Management
          </a>
          <a href="${pageContext.request.contextPath}/payroll" class="nav-link active">
			 <i class="fas fa-dollar-sign"></i>
			Payroll
		  </a>	
          <a href="${pageContext.request.contextPath}/attendance-approve"  class="nav-link">
            <i class="fas fa-clock"></i>
            Attendance
          </a>
          <a href="${pageContext.request.contextPath}/leave" class="nav-link">
            <i class="fas fa-calendar-alt"></i>
            Leave Management
          </a>
          		<a 
          href="${pageContext.request.contextPath}/views/login.jsp" 
          class="nav-link">
          <i class="fas fa-sign-out-alt"></i>
           Log out
           </a>
        </nav>
      </aside>



      <main class="main-content">
        <header class="page-header">
          <h1 class="page-title">Payroll Management</h1>
          <p class="page-subtitle">
            Create and manage employee payroll records
          </p>
        </header>

        <section class="content-section">
          <div class="payroll-container">
            <!-- Left side: Create Payroll Form -->
            <div class="payroll-form-container">
              <div class="payroll-form">
                <h3 class="form-title">Create Payroll Record</h3>

                <form id="payrollForm" method="post" action="payroll">
                  <input type="hidden" name="action" value="add" />

                  <div class="form-group">
                    <label for="employeeSelect">Staff Name</label>
                    <select
                      id="employeeSelect"
                      name="employee_id"
                      required
                      class="form-select"
                    >
                      <option value="">Select a staff member</option>
                      <c:forEach var="employee" items="${employeeList}">
                        <option value="${employee.id}" data-salary="${employee.salary}">${employee.name}</option>
                      </c:forEach>
                    </select>
                  </div>

                  <div class="form-group">
                    <label for="month">Month</label>
                    <input
                      type="month"
                      id="month"
                      name="month"
                      required
                      class="form-input"
                    />
                  </div>

                  <div class="form-group">
                    <label for="basicSalary">Basic Salary</label>
                    <input
                      type="number"
                      id="basicSalary"
                      name="basic_salary"
                      min="20000"
                      required
                      readonly
                      class="form-input"
                      
                    />
                  </div>

                  <div class="form-group">
                    <label for="deductions">Deductions</label>
                    <input
                      type="number"
                      id="deductions"
                      name="deductions"
                      step="100"
                      required
                      class="form-input"
                    />
                  </div>

                  <div class="form-group">
                    <label for="bonus">Bonus</label>
                    <input
                      type="number"
                      id="bonus"
                      name="bonus"
                      required
                      step="100"
                      class="form-input"
                    />
                  </div>

                  <div class="form-actions">
                    <button type="reset" class="cancel-btn">Clear</button>
                    <button type="submit" class="submit-btn">
                      <i class="fas fa-plus"></i> Create
                    </button>
                  </div>
                </form>
              </div>
            </div>

            <!-- Right side: Payroll Table -->
            <div class="payroll-table-container">
              <div class="payroll-table-card">
              <div class="search-container">

				</div>
                <div class="table-header">
                  <h3 class="table-title">Payroll Records</h3>
                  <input
				    type="text"
				    id="payrollSearch"
				    placeholder="Search by staff name"
				    class="search-input"
				  />
                </div>

                <div class="table-responsive">
                  <table class="payroll-table">
                    <thead>
                      <tr>
                        <th>Staff Name</th>
                        <th>Month</th>
                        <th>Basic Salary</th>
                        <th>Deduction</th>
                        <th>Bonus</th>
                        <th>Net Salary</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody id="payrollTableBody">
                      <c:forEach var="payroll" items="${payrollList}">
                        <tr
                          data-id="${payroll.id}"
                          data-employee-id="${payroll.userId}"
                          data-month="${payroll.month}"
                          data-basic="${payroll.basicSalary}"
                          data-deductions="${payroll.deductions}"
                          data-bonus="${payroll.bonus}"
                        >
                          <td>${payroll.employeeName}</td>
                           <fmt:parseDate value="${payroll.month}-01" var="parsedMonth" pattern="yyyy-MM-dd" />
						   <td><fmt:formatDate value="${parsedMonth}" pattern="MMMM yyyy" /></td>

                          <td>$${payroll.basicSalary}</td>
                          <td>$${payroll.deductions}</td>
                          <td>$${payroll.bonus}</td>
                          <td>
                            $${payroll.basicSalary - payroll.deductions +
                            payroll.bonus}
                          </td>
                          <td>
                            <div class="action-buttons">
                              <button
                                class="edit-btn"
                                onclick="editPayroll(this.closest('tr'))"
                              >
                                <i class="fas fa-edit"></i>
                              </button>
                              <form
                                action="payroll"
                                method="post"
                                style="display: inline"
                                onsubmit="return confirmDelete()"
                              >
                                <input
                                  type="hidden"
                                  name="action"
                                  value="delete"
                                />
                                <input
                                  type="hidden"
                                  name="id"
                                  value="${payroll.id}"
                                />
                                <button type="submit" class="delete-btn">
                                  <i class="fas fa-trash-alt"></i>
                                </button>
                              </form>
                            </div>
                          </td>
                        </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </section>
      </main>
    </div>

    <script>
      // Function to confirm deletion
      function confirmDelete() {
        return confirm("Are you sure you want to delete this payroll record?");
      }

      const basicSalaryInput = document.getElementById("basicSalary");
      const employeeSelect = document.getElementById("employeeSelect");
      
      employeeSelect.addEventListener("change", function () {
          const selectedOption = this.options[this.selectedIndex];
          const salary = selectedOption.getAttribute("data-salary");

          if (salary) {
            basicSalaryInput.value = salary;
          } else {
            basicSalaryInput.value = "";
          }
      });
      
      // Function to edit payroll
      function editPayroll(row) {
        // Get data from row
        const id = row.dataset.id;
        const employeeId = row.getAttribute("data-employee-id");
        const month = row.dataset.month;
        const basicSalary = row.dataset.basic;
        const deductions = row.dataset.deductions;
        const bonus = row.dataset.bonus;

        // Set form values
        document.getElementById("payrollForm").action = "payroll";
        document.querySelector('#payrollForm input[name="action"]').value =
          "update";

        const employeeSelect = document.getElementById("employeeSelect");
        

        // Add hidden id field
        let idField = document.querySelector('#payrollForm input[name="id"]');
        if (!idField) {
          idField = document.createElement("input");
          idField.type = "hidden";
          idField.name = "id";
          document.getElementById("payrollForm").appendChild(idField);
        }
        idField.value = id;

        // Set other form values
        document.getElementById("employeeSelect").value = employeeId;
        document.getElementById("month").value = month;
        document.getElementById("basicSalary").value = basicSalary;
        document.getElementById("deductions").value = deductions;
        document.getElementById("bonus").value = bonus;

        // Update form title and button text
        document.querySelector(".form-title").textContent =
          "Edit Payroll Record";
        document.querySelector(".submit-btn").innerHTML =
          '<i class="fas fa-save"></i> Update';

        // Scroll to form
        document
          .querySelector(".payroll-form")
          .scrollIntoView({ behavior: "smooth" });
      }
      
      document.addEventListener("DOMContentLoaded", function () {
    	    const monthInput = document.getElementById("month");
    	    const today = new Date();
    	    
    	    // Set to last day of previous month
    	    const prevMonth = new Date(today.getFullYear(), today.getMonth(), 0);
    	    const formatted = prevMonth.toISOString().slice(0, 7); // format YYYY-MM
    	    
    	    monthInput.max = formatted;
    	  });
      
      function validateDeductions() {
    	    const basicSalary = parseFloat(document.getElementById("basicSalary").value);
    	    const deductions = parseFloat(document.getElementById("deductions").value);

    	    if (deductions > basicSalary - 5000) {
    	      alert("Deductions cannot be more than Basic Salary.");
    	      document.getElementById("deductions").value = "";
    	      return false;
    	    }
    	    return true;
    	  }

    	  // Attach event listener to deductions field
    	  window.onload = function () {
    	    document.getElementById("deductions").addEventListener("input", validateDeductions);
    	  };
    	  
    	// Filter payroll table rows based on search input
    	  document.getElementById("payrollSearch").addEventListener("input", function () {
    	    const filter = this.value.toLowerCase();
    	    const rows = document.querySelectorAll("#payrollTableBody tr");

    	    rows.forEach((row) => {
    	      const name = row.cells[0].textContent.toLowerCase();
    	      const month = row.cells[1].textContent.toLowerCase();
    	      row.style.display = name.includes(filter) || month.includes(filter) ? "" : "none";
    	    });
    	  });

    </script>

   
  </body>
</html>
