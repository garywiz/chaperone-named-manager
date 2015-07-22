options {
	directory "$(VAR_DIR)/named-zones";

	// If there is a firewall between you and nameservers you want
	// to talk to, you may need to fix the firewall to allow multiple
	// ports to talk.  See http://www.kb.cert.org/vuls/id/800113

	// If your ISP provided one or more IP addresses for stable 
	// nameservers, you probably want to use them as forwarders.  
	// Uncomment the following block, and insert the addresses replacing 
	// the all-0's placeholder.

	// forwarders {
	// 	0.0.0.0;
	// };

	//========================================================================
	// If BIND logs error messages about the root key being expired,
	// you will need to update your keys.  See https://www.isc.org/bind-keys
	//========================================================================
	dnssec-validation auto;

	auth-nxdomain no;    # conform to RFC1035
	listen-on port 8053 { any; };
	listen-on-v6 port 8053 { any; };

	pid-file "$(VAR_DIR)/run/named.pid";
};

include "$(APPS_DIR)/etc/bind/rndc.key";

controls {
        inet 127.0.0.1 port 8953 allow { localhost; } keys { "rndc-key"; };
};

// prime the server with knowledge of the root servers
zone "." {
	type hint;
	file "$(APPS_DIR)/etc/bind/db.root";
};

// be authoritative for the localhost forward and reverse zones, and for
// broadcast zones as per RFC 1912

zone "localhost" {
	type master;
	file "$(APPS_DIR)/etc/bind/db.local";
};

zone "127.in-addr.arpa" {
	type master;
	file "$(APPS_DIR)/etc/bind/db.127";
};

zone "0.in-addr.arpa" {
	type master;
	file "$(APPS_DIR)/etc/bind/db.0";
};

zone "255.in-addr.arpa" {
	type master;
	file "$(APPS_DIR)/etc/bind/db.255";
};

// RFC1918 zones.  Remove these if you don't need them.

zone "10.in-addr.arpa"      { type master; file "/etc/bind/db.empty"; };
 
zone "16.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "17.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "18.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "19.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "20.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "21.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "22.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "23.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "24.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "25.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "26.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "27.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "28.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "29.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "30.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };
zone "31.172.in-addr.arpa"  { type master; file "/etc/bind/db.empty"; };

zone "168.192.in-addr.arpa" { type master; file "/etc/bind/db.empty"; };

// INCLUDE namedmanager zones

include "$(APPS_DIR)/var/named-zones/named.namedmanager.conf";
