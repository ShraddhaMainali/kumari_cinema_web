<%@ Page Title="Theatre Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="Theatre.aspx.cs" Inherits="kumari_cinema_web.pages.Theatre" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Theatre Management</h2>

    <h3 class="section-heading">Theatre List</h3>
    <!-- GridView for THEATRE table -->
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="THEATREID" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
            <asp:BoundField DataField="THEATREID" HeaderText="THEATREID" ReadOnly="True" SortExpression="THEATREID" />
            <asp:BoundField DataField="THEATRE_NAME" HeaderText="THEATRE_NAME" SortExpression="THEATRE_NAME" />
            <asp:BoundField DataField="THEATRE_CITY_HALL" HeaderText="THEATRE_CITY_HALL" SortExpression="THEATRE_CITY_HALL" />
            <asp:BoundField DataField="THEATRE_PHONE" HeaderText="THEATRE_PHONE" SortExpression="THEATRE_PHONE" />
        </Columns>
        <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
        <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
        <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
        <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
    </asp:GridView>

    <!-- SqlDataSource for THEATRE table -->
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
        SelectCommand="SELECT * FROM THEATRE"
        InsertCommand="INSERT INTO THEATRE (THEATREID, THEATRE_NAME, THEATRE_CITY_HALL, THEATRE_PHONE) VALUES (:THEATREID, :THEATRE_NAME, :THEATRE_CITY_HALL, :THEATRE_PHONE)"
        UpdateCommand="UPDATE THEATRE SET THEATRE_NAME = :THEATRE_NAME, THEATRE_CITY_HALL = :THEATRE_CITY_HALL, THEATRE_PHONE = :THEATRE_PHONE WHERE THEATREID = :THEATREID"
        DeleteCommand="DELETE FROM THEATRE WHERE THEATREID = :THEATREID">

        <InsertParameters>
            <asp:Parameter Name="THEATREID" Type="Decimal" />
            <asp:Parameter Name="THEATRE_NAME" Type="String" />
            <asp:Parameter Name="THEATRE_CITY_HALL" Type="String" />
            <asp:Parameter Name="THEATRE_PHONE" Type="Decimal" />
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="THEATRE_NAME" Type="String" />
            <asp:Parameter Name="THEATRE_CITY_HALL" Type="String" />
            <asp:Parameter Name="THEATRE_PHONE" Type="Decimal" />
            <asp:Parameter Name="THEATREID" Type="Decimal" />
        </UpdateParameters>

        <DeleteParameters>
            <asp:Parameter Name="THEATREID" Type="Decimal" />
        </DeleteParameters>

    </asp:SqlDataSource>

    <br />

    <h3 class="section-heading">Add or Edit Theatre</h3>
    <!-- FormView for THEATRE table -->
    <asp:FormView ID="FormView1" runat="server" DataKeyNames="THEATREID" DataSourceID="SqlDataSource1" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" GridLines="Both">

        <ItemTemplate>
            THEATREID:
            <asp:Label ID="THEATREIDLabel" runat="server" Text='<%# Eval("THEATREID") %>' />
            <br />
            THEATRE_NAME:
            <asp:Label ID="THEATRE_NAMELabel" runat="server" Text='<%# Bind("THEATRE_NAME") %>' />
            <br />
            THEATRE_CITY_HALL:
            <asp:Label ID="THEATRE_CITY_HALLLabel" runat="server" Text='<%# Bind("THEATRE_CITY_HALL") %>' />
            <br />
            THEATRE_PHONE:
            <asp:Label ID="THEATRE_PHONELabel" runat="server" Text='<%# Bind("THEATRE_PHONE") %>' />
            <br />
            <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
            &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" />
            &nbsp;<asp:LinkButton ID="NewButton" runat="server" CommandName="New" Text="New" />
        </ItemTemplate>

        <EditItemTemplate>
            THEATREID:
            <asp:Label ID="THEATREIDLabel1" runat="server" Text='<%# Eval("THEATREID") %>' />
            <br />
            THEATRE_NAME:
            <asp:TextBox ID="THEATRE_NAMETextBox" runat="server" Text='<%# Bind("THEATRE_NAME") %>' />
            <br />
            THEATRE_CITY_HALL:
            <asp:TextBox ID="THEATRE_CITY_HALLTextBox" runat="server" Text='<%# Bind("THEATRE_CITY_HALL") %>' />
            <br />
            THEATRE_PHONE:
            <asp:TextBox ID="THEATRE_PHONETextBox" runat="server" Text='<%# Bind("THEATRE_PHONE") %>' />
            <br />
            <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>

        <InsertItemTemplate>
            THEATREID:
            <asp:TextBox ID="THEATREIDTextBox" runat="server" Text='<%# Bind("THEATREID") %>' />
            <br />
            THEATRE_NAME:
            <asp:TextBox ID="THEATRE_NAMETextBox" runat="server" Text='<%# Bind("THEATRE_NAME") %>' />
            <br />
            THEATRE_CITY_HALL:
            <asp:TextBox ID="THEATRE_CITY_HALLTextBox" runat="server" Text='<%# Bind("THEATRE_CITY_HALL") %>' />
            <br />
            THEATRE_PHONE:
            <asp:TextBox ID="THEATRE_PHONETextBox" runat="server" Text='<%# Bind("THEATRE_PHONE") %>' />
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>

        <EditRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
        <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
        <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
        <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
        <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />

    </asp:FormView>

    <br />

    <h3 class="section-heading">Hall List</h3>
    <!-- GridView and FormView for HALL table -->
    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" DataKeyNames="HALLID" DataSourceID="SqlDataSource2">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
            <asp:BoundField DataField="HALLID" HeaderText="HALLID" ReadOnly="True" SortExpression="HALLID" />
            <asp:BoundField DataField="HALL_CAPACITY" HeaderText="HALL_CAPACITY" SortExpression="HALL_CAPACITY" />
            <asp:BoundField DataField="HALL_TYPE" HeaderText="HALL_TYPE" SortExpression="HALL_TYPE" />
        </Columns>
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource2" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
        SelectCommand="SELECT * FROM HALL"
        InsertCommand="INSERT INTO HALL (HALLID, HALL_CAPACITY, HALL_TYPE) VALUES (:HALLID, :HALL_CAPACITY, :HALL_TYPE)"
        UpdateCommand="UPDATE HALL SET HALL_CAPACITY = :HALL_CAPACITY, HALL_TYPE = :HALL_TYPE WHERE HALLID = :HALLID"
        DeleteCommand="DELETE FROM HALL WHERE HALLID = :HALLID">
        <InsertParameters>
            <asp:Parameter Name="HALLID" Type="Decimal" />
            <asp:Parameter Name="HALL_CAPACITY" Type="Decimal" />
            <asp:Parameter Name="HALL_TYPE" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="HALL_CAPACITY" Type="Decimal" />
            <asp:Parameter Name="HALL_TYPE" Type="String" />
            <asp:Parameter Name="HALLID" Type="Decimal" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:Parameter Name="HALLID" Type="Decimal" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <h3 class="section-heading">Add or Edit Hall</h3>
    <asp:FormView ID="FormView2" runat="server" DataKeyNames="HALLID" DataSourceID="SqlDataSource2" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" GridLines="Both">
        <ItemTemplate>
            HALLID:
            <asp:Label ID="HALLIDLabel" runat="server" Text='<%# Eval("HALLID") %>' />
            <br />
            HALL_CAPACITY:
            <asp:Label ID="HALL_CAPACITYLabel" runat="server" Text='<%# Bind("HALL_CAPACITY") %>' />
            <br />
            HALL_TYPE:
            <asp:Label ID="HALL_TYPELabel" runat="server" Text='<%# Bind("HALL_TYPE") %>' />
            <br />
            <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
            &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" />
            &nbsp;<asp:LinkButton ID="NewButton" runat="server" CommandName="New" Text="New" />
        </ItemTemplate>

        <EditItemTemplate>
            HALLID:
            <asp:Label ID="HALLIDLabel1" runat="server" Text='<%# Eval("HALLID") %>' />
            <br />
            HALL_CAPACITY:
            <asp:TextBox ID="HALL_CAPACITYTextBox" runat="server" Text='<%# Bind("HALL_CAPACITY") %>' />
            <br />
            HALL_TYPE:
            <asp:TextBox ID="HALL_TYPETextBox" runat="server" Text='<%# Bind("HALL_TYPE") %>' />
            <br />
            <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>

        <InsertItemTemplate>
            HALLID:
            <asp:TextBox ID="HALLIDTextBox" runat="server" Text='<%# Bind("HALLID") %>' />
            <br />
            HALL_CAPACITY:
            <asp:TextBox ID="HALL_CAPACITYTextBox" runat="server" Text='<%# Bind("HALL_CAPACITY") %>' />
            <br />
            HALL_TYPE:
            <asp:TextBox ID="HALL_TYPETextBox" runat="server" Text='<%# Bind("HALL_TYPE") %>' />
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>

        <EditRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
        <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
        <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
        <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
        <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
    </asp:FormView>

</asp:Content>