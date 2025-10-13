$TTL 86400
@   IN  SOA ns1.K57.com. root.K57.com. (
            2025101201  ; Serial (format: YYYYMMDDnn)
            3600        ; Refresh
            600         ; Retry
            604800      ; Expire
            86400       ; Minimum TTL )

@    IN  NS  ns1.K57.com.
@    IN  NS  ns2.K57.com.

ns1  IN  A   10.92.3.3
ns2  IN  A   10.92.3.4
@    IN  A   10.92.3.2