<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="kumari_cinema_web.pages.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard-page">
        <h2 class="dashboard-title">Dashboard</h2>
        <p class="dashboard-subtitle">Key statistics at a glance</p>

        <div class="stats-grid">
            <div class="stat-card stat-users">
                <div class="stat-label">Total Users</div>
                <div class="stat-value">
                    <asp:Label ID="lblTotalUsers" runat="server" Text="N/A" />
                </div>
                <div class="stat-desc">Registered users</div>
            </div>
            <div class="stat-card stat-movies">
                <div class="stat-label">Total Movies</div>
                <div class="stat-value">
                    <asp:Label ID="lblTotalMovies" runat="server" Text="N/A" />
                </div>
                <div class="stat-desc">Movies in the system</div>
            </div>
            <div class="stat-card stat-bookings">
                <div class="stat-label">Total Bookings</div>
                <div class="stat-value">
                    <asp:Label ID="lblTotalBookings" runat="server" Text="N/A" />
                </div>
                <div class="stat-desc">Ticket bookings</div>
            </div>
            <div class="stat-card stat-showing">
                <div class="stat-label">Movies Currently Showing</div>
                <div class="stat-value">
                    <asp:Label ID="lblCurrentlyShowing" runat="server" Text="N/A" />
                </div>
                <div class="stat-desc">With scheduled shows today or later</div>
            </div>
            <div class="stat-card stat-theatres">
                <div class="stat-label">Total Theatres</div>
                <div class="stat-value">
                    <asp:Label ID="lblTotalTheatres" runat="server" Text="N/A" />
                </div>
                <div class="stat-desc">Theatre venues in the system</div>
            </div>
        </div>

        <div class="dashboard-actions">
            <asp:Button ID="btnViewReport" runat="server" CssClass="btn-view-report" Text="View Report" OnClick="btnViewReport_Click" UseSubmitBehavior="true" />
        </div>

        <!-- Report sections: hidden until "View Report" is clicked -->
        <asp:Panel ID="ReportPanel" runat="server" Visible="false" CssClass="report-panel">
            <h3 class="report-section-title">User Tickets</h3>
            <div class="report-search-box">
                User ID :
                <asp:TextBox ID="txtReportUserId" runat="server" />
                <asp:Button ID="btnReportSearch" runat="server" Text="Search" OnClick="btnReportSearch_Click" />
            </div>
            <asp:Label ID="lblReportMessage" runat="server" CssClass="report-message" Visible="false" />
            <div class="report-grid">
                <asp:GridView ID="GridViewReportTickets" runat="server" AutoGenerateColumns="true" Width="100%" />
            </div>

            <div class="report-section-spacer">
                <h3 class="report-section-title">Theatre Movies</h3>
                <p class="report-desc">For any theater city hall, the detail of movie and showtime is shown below.</p>
                <div class="report-search-box">
                    <label for="ddlReportTheaterCityHall" style="font-weight: 600;">Theater City Hall:</label>
                    <asp:DropDownList ID="ddlReportTheaterCityHall" runat="server" CssClass="report-dropdown" />
                    <asp:Button ID="btnReportFilterTheater" runat="server" Text="Search" OnClick="btnReportFilterTheater_Click" />
                </div>
                <asp:Label ID="lblReportTheaterMessage" runat="server" CssClass="report-message" Visible="false" />
                <div class="report-grid">
                    <asp:GridView ID="GridViewReportTheater" runat="server" AutoGenerateColumns="true" Width="100%" />
                </div>
            </div>

            <div class="report-section-spacer">
                <h3 class="report-section-title">Top 3 Theatre Occupancy</h3>
                <div class="report-grid">
                    <asp:GridView ID="GridViewReportOccupancy" runat="server" AutoGenerateColumns="false" Width="100%">
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
        </asp:Panel>
    </div>

    <style>
        .dashboard-page { padding: 0 0 2rem 0; width: 100%; }
        .dashboard-title { margin-bottom: 0.25rem; }
        .dashboard-subtitle {
            color: #64748b;
            font-size: 0.95rem;
            margin-bottom: 2rem;
        }
        /* Five key statistics in a single row, same style as Total Movies */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        .stat-card {
            background: #fff;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 4px 20px rgba(91, 141, 201, 0.1);
            border: 1px solid #e2e8f0;
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 28px rgba(91, 141, 201, 0.15);
        }
        .stat-label {
            font-size: 0.8rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: #64748b;
            margin-bottom: 0.35rem;
        }
        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #334155;
            line-height: 1.2;
        }
        .stat-value .aspNetLabel { font-size: inherit; font-weight: inherit; color: inherit; }
        .stat-desc {
            font-size: 0.8rem;
            color: #94a3b8;
            margin-top: 0.35rem;
        }
        .stat-users .stat-value { color: #4a7ab8; }
        .stat-movies .stat-value { color: #0d9488; }
        .stat-bookings .stat-value { color: #c2410c; }
        .stat-showing .stat-value { color: #7c3aed; }
        .stat-theatres .stat-value { color: #059669; }
        .dashboard-actions { text-align: center; }
        .btn-view-report {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 14px 28px;
            background: linear-gradient(135deg, #5b8dc9 0%, #4a7ab8 50%, #3d6a9e 100%);
            color: #fff !important;
            text-decoration: none !important;
            font-weight: 600;
            font-size: 1.05rem;
            border-radius: 10px;
            box-shadow: 0 4px 16px rgba(74, 122, 184, 0.4);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border: none;
        }
        .btn-view-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 24px rgba(74, 122, 184, 0.5);
            color: #fff !important;
        }
        /* Report panel (shown when View Report is clicked) */
        .report-panel {
            margin-top: 2.5rem;
            padding-top: 2rem;
            border-top: 1px solid #e2e8f0;
        }
        .report-section-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #4a7ab8;
            border-bottom: 3px solid #5b8dc9;
            padding-bottom: 0.5rem;
            margin-bottom: 1rem;
        }
        .report-desc { margin-bottom: 1rem; color: #64748b; }
        .report-search-box {
            margin-bottom: 1rem;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 0.75rem;
        }
        .report-search-box input[type="text"] {
            padding: 8px 12px;
            width: 160px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 0.95rem;
        }
        .report-dropdown {
            padding: 8px 12px;
            min-width: 180px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 0.95rem;
        }
        .report-search-box input[type="submit"],
        .report-search-box button {
            padding: 8px 18px;
            background: linear-gradient(180deg, #5b8dc9 0%, #4a7ab8 100%);
            color: #fff !important;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
        }
        .report-message {
            display: block;
            margin: 0.5rem 0 1rem 0;
            padding: 10px 14px;
            color: #721c24;
            background: #f8d7da;
            border: 1px solid #f5c6cb;
            border-radius: 8px;
            font-size: 0.9rem;
        }
        .report-grid {
            margin-top: 1rem;
            margin-bottom: 1.5rem;
            overflow-x: auto;
            border-radius: 10px;
            box-shadow: 0 4px 20px rgba(91, 141, 201, 0.1);
            border: 1px solid #e2e8f0;
        }
        .report-grid table { width: 100% !important; border-collapse: collapse; background: #fff !important; }
        .report-grid table th {
            background: linear-gradient(180deg, #5b8dc9 0%, #4a7ab8 100%) !important;
            color: #fff !important;
            font-weight: 600;
            padding: 12px 16px;
            text-align: left;
            font-size: 0.8rem;
            text-transform: uppercase;
        }
        .report-grid table td {
            padding: 12px 16px;
            border-bottom: 1px solid #f1f5f9 !important;
            color: #475569 !important;
            background: #fff !important;
            font-size: 0.9rem;
        }
        .report-grid table tbody tr:nth-child(even) td { background: #f8fafc !important; }
        .report-grid table tbody tr:hover td { background: #eef5fc !important; }
        .report-section-spacer {
            margin-top: 2.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #e2e8f0;
        }
        @media (max-width: 1200px) {
            .stats-grid { grid-template-columns: repeat(3, 1fr); }
        }
        @media (max-width: 768px) {
            .stats-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 500px) {
            .stats-grid { grid-template-columns: 1fr; }
            .stat-value { font-size: 1.65rem; }
        }
    </style>
</asp:Content>
