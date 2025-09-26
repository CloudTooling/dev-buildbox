#!/usr/bin/env bash

configFile=$1
version=$2

# Increment a version string using Semantic Versioning (SemVer) terminology.
# Parse command line options.
# Source: https://github.com/fmahnke/shell-semver
#
# usage: increment_version.sh [-Mmp] major.minor.patch
increment_version() {
  while getopts ":Mmp" Option
  do
    case $Option in
      M ) major=true;;
      m ) minor=true;;
      p ) patch=true;;
      * ) patch=true;;
    esac
  done

  # shellcheck disable=SC2004,SC2206
  shift $(($OPTIND - 1))

  version=$1

  # Build array from version string.
  # shellcheck disable=SC2206
  a=( ${version//./ } )
  # If version string is missing or has the wrong number of members, show usage message.
  if [ ${#a[@]} -ne 3 ]
  then
    echo "usage: $(basename $0) [-Mmp] major.minor.patch"
    exit 1
  fi

  # Increment version numbers as requested.

  if [ -n "$major" ]
  then
    ((a[0]++))
    a[1]=0
    a[2]=0
  fi

  if [ -n "$minor" ]
  then
    ((a[1]++))
    a[2]=0
  fi

  if [ -n "$patch" ]
  then
    ((a[2]++))
  fi

  echo "${a[0]}.${a[1]}.${a[2]}"
}

increment_patch_version() {
  increment_version -p "$1"
}

if [[ "$version" == "X.Y.Z" ]]; then
  version=$(jq ".version" $configFile -r)
  newVersion=$(increment_patch_version $version)
fi

echo "Starting Base Docker release finish for ${newVersion}"

export version=$newVersion
