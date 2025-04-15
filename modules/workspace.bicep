param name string
param location string

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: name
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

output id string = logAnalytics.id
