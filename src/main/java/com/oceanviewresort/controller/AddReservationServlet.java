package com.oceanviewresort.controller;

import com.oceanviewresort.dao.ReservationDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/add-reservation")
public class AddReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNoStr = safe(req.getParameter("reservationNo"));
        String guestName = safe(req.getParameter("guestName"));
        String address = safe(req.getParameter("address"));
        String contactNumber = safe(req.getParameter("contactNumber"));
        String roomType = safe(req.getParameter("roomType"));
        String checkIn = safe(req.getParameter("checkIn"));
        String checkOut = safe(req.getParameter("checkOut"));

        if (isEmpty(reservationNoStr) || isEmpty(guestName) || isEmpty(address) ||
                isEmpty(contactNumber) || isEmpty(roomType) || isEmpty(checkIn) || isEmpty(checkOut)) {
            forwardWithError(req, resp, "All fields are required!");
            return;
        }

        int reservationNo;
        try {
            reservationNo = Integer.parseInt(reservationNoStr);
            if (reservationNo <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            forwardWithError(req, resp, "Reservation No must be a positive number!");
            return;
        }

        if (!contactNumber.matches("\\d{10}")) {
            forwardWithError(req, resp, "Contact Number must be 10 digits (ex: 0768056328)");
            return;
        }

        if (checkOut.compareTo(checkIn) <= 0) {
            forwardWithError(req, resp, "Check-out date must be after Check-in date!");
            return;
        }

        try {
            if (reservationDAO.reservationExists(reservationNo)) {
                forwardWithError(req, resp, "Reservation number already exists! Use a new number.");
                return;
            }

            reservationDAO.insertReservation(
                    reservationNo, guestName, address, contactNumber, roomType, checkIn, checkOut
            );

            req.setAttribute("success", "Reservation saved successfully!");
            req.getRequestDispatcher("addReservation.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError(req, resp, "Something went wrong. Please try again.");
        }
    }

    private String safe(String s) { return (s == null) ? "" : s.trim(); }
    private boolean isEmpty(String s) { return s == null || s.trim().isEmpty(); }

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws ServletException, IOException {
        req.setAttribute("error", msg);
        req.getRequestDispatcher("addReservation.jsp").forward(req, resp);
    }
}