---
published: true
title: New Maven Project
subtitle: Basics for developing Kotlin apps with Maven
---

Maven is a build tool for Java applications. The creation of maven projects can be done using the CLI and templates called Archetypes

# Init Project

To create a Kotlin/Maven project you can use the following command, provided:

- Archetype: `kotlin-archetype-jvm`
- Archetype Group ID: `org.jetbrains.kotlin`
- Archetype Version: `1.4.32`
- Project Group ID: `com.mycompany`
- Artifact ID: `demo`
- Output Directory: `.`

```sh
mvn archetype:generate -DarchetypeArtifactId=kotlin-archetype-jvm -DarchetypeGroupId=org.jetbrains.kotlin -DarchetypeVersion=1.4.32 -DgroupId=com.mycompany -DartifactId=demo -DoutputDirectory=.
```

Which will create a project based on the template in the `./demo` directory

Additionally, VSCode's **Maven for Java** extension also contains the `Maven: Create Maven Project` command which enables you to configure the entire project as well as search the Archetype repository for templates, I would recommend this over the command line method

# Self Contained JAR

To ensure your code builds to a self-contained JAR and that the main function is executable, you should add the following to the `build>plugins` section of your `pom.xml` file:

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-assembly-plugin</artifactId>
    <version>2.6</version>
    <executions>
        <execution>
            <id>make-assembly</id>
            <phase>package</phase>
            <goals> <goal>single</goal> </goals>
            <configuration>
                <archive>
                    <manifest>
                        <mainClass>${main.class}</mainClass>
                    </manifest>
                </archive>
                <descriptorRefs>
                    <descriptorRef>jar-with-dependencies</descriptorRef>
                </descriptorRefs>
            </configuration>
        </execution>
    </executions>
</plugin>
```

You'll also need to set the `main.class` property in your `properties` section so that the build knows what to set it as in the above plugin we defined, this is made up of the Project Group ID + the name of the file with `Kt` appended to refer to the compiled Kotlin class, so in the starter app it will be `com.mycompany.HelloKt`:

```xml
<properties>
    ... other stuff
    <main.class>com.mycompany.HelloKt</main.class>
</properties>
```

# Verify

The `verify` command will run through all the build workflows that are configured, you can run:

```sh
mvn verify
```

This will test/package the application for you

# Build

If you want to specicically build a `jar` file, you do this with the `package` command:

```sh
mvn package
```

# Run

Once you've packaged your application, you can use the following to run it:

```sh
java -jar target/appname-jar-with-dependencies.jar
```

# Clean

Lastly, to clean all build artifacts you can just use:

```sh
mvn clean
```
