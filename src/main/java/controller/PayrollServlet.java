package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dao.PayrollDAO;
import dao.UserDAO;
import model.Payroll;
import model.User;

@SuppressWarnings("serial")
@WebServlet("/payroll")
public class PayrollServlet extends HttpServlet {
	
	private PayrollDAO payrollDAO;
	private UserDAO UserDAO;

    @Override
    public void init() {
        payrollDAO = new PayrollDAO();
        UserDAO = new UserDAO(); // Initialize DAO objects
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	
    	// Get the current user from the session
    	HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // If no user is logged in, redirect to login page
        if (currentUser == null) {
		    response.sendRedirect("views/login.jsp");
		    return;
		}

        int userId = currentUser.getId(); // Get user ID
        String usertype = currentUser.getPosition(); // Get user role

        // If user is a manager, show payroll for all employees
		if (usertype != null && usertype.toLowerCase().equals("manager")) { 
			List<Payroll> payrolls = payrollDAO.getAllPayrolls(); // Get all payroll records
			List<User> employeeList = UserDAO.getAllUsers(); // Get all employees

			request.setAttribute("payrollList", payrolls);
			request.setAttribute("user_Id", userId);
			request.setAttribute("employeeList", employeeList);

			// Forward to admin payroll page
			RequestDispatcher dispatcher = request.getRequestDispatcher("views/PayrollAdmin.jsp");
			dispatcher.forward(request, response);

		} else { // If user is an employee, show only their payroll
			List<Payroll> payrolls = payrollDAO.getPayrollsByUserId(userId);
			request.setAttribute("payrollList", payrolls);

			// Forward to employee payroll page
			RequestDispatcher dispatcher = request.getRequestDispatcher("views/Payroll.jsp");
			dispatcher.forward(request, response);
		}
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action"); // Get action from form (add, update, delete)
    	HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        int userId = currentUser.getId();

        try {
            // Check which action is requested and call the respective method
            switch (action) {
                case "add":
                    addPayroll(request); // Add new payroll
                    break;
                case "update":
                    updatePayroll(request); // Update existing payroll
                    break;
                case "delete":
                    deletePayroll(request); // Delete payroll
                    break;
                default:
                    System.out.println("Unknown action: " + action);
            }

        } catch (NumberFormatException e) {
            System.out.println("Error parsing number: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("Unexpected error: " + e.getMessage());
            e.printStackTrace();
        }

        // After action, redirect back to the payroll page
        response.sendRedirect("payroll");
    }

    // Method to add a new payroll entry
    private void addPayroll(HttpServletRequest request) {
        String month = request.getParameter("month");
        int userID = Integer.parseInt(request.getParameter("employee_id"));
        double Basic_Salary = Double.parseDouble(request.getParameter("basic_salary"));
        double Deduction = Double.parseDouble(request.getParameter("deductions"));
        double bonus = Double.parseDouble(request.getParameter("bonus"));

        Payroll payroll = new Payroll();
        payroll.setUserId(userID);
        payroll.setMonth(month);
        payroll.setYear(Integer.parseInt(month.split("-")[0])); // Extract year from month string
        payroll.setBasicSalary(Basic_Salary);
        payroll.setDeductions(Deduction);
        payroll.setBonus(bonus);
        payroll.setStatus("Generated"); // Set default status

        payrollDAO.addPayroll(payroll); // Save to database
    }

    // Method to delete a payroll entry
    private void deletePayroll(HttpServletRequest request) {
        int id = Integer.parseInt(request.getParameter("id"));
        payrollDAO.deletePayroll(id); // Remove from database
    }

    // Method to update an existing payroll entry
    private void updatePayroll(HttpServletRequest request) {
        String month = request.getParameter("month");
        int payrollId = Integer.parseInt(request.getParameter("id"));
        double basicSalary = Double.parseDouble(request.getParameter("basic_salary"));
        double deductions = Double.parseDouble(request.getParameter("deductions"));
        double bonus = Double.parseDouble(request.getParameter("bonus"));
        int EmployeeID = Integer.parseInt(request.getParameter("employee_id"));

        Payroll payroll = new Payroll();
        payroll.setId(payrollId);
        payroll.setMonth(month);
        payroll.setYear(Integer.parseInt(month.split("-")[0])); // Extract year from month string
        payroll.setBasicSalary(basicSalary);
        payroll.setDeductions(deductions);
        payroll.setBonus(bonus);
        payroll.setUserId(EmployeeID);

        payrollDAO.updatePayroll(payroll); // Update in database
    }
}
