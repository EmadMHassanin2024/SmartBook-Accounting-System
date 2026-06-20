using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SmartBook.API.Migrations
{
    /// <inheritdoc />
    public partial class AddEntryIdToInvoice : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "EntryId",
                table: "Invoices",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Invoices_EntryId",
                table: "Invoices",
                column: "EntryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Invoices_JournalEntries_EntryId",
                table: "Invoices",
                column: "EntryId",
                principalTable: "JournalEntries",
                principalColumn: "EntryID",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Invoices_JournalEntries_EntryId",
                table: "Invoices");

            migrationBuilder.DropIndex(
                name: "IX_Invoices_EntryId",
                table: "Invoices");

            migrationBuilder.DropColumn(
                name: "EntryId",
                table: "Invoices");
        }
    }
}
