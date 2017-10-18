module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8530,
      network_id: "*", // Match any network id
	  gas:70000000,
//	  gasprice:1
    }
  }
};
