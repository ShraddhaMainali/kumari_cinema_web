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
</asp:Content>