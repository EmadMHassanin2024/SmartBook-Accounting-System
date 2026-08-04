using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SmartBook.API.Migrations
{
    /// <inheritdoc />
    public partial class AddUserIdToSystemConfiguration : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "UpdatedAt",
                table: "SystemConfigurations",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<string>(
                name: "UserId",
                table: "SystemConfigurations",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.UpdateData(
                table: "SystemConfigurations",
                keyColumn: "Id",
                keyValue: 1,
                columns: new[] { "UpdatedAt", "UserId" },
                values: new object[] { new DateTime(2026, 7, 27, 3, 7, 25, 870, DateTimeKind.Utc).AddTicks(9197), null });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "UpdatedAt",
                table: "SystemConfigurations");

            migrationBuilder.DropColumn(
                name: "UserId",
                table: "SystemConfigurations");
        }
    }
}
