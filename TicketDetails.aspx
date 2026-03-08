<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TicketDetails.aspx.cs" Inherits="TicketDetails" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Ticket Details</title>
    <style>
        table { border-collapse: collapse; }
        td { padding: 5px; }
        input, select { width: 200px; }
        .btn { margin-right: 5px; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>Ticket Details</h2>
            <table border="0">
                <tr>
                    <td>Ticket ID</td>
                    <td><asp:TextBox ID="txtTicketId" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>User ID</td>
                    <td><asp:TextBox ID="txtUserId" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Show ID</td>
                    <td><asp:TextBox ID="txtShowId" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Seat No</td>
                    <td><asp:TextBox ID="txtSeatNo" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Status</td>
                    <td><asp:TextBox ID="txtStatus" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="btnInsert" runat="server" CssClass="btn" Text="Insert" OnClick="InsertTicket"/>
                        <asp:Button ID="btnUpdate" runat="server" CssClass="btn" Text="Update" OnClick="UpdateTicket"/>
                        <asp:Button ID="btnDelete" runat="server" CssClass="btn" Text="Delete" OnClick="DeleteTicket"/>
                    </td>
                </tr>
            </table>
            <br />
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="true" AllowPaging="true" PageSize="10"
                OnSelectedIndexChanged="GridView1_SelectedIndexChanged">
            </asp:GridView>
        </div>
    </form>
</body>
</html>