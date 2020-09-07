#!/bin/bash
# Created with package:mono_repo v2.3.0

# Support built in commands on windows out of the box.
function pub {
       if [[ $TRAVIS_OS_NAME == "windows" ]]; then
        command pub.bat "$@"
    else
        command pub "$@"
    fi
}
function dartfmt {
       if [[ $TRAVIS_OS_NAME == "windows" ]]; then
        command dartfmt.bat "$@"
    else
        command dartfmt "$@"
    fi
}
function dartanalyzer {
       if [[ $TRAVIS_OS_NAME == "windows" ]]; then
        command dartanalyzer.bat "$@"
    else
        command dartanalyzer "$@"
    fi
}

if [[ -z ${PKGS} ]]; then
  echo -e '\033[31mPKGS environment variable must be set!\033[0m'
  exit 1
fi

if [[ "$#" == "0" ]]; then
  echo -e '\033[31mAt least one task argument must be provided!\033[0m'
  exit 1
fi

EXIT_CODE=0

for PKG in ${PKGS}; do
  echo -e "\033[1mPKG: ${PKG}\033[22m"
  pushd "${PKG}" || exit $?

  PUB_EXIT_CODE=0
  pub upgrade --no-precompile || PUB_EXIT_CODE=$?

  if [[ ${PUB_EXIT_CODE} -ne 0 ]]; then
    EXIT_CODE=1
    echo -e '\033[31mpub upgrade failed\033[0m'
    popd
    continue
  fi

  for TASK in "$@"; do
    echo
    echo -e "\033[1mPKG: ${PKG}; TASK: ${TASK}\033[22m"
    case ${TASK} in
    command_0)
      echo 'dartanalyzer --enable-experiment=non-nullable --fatal-warnings --fatal-infos .'
      dartanalyzer --enable-experiment=non-nullable --fatal-warnings --fatal-infos . || EXIT_CODE=$?
      ;;
    command_1)
      echo 'dartfmt --dry-run --set-exit-if-changed .'
      dartfmt --dry-run --set-exit-if-changed . || EXIT_CODE=$?
      ;;
    command_2)
      echo 'pub run --enable-experiment=non-nullable test --platform vm'
      pub run --enable-experiment=non-nullable test --platform vm || EXIT_CODE=$?
      ;;
    command_3)
      echo 'pub run --enable-experiment=non-nullable test --platform chrome'
      pub run --enable-experiment=non-nullable test --platform chrome || EXIT_CODE=$?
      ;;
    *)
      echo -e "\033[31mNot expecting TASK '${TASK}'. Error!\033[0m"
      EXIT_CODE=1
      ;;
    esac
  done

  popd
done

exit ${EXIT_CODE}
