# Multi-Tier Integration Service

For applications that span multiple tiers or make use of a separate data accesss and web application layers a generic integration service can be used to communicate between tiers

## Service Definition

The service enables you to call controllers on the underlying tier by their route, provided that complex objects are supplied in the request body where needed

```cs
public class IntegrationService
{
    private string _apiBaseUrl;
    private WebProxy _proxy;

    public IntegrationService(string apiBaseUrl, WebProxy proxy = null)
    {
        _apiBaseUrl = apiBaseUrl;
        _proxy = proxy;
    }

    /// <summary>
    /// Creates a new HttpClient instance that can be used to make HTTP requests to the API endpoint with the endpoint and proxy precofigured
    /// Supports basic HTTP methods and configurations. Essentially enables client to call a function on another application's route with
    /// params as a single POST DTO if necessary
    /// </summary>
    /// <returns></returns>
    public HttpClient GetClient()
    {
        HttpClient client;

        if (_proxy != null)
        {
            var handler = new HttpClientHandler()
            {
                Proxy = _proxy
            };
            client = new HttpClient(handler);
        }
        else
        {
            client = new HttpClient();
        }

        client.BaseAddress = new Uri(_apiBaseUrl);

        return client;
    }

    #region GET Methods
    public async Task<string> Get(string path)
    {
        using (var client = GetClient())
        {
            var response = await client.GetStringAsync(path);
            return response;
        }
    }

    public async Task<T> Get<T>(string path)
    {
        using (var client = GetClient())
        {
            var response = await client.GetStringAsync(path);
            var data = JsonConvert.DeserializeObject<T>(response);
            return data;
        }
    }
    #endregion

    #region POST Methods
    public async Task<string> Post(string path, object requestData)
    {
        using (var client = GetClient())
        {
            var requestContent = new StringContent(
                JsonConvert.SerializeObject(requestData),
                Encoding.UTF8,
                "application/json"
            );

            var response = await client.PostAsync(path, requestContent);
            var responseString = await response.Content.ReadAsStringAsync();

            return responseString;
        }
    }

    public async Task<T> Post<T>(string path, object requestData)
    {
        using (var client = GetClient())
        {
            var requestContent = new StringContent(
                JsonConvert.SerializeObject(requestData),
                Encoding.UTF8,
                "application/json"
            );

            var response = await client.PostAsync(path, requestContent);
            var responseString = await response.Content.ReadAsStringAsync();
            var data = JsonConvert.DeserializeObject<T>(responseString);

            return data;
        }
    }
    #endregion

    #region PUT Methods
    public async Task<string> Put(string path, object requestData)
    {
        using (var client = GetClient())
        {
            var requestContent = new StringContent(
                JsonConvert.SerializeObject(requestData),
                Encoding.UTF8,
                "application/json"
            );

            var response = await client.PutAsync(path, requestContent);
            var responseString = await response.Content.ReadAsStringAsync();

            return responseString;
        }
    }

    public async Task<T> Put<T>(string path, object requestData)
    {
        using (var client = GetClient())
        {
            var requestContent = new StringContent(
                JsonConvert.SerializeObject(requestData),
                Encoding.UTF8,
                "application/json"
            );

            var response = await client.PutAsync(path, requestContent);
            var responseString = await response.Content.ReadAsStringAsync();
            var data = JsonConvert.DeserializeObject<T>(responseString);

            return data;
        }
    }
    #endregion

    #region DELETE Methods
    public async Task<string> Delete(string path)
    {
        using (var client = GetClient())
        {
            var response = await client.DeleteAsync(path);
            var responseString = await response.Content.ReadAsStringAsync();

            return responseString;
        }
    }

    public async Task<T> Delete<T>(string path)
    {
        using (var client = GetClient())
        {
            var response = await client.DeleteAsync(path);
            var responseString = await response.Content.ReadAsStringAsync();
            var data = JsonConvert.DeserializeObject<T>(responseString);

            return data;
        }
    }
    #endregion
}
```

## Confugure the Service

You can configure the service in your `startup.cs` as follows:

```cs
 services.AddScoped<IntegrationService>(s =>
  {
      var proxySettings = Configuration
          .GetSection("ProxySettings")
          .Get<ProxySettings>();

      var intBaseUrl = Configuration.GetValue<string>("IntegrationUrl");

      if (proxySettings.EnvironmentHasProxy()) 
      {
          var proxy = new WebProxy(
              proxySettings.Endpoint,
              proxySettings.BypassOnLocal
          );

          return new IntegrationService(intBaseUrl, proxy);
      }
      else
      {
          return new IntegrationService(intBaseUrl);
      }
  });
```

The above is a bit overkill as it does the proxy checking too, but you don't need that if you know your proxy configuration beforehand or are not using a proxy

## Using the Service

To use the service you need to request it in a controller constructor via Dependency Injection

```cs
public class MyController : Controller {
  
  private IntegrationService _integrationService;
 
  public MyController(IntegrationService integrationService)
  {
    _integrationService = integrationService;
  }
  
  public async task<MyObject> MyFunction(ComplexObject data)
  {
    var result = await integrationService.Post<MyObject>("api/DoStuff", data);
    
    return result;
  }
}
```
