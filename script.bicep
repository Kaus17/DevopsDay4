// VIRTUAL NETWORK DEPLOYMENT
param vnetName string = 'vnet1'
param location string = 'eastus'
targetScope = 'resourceGroup'
param addressSpace string = '10.0.0.0/16'
param addrPrefixSub1 string = '10.0.1.0/24'
param subnet1Name string = 'Subnet1'
param subnet2Name string = 'Subnet2'

param addrPrefixSub2 string = '10.0.2.0/24'
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpace
      ]
    }
    
    subnets: [
      {
        name: subnet1Name
        properties: {
          addressPrefix: addrPrefixSub1
        }
        type: 'string'
      }
      {
        name: subnet2Name
        properties: {
          addressPrefix: addrPrefixSub2
        }
        type: 'string'
      }
    ]
  }
}
// // -----------------------------------------------------------------------------------------------
param VMName string = 'VM1'
param dnsLabelPrefix string = toLower('${VMName}-${uniqueString(resourceGroup().id, VMName)}')
param publicIpName string = '${VMName}-PubIP'
param publicIpSku string = 'Basic'
param publicIPAllocationMethod string = 'Dynamic'

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: publicIpName
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

var nicName = '${VMName}-NIC'

resource nic 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnet1Name)
          }
        }
      }
    ]
  }
  dependsOn: [
    virtualNetwork
  ]
}

param vmsize string = 'Standard_B1ms'
param License string = 'Windows_Server'
param username string = 'Kaustubh'
@minLength(12)
@secure
param password string
resource WinVM 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: VMName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmsize
    }
    licenseType: License
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
      
    }
    osProfile: {
      adminUsername: username
      adminPassword: password
      computerName: VMName
    }
    
    
    storageProfile: {
      
      osDisk: {
        createOption: 'FromImage'
        name: 'VM1-os-disk'
        managedDisk:{
          storageAccountType: 'Standard_LRS'
        }
        deleteOption:'Delete'
      }
      imageReference:{
        publisher:'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku:'2019-datacenter-gensecond'
        version:'latest'
      }
    }
  }
}

// ----------------------------------------------------------------------------------------------------



param VM2Name string = 'VM2'
param VM2dnsLabelPrefix string = toLower('${VM2Name}-${uniqueString(resourceGroup().id, VM2Name)}')
param VM2publicIpName string = '${VM2Name}-PubIP'
param VM2publicIpSku string = 'Basic'
param VM2publicIPAllocationMethod string = 'Dynamic'

resource VM2publicIp 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: VM2publicIpName
  location: location
  sku: {
    name: VM2publicIpSku
  }
  properties: {
    publicIPAllocationMethod: VM2publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: VM2dnsLabelPrefix
    }
  }
}

var VM2nicName = '${VM2Name}-NIC'

resource VM2nic 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: VM2nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig2'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: VM2publicIp.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnetName, subnet2Name)
          }
        }
      }
    ]
  }
  dependsOn: [
    virtualNetwork
  ]
}

param VM2vmsize string = 'Standard_D2s_v3'
param VM2username string = 'Kaustubh'
@minLength(12)
@secure
param VM2password string
resource LinuxVM 'Microsoft.Compute/virtualMachines@2022-11-01' = {
  name: VM2Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: VM2vmsize
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: VM2nic.id
        }
      ]
      
    }
    osProfile: {
      adminUsername: VM2username
      adminPassword: VM2password
      computerName: VM2Name
    }
    
    
    storageProfile: {
      
      osDisk: {
        createOption: 'FromImage'
        name: '${VM2Name}-os-disk'
        managedDisk:{
          storageAccountType: 'Standard_LRS'
        }
        deleteOption:'Delete'
      }
      imageReference:{
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
    }
  }
}
