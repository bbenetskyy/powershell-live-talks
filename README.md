# powersell-live-talks
PowerShell Quick Start into Scripting

# Agenda
1. Short intro to PowerShell
2. Help in PowerShell
3. Objects and Pipe lines
4. First scripts
5. Modules and Functions
6. //TODO


# Short intro to PowerShell

 ## Feature #1 - auto completion. 
 Works by `Tab` key, list one by one possible solutions.

#### Example #1
```powershell
> $PSVersionTable

Name                           Value
----                           -----
PSVersion                      5.1.16299.547
PSEdition                      Desktop
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}
BuildVersion                   10.0.16299.547
CLRVersion                     4.0.30319.42000
WSManStackVersion             ` 3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
```
#### Example #2
```powershell
> cd 'some path search with tab'
```
## Feature #2 - basic command structure.

Windows PowerShell commands have the following generic structure: `Verb-prefix_singular_noun`

The various Microsoft product teams use command prefixes a bit inconsistently, but using command prefixes is definitely considered best practice.

The singular-noun part of a PowerShell command makes it easier to guess at the correct command. For example, have you ever asked yourself whether the correct command name is `Get-Service` (singular) or `Get-Services` (plural)? You don’t need to worry anymore, because the best-practice guideline is to make all nouns singular.

#### Example #3
```powershell
> Get-Service

Status   Name               DisplayName
------   ----               -----------
Running  AdaptiveSleepSe... AdaptiveSleepService
Running  AdobeARMservice    Adobe Acrobat Update Service
Stopped  AdobeFlashPlaye... Adobe Flash Player Update Service
Stopped  AJRouter           AllJoyn Router Service
Stopped  ALG                Application Layer Gateway Service
Running  AMD External Ev... AMD External Events Utility
...
```

## Feature #3 - regex in search

You could use in search `*` to accept any count of characters or `?` to accept one only. Also other Regex elements are available but most frequently used this two.

#### Example #4
```powershell
>  Get-Service -Name v*

Status   Name               DisplayName
------   ----               -----------
Running  VaultSvc           Credential Manager
Stopped  vds                Virtual Disk
Running  vmcompute          Hyper-V Host Compute Service
Stopped  vmicguestinterface Hyper-V Guest Service Interface
Stopped  vmicheartbeat      Hyper-V Heartbeat Service
Stopped  vmickvpexchange    Hyper-V Data Exchange Service
Stopped  vmicrdv            Hyper-V Remote Desktop Virtualizati...
Stopped  vmicshutdown       Hyper-V Guest Shutdown Service
Stopped  vmictimesync       Hyper-V Time Synchronization Service
Stopped  vmicvmsession      Hyper-V PowerShell Direct Service
Stopped  vmicvss            Hyper-V Volume Shadow Copy Requestor
Running  vmms               Hyper-V Virtual Machine Management
Stopped  VSS                Volume Shadow Copy
Stopped  VSStandardColle... Visual Studio Standard Collector Se...
>  Get-Service -Name v?i*

Status   Name               DisplayName
------   ----               -----------
Stopped  vmicguestinterface Hyper-V Guest Service Interface
Stopped  vmicheartbeat      Hyper-V Heartbeat Service
Stopped  vmickvpexchange    Hyper-V Data Exchange Service
Stopped  vmicrdv            Hyper-V Remote Desktop Virtualizati...
Stopped  vmicshutdown       Hyper-V Guest Shutdown Service
Stopped  vmictimesync       Hyper-V Time Synchronization Service
Stopped  vmicvmsession      Hyper-V PowerShell Direct Service
Stopped  vmicvss            Hyper-V Volume Shadow Copy Requestor
```

## Feature #4 - properties and methods

#### Example #5
At powershell all returned items is objects and 
```powershell
>  Get-Service -Name v* -Exclude vm*

Status   Name               DisplayName
------   ----               -----------
Running  VaultSvc           Credential Manager
Stopped  vds                Virtual Disk
Stopped  VSS                Volume Shadow Copy
Stopped  VSStandardColle... Visual Studio Standard Collector Se...
```

# Help in PowerShell