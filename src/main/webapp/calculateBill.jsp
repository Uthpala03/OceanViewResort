<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String error = (String) request.getAttribute("error");
    String success = (String) request.getAttribute("success");

    String resNo = request.getParameter("reservationNo");
    if (resNo == null) resNo = "";

    Integer nights = (Integer) request.getAttribute("nights");
    Integer price = (Integer) request.getAttribute("price");
    Double total = (Double) request.getAttribute("total");
    String status = (String) request.getAttribute("status");

    double serviceCharge = 0.0;
    double grandTotal = 0.0;

    if (total != null) {
        serviceCharge = total * 0.10;
        grandTotal = total + serviceCharge;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Calculate Bill - Ocean View Resort</title>
</head>
<body>

<jsp:include page="includes/header.jsp"/>

<div class="container">

    <div class="card">
        <h1 style="margin:0 0 6px;">Calculate Bill</h1>
        <small>Step 1: Calculate bill. Step 2: If customer paid, click Save Payment.</small>

        <% if (error != null) { %><div class="alert bad"><%= error %></div><% } %>
        <% if (success != null) { %><div class="alert ok"><%= success %></div><% } %>

        <form action="<%=request.getContextPath()%>/calculate-bill" method="get"
              style="margin-top:14px; display:flex; gap:10px; flex-wrap:wrap; align-items:end;">
            <div style="flex:1; min-width:220px;">
                <small>Reservation No</small>
                <input type="number" name="reservationNo" value="<%= resNo %>" placeholder="e.g. 1001" required>
            </div>

            <input type="hidden" name="action" value="calc">
            <button class="btn primary" type="submit">Calculate</button>

            <a class="btn ghost" href="calculateBill.jsp">Clear</a>
        </form>
    </div>

    <div style="height:14px;"></div>

    <% if (nights != null && price != null && total != null) { %>
    <div class="card">
        <h2 style="margin:0 0 10px;">Bill Details</h2>

        <table class="table">
            <tr><th>Reservation No</th><td><%= request.getAttribute("reservationNo") %></td></tr>
            <tr><th>Guest Name</th><td><%= request.getAttribute("guest_name") %></td></tr>
            <tr><th>Room Type</th><td><%= request.getAttribute("room_type") %></td></tr>
            <tr><th>Status</th><td><b><%= status %></b></td></tr>

            <tr><th>Nights</th><td><%= nights %></td></tr>

            <tr>
                <th>Rate per Night</th>
                <td>Rs. <%= String.format("%,.2f", price.doubleValue()) %></td>
            </tr>

            <tr>
                <th>Room Total</th>
                <td><b>Rs. <%= String.format("%,.2f", total) %></b></td>
            </tr>

            <tr>
                <th>Service Charge (10%)</th>
                <td>Rs. <%= String.format("%,.2f", serviceCharge) %></td>
            </tr>

            <tr>
                <th>Grand Total</th>
                <td style="font-size:16px;">
                    <b>Rs. <%= String.format("%,.2f", grandTotal) %></b>
                </td>
            </tr>
        </table>

        <div style="margin-top:12px; display:flex; gap:10px; flex-wrap:wrap;">
            <form action="<%=request.getContextPath()%>/calculate-bill" method="get" style="display:inline;">
                <input type="hidden" name="reservationNo" value="<%= resNo %>">
                <input type="hidden" name="action" value="pay">
                <button class="btn ok" type="submit" <%= "PAID".equalsIgnoreCase(status) ? "disabled" : "" %>>
                    Save Payment (Mark as PAID)
                </button>
            </form>

            <form action="<%=request.getContextPath()%>/print-bill" method="get" style="display:inline;">
                <input type="hidden" name="reservationNo" value="<%= resNo %>">
                <button class="btn ghost" type="submit">Print Bill</button>
            </form>

            <a class="btn ghost" href="dashboard.jsp">Back</a>
        </div>

        <div style="margin-top:10px;">
            <small>* Grand Total includes 10% service charge.</small>
        </div>
    </div>
    <% } %>

</div>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>