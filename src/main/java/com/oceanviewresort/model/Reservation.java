package com.oceanviewresort.model;

public class Reservation {
    private int reservationNo;
    private String guestName;
    private String address;
    private String contactNumber;
    private String roomType;
    private String checkIn;
    private String checkOut;
    private String status;

    public Reservation() {}

    public Reservation(int reservationNo, String guestName, String address, String contactNumber,
                       String roomType, String checkIn, String checkOut, String status) {
        this.reservationNo = reservationNo;
        this.guestName = guestName;
        this.address = address;
        this.contactNumber = contactNumber;
        this.roomType = roomType;
        this.checkIn = checkIn;
        this.checkOut = checkOut;
        this.status = status;
    }

    public int getReservationNo() { return reservationNo; }
    public void setReservationNo(int reservationNo) { this.reservationNo = reservationNo; }

    public String getGuestName() { return guestName; }
    public void setGuestName(String guestName) { this.guestName = guestName; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getContactNumber() { return contactNumber; }
    public void setContactNumber(String contactNumber) { this.contactNumber = contactNumber; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getCheckIn() { return checkIn; }
    public void setCheckIn(String checkIn) { this.checkIn = checkIn; }

    public String getCheckOut() { return checkOut; }
    public void setCheckOut(String checkOut) { this.checkOut = checkOut; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}