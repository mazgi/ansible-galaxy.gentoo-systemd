#!/usr/bin/env -S zsh -eu
setopt extended_glob

readonly SCRIPT_NAME=$(basename $0)
readonly termColorClear='\033[0m'
readonly termColorInfo='\033[1;32m'
readonly termColorWarn='\033[1;33m'
readonly termColorErr='\033[1;31m'
echoInfo() {
    echo -e "${termColorInfo}$1${termColorClear}"
}
echoWarn() {
    echo -e "${termColorWarn}$1${termColorClear}"
}
echoErr() {
    echo -e "${termColorErr}$1${termColorClear}"
}

# see: http://zsh.sourceforge.net/Doc/Release/Zsh-Modules.html#index-funcstack
if [[ ${#funcstack[@]} -ne 0 ]]; then
  echoErr 'The script is being sourced.'
  echoErr "Please run it is as a subshell such as \"sh ${SCRIPT_NAME}\""
  return 1
fi

local PORTAGE_BINHOST_BASE_URL='http://localhost:8080'
showHelp() {
  echo "Usage: ${SCRIPT_NAME} [OPTIONS]"
  echo "Options:"
  echo "\t-h, --help\t\tShow this help message."
  # See https://zsh.sourceforge.io/Guide/zshguide05.html#l124
  echo "\t-b, --binhost url\tSpecify the portage HTTP binhost."
}

exitBecauseIlligalBinhostSpecified() {
  echo ""
  echoErr "Error: The binhost \"${PORTAGE_BINHOST_BASE_URL}\" is not acceptable!!"
  echo ""
  showHelp
  exit 3
}

# Detect selected backend type.
local TFSTATE_BACKEND_TYPE=none
args=$(getopt -o hb: -l help,binhost: -- "$@") || exit 1
eval "set -- $args"
while [ $# -gt 0 ]; do
  case $1 in
    -h | --help) showHelp; shift; exit 1;;
    -b | --binhost) PORTAGE_BINHOST_BASE_URL=$2; shift 2;;
    --) shift; break;;
  esac
done
echoInfo "The binhost base URL \"${PORTAGE_BINHOST_BASE_URL}\" was specified."
# Validate the binhost base url.
if ! curl --fail --location --output /dev/null --silent ${PORTAGE_BINHOST_BASE_URL}; then
  exitBecauseIlligalBinhostSpecified
fi

readonly PORTAGE_BINHOST_URL="${PORTAGE_BINHOST_BASE_URL}/var/cache/binpkgs"
readonly PORTAGE_BINHOST_PORTAGE_SETTINGS_URL="${PORTAGE_BINHOST_BASE_URL}/portage-settings.tar.gz"

export PORTAGE_BINHOST="${PORTAGE_BINHOST_URL}"

# portage settings
echoWarn "Update the portage settings templates with the downloaded ones from the binhost."
echoWarn "Please check the changes in the 'roles/create-gentoo-system/templates/' directory."
curl --location ${PORTAGE_BINHOST_PORTAGE_SETTINGS_URL} --output /workspace/tmp/provisioning/portage-settings.tar.gz --silent
mkdir -p /workspace/tmp/provisioning/portage-settings
tar xf /workspace/tmp/provisioning/portage-settings.tar.gz -C /workspace/tmp/provisioning/portage-settings
(
  cd /workspace/tmp/provisioning/portage-settings
  find etc -type f -exec cp {} /workspace/roles/create-gentoo-system/templates/{}.j2 \;
)

# PORTAGE_BINHOST
echoInfo "Write out the portage settings as a vars file."
cat<<EOF | tee /workspace/tmp/provisioning/portage-settings-vars.yml
portage_settings:
  portage_binhost: ${PORTAGE_BINHOST_URL}
EOF
