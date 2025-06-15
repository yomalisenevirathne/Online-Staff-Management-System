package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;
import model.User;

@SuppressWarnings("serial")
@WebServlet("/admin")
public class AdminUserServlet extends HttpServlet {

	private UserDAO userDAO;

	// Initialize the UserDAO object when the servlet starts
	@Override
	public void init() {
		userDAO = new UserDAO();
	}

	// Handles form submissions (add, update, delete actions)
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");

		switch (action) {
		case "add":
			addUser(request); // Add a new user
			break;
		case "update":
			System.out.println("Do Post Passed 2");
			updateUser(request); // Update existing user
			break;
		case "delete":
			deleteUser(request); // Delete a user
			break;
		}
		response.sendRedirect("admin"); // Refresh page after action
	}

	// Handles requests to show the admin dashboard and to load a user for editing
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		// If updating, load the user data to edit
		if ("update".equals(action)) {
			int userId = Integer.parseInt(request.getParameter("editUserId"));
			User editUser = userDAO.getUserById(userId); // Get user by ID from database
			request.setAttribute("editUser", editUser); // Send user data to JSP
		}

		// Get all users to show in the dashboard
		List<User> userList = userDAO.getAllUsers();
		request.setAttribute("userList", userList);

		// Show the admin dashboard page
		RequestDispatcher dispatcher = request.getRequestDispatcher("views/admin_dashboard.jsp");
		dispatcher.forward(request, response);
	}

	// Add a new user using data from the form
	private void addUser(HttpServletRequest request) {
		User user = new User();

		user.setName(request.getParameter("name"));
		user.setEmail(request.getParameter("email"));
		user.setPosition(request.getParameter("position"));
		user.setContactno(request.getParameter("contactno"));
		user.setDepartment(request.getParameter("department"));
		user.setPassword(request.getParameter("password"));

		// Get and set salary and OT rate
		double salary = Double.parseDouble(request.getParameter("salary"));
		double otPerHour = Double.parseDouble(request.getParameter("OTperHour"));
		user.setSalary(salary);
		user.setOtPerHour(otPerHour);

		userDAO.addUser(user); // Save the user to the database
	}

	// Update user information using form data
	private void updateUser(HttpServletRequest request) {
		User user = new User();
		user.setId(Integer.parseInt(request.getParameter("editUserId")));
		user.setName(request.getParameter("name"));
		user.setEmail(request.getParameter("email"));
		user.setPosition(request.getParameter("position"));
		user.setContactno(request.getParameter("contactno"));
		user.setDepartment(request.getParameter("department"));
		user.setPassword(request.getParameter("password"));

		// Get and set salary and OT rate
		double salary = Double.parseDouble(request.getParameter("salary"));
		double otPerHour = Double.parseDouble(request.getParameter("OTperHour"));
		user.setSalary(salary);
		user.setOtPerHour(otPerHour);

		userDAO.updateUser(user); // Update user in the database
		request.setAttribute("editUser", user); // Optional: send updated user back to JSP
	}

	// Delete a user using their ID
	private void deleteUser(HttpServletRequest request) {
		int id = Integer.parseInt(request.getParameter("userId"));
		userDAO.deleteUser(id); // Delete user from database
	}
}
