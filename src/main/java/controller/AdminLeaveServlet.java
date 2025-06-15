package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.LeaveRequestDAO;
import model.LeaveRequest;


@SuppressWarnings("serial")
@WebServlet("/Approve-Leave")
public class AdminLeaveServlet extends HttpServlet {

    private LeaveRequestDAO dao = new LeaveRequestDAO();   


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        String filterStatus = request.getParameter("status");
        if (filterStatus == null || filterStatus.isEmpty()) {
            filterStatus = "Pending";
        }

        List<LeaveRequest> leaveList = null;
		try {
			leaveList = dao.getLeaveRequestsByStatus(filterStatus);
		} catch (SQLException e) {
			
			e.printStackTrace();
		}
        request.setAttribute("leaveList", leaveList);
        request.setAttribute("selectedStatus", filterStatus);
        request.getRequestDispatcher("views/LeaveApplyAdmin.jsp").forward(request, response);
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int leaveId = Integer.parseInt(request.getParameter("leaveId"));
        String action = request.getParameter("action"); 
        String status = action.equals("approve") ? "Approved" : "Rejected";

        try {
            dao.updateLeaveStatus(leaveId, status);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("Approve-Leave"); 
    }

}
