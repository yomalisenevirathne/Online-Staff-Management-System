package dao;

import java.sql.*;
import java.sql.Date;
import java.util.*;
import model.Attendance;
import util.DBConnection;

public class AttendanceDAO {

    public void saveAttendance(List<Attendance> attendanceList) {
    	
    	for (Attendance att : attendanceList) {
            if (recordExists(att.getUserId(), att.getDate())) {
                updateAttendance(att); 
            } else {
                insertAttendance(att);
            }
        }
    }

    public List<Attendance> getAttendanceByUserId(int userid) {
        List<Attendance> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM attendance WHERE user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userid);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Attendance att = new Attendance();
                att.setId(rs.getInt("id"));
                att.setUserId(userid);
                att.setDate(rs.getDate("date"));
                att.setInTime(rs.getTime("in_time"));
                att.setOutTime(rs.getTime("out_time"));
                att.setRemark(rs.getString("remark"));
                att.setStatus(rs.getString("status"));
                list.add(att);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Attendance> getAttendanceRange(int userId, Date startDate, Date endDate) {
        List<Attendance> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection()) {
            String sql = "SELECT * FROM attendance WHERE user_id = ? AND date BETWEEN ? AND ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, userId);
            stmt.setDate(2, startDate);
            stmt.setDate(3, endDate);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Attendance a = new Attendance();
                a.setId(rs.getInt("id"));
                a.setUserId(rs.getInt("user_id"));
                a.setDate(rs.getDate("date"));
                a.setInTime(rs.getTime("in_time"));
                a.setOutTime(rs.getTime("out_time"));
                a.setStatus(rs.getString("status"));
                a.setRemark(rs.getString("remark"));
                list.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List<Attendance> getAttendanceByStatus(String status) {
        List<Attendance> attendanceList = new ArrayList<>();
        String sql;

        if ("All".equalsIgnoreCase(status)) {
            sql = "SELECT a.*, u.name FROM attendance a JOIN users u ON a.user_id = u.id";
        } else {
            sql = "SELECT a.*, u.name FROM attendance a JOIN users u ON a.user_id = u.id WHERE a.status = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (!"All".equalsIgnoreCase(status)) {
                stmt.setString(1, status);
            }

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Attendance att = new Attendance();
                att.setId(rs.getInt("id"));
                att.setUserId(rs.getInt("user_id"));
                att.setDate(rs.getDate("date"));
                att.setInTime(rs.getTime("in_time"));
                att.setOutTime(rs.getTime("out_time"));
                att.setStatus(rs.getString("status"));
                att.setRemark(rs.getString("remark"));
                att.setEmployeeName(rs.getString("name"));

                attendanceList.add(att);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return attendanceList;
    }



    public void updateAttendanceStatus(int id, String status) {
        String sql = "UPDATE attendance SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, id);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Object[]> getMonthlyAttendanceStats() throws SQLException {
        String sql = "SELECT MONTH(date) as month_num, " +
                     "COUNT(*) as total_records, " +
                     "SUM(CASE WHEN status = 'Present' THEN 1 ELSE 0 END) as present_count, " +
                     "SUM(CASE WHEN status = 'Absent' THEN 1 ELSE 0 END) as absent_count, " +
                     "SUM(CASE WHEN status = 'Late' THEN 1 ELSE 0 END) as late_count " +
                     "FROM attendance " +
                     "WHERE YEAR(date) = YEAR(CURRENT_DATE) " +
                     "GROUP BY MONTH(date) " +
                     "ORDER BY month_num";
        
        List<Object[]> stats = new ArrayList<>();
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Object[] monthStats = new Object[5];
                monthStats[0] = rs.getInt("month_num");
                monthStats[1] = rs.getInt("total_records");
                monthStats[2] = rs.getInt("present_count");
                monthStats[3] = rs.getInt("absent_count");
                monthStats[4] = rs.getInt("late_count");
                
                stats.add(monthStats);
            }
        }
        
        return stats;
    }
    
    
    public double getTodayAttendancePercentage() throws SQLException {
        String sql = "SELECT " +
                     "(SELECT COUNT(*) FROM attendance WHERE date = CURRENT_DATE AND status IN ('Present', 'Late')) AS present_count, " +
                     "(SELECT COUNT(*) FROM users) AS total_employees";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                int presentCount = rs.getInt("present_count");
                int totalEmployees = rs.getInt("total_employees");
                
                if (totalEmployees > 0) {
                    return Math.round((double) presentCount / totalEmployees * 100);
                }
            }
            return 0.0;
        }
    }
    
    public boolean deleteById(int id) {
        String sql = "DELETE FROM attendance WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private boolean recordExists(int userId, Date date) {
        String sql = "SELECT COUNT(*) FROM attendance WHERE user_id = ? AND date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setDate(2, date);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean updateAttendance(Attendance att) {
        String sql = "UPDATE attendance SET in_time = ?, out_time = ?, status = ?, remark = ? " +
                     "WHERE user_id = ? AND date = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setTime(1, att.getInTime());
            stmt.setTime(2, att.getOutTime());
            stmt.setString(3, "Pending");
            stmt.setString(4, att.getRemark());
            stmt.setInt(5, att.getUserId());
            stmt.setDate(6, att.getDate());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean insertAttendance(Attendance att) {
        String sql = "INSERT INTO attendance (user_id, date, in_time, out_time, status, remark) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, att.getUserId());
            stmt.setDate(2, att.getDate());
            stmt.setTime(3, att.getInTime());
            stmt.setTime(4, att.getOutTime());
            stmt.setString(5, "Pending");
            stmt.setString(6, att.getRemark());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }



}
