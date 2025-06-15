package controller;

import dao.LeaveRequestDAO;
import model.LeaveRequest;
import model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.*;

@SuppressWarnings("serial")
@WebServlet("/leave")
public class LeaveServlet extends HttpServlet {
    private LeaveRequestDAO dao;

    public void init() {
    	dao = new LeaveRequestDAO();
       
    }


	@SuppressWarnings("unused")
	@Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	HttpSession session = request.getSession();
    	User currentUser = (User) session.getAttribute("currentUser");
    	String action = request.getParameter("action");
    	String usertype = currentUser.getPosition();
    	
    	int employeeId;
    	
    	if (currentUser != null) {
    	    employeeId = currentUser.getId(); 
    	} else {
    	    response.sendRedirect("views/login.jsp");
    	    return;
    	}
    	
    	if ("delete".equalsIgnoreCase(action)) {
        	int leaveId = Integer.parseInt(request.getParameter("id"));
    		try {
				dao.deleteLeaveRequest(leaveId);
				
				List<LeaveRequest> leaveList = dao.getLeavesByUser(employeeId);
				request.setAttribute("id", employeeId);
		        request.setAttribute("leaveList", leaveList);

		        RequestDispatcher dispatcher = request.getRequestDispatcher("views/LeaveApply.jsp");
		        dispatcher.forward(request, response);
			} catch (SQLException e) {
				e.printStackTrace();
			}
        } 

    	if (usertype != null && usertype.toLowerCase().equals("manager")) { 
    		
    		String statusFilter = request.getParameter("status");
    		List<LeaveRequest> leaveList = null;
    		try {
	    		if (statusFilter == null || statusFilter.equals("All")) {
	    	        leaveList = dao.getAllRequests();
	    	    } else {
	    	        leaveList = dao.getLeaveRequestsByStatus(statusFilter);
	    	    }

			} catch (SQLException e) {
	
				e.printStackTrace();
			}
    		
    		request.setAttribute("id", employeeId);
            request.setAttribute("leaveList", leaveList);
            request.setAttribute("selectedStatus", statusFilter); 

            
            RequestDispatcher dispatcher = request.getRequestDispatcher("views/LeaveApplyAdmin.jsp");
            dispatcher.forward(request, response);
		}else
		{
    		List<LeaveRequest> leaveList = dao.getLeavesByUser(employeeId);
    		request.setAttribute("id", employeeId);
            request.setAttribute("leaveList", leaveList);
            RequestDispatcher dispatcher = request.getRequestDispatcher("views/LeaveApply.jsp");
            dispatcher.forward(request, response);
		}
		

    }

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String action = request.getParameter("action");
        System.out.println("Action received: " + action);
        int id = Integer.parseInt(request.getParameter("employee_id"));
        System.out.println("employee_id: " + id );
        

        try {
            if ("apply".equals(action)) {
           
                LeaveRequest lr = new LeaveRequest();
                lr.setStaffId(Integer.parseInt(request.getParameter("employee_id")));
                lr.setStartDate(Date.valueOf(request.getParameter("startDate")));
                lr.setEndDate(Date.valueOf(request.getParameter("endDate")));
                lr.setType(request.getParameter("leaveType"));
                lr.setReason(request.getParameter("remark"));
                lr.setStatus("Pending");
                dao.insertLeaveRequest(lr);

            } else if ("update".equals(action)) {
                int leaveId = Integer.parseInt(request.getParameter("id"));
                LeaveRequest lr = new LeaveRequest();
                lr.setId(leaveId);
                lr.setStaffId(Integer.parseInt(request.getParameter("employee_id")));
                lr.setStartDate(Date.valueOf(request.getParameter("startDate")));
                lr.setEndDate(Date.valueOf(request.getParameter("endDate")));
                lr.setType(request.getParameter("leaveType"));
                lr.setReason(request.getParameter("remark"));
                lr.setStatus("Pending");
                dao.updateLeaveRequest(lr);
   
            } else if ("approve".equals(action) || "reject".equals(action)) {
                // Debug: Log status update action
                System.out.println("Leave request status update: " + action);


                String status = action.equals("approve") ? "Approved" : "Rejected";

                // Debug: Log the ID and the status that is being updated
                System.out.println("Leave request ID: " + id);
                System.out.println("New status: " + status);

                dao.updateLeaveStatus(id, status);
                System.out.println("Leave request status updated successfully.");
                
            } 

        } catch (Exception e) {
            // Debug: Log the exception
            e.printStackTrace();
            System.out.println("An error occurred while processing the leave request: " + e.getMessage());
        }

        
        List<LeaveRequest> leaveList = dao.getLeavesByUser(id);
        request.setAttribute("id", id);
        request.setAttribute("leaveList", leaveList);
        
        for (LeaveRequest lr : leaveList) {
            System.out.println("Leave ID: " + lr.getId() + ", Type: " + lr.getType() +
                ", Start: " + lr.getStartDate() + ", End: " + lr.getEndDate() +
                ", Status: " + lr.getStatus());
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("views/LeaveApply.jsp");
        dispatcher.forward(request, response);
    }

}
