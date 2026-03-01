package com.oceanviewresort.controller;

import com.oceanviewresort.util.DBConnectionManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.temporal.ChronoUnit;

@WebServlet("/calculate-bill")
public class CalculateBillServlet extends HttpServlet {

    private static final double SERVICE_CHARGE_RATE = 0.10;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNoStr = req.getParameter("reservationNo");
        String action = req.getParameter("action");

        if (reservationNoStr == null || reservationNoStr.trim().isEmpty()) {
            req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
            return;
        }

        int reservationNo;
        try {
            reservationNo = Integer.parseInt(reservationNoStr.trim());
        } catch (NumberFormatException ex) {
            req.setAttribute("error", "Reservation Number must be a number!");
            req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
            return;
        }

        String selectSql =
                "SELECT guest_name, room_type, check_in, check_out, status " +
                        "FROM reservations WHERE reservation_no=?";

        String insertPaymentSql =
                "INSERT INTO payments (reservation_no, nights, total_amount) VALUES (?, ?, ?)";

        String updateStatusSql =
                "UPDATE reservations SET status='PAID' WHERE reservation_no=?";

        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(selectSql)) {

            ps.setInt(1, reservationNo);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    req.setAttribute("error", "Reservation not found!");
                    req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
                    return;
                }

                String status = rs.getString("status");
                if ("CANCELLED".equalsIgnoreCase(status)) {
                    req.setAttribute("error", "Reservation is cancelled. Cannot calculate.");
                    req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
                    return;
                }

                String guestName = rs.getString("guest_name");
                String roomType = rs.getString("room_type");
                Date checkIn = rs.getDate("check_in");
                Date checkOut = rs.getDate("check_out");

                long nightsLong = ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
                if (nightsLong <= 0) {
                    req.setAttribute("error", "Invalid dates. Check-out must be after check-in.");
                    req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
                    return;
                }

                int nights = (int) nightsLong;

                int pricePerNight;
                switch ((roomType == null ? "" : roomType.toUpperCase())) {
                    case "DOUBLE": pricePerNight = 8000; break;
                    case "DELUXE": pricePerNight = 10000; break;
                    case "SUITE":  pricePerNight = 12000; break;
                    default:       pricePerNight = 5000;  // SINGLE
                }

                // Room total
                double roomTotal = nights * pricePerNight;

                // Service charge 10%
                double serviceCharge = roomTotal * SERVICE_CHARGE_RATE;

                // Grand total
                double grandTotal = roomTotal + serviceCharge;

                req.setAttribute("reservationNo", reservationNo);
                req.setAttribute("guest_name", guestName);
                req.setAttribute("room_type", roomType);
                req.setAttribute("nights", nights);
                req.setAttribute("price", pricePerNight);

                req.setAttribute("total", roomTotal);
                req.setAttribute("serviceCharge", serviceCharge);
                req.setAttribute("grandTotal", grandTotal);

                req.setAttribute("status", status);

                if (action == null || "calc".equalsIgnoreCase(action)) {
                    req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
                    return;
                }

                if ("pay".equalsIgnoreCase(action)) {
                    if ("PAID".equalsIgnoreCase(status)) {
                        req.setAttribute("error", "Already PAID. No need to save again.");
                        req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
                        return;
                    }

                    try (PreparedStatement ps2 = con.prepareStatement(insertPaymentSql)) {
                        ps2.setInt(1, reservationNo);
                        ps2.setInt(2, nights);
                        ps2.setDouble(3, grandTotal);
                        ps2.executeUpdate();
                    }

                    try (PreparedStatement ps3 = con.prepareStatement(updateStatusSql)) {
                        ps3.setInt(1, reservationNo);
                        ps3.executeUpdate();
                    }

                    req.setAttribute("success", "Payment saved! Reservation status updated to PAID.");
                    req.setAttribute("status", "PAID");
                    req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error occurred.");
            req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
        }
    }
}