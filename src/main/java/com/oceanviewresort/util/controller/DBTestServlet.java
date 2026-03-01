package com.oceanviewresort.util.controller;

import com.oceanviewresort.util.DBConnectionManager;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/db-test")
public class DBTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");

        try (Connection con =
                     DBConnectionManager.getInstance().getConnection()) {

            response.getWriter().println("✅ Database Connected Successfully!");
        }
        catch (Exception e) {

            response.getWriter().println("❌ Database Connection Failed!");
            response.getWriter().println(e.getMessage());
        }
    }
}
