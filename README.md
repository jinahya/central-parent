# central-parent

[![Java CI with Maven](https://github.com/jinahya/central-parent/actions/workflows/maven.yml/badge.svg)](https://github.com/jinahya/central-parent/actions/workflows/maven.yml)
[![Maven Central](https://img.shields.io/maven-central/v/io.github.jinahya/central-parent.svg)](http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22io.github.jinahya%22%20AND%20a%3A%22central-parent%22)

A parent pom for deploying artifacts to the [Central Repository](https://central.sonatype.org/).

## Configure

### `pom.xml`

Just set this artifact as parent.

```xml
<parent>
  <groupId>io.github.jinahya</groupId>
  <artifactId>central-parent</artifactId>
</parent>
```

### `settings.xml`

Put your credentials to the `$M2_HOME/settings.xml`. See [Publishing By Using the Maven Plugin](https://central.sonatype.org/publish/publish-portal-maven/).

```xml
<server>
  <id>central</id>
  <username><!-- your token username --></username>
  <password><!-- your token password --></password>
</server>
```

## Deploy

See [Publishing By Using the Maven Plugin](https://central.sonatype.org/publish/publish-portal-maven/) for more options.

```
$ git switch -d x.y.z
$ mvn -Pcentral clean deploy
```