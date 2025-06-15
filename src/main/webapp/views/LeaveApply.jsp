<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Leave Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/leave.css" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css"
    />
    
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        // Get the current date in YYYY-MM-DD format
        const currentDate = new Date().toISOString().split("T")[0];

        // Set the minimum date for both start and end date
        document.getElementById("startDate").setAttribute("min", currentDate);
        document.getElementById("endDate").setAttribute("min", currentDate);

        // Validate end date on change (ensure it's after the start date)
        document
          .getElementById("startDate")
          .addEventListener("change", function () {
            const startDate = document.getElementById("startDate").value;
            const endDate = document.getElementById("endDate").value;

            if (startDate > endDate) {
              document.getElementById("endDate").value = "";
            }
            document.getElementById("endDate").setAttribute("min", startDate);
          });

        const editButtons = document.querySelectorAll(".edit-btn");
        const submitBtn = document.getElementById("submitBtn");
        const cancelBtn = document.getElementById("cancelBtn");
        const form = document.getElementById("leaveForm");

        editButtons.forEach((btn) => {
          btn.addEventListener("click", function () {
            document.getElementById("leaveId").value = this.dataset.id;
            document.getElementById("leaveType").value = this.dataset.type;
            document.getElementById("startDate").value = this.dataset.start;
            document.getElementById("endDate").value = this.dataset.end;
            document.getElementById("remark").value = this.dataset.reason;

            // Optional: Change the form action to update if needed

            document.querySelector("input[name='action']").value = "update";
            document.getElementById("leaveForm").action =
              "${pageContext.request.contextPath}/leave";
            submitBtn.textContent = "Update";
            cancelBtn.style.display = "inline-block";

            // Optional: Pass the ID in a hidden input for update
            if (!document.getElementById("leaveId")) {
              const hidden = document.createElement("input");
              hidden.type = "hidden";
              hidden.name = "id";
              hidden.id = "leaveId";
              document.getElementById("leaveForm").appendChild(hidden);
            }
            document.getElementById("leaveId").value = this.dataset.id;
          });

          cancelBtn.addEventListener("click", function () {
            form.reset(); // Clear fields
            document.querySelector("input[name='action']").value = "apply";
            submitBtn.textContent = "Submit";
            cancelBtn.style.display = "none";

            const leaveIdInput = document.getElementById("leaveId");
            if (leaveIdInput) leaveIdInput.remove();
          });
        });

        const deleteButtons = document.querySelectorAll(".delete-btn");
        deleteButtons.forEach((btn) => {
          btn.addEventListener("click", function (e) {
            const confirmed = confirm(
              "Are you sure you want to delete this leave request?"
            );
            if (confirmed) {
              const leaveId = this.dataset.id;
              window.location.href = '<c:url value="/leave"/>' + '?action=delete&id=' + leaveId;
            } else {
              e.preventDefault();
            }
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
        <a href="${pageContext.request.contextPath}/payroll" class="nav-link"><i class="fas fa-dollar-sign"></i> Payroll</a>
        <a href="${pageContext.request.contextPath}/attendance" class="nav-link "><i class="fas fa-clock"></i> Attendance</a>
        <a href="${pageContext.request.contextPath}/leave" class="nav-link active"><i class="fas fa-calendar-alt"></i> Leave Request</a>
        <a href="${pageContext.request.contextPath}/views/login.jsp" class="nav-link"><i class="fas fa-sign-out-alt"></i> Log out</a>
        </nav>
      </aside>

      <!-- Main content -->
      <main class="main-content">
        <!-- Content -->
        <section class="content-section">
          <div class="content-wrapper">
            <!-- Leave Requests Table -->
            <div class="leave-requests">
              <h2 class="table-title">My Leave Requests</h2>
              <table class="leave-table">
                <thead>
                  <tr>
                 	 <th>ID</th>
                    <th>Leave Type</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Action</th>
                  </tr>
                </thead>
                <tbody>
				  <c:forEach var="leave" items="${leaveList}">
				    <tr>
				    <td>${leave.id}</td>
				      <td>${leave.type}</td>
				      <td>${leave.startDate}</td>
				      <td>${leave.endDate}</td>
				      <td>${leave.reason}</td>
				      <td>
				        <span class="status-badge ${leave.status eq 'Approved' ? 'approved' : leave.status eq 'Rejected' ? 'rejected' : 'pending'}">
				          ${leave.status}
				        </span>
				      </td>
				      <td>
				      <div class="action-btn">
				        <button class="action-btn edit-btn"
						        data-id="${leave.id}"
						        data-type="${leave.type}"
						        data-start="${leave.startDate}"
						        data-end="${leave.endDate}"
						        data-reason="${leave.reason}">
						  		<i class="fas fa-edit"></i> Edit
						</button>
						<button type="button" class="action-btn delete-btn" data-id="${leave.id}">
						  <i class="fas fa-trash"></i> Delete
						</button>
						</div>
				      </td>
				    </tr>
				  </c:forEach>
				</tbody>
              </table>
            </div>

            <!-- Leave Application Form -->
            <div class="leave-form-container-user">
              <div class="card-header">
                <h2 class="card-title">Apply for Leave</h2>
              </div>
              <form
                id="leaveForm"
                class="leave-form"
                action="${pageContext.request.contextPath}/leave"
                method="POST"
              >
                <input type="hidden" name="action" id="action" value="apply" />
                <input type="hidden" name="id" id="leaveId" />
                
                <div class="form-group">
                  <label for="employeeName" class="form-label"
                    >Staff ID</label
                  >
                  <input
                    type="number"
                    id="employee_id"
                    name="employee_id"
                    required
                    readonly
                    class="form-input"
                    placeholder="John Smith"
                    value="${id}"
                  />
                </div>
                <div class="form-group">
                  <label for="leaveType" class="form-label">Leave Type</label>
                  <select
                    id="leaveType"
                    name="leaveType"
                    required
                    class="form-input"
                  >
                    <option value="" disabled selected>
                      Select leave type
                    </option>
                    <option>Annual Leave</option>
                    <option>Sick Leave</option>
                    <option>Casual Leave</option>
                  </select>
                </div>
                <div class="form-group">
                  <label for="startDate" class="form-label">Start Date</label>
                  <input
                    type="date"
                    id="startDate"
                    name="startDate"
                    required
                    class="form-input"
                  />
                </div>
                <div class="form-group">
                  <label for="endDate" class="form-label">End Date</label>
                  <input
                    type="date"
                    id="endDate"
                    name="endDate"
                    required
                    class="form-input"
                  />
                </div>
                <div class="form-group">
                  <label for="remark" class="form-label">Reason</label>
                  <input
                    type="text"
                    id="remark"
                    name="remark"
                    required
                    class="form-input"
                  />
                </div>
				<div class="form-actions">
				  <button type="button" id="cancelBtn" class="submit-btn" style="display: none; background-color: #ccc; color: black; margin-right: 10px;">
				    Cancel
				  </button>
				  <button type="submit" id="submitBtn" class="submit-btn">Submit</button>
				</div>
              </form>
            </div>
          </div>
        </section>
      </main>
    </div>
  </body>
</html>
