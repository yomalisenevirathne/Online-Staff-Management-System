<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 <%
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>


<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Attendance Apply</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/attendance.css" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" />



   <script>
		 <% if (error != null) { %>
		 alert("<%= error %>");
		<% } else if (message != null) { %>
		 alert("<%= message %>");
		<% } %>

      document.addEventListener("DOMContentLoaded", function () {
        const startDateInput = document.getElementById("startDate");
        const filterBtn = document.getElementById("filterBtn");
        
        //Set Date input Validation
        const today = new Date().toISOString().split('T')[0];
        document.getElementById('startDate').setAttribute('max', today);


        function formatDate(date) {
          return date.toISOString().split("T")[0];
        }

        filterBtn.addEventListener("click", () => {
          const startVal = startDateInput.value;

          if (!startVal) {
        	  alert("Please select a date.");
        	  return;
        	}


          const url =
            "${pageContext.request.contextPath}/attendance?startDate=" +
            encodeURIComponent(startVal) +
            "&endDate=" +
            encodeURIComponent(startVal);

          window.location.href = url;
        });
        
        
        //Delete Java Script Function
        const deleteButtons = document.querySelectorAll(".delete-btn");
        
        deleteButtons.forEach((btn) => {
          btn.addEventListener("click", function (e) {
            const confirmed = confirm(
              "Are you sure you want to delete this leave request?"
            );
            if (confirmed) {
              const leaveId = this.dataset.id;
              window.location.href = '<c:url value="/attendance"/>' + '?action=delete&id=' + leaveId;
            } else {
              e.preventDefault();
            }
          });
        });

      });
     
      


      
      document.addEventListener("DOMContentLoaded", function () {
    	    const form = document.getElementById("attendanceForm");

    	    form.addEventListener("submit", function (e) {
    	      const rows = document.querySelectorAll("#attendanceTableBody tr");
    	      let valid = true;

    	      rows.forEach((row) => {
    	        const inTimeInput = row.querySelector('input[name^="inTime-"]');
    	        const outTimeInput = row.querySelector('input[name^="outTime-"]');

    	        const inTime = inTimeInput.value;
    	        const outTime = outTimeInput.value;

    	        if (!inTime || !outTime) {
    	          alert("Both In Time and Out Time must be filled.");
    	          valid = false;
    	          e.preventDefault();
    	          return;
    	        }

    	        if (inTime >= outTime) {
    	          alert("In Time must be before Out Time.");
    	          valid = false;
    	          e.preventDefault();
    	          return;
    	        }
    	      });

    	      if (!valid) {
    	        e.preventDefault(); // Block form submission if invalid
    	      }
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
        <a href="${pageContext.request.contextPath}/payroll" class="nav-link"><i class="fas fa-dollar-sign"></i> Payroll</a>
        <a href="${pageContext.request.contextPath}/attendance" class="nav-link active"><i class="fas fa-clock"></i> Attendance</a>
        <a href="${pageContext.request.contextPath}/leave" class="nav-link"><i class="fas fa-calendar-alt"></i> Leave Request</a>
        <a href="${pageContext.request.contextPath}/views/login.jsp" class="nav-link"><i class="fas fa-sign-out-alt"></i> Log out</a>
      </nav>
    </aside>

    <!-- Main content -->
    <main class="main-content">


      <section class="content-section">
        <div class="content-card">
		<div class="card-header">
		  <h2 class="card-title">Apply Attendance</h2>
		  <p class="card-subtitle">Select a date range and enter in/out times for each day.</p>
		</div>


          <!-- Date Filter -->
           <div class="filter-group">
			  <div class="form-group">
			    <label for="startDate" class="form-label">Select Date</label>
			    <input type="date" id="startDate" name="startDate"
			      value="${startDate != null ? startDate : ''}" />
			  </div>
			  <button id="filterBtn" class="submit-btn">Filter</button>
			</div>

          <!-- Attendance Table -->
          <form id="attendanceForm" class="attendance-form" method="post" action="${pageContext.request.contextPath}/attendance">
            <table class="attendance-table">
              <thead>
                <tr>
                  <th>Date</th>
                  <th>In Time</th>
                  <th>Out Time</th>
                  <th>Status</th>
                  <th>Actions</th>
                </tr>
              </thead>
				<tbody id="attendanceTableBody">
                                <!-- Ensure Attendance List is not empty -->
                                <c:if test="${empty AttendanceList}">
                                    <tr><td colspan="4">No attendance records found.</td></tr>
                                </c:if>
                                
                                <!-- Loop through the Attendance List -->
                                <c:forEach var="attendance" items="${AttendanceList}">
                                    <tr>
                                        <td>${attendance.date}</td>
                                        <td>
                                        <input type="hidden" name="date-${attendance.date}" value="${attendance.date}" />
                                            <input type="time" name="inTime-${attendance.date}" 
                                                   value="${attendance.inTime != null ? attendance.inTime : ''}" />
                                        </td>
                                        <td>
                                            <input type="time" name="outTime-${attendance.date}" 
                                                   value="${attendance.outTime != null ? attendance.outTime : ''}" />
                                        </td>
                                        <td>
                                            <input type="text" name="status-${attendance.date}" 
                                                   value="${attendance.status != null ? attendance.status : 'Pending'}" readonly />
                                        </td>
                                        <td>
                                         <input type="hidden" name="id" value="${attendance.id}" />
										     <input type="hidden" name="action" value="delete" />
										      <button
										        type=button
										        class="delete-btn"
										        data-id="${attendance.id}"
										      >
										        <i class="fas fa-trash-alt"></i>
										      </button>
										</td>

                                    </tr>
                                </c:forEach>
                            </tbody>
					</table>

            <div class="form-group">
              <label for="remark" class="form-label">Remark</label>
              <textarea id="remark" name="remark" class="form-input" placeholder="Add any remarks here..." required></textarea>
            </div>

            <div class="form-actions">
             <input type="hidden" name="action" value="submit" />
              <button type="submit" class="submit-btn">Submit</button>
            </div>
          </form>
        </div>
      </section>
    </main>
  </div>
</body>
</html>
