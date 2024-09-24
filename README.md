# ossrh-parent
[![Build Status](https://travis-ci.org/jinahya/central-parent.svg)](https://travis-ci.org/jinahya/ossrh-parent)
[![Maven Central](https://img.shields.io/maven-central/v/io.github.jinahya/central-parent.svg)](http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22com.github.jinahya%22%20AND%20a%3A%22ossrh-parent%22)

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

See [Publishing By Using the Maven Plugin](https://central.sonatype.org/publish/publish-portal-maven/).

```xml
<server>
  <id>central</id>
  <username><!-- your token username --></username>
  <password><!-- your token password --></password>
</server>
```

## Deploy

```
$ git switch -d x.y.z
$ mvn -Pcentral clean deploy
```