#!/usr/bin/env bats

@test "should load helm" {
  run helm version
}

@test "should load ansible" {
  run ansible --version
  [ "$status" -eq 0 ]
}

@test "should load ansible-docsmith" {
  run ansible-docsmith --version
  [ "$status" -eq 0 ]
}

@test "should load node" {
  run node --version
  [ "$status" -eq 0 ]
}

@test "should load npm" {
  run npm --version
  [ "$status" -eq 0 ]
}

@test "should load conventional-changelog" {
  run conventional-changelog --version
  [ "$status" -eq 0 ]
}

@test "should load git-cliff" {
  run git-cliff --version
  [ "$status" -eq 0 ]
}

@test "should have git-cliff installed directly in /usr/local/bin" {
  [ -x /usr/local/bin/git-cliff ]
}

@test "should load yarn" {
  run yarn --version
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
