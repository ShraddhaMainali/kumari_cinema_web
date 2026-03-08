<%@ Page Title="MOVIE" Language="C#" MasterPageFile="~/Site1.Master" AutoEventWireup="true" CodeBehind="MOVIE.aspx.cs" Inherits="kumari_cinema_web.pages.MOVIE" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Movie Management</h2>

    <h3 class="section-heading">Movie List</h3>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="MOVIEID" DataSourceID="SqlDataSource1" Width="100%">
        <Columns>
            <asp:BoundField DataField="MOVIEID" HeaderText="MOVIEID" ReadOnly="True" />
            <asp:BoundField DataField="MOVIE_TITLE" HeaderText="MOVIE_TITLE" />
            <asp:BoundField DataField="MOVIE_DURATION" HeaderText="MOVIE_DURATION" />
            <asp:BoundField DataField="MOVIE_LANGUAGE" HeaderText="MOVIE_LANGUAGE" />
            <asp:BoundField DataField="MOVIE_GENRE" HeaderText="MOVIE_GENRE" />
            <asp:BoundField DataField="MOVIE_RELEASE_DATE" HeaderText="MOVIE_RELEASE_DATE" DataFormatString="{0:yyyy-MM-dd}" />
            <asp:CommandField ShowEditButton="True" ShowDeleteButton="True" />
        </Columns>
    </asp:GridView>

    <asp:SqlDataSource ID="SqlDataSource1" runat="server"
        ConnectionString="<%$ ConnectionStrings:ConnectionString %>"
        ProviderName="<%$ ConnectionStrings:ConnectionString.ProviderName %>"
        SelectCommand="SELECT * FROM MOVIE"
        InsertCommand="INSERT INTO MOVIE (MOVIEID, MOVIE_TITLE, MOVIE_DURATION, MOVIE_LANGUAGE, MOVIE_GENRE, MOVIE_RELEASE_DATE) VALUES (:MOVIEID, :MOVIE_TITLE, :MOVIE_DURATION, :MOVIE_LANGUAGE, :MOVIE_GENRE, :MOVIE_RELEASE_DATE)"
        UpdateCommand="UPDATE MOVIE SET MOVIE_TITLE=:MOVIE_TITLE, MOVIE_DURATION=:MOVIE_DURATION, MOVIE_LANGUAGE=:MOVIE_LANGUAGE, MOVIE_GENRE=:MOVIE_GENRE, MOVIE_RELEASE_DATE=:MOVIE_RELEASE_DATE WHERE MOVIEID=:MOVIEID"
        DeleteCommand="DELETE FROM MOVIE WHERE MOVIEID=:MOVIEID">

        <SelectParameters></SelectParameters>

        <InsertParameters>
            <asp:Parameter Name="MOVIEID" Type="Decimal" />
            <asp:Parameter Name="MOVIE_TITLE" Type="String" />
            <asp:Parameter Name="MOVIE_DURATION" Type="String" />
            <asp:Parameter Name="MOVIE_LANGUAGE" Type="String" />
            <asp:Parameter Name="MOVIE_GENRE" Type="String" />
            <asp:Parameter Name="MOVIE_RELEASE_DATE" Type="DateTime" />
        </InsertParameters>

        <UpdateParameters>
            <asp:Parameter Name="MOVIE_TITLE" Type="String" />
            <asp:Parameter Name="MOVIE_DURATION" Type="String" />
            <asp:Parameter Name="MOVIE_LANGUAGE" Type="String" />
            <asp:Parameter Name="MOVIE_GENRE" Type="String" />
            <asp:Parameter Name="MOVIE_RELEASE_DATE" Type="DateTime" />
            <asp:Parameter Name="MOVIEID" Type="Decimal" />
        </UpdateParameters>

        <DeleteParameters>
            <asp:Parameter Name="MOVIEID" Type="Decimal" />
        </DeleteParameters>
    </asp:SqlDataSource>

    <h3 class="section-heading">Add new movie</h3>
    <asp:FormView ID="FormView1" runat="server" DataKeyNames="MOVIEID" DataSourceID="SqlDataSource1" DefaultMode="Insert" CssClass="form-view-style">
        <InsertItemTemplate>
            MOVIEID:
            <asp:TextBox ID="MOVIEIDTextBox" runat="server" Text='<%# Bind("MOVIEID") %>' /><br />
            MOVIE_TITLE:
            <asp:TextBox ID="MOVIE_TITLETextBox" runat="server" Text='<%# Bind("MOVIE_TITLE") %>' /><br />
            MOVIE_DURATION:
            <asp:TextBox ID="MOVIE_DURATIONTextBox" runat="server" Text='<%# Bind("MOVIE_DURATION") %>' /><br />
            MOVIE_LANGUAGE:
            <asp:TextBox ID="MOVIE_LANGUAGETextBox" runat="server" Text='<%# Bind("MOVIE_LANGUAGE") %>' /><br />
            MOVIE_GENRE:
            <asp:TextBox ID="MOVIE_GENRETextBox" runat="server" Text='<%# Bind("MOVIE_GENRE") %>' /><br />
            MOVIE_RELEASE_DATE:
            <asp:TextBox ID="MOVIE_RELEASE_DATETextBox" runat="server" Text='<%# Bind("MOVIE_RELEASE_DATE") %>' /><br />
            <asp:LinkButton ID="InsertButton" runat="server" CommandName="Insert" Text="Insert" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
        </InsertItemTemplate>
        <ItemTemplate>
            MOVIEID: <asp:Label ID="MOVIEIDLabel" runat="server" Text='<%# Eval("MOVIEID") %>' /><br />
            MOVIE_TITLE: <asp:Label ID="MOVIE_TITLELabel" runat="server" Text='<%# Bind("MOVIE_TITLE") %>' /><br />
            MOVIE_DURATION: <asp:Label ID="MOVIE_DURATIONLabel" runat="server" Text='<%# Bind("MOVIE_DURATION") %>' /><br />
            MOVIE_LANGUAGE: <asp:Label ID="MOVIE_LANGUAGELabel" runat="server" Text='<%# Bind("MOVIE_LANGUAGE") %>' /><br />
            MOVIE_GENRE: <asp:Label ID="MOVIE_GENRELabel" runat="server" Text='<%# Bind("MOVIE_GENRE") %>' /><br />
            MOVIE_RELEASE_DATE: <asp:Label ID="MOVIE_RELEASE_DATELabel" runat="server" Text='<%# Bind("MOVIE_RELEASE_DATE") %>' /><br />
            <asp:LinkButton ID="NewButton" runat="server" CommandName="New" Text="New" />
        </ItemTemplate>
        <EditItemTemplate>
            MOVIEID: <asp:Label ID="MOVIEIDLabel1" runat="server" Text='<%# Eval("MOVIEID") %>' /><br />
            MOVIE_TITLE: <asp:TextBox ID="MOVIE_TITLETextBox" runat="server" Text='<%# Bind("MOVIE_TITLE") %>' /><br />
            MOVIE_DURATION: <asp:TextBox ID="MOVIE_DURATIONTextBox" runat="server" Text='<%# Bind("MOVIE_DURATION") %>' /><br />
            MOVIE_LANGUAGE: <asp:TextBox ID="MOVIE_LANGUAGETextBox" runat="server" Text='<%# Bind("MOVIE_LANGUAGE") %>' /><br />
            MOVIE_GENRE: <asp:TextBox ID="MOVIE_GENRETextBox" runat="server" Text='<%# Bind("MOVIE_GENRE") %>' /><br />
            MOVIE_RELEASE_DATE: <asp:TextBox ID="MOVIE_RELEASE_DATETextBox" runat="server" Text='<%# Bind("MOVIE_RELEASE_DATE") %>' /><br />
            <asp:LinkButton ID="UpdateButton" runat="server" CommandName="Update" Text="Update" />
            &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" CommandName="Cancel" Text="Cancel" />
        </EditItemTemplate>
    </asp:FormView>
</asp:Content>