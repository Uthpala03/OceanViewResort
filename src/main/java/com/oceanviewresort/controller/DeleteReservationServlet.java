package com.oceanviewresort.controller;

import com.oceanviewresort.util.DBConnectionManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/delete-reservation")
public class DeleteReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNoStr = req.getParameter("reservationNo");

        if (reservationNoStr == null || reservationNoStr.trim().isEmpty()) {
            req.setAttribute("error", "Enter Reservation Number!");
            req.getRequestDispatcher("deleteReservation.jsp").forward(req, resp);
            return;
        }

        int reservationNo;
        try {
            reservationNo = Integer.parseInt(reservationNoStr.trim());
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Reservation Number must be a valid number!");
            req.getRequestDispatcher("deleteReservation.jsp").forward(req, resp);
            return;
        }

        String checkReservationSql = "SELECT status FROM reservations WHERE reservation_no=?";
        String checkPaymentsSql = "SELECT COUNT(*) FROM payments WHERE reservation_no=?";
        String cancelReservationSql =
                "UPDATE reservations SET status='CANCELLED' WHERE reservation_no=? AND status <> 'PAID'";

        try (Connection con = DBConnectionManager.getInstance().getConnection()) {

            // 1) Reservation must exist
            String status;
            try (PreparedStatement ps0 = con.prepareStatement(checkReservationSql)) {
                ps0.setInt(1, reservationNo);
                try (ResultSet rs0 = ps0.executeQuery()) {
                    if (!rs0.next()) {
                        req.setAttribute("error", "Reservation not found!");
                        req.getRequestDispatcher("deleteReservation.jsp").forward(req, resp);
                        return;
                    }
                    status = rs0.getString("status");
                }
            }

            if ("CANCELLED".equalsIgnoreCase(status)) {
                req.setAttribute("error", "Reservation already CANCELLED.");
                req.getRequestDispatcher("deleteReservation.jsp").forward(req, resp);
                return;
            }

            if ("PAID".equalsIgnoreCase(status)) {
                req.setAttribute("error", "Cannot cancel! Reservation already PAID.");
                req.getRequestDispatcher("deleteReservation.jsp").forward(req, resp);
                return;
            }

            // 2) Block cancel if payments exist
            try (PreparedStatement psCheck = con.prepareStatement(checkPaymentsSql)) {
                psCheck.setInt(1, reservationNo);

                try (ResultSet rs = psCheck.executeQuery()) {
                    rs.next();
                    int count = rs.getInt(1);
                    if (count > 0) {
                        req.setAttribute("error", "Cannot cancel! Payment already exists for this reservation.");
                        req.getRequestDispatcher("deleteReservation.jsp").forward(req, resp);
                        return;
                    }
                }
            }

            // 3) Cancel (soft delete)
            try (PreparedStatement psCancel = con.prepareStatement(cancelReservationSql)) {
                psCancel.setInt(1, reservationNo);
                int rows = psCancel.executeUpdate();

                if (rows > 0) {
                    req.setAttribute("message", "Reservation cancelled successfully!");
                } else {
                    req.setAttribute("error", "Cannot cancel reservation!");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Something went wrong. Please try again.");
        }

        req.getRequestDispatcher("deleteReservation.jsp").forward(req, resp);
    }
}