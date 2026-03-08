using System;
using System.Data;
using System.Configuration;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace kumari_cinema_web.pages
{
    public partial class UserTickets : System.Web.UI.Page
    {
        private const string Sql = @"
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

        protected void Page_Load(object sender, EventArgs e)
        {
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
                        cmd.CommandText = Sql;
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
    }
}
