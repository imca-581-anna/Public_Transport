
<%@ page import="java.sql.*" %>
<%@ page import="com.transport.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>Alternative Bus Routes</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<header>
    <h1>Alternative Routes</h1>
    <p>Explore other available bus routes</p>
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
    <h2>Find an Alternative Route</h2>

    <form action="alternatives.jsp" method="get">
        <label for="routeId">Select your current route:</label>

        <select name="routeId" id="routeId">
            <option value="">All routes</option>

            <%
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(
                    "SELECT route_id, route_name FROM routes " +
                    "ORDER BY route_id");
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    int id = rs.getInt("route_id");
                    String name = rs.getString("route_name");
                    String selected = "";

                    if (String.valueOf(id).equals(
                            request.getParameter("routeId"))) {
                        selected = "selected";
                    }
            %>

            <option value="<%= id %>" <%= selected %>>
                <%= name %>
            </option>

            <%
                }
            } catch (Exception e) {
                application.log("Error loading route options", e);
            }
            %>
        </select>

        <button type="submit">Find Alternatives</button>
    </form>

    <h2>Other Available Routes</h2>

    <table border="1" cellpadding="10"
           cellspacing="0" width="100%">
        <tr>
            <th>Route ID</th>
            <th>Route Name</th>
            <th>Starting Point</th>
            <th>Destination</th>
        </tr>

        <%
        String routeParam = request.getParameter("routeId");
        int routeId = 0;
        boolean validRouteId = false;

        if (routeParam != null && !routeParam.trim().isEmpty()) {
            try {
                routeId = Integer.parseInt(routeParam);

                if (routeId > 0) {
                    validRouteId = true;
                }
            } catch (NumberFormatException e) {
                validRouteId = false;
            }
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(
                "SELECT route_id, route_name, start_point, end_point " +
                "FROM routes " +
                "WHERE (? = 0 OR route_id <> ?) " +
                "ORDER BY route_id")) {

            ps.setInt(1, validRouteId ? routeId : 0);
            ps.setInt(2, validRouteId ? routeId : 0);

            try (ResultSet rs = ps.executeQuery()) {
                boolean found = false;

                while (rs.next()) {
                    found = true;
        %>

        <tr>
            <td><%= rs.getInt("route_id") %></td>
            <td><%= rs.getString("route_name") %></td>
            <td><%= rs.getString("start_point") %></td>
            <td><%= rs.getString("end_point") %></td>
        </tr>

        <%
                }

                if (!found) {
        %>
        <tr>
            <td colspan="4">No alternative routes found.</td>
        </tr>
        <%
                }
            }

        } catch (Exception e) {
        %>
        <tr>
            <td colspan="4">Unable to load alternative routes.</td>
        </tr>
        <%
            application.log("Error loading alternatives", e);
        }
        %>
    </table>

    <p>
        Note: These are other routes in the database.
        They are not guaranteed to reach the same destination.
    </p>
</main>

</body>
</html>
