#!/usr/bin/env -S zsh -eu

readonly local SCRIPT_NAME=$(basename $0)
readonly local STATUS_FILE=/var/run/container-stat-myself/status.json
getStatusFilePath () {
  echo ${STATUS_FILE:?}
}
resetStatus () {
  echoDebug "Reset the status."
  readonly local _dir=$(dirname ${STATUS_FILE:?})
  sudo mkdir -p ${_dir:?}/
  sudo chmod 777 ${_dir:?}/
  echo '{}' > ${STATUS_FILE:?}
}
updateStatusToSucceeded () {
  echoDebug "Update the status to succeeded."
  readonly local _tmpfile=${STATUS_FILE:?}.tmp
  cp ${STATUS_FILE:?} ${_tmpfile:?}
  jq '. + {succeeded:true}' ${_tmpfile:?} | tee ${STATUS_FILE:?}
  rm -rf ${_tmpfile:?}
}
updateStatusToFailed () {
  echoDebug "Update the status to succeeded."
  readonly local _tmpfile=${STATUS_FILE:?}.tmp
  cp ${STATUS_FILE:?} ${_tmpfile:?}
  jq '. + {succeeded:false}' ${_tmpfile:?} | tee ${STATUS_FILE:?}
  rm -rf ${_tmpfile:?}
}

showHelp() {
  echo "Usage: ${SCRIPT_NAME} [OPTIONS]"
  echo "Options:"
  echo "\t-h, --help\t\tShow this help message."
  echo "\t-p, --print-status-file-path\t\t(TBD)."
  echo "\t-f, --record-failure\t\t(TBD)."
  echo "\t-r, --reset-status\t\t(TBD)."
  echo "\t-s, --record-success\t\t(TBD)."
  echo "\t-w, --wait-signals\t\t(TBD)."
}

args=$(getopt -o hpfrsw -l help,print-status-file-path,record-failure,reset-status,record-success,wait-signals -- "$@") || exit 1
eval "set -- $args"
while [ $# -gt 0 ]; do
  case $1 in
    -h | --help)
      showHelp
      shift; exit 1;;
    -p | --print-status-file-path)
      getStatusFilePath
      shift; exit 0;;
    -f | --record-failure)
      updateStatusToFailed
      shift; exit 0;;
    -r | --reset-status)
      resetStatus
      shift; exit 0;;
    -s | --record-success)
      updateStatusToSucceeded
      shift; exit 0;;
    -w | --wait-signals)
      # Nothing todo.
      shift; break;;
    --)
      shift; break;;
  esac
done

trapSigTerm () {
  echoDebug "Exit by SIGTERM."
  trap SIGTERM
  exit 0
}
trap 'trapSigTerm' SIGTERM

echoInfo '✅ You are all set!'
# http://patorjk.com/software/taag/#p=display&f=Calvin%20S&t=you're%20all%20set
echoDebug '┬ ┬┌─┐┬ ┬┬─┐┌─┐  ┌─┐┬  ┬    ┌─┐┌─┐┌┬┐'
echoDebug '└┬┘│ ││ │├┬┘├┤   ├─┤│  │    └─┐├┤  │ '
echoDebug ' ┴ └─┘└─┘┴└─└─┘  ┴ ┴┴─┘┴─┘  └─┘└─┘ ┴ '
echoDebug "Turn in infinity sleep..."
sleep infinity &; readonly local SLEEP_PID=$!
wait ${SLEEP_PID}
exit $?
