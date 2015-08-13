#!/bin/bash

set -euo pipefail

mvn -V -B -e verify

mvn org.codehaus.mojo:sonar-maven-plugin:2.6:sonar \
    -Dsonar.analysis.mode=preview \
    -Dsonar.host.url=http://nemo.sonarqube.org/ \
    -Dsonar.issuesReport.html.enable
