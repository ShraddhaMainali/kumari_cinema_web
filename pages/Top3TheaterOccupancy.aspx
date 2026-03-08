<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Top3TheaterOccupancy.aspx.cs" Inherits="kumari_cinema_web.pages.Top3TheaterOccupancy" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Top 3 Theater Occupancy</title>
    <style>
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
        }
        .search-box input[type="submit"],
        .search-box button {
            padding: 10px 20px;
            background: linear-gradient(180deg, #5b8dc9 0%, #4a7ab8 100%);
            color: #fff;
            border: none;
            border-radius: 8px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
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
        .grid {
            margin-top: 24px;
            overflow-x: auto;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(91, 141, 201, 0.1);
            border: 1px solid #e2e8f0;
        }
        .grid table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
        }
        .grid table th {
            background: linear-gradient(180deg, #5b8dc9 0%, #4a7ab8 100%);
            color: #fff;
            font-weight: 600;
            padding: 14px 18px;
            text-align: left;
            font-size: 0.8rem;
            text-transform: uppercase;
        }
        .grid table td {
            padding: 14px 18px;
            border-bottom: 1px solid #f1f5f9;
            color: #475569;
            font-size: 0.95rem;
        }
        .grid table tbody tr:nth-child(even) td { background: #f8fafc; }
        .grid table tbody tr:hover td { background: #eef5fc; }
        .section-separator {
            margin: 48px 0 32px 0;
            padding-top: 32px;
            border-top: 2px solid #e2e8f0;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">

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

            <div class="section-separator">
                <h2>Movie Theater City Hall Occupancy Performer</h2>
                <div class="grid">
                    <asp:GridView ID="GridViewOccupancy" runat="server" AutoGenerateColumns="false" Width="100%">
                        <Columns>
                            <asp:BoundField DataField="MOVIE_TITLE" HeaderText="Movie Title" />
                            <asp:BoundField DataField="HALLID" HeaderText="Hall ID" />
                            <asp:BoundField DataField="HALL_CAPACITY" HeaderText="Hall Capacity" />
                            <asp:BoundField DataField="TICKETS_SOLD" HeaderText="Tickets Sold" />
                            <asp:BoundField DataField="OCCUPANCY_PERCENT" HeaderText="Occupancy Percent" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>

        </div>
    </form>
</body>
</html>
