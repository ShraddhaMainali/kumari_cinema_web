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

        private const string SqlTop3Occupancy = @"
SELECT *
FROM (
    SELECT
        M.MOVIE_TITLE,
        H.HALLID,
        H.HALL_CAPACITY,
        COUNT(T.TICKETID) AS TICKETS_SOLD,
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
)
WHERE ROWNUM <= 3";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                BindTop3Occupancy();
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
    }
}
