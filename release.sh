#!/bin/sh
# http://vincent.demeester.fr/posts/2012-07-23-maven-release-gitflow/
# https://github.com/vdemeester/java-config
mvn -DtagNameFormat=@{project.version} -DpushChanges=false -DlocalCheckout=true -Dgoals=install release:prepare release:perform
