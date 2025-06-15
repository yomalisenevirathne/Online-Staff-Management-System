package util;

import java.sql.Connection;
import java.sql.SQLException;

public class DBConnectionTest {

    public static void main(String[] args) {
        // Get the connection instance
        Connection connection = DBConnection.getConnection();

        // Test if the connection is successful
        if (connection != null) {
            System.out.println("Connection established successfully!");
            try {
                // Close the connection after testing
                connection.close();
                System.out.println("Connection closed.");
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("Failed to establish connection.");
        }
    }
}
