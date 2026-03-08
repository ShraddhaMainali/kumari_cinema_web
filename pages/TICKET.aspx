<%@ Page Title="Ticket Management" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="TICKET.aspx.cs" Inherits="kumari_cinema_web.pages.TICKET" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Ticket Management</h2>

    <h3 class="section-heading">Ticket List</h3>
    <!-- GridView for TICKET table -->
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" DataKeyNames="TICKETID" DataSourceID="SqlDataSource3">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
            <asp:BoundField DataField="TICKETID" HeaderText="TICKETID" ReadOnly="True" SortExpression="TICKETID" />
            <asp:BoundField DataField="TICKET_PRICE" HeaderText="TICKET_PRICE" SortExpression="TICKET_PRICE" />
            <asp:BoundField DataField="TICKET_NUMBER" HeaderText="TICKET_NUMBER" SortExpression="TICKET_NUMBER" />
            <asp:BoundField DataField="TICKET_STATUS" HeaderText="TICKET_STATUS" SortExpression="TICKET_STATUS" />
            <asp:BoundField DataField="FINAL_TICKET_PRICE" HeaderText="FINAL_TICKET_PRICE" SortExpression="FINAL_TICKET_PRICE" />
            <asp:BoundField DataField="PURCHASE_DATETIME" HeaderText="PURCHASE_DATETIME" SortExpression="PURCHASE_DATETIME" />
            <asp:BoundField DataField="BOOKING_STATUS" HeaderText="BOOKING_STATUS" SortExpression="BOOKING_STATUS" />
            <asp:BoundField DataField="BOOKING_DATETIME" HeaderText="BOOKING_DATETIME" SortExpression="BOOKING_DATETIME" />
        </Columns>
        <FooterStyle BackColor="#F7DFB5" ForeColor="#8C4510" />
        <HeaderStyle BackColor="#A55129" Font-Bold="True" ForeColor="White" />
        <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
        <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
        <SelectedRowStyle BackColor="#738A9C" Font-Bold="True" ForeColor="White" />
        <SortedAscendingCellStyle BackColor="#FFF1D4" />
        <SortedAscendingHeaderStyle BackColor="#B95C30" />
        <SortedDescendingCellStyle BackColor="#F1E5CE" />
        <SortedDescendingHeaderStyle BackColor="#93451F" />
    </asp:GridView>

    <!-- SqlDataSource for TICKET table -->
    <asp:SqlDataSource ID="SqlDataSource3" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
        SelectCommand="SELECT * FROM TICKET"
        InsertCommand="INSERT INTO TICKET (TICKETID, TICKET_PRICE, TICKET_NUMBER, TICKET_STATUS, FINAL_TICKET_PRICE, PURCHASE_DATETIME, BOOKING_STATUS, BOOKING_DATETIME) VALUES (:TICKETID, :TICKET_PRICE, :TICKET_NUMBER, :TICKET_STATUS, :FINAL_TICKET_PRICE, :PURCHASE_DATETIME, :BOOKING_STATUS, :BOOKING_DATETIME)"
        UpdateCommand="UPDATE TICKET SET TICKET_PRICE = :TICKET_PRICE, TICKET_NUMBER = :TICKET_NUMBER, TICKET_STATUS = :TICKET_STATUS, FINAL_TICKET_PRICE = :FINAL_TICKET_PRICE, PURCHASE_DATETIME = :PURCHASE_DATETIME, BOOKING_STATUS = :BOOKING_STATUS, BOOKING_DATETIME = :BOOKING_DATETIME WHERE TICKETID = :TICKETID"
        DeleteCommand="DELETE FROM TICKET WHERE TICKETID = :TICKETID">

        <InsertParameters>
            <asp:Parameter Name="TICKETID" Type="Decimal" />
            <asp:Parameter Name="TICKET_PRICE" Type="String" />
            <asp:Parameter Name="TICKET_NUMBER" Type="String" />
            <asp:Parameter Name="TICKET_STATUS" Type="String" />
            <asp:Parameter Name="FINAL_TICKET_PRICE" Type="String" />
            <asp:Parameter Name="PURCHASE_DATETIME" Type="DateTime" />
            <asp:Parameter Name="BOOKING_STATUS" Type="String" />
            <asp:Parameter Name="BOOKING_DATETIME" Type="DateTime" />
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="TICKET_PRICE" Type="String" />
            <asp:Parameter Name="TICKET_NUMBER" Type="String" />
            <asp:Parameter Name="TICKET_STATUS" Type="String" />
            <asp:Parameter Name="FINAL_TICKET_PRICE" Type="String" />
            <asp:Parameter Name="PURCHASE_DATETIME" Type="DateTime" />
            <asp:Parameter Name="BOOKING_STATUS" Type="String" />
            <asp:Parameter Name="BOOKING_DATETIME" Type="DateTime" />
            <asp:Parameter Name="TICKETID" Type="Decimal" />
        </UpdateParameters>

        <DeleteParameters>
            <asp:Parameter Name="TICKETID" Type="Decimal" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <br /><br />

    <h3 class="section-heading">Add or Edit Ticket</h3>
    <!-- FormView for TICKET table -->
    <asp:FormView ID="FormView1" runat="server" DataKeyNames="TICKETID" DataSourceID="SqlDataSource3" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" GridLines="Both">

        <ItemTemplate>
            TICKETID: <asp:Label ID="TICKETIDLabel" runat="server" Text='<%# Eval("TICKETID") %>' /><br />
            TICKET_PRICE: <asp:Label ID="TICKET_PRICELabel" runat="server" Text='<%# Bind("TICKET_PRICE") %>' /><br />
            TICKET_NUMBER: <asp:Label ID="TICKET_NUMBERLabel" runat="server" Text='<%# Bind("TICKET_NUMBER") %>' /><br />
            TICKET_STATUS: <asp:Label ID="TICKET_STATUSLabel" runat="server" Text='<%# Bind("TICKET_STATUS") %>' /><br />
            FINAL_TICKET_PRICE: <asp:Label ID="FINAL_TICKET_PRICELabel" runat="server" Text='<%# Bind("FINAL_TICKET_PRICE") %>' /><br />
            PURCHASE_DATETIME: <asp:Label ID="PURCHASE_DATETIMELabel" runat="server" Text='<%# Bind("PURCHASE_DATETIME") %>' /><br />
            BOOKING_STATUS: <asp:Label ID="BOOKING_STATUSLabel" runat="server" Text='<%# Bind("BOOKING_STATUS") %>' /><br />
            BOOKING_DATETIME: <asp:Label ID="BOOKING_DATETIMELabel" runat="server" Text='<%# Bind("BOOKING_DATETIME") %>' /><br />
            <asp:LinkButton ID="EditButton" runat="server" CommandName="Edit" Text="Edit" />
            &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CommandName="Delete" Text="Delete" />
            &nbsp;<asp:LinkButton ID="NewButton" runat="server" CommandName="New" Text="New" />
        </ItemTemplate>

        <EditItemTemplate>
            TICKETID: <asp:Label ID="TICKETIDLabel1" runat="server" Text='<%# Eval("TICKETID") %>' /><br />
            TICKET_PRICE: <asp:TextBox ID="TICKET_PRICETextBox" runat="server" Text='<%# Bind("TICKET_PRICE") %>' /><br />
            TICKET_NUMBER: <asp:TextBox ID="TICKET_NUMBERTextBox" runat="server" Text='<%# Bind("TICKET_NUMBER") %>' /><br />
            TICKET_STATUS: <asp:TextBox ID="TICKET_STATUSTextBox" runat="server" Text='<%# Bind("TICKET_STATUS") %>' /><br />
            FINAL_TICKET_PRICE: <asp:TextBox ID="FINAL_TICKET_PRICETextBox" runat="server" Text='<%# Bind("FINAL_TICKET_PRICE") %>' /><br />
            PURCHASE_DATETIME: <asp:TextBox ID="PURCHASE_DATETIMETextBox" runat="server" Text='<%# Bind("PURCHASE_DATETIME") %>' /><br />
            BOOKING_STATUS: <asp:TextBox ID="BOOKING_STATUSTextBox" runat="server" Text='<%# Bind("BOOKING_STATUS") %>' /><br />
            BOOKING_DATETIME: <asp:TextBox ID="BOOKING_DATETIMETextBox" runat="server" Text='<%# Bind("BOOKING_DATETIME") %>' /><br />
            <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>

        <InsertItemTemplate>
            TICKETID: <asp:TextBox ID="TICKETIDTextBox" runat="server" Text='<%# Bind("TICKETID") %>' /><br />
            TICKET_PRICE: <asp:TextBox ID="TICKET_PRICETextBox" runat="server" Text='<%# Bind("TICKET_PRICE") %>' /><br />
            TICKET_NUMBER: <asp:TextBox ID="TICKET_NUMBERTextBox" runat="server" Text='<%# Bind("TICKET_NUMBER") %>' /><br />
            TICKET_STATUS: <asp:TextBox ID="TICKET_STATUSTextBox" runat="server" Text='<%# Bind("TICKET_STATUS") %>' /><br />
            FINAL_TICKET_PRICE: <asp:TextBox ID="FINAL_TICKET_PRICETextBox" runat="server" Text='<%# Bind("FINAL_TICKET_PRICE") %>' /><br />
            PURCHASE_DATETIME: <asp:TextBox ID="PURCHASE_DATETIMETextBox" runat="server" Text='<%# Bind("PURCHASE_DATETIME") %>' /><br />
            BOOKING_STATUS: <asp:TextBox ID="BOOKING_STATUSTextBox" runat="server" Text='<%# Bind("BOOKING_STATUS") %>' /><br />
            BOOKING_DATETIME: <asp:TextBox ID="BOOKING_DATETIMETextBox" runat="server" Text='<%# Bind("BOOKING_DATETIME") %>' /><br />
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