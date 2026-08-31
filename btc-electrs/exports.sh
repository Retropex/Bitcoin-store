export APP_ELECTRSBLAKE2B_IP="10.21.22.6"
export APP_ELECTRSBLAKE2B_NODE_IP="10.21.21.11"

export APP_ELECTRSBLAKE2B_NODE_PORT="50004"

for var in \
	IP \
	NODE_IP \
	NODE_PORT \
; do
	  electrs_var="APP_ELECTRS_${var}"
	  blake2b_var="APP_ELECTRSBLAKE2B_${var}"
	if [ -n "${!blake2b_var-}" ]; then
        export "$electrs_var"="${!electrs_var:=${!blake2b_var}}"
    else
        echo "Warning: $blake2b_var is unset or empty"
    fi
done

rpc_hidden_service_file="${EXPORTS_TOR_DATA_DIR}/app-${EXPORTS_APP_ID}-rpc/hostname"
export APP_ELECTRS_RPC_HIDDEN_SERVICE="$(cat "${rpc_hidden_service_file}" 2>/dev/null || echo "notyetset.onion")"