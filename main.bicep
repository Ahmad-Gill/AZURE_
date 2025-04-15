param location string = resourceGroup().location

param vnet1Name string = 'vnet-student-1'
param vnet1AddressPrefix string = '10.0.0.0/16'
param vnet1InfraPrefix string = '10.0.1.0/24'
param vnet1StoragePrefix string = '10.0.2.0/24'

param vnet2Name string = 'vnet-student-2'
param vnet2AddressPrefix string = '10.1.0.0/16'
param vnet2InfraPrefix string = '10.1.1.0/24'
param vnet2StoragePrefix string = '10.1.2.0/24'

param vm1Name string = 'vm-student-1'
param vm2Name string = 'vm-student-2'
param adminUsername string = 'azureuser'
@secure()
param adminPassword string

param storage1Name string = 'storastudent1ahmad786'
param storage2Name string = 'storastudent2ahmad786'

module vnet1Module 'modules/vnet.bicep' = {
  name: 'vnet1Deploy'
  params: {
    vnetName: vnet1Name
    location: location
    addressPrefix: vnet1AddressPrefix
    infraSubnetPrefix: vnet1InfraPrefix
    storageSubnetPrefix: vnet1StoragePrefix
  }
}

module vnet2Module 'modules/vnet.bicep' = {
  name: 'vnet2Deploy'
  params: {
    vnetName: vnet2Name
    location: location
    addressPrefix: vnet2AddressPrefix
    infraSubnetPrefix: vnet2InfraPrefix
    storageSubnetPrefix: vnet2StoragePrefix
  }
}

module peerModule 'modules/peerVnets.bicep' = {
  name: 'peerVnets'
  dependsOn: [vnet1Module, vnet2Module]
  params: {
    vnet1Name: vnet1Name
    vnet2Name: vnet2Name
  }
}

module vm1Module 'modules/vm.bicep' = {
  name: 'vm1Deploy'
  params: {
    vmName: vm1Name
    location: location
    subnetId: vnet1Module.outputs.infraSubnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module vm2Module 'modules/vm.bicep' = {
  name: 'vm2Deploy'
  params: {
    vmName: vm2Name
    location: location
    subnetId: vnet2Module.outputs.infraSubnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module storage1Module 'modules/storage.bicep' = {
  name: 'storage1Deploy'
  params: {
    storageAccountName: storage1Name
    location: location
    storageAccountSku: 'Standard_ZRS'
    storageSubnetId: vnet1Module.outputs.storageSubnetId
  }
}

module storage2Module 'modules/storage.bicep' = {
  name: 'storage2Deploy'
  params: {
    storageAccountName: storage2Name
    location: location
    storageAccountSku: 'Standard_ZRS'
    storageSubnetId: vnet2Module.outputs.storageSubnetId
  }
}
