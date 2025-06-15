<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Attendance Approve</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/attendance.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
    />
    <script>
    document.addEventListener("DOMContentLoaded", function () {
	  	document.getElementById("filterBtn").addEventListener("click", function () {
	    var filterName = document.getElementById("filterName").value.toLowerCase();
	    var table = document.querySelector(".attendance-table tbody");
	    var rows = table.getElementsByTagName("tr");
	    const clearBtn = document.getElementById("clearBtn");
	    
	
	    // Loop through all rows and hide the ones that don't match the filter
	    for (var i = 0; i < rows.length; i++) {
	      var nameCell = rows[i].getElementsByTagName("td")[0]; // The first column (Employee Name)
	      if (nameCell) {
	        var employeeName = nameCell.textContent || nameCell.innerText;
	        if (employeeName.toLowerCase().indexOf(filterName) > -1) {
	          rows[i].style.display = ""; // Show row
	        } else {
	          rows[i].style.display = "none"; // Hide row
	        }
	      }
	      
	      var filterDate = document.getElementById("filterDate").value; // Get date value
		    if (filterDate) {
		      var dateCell = rows[i].getElementsByTagName("td")[1]; // The second column (Date)
		      var rowDate = dateCell.textContent || dateCell.innerText;
		      if (rowDate !== filterDate) {
		        rows[i].style.display = "none"; // Hide row if date doesn't match
		      }
		    }
	    	}
	  	});
	  	
	  	clearBtn.addEventListener("click", function () {
	  		const filterInput = document.getElementById("filterName");
	  		const rows = document.querySelectorAll(".attendance-table tbody tr");
	        filterInput.value = ""; // Clear the input
	        rows.forEach(function (row) {
	          row.style.display = ""; // Show all rows
	        });
	      });
    });
</script>
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
          <a href="${pageContext.request.contextPath}/payroll" class="nav-link">
			 <i class="fas fa-dollar-sign"></i>
			Payroll
		  </a>	
          <a href="${pageContext.request.contextPath}/attendance-approve" class="nav-link active" aria-current="page">
            <i class="fas fa-clock"></i>
            Attendance
          </a>
          <a href="${pageContext.request.contextPath}/leave" class="nav-link ">
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


      <!-- Main content -->
      <main class="main-content">
        <!-- Content -->
        <section class="content-section">
          <div class="content-card">
            <div class="card-header">
              <h2 class="card-title">Approve Attendance Records</h2>
            </div>

            <!-- Filter Options -->
            <div class="filter-container">
              <div class="form-group">
                <label for="filterName" class="form-label"
                  >Filter by Employee Name</label
                >
                <input
                  type="text"
                  id="filterName"
                  class="form-input"
                  placeholder="Enter employee name..."
                />
              </div>
              <div class="form-group">
                <label for="filterDate" class="form-label"
                  >Filter by Date</label
                >
                <input type="date" id="filterDate" class="form-input" />
              </div>
              <div class="button-group">
                <button id="filterBtn" class="submit-btn">Apply Filter</button>
                <button id="clearBtn" class="clear-btn">Clear Filter</button>
              </div>
              

            <form method="get" action="attendance-approve" class="filter-form">
             <div class="form-group">
                <label for="statusFilter" class="form-label">Filter by Date</label>
                	<select name="status" id="statusFilter" onchange="this.form.submit()" class="form-select">
					  <option value="All" ${selectedStatus == 'All' ? 'selected' : ''}>All</option>
					  <option value="Pending" ${selectedStatus == 'Pending' ? 'selected' : ''}>Pending</option>
					  <option value="Approved" ${selectedStatus == 'Approved' ? 'selected' : ''}>Approved</option>
					  <option value="Rejected" ${selectedStatus == 'Rejected' ? 'selected' : ''}>Rejected</option>
					</select>
              </div>
            </form>

            </div>
            </div>

            <table class="attendance-table">
              <thead>
                <tr>
                  <th>Employee Name</th>
                  <th>Date</th>
                  <th>In Time</th>
                  <th>Out Time</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="att" items="${pendingAttendance}">
                  <tr>
                    <td>${att.employeeName}</td>
                    <td>${att.date}</td>
                    <td>${att.inTime}</td>
                    <td>${att.outTime}</td>
                    <td>
                      <span class="status-badge pending">${att.status}</span>
                    </td>
                    <td class="actions-cell">
                      <c:choose>
				          <c:when test="${att.status == 'Pending'}">
				            <form method="post" action="attendance-approve">
				              <input type="hidden" name="attendanceId" value="${att.id}" />
				              <button class="action-btn approve-btn" name="action" value="approve">
				                <i class="fas fa-check"></i> Approve
				              </button>
				              <button class="action-btn reject-btn" name="action" value="reject">
				                <i class="fas fa-times"></i> Reject
				              </button>
				            </form>
				          </c:when>
				          <c:otherwise>
				            <!-- No action buttons for Approved/Rejected -->
				            <span class="text-muted">System ${att.status}</span>
				          </c:otherwise>
				        </c:choose>
                    </td>
                  </tr>
                </c:forEach>
              </tbody>
            </table>
          </div>
          
        </section>
      </main>
    </div>
  </body>
</html>
