Maven is a build tool for Java applications. The creation of maven projects can be done using the CLI and templates called Archetypes

# Init Project

To create a Kotlin/Maven project you can use the following command, provided:

- Archetype: `kotlin-archetype-jvm`
- Archetype Group ID: `org.jetbrains.kotlin`
- Archetype Version: `1.4.32`
- Project Group ID: `com.mycompany`
- Artiface ID: `demo`
- Output Directory: `.`

```sh
mvn archetype:generate -DarchetypeArtifactId=kotlin-archetype-jvm -DarchetypeGroupId=org.jetbrains.kotlin -DarchetypeVersion=1.4.32 -DgroupId=com.mycompany -DartifactId=demo -DoutputDirectory=.
```

Which will create a project based on the template in the `./demo` directory

Additionally, VSCode's **Maven for Java** extension also contains the `Maven: Create Maven Project` command which enables you to configure the entire project as well as search the Archetype repository for templates, I would recommend this over the command line method

# Compile

To compile a Maven app, run the followig command from the application directory, `./demo` in our example:

```sh
mvn compile
```

# Run

To run a maven app you actually run the compiled `jar`:

```sh
java -jar path/to/compiled.jar
```
