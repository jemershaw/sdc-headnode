#!/usr/bin/bash
#
# Upgrades setup and configure scripts in /usbkey/extra/... for new
# SDC core zone provisions.
#
# Usage:
#   ./upgrade-setup.sh <upgrade-images-file>
#

set -o errexit
set -o xtrace

function copy_setup_files
{
    local role=$1
    rm -f /usbkey/extra/$role/setup
    cp zones/$role/setup /usbkey/extra/$role/setup
    rm -f /usbkey/extra/$role/configure
    cp zones/$role/configure /usbkey/extra/$role/configure
    rm -f /usbkey/extra/$role/setup.common
    cp /usbkey/default/setup.common /usbkey/extra/$role/setup.common
    rm -f /usbkey/extra/$role/configure.common
    cp /usbkey/default/configure.common /usbkey/extra/$role/configure.common
    #TODO: should update /usbkey/extras/bashrc from /usbkey/rc/
}


#---- mainline

IMAGE_LIST=$1
if [[ -z $1 ]]; then
    echo "$0: error: no '<update-images-file>' given"
    echo ""
    echo "Usage: download-all.sh <update-images-file>"
    exit 1
fi
source $IMAGE_LIST

# Hack extract role names from FOO_IMAGE vars in the given <upgrade-images-file>.
ROLES=
[[ -n "$SDC_IMAGE" ]] && ROLES="$ROLES sdc"
[[ -n "$UFDS_IMAGE" ]] && ROLES="$ROLES ufds"
[[ -n "$ADMINUI_IMAGE" ]] && ROLES="$ROLES adminui"
[[ -n "$AMON_IMAGE" ]] && ROLES="$ROLES amon"
[[ -n "$AMONREDIS_IMAGE" ]] && ROLES="$ROLES amonredis"
[[ -n "$CA_IMAGE" ]] && ROLES="$ROLES ca"
[[ -n "$CLOUDAPI_IMAGE" ]] && ROLES="$ROLES cloudapi"
[[ -n "$CNAPI_IMAGE" ]] && ROLES="$ROLES cnapi"
[[ -n "$DHCPD_IMAGE" ]] && ROLES="$ROLES dhcpd"
[[ -n "$FWAPI_IMAGE" ]] && ROLES="$ROLES fwapi"
[[ -n "$IMGAPI_IMAGE" ]] && ROLES="$ROLES imgapi"
[[ -n "$NAPI_IMAGE" ]] && ROLES="$ROLES napi"
[[ -n "$SAPI_IMAGE" ]] && ROLES="$ROLES sapi"
[[ -n "$USAGEAPI_IMAGE" ]] && ROLES="$ROLES usageapi"
[[ -n "$VMAPI_IMAGE" ]] && ROLES="$ROLES vmapi"
[[ -n "$WORKFLOW_IMAGE" ]] && ROLES="$ROLES workflow"
[[ -n "$DAPI_IMAGE" ]] && ROLES="$ROLES dapi"

cp default/* /usbkey/default
for ROLE in $ROLES; do
    copy_setup_files $ROLE
done