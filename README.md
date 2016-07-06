# OpenRelayHunter

Not-So-Quick and dirty script to scan a selection of IP ranges for Open SMTP or DNS resolvers

Prerequisite: 'prips' utility (aptitude install prips)
Prerequisite: 'mail' utility (aptitude install mutt)

Authors: Johnathan Williamson (@SuitedUpGeek) / Shane Mc Cormack (@ShaneMcC)

```
OpenRelay Hunter.

Usage: ./hunter.sh [flags] <IP> [IP [IP] ... [IP]]

Accepted flags:

 -h, --help                      Show this help.
 -d, --dns                       Check for Open DNS Resolver.
 -s, --smtp                      Check for Open Relay.
 -t <addr>, --to <addr>          Email address to send report to.
 -f <addr>, --from <addr>        Email address to send report from.

Anything param passed that isn't a flag is considered an address range to scan

Address ranges must be a CIDR range of /31 or larger, or individual IPs (without '/32')
```
