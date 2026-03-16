using System;
using System.Configuration;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace kumari_cinema_web.pages
{
    public partial class TheatreMovies : Page
    {
        // Unified query that returns either all records or only the records
        // for the selected city hall based on the parameter value.
        private const string SqlTheatreMovies = @"
SELECT DISTINCT 
    t.THEATREID,
    t.THEATRE_CITY_HALL AS TheaterCityHall,
    ms.HALLID,
    m.MOVIEID,
    m.MOVIE_TITLE AS MovieTitle,
    s.SHOWID,
    s.SHOW_TIME AS ShowTime
FROM THEATRE t
JOIN MOVIE_SHOW ms ON t.THEATREID = ms.THEATREID
JOIN MOVIE m ON ms.MOVIEID = m.MOVIEID
JOIN SHOW s ON ms.SHOWID = s.SHOWID
WHERE (:SelectedCityHall = 'All' 
       OR UPPER(TRIM(t.THEATRE_CITY_HALL)) = UPPER(TRIM(:SelectedCityHall)))
ORDER BY t.THEATRE_CITY_HALL, ms.HALLID, s.SHOW_TIME";

        private const string SqlCityHalls = @"
SELECT DISTINCT THEATRE_CITY_HALL 
FROM THEATRE 
ORDER BY THEATRE_CITY_HALL";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCityHallDropdown();
                BindTheatreMovies();
            }
        }

        protected void ddlTheaterCityHall_SelectedIndexChanged(object sender, EventArgs e)
        {
            lblTheaterMessage.Visible = false;
            BindTheatreMovies();
        }

        private void BindCityHallDropdown()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;

            ddlTheaterCityHall.Items.Clear();
            ddlTheaterCityHall.Items.Add(new ListItem("All", "All"));
            ddlTheaterCityHall.SelectedIndex = 0;

            if (string.IsNullOrEmpty(connStr))
            {
                return;
            }

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
                                if (!rdr.IsDBNull(0))
                                {
                                    var city = rdr.GetString(0);
                                    if (!string.IsNullOrWhiteSpace(city))
                                    {
                                        ddlTheaterCityHall.Items.Add(new ListItem(city, city));
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch
            {
                // If loading city halls fails, the dropdown will still contain the "All" option.
            }
        }

        private void BindTheatreMovies()
        {
            string connStr = ConfigurationManager.ConnectionStrings["ConnectionString"]?.ConnectionString;

            if (string.IsNullOrEmpty(connStr))
            {
                GridViewTheaterCityHall.DataSource = null;
                GridViewTheaterCityHall.DataBind();
                lblTheaterMessage.Text = "Connection string not configured.";
                lblTheaterMessage.Visible = true;
                return;
            }

            string selectedCityHall = ddlTheaterCityHall.SelectedValue;
            if (string.IsNullOrWhiteSpace(selectedCityHall))
            {
                selectedCityHall = "All";
            }

            DataTable dt = new DataTable();

            try
            {
                using (var conn = new System.Data.OracleClient.OracleConnection(connStr))
                {
                    conn.Open();

                    using (var cmd = conn.CreateCommand())
                    {
                        cmd.CommandText = SqlTheatreMovies;
                        cmd.CommandType = CommandType.Text;

                        var p = new System.Data.OracleClient.OracleParameter("SelectedCityHall", System.Data.OracleClient.OracleType.VarChar)
                        {
                            Value = selectedCityHall
                        };
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
                lblTheaterMessage.Text = "Error loading movie and show details: " + ex.Message;
                lblTheaterMessage.Visible = true;
            }

            GridViewTheaterCityHall.DataSource = dt;
            GridViewTheaterCityHall.DataBind();

            if (dt.Rows.Count == 0 && !lblTheaterMessage.Visible)
            {
                lblTheaterMessage.Text = selectedCityHall == "All"
                    ? "No movie show details found."
                    : "No show details found for the selected city hall.";
                lblTheaterMessage.Visible = true;
            }
        }
    }
}
