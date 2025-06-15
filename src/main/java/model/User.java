package model;

public class User {
	private int id;
	private String name;
	private String email;
	private String position;
	private String contactno;
	private String department;
	private String password;
	private double salary;
	private double otPerHour;

	public User() {
	}

	public User(int id, String name, String email, String position, String contactno, String department,
			String password, double salary, double otPerHour) {
		this.id = id;
		this.name = name;
		this.email = email;
		this.position = position;
		this.contactno = contactno;
		this.department = department;
		this.password = password;
		this.salary = salary;
		this.otPerHour = otPerHour;

	}

	// Getters and setters
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPosition() {
		return position;
	}

	public void setPosition(String position) {
		this.position = position;
	}

	public String getContactno() {
		return contactno;
	}

	public void setContactno(String contactno) {
		this.contactno = contactno;
	}

	public String getDepartment() {
		return department;
	}

	public void setDepartment(String department) {
		this.department = department;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public double getSalary() {
		return salary;
	}

	public void setSalary(double salary) {
		this.salary = salary;
	}

	public double getOtPerHour() {
		return otPerHour;
	}

	public void setOtPerHour(double otPerHour) {
		this.otPerHour = otPerHour;
	}
}