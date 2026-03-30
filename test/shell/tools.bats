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

@test "should have JAVA_HOME set to JDK 17" {
  [ -n "$JAVA_HOME" ]
  [[ "$JAVA_HOME" == *"openjdk17"* ]]
}

@test "should have JAVA_HOME pointing to valid JDK" {
  run "$JAVA_HOME/bin/java" -version
  [ "$status" -eq 0 ]
}
