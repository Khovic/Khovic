# Border Gateway Protocol (BGP) 101
A protocol of sharing network paths, an AS (Autonomous System) is a router which has an ASN (AS number) assigned to it and is controlled by one entity- a network in BGP. 
An AS will advertise all the shortest paths it knows to all its peers, the AS prepends its own ASN to the path. This creates an src to dst path which BGP routers (aka peers) can learn and propagate.
By default, BGP exchanges the shortest ASPATH (Autonomous System Path),
AS Path Prepending can be used to artificially make a ASPATH appear longer and reduce its preference over other ASPaths.
Example of a Route Table:

DESTINATION    NEXT HOP      ASPATH
10.16.0.0/16    0.0.0.0          i
10.17.0.0/16    10.17.0.1     201,i
10.18.0.0/16    10.17.0.1     201, 202, i

In this case, 0.0.0.0 means the network is locally connects. 
i means it learnt of the network by being directly connected to it.

