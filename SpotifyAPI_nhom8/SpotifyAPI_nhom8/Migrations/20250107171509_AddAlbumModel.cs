using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SpotifyAPI_nhom8.Migrations
{
    /// <inheritdoc />
    public partial class AddAlbumModel : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "AlbumId",
                schema: "identity",
                table: "Songs",
                type: "int",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Albums",
                schema: "identity",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    ArtUrl = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Albums", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Songs_AlbumId",
                schema: "identity",
                table: "Songs",
                column: "AlbumId");

            migrationBuilder.AddForeignKey(
                name: "FK_Songs_Albums_AlbumId",
                schema: "identity",
                table: "Songs",
                column: "AlbumId",
                principalSchema: "identity",
                principalTable: "Albums",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Songs_Albums_AlbumId",
                schema: "identity",
                table: "Songs");

            migrationBuilder.DropTable(
                name: "Albums",
                schema: "identity");

            migrationBuilder.DropIndex(
                name: "IX_Songs_AlbumId",
                schema: "identity",
                table: "Songs");

            migrationBuilder.DropColumn(
                name: "AlbumId",
                schema: "identity",
                table: "Songs");
        }
    }
}
