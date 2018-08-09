#! /bin/bash
export zone=$(curl -s -H "Metadata-Flavor: Google" "http://metadata.google.internal/computeMetadata/v1/instance/zone" | grep -o [[:alnum:]-]*$)

# Set zone in Consul template
envsubst < "/etc/hosts.consul.ctmpl.tpl" > "/etc/hosts.consul.ctmpl"

# Set zone in Consul Nats files
envsubst < "/etc/consul.d/nats.json.tpl" > "/etc/consul.d/nats.json"

# Start consul
/usr/local/bin/consul agent -data-dir /tmp/consul -config-dir /etc/consul.d $CONSUL_SERVERS &

# Start consul-template
/usr/local/bin/consul-template -template "/etc/hosts.consul.ctmpl:/etc/hosts.consul:systemctl reload dnsmasq" -retry 30s -max-stale 10s -wait 10s &

# Modify resolv.conf to use dnsmasq
sed -i "s/nameserver 169.254.169.254/nameserver 127.0.0.1\nnameserver 169.254.169.254/g" /etc/resolv.conf

# Start NATS Server
/usr/local/bin/gnatsd -m 8222

