#!/usr/bin/env bash

# Verify OS
while [[ $# > 0 ]]; do
    key="$1"
    case $key in
        -c|--cassandra)
        path_to_cassandra="$2"
        shift
        ;;
        *)
        echo "No params provided";
        exit 1;
        ;;
    esac
shift
done

function validateOS {
  UNAME_S=$(uname -s)
  if [[ ${UNAME_S} =~ Linux* ]] ; then
    echo "Linux OS"
  elif [[ ${UNAME_S} =~ Darwin* ]] ; then
    echo "OS X machine"
  else
    echo "Invalid OS"
    exit 1;
  fi
}

function verifyGit {
  if type -p git; then
      echo found git executable in PATH
      _git=git
  else
      echo "please install git 2.2.x"
      exit;
  fi

  if [[ "$_git" ]]; then
      version_string=$("$_git" --version)
      echo versionString "$version_string"
      version="${version_string: -5}"

      echo version "${version}"
      if [[ "${version:0:1}" -ge "2" && "${version:2:1}" -ge "2" ]]; then
          echo "git version is greater than 2.2.x"
      else
          echo "git version is less than 2.2.x"
          exit 1;
      fi
  fi
}

function verifyNpm {
  if type -p npm; then
      echo found npm executable in PATH
      _npm=npm
  else
      echo "Please install npm 2.7.x or greater"
      exit 1;
  fi

  if [[ "$_npm" ]]; then
      version=$("$_npm" --version)
      echo npm version found "$version"
      if [[ "${version:0:1}" -ge "2" && "${version:2:1}" -ge "7" ]]; then
          echo "npm version is greater than 2.7"
      else
          echo "npm version is less than 2.7"
          exit 1;
      fi
  fi
}

function verifyNode {
  if type -p node; then
      echo found nodejs executable in PATH
      _node=node
  else
      echo "Please install nodejs version 0.12.x or greater"
      exit 1;
  fi

  if [[ "$_node" ]]; then
      version=$("$_node" --version)
      echo nodejs version "$version"
      if [[ "${version:1:1}" -gt "0" && "${version:3:1}" -ge "0" ]]; then
          echo "nodejs version is more than 0.12"
      elif [[ "${version:1:1}" -eq "0" && "${version:3:2}" -ge "12"  ]]; then
          echo "nodejs version is greater than 0.12"
      else
          echo "nodejs version is less than 0.12"
          exit 1;
      fi
  fi
}

function verifyJava {
  if type -p java; then
      echo found java executable in PATH
      _java=java
  elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]];  then
      echo found java executable in JAVA_HOME
      _java="$JAVA_HOME/bin/java"
  else
      echo "please install java version 1.8 or greater"
      exit 1;
  fi

  if [[ "$_java" ]]; then
      version=$("$_java" -version 2>&1 | awk -F '"' '/version/ {print $2}')
      echo java version "$version"
      if [[ "${version:0:1}" -eq "1" && "${version:2:1}" -eq "8" ]]; then
          echo "java version is greater than 1.8"
      else
          echo "java version is less than 1.8"
          exit 1;
      fi
  fi
}

function verifyCassandra {
  if [[ ${path_to_cassandra} ]]; then
      if [[ ! -d "${path_to_cassandra}/bin" ]]; then
          if [[ ! -d "${path_to_cassandra}bin" ]]; then
            echo "wrong cassandra directory provided"
            exit 1
          else
            CASSANDRA_BIN="${path_to_cassandra}bin";
          fi
      else
        CASSANDRA_BIN="${path_to_cassandra}/bin";
      fi
  fi

  if type -p cassandra; then
      echo found cassandra executable in PATH
      _cassandra=cassandra
  elif [[ -n "$CASSANDRA_BIN" ]] && [[ -x "$CASSANDRA_BIN/cassandra" ]];  then
      echo found cassandra executable in CASSANDRA_HOME
      _cassandra="$CASSANDRA_BIN/cassandra"
  else
      echo "Please download/install cassandra version 2.1.11"
      exit 1;
  fi

  if [[ "$_cassandra" ]]; then
      version=$("$_cassandra" -v)
      echo cassandra version "$version"
      if [[ "${version:0:1}" -eq "2" && "${version:2:1}" -eq "1" &&  "${version:4:2}" -eq "11" ]]; then
          echo "cassandra version found 2.1.11"
      else
          echo "Please see about using cassandra version 2.1.11"
          exit 1;
      fi
  fi
}

function verifyMaven {
  if type -p mvn; then
      echo found mvn executable in PATH
      _mvn=mvn
  else
      echo "please install maven version 3.3.9 or greater"
      exit 1;
  fi

  mvn --version | grep -e 'Maven\s[3-9]\.[0-9]\.[0-9]*'
  if [[ $? -eq 0 ]]; then
    mvn --version | grep -e 'Maven\s[3-9]\.[4-9]\.[0-9]*'
    if [[ $? -eq 0 ]]; then
      echo "Maven 3.4.x found"
    else
      mvn --version | grep -e 'Maven\s3\.3\.9*'
      if [[ $? -eq 0 ]]; then
        echo "Maven 3.3.9 found"
      else
        echo "No maven 3.3.9 or greater was found"
        exit 1;
      fi
    fi
  else
    echo "No maven 3.3.9 or greater was found"
    exit 1;
  fi
}

function validateXcode {
   version=$(xcodebuild -version)
   if [[ $? -eq 0 ]]; then
      majorv=${version:6:1}
      echo  "xcode version found: " $majorv
   else
    echo "Please see about installing xcode tools"
    exit 1;
   fi
}

validateXcode
validateOS
verifyJava
verifyNode
verifyNpm
verifyMaven

if [[ ${path_to_cassandra} ]]; then
  verifyCassandra
fi


exit 0;