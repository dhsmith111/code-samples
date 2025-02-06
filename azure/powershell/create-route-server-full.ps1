# The following code creates a resource group named myRouteServerRG, a virtual network named myVirtualNetwork within that 
# same resource group, a dedicated subnet named RouteServerSubnet for Azure Route Server, and a Route Server object named 
# myRouteServer. Finally, it configures the connection to its BGP peer myNVA.
# reference: https://learn.microsoft.com/en-us/training/modules/intro-to-azure-route-server/5-deploy-azure-route-server

$rg = @{
    Name = 'myRouteServerRG'
    Location = 'WestUS'
}
New-AzResourceGroup @rg
$vnet = @{
    Name = 'myVirtualNetwork'
    ResourceGroupName = 'myRouteServerRG'
    Location = 'WestUS'
    AddressPrefix = '10.0.0.0/16'    
}
$virtualNetwork = New-AzVirtualNetwork @vnet
$subnet = @{
    Name = 'RouteServerSubnet'
    VirtualNetwork = $virtualNetwork
    AddressPrefix = '10.0.0.0/24'
}
$subnetConfig = Add-AzVirtualNetworkSubnetConfig @subnet
$virtualnetwork | Set-AzVirtualNetwork
$ip = @{
    Name = 'myRouteServerIP'
    ResourceGroupName = 'myRouteServerRG'
    Location = 'WestUS'
    AllocationMethod = 'Static'
    IpAddressVersion = 'Ipv4'
    Sku = 'Standard'
}
$publicIp = New-AzPublicIpAddress @ip
$rs = @{
    RouteServerName = 'myRouteServer'
    ResourceGroupName = 'myRouteServerRG'
    Location = 'WestUS'
    HostedSubnet = $subnetConfig.Id
    PublicIP = $publicIp
}
New-AzRouteServer @rs
$peer = @{
    PeerName = 'myNVA'
    PeerIp = '192.168.0.1'
    PeerAsn = '65501'
    RouteServerName = 'myRouteServer'
    ResourceGroupName = myRouteServerRG'
}
Add-AzRouteServerPeer @peer
$routeserver = @{
    RouteServerName = 'myRouteServer'
    ResourceGroupName = 'myRouteServerRG'
} 
Get-AzRouteServer @routeserver
