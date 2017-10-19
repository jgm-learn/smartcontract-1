module.exports = {
  networks: {
    development: {
      host: '192.168.22.123',
      port: 8545,
      network_id: "*", // Match any network id
	  gas:70000000,
//	  gasprice:1
    }
  }
};
