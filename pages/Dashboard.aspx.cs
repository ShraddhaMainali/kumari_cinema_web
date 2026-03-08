using System;
using System.Configuration;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace kumari_cinema_web.pages
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private const string SqlUserTickets = @"
SELECT u.USERID, u.USER_USERNAME, u.USER_EMAIL, t.TICKETID, t.TICKET_NUMBER, stm.SEATID,
       t.FINAL_TICKET_PRICE, t.PURCHASE_DATETIME, m.MOVIE_TITLE, s.SHOW_DATE, s.SHOW_TIME,
       s.START_DATETIME, s.END_DATETIME
FROM USERS u
LEFT JOIN SHOW_TICKET stm ON u.USERID = stm.USERID
LEFT JOIN TICKET t ON stm.TICKETID = t.TICKETID
LEFT JOIN SHOW s ON stm.SHOWID = s.SHOWID
LEFT JOIN MOVIE m ON stm.MOVIEID = m.MOVIEID
WHERE u.USERID = :USERID
ORDER BY t.PURCHASE_DATETIME DESC";

        private const string SqlTheaterCityHall = @"
SELECT t.THEATREID, t.THEATRE_CITY_HALL AS TheaterCityHall, ms.HALLID, m.MOVIEID,
       m.MOVIE_TITLE AS MovieTitle, s.SHOWID, s.SHOW_TIME AS ShowTime
FROM MOVIE_SHOW ms
JOIN MOVIE m ON ms.MOVIEID = m.MOVIEID
JOIN SHOW s ON ms.SHOWID = s.SHOWID
JOIN THEATRE t ON ms.THEATREID = t.THEATREID
WHERE t.THEATRE_CITY_HALL = :CITYHALL
ORDER BY ms.HALLID, s.SHOW_TIME";

        private const string SqlTheaterCityHallAll = @"
SELECT t.THEATREID, t.THEATRE_CITY_HALL AS TheaterCityHall, ms.HALLID, m.MOVIEID,
       m.MOVIE_TITLE AS MovieTitle, s.SHOWID, s.SHOW_TIME AS ShowTime
FROM MOVIE_SHOW ms
JOIN MOVIE m ON ms.MOVIEID = m.MOVIEID
JOIN SHOW s ON ms.SHOWID = s.SHOWID
JOIN THEATRE t ON ms.THEATREID = t.THEATREID
ORDER BY t.THEATRE_CITY_HALL, ms.HALLID, s.SHOW_TIME";

        private const string SqlCityHalls = "SELECT DISTINCT THEATRE_CITY_HALL FROM THEATRE ORDER BY THEATRE_CITY_HALL";

        private const string SqlTop3Occupancy = @"
