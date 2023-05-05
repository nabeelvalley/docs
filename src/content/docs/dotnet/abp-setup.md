[[toc]]

[Refer to](https://github.com/aodendaal/aspnetboilerplate-core-ng)

# Infrastructure Layer

Inside of `.EFCore/DbContext` we add a `dbSet` for each entity

```cs
public dbSet<Customer> Customers {get; set;}
```

Thereafter we do a migration to add any new elements

Inside `EFCore/Seed/Host` the default admin is generated when the database is started for the first time. Additional users or entities can be generated on seeding as well, this will be executed every time the database is started up

## Classes, Interfaces and Abstracts

- Class: contains methods and properties
- Interface: can only inherit interfaces, always public – cannot have private members
- Abstract: classes are specified but not implemented, can be partial or pure abstract
- Virtual: methods that can be overwritten
- Sealed: cannot be extended

Can only inherit from one class at a time, however we can use multiple interfaces

# Application Layer

Inside of the .Core we include all our business logic, rules & Entities
Classes with rule-sets and properties

If we want a class to be an entity we do the following :

```cs
Public class Customer : FullAuditedEntity<long>
{
    [Required]
    Public string Name {get; set;}
    Public decimal Budget {get; set;}
    Public List<Invoice> Invoices { get; set; }//link to child
}
```

Other Entity Extensions/Inheritances:

- `Entity`
- `IMayHaveTenant`
- `IMustHaveTenant`

## AppService

Add a folder with the entity name and expose it to the application layer via the `.Application` folder, the name should end in `AppService`:

`CustomerAppService.cs`

```cs
public class CustomerAppService : ApplicationService
{
	public void DoStuff(){} //This will be available in the rest service, in our case = swagger
}
```

Inside of the WebCore we find the `CoreModule.cs` file that will generate the function that is accessible by the REST API, this is an infrastructure layer that hosts the application layer

We can generate these objects with dependency Injection:

```cs
public class CustomerAppService : ApplicationService
{
	private readonly IRepository<Customer> customerRepository; //repo of customers
	public CustomersAppService(IRepository<Customer>) //dependency injection
	{
		this.customerRepository = customerRepository;
	}

	public CustomerDto Create(CustomerDto input)
	{
		var customer = ObjectMapper.Map<Customer>(input);
		var customerId = customerRepository.InsertAndGetId(customer);

		return customerId;
	}
}
```

We do not directly expose our objects to the domain layer, this is passed by way of a DTO

## Service Manager

We can define a new class in the `.Core/Invoice`

```cs
public class InvoicesManager : DomainService
{
	Private readonly IRepository<Invoice> invoiceRepo;
	Public InvoicesManager(
		IRepository<Invoice> invoiceRepo
	){
		This.invoiceRepo = invoiceRepo;
	}

	Public async Task<int> CreateAsync(Invoice invoice)
	{
		Var id = await invoiceRepo.InsertAndGetIdAsync(invoice);
		Return id;
	}
}
```

Thereafter we define an AppService and Dto for the `invoice` and `lineItem`

# Authentication

Makes use of a token which system will use to verify the access of a user, this token is returned on login and is carried in the header.

## Roles

We can create multiple roles which would define the permissions for a user. The domain layer is where the business rules sit and therefore permissions and roles are defined in the domain layer in the .Core/Roles/StaticRoleNames.cs In this file we reserve a name in the tenant list,

Next we move to the AppRoleConfig.cs and add a static role definition for each role we need in the application

## Permissions

Permission Names are stored in the PermissionNames.cs file, the actual permissions are stored in the AuthorizationProvider.cs file

## Seeding

### Roles

In the .EfCore/EfCore/Seed/Tenant/TenantRoleAndUserBuilder.cs we use the same code that creates an Admin role and copy and rename where needed, this will verify that there is no role and will create on initialization. This is only run once, during DB initialization

### Permissions

In the Tenant Builder we specify our permissions for a specific role type, however this will require us to use the granted permissions and the permission checker for a role

Using that we make use of AbpAuthorize to specify what permission has access to a specific function

We simply add

```cs
[AbpAuthorize(PermissionNames.Pages_CreateUser, PermissionNames.Pages_Update User,…....)]
```

Above the specific function that needs to be locked

> ABP has two role types : Static and dynamic

We use static roles to define roles that we wouldn’t want to be removed at any point in time (like the admin role)

BoilerPlate makes use of two service types:

1. Managers
   - Do backend work
2. App Services
   - Interface between domain and external app
   - Responsible for security

Technically no difference in what these can do, this definition is for purpose differentiation

# Setting up an Entity

1. Make a folder for Entity inside of Project.Core
2. Create a class inside of folder, make the class public and in idealize a FullAuditedEntity:

```cs
public class Project : FullAuditedEntity
{
    public string Name { get; set; }
    public string Details { get; set; }
}
```

3. Create a folder with same name as class folder inside application, then add a Dto folder to that
4. Add a class into the dto folder with the name <ClassName>Dto, then copy original class and replace "FullAuditedEntity" with "EntityDto" and add the automapper, however you only need refer to the properties of the class you will be using., and not directly include referenced entities.

```cs
[AutoMap(typeof(Project))]
public class ProjectsDto : EntityDto
{
    public string Name { get; set; }
    public string Details { get; set; }
}
```

5. Add an app service inside of the Entity folder in the application layer and make use of the following:

```cs
public class ProjectsAppService : AsyncCrudAppService<Project, ProjectsDto>
{
    public ProjectsAppService(IRepository<Project> projectRepository) : base(projectRepository)
    {

    }
}
```

6. To project EntityFrameworkCore/EntityFrameworkCore/ProjectDbContext.cs add

```cs
public DbSet<Project> Projects;

public TestProjectDbContext(DbContextOptions<TestProjectDbContext> options) : base(options)
{
}
```

7. To run the project, in powershell do:
   a. Run in VS Code with IISExpress
   b. Entity framework check : `dotnet ef`
   c. Migrate db : `dotnet ef migrations add <MigrationName>`
   d. Update db : `dotnet ef database update`
   e. Stop and check Db via SQL Explorer

8. Database update complete
