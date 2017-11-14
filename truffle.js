var cfg = require('./config.js');
require('babel-register');
module.exports = {
  networks: {
    development: {
      host:cfg.Host,
      port:cfg.Port,
      network_id: "*", //match any networkID
	  gas:70000000,
      from:cfg.GodAddr,
//	  gasprice:1
    }
  }
};
