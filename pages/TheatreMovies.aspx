<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="TheatreMovies.aspx.cs" Inherits="kumari_cinema_web.pages.TheatreMovies" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Theater Movies and User Tickets</title>

    <style>
        /* Theme: same soft blue as Site1.Master & Style.css */
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #eef2f7;
            color: #334155;
            min-height: 100vh;
            padding: 28px 24px;
        }

        .container {
            max-width: 98%;
            width: 100%;
            margin: 0 auto;
            background: #fff;
            padding: 32px 36px;
            border-radius: 12px;
            box-shadow: 0 4px 24px rgba(91, 141, 201, 0.12);
            border: 1px solid #e2e8f0;
        }

        h2 {
            font-size: 1.5rem;
            font-weight: 600;
            color: #4a7ab8;
            border-bottom: 3px solid #5b8dc9;
            padding-bottom: 0.5rem;
            margin-bottom: 1.5rem;
            letter-spacing: 0.02em;
        }

        .section-spacer {
            margin-top: 48px;
            padding-top: 32px;
            border-top: 1px solid #e2e8f0;
        }

        .search-box {
            margin-bottom: 24px;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 12px;
        }

        .search-box input[type="text"] {
            padding: 10px 14px;
            width: 180px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: inherit;
            background: #fff;
            color: #334155;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .search-box input[type="text"]:focus {
            outline: none;
            border-color: #5b8dc9;
            box-shadow: 0 0 0 3px rgba(91, 141, 201, 0.2);
        }

        .search-box .search-dropdown,
        .search-box select.search-dropdown {
            padding: 10px 14px;
            min-width: 200px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: inherit;
            background: #fff;
            color: #334155;
        }

        .search-box input[type="submit"],
        .search-box button {
            padding: 10px 20px;
            background: linear-gradient(180deg, #5b8dc9 0%, #4a7ab8 100%);
            color: #fff !important;
            border: none;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(74, 122, 184, 0.3);
        }

        .search-box input[type="submit"]:hover,
        .search-box button:hover {
            background: linear-gradient(180deg, #4a7ab8 0%, #3d6a9e 100%);
            box-shadow: 0 4px 12px rgba(74, 122, 184, 0.4);
            transform: translateY(-1px);
        }

        .message {
            display: block;
            margin: 12px 0 20px 0;
            padding: 12px 16px;
            color: #721c24;
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            font-size: 0.95rem;
        }

        /* Table: eye-catchy, matches project theme */
        .grid {
            margin-top: 24px;
            overflow-x: auto;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(91, 141, 201, 0.1);
            border: 1px solid #e2e8f0;
        }

        .grid table {
            width: 100% !important;
            border-collapse: collapse;
            background: #fff !important;
        }

        .grid table th {
            background: linear-gradient(180deg, #5b8dc9 0%, #4a7ab8 100%) !important;
            color: #fff !important;
            font-weight: 600;
            padding: 14px 18px;
            text-align: left;
            border: none !important;
            letter-spacing: 0.03em;
            font-size: 0.8rem;
            text-transform: uppercase;
        }

        .grid table td {
            padding: 14px 18px;
            border-bottom: 1px solid #f1f5f9 !important;
            color: #475569 !important;
            background: #fff !important;
            font-size: 0.95rem;
        }

        .grid table tbody tr:nth-child(even) td {
            background: #f8fafc !important;
        }

        .grid table tbody tr:hover td {
            background: #eef5fc !important;
        }

        .grid table tbody tr:last-child td {
            border-bottom: none !important;
        }

        @media (max-width: 768px) {
            body { padding: 16px; }
            .container { padding: 20px; }
            .grid table th,
            .grid table td { padding: 10px 12px; font-size: 0.9rem; }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">

            <!-- User Tickets section -->
            <h2>User Ticket Details</h2>
            <div class="search-box">
                User ID :
                <asp:TextBox ID="txtUserId" runat="server" />
                <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
            </div>
            <asp:Label ID="lblMessage" runat="server" CssClass="message" Visible="false" />
            <div class="grid">
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="true" Width="100%" />
            </div>

            <!-- Theater City Hall movie details and showtimes section -->
            <div class="section-spacer">
                <h2>Theater City Hall – Movie Details and Showtimes</h2>
                <p style="margin-bottom: 16px; color: #64748b;">For any theater city hall, the detail of movie and showtime is shown below.</p>
                <div class="search-box">
                    <label for="ddlTheaterCityHall" style="font-weight: 600;">Theater City Hall:</label>
                    <asp:DropDownList ID="ddlTheaterCityHall" runat="server" CssClass="search-dropdown" />
                    <asp:Button ID="btnFilterTheater" runat="server" Text="Search" OnClick="btnFilterTheater_Click" />
                </div>
                <asp:Label ID="lblTheaterMessage" runat="server" CssClass="message" Visible="false" />
                <div class="grid">
                    <asp:GridView ID="GridViewTheaterCityHall" runat="server" AutoGenerateColumns="true" Width="100%" />
                </div>
            </div>

        </div>
    </form>
</body>
</html>
