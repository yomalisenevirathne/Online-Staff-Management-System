package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.AttendanceDAO;
import dao.LeaveRequestDAO;
import dao.PayrollDAO;
import dao.UserDAO;


@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    

    private UserDAO empDao = new UserDAO();
    private LeaveRequestDAO leaveDAO =new LeaveRequestDAO();
    private AttendanceDAO attendanceDAO = new AttendanceDAO();
    private PayrollDAO payrollDAO = new PayrollDAO();
    
    @Override
    public void init() throws ServletException {
       
    }
       
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Fetch dashboard statistics
        	System.out.println("Total Employee 1" );
            int totalEmployees = empDao.getTotalEmployees();
            System.out.println("Total Employee 2" );
            int pendingLeaves = leaveDAO.getPendingLeavesCount();
            System.out.println("Total Employee 3" );
            double todayAttendance = attendanceDAO.getTodayAttendancePercentage();
            System.out.println("Total Employee 4" );
            double totalPayroll = payrollDAO.getCurrentMonthTotalPayroll();
            System.out.println("Total Employee 5" + totalPayroll);
            
            
            // Fetch leave category counts
            int annualLeaveCount = leaveDAO.getLeaveCountByType("Annual Leave");
            System.out.println("Total Leave Count" + annualLeaveCount);
            int sickLeaveCount = leaveDAO.getLeaveCountByType("Sick Leave");
            int casualLeaveCount = leaveDAO.getLeaveCountByType("Casual Leave");
            int unpaidLeaveCount = leaveDAO.getLeaveCountByType("Unpaid Leave");
            
            // Fetch monthly payroll data
            //List<PayrollMonth> monthlyPayrolls = payrollDAO.getMonthlyPayrollsForCurrentYear();
            
            // Set attributes in request for JSP access
            System.out.println("Total Employee" + totalEmployees );
            request.setAttribute("totalEmployees", totalEmployees);
            request.setAttribute("pendingLeaves", pendingLeaves);
            request.setAttribute("todayAttendance", todayAttendance);
            request.setAttribute("totalPayroll", totalPayroll);
            
            request.setAttribute("annualLeaveCount", annualLeaveCount);
            request.setAttribute("sickLeaveCount", sickLeaveCount);
            request.setAttribute("casualLeaveCount", casualLeaveCount);
            request.setAttribute("unpaidLeaveCount", unpaidLeaveCount);
            
            //request.setAttribute("monthlyPayrolls", monthlyPayrolls);
            
            // Forward to the dashboard JSP page
            request.getRequestDispatcher("/views/Dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {

            getServletContext().log("Error loading dashboard data", e);
            request.setAttribute("errorMessage", "Failed to load dashboard data: " + e.getMessage());
            request.getRequestDispatcher("views/Dashboard.jsp").forward(request, response);
        }
    }
}