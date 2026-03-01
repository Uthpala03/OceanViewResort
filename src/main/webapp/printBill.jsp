<%@ page contentType="text/html;charset=UTF-8" %>
<%
    Object reservationNo = request.getAttribute("reservationNo");
    Object guestName = request.getAttribute("guest_name");
    Object roomType = request.getAttribute("room_type");
    Object nights = request.getAttribute("nights");
    Object price = request.getAttribute("price");
    Object total = request.getAttribute("total");
    Object status = request.getAttribute("status");

    if (status == null) status = "ACTIVE";

    double roomTotal = (total == null) ? 0.0 : ((Number) total).doubleValue();
    double pricePerNight = (price == null) ? 0.0 : ((Number) price).doubleValue();

    double serviceCharge = roomTotal * 0.10;
    double grandTotal = roomTotal + serviceCharge;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Print Bill - Ocean View Resort</title>

    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">

    <style>
        .invoice-wrap{
            width: min(820px, 94vw);
            margin: 22px auto;
        }
        .invoice{
            background:#fff;
            border:1px solid #e6e8ef;
            border-radius:14px;
            box-shadow: 0 10px 24px rgba(17,24,39,.08);
            padding: 22px;
        }
        .inv-top{
            display:flex;
            justify-content:space-between;
            gap:12px;
            flex-wrap:wrap;
            align-items:flex-start;
        }
        .inv-title{ margin:0; font-size: 22px; }
        .muted{ color:#6b7280; font-size:13px; margin-top:6px; }
        .inv-badge{
            display:inline-block;
            padding:6px 10px;
            border-radius:999px;
            font-size:12px;
            border:1px solid #e6e8ef;
            background:#f8fafc;
        }
        .inv-grid{
            display:grid;
            grid-template-columns: 1fr;
            gap:12px;
            margin-top: 14px;
        }
        @media(min-width:900px){ .inv-grid{ grid-template-columns: 1fr 1fr; } }

        .inv-row{
            display:flex;
            justify-content:space-between;
            gap:12px;
            padding:10px 12px;
            border:1px solid #e6e8ef;
            border-radius:12px;
            background:#fff;
        }
        .inv-row b{ font-weight:800; }

        .total-box{
            margin-top:14px;
            padding:14px 16px;
            border:1px solid rgba(14,165,233,.25);
            background: rgba(14,165,233,.06);
            border-radius: 12px;
        }
        .total-line{
            display:flex;
            justify-content:space-between;
            gap:12px;
            margin-top:8px;
            font-size:14px;
        }
        .grand{
            font-size:18px;
            font-weight:900;
        }

        @media print{
            .no-print{ display:none !important; }
            body{ background:#fff; }
            .invoice-wrap{ width: 100%; margin:0; }
            .invoice{ box-shadow:none; border:0; border-radius:0; }
        }
    </style>
</head>

<body>

<div class="invoice-wrap">
    <div class="invoice">

        <div class="inv-top">
            <div>
                <h1 class="inv-title">Ocean View Resort — Guest Bill</h1>
                <div class="muted">Galle, Sri Lanka</div>
            </div>

            <div style="text-align:right;">
                <div class="inv-badge">Status: <b><%= status %></b></div>
                <div class="muted">Reservation No: <b><%= reservationNo %></b></div>
            </div>
        </div>

        <div class="inv-grid">
            <div class="inv-row"><span>Guest Name</span><b><%= guestName %></b></div>
            <div class="inv-row"><span>Room Type</span><b><%= roomType %></b></div>
            <div class="inv-row"><span>Nights</span><b><%= nights %></b></div>
            <div class="inv-row">
                <span>Price / Night</span>
                <b>Rs. <%= String.format("%,.2f", pricePerNight) %></b>
            </div>
        </div>

        <div class="total-box">
            <div style="font-weight:900;">Payment Summary</div>
            <div class="muted">Includes room charges + 10% service charge</div>

            <div class="total-line">
                <span>Room Total</span>
                <b>Rs. <%= String.format("%,.2f", roomTotal) %></b>
            </div>

            <div class="total-line">
                <span>Service Charge (10%)</span>
                <b>Rs. <%= String.format("%,.2f", serviceCharge) %></b>
            </div>

            <div class="total-line grand">
                <span>Grand Total</span>
                <span>Rs. <%= String.format("%,.2f", grandTotal) %></span>
            </div>
        </div>

        <div class="muted" style="margin-top:14px;">
            Note: Please keep this bill for your records. Thank you for staying with Ocean View Resort.
        </div>

        <div class="no-print" style="margin-top:16px; display:flex; gap:10px; flex-wrap:wrap;">
            <button class="btn primary" onclick="window.print()">Print</button>
            <a class="btn ghost" href="calculateBill.jsp">Back</a>
            <a class="btn ghost" href="dashboard.jsp">Dashboard</a>
        </div>

    </div>
</div>

</body>
</html>