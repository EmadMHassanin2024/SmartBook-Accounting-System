using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace SmartBook.API.Migrations
{
    /// <inheritdoc />
    public partial class AddInvoiceAndDetails : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
              name: "JournalDetails",
              columns: table => new
              {
                  DetailID = table.Column<int>(type: "int", nullable: false)
                      .Annotation("SqlServer:Identity", "1, 1"),
                  EntryID = table.Column<int>(type: "int", nullable: true),
                  AccountID = table.Column<int>(type: "int", nullable: true),
                  Debit = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: true, defaultValue: 0.00m),
                  Credit = table.Column<decimal>(type: "decimal(18,2)", precision: 18, scale: 2, nullable: true, defaultValue: 0.00m),
                  Description = table.Column<string>(type: "nvarchar(max)", nullable: true)
              },
              constraints: table =>
              {
                  table.PrimaryKey("PK_JournalDetails", x => x.DetailID);
                  table.ForeignKey(
                      name: "FK_JournalDetails_Accounts_AccountID",
                      column: x => x.AccountID,
                      principalTable: "Accounts",
                      principalColumn: "AccountID");
                  table.ForeignKey(
                      name: "FK_JournalDetails_JournalEntries_EntryID",
                      column: x => x.EntryID,
                      principalTable: "JournalEntries",
                      principalColumn: "EntryID");
              });


        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
          

            migrationBuilder.DropTable(
                name: "JournalDetails");

          
        }
    }
}
