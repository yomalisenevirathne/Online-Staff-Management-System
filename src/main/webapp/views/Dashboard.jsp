<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Dashboard | Task Minds</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/dashboard.css" />
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
          <a href="${pageContext.request.contextPath}/dashboard" class="nav-link active">
            <i class="fas fa-th-large"></i>
            Dashboard
          </a>

          <a href="${pageContext.request.contextPath}/admin" class="nav-link " aria-current="page">
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
            class="nav-link"
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
        <!-- Top bar -->
        <header class="top-bar">
          <div>
            <h1 class="page-title">Dashboard</h1>
            <p class="card-subtitle">
              Overview of your organization's key metrics
            </p>
          </div>

        </header>

        <!-- Content -->
        <section class="content-section">
          <!-- Stats Overview -->
          <div class="dashboard-grid">
            <!-- Total Employees -->
            <div class="stat-card">
              <div class="stat-decoration" style="color: #3b82f6"></div>
              <div class="stat-header">
                <h3 class="stat-title">TOTAL STAFF</h3>
                <div class="stat-icon bg-blue">
                  <i class="fas fa-users"></i>
                </div>
              </div>
              <p class="stat-value">${totalEmployees}</p>
              <div class="stat-change positive">
                <i class="fas fa-arrow-up"></i>
                <span>5% from last month</span>
              </div>
            </div>

            <!-- Pending Leave Requests -->
            <div class="stat-card">
              <div class="stat-decoration" style="color: #f59e0b"></div>
              <div class="stat-header">
                <h3 class="stat-title">PENDING LEAVES</h3>
                <div class="stat-icon bg-orange">
                  <i class="fas fa-calendar-alt"></i>
                </div>
              </div>
              <p class="stat-value">${pendingLeaves}</p>
              <div class="stat-change positive">
                <i class="fas fa-arrow-down"></i>
                <span>12% from last month</span>
              </div>
            </div>

            <!-- Attendance Today -->
            <div class="stat-card">
              <div class="stat-decoration" style="color: #10b981"></div>
              <div class="stat-header">
                <h3 class="stat-title">TODAY'S ATTENDANCE</h3>
                <div class="stat-icon bg-green">
                  <i class="fas fa-clock"></i>
                </div>
              </div>
              <p class="stat-value">${todayAttendance}%</p>
              <div class="stat-change positive">
                <i class="fas fa-arrow-up"></i>
                <span>3% from yesterday</span>
              </div>
            </div>

            <!-- Payroll Processed -->
            <div class="stat-card">
              <div class="stat-decoration" style="color: #8b5cf6"></div>
              <div class="stat-header">
                <h3 class="stat-title">TOTAL PAYROLL</h3>
                <div class="stat-icon bg-purple">
                  <i class="fas fa-dollar-sign"></i>
                </div>
              </div>
              <p class="stat-value">$${totalPayroll}</p>
              <div class="stat-change positive">
                <i class="fas fa-arrow-up"></i>
                <span>8% from last month</span>
              </div>
            </div>
          </div>

          <!-- Model Lists (replacing charts) -->
          <div class="lists-grid">
            <!-- Employee List with Leave Categories Panel -->
            <div class="list-container">
              <!-- Right side: Leave Categories Panel -->
              <div class="leave-categories-panel">
                <h4 class="panel-title">Leave Categories</h4>

                <div class="category-cards">
                  <!-- Annual Leave -->
                  <div class="category-card">
                    <div class="category-icon bg-blue">
                      <i class="fas fa-plane-departure"></i>
                    </div>
                    <div class="category-details">
                      <div class="category-name">Annual Leave</div>
                      <div class="category-count">
                        ${annualLeaveCount != null ? annualLeaveCount : 45}
                      </div>
                    </div>
                  </div>

                  <!-- Sick Leave -->
                  <div class="category-card">
                    <div class="category-icon bg-orange">
                      <i class="fas fa-briefcase-medical"></i>
                    </div>
                    <div class="category-details">
                      <div class="category-name">Sick Leave</div>
                      <div class="category-count">
                        ${sickLeaveCount != null ? sickLeaveCount : 28}
                      </div>
                    </div>
                  </div>

                  <!-- Casual Leave -->
                  <div class="category-card">
                    <div class="category-icon bg-green">
                      <i class="fas fa-coffee"></i>
                    </div>
                    <div class="category-details">
                      <div class="category-name">Casual Leave</div>
                      <div class="category-count">
                        ${casualLeaveCount != null ? casualLeaveCount : 15}
                      </div>
                    </div>
                  </div>

                  <!-- Unpaid Leave -->
                  <div class="category-card">
                    <div class="category-icon bg-purple">
                      <i class="fas fa-hourglass-half"></i>
                    </div>
                    <div class="category-details">
                      <div class="category-name">Unpaid Leave</div>
                      <div class="category-count">
                        ${unpaidLeaveCount != null ? unpaidLeaveCount : 7}
                      </div>
                    </div>
                  </div>
                </div>

                <div class="panel-footer">
                  <a href="${pageContext.request.contextPath}/Approve-Leave" class="view-all-link">
                    <i class="fas fa-chart-pie"></i> View Details
                  </a>
                </div>
              </div>

              <div class="monthly-payroll-scroll-container">
                <div class="monthly-payroll-container">
                  <!-- Current Year Months -->
                  <c:forEach
                    var="payrollMonth"
                    items="${monthlyPayrolls}"
                    varStatus="status"
                  >
                  </c:forEach>

                  <!-- Fallback data if no monthly payrolls from backend -->
                  <c:if test="${empty monthlyPayrolls}">
                    <div class="month-payroll-card">
                      <div class="month-name">May 2025</div>
                      <div class="month-amount">$87,650</div>
                      <div class="month-indicator">
                        <div class="indicator-bar" style="width: 95%"></div>
                      </div>
                      <div class="month-comparison positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>5% from previous</span>
                      </div>
                    </div>

                    <div class="month-payroll-card">
                      <div class="month-name">April 2025</div>
                      <div class="month-amount">$83,500</div>
                      <div class="month-indicator">
                        <div class="indicator-bar" style="width: 90%"></div>
                      </div>
                      <div class="month-comparison positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>3% from previous</span>
                      </div>
                    </div>

                    <div class="month-payroll-card">
                      <div class="month-name">March 2025</div>
                      <div class="month-amount">$81,050</div>
                      <div class="month-indicator">
                        <div class="indicator-bar" style="width: 87%"></div>
                      </div>
                      <div class="month-comparison positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>2% from previous</span>
                      </div>
                    </div>

                    <div class="month-payroll-card">
                      <div class="month-name">February 2025</div>
                      <div class="month-amount">$79,450</div>
                      <div class="month-indicator">
                        <div class="indicator-bar" style="width: 85%"></div>
                      </div>
                      <div class="month-comparison negative">
                        <i class="fas fa-arrow-down"></i>
                        <span>1% from previous</span>
                      </div>
                    </div>

                    <div class="month-payroll-card">
                      <div class="month-name">January 2025</div>
                      <div class="month-amount">$80,250</div>
                      <div class="month-indicator">
                        <div class="indicator-bar" style="width: 86%"></div>
                      </div>
                      <div class="month-comparison positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>4% from previous</span>
                      </div>
                    </div>

                    <div class="month-payroll-card">
                      <div class="month-name">December 2024</div>
                      <div class="month-amount">$76,940</div>
                      <div class="month-indicator">
                        <div class="indicator-bar" style="width: 82%"></div>
                      </div>
                      <div class="month-comparison positive">
                        <i class="fas fa-arrow-up"></i>
                        <span>2% from previous</span>
                      </div>
                    </div>
                  </c:if>
                </div>
               </div>
            </div>
          </div>
        </section>
      </main>
    </div>
  </body>
</html>
