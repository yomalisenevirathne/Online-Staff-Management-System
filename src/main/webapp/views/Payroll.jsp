<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>My Payroll</title>
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
        <a href="${pageContext.request.contextPath}/payroll" class="nav-link active"><i class="fas fa-dollar-sign"></i> Payroll</a>
        <a href="${pageContext.request.contextPath}/attendance" class="nav-link "><i class="fas fa-clock"></i> Attendance</a>
        <a href="${pageContext.request.contextPath}/leave" class="nav-link"><i class="fas fa-calendar-alt"></i> Leave Request</a>
        <a href="${pageContext.request.contextPath}/views/login.jsp" class="nav-link"><i class="fas fa-sign-out-alt"></i> Log out</a>
        </nav>
      </aside>

      <!-- Main content -->
      <main class="main-content">
        <!-- Top bar -->


        <!-- Content -->
        <section class="content-section">
          <div class="content-card">
            <div class="card-header">
              <h2 class="card-title">Payroll Details</h2>
              <p class="card-subtitle">
                View your monthly payroll records below.
              </p>
            </div>
            <table class="payroll-table">
              <thead>
                <tr>
                    <th>Month</th>
				    <th>Year</th>
				    <th>Basic Salary</th>
				    <th>Bonus</th>
				    <th>Deductions</th>
				    <th>Net Salary</th>
				    <th>Payment Date</th>
				    <th>Status</th>
                </tr>
              </thead>
              <tbody>
               <tbody>
					  <c:forEach var="payroll" items="${payrollList}">
					    <tr>
					      <td>${payroll.month}</td>
					      <td>${payroll.year}</td>
					      <td>$${payroll.basicSalary}</td>
					      <td>$${payroll.bonus}</td>
					      <td>$${payroll.deductions}</td>
					      <td>
					        $<c:out value="${payroll.basicSalary + payroll.bonus - payroll.deductions}" />
					      </td>
					      <td>${payroll.paymentDate}</td>
					      <td>
					        <span class="status-badge generated">Generated</span>
					      </td>
					    </tr>
					  </c:forEach>
					</tbody>
              </tbody>
            </table>
          </div>
        </section>
      </main>
    </div>
  </body>
</html>
