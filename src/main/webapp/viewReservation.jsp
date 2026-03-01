<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.oceanviewresort.model.Reservation" %>

<%
    String error = (String) request.getAttribute("error");
    Reservation one = (Reservation) request.getAttribute("one");
    List<Reservation> list = (List<Reservation>) request.getAttribute("list");
%>

<!DOCTYPE html>
<html>
<head>
    <title>View Reservations - Ocean View Resort</title>
</head>
<body>

<jsp:include page="includes/header.jsp"/>

<div class="container">

    <div class="card">
        <h1 style="margin:0 0 6px;">
            <i class="fa-solid fa-magnifying-glass"></i> View Reservations
        </h1>
        <small>Search by reservation number or view all reservations</small>

        <% if (error != null) { %>
            <div class="alert bad"><%= error %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/view-reservation" method="get"
              style="margin-top:14px; display:flex; gap:10px; flex-wrap:wrap; align-items:end;">

            <div style="flex:1; min-width:220px;">
                <small>Reservation No</small>
                <input type="number" name="reservationNo" placeholder="e.g. 1001">
            </div>

            <button type="submit" class="btn primary">
                <i class="fa-solid fa-magnifying-glass"></i> Search
            </button>

            <a href="<%=request.getContextPath()%>/view-reservation" class="btn ghost">
                <i class="fa-solid fa-list"></i> Show All
            </a>
        </form>
    </div>

    <div style="height:14px;"></div>

    <% if (one != null) { %>
        <div class="card">
            <h2 style="margin:0 0 10px;">
                <i class="fa-solid fa-circle-check"></i> Search Result
            </h2>

            <div class="table-wrap">
                <table class="table">
                    <tbody>
                    <tr><th>Reservation No</th><td><%= one.getReservationNo() %></td></tr>
                    <tr><th>Guest Name</th><td><%= one.getGuestName() %></td></tr>
                    <tr><th>Address</th><td><%= one.getAddress() %></td></tr>
                    <tr><th>Contact Number</th><td><%= one.getContactNumber() %></td></tr>
                    <tr><th>Room Type</th><td><%= one.getRoomType() %></td></tr>
                    <tr><th>Check-in</th><td><%= one.getCheckIn() %></td></tr>
                    <tr><th>Check-out</th><td><%= one.getCheckOut() %></td></tr>
                    <tr>
                        <th>Status</th>
                        <td>
                            <%
                                String stOne = one.getStatus();
                                String clsOne = "active";
                                if ("PAID".equalsIgnoreCase(stOne)) clsOne = "paid";
                                if ("CANCELLED".equalsIgnoreCase(stOne)) clsOne = "cancelled";
                            %>
                            <span class="badge <%=clsOne%>"><%= stOne %></span>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <div style="height:14px;"></div>
    <% } %>

    <div class="card">
        <h2 style="margin:0 0 10px;">
            <i class="fa-solid fa-table"></i> All Reservations
        </h2>

        <div class="table-wrap">
            <table class="table">
                <thead>
                <tr>
                    <th>Res No</th>
                    <th>Guest</th>
                    <th>Contact</th>
                    <th>Room</th>
                    <th>Check-in</th>
                    <th>Check-out</th>
                    <th>Status</th>
                </tr>
                </thead>
                <tbody>

                <%
                    if (list == null || list.isEmpty()) {
                %>
                    <tr>
                        <td colspan="7"><small>No reservations found.</small></td>
                    </tr>
                <%
                    } else {
                        for (Reservation r : list) {
                            String st = r.getStatus();
                            String cls = "active";
                            if ("PAID".equalsIgnoreCase(st)) cls = "paid";
                            if ("CANCELLED".equalsIgnoreCase(st)) cls = "cancelled";
                %>
                    <tr>
                        <td><%= r.getReservationNo() %></td>
                        <td><%= r.getGuestName() %></td>
                        <td><%= r.getContactNumber() %></td>
                        <td><%= r.getRoomType() %></td>
                        <td><%= r.getCheckIn() %></td>
                        <td><%= r.getCheckOut() %></td>
                        <td><span class="badge <%=cls%>"><%= st %></span></td>
                    </tr>
                <%
                        }
                    }
                %>

                </tbody>
            </table>
        </div>
    </div>

</div>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>