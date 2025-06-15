package model;

import java.sql.Date;

public class Payroll {
    private int id;
    private int userId;
    private String month;
    private int year;
    private double basicSalary;
    private double bonus;
    private double deductions;
    private Date paymentDate;
    private String status;
    private String employeeName;


    public double getNetSalary() {
        return basicSalary + bonus - deductions;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getMonth() {
        return month;
    }
    public void setMonth(String month) {
        this.month = month;
    }

    public int getYear() {
        return year;
    }
    public void setYear(int year) {
        this.year = year;
    }

    public double getBasicSalary() {
        return basicSalary;
    }
    public void setBasicSalary(double basicSalary) {
        this.basicSalary = basicSalary;
    }

    public double getBonus() {
        return bonus;
    }
    public void setBonus(double bonus) {
        this.bonus = bonus;
    }

    public double getDeductions() {
        return deductions;
    }
    public void setDeductions(double deductions) {
        this.deductions = deductions;
    }

	public Date getPaymentDate() {
		return paymentDate;
	}

	public void setPaymentDate(Date paymentDate) {
		this.paymentDate = paymentDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getEmployeeName() {
		return employeeName;
	}

	public void setEmployeeName(String employeeName) {
		this.employeeName = employeeName;
	}
}
