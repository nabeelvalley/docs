# Testing Private Members

In order to test the values of private members (if for some reason that's necessary) you will need to make use of reflection. The following two functions will make it possible to access a private `field` or `property`

```cs
private CastType GetPrivateField<BaseType, CastType>(object sut, string fieldName)
{
  return (CastType) typeof(BaseType)
    .GetField("_endpoint", BindingFlags.NonPublic | BindingFlags.GetField | BindingFlags.Instance)
    .GetValue(sut);
}

private CastType GetPrivateProperty<BaseType, CastType>(object sut, string fieldName)
{
  return (CastType) typeof(BaseType)
    .GetField("_endpoint", BindingFlags.NonPublic | BindingFlags.GetProperty | BindingFlags.Instance)
    .GetValue(sut);
}
```
