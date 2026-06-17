---
published: true
title: Basic Auth for .NET Core
subtitle: Utilising Basic Auth with .NET Core Identity
---

.NET Core Identity using Local Users can be used natively on application endpoints, this however makes use of a few additional layers of abstracting which can make using it with a WebAPI kind of troublesome

In order to add your own custom authentication which makes use of Basic Auth and the UserManager Dependency provided by Identity, you can do the following

In your API Class, define the following private property

```cs
public class ApiController : ControllerBase
{
  private readonly UserManager<IdentityUser> _userManager;
```

Next, in your Controller's `constructor` you need to add the `UserManager` dependency

```cs
public ApiController(UserManager<IdentityUser> userManager)
{
    _userManager = userManager;
}
```

In your application class, you can then provide a function which will verify the user login based on the `HttpContext` of the request,
however this can also be implemented as a free-standing function which takes the `username`, `password`, and `Usermanager` as inputs and works purely by making use of those. But for this context this function is defined inside of the controller class. This will return a `bool` which indicates if the user making the request has been authenticated

```cs
private async Task<bool> isUserAuthenticted()
{
    var passwordHasher = new PasswordHasher<IdentityUser>();

    string authHeader = HttpContext.Request.Headers["Authorization"];

    if (authHeader != null && authHeader.StartsWith("Basic"))
    {
        string encodedUsernamePassword = authHeader.Substring("Basic ".Length).Trim();
        Encoding encoding = Encoding.GetEncoding("iso-8859-1");
        string usernamePassword = encoding.GetString(Convert.FromBase64String(encodedUsernamePassword));

        int seperatorIndex = usernamePassword.IndexOf(':');

        var username = usernamePassword.Substring(0, seperatorIndex);
        var password = usernamePassword.Substring(seperatorIndex + 1);

        var user = await _userManager.FindByNameAsync(username);

        var verificationResult = await _userManager.CheckPasswordAsync(user, password);

        return verificationResult;
    }
    else
    {
        return false;
    }
}
```

The above can then be implemented by a controller with something like:

```cs
public async Task<ActionResult<string>> GetText()
{
  if (await isUserAuthenticated)
  {
    return "Hello world";
  }
  else
  {
    return Unauthorized();
  }
}
```
