# powershell-live-talks
PowerShell Quick Start into Scripting

## [Free Powershell E-Books](https://blogs.technet.microsoft.com/pstips/2014/05/26/free-powershell-ebooks/)
## [PowerShell Scripting](https://docs.microsoft.com/en-us/powershell/scripting/powershell-scripting?view=powershell-5.1)
## [Windows Powershell](https://docs.microsoft.com/en-us/powershell/windows/get-started?view=win10-ps)

# Agenda
1. Intro
2. Short intro to PowerShell
3. Help in PowerShell
5. Objects and Pipe lines
6. First scripts
7. Modules and Functions
8. //TODO


https://kevinmarquette.github.io/2017-04-10-Powershell-exceptions-everything-you-ever-wanted-to-know/

# Chapter #1 - Intro

We need to get information about all service statuses:
```powershell
> Get-Service | select -Property DisplayName, Status | Out-File services.txt
```
Hmm, it's looks ok, but what about some summary and other statistic information:
```powershell
> Get-Service | select -Property DisplayName, Status | Export-Csv services.csv
```
Now our data formatted to csv and we could visualize it with Tableau for example.

But what if we want to make some summarizing about all in one our **file**:
```powershell
> Get-Service | group -Property Status | select -Property count, name
```
And use it like named function:
```powershell
> function Get-ServiceStatus {
    Get-Service | group -Property Status | select -Property count, name
}
> Get-ServiceStatus
```
Or save into file and import for special folder:
```powershell
> . .\Get-ServiceStatus.ps1
> Get-ServiceStatus
```
# Chapter #2 - Short intro to PowerShell

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
At powershell all returned items is objects an
```powershell
>  Get-Service -Name v* -Exclude vm*

Status   Name               DisplayName
------   ----               -----------
Running  VaultSvc           Credential Manager
Stopped  vds                Virtual Disk
Stopped  VSS                Volume Shadow Copy
Stopped  VSStandardColle... Visual Studio Standard Collector Se...
```

## Feature #5 - break current command execution

_Errors will be reviewed later on chapter #7_

