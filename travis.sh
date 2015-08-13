#!/bin/bash

set -euo pipefail

mvn -V -B -e verify

mvn org.codehaus.mojo:sonar-maven-plugin:2.6:sonar \
    -Dsonar.analysis.mode=preview \
    -Dsonar.host.url=http://nemo.sonarqube.org/ \
    -Dsonar.issuesReport.html.enable

rm -rf out || true
mkdir out
cp target/sonar/issues-report/issues-report.html out/index.html
cp -r target/sonar/issues-report/issuesreport_files out/
cd out
git init
git config user.name "Travis CI"
git config user.email "<you>@<your-email>"
git add .
git commit -m "Deploy to GitHub Pages"
git push --force --quiet "https://${GH_TOKEN}@github.com/Godin/travis-sonarqube-analysis-playground.git" master:gh-pages > /dev/null 2>&1
