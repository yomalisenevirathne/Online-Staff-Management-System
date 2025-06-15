<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Leave Management (Admin)</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/leave.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
    />
    <script>
	  function confirmAction(form) {
	    const action = form.querySelector("button[type='submit'][clicked=true]").value;
	    const message = action === "approve"
	      ? "Are you sure you want to approve this leave request?"
	      : "Are you sure you want to reject this leave request?";
	
	    return confirm(message);
	  }
	
	  // Mark which button was clicked
	  document.querySelectorAll("form button[type='submit']").forEach(btn => {
	    btn.addEventListener("click", function () {
	      const buttons = this.closest("form").querySelectorAll("button[type='submit']");
	      buttons.forEach(b => b.removeAttribute("clicked"));
	      this.setAttribute("clicked", "true");
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

          <a href="${pageContext.request.contextPath}/admin" class="nav-link" aria-current="page">
            <i class="fas fa-user-friends"></i>
            Staff Management
          </a>

          <a href="${pageContext.request.contextPath}/payroll" class="nav-link">
            <i class="fas fa-dollar-sign"></i>
            Payroll
          </a>
          <a
            href="${pageContext.request.contextPath}/attendance-approve"
            class="nav-link"
          >
            <i class="fas fa-clock"></i>
            Attendance
          </a>
          <a
            href="${pageContext.request.contextPath}/Approve-Leave"
            class="nav-link active"
          >
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
        <header class="page-header">
          <h1 class="page-title">Leave Management</h1>
          <p class="page-subtitle">Review and manage staff leave requests</p>
        </header>

        <!-- Content -->
        <section class="content-section">
          <div class="content-card">
            <div class="card-header">
              <h2 class="card-title">Pending Leave Applications</h2>
              
              <div class="filter-container">
                <form method="get" action="leave" class="filter-form">
                  <div class="form-group inline">
                    <label for="statusFilter">Filter by Status:</label>
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
            
            <div class="table-container">
              <table class="leave-table">
                <thead>
                  <tr>
                    <th>staff</th>
                    <th>Leave Type</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="leave" items="${leaveList}">
                    <tr>
                      <td class="employee-cell">${leave.employeeName}</td>
                      <td>${leave.type}</td>
                      <td>${leave.startDate}</td>
                      <td>${leave.endDate}</td>
                      <td>
                        <span class="status-badge ${leave.status.toLowerCase()}">${leave.status}</span>
                      </td>
                      <td class="actions-cell">
                        <div class="action-buttons">
                          <c:choose>
						      <c:when test="${leave.status.toLowerCase() == 'approved' || leave.status.toLowerCase() == 'rejected'}">
						        <button class="action-btn no-action-btn" disabled>
						          <i class="fas fa-ban"></i> No Action
						        </button>
						      </c:when>
						      <c:otherwise>
						        <form method="post" action="Approve-Leave" class="inline-form" onsubmit="return confirmAction(this);">
						          <input type="hidden" name="leaveId" value="${leave.id}" />
						          <button type="submit" name="action" value="approve" class="action-btn approve-btn">
						            <i class="fas fa-check"></i> Approve
						          </button>
						          <button type="submit" name="action" value="reject" class="action-btn reject-btn">
						            <i class="fas fa-times"></i> Reject
						          </button>
						        </form>
						      </c:otherwise>
						    </c:choose>
                        </div>
                      </td>
                    </tr>
                  </c:forEach>
                  
                  <!-- Fallback empty state if no leave requests -->
                  <c:if test="${empty leaveList}">
                    <tr class="empty-state-row">
                      <td colspan="6">
                        <div class="empty-state">
                          <i class="fas fa-calendar-times empty-icon"></i>
                          <p>No leave requests found</p>
                        </div>
                      </td>
                    </tr>
                  </c:if>
                </tbody>
              </table>
            </div>
          </div>
        </section>
      </main>
    </div>
    
    <script>
      function confirmAction(form) {
        const action = form.querySelector('button[type="submit"]:focus').value;
        const actionText = action === 'approve' ? 'approve' : 'reject';
        return confirm(`Are you sure you want to ${actionText} this leave request?`);
      }
    </script>
  </body>
</html>
