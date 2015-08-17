/* Initial data load */

INSERT INTO `name_servers` VALUES (1,1,1,1,'$(CONFIG_EXT_HOSTNAME)','Default configured nameserver','api','ultrahighsecretkey',1,1);

REPLACE INTO config VALUES ("ADMIN_API_KEY", 'ultrasecretadminapikey'), ("DEFAULT_HOSTMASTER", '$(CONFIG_EMAIL)');
