Challenge #1

A 3-tier environment is a common setup. Use a tool of your choosing/familiarity create these resources.

Answer:

Azure 3 Tier Approach:

1) Web Tier
2) Application Tier
3) Database Tier

Resources used for this approach are Azure Virtual Machines, Load Balancer, Azure SQL Database.

I have created this approach based on my last year project setup. It is a simple and traditional method to manage the IIS based web application(Asp.Net) which installed in Windows Servers.

Have placed a public load balancer as front end to manage the load to manage the Web server virtual machines traffic and configured a internal load balancer along with application servers.

Data will be stored in Azure SQL DB since the data is relational. Have also created a high level view of this 3-Tier Architecture. 

Please note Network security groups, Keyvault (To store credentials), Public load balancer with WAF, and SQL scripts are need to add in order to complete the script.


Challenge #2

We need to write code that will query the meta data of an instance within AWS and provide a json formatted output. The choice of language and implementation is up to you.
Bonus Points
The code allows for a particular data key to be retrieved individually
Hints
·         Aws Documentation (https://docs.aws.amazon.com/)
·         Azure Documentation (https://docs.microsoft.com/en-us/azure/?product=featured)
·         Google Documentation (https://cloud.google.com/docs)

Answer:

I have manually created the VM and Initially tried to run the below powershell command inside the VM to query the details in JSON format. But I ended up with error. 

Windows PowerShell
Copyright (C) 2016 Microsoft Corporation. All rights reserved.

PS C:\Users\userone> Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri http://169.254.169.254/me
tadata/instance?api-version=2020-09-01 | ConvertTo-Json
Invoke-RestMethod : A parameter cannot be found that matches parameter name 'NoProxy'.
At line:1 char:61
+ ... RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri ht ...
+                                                          ~~~~~~~~
    + CategoryInfo          : InvalidArgument: (:) [Invoke-RestMethod], ParameterBindingException
    + FullyQualifiedErrorId : NamedParameterNotFound,Microsoft.PowerShell.Commands.InvokeRestMethodCommand

PS C:\Users\userone> $PSVersionTable.PSVersion

Major  Minor  Build  Revision
-----  -----  -----  --------
5      1      14393  5127

Please note this error occurs because of the powershell version. We need to update the powershell to Version 6 or higher in order to get the result for the above command.
We can also create a powershell script for this. Due to powershell version 5.1 few commands are not available to run.
So have tried to run the below command inside the Azure VM as we need to get the output in JSON format in simple way.

PS C:\Users\userone\Desktop> $im = invoke-restmethod -headers @{"metadata"="true"} -uri http://169.254.169.254/metadata/instance?api-version=2017-08-01 -method get
PS C:\Users\userone\Desktop> $im | convertto-json
{
    "compute":  {
                    "location":  "eastus",
                    "name":  "metavmone",
                    "offer":  "WindowsServer",
                    "osType":  "Windows",
                    "placementGroupId":  "",
                    "platformFaultDomain":  "0",
                    "platformUpdateDomain":  "0",
                    "publisher":  "MicrosoftWindowsServer",
                    "resourceGroupName":  "ODL-azureV2-676325",
                    "sku":  "2016-datacenter-gensecond",
                    "subscriptionId":  "b2aec48f-6dad-4d57-ad25-dad521fe74a4",
                    "tags":  "DeploymentId:676325;LaunchId:21565;LaunchType:ON_DEMAND_LAB;TemplateId:4283;TenantId:none",
                    "version":  "14393.5192.220612",
                    "vmId":  "d51cd032-559c-4c58-8efa-1d172428fe64",
                    "vmSize":  "Standard_D2s_v3"
                },
    "network":  {
                    "interface":  [
                                      "@{ipv4=; ipv6=; macAddress=000D3A8F4949}"
                                  ]
                }
}

I have also used another command to query the network information of the Azure Virtual Machine.

PS C:\Users\userone> Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -Uri "http://169.254.169.254/metadata/instance/network?api-version=2017-08-01" | ConvertTo-Json  -Depth 64
{
    "interface":  [
                      {
                          "ipv4":  {
                                       "ipAddress":  [
                                                         {
                                                             "privateIpAddress":  "10.0.0.7",
                                                             "publicIpAddress":  "20.115.38.15"
                                                         }
                                                     ],
                                       "subnet":  [
                                                      {
                                                          "address":  "10.0.0.0",
                                                          "prefix":  "24"
                                                      }
                                                  ]
                                   },
                          "ipv6":  {
                                       "ipAddress":  [

                                                     ]
                                   },
                          "macAddress":  "000D3A8F4949"
                      }
                  ]
}


Challenge #3

We have a nested object, we would like a function that you pass in the object and a key and get back the value. How this is implemented is up to you.
Example Inputs
object = {“a”:{“b”:{“c”:”d”}}}
key = a/b/c
object = {“x”:{“y”:{“z”:”a”}}}
key = x/y/z
value = a

I have tried to create this using python. But unable to complete this as I am running out of time.
