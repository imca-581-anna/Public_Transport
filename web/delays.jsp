
<%@ page import="java.sql.*" %>
<%@ page import="com.transport.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Bus Delays</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<header>
    <h1>Bus Delay Notifications</h1>
    <p>Check service disruptions and traffic delays</p>
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
    <h2>Service Alerts</h2>

    <table border="1" cellpadding="10"
           cellspacing="0" width="100%">
        <tr>
            <th>Alert ID</th>
            <th>Bus Number</th>
            <th>Delay (Minutes)</th>
            <th>Message</th>
        </tr>

        <%
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT d.delay_id, b.bus_number, " +
                "d.delay_minutes, d.message " +
                "FROM delays d INNER JOIN buses b " +
                "ON d.bus_id = b.bus_id ORDER BY d.delay_id DESC");
             ResultSet rs = ps.executeQuery()) {

            boolean found = false;

            while (rs.next()) {
                found = true;
        %>

        <tr>
            <td><%= rs.getInt("delay_id") %></td>
            <td><%= rs.getString("bus_number") %></td>
            <td><%= rs.getInt("delay_minutes") %></td>
            <td><%= rs.getString("message") %></td>
        </tr>

        <%
            }

            if (!found) {
        %>
        <tr><td colspan="4">No delay alerts at present.</td></tr>
        <%
            }

        } catch (Exception e) {
        %>
        <tr><td colspan="4">Unable to load delay alerts.</td></tr>
        <%
            application.log("Error loading delays", e);
        }
        %>
    </table>
</main>

</body>
</html>
