package dao;

import model.Payroll;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PayrollDAO {
    private Connection conn;

    // Constructor: Get the database connection
    public PayrollDAO() {
        this.conn = DBConnection.getConnection();
    }

    // Get payrolls for a specific user
    public List<Payroll> getPayrollsByUserId(int userId) {
        List<Payroll> payrolls = new ArrayList<>();
        
        // SQL to get payroll by user ID, sorted by year and month
        String query = "SELECT * FROM payroll WHERE user_id = ? ORDER BY year DESC, FIELD(month, 'January','February','March','April','May','June','July','August','September','October','November','December') DESC";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            // Go through results and fill the payroll list
            while (rs.next()) {
                Payroll p = new Payroll();
                p.setId(rs.getInt("id"));
                p.setUserId(rs.getInt("user_id"));
                p.setMonth(rs.getString("month"));
                p.setYear(rs.getInt("year"));
                p.setBasicSalary(rs.getDouble("basic_salary"));
                p.setBonus(rs.getDouble("bonus"));
                p.setDeductions(rs.getDouble("deductions"));
                p.setPaymentDate(rs.getDate("payment_date"));
                p.setStatus("Received"); // Set status
                payrolls.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace(); // Print any error
        }

        return payrolls; // Return the list
    }

    // Add a new payroll record to the database
    public void addPayroll(Payroll payroll) {
        String sql = "INSERT INTO payroll (user_id, month, basic_salary, bonus, deductions, year, payment_date, status) VALUES (?, ?, ?, ?, ?, ?, ?, 'Paid')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, payroll.getUserId());
            stmt.setString(2, payroll.getMonth());
            stmt.setDouble(3, payroll.getBasicSalary());
            stmt.setDouble(4, payroll.getBonus());
            stmt.setDouble(5, payroll.getDeductions());
            stmt.setInt(6, payroll.getYear());

            // Set current date as payment date
            java.sql.Date currentDate = new java.sql.Date(System.currentTimeMillis());
            stmt.setDate(7, currentDate);

            stmt.executeUpdate(); // Run the query

        } catch (SQLException e) {
            e.printStackTrace(); // Print any error
        }
    }

    // Get payroll records for all users (used by managers)
    public List<Payroll> getAllPayrolls() {
        List<Payroll> list = new ArrayList<>();
        
        // Join payroll and users to get employee names
        String sql = "SELECT p.id, p.user_id, u.name AS employee_name, p.month, p.basic_salary, p.deductions, p.bonus " +
                "FROM payroll p JOIN users u ON p.user_id = u.id";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Payroll payroll = new Payroll();
                payroll.setId(rs.getInt("id"));
                payroll.setUserId(rs.getInt("user_id"));
                payroll.setEmployeeName(rs.getString("employee_name"));
                payroll.setMonth(rs.getString("month"));
                payroll.setBasicSalary(rs.getDouble("basic_salary"));
                payroll.setBonus(rs.getDouble("bonus"));
                payroll.setDeductions(rs.getDouble("deductions"));
                payroll.setStatus("Remittance"); // Set status
                list.add(payroll);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list; // Return all payrolls
    }

    // Update existing payroll data
    public void updatePayroll(Payroll payroll) {
        String sql = "UPDATE payroll SET month = ?, basic_salary = ?, deductions = ? , bonus = ? , year = ?, user_id = ? , status = 'Paid' WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, payroll.getMonth());
            stmt.setDouble(2, payroll.getBasicSalary());
            stmt.setDouble(3, payroll.getDeductions());
            stmt.setDouble(4, payroll.getBonus());
            stmt.setInt(5, payroll.getYear());
            stmt.setInt(6, payroll.getUserId());
            stmt.setInt(7, payroll.getId());

            stmt.executeUpdate(); // Run the update

        } catch (SQLException e) {
            e.printStackTrace(); // Print any error
        }
    }

    // Delete a payroll record by its ID
    public void deletePayroll(int id) {
        String sql = "DELETE FROM payroll WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            stmt.executeUpdate(); // Run the delete

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Get total of all salaries for the current month (basic_salary sum)
    public double getCurrentMonthTotalPayroll() throws SQLException {
        String sql = "SELECT SUM(basic_salary) FROM payroll";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1); // Return total
            }
            return 0.0; // Return 0 if no data
        }
    }
}
