package dao;

import model.LeaveRequest;
import util.DBConnection;

import java.sql.*;
import java.util.*;

public class LeaveRequestDAO {
	private Connection connection;

    public LeaveRequestDAO() {
        this.connection = DBConnection.getConnection(); 
    }

    public List<LeaveRequest> getAllRequests() throws SQLException {
        List<LeaveRequest> list = new ArrayList<>();
        String sql = "SELECT lr.*, u.name AS staff_name " +
                "FROM leave_request lr " +
                "INNER JOIN users u ON lr.user_id = u.id";
        PreparedStatement ps = connection.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            LeaveRequest lr = new LeaveRequest();
            lr.setId(rs.getInt("id"));
            lr.setStaffId(rs.getInt("user_id"));
            lr.setStartDate(rs.getDate("start_date"));
            lr.setEndDate(rs.getDate("end_date"));
            lr.setType(rs.getString("type"));
            lr.setReason(rs.getString("reason"));
            lr.setStatus(rs.getString("status"));
            lr.setEmployeeName(rs.getString("staff_name"));
            list.add(lr);
        }
        return list;
    }

    public void insertLeaveRequest(LeaveRequest lr) throws SQLException {
        String sql = "INSERT INTO leave_request (user_id, start_date, end_date, type, reason, status) VALUES (?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, lr.getStaffId());
        ps.setDate(2, lr.getStartDate());
        ps.setDate(3, lr.getEndDate());
        ps.setString(4, lr.getType());
        ps.setString(5, lr.getReason());
        ps.setString(6, lr.getStatus());
        ps.executeUpdate();
    }

    public void updateLeaveStatus(int id, String status) throws SQLException {
        String sql = "UPDATE leave_request SET status=? WHERE id=?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, status);
        ps.setInt(2, id);
        ps.executeUpdate();
    }

    public void deleteLeaveRequest(int id) throws SQLException {
        String sql = "DELETE FROM leave_request WHERE id=?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
    }
    
    
    public List<LeaveRequest> getLeavesByUser(int userid) {
        List<LeaveRequest> leaves = new ArrayList<>();
        
        String sql = "SELECT * FROM leave_request WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userid);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LeaveRequest lr = new LeaveRequest();
                lr.setId(rs.getInt("id"));
                lr.setStaffId(rs.getInt("user_id"));
                lr.setStartDate(rs.getDate("start_date"));
                lr.setEndDate(rs.getDate("end_date"));
                lr.setType(rs.getString("type"));
                lr.setReason(rs.getString("reason"));
                lr.setStatus(rs.getString("status"));

                leaves.add(lr);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return leaves;
    }
    
    public void updateLeaveRequest(LeaveRequest leaveRequest) throws SQLException {
        String query = "UPDATE leave_request SET user_id = ?, start_date = ?, end_date = ?, type = ?, reason = ?, status = ? WHERE id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(query)) {
            stmt.setInt(1, leaveRequest.getStaffId());
            stmt.setDate(2, leaveRequest.getStartDate());
            stmt.setDate(3, leaveRequest.getEndDate());
            stmt.setString(4, leaveRequest.getType());
            stmt.setString(5, leaveRequest.getReason());
            stmt.setString(6, leaveRequest.getStatus());
            stmt.setInt(7, leaveRequest.getId());

            stmt.executeUpdate();
        }
    }
    
    public List<LeaveRequest> getLeaveRequestsByStatus(String status) throws SQLException {
        List<LeaveRequest> list = new ArrayList<>();

        String sql = "SELECT lr.*, u.name AS staff_name " +
                     "FROM leave_request lr " +
                     "INNER JOIN users u ON lr.user_id = u.id";

        if (!"All".equalsIgnoreCase(status)) {
            sql += " WHERE lr.status = ?";
        }

        PreparedStatement ps = connection.prepareStatement(sql);

        if (!"All".equalsIgnoreCase(status)) {
            ps.setString(1, status);
        }

        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            LeaveRequest lr = new LeaveRequest();
            lr.setId(rs.getInt("id"));
            lr.setStaffId(rs.getInt("user_id"));
            lr.setStartDate(rs.getDate("start_date"));
            lr.setEndDate(rs.getDate("end_date"));
            lr.setType(rs.getString("type"));
            lr.setReason(rs.getString("reason"));
            lr.setStatus(rs.getString("status"));
            lr.setEmployeeName(rs.getString("staff_name"));
            list.add(lr);
        }

        return list;
    }
    
    public int getPendingLeavesCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM leave_request WHERE status = 'Pending'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        }
    }
    
    public int getLeaveCountByType(String leaveType) throws SQLException {
        String sql = "SELECT COUNT(*) FROM leave_request WHERE type = ? AND status != 'Rejected'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, leaveType);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                return 0;
            }
        }
    }

}
