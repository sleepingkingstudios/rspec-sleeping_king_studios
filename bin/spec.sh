#!/bin/bash --login

GEMSET="rspec-sleepingkingstudios"

for version in "2.0.0" "2.1.8" "2.2.4" "2.3.0"
do
  echo 'Running specs for '$version':'
  rvm $version@$GEMSET --create
  rvm $version@$GEMSET exec bundle install --quiet
  rvm $version@$GEMSET exec appraisal install
  rvm $version@$GEMSET exec appraisal rake ci:terse
done
