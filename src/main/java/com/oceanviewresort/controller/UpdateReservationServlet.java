package com.oceanviewresort.controller;

import com.oceanviewresort.util.DBConnectionManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/update-reservation")
public class UpdateReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNoStr = req.getParameter("reservationNo");

        if (reservationNoStr == null || reservationNoStr.trim().isEmpty()) {
            req.getRequestDispatcher("updateReservation.jsp").forward(req, resp);
            return;
        }

        int reservationNo;
        try {
            reservationNo = Integer.parseInt(reservationNoStr.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Reservation Number must be a valid number!");
            req.getRequestDispatcher("updateReservation.jsp").forward(req, resp);
            return;
        }

        String sql = "SELECT reservation_no, guest_name, address, contact_number, room_type, check_in, check_out, status " +
                "FROM reservations WHERE reservation_no = ?";

        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String status = rs.getString("status");
                    if ("CANCELLED".equalsIgnoreCase(status)) {
                        req.setAttribute("error", "Cannot update. Reservation is CANCELLED.");
                    } else {
                        req.setAttribute("reservation_no", rs.getInt("reservation_no"));
                        req.setAttribute("guest_name", rs.getString("guest_name"));
                        req.setAttribute("address", rs.getString("address"));
                        req.setAttribute("contact_number", rs.getString("contact_number"));
                        req.setAttribute("room_type", rs.getString("room_type"));
                        req.setAttribute("check_in", rs.getDate("check_in").toString());
                        req.setAttribute("check_out", rs.getDate("check_out").toString());
                        req.setAttribute("status", status);
                    }
                } else {
                    req.setAttribute("error", "Reservation not found!");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Something went wrong. Please try again.");
        }

        req.getRequestDispatcher("updateReservation.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int reservationNo;

        try {
            reservationNo = Integer.parseInt(req.getParameter("reservationNo"));

            String guestName = req.getParameter("guestName").trim();
            String address = req.getParameter("address").trim();
            String contact = req.getParameter("contact").trim();
            String roomType = req.getParameter("roomType").trim();
            String checkIn = req.getParameter("checkIn").trim();
            String checkOut = req.getParameter("checkOut").trim();

            if (guestName.isEmpty() || address.isEmpty() || contact.isEmpty() ||
                    roomType.isEmpty() || checkIn.isEmpty() || checkOut.isEmpty()) {
                req.setAttribute("error", "All fields are required!");
                loadFormBack(req, resp, reservationNo, guestName, address, contact, roomType, checkIn, checkOut);
                return;
            }

            if (!contact.matches("\\d{10}")) {
                req.setAttribute("error", "Contact Number must be 10 digits!");
                loadFormBack(req, resp, reservationNo, guestName, address, contact, roomType, checkIn, checkOut);
                return;
            }

            if (checkOut.compareTo(checkIn) <= 0) {
                req.setAttribute("error", "Check-out date must be after Check-in date!");
                loadFormBack(req, resp, reservationNo, guestName, address, contact, roomType, checkIn, checkOut);
                return;
            }

            String sqlStatus = "SELECT status FROM reservations WHERE reservation_no=?";
            String sqlUpdate = "UPDATE reservations SET guest_name=?, address=?, contact_number=?, room_type=?, check_in=?, check_out=? " +
                    "WHERE reservation_no=? AND status <> 'CANCELLED'";

            try (Connection con = DBConnectionManager.getInstance().getConnection()) {

                String status;
                try (PreparedStatement ps0 = con.prepareStatement(sqlStatus)) {
                    ps0.setInt(1, reservationNo);
                    try (ResultSet rs0 = ps0.executeQuery()) {
                        if (!rs0.next()) {
                            req.setAttribute("error", "Reservation not found!");
                            req.getRequestDispatcher("updateReservation.jsp").forward(req, resp);
                            return;
                        }
                        status = rs0.getString("status");
                    }
                }

                if ("CANCELLED".equalsIgnoreCase(status)) {
                    req.setAttribute("error", "Cannot update. Reservation is CANCELLED.");
                    req.getRequestDispatcher("updateReservation.jsp").forward(req, resp);
                    return;
                }

                try (PreparedStatement ps = con.prepareStatement(sqlUpdate)) {

                    ps.setString(1, guestName);
                    ps.setString(2, address);
                    ps.setString(3, contact);
                    ps.setString(4, roomType);
                    ps.setDate(5, Date.valueOf(checkIn));
                    ps.setDate(6, Date.valueOf(checkOut));
                    ps.setInt(7, reservationNo);

                    int rows = ps.executeUpdate();

                    if (rows > 0) {
                        req.setAttribute("message", "Reservation updated successfully!");
                        req.setAttribute("updatedReservationNo", reservationNo);
                    } else {
                        req.setAttribute("error", "Reservation not found!");
                    }
                }
            }

            loadFormBack(req, resp, reservationNo, guestName, address, contact, roomType, checkIn, checkOut);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Something went wrong. Please try again.");
            req.getRequestDispatcher("updateReservation.jsp").forward(req, resp);
        }
    }

    private void loadFormBack(HttpServletRequest req, HttpServletResponse resp,
                              int reservationNo, String guestName, String address, String contact,
                              String roomType, String checkIn, String checkOut)
            throws ServletException, IOException {

        req.setAttribute("reservation_no", reservationNo);
        req.setAttribute("guest_name", guestName);
        req.setAttribute("address", address);
        req.setAttribute("contact_number", contact);
        req.setAttribute("room_type", roomType);
        req.setAttribute("check_in", checkIn);
        req.setAttribute("check_out", checkOut);

        req.getRequestDispatcher("updateReservation.jsp").forward(req, resp);
    }
}