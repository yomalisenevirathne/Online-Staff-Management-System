package model;

import java.sql.Time;
import java.sql.Date;

public class Attendance {
    private int id;
    private int userid;
    private Date date;
    private Time inTime;
    private Time outTime;
    private String remark;
    private String status;
    private String employeeName;;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userid; }
    public void setUserId(int userid) { this.userid = userid; }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public Time getInTime() { return inTime; }
    public void setInTime(Time inTime) { this.inTime = inTime; }

    public Time getOutTime() { return outTime; }
    public void setOutTime(Time outTime) { this.outTime = outTime; }

    public String getRemark() { return remark; }
    public void setRemark(String remark) { this.remark = remark; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public String getEmployeeName() { return employeeName; }
	public void setEmployeeName(String employeeName)  { this.employeeName = employeeName; }
		
		

}
