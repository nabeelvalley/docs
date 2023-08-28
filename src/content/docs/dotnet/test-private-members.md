---
published: true
title: Testing Private Members
subtitle: Unit Testing Private Members with XUnit
description: Unit Testing Private Members with XUnit
---

---
published: true
title: Testing Private Members
subtitle: Unit Testing Private Members with XUnit
description: Unit Testing Private Members with XUnit
---

# Testing Private Members

In order to test the values of private members (if for some reason that's necessary) you will need to make use of reflection. The following two functions will make it possible to access a private `field` or `property`

```cs
private CastType GetPrivateField<BaseType, CastType>(object obj, string fieldName)
{
  return (CastType) typeof(BaseType)
    .GetField("_endpoint", BindingFlags.NonPublic | BindingFlags.GetField | BindingFlags.Instance)
    .GetValue(obj);
}

private CastType GetPrivateProperty<BaseType, CastType>(object obj, string fieldName)
{
  return (CastType) typeof(BaseType)
    .GetField(obj, BindingFlags.NonPublic | BindingFlags.GetProperty | BindingFlags.Instance)
    .GetValue(obj);
}
```

## Abastract Testing Class

Additionally the Testing Class can inherit from the following base abstract

```cs
 /// <summary>
/// Classes that would like to test private members of class can extend this
/// </summary>
public abstract class AccessPrivateMemberBase
{
    /// <summary>
    /// Get a Private Field from the given object
    /// </summary>
    /// <typeparam name="BaseType">Type of the Input Object</typeparam>
    /// <typeparam name="CastType">Type of the Output Field</typeparam>
    /// <param name="obj"></param>
    /// <param name="fieldName">Name of the Field to get</param>
    /// <returns></returns>
    internal CastType GetPrivateField<BaseType, CastType>(object obj, string fieldName)
    {
        return (CastType)typeof(BaseType)
          .GetField(fieldName, BindingFlags.NonPublic | BindingFlags.GetField | BindingFlags.Instance)
          .GetValue(obj);
    }

    /// <summary>
    /// Get a Private Property from the given object
    /// </summary>
    /// <typeparam name="BaseType">Type of the Input Object</typeparam>
    /// <typeparam name="CastType">Type of the Output Property</typeparam>
    /// <param name="obj"></param>
    /// <param name="propertyName">Name of the Property to get</param>
    /// <returns></returns>
    internal CastType GetPrivateProperty<BaseType, CastType>(object obj, string propertyName)
    {
        return (CastType)typeof(BaseType)
          .GetField(propertyName, BindingFlags.NonPublic | BindingFlags.GetProperty | BindingFlags.Instance)
          .GetValue(obj);
    }
}
```

And then the testing class simply needs to be defined as:

```cs
public class MyTestingClass : AccessPrivateMemberBase
```

# Inherited Members

A more generic version of the above is also able to test for members that are in inherited classes (which the above will fail at):

```cs
/// <summary>
/// Get a Private Member from the given object.throws a KeyNotFound
/// Exception if the member could not be found
/// </summary>
/// <typeparam name="BaseType">Type of the Input Object</typeparam>
/// <typeparam name="CastType">Type of the Output Field</typeparam>
/// <param name="obj"></param>
/// <param name="fieldName">Name of the Field to get</param>
/// <returns></returns>
public static CastType GetPrivateMember<CastType>(
    object obj, string fieldName, int searchDepth = 1
)
{
    BindingFlags bindingFlags = BindingFlags.NonPublic
                                | BindingFlags.GetField
                                | BindingFlags.GetProperty
                                | BindingFlags.Instance;

    CastType result;

    result = (CastType)obj
      ?.GetType()
      ?.GetField(fieldName, bindingFlags)
      ?.GetValue(obj);

    int depth = 1;
    while (result == null && depth <= searchDepth)
    {
        depth ++;
        result = (CastType)obj
            ?.GetType()
            ?.BaseType
            ?.GetField(fieldName, bindingFlags)
            ?.GetValue(obj);

    }

    if (result == null)
        throw new KeyNotFoundException("The required member could not be found");

    return result;
}
```