SELECT * FROM (
    SELECT M.MOVIE_TITLE, H.HALLID, H.HALL_CAPACITY, COUNT(T.TICKETID) AS TICKETS_SOLD,
           ROUND((COUNT(T.TICKETID) / H.HALL_CAPACITY) * 100, 2) AS OCCUPANCY_PERCENT
    FROM MOVIE M
    JOIN MOVIE_SHOW MS ON M.MOVIEID = MS.MOVIEID
    JOIN SHOW S ON MS.SHOWID = S.SHOWID
    JOIN SHOW_TICKET ST ON S.SHOWID = ST.SHOWID
    JOIN TICKET T ON ST.TICKETID = T.TICKETID
    JOIN HALL H ON MS.HALLID = H.HALLID
    WHERE T.TICKET_STATUS = 'PAID'
    GROUP BY M.MOVIE_TITLE, H.HALLID, H.HALL_CAPACITY
    ORDER BY OCCUPANCY_PERCENT DESC
) WHERE ROWNUM <= 3";

        private bool ReportVisible
        {
            get { return (bool)(ViewState["ReportVisible"] ?? false); }
            set { ViewState["ReportVisible"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
            {
                ReportPanel.Visible = ReportVisible;
                return;
            }
            BindStatistics();
        }

        protected void btnViewReport_Click(object sender, EventArgs e)
        {
            ReportVisible = true;
            ReportPanel.Visible = true;
            if (ddlReportTheaterCityHall.Items.Count == 0)
                BindReportCityHallDropdown();
            BindReportTheaterCityHall();
            BindReportTop3Occupancy();
        }

        protected void btnReportSearch_Click(object sender, EventArgs e)
        {
            lblReportMessage.Visible = false;
            if (string.IsNullOrWhiteSpace(txtReportUserId.Text))
            {
                GridViewReportTickets.DataSource = null;
                GridViewReportTickets.DataBind();
                lblReportMessage.Text = "Please enter a User ID.";
                lblReportMessage.Visible = true;
                return;
            }
            if (!decimal.TryParse(txtReportUserId.Text.Trim(), out decimal userId))
            {
                GridViewReportTickets.DataSource = null;
                GridViewReportTickets.DataBind();
                lblReportMessage.Text = "Please enter a valid numeric User ID.";
                lblReportMessage.Visible = true;
                return;
            }
            BindReportUserTickets(userId);
        }

        protected void btnReportFilterTheater_Click(object sender, EventArgs e)
        {
            lblReportTheaterMessage.Visible = false;
            BindReportTheaterCityHall();
        }

        private void BindReportUserTickets(decimal userId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            if (string.IsNullOrEmpty(connStr))
            {
                GridViewReportTickets.DataSource = null;
                GridViewReportTickets.DataBind();
                lblReportMessage.Text = "Connection string not configured.";
                lblReportMessage.Visible = true;
                return;
            }
            DataTable dt;
            try
            {
                dt = new DataTable();
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = SqlUserTickets;
                        cmd.CommandType = CommandType.Text;
                        var p = new System.Data.OracleClient.OracleParameter("USERID", System.Data.OracleClient.OracleType.Number);
                        p.Value = userId;
                        cmd.Parameters.Add(p);
                        using (var da = new System.Data.OracleClient.OracleDataAdapter(cmd))
                            da.Fill(dt);
                    }
                }
            }
            catch (Exception ex)
            {
                dt = new DataTable();
                lblReportMessage.Text = "Error: " + ex.Message;
                lblReportMessage.Visible = true;
            }
            GridViewReportTickets.DataSource = dt;
            GridViewReportTickets.DataBind();
            if (dt.Rows.Count == 0 && !lblReportMessage.Visible)
            {
                lblReportMessage.Text = "No records found for this User ID.";
                lblReportMessage.Visible = true;
            }
        }

        private void BindReportCityHallDropdown()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            ddlReportTheaterCityHall.Items.Clear();
            ddlReportTheaterCityHall.Items.Add(new ListItem("All", ""));
            if (string.IsNullOrEmpty(connStr)) return;
            try
            {
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = SqlCityHalls;
                        cmd.CommandType = CommandType.Text;
                        using (var rdr = cmd.ExecuteReader())
                        {
                            while (rdr.Read())
                            {
                                var city = rdr.IsDBNull(0) ? "" : rdr.GetString(0);
                                if (!string.IsNullOrEmpty(city))
                                    ddlReportTheaterCityHall.Items.Add(new ListItem(city, city));
                            }
                        }
                    }
                }
            }
            catch { }
        }

        private void BindReportTheaterCityHall()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            if (string.IsNullOrEmpty(connStr))
            {
                GridViewReportTheater.DataSource = null;
                GridViewReportTheater.DataBind();
                return;
            }
            string selectedCity = ddlReportTheaterCityHall.SelectedValue ?? "";
            bool showAll = string.IsNullOrEmpty(selectedCity);
            DataTable dt;
            try
            {
                dt = new DataTable();
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = showAll ? SqlTheaterCityHallAll : SqlTheaterCityHall;
                        cmd.CommandType = CommandType.Text;
                        if (!showAll)
                        {
                            var p = new System.Data.OracleClient.OracleParameter("CITYHALL", System.Data.OracleClient.OracleType.VarChar);
                            p.Value = selectedCity;
                            cmd.Parameters.Add(p);
                        }
                        using (var da = new System.Data.OracleClient.OracleDataAdapter(cmd))
                            da.Fill(dt);
                    }
                }
            }
            catch (Exception ex)
            {
                dt = new DataTable();
                lblReportTheaterMessage.Text = "Error loading show details: " + ex.Message;
                lblReportTheaterMessage.Visible = true;
            }
            GridViewReportTheater.DataSource = dt;
            GridViewReportTheater.DataBind();
            if (dt != null && dt.Rows.Count == 0 && !lblReportTheaterMessage.Visible)
            {
                lblReportTheaterMessage.Text = showAll ? "No movie show details found." : "No show details found for the selected city hall.";
                lblReportTheaterMessage.Visible = true;
            }
        }

        private void BindReportTop3Occupancy()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            if (string.IsNullOrEmpty(connStr))
            {
                GridViewReportOccupancy.DataSource = null;
                GridViewReportOccupancy.DataBind();
                return;
            }
            try
            {
                var dt = new DataTable();
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();
                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = SqlTop3Occupancy;
                        cmd.CommandType = CommandType.Text;
                        using (var da = new System.Data.OracleClient.OracleDataAdapter(cmd))
                            da.Fill(dt);
                    }
                }
                GridViewReportOccupancy.DataSource = dt;
                GridViewReportOccupancy.DataBind();
            }
            catch
            {
                GridViewReportOccupancy.DataSource = null;
                GridViewReportOccupancy.DataBind();
            }
        }

        private void BindStatistics()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            if (string.IsNullOrEmpty(connStr))
            {
                SetErrorState();
                return;
            }

            try
            {
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();

                    lblTotalUsers.Text = GetCount(conn, "SELECT COUNT(*) FROM USERS");
                    lblTotalMovies.Text = GetCount(conn, "SELECT COUNT(*) FROM MOVIE");
                    lblTotalBookings.Text = GetCount(conn, "SELECT COUNT(*) FROM TICKET");
                    lblCurrentlyShowing.Text = GetCount(conn, @"
                        SELECT COUNT(DISTINCT M.MOVIEID)
                        FROM MOVIE M
                        JOIN MOVIE_SHOW MS ON M.MOVIEID = MS.MOVIEID
                        JOIN SHOW S ON MS.SHOWID = S.SHOWID
                        WHERE S.SHOW_DATE >= TRUNC(SYSDATE)");
                    lblTotalTheatres.Text = GetCount(conn, "SELECT COUNT(*) FROM THEATRE");
                }
            }
            catch (Exception)
            {
                SetErrorState();
            }
        }

        private static string GetCount(System.Data.OracleClient.OracleConnection conn, string sql)
        {
            using (var cmd = conn.CreateCommand())
            {
                cmd.CommandText = sql;
                cmd.CommandType = CommandType.Text;
                object val = cmd.ExecuteScalar();
                if (val == null || val == DBNull.Value)
                    return "0";
                return Convert.ToString(val);
            }
        }

        private void SetErrorState()
        {
            lblTotalUsers.Text = "N/A";
            lblTotalMovies.Text = "N/A";
            lblTotalBookings.Text = "N/A";
            lblCurrentlyShowing.Text = "N/A";
            lblTotalTheatres.Text = "N/A";
        }
    }
}
