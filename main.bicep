param location string = resourceGroup().location
param adminUsername string = 'azureuser'
@secure()
param adminPassword string
module vnet1Module 'modules/vnet.bicep' = {
  name: 'ExtraCredAssignmentnet1Deploy'
  params: {
    vnetName: 'Extra-Cred-Assignment-vnet-1'
    location: location
    addressPrefix: '10.0.0.0/16'
    infraSubnetPrefix: '10.0.1.0/24'
    storageSubnetPrefix: '10.0.2.0/24'
  }
}

module vnet2Module 'modules/vnet.bicep' = {
  name: 'Extra-Cred-Assignment-vnet-2-Deploy'
  params: {
    vnetName: 'Extra-Cred-Assignment-vnet-2'
    location: location
    addressPrefix:  '10.1.0.0/16'
    infraSubnetPrefix: '10.1.1.0/24'
    storageSubnetPrefix:  '10.1.2.0/24'
  }
}

module peerModule 'modules/peerVnets.bicep' = {
  name: 'Extra-Cred-Assignment-peerVnets'
  dependsOn: [vnet1Module, vnet2Module]
  params: {
    vnet1Name: 'Extra-Cred-Assignment-vnet-1'
    vnet2Name: 'Extra-Cred-Assignment-vnet-2'
  }
}

module vm1Module 'modules/vm.bicep' = {
  name: 'Extra-Cred-Assignment-vm-1-Deploy'
  params: {
    vmName:  'Extra-Cred-Assignment-vm-1'
    location: location
    subnetId: vnet1Module.outputs.infraSubnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module vm2Module 'modules/vm.bicep' = {
  name: 'vm2Deploy'
  params: {
    vmName: 'Extra-Cred-Assignment-vm-2'
    location: location
    subnetId: vnet2Module.outputs.infraSubnetId
    adminUsername: adminUsername
    adminPassword: adminPassword
  }
}

module storage1Module 'modules/storage.bicep' = {
  name: 'storage1Deploy'
  params: {
    storageAccountName: 'Extra-Cred-Assignment-storastudent1Mahmad011'
    location: location
    storageSubnetId: vnet1Module.outputs.storageSubnetId
  }
}

module storage2Module 'modules/storage.bicep' = {
  name: 'storage2Deploy'
  params: {
    storageAccountName: 'Extra-Cred-Assignment-storastudent2Mahmad011'
    location: location
    storageSubnetId: vnet2Module.outputs.storageSubnetId
  }
}
