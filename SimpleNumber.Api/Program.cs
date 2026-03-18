var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/random", () =>
{
    var random = new Random();
    var value = random.Next(1, 101); // Return a random number between 1 and 100
    return Results.Ok(new { Number = value });
});

app.MapGet("/random/{max}", (int max) =>
{
    var random = new Random();
    var value = random.Next(1, max + 1); // Return a random number between 1 and max
    return Results.Ok(new { Number = value });
});

app.MapGet("/", () => "Simple Number API is running!");

app.Run();