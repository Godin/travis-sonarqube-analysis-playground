#!/bin/bash

set -euo pipefail

#rm -r sonar-runner-dist-2.4.zip sonar-runner-2.4 || true
curl -O http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip
unzip sonar-runner-dist-2.4.zip

./sonar-runner-2.4/bin/sonar-runner -X -Dsonar.analysis.mode=preview \
    -Dsonar.host.url=http://byteshiva.ngrok.io/ \
    -Dsonar.issuesReport.html.enable \
    -Dsonar.projectKey=app \
    -Dsonar.projectName=Backbone.js \
    -Dsonar.projectVersion=master \
    -Dsonar.sources=backbone \
    -Dsonar.inclusions=**/backbone.js

rm -rf out || true
mkdir out
cp .sonar/issues-report/issues-report.html out/index.html
cp -r .sonar/issues-report/issuesreport_files out/
cd out
git init
git config user.name "Travis CI"
git config user.email "byteshiva@gmail.com"
git add .
git commit -m "Deploy to GitHub Pages"
git push --force --quiet "https://${GH_TOKEN}@github.com/byteshiva/travis-sonarqube-analysis-playground.git" master:gh-pages > /dev/null 2>&1
