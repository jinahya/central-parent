# ossrh-parent
A parent pom project for deploying artifacts to `oss.sonatype.org`. See [OSSRH Guide](http://central.sonatype.org/pages/ossrh-guide.html)([Apache Maven](http://central.sonatype.org/pages/apache-maven.html)).

## `pom.xml`
Just set this artifact as a parent.
```xml
<parent>
  <groupId>com.github.jinahya</groupId>
  <artifactId>ossrh-parent</artifactId>
  <version>0.1.1</version>
</parent>
```
## `settings.xml`
We need two credentials.
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
Now you can release artifact as following.
```
$ mvn checkout x.y.z
$ mvn -Possrh clean deploy
```
