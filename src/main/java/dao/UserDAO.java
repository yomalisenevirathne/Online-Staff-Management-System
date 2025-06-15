package dao;

import util.DBConnection;
import java.sql.*;
import java.util.*;

import model.User;

public class UserDAO {

	// Add a new user to the database
	public void addUser(User user) {
		try (Connection conn = DBConnection.getConnection()) {
			String sql = "INSERT INTO users (name, email, position, contactno, department, password, salary, OTperHour) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, user.getName());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPosition());
			ps.setString(4, user.getContactno());
			ps.setString(5, user.getDepartment());
			ps.setString(6, user.getPassword());
			ps.setDouble(7, user.getSalary());
			ps.setDouble(8, user.getOtPerHour());
			ps.executeUpdate(); // Insert user into database
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Update user details in the database
	public void updateUser(User user) {
		try (Connection conn = DBConnection.getConnection()) {
			String sql = "UPDATE users SET name=?, email=?, position=?, contactno=?, department=?, password=?, salary=?, OTperHour=? WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, user.getName());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPosition());
			ps.setString(4, user.getContactno());
			ps.setString(5, user.getDepartment());
			ps.setString(6, user.getPassword());
			ps.setDouble(7, user.getSalary());
			ps.setDouble(8, user.getOtPerHour());
			ps.setInt(9, user.getId());
			ps.executeUpdate(); // Update user in database
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Delete a user from the database by ID
	public void deleteUser(int id) {
		try (Connection conn = DBConnection.getConnection()) {
			String sql = "DELETE FROM users WHERE id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate(); // Delete user
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Get a list of all users from the database
	public List<User> getAllUsers() {
		List<User> list = new ArrayList<>();
		try (Connection conn = DBConnection.getConnection()) {
			String sql = "SELECT * FROM users";
			PreparedStatement ps = conn.prepareStatement(sql);
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				User u = new User();
				u.setId(rs.getInt("id"));
				u.setName(rs.getString("name"));
				u.setEmail(rs.getString("email"));
				u.setPosition(rs.getString("position"));
				u.setContactno(rs.getString("contactno"));
				u.setDepartment(rs.getString("department"));
				u.setPassword(rs.getString("password"));
				u.setSalary(rs.getDouble("salary"));
				u.setOtPerHour(rs.getDouble("OTperHour"));
				list.add(u); // Add each user to the list
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	// Get a single user by their ID
	public User getUserById(int id) {
		User user = null;
		try (Connection conn = DBConnection.getConnection()) {
			String sql = "SELECT * FROM users WHERE id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				user = new User();
				user.setId(rs.getInt("id"));
				user.setName(rs.getString("name"));
				user.setEmail(rs.getString("email"));
				user.setPosition(rs.getString("position"));
				user.setContactno(rs.getString("contactno"));
				user.setDepartment(rs.getString("department"));
				user.setPassword(rs.getString("password"));
				user.setSalary(rs.getDouble("salary"));
				user.setOtPerHour(rs.getDouble("OTperHour"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}

	// Login method to check if a user exists with the given email and password
	public User login(String email, String password) {
		User user = null;
		try (Connection conn = DBConnection.getConnection()) {
			String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
			PreparedStatement stmt = conn.prepareStatement(sql);
			stmt.setString(1, email);
			stmt.setString(2, password);
			ResultSet rs = stmt.executeQuery();

			while (rs.next()) {
				user = new User();
				user.setId(rs.getInt("id"));
				user.setName(rs.getString("name"));
				user.setEmail(rs.getString("email"));
				user.setPosition(rs.getString("position"));
				user.setContactno(rs.getString("contactno"));
				user.setDepartment(rs.getString("department"));
				user.setPassword(rs.getString("password"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return user;
	}

	// Get the total number of users (employees)
	public int getTotalEmployees() throws SQLException {
		String sql = "SELECT COUNT(*) FROM users";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {

			if (rs.next()) {
				return rs.getInt(1); // Return total count
			}
			return 0;
		}
	}
}
