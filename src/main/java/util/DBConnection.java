package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    
    private static final String URL = "jdbc:mysql://localhost:3306/staff_management";
    private static final String USER = "root"; 
    private static final String PASSWORD = "root"; 

    private static Connection connection = null;

    public static Connection getConnection() {
        Connection connection = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database connected successfully!");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return connection;
    }
}
