#!/usr/bin/env bats

@test "should load node" {
  run node --version
  [ "$status" -eq 0 ]
}

@test "should load npm" {
  run npm --version
  [ "$status" -eq 0 ]
}

@test "should load mvn" {
  run mvn --version
  [ "$status" -eq 0 ]
}

@test "should load java" {
  run java -version
  [ "$status" -eq 0 ]
}
