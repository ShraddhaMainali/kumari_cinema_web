<%@ Page Title="User Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="UserDetail.aspx.cs" Inherits="kumari_cinema_web.pages.UserDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>User Management</h2>

    <h3 class="section-heading">User List</h3>
    <!-- GridView for USERS table -->
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" DataKeyNames="USERID" DataSourceID="SqlDataSource1">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
            <asp:BoundField DataField="USERID" HeaderText="USERID" ReadOnly="True" SortExpression="USERID" />
            <asp:BoundField DataField="USER_EMAIL" HeaderText="USER_EMAIL" SortExpression="USER_EMAIL" />
            <asp:BoundField DataField="USER_USERNAME" HeaderText="USER_USERNAME" SortExpression="USER_USERNAME" />
            <asp:BoundField DataField="USER_PASSWORD" HeaderText="USER_PASSWORD" SortExpression="USER_PASSWORD" />
            <asp:BoundField DataField="USER_ADDRESS" HeaderText="USER_ADDRESS" SortExpression="USER_ADDRESS" />
            <asp:BoundField DataField="USER_PHONE" HeaderText="USER_PHONE" SortExpression="USER_PHONE" />
            <asp:BoundField DataField="REGISTRATION_DATE" HeaderText="REGISTRATION_DATE" SortExpression="REGISTRATION_DATE" />
        </Columns>
        <FooterStyle BackColor="White" ForeColor="#000066" />
        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
        <RowStyle ForeColor="#000066" />
        <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
        <SortedAscendingCellStyle BackColor="#F1F1F1" />
        <SortedAscendingHeaderStyle BackColor="#007DBB" />
        <SortedDescendingCellStyle BackColor="#CAC9C9" />
        <SortedDescendingHeaderStyle BackColor="#00547E" />
    </asp:GridView>

    <!-- SqlDataSource for USERS table -->
    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
        SelectCommand="SELECT * FROM USERS"
        InsertCommand="INSERT INTO USERS (USERID, USER_EMAIL, USER_USERNAME, USER_PASSWORD, USER_ADDRESS, USER_PHONE, REGISTRATION_DATE) VALUES (:USERID, :USER_EMAIL, :USER_USERNAME, :USER_PASSWORD, :USER_ADDRESS, :USER_PHONE, :REGISTRATION_DATE)"
        UpdateCommand="UPDATE USERS SET USER_EMAIL = :USER_EMAIL, USER_USERNAME = :USER_USERNAME, USER_PASSWORD = :USER_PASSWORD, USER_ADDRESS = :USER_ADDRESS, USER_PHONE = :USER_PHONE, REGISTRATION_DATE = :REGISTRATION_DATE WHERE USERID = :USERID"
        DeleteCommand="DELETE FROM USERS WHERE USERID = :USERID">

        <InsertParameters>
            <asp:Parameter Name="USERID" Type="Decimal" />
            <asp:Parameter Name="USER_EMAIL" Type="String" />
            <asp:Parameter Name="USER_USERNAME" Type="String" />
            <asp:Parameter Name="USER_PASSWORD" Type="String" />
            <asp:Parameter Name="USER_ADDRESS" Type="String" />
            <asp:Parameter Name="USER_PHONE" Type="Decimal" />
            <asp:Parameter Name="REGISTRATION_DATE" Type="DateTime" />
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="USER_EMAIL" Type="String" />
            <asp:Parameter Name="USER_USERNAME" Type="String" />
            <asp:Parameter Name="USER_PASSWORD" Type="String" />
            <asp:Parameter Name="USER_ADDRESS" Type="String" />
            <asp:Parameter Name="USER_PHONE" Type="Decimal" />
            <asp:Parameter Name="REGISTRATION_DATE" Type="DateTime" />
            <asp:Parameter Name="USERID" Type="Decimal" />
        </UpdateParameters>

        <DeleteParameters>
            <asp:Parameter Name="USERID" Type="Decimal" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <br /><br />

    <h3 class="section-heading">Add or Edit User</h3>
    <!-- FormView for USERS table -->
    <asp:FormView ID="FormView1" runat="server" DataKeyNames="USERID" DataSourceID="SqlDataSource1" BackColor="White" BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" GridLines="Both">

        <ItemTemplate>
            USERID: <asp:Label ID="USERIDLabel" runat="server" Text='<%# Eval("USERID") %>' /><br />
            USER_EMAIL: <asp:Label ID="USER_EMAILLabel" runat="server" Text='<%# Bind("USER_EMAIL") %>' /><br />
            USER_USERNAME: <asp:Label ID="USER_USERNAMELabel" runat="server" Text='<%# Bind("USER_USERNAME") %>' /><br />
            USER_PASSWORD: <asp:Label ID="USER_PASSWORDLabel" runat="server" Text='<%# Bind("USER_PASSWORD") %>' /><br />
            USER_ADDRESS: <asp:Label ID="USER_ADDRESSLabel" runat="server" Text='<%# Bind("USER_ADDRESS") %>' /><br />
            USER_PHONE: <asp:Label ID="USER_PHONELabel" runat="server" Text='<%# Bind("USER_PHONE") %>' /><br />
            REGISTRATION_DATE: <asp:Label ID="REGISTRATION_DATELabel" runat="server" Text='<%# Bind("REGISTRATION_DATE") %>' /><br />
            <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
            &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" />
            &nbsp;<asp:LinkButton ID="NewButton" runat="server" CommandName="New" Text="New" />
        </ItemTemplate>

        <EditItemTemplate>
            USERID: <asp:Label ID="USERIDLabel1" runat="server" Text='<%# Eval("USERID") %>' /><br />
            USER_EMAIL: <asp:TextBox ID="USER_EMAILTextBox" runat="server" Text='<%# Bind("USER_EMAIL") %>' /><br />
            USER_USERNAME: <asp:TextBox ID="USER_USERNAMETextBox" runat="server" Text='<%# Bind("USER_USERNAME") %>' /><br />
            USER_PASSWORD: <asp:TextBox ID="USER_PASSWORDTextBox" runat="server" Text='<%# Bind("USER_PASSWORD") %>' /><br />
            USER_ADDRESS: <asp:TextBox ID="USER_ADDRESSTextBox" runat="server" Text='<%# Bind("USER_ADDRESS") %>' /><br />
            USER_PHONE: <asp:TextBox ID="USER_PHONETextBox" runat="server" Text='<%# Bind("USER_PHONE") %>' /><br />
            REGISTRATION_DATE: <asp:TextBox ID="REGISTRATION_DATETextBox" runat="server" Text='<%# Bind("REGISTRATION_DATE") %>' /><br />
            <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>

        <InsertItemTemplate>
            USERID: <asp:TextBox ID="USERIDTextBox" runat="server" Text='<%# Bind("USERID") %>' /><br />
            USER_EMAIL: <asp:TextBox ID="USER_EMAILTextBox" runat="server" Text='<%# Bind("USER_EMAIL") %>' /><br />
            USER_USERNAME: <asp:TextBox ID="USER_USERNAMETextBox" runat="server" Text='<%# Bind("USER_USERNAME") %>' /><br />
            USER_PASSWORD: <asp:TextBox ID="USER_PASSWORDTextBox" runat="server" Text='<%# Bind("USER_PASSWORD") %>' /><br />
            USER_ADDRESS: <asp:TextBox ID="USER_ADDRESSTextBox" runat="server" Text='<%# Bind("USER_ADDRESS") %>' /><br />
            USER_PHONE: <asp:TextBox ID="USER_PHONETextBox" runat="server" Text='<%# Bind("USER_PHONE") %>' /><br />
            REGISTRATION_DATE: <asp:TextBox ID="REGISTRATION_DATETextBox" runat="server" Text='<%# Bind("REGISTRATION_DATE") %>' /><br />
            <asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>

        <EditRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
        <FooterStyle BackColor="White" ForeColor="#000066" />
        <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
        <RowStyle ForeColor="#000066" />
        <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />

    </asp:FormView>

</asp:Content>