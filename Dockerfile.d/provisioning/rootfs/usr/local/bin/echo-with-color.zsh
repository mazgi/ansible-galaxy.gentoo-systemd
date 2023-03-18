#!/usr/bin/env -S zsh -eu

readonly local SCRIPT_NAME=$(basename $0)
readonly local termColorClear='\033[0m'
echoDebug() {
  readonly local termColorDebug='\033[1;34m'
  echo -e "${termColorDebug}$@${termColorClear}"
}
echoInfo() {
  readonly local termColorInfo='\033[1;32m'
  echo -e "${termColorInfo}$@${termColorClear}"
}
echoWarn() {
  readonly local termColorWarn='\033[1;33m'
  echo -e "${termColorWarn}$@${termColorClear}"
}
echoErr() {
  readonly local termColorErr='\033[1;31m'
  echo -e "${termColorErr}$@${termColorClear}"
}

# Export functions by names
case ${SCRIPT_NAME} in
  echoDebug | echoInfo |echoWarn | echoErr)
    ${SCRIPT_NAME} "$@"
    exit 0
    ;;
esac
