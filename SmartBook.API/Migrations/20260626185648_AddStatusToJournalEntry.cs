using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SmartBook.API.Migrations
{
    /// <inheritdoc />
    public partial class AddStatusToJournalEntry : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "JournalStatus",
                table: "JournalEntries",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "JournalStatus",
                table: "JournalEntries");
        }
    }
}
