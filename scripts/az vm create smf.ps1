$keyvaultName = "airheadsbcKeys"
$resourceGroup = "airheadsbc"
$certName = "airheadsbccerta43be45e-6dcf-4b8e-b9a6-9a5f8299357b"
$subs = "Pay-As-You-Go"
$certURL = (Get-AzureKeyVaultSecret -VaultName $keyvaultName -Name $certName).id
$vm_secret = (az vm secret format --secrets $certURL --keyvault $keyvaultName --resource-group $resourceGroup --subscription $subs)

$keyvaultName = "airheadsbcKeys"
Set-AzureRmKeyVaultAccessPolicy -VaultName $keyvaultName -EnabledForDeployment
$admin = "j007am"
$keyFile = cat ~/.ssh/id_rsa.pub
$resourceGroup = "airheadsbc"
$certName = "airheadsbccerta43be45e-6dcf-4b8e-b9a6-9a5f8299357b"
$VMName = "VMInstance"
$location = "Canada Central"
$bootDiagStorage =  "airheadsbcdiag"
$customData = "cloud-init-web-server.txt"
$subs = "Pay-As-You-Go"
$nics = "instancevm231"
$image = "Bitnami:simplemachinesforum:2-0:2.0.1811302007"
$certURL = (Get-AzureKeyVaultSecret -VaultName $keyvaultName -Name $certName).id
$vm_secret = (az vm secret format --secrets $certURL --keyvault $keyvaultName --resource-group $resourceGroup --subscription $subs)
az vm create --name $VMName --resource-group $resourceGroup --admin-username $admin --authentication-type ssh --boot-diagnostics-storage $bootDiagStorage --custom-data $customData --image $image --location $location --nics $nics --ssh-key-value $keyFile --subscription $subs
--secrets $vm_secret
$vm=Get-AzureRmVM -ResourceGroupName $resourceGroup -Name $VMName
$vaultId=(Get-AzureRmKeyVault -ResourceGroupName $resourceGroup -VaultName $keyVaultName).ResourceId
$vm=Add-AzureRmVMSecret -VM $vm -SourceVaultId $vaultId -CertificateUrl $certURL
az vm open-port --resource-group $resourceGroup --name $VMName --port 443
Update-AzureRmVM -ResourceGroupName $resourceGroup -VM $vm
