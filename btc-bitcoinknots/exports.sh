export APP_BITCOIN_KNOTS_POW_NODE_IP="10.21.21.233"
export APP_BITCOIN_KNOTS_POW_TOR_PROXY_IP="10.21.22.14"
export APP_BITCOIN_KNOTS_POW_I2P_DAEMON_IP="10.21.22.15"

export APP_BITCOIN_KNOTS_POW_DATA_DIR="${EXPORTS_APP_DIR}/data/bitcoin"
export APP_BITCOIN_KNOTS_POW_RPC_PORT="48332"
export APP_BITCOIN_KNOTS_POW_P2P_PORT="48333"
# Additional inbound P2P listener granting whitelisted permissions (whitebind) to this port; for trusted internal apps only; do not publish externally
export APP_BITCOIN_KNOTS_POW_P2P_WHITEBIND_PORT="48335"
export APP_BITCOIN_KNOTS_POW_TOR_PORT="48334"
export APP_BITCOIN_KNOTS_POW_ZMQ_RAWBLOCK_PORT="58332"
export APP_BITCOIN_KNOTS_POW_ZMQ_RAWTX_PORT="58333"
export APP_BITCOIN_KNOTS_POW_ZMQ_HASHBLOCK_PORT="58334"
export APP_BITCOIN_KNOTS_POW_ZMQ_SEQUENCE_PORT="58335"
export APP_BITCOIN_KNOTS_POW_ZMQ_HASHTX_PORT="58336"

export APP_BITCOIN_KNOTS_POW_NETWORK="testnet4" 

# Check for an existing settings.json file to override APP_BITCOIN_NETWORK with user's choice
{
	BITCOIN_APP_CONFIG_FILE="${EXPORTS_APP_DIR}/data/app/settings.json"
	if [[ -f "${BITCOIN_APP_CONFIG_FILE}" ]]
	then
		bitcoin_app_network=$(jq -r '.chain' "${BITCOIN_APP_CONFIG_FILE}")
		case $bitcoin_app_network in
			"testnet4")
				APP_BITCOIN_KNOTS_POW_NETWORK="testnet4";;
			"regtest")
				APP_BITCOIN_KNOTS_POW_NETWORK="regtest";;
			*)
				if [[ -n "$bitcoin_app_network" ]] && [[ "$bitcoin_app_network" != "null" ]]; then
					echo "Warning (${EXPORTS_APP_ID}): Invalid network '${bitcoin_app_network}' in settings.json. Exporting APP_BITCOIN_NETWORK as default 'mainnet'."
				fi;;
		esac
	fi
} > /dev/null || true

BITCOIN_ENV_FILE="${EXPORTS_APP_DIR}/.env"

if [[ ! -f "${BITCOIN_ENV_FILE}" ]]; then
	
	if [[ -z ${BITCOIN_RPC_USER+x} ]] || [[ -z ${BITCOIN_RPC_PASS+x} ]]; then
		BITCOIN_RPC_USER="umbrel"
		BITCOIN_RPC_DETAILS=$("${EXPORTS_APP_DIR}/scripts/rpcauth.py" "${BITCOIN_RPC_USER}")
		BITCOIN_RPC_PASS=$(echo "$BITCOIN_RPC_DETAILS" | tail -1)
	fi

	echo "export APP_BITCOIN_KNOTS_POW_RPC_USER='${BITCOIN_RPC_USER}'"	>> "${BITCOIN_ENV_FILE}"
	echo "export APP_BITCOIN_KNOTS_POW_RPC_PASS='${BITCOIN_RPC_PASS}'"	>> "${BITCOIN_ENV_FILE}"
fi

. "${BITCOIN_ENV_FILE}"

# echo "${APP_BITCOIN_KNOTS_POW_COMMAND}"

rpc_hidden_service_file="${EXPORTS_TOR_DATA_DIR}/app-${EXPORTS_APP_ID}-rpc/hostname"
p2p_hidden_service_file="${EXPORTS_TOR_DATA_DIR}/app-${EXPORTS_APP_ID}-p2p/hostname"
export APP_BITCOIN_KNOTS_POW_RPC_HIDDEN_SERVICE="$(cat "${rpc_hidden_service_file}" 2>/dev/null || echo "notyetset.onion")"
export APP_BITCOIN_KNOTS_POW_P2P_HIDDEN_SERVICE="$(cat "${p2p_hidden_service_file}" 2>/dev/null || echo "notyetset.onion")"

# electrs compatible network param
export APP_BITCOIN_KNOTS_POW_NETWORK_ELECTRS=$APP_BITCOIN_KNOTS_POW_NETWORK
if [[ "${APP_BITCOIN_KNOTS_POW_NETWORK_ELECTRS}" = "mainnet" ]]; then
	APP_BITCOIN_KNOTS_POW_NETWORK_ELECTRS="bitcoin"
fi