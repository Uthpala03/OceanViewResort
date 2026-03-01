package com.oceanviewresort.controller;

import com.oceanviewresort.util.DBConnectionManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.time.temporal.ChronoUnit;

@WebServlet("/print-bill")
public class PrintBillServlet extends HttpServlet {

    private static final double SERVICE_CHARGE_RATE = 0.10; // ✅ 10%

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
            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
            return;
        }

        int reservationNo;
        try {
            reservationNo = Integer.parseInt(reservationNoStr.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
            return;
        }

        String sql = "SELECT guest_name, room_type, check_in, check_out, status " +
                "FROM reservations WHERE reservation_no=?";

        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, reservationNo);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    req.setAttribute("error", "Reservation not found!");
                    req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
                    return;
                }

                String status = rs.getString("status");
                if ("CANCELLED".equalsIgnoreCase(status)) {
                    req.setAttribute("error", "Cannot print bill. Reservation is cancelled.");
                    req.getRequestDispatcher("calculateBill.jsp").forward(req, resp);
                    return;
                }

                String guestName = rs.getString("guest_name");
                String roomType = rs.getString("room_type");
                Date checkIn = rs.getDate("check_in");
                Date checkOut = rs.getDate("check_out");

                long nightsLong = ChronoUnit.DAYS.between(checkIn.toLocalDate(), checkOut.toLocalDate());
                if (nightsLong <= 0) nightsLong = 1;

                int price;
                switch ((roomType == null ? "" : roomType.toUpperCase())) {
                    case "DOUBLE": price = 8000; break;
                    case "DELUXE": price = 10000; break;
                    case "SUITE":  price = 12000; break;
                    default:       price = 5000;
                }

                double roomTotal = nightsLong * price;
                double serviceCharge = roomTotal * SERVICE_CHARGE_RATE;
                double grandTotal = roomTotal + serviceCharge;

                req.setAttribute("reservationNo", reservationNo);
                req.setAttribute("guest_name", guestName);
                req.setAttribute("room_type", roomType);
                req.setAttribute("nights", nightsLong);
                req.setAttribute("price", price);

                // ✅ send totals
                req.setAttribute("total", roomTotal);
                req.setAttribute("serviceCharge", serviceCharge);
                req.setAttribute("grandTotal", grandTotal);

                req.setAttribute("status", status);

                req.getRequestDispatcher("printBill.jsp").forward(req, resp);
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
        }
    }
}