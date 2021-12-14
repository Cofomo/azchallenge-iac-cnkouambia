Describe "Get-RessourceGroup" {
		Context "Ressource group <_>" -ForEach 'azchallenge-cnkouambia-dev-rg','azchallenge-cnkouambia-accept-rg','azchallenge-cnkouambia-prod-rg' {
			
			It 'Verifier quil ya 9 éléments qui existe dans le RG' {
				$rgs = Get-AzResource -ResourceGroupName $_
				$rgs.name.count | Should -not -BeLessThan 9
			}

			It 'Verifier quun object de type Microsoft.Sql/servers existe dans le RG' {
				$item = Get-AzResource -ResourceGroupName $_ -ResourceType 'Microsoft.Sql/servers'
				$item | Should -not -BeNullOrEmpty
			}
		
			It 'Verifier quun object de type Microsoft.Sql/servers/databases existe dans le RG' {
				$item = Get-AzResource -ResourceGroupName $_ -ResourceType 'Microsoft.Sql/servers/databases'
				$item | Should -not -BeNullOrEmpty
			}
		
			It 'Verifier quun object de type Microsoft.Storage/storageAccounts existe dans le RG' {
				$item = Get-AzResource -ResourceGroupName $_ -ResourceType 'Microsoft.Storage/storageAccounts'
				$item | Should -not -BeNullOrEmpty
			}
		
			It 'Verifier quun object de type Microsoft.Web/sites existe dans le RG' {
				$item = Get-AzResource -ResourceGroupName $_ -ResourceType 'Microsoft.Web/sites'
				$item | Should -not -BeNullOrEmpty
			}
		
			It 'Verifier quun object de type Microsoft.ServiceBus/namespaces existe dans le RG' {
				$item = Get-AzResource -ResourceGroupName $_ -ResourceType 'Microsoft.ServiceBus/namespaces'
				$item | Should -not -BeNullOrEmpty
			}	

			It 'Verifier quun object de type Microsoft.Web/serverFarms existe dans le RG' {
				$item = Get-AzResource -ResourceGroupName $_ -ResourceType 'Microsoft.Web/serverFarms'
				$item | Should -not -BeNullOrEmpty
			}	
			
			It 'Verifier quun App Service Plan existe dans le RG de SKU B1 dans la location Cananda Central' {
				$azserviceplan = Get-AzAppServicePlan -ResourceGroupName $_	
				$azserviceplan.Location | Should -Be "Canada Central"
				$azserviceplan.Sku.name | Should -Be "B1"
			}

			It 'Verifier que le Azure Storage Account existe et de type StorageV2 - GRS et Hot Tier' {
				$storage = Get-AzStorageAccount -ResourceGroupName $_
				$storage.kind | Should -Be "StorageV2"
				$storage.Sku.Name | Should -Be "Standard_GRS"
				$storage.location | Should -Be "CanadaCentral"
				$storage.AccessTier | Should -Be "Hot"
			}
			
			It 'Verifier quun Serveur de base de données existe dans le RG pour un compte xxxx' {
				$azsqlserver = Get-AzSqlServer -ResourceGroupName $_
				$azsqlserver.Location | Should -Be "CanadaCentral"
				$azsqlserver.SqlAdministratorLogin | Should -Be 'admin_nkc'
			}
				
			It 'Verifier quun Service Bus NameSpace existe dans le RG avec le Sku Standard et statut success ' {
				$azservicebus = Get-AzServiceBusNamespace -ResourceGroupName $_
				$azservicebus.Location | Should -Be "Canada Central"
				$azservicebus.Sku.Name | Should -Be 'Standard'
				$azservicebus.ProvisioningState | Should -Be 'Succeeded'
			}

			It 'Verifier quun Function App existe dans le RG avec un appServicePlan et en statut Running et un OS' {
				$azfunctionapp = Get-AzFunctionApp -ResourceGroupName $_	
				$azfunctionapp.Location | Should -Be "Canada Central"
				$azfunctionapp.AppServicePlan | Should -not -BeNullOrEmpty
				$azfunctionapp.Status | Should -Be 'Running'
				$azfunctionapp.OSType | Should -Be 'Linux'
			}

			It 'Verifier quune base de données existe dans le RG avec un nom donné en statut online et Sku GEN5' {
				$azsqlserver = Get-AzSqlServer -ResourceGroupName $_
				$azsqldb = Get-AzSqlDatabase -ResourceGroupName $_ -ServerName $azsqlserver.ServerName -DatabaseName 'nkcapp-db'	
				$azsqldb.Location | Should -Be "CanadaCentral"
				$azsqldb.DatabaseName | Should -Be 'nkcapp-db'
				$azsqldb.Status | Should -Be 'Online'
				$azsqldb.SkuName | Should -Be 'Gp_Gen5'
			}
		}
	}	

#Install-Module Pester -Force
#Import-Module Pester -Force
#Import-Module Pester -Passthru
#Connect-AzAccount -Subscription "fefd6011-af8c-4269-8372-c5a7183d91d3"
#Invoke-Pester -Output Detailed "D:\Iac Challenge\AzureResourceGroup1\azuredeploy.Tests.ps1"