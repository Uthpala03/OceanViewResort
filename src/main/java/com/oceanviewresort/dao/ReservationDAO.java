package com.oceanviewresort.dao;

import com.oceanviewresort.model.Reservation;
import com.oceanviewresort.util.DBConnectionManager;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // ✅ Check if reservation no already exists (ignore CANCELLED so number can be reused)
    public boolean reservationExists(int reservationNo) throws Exception {
        String sql = "SELECT reservation_no FROM reservations WHERE reservation_no = ? AND status <> 'CANCELLED'";
        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationNo);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    // ✅ Insert reservation (status defaults to ACTIVE)
    public void insertReservation(int reservationNo, String guestName, String address,
                                  String contactNumber, String roomType,
                                  String checkIn, String checkOut) throws Exception {

        String sql = "INSERT INTO reservations " +
                "(reservation_no, guest_name, address, contact_number, room_type, check_in, check_out, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, 'ACTIVE')";

        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationNo);
            ps.setString(2, guestName);
            ps.setString(3, address);
            ps.setString(4, contactNumber);
            ps.setString(5, roomType);

            // ✅ real DATE values
            ps.setDate(6, Date.valueOf(checkIn));
            ps.setDate(7, Date.valueOf(checkOut));

            ps.executeUpdate();
        }
    }

    public Reservation getReservationByNo(int reservationNo) throws Exception {
        String sql = "SELECT reservation_no, guest_name, address, contact_number, room_type, check_in, check_out, status " +
                "FROM reservations WHERE reservation_no = ?";

        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapReservation(rs);
            }
        }
        return null;
    }

    public List<Reservation> getAllReservations() throws Exception {
        List<Reservation> list = new ArrayList<>();

        String sql = "SELECT reservation_no, guest_name, address, contact_number, room_type, check_in, check_out, status " +
                "FROM reservations WHERE status <> 'CANCELLED' ORDER BY reservation_no DESC";

        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapReservation(rs));
        }
        return list;
    }

    private Reservation mapReservation(ResultSet rs) throws Exception {
        String statusValue = rs.getString("status");
        if (statusValue == null || statusValue.trim().isEmpty()) statusValue = "ACTIVE";

        return new Reservation(
                rs.getInt("reservation_no"),
                rs.getString("guest_name"),
                rs.getString("address"),
                rs.getString("contact_number"),
                rs.getString("room_type"),
                String.valueOf(rs.getDate("check_in")),
                String.valueOf(rs.getDate("check_out")),
                statusValue
        );
    }
}