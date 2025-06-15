package controller;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.AttendanceDAO;
import model.Attendance;


@SuppressWarnings("serial")
@WebServlet("/attendance-approve")
public class AttendanceApproveServlet extends HttpServlet {
	private AttendanceDAO attendanceDAO;

    public void init() {
        attendanceDAO = new AttendanceDAO();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String filterStatus = request.getParameter("status");
        System.out.println("status" + filterStatus);
        
        if (filterStatus == null || filterStatus.isEmpty()) {
            filterStatus = "Pending";
        }

        List<Attendance> attendanceList;
        
		attendanceList = attendanceDAO.getAttendanceByStatus(filterStatus);
        request.setAttribute("pendingAttendance", attendanceList);
        request.setAttribute("selectedStatus", filterStatus);
        request.setAttribute("pendingAttendance", attendanceList);

        RequestDispatcher dispatcher = request.getRequestDispatcher("views/AttendanceApprove.jsp");
        dispatcher.forward(request, response);
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    int attendanceId = Integer.parseInt(request.getParameter("attendanceId"));
	    String action = request.getParameter("action");

	    String newStatus = action.equals("approve") ? "Approved" : "Rejected";
	    attendanceDAO.updateAttendanceStatus(attendanceId, newStatus);

	    response.sendRedirect(request.getContextPath() + "/attendance-approve");
	}

}
