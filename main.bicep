param location string = resourceGroup().location
param adminUsername string = 'azureuser'
@secure()
param adminPassword string

module vnet1Module 'modules/vnet.bicep' = {
  name: 'ExtraCredAssignment-vnet-1-Deploy'
  params: {
    vnetName: 'ExtraCredAssignment-vnet-1'
    location: location
    addressPrefix: '10.0.0.0/16'
    infraSubnetPrefix: '10.0.1.0/24'
    storageSubnetPrefix: '10.0.2.0/24'
  }
}

module vnet2Module 'modules/vnet.bicep' = {
  name: 'ExtraCredAssignment-vnet-2-Deploy'
  params: {
    vnetName: 'ExtraCredAssignment-vnet-2'
    location: location
    addressPrefix:  '10.1.0.0/16'
    infraSubnetPrefix: '10.1.1.0/24'
    storageSubnetPrefix:  '10.1.2.0/24'
  }
}

module peerModule 'modules/peerVnets.bicep' = {
  name: 'ExtraCredAssignment-peerVnets'
  dependsOn: [vnet1Module, vnet2Module]
  params: {
    vnet1Name: 'ExtraCredAssignment-vnet-1'
    vnet2Name: 'ExtraCredAssignment-vnet-2'
  }
}

module vm1Module 'modules/vm.bicep' = {
  name:'vm1Deploy'
  params: {
    vmName: 'extcredassivm1'
    location: location
    subnetId: vnet1Module.outputs.infraSubnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module vm2Module 'modules/vm.bicep' = {
  name: 'vm2Deploy'
  params: {
    vmName: 'extcredassivm2'
    location: location
    subnetId: vnet2Module.outputs.infraSubnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module storage1Module 'modules/storage.bicep' = {
  name: 'storage1Deploy'
  params: {
    storageAccountName: 'extracredassignmentstor1'
    location: location
    storageSubnetId: vnet1Module.outputs.storageSubnetId
  }
}

module storage2Module 'modules/storage.bicep' = {
  name: 'storage2Deploy'
  params: {
    storageAccountName: 'extracredassignmentstor2'
    location: location
    storageSubnetId: vnet2Module.outputs.storageSubnetId
  }
}
