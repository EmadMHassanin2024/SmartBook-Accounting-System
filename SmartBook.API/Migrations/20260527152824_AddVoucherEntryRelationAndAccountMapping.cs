using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SmartBook.API.Migrations
{
    /// <inheritdoc />
    public partial class AddVoucherEntryRelationAndAccountMapping : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_AccountMappings_MovementType",
                table: "AccountMappings");

            migrationBuilder.AddColumn<int>(
                name: "EntryID",
                table: "Vouchers",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Vouchers_EntryID",
                table: "Vouchers",
                column: "EntryID");

            migrationBuilder.CreateIndex(
                name: "IX_AccountMappings_MovementType",
                table: "AccountMappings",
                column: "MovementType",
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Vouchers_JournalEntries_EntryID",
                table: "Vouchers",
                column: "EntryID",
                principalTable: "JournalEntries",
                principalColumn: "EntryID",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Vouchers_JournalEntries_EntryID",
                table: "Vouchers");

            migrationBuilder.DropIndex(
                name: "IX_Vouchers_EntryID",
                table: "Vouchers");

            migrationBuilder.DropIndex(
                name: "IX_AccountMappings_MovementType",
                table: "AccountMappings");

            migrationBuilder.DropColumn(
                name: "EntryID",
                table: "Vouchers");

            migrationBuilder.CreateIndex(
                name: "IX_AccountMappings_MovementType",
                table: "AccountMappings",
                column: "MovementType");
        }
    }
}
