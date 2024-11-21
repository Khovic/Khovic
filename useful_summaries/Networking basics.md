### Lesson 1 Network devices ###
# Network
    A grouping of hosts which require similar connectivity
# Hosts
    Anything that sends or receives data over the network
# Hub
    Multiport repeater
# Switches
    Facilitate communication within a network
    Switching: the process of moving data within a network
# Router
    Facilitate communication between networks.
    Routing: the process of moving data between networks
    The router receives an IP address in every network it is connected to,
    Its used for for hosts in a network to access hosts outside the network - the Default Gateway.

# Routing table
    All the networks that the router knows about




### Lesson 2 OSI Model ###
# Layer 1: Physical 
    Any device or technology that allows the transport of bits, for example:
    Cables, Wifi, Repeaters, Hubs.

# Layer 2: Hop to hop delivery
    Devices and technologies that interact with layer 1 directly, are considered to be Layer 2.
    They use MAC addressing scheme, for example:
    Switches, Network Interfaces, or any device with a MAC address.

# Layer 3: End to end delivery
    Devices and technologies that use IP addressing scheme, they facilicate the transport of 
    data between networks (and over various layer 2 devices) to allow 2 hosts to communicate.
    Example: Routers or any devices with an IP address.

# Layer 4: Transport layer (Service to Service)
    The layer that allows to distinguish data streams, uses ports as an addressing scheme.
    Server listens on pre-defined ports for incoming requests.
    Clients use random ports for outgoing requests.
    TCP/UDP ports range in 0-65535.

# Layer 5-7: Session, Presentation and Application Layers
    Can be considered as one layer managed by the end Application that handles the final data recieved or transported by the application.

# Summary
    Devices on a layer interact only with the data relevant to its layer and uses its addressing scheme and protocols.




### Lesson 3 Internet communication between hosts ###
# Subnet mask
    defines the size as a network, for example 255.255.255.0 == /24.

# ARP request
    A request a host sends in order to get the MAC address of a host using its IP address.
    After recieving it is stored in a hosts ARP Cache.

# Default Gateway
    The IP address the host uses for communication with hosts on different network, usually it
    is the IP address of the network's router.

# Communication between hosts on same / different networks
    When sending Data from host A to host be the first step is determining if the Host B is on the 
    same network or on a foreign network (using the Subnet Mask)
    1. Same: Host gets the MAC address of Host B (using ARP request) and sends the data directly over Layer 2.
    2. Foreign (Different): Host A wil try to resolve the MAC address of the default gateway and send the data to it (presumebly router) for further routing.




### Lesson 4 Switches ###
# Switches are Layer 2 Devices, Layer 3 information (such as IP addresses) is ignored.

# MAC Address Table
    switches use and maintain a MAC Address Table. 

# The 3 Actions of switches
    Learn: Update MAC Address Table with mapping of switch port to Source MAC.
           Happens when a network device tries to send a frame through the switch,
           since that frame contains the SRC MAC address, the switch will map the port
           to the SRC MAC address and save it in the MAC Address Table

    Flood: Duplicate and send frame out all switch ports (except the receiving port).
           Useful when the destination MAC address is not present in the MAC Address Table. 
           The owner of the MAC address will receive the frame, and often will respond back trough
           the switch, at this point the switch will learn its port and update the MAC Address table.

    Forward: Use MAC Address Table to deliver Frame to apporpriate switch port.

    Unicast frame: destination MAC address is another host,
                   Switch will only flood if destination MAC is not in MAC address table.
    Broadcast frame: destination MAC address is ffff.ffff.ffff
                     Broadcast frames are always flooded

        * switches will only send Broadcasts if traffic is going TO or FROM the switch (and not just passing through the switch).

    VLAN: you can divide a physical switch to multiple "mini switches" with each having its own ports, and acting independently.


### Lesson 5 Routers ###
# Terminology:
    node: any device that implements IP.
    router: a node that forwards IP packets that are not explicitly addressed to itself.
    host: any node that is not a router.

    Routers are connected to a network and have IP and MAC address on each interface (just like hosts).
    Routers forward packets that aren't destined to themselves.
    Routers also have ARP tables.

# Routing Table
    Routing table: Routers maintain a map of all the networks they know about.
    Routing table can be populated in these 3 ways:
        Directly Connected: Routes for networks which are attached.
        Static Routes: Routes manually provided by an administrator.
        Dynamic Routes: Routes learned automatically from other routers, using dyamic routing protocols.
    
# Scalability 
    Routers are typically deployed in a hierarchy, this allows easier scalability and more consistent connectivity.
    aswell it allows a reduced number of entries in the router's Routing Table.
    The default route (0.0.0.0/0) means that any frame destined to any IP address will use that route (unless a more specific route is provided in the routing table).


### Lesson 6 Protocols ###
# The 4 Things every host needs for internet connectivity:
    IP Address: for itself
    Subnent Mask: to determine the size of the host's network.
    Default Gateway: to access hosts outside the host's network.
    DNS Address: for resolving Domain Names. 

    Usually these 4 things are provided automatically by the DHCP (Dynamic Host Configuration Protocol) Server.


### How Data moves through the Internet
    Data moves through the internet based upon these 3 tables:
        MAC Address Table: mapping of switchport to MAC address.
        ARP Table / Cache: Mapping of IP address to MAC address.
        Routing Table: Mapping of IP network to Interface or next Router.