using System;
using System.Data;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace kumari_cinema_web.pages
{
    public partial class Top3TheaterOccupancy : System.Web.UI.Page
    {
        private const string SqlUserTickets = @"
SELECT u.USERID,
       u.USER_USERNAME,
       u.USER_EMAIL,
       t.TICKETID,
       t.TICKET_NUMBER,
       stm.SEATID,
       t.FINAL_TICKET_PRICE,
       t.PURCHASE_DATETIME,
       m.MOVIE_TITLE,
       s.SHOW_DATE,
       s.SHOW_TIME,
       s.START_DATETIME,
       s.END_DATETIME
FROM USERS u
LEFT JOIN SHOW_TICKET stm ON u.USERID = stm.USERID
LEFT JOIN TICKET t ON stm.TICKETID = t.TICKETID
LEFT JOIN SHOW s ON stm.SHOWID = s.SHOWID
LEFT JOIN MOVIE m ON stm.MOVIEID = m.MOVIEID
WHERE u.USERID = :USERID
ORDER BY t.PURCHASE_DATETIME DESC";

        private const string SqlMovies = @"
SELECT MOVIEID, MOVIE_TITLE
FROM MOVIE
ORDER BY MOVIE_TITLE";

        // MovieTheatherCityHallOccupancyPerformer:
        // For any movie, show top 3 theatre city halls by occupancy percentage.
        // Only paid tickets are counted as occupancy (BOOKING_STATUS = 'Booked').
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

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                EnsureOccupancyGridColumns();
                BindMovieDropdown();
                BindTop3Occupancy();
            }
        }

        protected void ddlMovie_SelectedIndexChanged(object sender, EventArgs e)
        {
            EnsureOccupancyGridColumns();
            BindTop3Occupancy();
        }

        private void EnsureOccupancyGridColumns()
        {
            // Force the expected columns regardless of stale markup/deployed files.
            GridViewOccupancy.AutoGenerateColumns = false;
            GridViewOccupancy.Columns.Clear();

            GridViewOccupancy.Columns.Add(new BoundField { DataField = "MOVIE_TITLE", HeaderText = "MOVIE_TITLE" });
            GridViewOccupancy.Columns.Add(new BoundField { DataField = "THEATRE_NAME", HeaderText = "THEATRE_NAME" });
            GridViewOccupancy.Columns.Add(new BoundField { DataField = "THEATRE_CITY_HALL", HeaderText = "THEATRE_CITY_HALL" });
            GridViewOccupancy.Columns.Add(new BoundField { DataField = "HALLID", HeaderText = "HALLID" });
            GridViewOccupancy.Columns.Add(new BoundField { DataField = "HALL_CAPACITY", HeaderText = "HALL_CAPACITY" });
            GridViewOccupancy.Columns.Add(new BoundField { DataField = "SEATS_BOOKED", HeaderText = "SEATS_BOOKED" });
            GridViewOccupancy.Columns.Add(new BoundField { DataField = "OCCUPANCY_PERCENT", HeaderText = "OCCUPANCY_PERCENT" });
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            HideMessage();
            if (string.IsNullOrWhiteSpace(txtUserId.Text))
            {
                GridView1.DataSource = null;
                GridView1.DataBind();
                ShowMessage("Please enter a User ID.");
                return;
            }

            if (!decimal.TryParse(txtUserId.Text.Trim(), out decimal userId))
            {
                GridView1.DataSource = null;
                GridView1.DataBind();
                ShowMessage("Please enter a valid numeric User ID.");
                return;
            }

            BindUserTickets(userId);
        }

        private void ShowMessage(string text)
        {
            lblMessage.Text = text;
            lblMessage.Visible = true;
        }

        private void HideMessage()
        {
            lblMessage.Visible = false;
            lblMessage.Text = string.Empty;
        }

        private void BindUserTickets(decimal userId)
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            if (string.IsNullOrEmpty(connStr))
            {
                GridView1.DataSource = null;
                GridView1.DataBind();
                ShowMessage("Connection string not configured.");
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
                        {
                            da.Fill(dt);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                dt = new DataTable();
                ShowMessage("Error: " + ex.Message);
            }

            GridView1.DataSource = dt;
            GridView1.DataBind();

            if (dt.Rows.Count == 0 && !lblMessage.Visible)
                ShowMessage("No records found for this User ID.");
        }

        private void BindTop3Occupancy()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            if (string.IsNullOrEmpty(connStr))
            {
                GridViewOccupancy.DataSource = null;
                GridViewOccupancy.DataBind();
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
                        p.Value = GetSelectedMovieId();
                        cmd.Parameters.Add(p);
                        using (var da = new System.Data.OracleClient.OracleDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }
                    }
                }
                GridViewOccupancy.DataSource = dt;
                GridViewOccupancy.DataBind();
            }
            catch
            {
                GridViewOccupancy.DataSource = null;
                GridViewOccupancy.DataBind();
            }
        }

        private void BindMovieDropdown()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            var ddlMovie = GetMovieDropdown();
            if (ddlMovie == null) return;

            ddlMovie.Items.Clear();

            if (string.IsNullOrEmpty(connStr))
            {
                ddlMovie.Items.Add(new ListItem("No movies (missing connection)", "0"));
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
                        {
                            da.Fill(dt);
                        }
                    }
                }

                ddlMovie.DataSource = dt;
                ddlMovie.DataTextField = "MOVIE_TITLE";
                ddlMovie.DataValueField = "MOVIEID";
                ddlMovie.DataBind();

                if (ddlMovie.Items.Count == 0)
                {
                    ddlMovie.Items.Add(new ListItem("No movies found", "0"));
                }
                else
                {
                    ddlMovie.SelectedIndex = 0;
                }
            }
            catch
            {
                ddlMovie.Items.Clear();
                ddlMovie.Items.Add(new ListItem("Unable to load movies", "0"));
            }
        }

        private decimal GetSelectedMovieId()
        {
            var ddlMovie = GetMovieDropdown();
            if (ddlMovie == null) return 1;

            if (decimal.TryParse(ddlMovie.SelectedValue, out decimal movieId) && movieId > 0)
                return movieId;
            return 1;
        }

        private DropDownList GetMovieDropdown()
        {
            return FindControlRecursive(this, "ddlMovie") as DropDownList;
        }

        private static Control FindControlRecursive(Control root, string id)
        {
            if (root == null) return null;
            if (string.Equals(root.ID, id, StringComparison.Ordinal)) return root;

            foreach (Control child in root.Controls)
            {
                var match = FindControlRecursive(child, id);
                if (match != null) return match;
            }

            return null;
        }
    }
}
