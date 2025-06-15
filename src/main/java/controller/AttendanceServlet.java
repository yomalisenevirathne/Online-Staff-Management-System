package controller;

import dao.AttendanceDAO;
import model.Attendance;
import model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@SuppressWarnings("serial")
@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {
	
	private AttendanceDAO AttendanceDAO;
	
    public void init() {
    	AttendanceDAO = new AttendanceDAO();
    }
	
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
    	HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        int userId = currentUser.getId();

        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        System.out.println("Dates : " + startDateStr + " | End Date :" + endDateStr);

       List<Attendance> fullAttendanceList = new ArrayList<>();
       List<Attendance> attendanceList;
       
        //Delete Method
        String Action = request.getParameter("action");
        if (Action != null && Action.equalsIgnoreCase("delete")) {

        	String idStr = request.getParameter("id");
        	
            if (idStr != null && !idStr.isEmpty()) {

                try {
                    int id = Integer.parseInt(idStr);
                    boolean deleted = AttendanceDAO.deleteById(id);
                    
                    if (deleted) {
                        request.setAttribute("message", "Deleted successfully");
                    } else {
                        request.setAttribute("error", "Delete failed");
                    }


                } catch (NumberFormatException e) {
                	System.out.println("NumberFormatException : " + e.getMessage());
                }
            }
        }

        // If date range is provided, fetch attendance records for that range
        if (startDateStr != null && endDateStr != null) {
            try {
            	LocalDate start = LocalDate.parse(startDateStr);
                LocalDate end = LocalDate.parse(endDateStr);

                attendanceList = AttendanceDAO.getAttendanceRange(userId,Date.valueOf(start), Date.valueOf(end));
                
                Map<LocalDate, Attendance> attendanceMap = attendanceList.stream()
                        .collect(Collectors.toMap(
                            att -> att.getDate().toLocalDate(),
                            att -> att	
                        ));

                    for (LocalDate date = start; !date.isAfter(end); date = date.plusDays(1)) {
                        if (attendanceMap.containsKey(date)) {
                            fullAttendanceList.add(attendanceMap.get(date));
                        } else {
                            // Add empty attendance for dates not in DB
                            Attendance empty = new Attendance();
                            empty.setDate(Date.valueOf(date));
                            empty.setUserId(userId);
                            empty.setStatus("Not Submitted");
                            fullAttendanceList.add(empty);
                        }
                    }
            } catch (IllegalArgumentException e) {
                attendanceList = new ArrayList<>();
            }
        } else {
            fullAttendanceList = AttendanceDAO.getAttendanceByUserId(userId);
        }

 
        // Set the attendance data as request attributes
        request.setAttribute("AttendanceList", fullAttendanceList);
        request.setAttribute("startDate", startDateStr);  // For pre-filling the form
        request.setAttribute("endDate", endDateStr);      // For pre-filling the form

        // Forward the request to the JSP for rendering
        RequestDispatcher dispatcher = request.getRequestDispatcher("views/Attendance.jsp");
        dispatcher.forward(request, response);
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        int userId = currentUser.getId();
        String remark = request.getParameter("remark");
        

        List<Attendance> attendanceList = new ArrayList<>();
        Enumeration<String> paramNames = request.getParameterNames();
        
        while (paramNames.hasMoreElements()) {
            String param = paramNames.nextElement();

            if (param.startsWith("date-")) {
            	String dateParamName = param; 

            	String dateStr = request.getParameter(dateParamName);
            	String substringParam = param.substring(5);

            	if (dateStr == null || dateStr.isEmpty()) {
                    continue;
                }
            	
                String inTimeStr = request.getParameter("inTime-" + substringParam);
                String outTimeStr = request.getParameter("outTime-" + substringParam);
                String status = request.getParameter("status-" + substringParam);
                

                Attendance att = new Attendance();
                att.setUserId(userId);
                att.setDate(Date.valueOf(dateStr));
                att.setInTime((inTimeStr == null || inTimeStr.isEmpty()) ? null : Time.valueOf(inTimeStr + ":00"));
                att.setOutTime((outTimeStr == null || outTimeStr.isEmpty()) ? null : Time.valueOf(outTimeStr + ":00"));
                att.setStatus(status);
                att.setRemark(remark);
                attendanceList.add(att);

            }
        }
        
        AttendanceDAO.saveAttendance(attendanceList);
        response.sendRedirect("attendance"); 
//        
//        List<Attendance> AttendanceList = AttendanceDAO.getAttendanceByUserId(userId);
//        request.setAttribute("AttendanceList", AttendanceList);
//
//        RequestDispatcher dispatcher = request.getRequestDispatcher("attendance");
//        dispatcher.forward(request, response);
    }

   


}
