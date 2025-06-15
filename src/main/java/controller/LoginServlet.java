package controller;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import dao.UserDAO;
import model.User;

@SuppressWarnings("serial")
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        User user = userDAO.login(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);
         
            if (user.getPosition().toLowerCase().contains("manager")) {
            	response.sendRedirect("dashboard");
            } else {
                response.sendRedirect("payroll");
            }
        } else {
            request.setAttribute("error", "Invalid credentials!");
            RequestDispatcher dispatcher = request.getRequestDispatcher("views/login.jsp");
            dispatcher.forward(request, response);
        }
    }
}
