package com.oceanviewresort.controller;

import com.oceanviewresort.util.DBConnectionManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final int SESSION_TIMEOUT_SECONDS = 15 * 60;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            req.setAttribute("error", "Username and Password are required!");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        String sql = "SELECT username, role, is_active " +
                "FROM users WHERE username=? AND password_hash=?";

        try (Connection con = DBConnectionManager.getInstance().getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, username.trim());
            ps.setString(2, password.trim());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    int isActive = rs.getInt("is_active");
                    if (isActive != 1) {
                        req.setAttribute("error", "Account is disabled. Contact admin.");
                        req.getRequestDispatcher("login.jsp").forward(req, resp);
                        return;
                    }

                    HttpSession session = req.getSession(true);
                    session.setAttribute("username", rs.getString("username"));
                    session.setAttribute("role", rs.getString("role"));
                    session.setMaxInactiveInterval(SESSION_TIMEOUT_SECONDS);

                    resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");

                } else {
                    req.setAttribute("error", "Invalid username or password!");
                    req.getRequestDispatcher("login.jsp").forward(req, resp);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Server error! Please try again.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("username") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard.jsp");
            return;
        }

        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }
}