check_consul_services_in_critical_state
==========

This Nagios plugin is basically a fork of this [check_json plugin](https://github.com/bbuchalter/check_json), dumbed down to do only one task: check if [Consul discovery server](https://consul.io) has any services in 'critical' state.

Retrieves list of services in 'critical' state from Consul.
Returns OK if the list is empty.

```--help```      shows this message
```--version```   shows version information

Usage: ```$0 -U http://consul-host:port```
where
``-U`` is Consul URL (http or https)
``-t`` is timeout in seconds to wait for the URL to load (default 60)