If we run some large command and in meantime think that we don't need it or we make some mistake during typing command. We could break current execution wth command `Ctrl+C`(same as in CMD)
#### Example #6
```powershell
> while($true){ Get-Alias } 
#...
Ctrl+C
>
```
## Feature #6 - Checking possible actions
If we not sure if such command even exist we should try `Get-Command` for list all possible matches of searched command and ster it use `Get-Help` for detailed command description(_about it more at Chapter #3_)

#### Example #7
```powershell
> Get-Command *member

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Add-Member                                         3.1.0.0    Microsoft.PowerShell.Utility
Cmdlet          Get-Member                                         3.1.0.0    Microsoft.PowerShell.Utility

> Get-Command -CommandType Alias -Name gm

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           gm -> Get-Member

```

What about searching aliases for commands? We could use `Get-Member` or `gm` commands as well thanks for possibility of defining aliases. Also there a lot of predefined by system
#### Example #8
```powershell
> Get-Alias gm

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           gm -> Get-Member


> Get-Alias Get-Member
Get-Alias : This command cannot find a matching alias because an alias with the name 'Get-Member' does not exist.
At line:1 char:1
+ Get-Alias Get-Member
+ ~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (Get-Member:String) [Get-Alias], ItemNotFoundException
    + FullyQualifiedErrorId : ItemNotFoundException,Microsoft.PowerShell.Commands.GetAliasCommand

> Get-Alias gm  | select -Property name, DisplayName, Definition

Name DisplayName      Definition
---- -----------      ----------
gm   gm -> Get-Member Get-Member


> Get-Alias -Definition Get-Member

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Alias           gm -> Get-Member
```


# Chapter #3 - Help in PowerShell

## Feture #7 - Get-Help

The [`Get-Help`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-help?view=powershell-6) cmdlet displays information about PowerShell concepts and commands, including cmdlets, functions, CIM commands, workflows, providers, aliases and scripts.

To get help for a PowerShell command, type `Get-Help` followed by the command name, such as: 
#### Example #9
```powershell
> Get-Help Get-Process
```

Conceptual help topics in PowerShell begin with "about_", such as "about_Comparison_Operators". To see all "about_" topics, type `Get-Help about_*`. To see a particular topic, type `Get-Help about_<topic-name>`, such as `Get-Help about_Comparison_Operators`.

To get help for a PowerShell provider, type Get-Help followed by the provider name. For example, to get help for the Certificate provider, type `Get-Help Certificate`.

In addition to Get-Help, you can also type help or man, which displays one screen of text at a time, or `<cmdlet-name> -?`, which is identical to Get-Help but works only for commands.

`Get-Help` gets the help content that it displays from help files on your computer. Without the help files, `Get-Help` displays only basic information about commands. Some PowerShell modules come with help files. However, starting in Windows PowerShell 3.0, the modules that come with the Windows operating system do not include help files. To download or update the help files for a module in Windows PowerShell 3.0, use the `Update-Help` cmdlet.

You can also view the help topics for PowerShell online in the Microsoft Docs. To get the online version of a help topic, use the Online parameter, such as:
#### Example #10
```powershell
 > Get-Help Get-Process -Online
```
If you type `Get-Help` followed by the exact name of a help topic, or by a word unique to a help topic, `Get-Help` displays the topic contents. If you enter a word or word pattern that appears in several help topic titles, `Get-Help` displays a list of the matching titles. If you enter a word that does not appear in any help topic titles, `Get-Help` displays a list of topics that include that word in their contents.
#### Example #11
```powershell
> Get-Help Format-Table
> Get-Help -Name Format-Table
> Format-Table -?
```
These commands display same basic information about the `Format-Table` cmdlet.
## Feature #8 - Display basic information one page at a time
These commands display basic information about the `Format-Table` cmdlet one page at a time:
#### Example #12
```powershell
> Get-Help Format-Table | Out-Host -Paging
> help Format-Table
> man Format-Table
```
## Feature #9 - Display more information for a cmdlet
These commands display more information about the `Format-Table` cmdlet than usual:
#### Example #13
```powershell
> Get-Help Format-Table -Detailed
> Get-Help Format-Table -Full
```
The `Detailed` parameter displays the detailed view of the help topic, which includes parameter descriptions and examples.

The `Full` parameter displays the full view of the help topic, which includes parameter descriptions, examples, input and output object types, and additional notes.

**The `Detailed` and `Full` parameters are effective only for the commands whose help files are installed on the computer.**
## Feature #10 - Display selected parts of a cmdlet by using parameters
These commands display selected parts of the `Format-Table` cmdlet help
#### Example #14
```powershell
> Get-Help Format-Table -Examples
> Get-Help Format-Table -Parameter GroupBy
> Get-Help Format-Table -Parameter *
```
The `Examples` parameter displays only the `NAME`, `SYNOPSIS`, and all Examples. You can not specify an `Example` number because the `Examples` parameter is a `switch parameter`.

The `Parameter` parameter displays only the descriptions of the specified parameters. If you specify only the wildcard character (`*`), it displays the descriptions of all parameters.
## Feature #10 - search for a word in particular cmdlet help topic
This example shows how to search for a word in particular cmdlet help topic. This command searches for the word Clixml in the full version of the help topic for the Add-Member cmdled.
Because the `Get-Help` cmdlet generates a `MamlCommandHelpInfo` object, not a `string`, you have to use a cmdlet that transforms the help topic content into a `string`, such as `Out-String` or `Out-File`.
#### Example #15
```powershell
> Get-Help Add-Member -Full | Out-String -Stream | Select-String -Pattern Clixml
```
## Feature #11 - Display help for a script
We could show information also for a user scripts. Even with examples, as it will be shown in _Chapter #7_ 
#### Example #16
```powershell
> Get-Help .\Get-ServiceStatus.ps1
```

# Chapter #4 - Objects and Pipe lines

## Feature #12 - PowerShell return objects
When we call any command we mostly get as answer object with some type. When powershell try to return object, it's map it into UI table with command `Format-Table` with default properties for it.
#### Example #17 
```powershell
> Get-Help get-v*
> Get-Help get-v* | Format-Table
```
We could see what returned from previous side of pipe line with `Get-Member`(`gm`).

## Feature #13 - PowerShell Pile lines

`Get-Member` accept inputs via argument or via pipe line. In such way pipe line just move output with saving his type. 

#### Example #18
```powershell
>Get-Member -InputObject (Get-Help get-v*)
>Get-Help get-v* | Get-Member
```
As you could saw these commands returns different values but work on the same input models. This works because `Get-Member` have different options to accepting input argument. To ensure of that we should check `Get-Help`

#### Example #19
```powershell
> Get-Help Get-Member -Parameter Name

-Name <String[]>
    Specifies the names of one or more properties or methods of the object. Get-Member gets only the specified
    properties and methods.

    If you use the Name parameter with the MemberType , View , or Static parameter, Get-Member gets only the
    members that satisfy the criteria of all parameters.

    To get a static member by name, use the Static parameter with the Name parameter.

    Required?                    false
    Position?                    0
    Default value                None
    Accept pipeline input?       False
    Accept wildcard characters?  false


> Get-Help Get-Member -Parameter InputObject

-InputObject <PSObject>
    Specifies the object whose members are retrieved.

    Using the InputObject parameter is not the same as piping an object to Get-Member . The differences are as
    follows:

    - When you pipe a collection of objects to Get-Member , Get-Member gets the members of the individual
    objects in the collection, such as the properties of each string in an array of strings. - When you use
    InputObject to submit a collection of objects, Get-Member gets the members of the collection, such as the
    properties of the array in an array of strings.

    Required?                    false
    Position?                    named
    Default value                None
    Accept pipeline input?       True (ByValue)
    Accept wildcard characters?  false
```
Most important information for us is `Accept pipeline input?` and `Position?`.

As we could see default it accept `Name` and `InputObject` accept values from pipeline. In both examples we use `InputObject`, so why we have different output?

In help you could saw that `-InputObject <PSObject>` and this converts to `System.Object` but `Accept pipeline input?  True (ByValue)` have specified that this will be accepted by input value.
Also this was described at help with more details.

#### Example #20
If we would like to get all properties of `Get-Disk` command with Pipe Line we could simply filter only needed for use properties
```powershell
> Get-Disk  | Get-Member | Where-Object {$_.MemberType -eq 'Property'}
Name                 MemberType Definition
----                 ---------- ----------
AdapterSerialNumber  Property   string AdapterSerialNumber {get;}
AllocatedSize        Property   uint64 AllocatedSize {get;}
BootFromDisk         Property   bool BootFromDisk {get;}
FirmwareVersion      Property   string FirmwareVersion {get;}
FriendlyName         Property   string FriendlyName {get;}
Guid                 Property   string Guid {get;}
...
```

Get-Disk -PipelineVariable $disk  | Get-Member | Where-Object {$_.MemberType -eq 'Property'}| Select -Property Name -PipelineVariable $allNames | $disk | select -ExpandProperty $allNames

get-disk

get all parameters
get names

https://blogs.msdn.microsoft.com/santiagocanepa/2011/02/28/mandatory-parameters-in-powershell/

```powershell
> Get-Process -Name a* -PipelineVariable  Proc |  ForEach {
   Get-WmiObject  -Class Win32_Service  -ErrorAction SilentlyContinue  -Filter "ProcessID='$($Proc.Id)'" -PipelineVariable  Service |  ForEach {
       [pscustomobject]@{
            ProcessName = $Proc.Name
            PID =  $Proc.Id
            ServiceName = $Service.Name
            ServiceDisplayName = $Service.DisplayName
            StartName =  $Service.StartName
        }
   }
 }  | Format-Table  -AutoSize
```