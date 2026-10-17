var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

// This is your RESTful API Endpoint (Requirement #4)
app.MapGet("/api/posts", () =>
{
    var posts = new[]
    {
        new { Id = 1, User = "Ayesha", Content = "My tomatoes are flowering!" },
        new { Id = 2, User = "Tanvir", Content = "Found a great community garden." },
        new { Id = 3, User = "Nusrat", Content = "My basil leaves are turning yellow." }
    };
    
    return Results.Ok(posts);
});

app.Run();