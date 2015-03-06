#!/bin/bash --login

GEMSET="rspec-sleepingkingstudios"

for version in "2.0.0" "2.1.5" "2.2.1"
do
  echo 'Running specs for '$version':'
  rvm $version@$GEMSET --create
  rvm $version@$GEMSET exec bundle install --quiet
  rvm $version@$GEMSET exec appraisal install
  rvm $version@$GEMSET exec appraisal rspec --format=progress
done
