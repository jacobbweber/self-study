function New-UnattendFile {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        Example of how to use this cmdlet
    .EXAMPLE
        Another example of how to use this cmdlet
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]
        $VM,

        [parameter(Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [string]
        $RootHyperVVMPath

    )

    process {
        $xml = @"
<!--*************************************************
Installation Notes
dynamically adding computer info
**************************************************-->

<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
<settings pass="windowsPE">
<component name="Microsoft-Windows-International-Core-WinPE" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<SetupUILanguage>
<UILanguage>en-US</UILanguage>
</SetupUILanguage>
<InputLocale>0c09:00000409</InputLocale>
<SystemLocale>en-US</SystemLocale>
<UILanguage>en-US</UILanguage>
<UILanguageFallback>en-US</UILanguageFallback>
<UserLocale>en-US</UserLocale>
</component>
<component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<ImageInstall>
<OSImage>
<InstallTo>
<DiskID>0</DiskID>
<PartitionID>2</PartitionID>
</InstallTo>
<InstallFrom>
<MetaData wcm:action="add">
<Key>/IMAGE/INDEX</Key>
<Value>2</Value>
</MetaData>
</InstallFrom>
</OSImage>
</ImageInstall>
<UserData>
<AcceptEula>true</AcceptEula>
<FullName>admin</FullName>
<Organization></Organization>
<ProductKey>
<Key>WC2BQ-8NRM3-FDDYY-2BFGV-KHKQY</Key>
</ProductKey>
</UserData>
<EnableFirewall>true</EnableFirewall>
<DiskConfiguration>
<Disk wcm:action="add">
<CreatePartitions>
<CreatePartition wcm:action="add">
<Order>1</Order>
<Size>350</Size>
<Type>Primary</Type>
</CreatePartition>
<CreatePartition wcm:action="add">
<Extend>true</Extend>
<Order>2</Order>
<Type>Primary</Type>
</CreatePartition>
</CreatePartitions>
<ModifyPartitions>
<ModifyPartition wcm:action="add">
<Format>NTFS</Format>
<Label>System</Label>
<Order>1</Order>
<PartitionID>1</PartitionID>
<TypeID>0x27</TypeID>
</ModifyPartition>
<ModifyPartition wcm:action="add">
<Order>2</Order>
<PartitionID>2</PartitionID>
<Letter>C</Letter>
<Label>OS</Label>
<Format>NTFS</Format>
</ModifyPartition>
</ModifyPartitions>
<DiskID>0</DiskID>
<WillWipeDisk>true</WillWipeDisk>
</Disk>
</DiskConfiguration>
</component>
</settings>
<settings pass="offlineServicing">
<component name="Microsoft-Windows-LUA-Settings" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<EnableLUA>true</EnableLUA>
</component>
</settings>
<settings pass="generalize">
<component name="Microsoft-Windows-Security-SPP" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<SkipRearm>1</SkipRearm>
</component>
</settings>
<settings pass="specialize">
<component name="Microsoft-Windows-International-Core" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<InputLocale>0409:00000409</InputLocale>
<SystemLocale>en-US</SystemLocale>
<UILanguage>en-US</UILanguage>
<UILanguageFallback>en-US</UILanguageFallback>
<UserLocale>en-US</UserLocale>
</component>
<component name="Microsoft-Windows-Security-SPP-UX" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<SkipAutoActivation>true</SkipAutoActivation>
</component>
<component name="Microsoft-Windows-SQMApi" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<CEIPEnabled>0</CEIPEnabled>
</component>
<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<ComputerName>$VM</ComputerName>
</component>
</settings>
<settings pass="oobeSystem">
<component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<AutoLogon>
<Password>
<Value>Titl@pn!</Value>
<PlainText>true</PlainText>
</Password>
<Enabled>true</Enabled>
<LogonCount>2</LogonCount>
<Username>admin</Username>
</AutoLogon>
<FirstLogonCommands>
<SynchronousCommand wcm:action="add">
<CommandLine>cmd.exe /c powershell -Command "Enable-PSRemoting"</CommandLine>
<Description>Set Execution Policy 64 Bit</Description>
<Order>1</Order>
<RequiresUserInput>true</RequiresUserInput>
</SynchronousCommand>
</FirstLogonCommands>
<OOBE>
<HideEULAPage>true</HideEULAPage>
<HideLocalAccountScreen>true</HideLocalAccountScreen>
<HideOEMRegistrationScreen>true</HideOEMRegistrationScreen>
<HideOnlineAccountScreens>true</HideOnlineAccountScreens>
<HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
<NetworkLocation>Home</NetworkLocation>
<ProtectYourPC>3</ProtectYourPC>
<SkipMachineOOBE>true</SkipMachineOOBE>
<SkipUserOOBE>true</SkipUserOOBE>
</OOBE>
<UserAccounts>
<AdministratorPassword>
<Value>Titl@pn!</Value>
<PlainText>true</PlainText>
</AdministratorPassword>
<LocalAccounts>
<LocalAccount wcm:action="add">
<Password>
<Value>Titl@pn!</Value>
<PlainText>true</PlainText>
</Password>
<Description>admin</Description>
<DisplayName>admin</DisplayName>
<Group>Administrators</Group>
<Name>admin</Name>
</LocalAccount>
</LocalAccounts>
</UserAccounts>
<RegisteredOrganization></RegisteredOrganization>
<RegisteredOwner>admin</RegisteredOwner>
<DisableAutoDaylightTimeSet>false</DisableAutoDaylightTimeSet>
<TimeZone>Eastern Standard Time</TimeZone>
</component>
</settings>
</unattend>
"@

        try {
            Write-Verbose -Message 'Creating a new unattended file'
            $xml | Add-Content -Path (Join-Path -Path $RootHyperVVMPath -ChildPath "$VM\autounattend.xml")

        } catch {
            Write-Warning ' there was an error creating a new xml file at'
            throw $_
        }

    }
}