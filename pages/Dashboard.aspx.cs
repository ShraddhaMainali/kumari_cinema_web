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

        private const string SqlMovies = @"
SELECT MOVIEID, MOVIE_TITLE
FROM MOVIE
ORDER BY MOVIE_TITLE";

        private const string SqlTop3Occupancy = @"
SELECT *
FROM (
    SELECT 
        m.MOVIE_TITLE,
        th.THEATRE_NAME,
        th.THEATRE_CITY_HALL,
        h.HALLID,
        h.HALL_CAPACITY,
        COUNT(t.TICKETID) AS SEATS_BOOKED,
        ROUND((COUNT(t.TICKETID)/h.HALL_CAPACITY)*100, 2) AS OCCUPANCY_PERCENT
    FROM MOVIE m
    JOIN MOVIE_SHOW ms ON m.MOVIEID = ms.MOVIEID
    JOIN SHOW s ON ms.SHOWID = s.SHOWID
    JOIN SHOW_TICKET st ON s.SHOWID = st.SHOWID
    JOIN TICKET t ON st.TICKETID = t.TICKETID
    JOIN HALL h ON ms.HALLID = h.HALLID
    JOIN THEATRE th ON ms.THEATREID = th.THEATREID
    WHERE m.MOVIEID = :MOVIEID
      AND t.BOOKING_STATUS = 'Booked'
    GROUP BY m.MOVIE_TITLE, th.THEATRE_NAME, th.THEATRE_CITY_HALL, h.HALLID, h.HALL_CAPACITY
    ORDER BY OCCUPANCY_PERCENT DESC
)
WHERE ROWNUM <= 3";

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
            if (ddlReportMovie.Items.Count == 0)
                BindReportMovieDropdown();
            BindReportTheaterCityHall();
            GridViewReportOccupancy.DataSource = null;
            GridViewReportOccupancy.DataBind();
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

        public void btnReportSearchOccupancy_Click(object sender, EventArgs e)
        {
            BindReportTop3Occupancy();
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
                        var p = new System.Data.OracleClient.OracleParameter("MOVIEID", System.Data.OracleClient.OracleType.Number);
                        p.Value = GetSelectedReportMovieId();
                        cmd.Parameters.Add(p);
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

        private void BindReportMovieDropdown()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            ddlReportMovie.Items.Clear();

            if (string.IsNullOrEmpty(connStr))
            {
                ddlReportMovie.Items.Add(new ListItem("No movies (missing connection)", "0"));
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
                        cmd.CommandText = SqlMovies;
                        cmd.CommandType = CommandType.Text;
                        using (var da = new System.Data.OracleClient.OracleDataAdapter(cmd))
                            da.Fill(dt);
                    }
                }

                ddlReportMovie.DataSource = dt;
                ddlReportMovie.DataTextField = "MOVIE_TITLE";
                ddlReportMovie.DataValueField = "MOVIEID";
                ddlReportMovie.DataBind();

                if (ddlReportMovie.Items.Count == 0)
                {
                    ddlReportMovie.Items.Add(new ListItem("No movies found", "0"));
                }
                else
                {
                    ddlReportMovie.SelectedIndex = 0;
                }
            }
            catch
            {
                ddlReportMovie.Items.Clear();
                ddlReportMovie.Items.Add(new ListItem("Unable to load movies", "0"));
            }
        }

        private decimal GetSelectedReportMovieId()
        {
            if (ddlReportMovie != null && decimal.TryParse(ddlReportMovie.SelectedValue, out decimal movieId) && movieId > 0)
            {
                return movieId;
            }

            // Fallback to 1 to match the sample query/output when dropdown is empty.
            return 1;
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
