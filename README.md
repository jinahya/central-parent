# ossrh-parent
[![Build Status](https://travis-ci.org/jinahya/ossrh-parent.svg)](https://travis-ci.org/jinahya/ossrh-parent)
[![Dependency Status](https://www.versioneye.com/user/projects/5652ef1dff016c00330005b0/badge.svg)](https://www.versioneye.com/user/projects/5652ef1dff016c00330005b0)
[![Maven Central](https://img.shields.io/maven-central/v/com.github.jinahya/ossrh-parent.svg)](http://search.maven.org/#search%7Cga%7C1%7Cg%3A%22com.github.jinahya%22%20AND%20a%3A%22ossrh-parent%22)
[![GitHub issues](https://img.shields.io/github/issues/com.github.jinahya/ossrh-parent.svg)](https://github.com/jinahya/ossrh-parent/issues)

a parent pom project for deploying artifacts to `oss.sonatype.org`. see [OSSRH Guide](http://central.sonatype.org/pages/ossrh-guide.html) (or [Apache Maven specific](http://central.sonatype.org/pages/apache-maven.html)). you might also want to see [Working with PGP Signatures](http://central.sonatype.org/pages/working-with-pgp-signatures.html).

## `pom.xml`

just set this artifact as parent.

```xml
<parent>
  <groupId>com.github.jinahya</groupId>
  <artifactId>ossrh-parent</artifactId>
  <version>x.y.z</version>
</parent>
```
## `settings.xml`

we need two credentials. one for `nexus-staging-maven-plugin` and the other for `maven-gpg-plugin`.

```xml
<!-- for nexus-staging-maven-plugin -->
<server>
  <id>ossrh</id>
  <username>username</username>
  <password>{...}</password>
</server>

<!-- for maven-gpg-plugin -->
<server>
  <id>gpg.passphrase</id>
  <passphrase>{...}</passphrase>
</server>
```

## deploy

### snapshots

snapshots can be deployed as it is

```
$ mvn deploy
```

### releases

releases can be deployed like this.

```
$ git checkout x.y.z
$ mvn -Possrh deploy
```

## caveats

note that, by invoking the `deploy` goal with the `-Possrh` profile, you're intending to deploy the artifact to the OSSRH (snapshot|release) repository. when the `${project.version}` doesn't have a `SNAPSHOT`, the deployed artifact will also be automatically synchronized to the Maven Central Respository.
