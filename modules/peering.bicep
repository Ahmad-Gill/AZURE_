// modules/peering.bicep
// This module creates bidirectional VNet peering between two existing VNets.

param vnet1Id string
param vnet2Id string

// Extract the VNet names from their IDs.
var vnet1Name = last(split(vnet1Id, '/'))
var vnet2Name = last(split(vnet2Id, '/'))

// Declare the existing VNets using the current resource group scope.
resource vnet1 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
  scope: resourceGroup()
  name: vnet1Name
}

resource vnet2 'Microsoft.Network/virtualNetworks@2021-03-01' existing = {
  scope: resourceGroup()
  name: vnet2Name
}

// Create peering from vnet1 to vnet2.
resource peering1 'Microsoft.Network/virtualNetworks/peerings@2021-08-01' = {
  name: 'peer-${vnet1Name}-to-${vnet2Name}'
  parent: vnet1
  properties: {
    remoteVirtualNetwork: {
      id: vnet2Id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

// Create peering from vnet2 to vnet1.
resource peering2 'Microsoft.Network/virtualNetworks/peerings@2021-08-01' = {
  name: 'peer-${vnet2Name}-to-${vnet1Name}'
  parent: vnet2
  properties: {
    remoteVirtualNetwork: {
      id: vnet1Id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

output peering1Id string = peering1.id
output peering2Id string = peering2.id
