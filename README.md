# central-parent

[![Java CI with Maven](https://github.com/jinahya/central-parent/actions/workflows/maven.yml/badge.svg)](https://github.com/jinahya/central-parent/actions/workflows/maven.yml)
[![Maven Central](https://img.shields.io/maven-central/v/io.github.jinahya/central-parent.svg)](https://central.sonatype.com/artifact/io.github.jinahya/central-parent)

A parent pom for publishing artifacts to the [Central Repository](https://central.sonatype.org/) via the [Central Portal](https://central.sonatype.com/).

Set it as your parent, put your token in `settings.xml`, and run `mvn -Pcentral-releases deploy`.

## What You Get

* Two publishing profiles, `central-releases` and `central-snapshots`; see [Profiles](#profiles).
* Everything Central requires for a release — gpg signatures, `-sources.jar`, `-javadoc.jar`, checksums — produced by the `central-releases` profile.
* Pinned versions (`<pluginManagement>`) of the plugins involved; see [Managed Plugins](#managed-plugins).
* A `requireMavenVersion` rule; see [Requirements](#requirements).

## Requirements

| What                    | Notes                                                                                                                                                      |
|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Maven `[3.9.0,4)`       | Enforced for every build. 3.9.0+ is required by managed plugins; the upper bound is temporary, see [Known Issues](#known-issues).                           |
| A Central Portal account | With a [verified namespace](https://central.sonatype.org/register/namespace/) matching your `groupId`.                                                    |
| A user token            | Generated on the [Central Portal](https://central.sonatype.com/usertoken). See [Generating a Portal Token](https://central.sonatype.org/publish/generate-portal-token/). |
| A GPG key               | Only for releases. Its public key must be on a key server. See [GPG](https://central.sonatype.org/publish/requirements/gpg/).                              |

## Usage

### 1. Set the parent

```xml
<parent>
  <groupId>io.github.jinahya</groupId>
  <artifactId>central-parent</artifactId>
  <version>0.1.7</version>
</parent>
```

### 2. Override the project metadata

Central [requires](https://central.sonatype.org/publish/requirements/) `name`, `description`, `url`, `licenses`, `developers` and `scm`. **These are all inherited from this parent and describe _this_ project, not yours** — e.g., an inherited `<scm><url>` ends up as `https://github.com/jinahya/<your-artifactId>/<your-artifactId>`. Override every one of them.

```xml
<name>${project.artifactId}</name>
<description>...</description>
<url>https://github.com/you/your-project</url>

<licenses>
  <license>
    <name>...</name>
    <url>...</url>
  </license>
</licenses>

<developers>
  <developer>
    <name>...</name>
    <email>...</email>
  </developer>
</developers>

<scm>
  <connection>scm:git:https://github.com/you/your-project.git</connection>
  <developerConnection>scm:git:git@github.com:you/your-project.git</developerConnection>
  <url>https://github.com/you/your-project</url>
</scm>
```

### 3. Configure `settings.xml`

Put your user token into `~/.m2/settings.xml`. The `<id>` must be `central`.

```xml
<settings>
  <servers>
    <server>
      <id>central</id>
      <username><!-- your token username --></username>
      <password><!-- your token password --></password>
    </server>
  </servers>
</settings>
```

### 4. Provide the GPG passphrase

The `central-releases` profile signs with the `maven-gpg-plugin`. Following its [recommendations](https://maven.apache.org/plugins/maven-gpg-plugin/usage.html), provide the passphrase in one of these ways:

* **On a workstation**, let `gpg-agent` provide it. In batch mode (`-B`, or the build that `release:perform` runs) the agent can't prompt, so cache the passphrase beforehand.
  ```
  $ echo test | gpg --clearsign
  ```
* **On CI**, or anywhere without an agent, set the `MAVEN_GPG_PASSPHRASE` environment variable. Don't type it inline, or it ends up in your shell history.
  ```
  $ read -s -p "GPG passphrase: " MAVEN_GPG_PASSPHRASE; export MAVEN_GPG_PASSPHRASE
  ```

Don't put the passphrase in `settings.xml` or pass it with `-Dgpg.passphrase`; both are deprecated by the plugin.

### 5. Publish

#### Releases

```
$ git switch -d x.y.z
$ mvn -Pcentral-releases clean deploy
```

The deployment is uploaded, validated, and published automatically (`autoPublish=true`). The build returns once it's validated; actual availability on Central may take a while longer.

#### Snapshots

[Enable SNAPSHOTs](https://central.sonatype.org/publish/publish-portal-snapshots/#enabling-snapshot-releases-for-your-namespace) for your namespace on the Central Portal first.

```
$ mvn -Pcentral-snapshots clean deploy
```

To consume published snapshots, see [Consuming -SNAPSHOT Releases](https://central.sonatype.org/publish/publish-portal-snapshots/#consuming-snapshot-releases-for-your-project).

## Profiles

| Profile             | Accepts              | What it does                                                                                                                                            |
|---------------------|----------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| `central-releases`  | release versions     | Fails on `-SNAPSHOT` versions. Signs (gpg), attaches sources and javadocs, uploads to the Central Portal, and auto-publishes.                            |
| `central-snapshots` | `-SNAPSHOT` versions | Fails on release versions. Uploads to the [Central Portal Snapshots](https://central.sonatype.com/repository/maven-snapshots/) repository; no signing. |

Both profiles use the `central-publishing-maven-plugin` with `<publishingServerId>central</publishingServerId>`.

There is no `<distributionManagement>`, so a plain `mvn deploy` without one of the profiles fails.

See [Publishing By Using the Maven Plugin](https://central.sonatype.org/publish/publish-portal-maven/) for the plugin's other options, which you can set in your own pom.

## Managed Plugins

| Plugin                                                     | Version  |
|------------------------------------------------------------|----------|
| `org.apache.maven.plugins:maven-enforcer-plugin`           | `3.7.0`  |
| `org.apache.maven.plugins:maven-gpg-plugin`                | `3.2.8`  |
| `org.apache.maven.plugins:maven-javadoc-plugin`            | `3.12.0` (`${version.maven-javadoc-plugin}`) |
| `org.apache.maven.plugins:maven-release-plugin`            | `3.3.1`  |
| `org.apache.maven.plugins:maven-source-plugin`             | `3.4.0`  |
| `org.codehaus.mojo:tidy-maven-plugin`                      | `1.5.0`  |
| `org.codehaus.mojo:versions-maven-plugin`                  | `2.25.1` |
| `org.sonatype.central:central-publishing-maven-plugin`     | `0.12.0` |

## Known Issues

### Maven 4

The `central-publishing-maven-plugin` [fails to publish with Maven 4.x.x](https://github.com/sonatype-nexus-community/central-publishing-maven-plugin/issues/7) (listed under *Known issues* in [Publishing By Using the Maven Plugin](https://central.sonatype.org/publish/publish-portal-maven/)).

Until it's fixed, the `requireMavenVersion` rule is capped below `4` (`[3.9.0,4)`), so the build fails early with a clear message instead of failing at upload time. Once a fixed plugin version is released, the plugin will be bumped and the range changed back to `[3.9.0,)`.

## Migrating from `0.1.6` or Earlier

* The `central` profile is renamed to `central-releases`. Replace `-Pcentral` with `-Pcentral-releases`.
* The `ossrh` `<distributionManagement>` is removed; [OSSRH has been shut down](https://central.sonatype.org/news/20250326_ossrh_sunset/).
* The `nexus-staging-maven-plugin` is no longer managed.
* The minimum Maven version is now `3.9.0`, and Maven 4 is rejected for now.
