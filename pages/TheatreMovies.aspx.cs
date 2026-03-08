using System;
using System.Data;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace kumari_cinema_web.pages
{
    public partial class TheatreMovies : System.Web.UI.Page
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

        private const string SqlTheaterCityHall = @"
SELECT 
    t.THEATREID,
    t.THEATRE_CITY_HALL AS TheaterCityHall,
    ms.HALLID,
    m.MOVIEID,
    m.MOVIE_TITLE AS MovieTitle,
    s.SHOWID,
    s.SHOW_TIME AS ShowTime
FROM MOVIE_SHOW ms
JOIN MOVIE m
    ON ms.MOVIEID = m.MOVIEID
JOIN SHOW s
    ON ms.SHOWID = s.SHOWID
JOIN THEATRE t
    ON ms.THEATREID = t.THEATREID
WHERE t.THEATRE_CITY_HALL = :CITYHALL
ORDER BY ms.HALLID, s.SHOW_TIME";

        private const string SqlTheaterCityHallAll = @"
SELECT 
    t.THEATREID,
    t.THEATRE_CITY_HALL AS TheaterCityHall,
    ms.HALLID,
    m.MOVIEID,
    m.MOVIE_TITLE AS MovieTitle,
    s.SHOWID,
    s.SHOW_TIME AS ShowTime
FROM MOVIE_SHOW ms
JOIN MOVIE m
    ON ms.MOVIEID = m.MOVIEID
JOIN SHOW s
    ON ms.SHOWID = s.SHOWID
JOIN THEATRE t
    ON ms.THEATREID = t.THEATREID
ORDER BY t.THEATRE_CITY_HALL, ms.HALLID, s.SHOW_TIME";

        private const string SqlCityHalls = "SELECT DISTINCT THEATRE_CITY_HALL FROM THEATRE ORDER BY THEATRE_CITY_HALL";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCityHallDropdown();
                BindTheaterCityHall();
            }
        }

        public void btnFilterTheater_Click(object sender, EventArgs e)
        {
            lblTheaterMessage.Visible = false;
            BindTheaterCityHall();
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

        private void BindCityHallDropdown()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            ddlTheaterCityHall.Items.Clear();
            ddlTheaterCityHall.Items.Add(new ListItem("All", ""));
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
                                    ddlTheaterCityHall.Items.Add(new ListItem(city, city));
                            }
                        }
                    }
                }
            }
            catch (Exception)
            {
                // Keep "All" only
            }
        }

        private void BindTheaterCityHall()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;
            if (string.IsNullOrEmpty(connStr))
            {
                GridViewTheaterCityHall.DataSource = null;
                GridViewTheaterCityHall.DataBind();
                return;
            }

            string selectedCity = ddlTheaterCityHall.SelectedValue ?? "";
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
                        {
                            da.Fill(dt);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                dt = new DataTable();
                lblTheaterMessage.Text = "Error loading show details: " + ex.Message;
                lblTheaterMessage.Visible = true;
            }

            GridViewTheaterCityHall.DataSource = dt;
            GridViewTheaterCityHall.DataBind();

            if (dt.Rows.Count == 0 && !lblTheaterMessage.Visible)
            {
                lblTheaterMessage.Text = showAll ? "No movie show details found." : "No show details found for the selected city hall.";
                lblTheaterMessage.Visible = true;
            }
        }
    }
}
