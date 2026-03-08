using System;
using System.Data;
using System.Web.UI;

namespace kumari_cinema_web.pages
{
    public partial class Theatre : System.Web.UI.Page
    {
        private const string ViewStateKeyTheatreTable = "TheatreTable";
        private const string ViewStateKeyNewTheatreRow = "NewTheatreRow";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadTheatreTable();
            GridView1.RowUpdating += GridView1_RowUpdating;
            GridView1.RowDeleting += GridView1_RowDeleting;
            FormView1.ItemInserting += FormView1_ItemInserting;
            FormView1.ItemInserted += FormView1_ItemInserted;
            BindGridView1();
        }

        private void LoadTheatreTable()
        {
            var view = (DataView)SqlDataSource1.Select(DataSourceSelectArguments.Empty);
            DataTable dt = view.ToTable();
            if (dt.Columns.Contains("THEATREID"))
                dt.PrimaryKey = new[] { dt.Columns["THEATREID"] };
            ViewState[ViewStateKeyTheatreTable] = dt;
        }

        private DataTable GetTheatreTable()
        {
            var dt = ViewState[ViewStateKeyTheatreTable] as DataTable;
            if (dt == null)
            {
                LoadTheatreTable();
                dt = ViewState[ViewStateKeyTheatreTable] as DataTable;
            }
            return dt;
        }

        private void BindGridView1()
        {
            DataTable dt = GetTheatreTable();
            if (dt != null)
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }

        protected void FormView1_ItemInserting(object sender, System.Web.UI.WebControls.FormViewInsertEventArgs e)
        {
            var row = new object[4];
            row[0] = GetFormViewInsertValue("THEATREIDTextBox", typeof(decimal));
            row[1] = GetFormViewInsertValue("THEATRE_NAMETextBox", typeof(string));
            row[2] = GetFormViewInsertValue("THEATRE_CITY_HALLTextBox", typeof(string));
            row[3] = GetFormViewInsertValue("THEATRE_PHONETextBox", typeof(decimal));
            ViewState[ViewStateKeyNewTheatreRow] = row;
        }

        private object GetFormViewInsertValue(string controlId, Type type)
        {
            var ctrl = FormView1.FindControl(controlId) as System.Web.UI.WebControls.TextBox;
            string text = ctrl?.Text ?? "";
            if (type == typeof(decimal))
            {
                decimal.TryParse(text, out decimal d);
                return d;
            }
            return text;
        }

        protected void FormView1_ItemInserted(object sender, System.Web.UI.WebControls.FormViewInsertedEventArgs e)
        {
            if (e.Exception == null && ViewState[ViewStateKeyNewTheatreRow] is object[] row)
            {
                DataTable dt = GetTheatreTable();
                if (dt != null)
                {
                    dt.Rows.Add(row);
                    ViewState[ViewStateKeyTheatreTable] = dt;
                    BindGridView1();
                }
                ViewState.Remove(ViewStateKeyNewTheatreRow);
            }
        }

        protected void GridView1_RowUpdating(object sender, System.Web.UI.WebControls.GridViewUpdateEventArgs e)
        {
            SqlDataSource1.UpdateParameters["THEATREID"].DefaultValue = e.Keys["THEATREID"]?.ToString();
            SqlDataSource1.UpdateParameters["THEATRE_NAME"].DefaultValue = e.NewValues["THEATRE_NAME"]?.ToString();
            SqlDataSource1.UpdateParameters["THEATRE_CITY_HALL"].DefaultValue = e.NewValues["THEATRE_CITY_HALL"]?.ToString();
            SqlDataSource1.UpdateParameters["THEATRE_PHONE"].DefaultValue = e.NewValues["THEATRE_PHONE"]?.ToString();
            try
            {
                SqlDataSource1.Update();
                DataTable dt = GetTheatreTable();
                if (dt != null)
                {
                    DataRow dr = dt.Rows.Find(e.Keys["THEATREID"]);
                    if (dr != null)
                    {
                        dr["THEATRE_NAME"] = e.NewValues["THEATRE_NAME"];
                        dr["THEATRE_CITY_HALL"] = e.NewValues["THEATRE_CITY_HALL"];
                        dr["THEATRE_PHONE"] = e.NewValues["THEATRE_PHONE"];
                    }
                    ViewState[ViewStateKeyTheatreTable] = dt;
                }
                GridView1.EditIndex = -1;
                BindGridView1();
            }
            finally
            {
                e.Cancel = true;
            }
        }

        protected void GridView1_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            object key = e.Keys["THEATREID"];
            SqlDataSource1.DeleteParameters["THEATREID"].DefaultValue = key?.ToString();
            try
            {
                SqlDataSource1.Delete();
                DataTable dt = GetTheatreTable();
                if (dt != null)
                {
                    DataRow dr = dt.Rows.Find(key);
                    if (dr != null)
                    {
                        dt.Rows.Remove(dr);
                    }
                    ViewState[ViewStateKeyTheatreTable] = dt;
                }
                BindGridView1();
            }
            finally
            {
                e.Cancel = true;
            }
        }
    }
}
