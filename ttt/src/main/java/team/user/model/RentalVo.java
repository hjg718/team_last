package team.user.model;

import java.util.Date;

public class RentalVo {

	private int num;
	private Date rentaldate;
	private String returndate;
	private String rendate;
	private int booknum;
	private String day;
	
	
	public int getNum() {
		return num;
	}
	public void setNum(int num) {
		this.num = num;
	}
	public Date getRentaldate() {
		return rentaldate;
	}
	public void setRentaldate(Date rentaldate) {
		this.rentaldate = rentaldate;
	}
	public String getReturndate() {
		return returndate;
	}
	public void setReturndate(String returndate) {
		this.returndate = returndate;
	}
	public int getBooknum() {
		return booknum;
	}
	public void setBooknum(int booknum) {
		this.booknum = booknum;
	}
	public String getDay() {
		return day;
	}
	public void setDay(String day) {
		this.day = day;
	}
	public String getRendate() {
		return rendate;
	}
	public void setRendate(String rendate) {
		this.rendate = rendate;
	}
	
	
}
