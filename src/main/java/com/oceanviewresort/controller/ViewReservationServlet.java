package com.oceanviewresort.controller;

import com.oceanviewresort.dao.ReservationDAO;
import com.oceanviewresort.model.Reservation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/view-reservation")
public class ViewReservationServlet extends HttpServlet {

    private final ReservationDAO reservationDAO = new ReservationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String reservationNoStr = req.getParameter("reservationNo");

        try {
            List<Reservation> all = reservationDAO.getAllReservations();
            req.setAttribute("list", all);

            if (reservationNoStr == null || reservationNoStr.trim().isEmpty()) {
                req.getRequestDispatcher("viewReservation.jsp").forward(req, resp);
                return;
            }

            int reservationNo;
            try {
                reservationNo = Integer.parseInt(reservationNoStr.trim());
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Reservation No must be a valid number!");
                req.getRequestDispatcher("viewReservation.jsp").forward(req, resp);
                return;
            }

            Reservation one = reservationDAO.getReservationByNo(reservationNo);
            if (one == null) req.setAttribute("error", "Reservation not found!");
            else req.setAttribute("one", one);

            req.getRequestDispatcher("viewReservation.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Something went wrong. Please try again.");
            req.getRequestDispatcher("viewReservation.jsp").forward(req, resp);
        }
    }
}