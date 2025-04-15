param storageAccountName string
param location string 
param storageSubnetId string

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_ZRS'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: storageSubnetId
        }
      ]
      defaultAction: 'Deny'//Only trusted subnets or IP addresses (via rules) can access it.      
    }
  }
}

output storageAccountId string = storageAccount.id
