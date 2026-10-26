
<%@ page import="java.sql.*" %>
<%@ page import="com.transport.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Bus Timetable</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<header>
    <h1>Bus Timetable</h1>
    <p>Check scheduled bus arrival times</p>
</header>

<nav>
    <a href="index.jsp">Home</a>
    <a href="buses.jsp">Track Buses</a>
    <a href="routes.jsp">Routes</a>
    <a href="timetable.jsp">Timetable</a>
    <a href="delays.jsp">Delays</a>
    <a href="alternatives.jsp">Alternative Routes</a>
</nav>

<main>
    <h2>Scheduled Arrivals</h2>

    <table border="1" cellpadding="10"
           cellspacing="0" width="100%">
        <tr>
            <th>Stop ID</th>
            <th>Route</th>
            <th>Bus Stop</th>
            <th>Arrival Time</th>
        </tr>

        <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT s.stop_id, r.route_name, s.stop_name, " +
                "s.arrival_time FROM bus_stops s " +
                "INNER JOIN routes r ON s.route_id = r.route_id " +
                "ORDER BY s.route_id, s.arrival_time");
             ResultSet rs = ps.executeQuery()) {

            boolean found = false;

            while (rs.next()) {
                found = true;
        %>

        <tr>
            <td><%= rs.getInt("stop_id") %></td>
            <td><%= rs.getString("route_name") %></td>
            <td><%= rs.getString("stop_name") %></td>
            <td><%= rs.getString("arrival_time") == null
                    ? "Not scheduled" : rs.getString("arrival_time") %></td>
        </tr>

        <%
            }

            if (!found) {
        %>
        <tr><td colspan="4">No timetable available.</td></tr>
        <%
            }

        } catch (Exception e) {
        %>
        <tr><td colspan="4">Unable to load timetable.</td></tr>
        <%
            application.log("Error loading timetable", e);
        }
        %>
    </table>
</main>

</body>
</html>
