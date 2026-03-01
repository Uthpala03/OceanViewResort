package com.oceanviewresort.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;
import java.io.IOException;

@WebFilter("*.jsp")
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String uri = req.getRequestURI(); // like /OceanViewResort/dashboard.jsp

        // ✅ Allow login page without session
        if (uri.endsWith("login.jsp")) {
            chain.doFilter(request, response);
            return;
        }

        // ✅ Optional: allow public pages (if you want)
        // if (uri.endsWith("help.jsp")) { chain.doFilter(request, response); return; }

        HttpSession session = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("username") != null);

        if (!loggedIn) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }
}