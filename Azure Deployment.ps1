# Variable Declaration
$rgName='prasanrg'
$location='eastus'

#Resource Group
New-AzResourceGroup -Name $rgName -Location $location

#Virtual Network and Public IP Address
$subnet = New-AzVirtualNetworkSubnetConfig -name 'subnetone' -AddressPrefix 192.168.1.0/24
$vnet = New-AzVirtualNetwork -ResourceGroupName $rgName -Name 'Vnetone' `
  -AddressPrefix 192.168.0.0/16 -Location $location -Subnet $subnet
$publicIp = New-AzPublicIpAddress -ResourceGroupName $rgName -Name 'PublicIPone' `
  -Location $location -AllocationMethod Dynamic

#Front-End config for Web Tier and Back-End Address Pool
$feip = New-AzLoadBalancerFrontendIpConfig -Name 'Frontendone' -PublicIpAddress $publicIp
$bepool = New-AzLoadBalancerBackendAddressPoolConfig -Name 'BackEndPoolone'

#Load Balancer Probe and Rule for Port 80
$probe = New-AzLoadBalancerProbeConfig -Name 'HealthProbeone' -Protocol Http -Port 80 `
  -RequestPath / -IntervalInSeconds 360 -ProbeCount 5
$rule = New-AzLoadBalancerRuleConfig -Name 'LoadBalancerRuleforWeb' -Protocol Tcp `
  -Probe $probe -FrontendPort 80 -BackendPort 80 `
  -FrontendIpConfiguration $feip -BackendAddressPool $bePool

#NAT Rules for RDP
$natrule1 = New-AzLoadBalancerInboundNatRuleConfig -Name 'LBConfigone' -FrontendIpConfiguration $feip `
  -Protocol tcp -FrontendPort 501 -BackendPort 3389

$natrule2 = New-AzLoadBalancerInboundNatRuleConfig -Name 'LBConfigtwo' -FrontendIpConfiguration $feip `
  -Protocol tcp -FrontendPort 502 -BackendPort 3389

$natrule3 = New-AzLoadBalancerInboundNatRuleConfig -Name 'LBConfigthree' -FrontendIpConfiguration $feip `
  -Protocol tcp -FrontendPort 503 -BackendPort 3389

# Load Balancer
$lb = New-AzLoadBalancer -ResourceGroupName $rgName -Name 'LBOne' -Location $location `
  -FrontendIpConfiguration $feip -BackendAddressPool $bepool `
  -Probe $probe -LoadBalancingRule $rule -InboundNatRule $natrule1,$natrule2,$natrule3

# Virtual Machine Configuration for Web Tier server one
$vmConfig = New-AzVMConfig -VMName 'webserverone' -VMSize Standard_DS2 | `
  Set-AzVMOperatingSystem -Windows -ComputerName 'webserverone' -Credential $cred | `
  Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer `
  -Skus 2016-Datacenter -Version latest | Add-AzVMNetworkInterface -Id $nicVM1.Id

# Virtual Machines for Web Tier server one
$webserverone = New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig

# Virtual Machine Configuration for Web Tier server two
$vmConfig = New-AzVMConfig -VMName 'webservertwo' -VMSize Standard_DS2 | `
  Set-AzVMOperatingSystem -Windows -ComputerName 'webservertwo' -Credential $cred | `
  Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer `
  -Skus 2016-Datacenter -Version latest | Add-AzVMNetworkInterface -Id $nicVM1.Id

  # Virtual Machines for Web Tier server two
$webservertwo = New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig


# Virtual Machine Configuration for App Tier server one
$vmConfig = New-AzVMConfig -VMName 'appserverone' -VMSize Standard_D8_v3 | `
  Set-AzVMOperatingSystem -Windows -ComputerName 'appserverone' -Credential $cred | `
  Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer `
  -Skus 2016-Datacenter -Version latest | Add-AzVMNetworkInterface -Id $nicVM1.Id

# Virtual Machines for App Tier server one
$appserverone = New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig

# Virtual Machine Configuration for App Tier server two
$vmConfig = New-AzVMConfig -VMName 'appservertwo' -VMSize Standard_D8_v3 | `
  Set-AzVMOperatingSystem -Windows -ComputerName 'appservertwo' -Credential $cred | `
  Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer `
  -Skus 2016-Datacenter -Version latest | Add-AzVMNetworkInterface -Id $nicVM1.Id

# Virtual Machines for App Tier server two
$appservertwo = New-AzVM -ResourceGroupName $rgName -Location $location -VM $vmConfig





 


