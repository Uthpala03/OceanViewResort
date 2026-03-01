<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.oceanviewresort.util.DBConnectionManager" %>

<!DOCTYPE html>
<html>
<head>
    <title>Payments - Ocean View Resort</title>
</head>
<body>

<jsp:include page="includes/header.jsp"/>

<div class="container">

    <div class="card">
        <h1 style="margin:0 0 6px;">Payment History</h1>
        <small>All payment records (latest first)</small>

        <div style="height:12px;"></div>

        <table class="table">
            <thead>
            <tr>
                <th>Payment ID</th>
                <th>Reservation No</th>
                <th>Nights</th>
                <th>Total Amount (Rs)</th>
                <th>Payment Date</th>
            </tr>
            </thead>

            <tbody>
            <%
                String sql = "SELECT payment_id, reservation_no, nights, total_amount, payment_date " +
                             "FROM payments ORDER BY payment_id DESC";

                boolean hasRows = false;
                double grandTotal = 0;

                SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy | hh:mm a");

                try (Connection con = DBConnectionManager.getInstance().getConnection();
                     PreparedStatement ps = con.prepareStatement(sql);
                     ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {
                        hasRows = true;

                        double amount = rs.getDouble("total_amount");
                        grandTotal += amount;

                        Timestamp ts = rs.getTimestamp("payment_date");
            %>
                        <tr>
                            <td><%= rs.getInt("payment_id") %></td>
                            <td><%= rs.getInt("reservation_no") %></td>
                            <td><%= rs.getInt("nights") %></td>
                            <td>Rs. <%= String.format("%,.2f", amount) %></td>
                            <td><%= (ts != null ? sdf.format(ts) : "-") %></td>
                        </tr>
            <%
                    }

                } catch (Exception e) {
            %>
                    <tr>
                        <td colspan="5">
                            <div class="alert bad">Error loading payments. Please try again.</div>
                        </td>
                    </tr>
            <%
                }

                if (!hasRows) {
            %>
                    <tr>
                        <td colspan="5"><small>No payments found.</small></td>
                    </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <!-- ✅ GRAND TOTAL -->
        <div style="margin-top:18px; text-align:right; font-size:18px; font-weight:800;">
            Total Payments:
            <span style="color:#0ea5e9;">
                Rs. <%= String.format("%,.2f", grandTotal) %>
            </span>
        </div>

        <div style="margin-top:12px;">
            <a class="btn ghost" href="dashboard.jsp">Back</a>
        </div>

    </div>

</div>

<jsp:include page="includes/footer.jsp"/>

</body>
</html>