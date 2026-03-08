<%@ Page Title="SHOWTIME" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="SHOWTIME.aspx.cs" Inherits="kumari_cinema_web.pages.SHOWTIME" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Showtime Management</h2>

    <h3 class="section-heading">Show Schedule</h3>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" DataKeyNames="SHOWID" DataSourceID="SqlDataSource4">
        <Columns>
            <asp:CommandField ShowDeleteButton="True" ShowEditButton="True" />
            <asp:BoundField DataField="SHOWID" HeaderText="SHOWID" ReadOnly="True" SortExpression="SHOWID" />
            <asp:BoundField DataField="SHOW_DATE" HeaderText="SHOW_DATE" SortExpression="SHOW_DATE" />
            <asp:BoundField DataField="START_DATETIME" HeaderText="START_DATETIME" SortExpression="START_DATETIME" />
            <asp:BoundField DataField="END_DATETIME" HeaderText="END_DATETIME" SortExpression="END_DATETIME" />
            <asp:BoundField DataField="SHOW_TIME" HeaderText="SHOW_TIME" SortExpression="SHOW_TIME" />
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

    <asp:SqlDataSource ID="SqlDataSource4" runat="server" ConnectionString="<%$ ConnectionStrings:ConnectionString %>" 
        DeleteCommand="DELETE FROM &quot;SHOW&quot; WHERE &quot;SHOWID&quot; = :SHOWID" 
        InsertCommand="INSERT INTO &quot;SHOW&quot; (&quot;SHOWID&quot;, &quot;SHOW_DATE&quot;, &quot;START_DATETIME&quot;, &quot;END_DATETIME&quot;, &quot;SHOW_TIME&quot;) VALUES (:SHOWID, :SHOW_DATE, :START_DATETIME, :END_DATETIME, :SHOW_TIME)" 
        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>" 
        SelectCommand="SELECT * FROM &quot;SHOW&quot;" 
        UpdateCommand="UPDATE &quot;SHOW&quot; SET &quot;SHOW_DATE&quot; = :SHOW_DATE, &quot;START_DATETIME&quot; = :START_DATETIME, &quot;END_DATETIME&quot; = :END_DATETIME, &quot;SHOW_TIME&quot; = :SHOW_TIME WHERE &quot;SHOWID&quot; = :SHOWID">
        <DeleteParameters>
            <asp:Parameter Name="SHOWID" Type="Decimal" />
        </DeleteParameters>
        <InsertParameters>
            <asp:Parameter Name="SHOWID" Type="Decimal" />
            <asp:Parameter Name="SHOW_DATE" Type="DateTime" />
            <asp:Parameter Name="START_DATETIME" Type="DateTime" />
            <asp:Parameter Name="END_DATETIME" Type="DateTime" />
            <asp:Parameter Name="SHOW_TIME" Type="String" />
        </InsertParameters>
        <UpdateParameters>
            <asp:Parameter Name="SHOW_DATE" Type="DateTime" />
            <asp:Parameter Name="START_DATETIME" Type="DateTime" />
            <asp:Parameter Name="END_DATETIME" Type="DateTime" />
            <asp:Parameter Name="SHOW_TIME" Type="String" />
            <asp:Parameter Name="SHOWID" Type="Decimal" />
        </UpdateParameters>
    </asp:SqlDataSource>

    <br />

    <h3 class="section-heading">Add or Edit Showtime</h3>
    <asp:FormView ID="FormView1" runat="server" BackColor="#DEBA84" BorderColor="#DEBA84" BorderStyle="None" BorderWidth="1px" CellPadding="3" CellSpacing="2" DataKeyNames="SHOWID" DataSourceID="SqlDataSource4" GridLines="Both">
        <EditItemTemplate>
            SHOWID:
            <asp:Label ID="SHOWIDLabel1" runat="server" Text='<%# Eval("SHOWID") %>' />
            <br />
            SHOW_DATE:
            <asp:TextBox ID="SHOW_DATETextBox" runat="server" Text='<%# Bind("SHOW_DATE") %>' />
            <br />
            START_DATETIME:
            <asp:TextBox ID="START_DATETIMETextBox" runat="server" Text='<%# Bind("START_DATETIME") %>' />
            <br />
            END_DATETIME:
            <asp:TextBox ID="END_DATETIMETextBox" runat="server" Text='<%# Bind("END_DATETIME") %>' />
            <br />
            SHOW_TIME:
            <asp:TextBox ID="SHOW_TIMETextBox" runat="server" Text='<%# Bind("SHOW_TIME") %>' />
            <br />
            <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>

        <InsertItemTemplate>
            SHOWID:
            <asp:TextBox ID="SHOWIDTextBox" runat="server" Text='<%# Bind("SHOWID") %>' />
            <br />
            SHOW_DATE:
            <asp:TextBox ID="SHOW_DATETextBox" runat="server" Text='<%# Bind("SHOW_DATE") %>' />
            <br />
            START_DATETIME:
            <asp:TextBox ID="START_DATETIMETextBox" runat="server" Text='<%# Bind("START_DATETIME") %>' />
            <br />
            END_DATETIME:
            <asp:TextBox ID="END_DATETIMETextBox" runat="server" Text='<%# Bind("END_DATETIME") %>' />
            <br />
            SHOW_TIME:
            <asp:TextBox ID="SHOW_TIMETextBox" runat="server" Text='<%# Bind("SHOW_TIME") %>' />
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>

        <ItemTemplate>
            SHOWID:
            <asp:Label ID="SHOWIDLabel" runat="server" Text='<%# Eval("SHOWID") %>' />
            <br />
            SHOW_DATE:
            <asp:Label ID="SHOW_DATELabel" runat="server" Text='<%# Bind("SHOW_DATE") %>' />
            <br />
            START_DATETIME:
            <asp:Label ID="START_DATETIMELabel" runat="server" Text='<%# Bind("START_DATETIME") %>' />
            <br />
            END_DATETIME:
            <asp:Label ID="END_DATETIMELabel" runat="server" Text='<%# Bind("END_DATETIME") %>' />
            <br />
            SHOW_TIME:
            <asp:Label ID="SHOW_TIMELabel" runat="server" Text='<%# Bind("SHOW_TIME") %>' />
            <br />
            <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" CommandName="Edit" Text="Edit" />
            &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" CommandName="Delete" Text="Delete" />
            &nbsp;<asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" CommandName="New" Text="New" />
        </ItemTemplate>

        <PagerStyle ForeColor="#8C4510" HorizontalAlign="Center" />
        <RowStyle BackColor="#FFF7E7" ForeColor="#8C4510" />
    </asp:FormView>
</asp:Content>