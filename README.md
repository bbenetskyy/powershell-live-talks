# powershell-live-talks
PowerShell Quick Start into Scripting

## [Free Powershell E-Books](https://blogs.technet.microsoft.com/pstips/2014/05/26/free-powershell-ebooks/)
## [PowerShell Scripting](https://docs.microsoft.com/en-us/powershell/scripting/powershell-scripting?view=powershell-5.1)
## [Windows Powershell](https://docs.microsoft.com/en-us/powershell/windows/get-started?view=win10-ps)

https://kevinmarquette.github.io/2017-04-10-Powershell-exceptions-everything-you-ever-wanted-to-know/

https://blogs.msdn.microsoft.com/santiagocanepa/2011/02/28/mandatory-parameters-in-powershell/

# Agenda
1. Intro
2. Short intro to PowerShell
3. Help in PowerShell
5. Objects and Pipe lines
6. First scripts
7. Modules and Functions
8. Killer Features
9. Real World Examples

```powershell
ii .
show-object  $x
new-object -type FileResource
[FileResource]::new()
[string]::new
[ValidateSet('2','3')]
get-w*e*e
about_PSModule.help.txt
$a,$b,$c = get-* # $a == 1; $b == 2; $c == all other
$c.prop == call prop in each and list a result list
gps [a-r]*[g-p]* | stop-process -WhatIf
stop-process -name lsass
import-module -name psscript*
get-command -module psscri*
invoke-scriptanalyzer -path test.ps1
New-Module 
[switch]test == -test
ALWAYS NON PLURAL NAMES
```

[Jeff Hicks](https://github.com/jdhitsolutions)

https://docs.microsoft.com/en-us/powershell/dsc/pullserversmb

1. [ Description. ](#desc)
2. [ Usage tips. ](#usage)

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

 ## Feature # - auto completion. 
 Works by `Tab` key, list one by one possible solutions.

#### Example #
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
#### Example #
```powershell
> cd 'some path search with tab'
```
## Feature # - basic command structure.

> Windows PowerShell commands have the following generic structure: `Verb-prefix_singular_noun`

The various Microsoft product teams use command prefixes a bit inconsistently, but using command prefixes is definitely considered best practice.

The singular-noun part of a PowerShell command makes it easier to guess at the correct command. For example, have you ever asked yourself whether the correct command name is `Get-Service` (singular) or `Get-Services` (plural)? You don’t need to worry anymore, because the best-practice guideline is to make all nouns singular.

#### Example #
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

## Feature # - regex in search

You could use in search `*` to accept any count of characters or `?` to accept one only. Also other Regex elements are available but most frequently used this two.

#### Example #
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

## Feature # - properties and methods

#### Example #
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

## Feature # - break current command execution

> Errors will be reviewed later on chapter #7

If we run some large command and in meantime think that we don't need it or we make some mistake during typing command. We could break current execution wth command `Ctrl+C`(same as in CMD)
#### Example #
```powershell
> while($true){ Get-Alias } 
#...
Ctrl+C
>
```
## Feature # - Checking possible actions
If we not sure if such command even exist we should try `Get-Command` for list all possible matches of searched command and ster it use `Get-Help` for detailed command description(_about it more at Chapter #3_)

#### Example #
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
#### Example #
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
#### Example #
```powershell
> Get-Help Get-Process
```

Conceptual help topics in PowerShell begin with "about_", such as "about_Comparison_Operators". To see all "about_" topics, type `Get-Help about_*`. To see a particular topic, type `Get-Help about_<topic-name>`, such as `Get-Help about_Comparison_Operators`.

To get help for a PowerShell provider, type Get-Help followed by the provider name. For example, to get help for the Certificate provider, type `Get-Help Certificate`.

In addition to Get-Help, you can also type help or man, which displays one screen of text at a time, or `<cmdlet-name> -?`, which is identical to Get-Help but works only for commands.

`Get-Help` gets the help content that it displays from help files on your computer. Without the help files, `Get-Help` displays only basic information about commands. Some PowerShell modules come with help files. However, starting in Windows PowerShell 3.0, the modules that come with the Windows operating system do not include help files. To download or update the help files for a module in Windows PowerShell 3.0, use the `Update-Help` cmdlet.

You can also view the help topics for PowerShell online in the Microsoft Docs. To get the online version of a help topic, use the Online parameter, such as:
#### Example #
```powershell
 > Get-Help Get-Process -Online
```
If you type `Get-Help` followed by the exact name of a help topic, or by a word unique to a help topic, `Get-Help` displays the topic contents. If you enter a word or word pattern that appears in several help topic titles, `Get-Help` displays a list of the matching titles. If you enter a word that does not appear in any help topic titles, `Get-Help` displays a list of topics that include that word in their contents.
#### Example #
```powershell
> Get-Help Format-Table
> Get-Help -Name Format-Table
> Format-Table -?
```
These commands display same basic information about the `Format-Table` cmdlet.
## Feature # - Display basic information one page at a time
These commands display basic information about the `Format-Table` cmdlet one page at a time:
#### Example #
```powershell
> Get-Help Format-Table | Out-Host -Paging
> help Format-Table
> man Format-Table
```
## Feature # - Display more information for a cmdlet
These commands display more information about the `Format-Table` cmdlet than usual:
#### Example #
```powershell
> Get-Help Format-Table -Detailed
> Get-Help Format-Table -Full
```
The `Detailed` parameter displays the detailed view of the help topic, which includes parameter descriptions and examples.

The `Full` parameter displays the full view of the help topic, which includes parameter descriptions, examples, input and output object types, and additional notes.

**The `Detailed` and `Full` parameters are effective only for the commands whose help files are installed on the computer.**
## Feature # - Display selected parts of a cmdlet by using parameters
These commands display selected parts of the `Format-Table` cmdlet help
#### Example #
```powershell
> Get-Help Format-Table -Examples
> Get-Help Format-Table -Parameter GroupBy
> Get-Help Format-Table -Parameter *
```
The `Examples` parameter displays only the `NAME`, `SYNOPSIS`, and all Examples. You can not specify an `Example` number because the `Examples` parameter is a `switch parameter`.

The `Parameter` parameter displays only the descriptions of the specified parameters. If you specify only the wildcard character (`*`), it displays the descriptions of all parameters.
## Feature # - search for a word in particular cmdlet help topic
This example shows how to search for a word in particular cmdlet help topic. This command searches for the word Clixml in the full version of the help topic for the Add-Member cmdled.
Because the `Get-Help` cmdlet generates a `MamlCommandHelpInfo` object, not a `string`, you have to use a cmdlet that transforms the help topic content into a `string`, such as `Out-String` or `Out-File`.
#### Example #
```powershell
> Get-Help Add-Member -Full | Out-String -Stream | Select-String -Pattern Clixml
```
## Feature # - Display help for a script
We could show information also for a user scripts. Even with examples, as it will be shown in _Chapter #7_ 
#### Example #
```powershell
> Get-Help .\Get-ServiceStatus.ps1
```

# Chapter #4 - Objects and Pipe lines

## Feature # - PowerShell return objects
When we call any command we mostly get as answer object with some type. When powershell try to return object, it's map it into UI table with command `Format-Table` with default properties for it.
#### Example #
```powershell
> Get-Help get-v*
> Get-Help get-v* | Format-Table
```
We could see what returned from previous side of pipe line with `Get-Member`(`gm`).

## Feature # - PowerShell Pile lines

There are plenty of Linux shells with a pipeline, allowing you to send the text that one command outputs as input to the next command in the pipeline. PowerShell takes this to the next level by allowing you to take the objects that one cmdlet outputs and pass them as input to the next cmdlet in the pipeline.

`Get-Member` accept inputs via argument or via pipe line. In such way pipe line just move output with saving his type. 

#### Example #
```powershell
>Get-Member -InputObject (Get-Help get-v*)
>Get-Help get-v* | Get-Member
```
As you could saw these commands returns different values but work on the same input models. This works because `Get-Member` have different options to accepting input argument. To ensure of that we should check `Get-Help`

#### Example #
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

If we would like to get all properties of `Get-Disk` command with Pipe Line we could simply filter only needed for use properties
#### Example #
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
And if we want to run with it, then we should run:
#### Example #
```powershell
> Get-Disk |   select -Property *
```

## Feature # - Default Formatting
When I first started out with PowerShell, I thought everything was magic, but the truth is it just takes a little bit of time to understand what is going on underneath the hood. The same is true for the PowerShell formatting system. In fact, if you run the Get-Service cmdlet, the output generated only shows you 3 properties: `Status`, `Name` and `DisplayName`.


But if you pipe `Get-Service` to `Get-Member`, you see that the `ServiceController` objects have a lot more than just these three properties, so what is going on?


The answer lies within a hidden file that defines how most of the built-in cmdlets display their output. To get an understanding, type the following into the shell and hit enter.
#### Example #
```powershell
> Get-Service -Name amd*
Status   Name               DisplayName
------   ----               -----------
Running  AMD External Ev... AMD External Events Utility

> Get-Service -Name amd* | Get-Member

   TypeName: System.ServiceProcess.ServiceController

Name                      MemberType    Definition
----                      ----------    ----------
Name                      AliasProperty Name = ServiceName
RequiredServices          AliasProperty RequiredServices = ServicesDependedOn
Disposed                  Event         System.EventHandler Disposed(System.Object, System.EventArgs)
Close                     Method        void Close()
Continue                  Method        void Continue()
CreateObjRef              Method        System.Runtime.Remoting.ObjRef CreateObjRef(type requestedType)
...
ToString                  ScriptMethod  System.Object ToString();

> code-insiders C:\Windows\System32\WindowsPowerShell\v1.0\DotNetTypes.format.ps1xml
```
Suddenly, you can see that underneath the hood PowerShell is formatting any objects in the Pipeline that are of the ServiceController type and creating a table with three columns: Status, Name, and DisplayName. But what if the type you are dealing with doesn’t have an entry in that file, or any other format file for that matter? Well then, it’s quite simple actually. If the object coming out of the pipeline has 5 or more properties:
> PowerShell displays all of the object’s properties in a list; if it has less than 5 properties, it displays them in a table.

## Feature # - Works with object

Let's select one of services. Best Windows service for test is `bits` - Background Intelligent Transfer Service. Let's get that service to variable, check status, run some functions from `Get-Member`.

#### Example #
```powershell
> $Service=Get-Service -Name bits
> $Service | GM

   TypeName: System.ServiceProcess.ServiceController

Name                      MemberType    Definition
----                      ----------    ----------
Name                      AliasProperty Name = ServiceName
Start                     Method        void Start(), void Start(string[] args)
Stop                      Method        void Stop()
Status                    Property      System.ServiceProcess.ServiceControllerStatus Status {get;}

> $Service.Status
Stopped
> $service.Start() #$service.Stop()
> $Service.Status
Stopped
> $Service=Get-Service -Name bits
> $Service.Status
Running
> $Msg="Service Name is $($service.name.ToUpper())"
> $msg
Service Name is BITS
```
Also we could work in quite same way with array of values in variable. More details will be with _Feature Variable Types_.
#### Example #
```powershell
> $Services=Get-Service
> $services[0]

Status   Name               DisplayName
------   ----               -----------
Stopped  AdobeFlashPlaye... Adobe Flash Player Update Service


> $services[0].Status
Stopped
> $Services[-1].Name
YandexBrowserService
> "Service Name is $($services[4].DisplayName)"
Service Name is Application Information
> "Service Name is $($services[4].name.ToUpper())"
Service Name is APPINFO
```

## Feature # - Formatting Your Data

If you are not happy with the default formatting of an object or type, you can roll your own formatting. There are three cmdlets you need to know to do this:
* `Format-List`
* `Format-Table`
* `Format-Wide`

`Format-Wide` simply takes a collection of objects and displays a single property of each object. By default, it will look for a name property; if your objects don’t contain a name property, it will use the first property of the object once the properties have been sorted alphabetically.
#### Example #
```powershell
> Get-Service -Name a*  | Format-Wide


AdaptiveSleepService              AdobeARMservice
AdobeFlashPlayerUpdateSvc         AJRouter
ALG                               AMD External Events Utility
AppIDSvc                          Appinfo
AppMgmt                           AppReadiness
AppVClient                        AppXSvc
aspnet_state                      AssignedAccessManagerSvc
AudioEndpointBuilder              Audiosrv
AxInstSV
```
As you can see, it also defaults to two columns, although you can specify both which property you want to use, as well as how many columns you want to be displayed.
#### Example #
```powershell
> Get-Service -Name a*  | Format-Wide  -Property DisplayName -Column 6


Adaptive... Adobe A... Adobe F... AllJoyn... Applica... AMD Ext...
Applicat... Applica... Applica... App Rea... Microso... AppX De...
ASP.NET ... Assigne... Windows... Windows... ActiveX...
```
If something is formatted as a table by default, you can always switch it to list view by using the `Format-List` cmdlet. Let’s take a look at the output of the `Get-Process` cmdlet.
#### Example #
```powershell
> gps

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessN
                                                          ame
-------  ------    -----      -----     ------     --  -- --------
    143       8     1916       6652             14024   0 Adapt...
    644      37    28636      32528      14.34   4716   1 Appli...
    149       9     1624       6296              3640   0 armsvc
    230      12     2800      10196              6160   1 atieclxx
    128       8     1632       4948              2084   0 atiesrxx
    252      15    12564      16932      95.47   6352   0 audiodg
    181       9     7244       6712       0.16   1996   1 bash
    182       9     7184       6712       0.14  16564   1 bash
   1034     134   102124      93360      86.73  18236   1 Brady...
   1205     173   155864     132668   3,843.92  16040   1 Brady...
```
This tabular view actually suits this kind of information very well, but let’s pretend we want to view it in list form. All we really have to do is pipe it to `Format-List`.
#### Example #
```powershell
> Get-Process | Format-List

Id      : 14024
Handles : 143
CPU     :
SI      : 0
Name    : AdaptiveSleepService

Id      : 4716
Handles : 644
CPU     : 14.34375
SI      : 1
Name    : ApplicationFrameHost

Id      : 3640
Handles : 149
CPU     :
SI      : 0
Name    : armsvc
```
As you can see there are only four items displayed in the list by default. To view all the properties of the object, you can use a wildcard character.
#### Example #
```powershell
> Get-Process | Format-List –Property *

Name                       : AdaptiveSleepService
Id                         : 14024
PriorityClass              :
FileVersion                :
HandleCount                : 143
WorkingSet                 : 6537216
PagedMemorySize            : 1961984
PrivateMemorySize          : 1961984
VirtualMemorySize          : 103632896
TotalProcessorTime         :
SI                         : 0
Handles                    : 143
VM                         : 103632896
WS                         : 6537216
PM                         : 1961984
NPM                        : 7832
```
Alternatively, you can select just the properties you want.
#### Example #
```powershell
> Get-Process | Format-List –Property name,id

Name : AdaptiveSleepService
Id   : 14024

Name : ApplicationFrameHost
Id   : 4716

Name : armsvc
Id   : 3640

Name : atieclxx
Id   : 6160

Name : atiesrxx
Id   : 2084
```
`Format-Table`, on the other hand, takes data and turns it into a table. Since our data from `Get-Process` is already in the form of a table, we can use it to easily choose properties we want displayed in the table. I used the AutoSize parameter to make all the data fit onto a single screen.
#### Example #
```powershell
> Get-Process | Format-Table name,id –AutoSize

Name                                                 Id
----                                                 --
AdaptiveSleepService                              14024
ApplicationFrameHost                               4716
armsvc                                             3640
atieclxx                                           6160
atiesrxx                                           2084
audiodg                                            6352
bash                                               1996
bash                                              16564
Brady.Tolling.DataServiceHost                     18236
Brady.Tolling.ExplorerHost                        16040
```
## Feature # - Filtering and Comparing
One of the best things about using an object-based pipeline is that you can filter objects out of the pipeline at any stage using the `Where-Object` cmdlet.
#### Example #
```powershell
> Get-Service | Where-Object {$_.Status -eq “Running”}

Status   Name               DisplayName
------   ----               -----------
Running  AdaptiveSleepSe... AdaptiveSleepService
Running  AdobeARMservice    Adobe Acrobat Update Service
Running  AMD External Ev... AMD External Events Utility
Running  Appinfo            Application Information
Running  AudioEndpointBu... Windows Audio Endpoint Builder
Running  Audiosrv           Windows Audio
Running  BDESVC             BitLocker Drive Encryption Service
Running  BFE                Base Filtering Engine
Running  BITS               Background Intelligent Transfer Ser...
Running  BrokerInfrastru... Background Tasks Infrastructure Ser...
```
Using where object is actually very simple.

`$_` represents the current pipeline object, from which you can choose a property that you want to filter on. Here, were are only keeping objects where the `Status` property equals `Running`. There are a few comparison operators you can use in the filtering script block:
* `eq` (Equal To)
* `neq` (Not Equal To)
* `gt` (Greater Than)
* `ge` (Greater Than or Equal To)
* `lt` (Less Than)
* `le` (Less Than or Equal To)
* `like` (Wildcard String Match)

A full list and more information can be viewed in the `about_comparison` conceptual help file, however it does take some time getting used to the `Where-Object` syntax. 
#### Example #
```powershell
> help about_comparison
```
## Feature # - Display system processes one page at a time
The `Out-Host` cmdlet sends output to the PowerShell host for display. The host displays the output at the command line. Because `Out-Host` is the default, you do not have to specify it unless you want to use its parameters to change the display.
#### Example #
```powershell
> Get-Process | Out-Host -Paging

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
    143       8     1916       6520             14024   0 AdaptiveSleepService
    773      43    35348      43828      14.56   4716   1 ApplicationFrameHost
    149       9     1624       6408              3640   0 armsvc
    234      12     2832      10376              6160   1 atieclxx
    128       8     1572       5164              2084   0 atiesrxx
    259      16    12600      17036      95.69   6352   0 audiodg
    181       9     7244       7152       0.16   1996   1 bash
    182       9     7184       7156       0.14  16564   1 bash
   1340     271   172932     138356     102.41  18236   1 Brady.Tolling.DataServiceHost
   1549     333   232384     184892   4,403.28  16040   1 Brady.Tolling.ExplorerHost
<SPACE> next page; <CR> next line; Q quit
    214      20     5064       9864              3744   0 BuildService
```
This command displays the processes on the system one page at a time. It uses the `Get-Process` cmdlet to get the processes on the system. The pipeline operator sends the results to `Out-Host` cmdlet, which displays them at the console. The `Paging` parameter displays one page of data at a time.
## Feature # - Display session history
Windows PowerShell itself keeps a history of the commands you’ve typed in the current PowerShell session. You can use several included cmdlets to view and work with your history.

To view the history of commands you’ve typed, run the following cmdlet:
#### Example #
```powershell
> Get-History

  Id CommandLine
  -- -----------
   1 git fetch
   2 git pull
   3 Get-Service | Format-Wide
   4 Get-Service -Name amd*  | Format-Wide
```
You can search your history by piping the resulting output to the `Select-String` cmdlet and specifying the text you want to search for:    
#### Example #
```powershell
> Get-History |  Select-String -Pattern "Table"

Get-Process | Format-Table name,id –AutoSize
```
To view a more detailed command history that displays the execution status of each command along with its start and end times, run the following command:
#### Example #
```powershell
> Get-History | Format-List -Property *


Id                 : 1
CommandLine        : git fetch
ExecutionStatus    : Completed
StartExecutionTime : 25/08/2018 11:44:36
EndExecutionTime   : 25/08/2018 11:44:37

Id                 : 2
CommandLine        : git pull
ExecutionStatus    : Completed
StartExecutionTime : 25/08/2018 11:44:50
EndExecutionTime   : 25/08/2018 11:44:51
```
By default, the `Get-History` cmdlet only shows the **32** most recent history entries. If you want to view or search a larger number of history entries, use the `-Count` option to specify how many history entries PowerShell should show, like so:
#### Example #
```powershell
> Get-History -Count 1000
> Get-History -Count 1000 | Select-String -Pattern "Table"
> Get-History -Count 1000 | Format-List -Property *
```
## Feature # - Run Commands From Your History
To run a command from your history, use the following cmdlet, specifying the Id number of the history item as shown by the `Get-History` cmdlet. To run two commands from your history back to back, use `Invoke-History` twice on the same line, separated by a **semicolon**.
#### Example #
```powershell
> Invoke-History 1 ; Invoke-History 2
Get-History

  Id CommandLine
  -- -----------
   1 Get-History
   2 Get-History
   3 Get-History
   4 Get-History
Get-History
   1 Get-History
   2 Get-History
   3 Get-History
   4 Get-History
```

## Feature # - Save and Import Your PowerShell History
If you want to save the PowerShell command history for the current session so you can refer to it later, you can do so
#### Example #
```powershell
> Get-History | Export-Clixml -Path .\history.xml
```
This exports your command history as a detailed XML file complete with **“StartExecutionTime”** and **“EndExecutionTime”** values for each command that tell you when the command was run and how long it took to complete.


Once you’ve exported your PowerShell history to such an XML file, you (or anyone else you send the XML file to) can import it to another PowerShell session with the `Add-History` cmdlet:
#### Example #
```powershell
> Add-History -InputObject (Import-Clixml .\history.xml)
```
If you run the `Get-History` cmdlet after importing such an XML file, you’ll see that the commands from the XML file were imported into your current PowerShell session’s history.
## Feature # - Clear Your PowerShell History

To clear the history of commands you’ve typed, run the following cmdlet:
#### Example #
```powershell
> Clear-History
```
Note that the command line buffer is separate from the PowerShell history. So, even after you run `Clear-History`, you can continue to press the **up** and **down** arrow keys to scroll through commands you’ve typed. However, if you run `Get-History`, you’ll see that your PowerShell history is **in fact empty**.

PowerShell doesn’t remember your history between sessions. To erase both command histories for the current session, all you have to do is close the PowerShell window.

If you’d like to clear the PowerShell window after clearing the history, you can do it by running the `Clear` command:
#### Example #
```powershell
> Clear
```

## Feature # - Get enhanced info by using Pipe Line

Let's get information for all running processes on our local computer and gets instances of WMI classes or information about the available classes for more detailed about each processes.

#### Example #
```powershell
> Get-Process -Name a* -PipelineVariable  Proc |  ForEach {
   Get-WmiObject  -Class Win32_Service  -ErrorAction SilentlyContinue  -Filter "ProcessID='$($Proc.Id)'" -PipelineVariable  Service |  ForEach {
       [PSCustomObject]@{
            ProcessName = $Proc.Name
            PID =  $Proc.Id
            ServiceName = $Service.Name
            ServiceDisplayName = $Service.DisplayName
            StartName =  $Service.StartName
        }
   }
 }  | Format-Table  -AutoSize

ProcessName           PID ServiceName                 ServiceDisplayName           StartName
-----------           --- -----------                 ------------------           ---------
AdaptiveSleepService 9760 AdaptiveSleepService        AdaptiveSleepService         LocalSystem
armsvc               3440 AdobeARMservice             Adobe Acrobat Update Service LocalSystem
atiesrxx             1996 AMD External Events Utility AMD External Events Utility  LocalSystem
```
Let's see what we done in **Example #22**:
* `Get-Process -Name a*` - return all running processes which name starts from `a` without checking for case.
* `-PipelineVariable  Proc` - initialize variable which will exist in next pipe line parts but not outside of command
* `ForEach` - query for each element from left part of pipe line, values will be available under `$Proc` variable
* `Get-WmiObject` - gets instances of WMI classes or information about the available classes.
* `-Class Win32_Service` - specifies the name of a WMI class. When this parameter is used, the cmdlet retrieves instances of the WMI class. It could be also `Win32_Service`, `Win32_Process`,`Win32_Bios` and other
* `-ErrorAction SilentlyContinue` - 3num. Determines how the cmdlet responds when an error occurs. Values are: `Continue` [default], `Stop`, `SilentlyContinue`, `Inquire`
* `-Filter "ProcessID='$($Proc.Id)'"` - Specifies a `Where` clause to use as a filter. Uses the syntax of the WMI Query Language (WQL).
* `PSCustomObject` - this is a very simple way to create structured data. For more, please read this great article - [Everything you wanted to know about PSCustomObject](https://kevinmarquette.github.io/2016-10-28-powershell-everything-you-wanted-to-know-about-pscustomobject/)
* `Format-Table` - view output in table style, for this type if will be `Format-List` default.
* `-AutoSize` - indicates that the cmdlet adjusts the column size and number of columns based on the width of the data. By default, the column size and number are determined by the view.

## Feature # - Truncating Parameters
Windows PowerShell also allows you truncate parameter names up until the point where they become ambiguous, that is to say up until the point where PowerShell can no longer figure out which parameter you are talking about
#### Example #
```powershell
>  Get-Service -Name *sql* -ComputerName localhost
Status   Name               DisplayName
------   ----               -----------
Running  MSSQL$SQLEXPRESS   SQL Server (SQLEXPRESS)
Stopped  SQLAgent$SQLEXP... SQL Server Agent (SQLEXPRESS)
Stopped  SQLBrowser         SQL Server Browser
Running  SQLTELEMETRY$SQ... SQL Server CEIP service (SQLEXPRESS)
Running  SQLWriter          SQL Server VSS Writer

> Get-Service -Na *sql* -Com localhost

Status   Name               DisplayName
------   ----               -----------
Running  MSSQL$SQLEXPRESS   SQL Server (SQLEXPRESS)
Stopped  SQLAgent$SQLEXP... SQL Server Agent (SQLEXPRESS)
Stopped  SQLBrowser         SQL Server Browser
Running  SQLTELEMETRY$SQ... SQL Server CEIP service (SQLEXPRESS)
Running  SQLWriter          SQL Server VSS Writer
```

# Chapter #6 - First scripts

## Feature # - Script policies

Let's create  our first script in current directory. As code we will use simple `Write-Host` to display static text as output in our powershell window

#### Example #
```powershell
> echo 'Write-Host "Script, World!"' > 'First Script.ps1'
> ls

    Directory: powershell-live-talks

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       20/08/2018     10:44                .vscode
-a----       20/08/2018     14:46             58 First Script.ps1
-a----       16/08/2018     11:48            106 Get-ServiceStatus.ps1
-a----       20/08/2018     14:23          19881 README.md

> more '.\First Script.ps1'
Write-Host "Script, World!"

> & '.\First Script.ps1'
Script, World!
```
Here we move text with command into new file, check if it's exist in directory and see what inside newly created file. After it we execute it.

In order to prevent malicious scripts from running on your system, PowerShell enforces an execution policy. There are 4 execution policies you can use:

* Restricted – Scripts won’t run. Period. (Default setting)
* RemoteSigned – Locally-created scripts will run. Scripts that were created on another machine will not run unless they are signed by a trusted publisher.
* AllSigned – Scripts will only run if signed by a trusted publisher (including locally-created scripts).
* Unrestricted – All scripts will run regardless of who created them and whether or not they are signed.

We could check current execution policy by `Get-ExecutionPolicy` command and set by `Set-ExecutionPolicy`.

#### Example #
```powershell
> Get-ExecutionPolicy
RemoteSigned

> Set-ExecutionPolicy RemoteSigned
Set-ExecutionPolicy : Access to the registry key
'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell' is denied. To change the
execution policy for the default (LocalMachine) scope, start Windows PowerShell with the "Run as administrator"
option. To change the execution policy for the current user, run "Set-ExecutionPolicy -Scope CurrentUser".
At line:1 char:1
+ Set-ExecutionPolicy RemoteSigned
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : PermissionDenied: (:) [Set-ExecutionPolicy], UnauthorizedAccessException
    + FullyQualifiedErrorId : System.UnauthorizedAccessException,Microsoft.PowerShell.Commands.SetExecutionPolicy
   Command
```
In order to change the execution policy, we will need to reopen PowerShell as an Administrator. The `Set-ExecutionPolicy` command will ask to verify that you really want to change the execution policy. Go ahead and select `Y` for yes, then go ahead and close and reopen your Powershell window.

## Feature # - Using Variables to Store Objects
PowerShell works with objects. PowerShell lets you create variables, essentially named objects, to preserve output for later use. If you are used to working with variables in other shells remember that PowerShell variables are objects, not text.

Variables are always specified with the initial character `$`, and can include any alphanumeric characters or the underscore in their names.

You can create a variable by typing a valid variable name
#### Example #
```powershell
> $cool
```
This returns no result because `$cool` does not have a value. You can create a variable and assign it a value in the same step. 
> PowerShell only creates the variable if it does not exist; otherwise, it assigns the specified value to the existing variable. 

To store your current location in the variable `$cool`, type:
#### Example #
```powershell
> $cool = Get-Location
> $cool

Path
----
~\powershell-live-talks
```
You can use `Get-Member` to display information about the contents of variables. Piping `$cool` to `Get-Member` will show you that it is a `PathInfo` object, just like the output from `Get-Location`:
#### Example #
```powershell
> $cool | Get-Member -MemberType Property


   TypeName: System.Management.Automation.PathInfo

Name         MemberType Definition
----         ---------- ----------
Drive        Property   System.Management.Automation.PSDriveInfo Drive {get;}
Path         Property   string Path {get;}
Provider     Property   System.Management.Automation.ProviderInfo Provider {get;}
ProviderPath Property   string ProviderPath {get;}
```
PowerShell provides several commands to manipulate variables. You can see a complete listing in a readable form by typing:
#### Example #
```powershell
> Get-Command -Noun Variable | Format-Table -Property Name,Definition -AutoSize -Wrap

Name            Definition
----            ----------
Clear-Variable  ...
Get-Variable    ...
New-Variable    ...
Remove-Variable ...
Set-Variable    ...
```
In addition to the variables you create in your current PowerShell session, there are several system-defined variables. You can use the `Remove-Variable` cmdlet to clear out all of the variables which are not controlled by PowerShell. Type the following command to clear all variables:
#### Example #
```powershell
> Remove-Variable -Name * -Force -ErrorAction SilentlyContinue
```
If you then run the Get-Variable cmdlet, you will see the remaining PowerShell variables. Since there is also a variable PowerShell drive, you can also display all PowerShell variables by typing:
#### Example #
```powershell
>  Get-Variable

Name                           Value
----                           -----
$                              $cool
^                              $cool
args                           {}
...

> Get-ChildItem variable:

Name                           Value
----                           -----
$                              Get-Variable
^                              Get-Variable
args                           {}
...
```
Although PowerShell is not Cmd.exe, it runs in a command shell environment and can use the same variables available in any environment in Windows. These variables are exposed through a drive named `env:`. You can view these variables by typing:
#### Example #
```powershell
> Get-ChildItem env:

Name                           Value
----                           -----
ALLUSERSPROFILE                C:\ProgramData
APPDATA                        C:\Users\bbenetskyi\AppData\Roaming
ChocolateyInstall              C:\ProgramData\chocolatey
ChocolateyLastPathUpdate       Mon Jun 18 11:35:35 2018
CommonProgramFiles             C:\Program Files\Common Files
CommonProgramFiles(x86)        C:\Program Files (x86)\Common Files
...
```
Although the standard variable cmdlets are not designed to work with env: variables, you can still use them by specifying the `env:` prefix. For example, to see the operating system root directory, you can use the command-shell `%SystemRoot%` variable from within PowerShell by typing:
#### Example #
```powershell
> $env:SystemRoot
C:\WINDOWS
```
You can also create and modify environment variables from within PowerShell. Environment variables accessed from Windows PowerShell conform to the normal rules for environment variables elsewhere in Windows.

## Feature # - Variable Types

You could define variables with spaces:
#### Example #
```powershell
> $simpleVariable = '#1';
> ${simple Variable} = '#2';
> ${simple Variable}
#2
> $simpleVariable
#1
```
Also there is a possibility to define strongly typed variable
#### Example #
```powershell
> [String]$MyName="Jason"
> [int]$Oops="Jason"
Cannot convert value "Jason" to type "System.Int32". Error: "Input string was not in a correct format."
At line:1 char:1
+ [int]$Oops="Jason"
+ ~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : MetadataError: (:) [], ArgumentTransformationMetadataException
    + FullyQualifiedErrorId : RuntimeException
```
Same as `Console.ReadLine` we could await for user input in PowerShell
#### Example #
```powershell
> [string]$ComputerName=Read-host "Enter Computer Name"
Enter Computer Name: WorkPC
> Write-Output $ComputerName
WorkPC
```
## Feature # - Quotation Marks

In PowerShell we have inline variable resolving
#### Example #
```powershell
> $name = 'Bohdan'
> "We could print $name as name of $name"
We could print Bohdan as name of Bohdan
> 'We could print $name as name of $name'
We could print $name as name of $name
> "We could print `$name as name of $name"
We could print $name as name of Bohdan
```
So as you could see both kinds of quotes are used to delimit string values. 
> In general, you should use single quotes

There are three instances when you might want to shift to double quotes. First, when you want to have variable names replaced with their contents: `"We could print $name as name of $name"`. That's a useful trick, since it saves you from having to concatenate strings in a lot of situations. 


Second, when you need to delimit a string within the string - such as in a SQL query: `$query = "SELECT * FROM Worksops WHERE Name LIKE '%K8s%'"`. Using outer double quotes lets you use the single quotes needed within the string.


Finally, when you need to use an escape character, since those aren't parsed within single quotes: `Get-Process | Export-CSV processes.tdf -delimiter "```t"`. That creates a tab-delimited file. 

Apart from those three instances, it's generally considered a best practice to stick with single quotes. 

## Feature # - If/Else Statement
Here is all simple, let's just look on examples:
#### Example #
```powershell
> $Status=(Get-service -name bits).status
> If ($Status -eq "Running") {
     Clear-Host
     Write-Output "Service is being stopped"
     Stop-Service -name bits
 } ElseIf ($Status -eq "Pending") {
     Clear-Host
     Write-Output "Service is in undefined status"
 } Else {
     Clear-Host
     Write-Output "Service is already stopped"
 }
```
 ## Feature # - Switch
 Just the same, all should be clear from exmaples:
 #### Example #
 ```powershell
 > [int] $status = Read-Host('Enter number between 0..4')
Enter number between 0..4: 4
> Switch ($status) {
   0 { $status_text = 'ok' }
   1 { $status_text = 'error' }
   2 { $status_text = 'jammed' }
   3 { $status_text = 'overheated' }
   4 { $status_text = 'empty' }
   default { $status_text = 'unknown' }
 }
> $status_text
empty
 ```
## Feature - Loops(While,Do-While)
And again short and self explained examples:
#### Example #
```powershell
> # Do loop
> $i= 1
> Do {
     Write-Output "Workshops is great event for $i times"
     $i=$i+1 # $i++
 } While ($i -le 5) #Also Do-Until
Workshops is great event for 1 times
Workshops is great event for 2 times
Workshops is great event for 3 times
Workshops is great event for 4 times
Workshops is great event for 5 times
>
> # While Loop
> $i=5
> While ($i -gt 1) {
     Write-Output "Workshops is sucks when $i in one day"
     $i--
 }
Workshops is sucks when 5 in one day
Workshops is sucks when 4 in one day
Workshops is sucks when 3 in one day
Workshops is sucks when 2 in one day
```
Hope all is really clear)))

## Feature - Foreach statement
We already saw it. Not we will just look what forms it have:
#### Example #
```powershell
> # Foreach - used often in our scripting for today
> $services = Get-Service
> ForEach ($service in $services) {
   $service.Displayname
 }
Adobe Flash Player Update Service
AllJoyn Router Service
Application Layer Gateway Service
...
> #For loop
> For ($i=0;$i –lt 5;$i++) {
  #do something
 }
>
> #Another way
> 1..5 | ForEach-Object -process {
     Start calc
 }
```
## Feature # - Complete Template
This is not feature - this is just complete template of availbale parameters and help description for functions

It's loceted at [CompleteTemplate.ps1](https://github.com/bbenetskyy/powershell-live-talks/blob/master/CompleteTemplate.ps1)

## Feature # - Common Parameter in Powershell

The example below will use `Get-Service` to get a list of all of the services on my computer and then sort that list by the `State` property. What we will see this time will not be an accurate representation the output that we were expecting.
#### Example #
```powershell
> Get-Service -PipelineVariable  Service |  Sort-Object -Property  State |  ForEach {

   [pscustomobject]@{

   Name =  $Service.Name

   DisplayName =  $_.DisplayName

   }

 }

Name          DisplayName
----          -----------
XboxNetApiSvc Software Protection
XboxNetApiSvc SQL Server Agent (SQLEXPRESS)
XboxNetApiSvc Windows Perception Service
XboxNetApiSvc Print Spooler
XboxNetApiSvc SQL Server VSS Writer
XboxNetApiSvc SSDP Discovery
...
```
The last item in the pipeline is saved to the pipeline variable due to the aggregation that is occurring with `Sort-Object`. This is happening because all of the data is being held up by `Get-Service` before being sent to `Sort-Object` to be sorted based on the given sorting parameters. Because of this, the pipeline variable no longer shows all of the output and isn't a good source of data to be used later on in other commands in the pipeline.

Building a function that allows you to make use of this parameter is easier than you think! The key component when you build your function or script is to include the cmdlet binding attribute that defines your function as an advanced function and opens up this parameter (as well as other common parameters). You can quickly verify this by looking at the command syntax.

#### Without cmdletbinding:
#### Example #
```powershell
> Function Test-Function  {

   Param (

   [string[]]$Data

   )

 }
> Get-Command Test-Function  -Syntax

Test-Function [[-Data] <string[]>]
```
####  With cmdletbinding:
#### Example #
```powershell
> Function Test-Function  {

   [cmdletbinding()]

   Param (

   [string[]]$Data

   )

   }
> Get-Command Test-Function  -Syntax

Test-Function [[-Data] <string[]>] [<CommonParameters>]
```
You can see that the `CommandParameter` label is used on the function that includes the cmdlet binding attribute which means that we have our pipeline variable enabled for use.

Once you have done this then you can begin building out your function. The process to do this is a little quirky, for a lack of better words. I found that supporting the pipeline in the function using more traditional means like the Process block only seems to send the first item in the pipeline to the variable as shown below.

#### Example #
```powershell
> Function Test-Function  {

   [cmdletbinding()]

   Param (

   [parameter(ValueFromPipeline=$True)]

   [object[]]$Data

   )

   Process  {

   ForEach  ($Item in  $Data) {

   $Item

   }

   }

 }
 1..5|Test-Function -PipelineVariable  t|ForEach{$t}
1
```
This does work as expected when using the named parameter
#### Example #
```powershell
> Test-Function -Data (1..5) -PipelineVariable  t | ForEach {$t}
1
2
3
4
5
```
So how in the world can we make this support pipeline input? Well, we can make use of an automatic variable called `$Input` which takes in all of the pipeline input and treats it like a collection. It can even be placed in the `Begin` block and it will have all of the pipeline data! This variable does have a different meaning when you are not supporting pipeline input and another catch is that you cannot have a Process block with your pipeline support because it then becomes the single item in the Process block (like `$_` and `$PSItem`).
#### Example #
```powershell
> Function Test-Function  {

   [cmdletbinding()]

   Param (

   [parameter(ValueFromPipeline=$True)]

   [object[]]$Data

   )

   $input

 }
PS C:\Users\bbenetskyi> 1..5|Test-Function -PipelineVariable  t|ForEach{$t}
1
2
3
4
5
```
`cmdletbinding` - provide the ability to use `Write-Verbose` and `Write-Debug` in your script or function, and have their output controlled by `-Verbose` and `-Debug` parameters of that script or function. 

# Chapter #6 - Modules and Functions

## Feature # - Functions
Hmm, what is function? We could check it as enhanced PowerShell users:
#### Example #
```powershell
> help about_functions
LONG DESCRIPTION
    A function is a list of Windows PowerShell statements that has a name
    that you assign. When you run a function, you type the function name.
    The statements in the list run as if you had typed them at the command
    prompt.
```
How looks like functions?
#### Example #
```powershell
>help about_functions -examples
```
Now let's define simple function which checks [disk info](https://github.com/bbenetskyy/powershell-live-talks/blob/master/DiskInfo.ps1) for some computer.
#### Example #
```powershell
"Function Get-DiskInfo{

     [CmdletBinding()]
     param(
         [Parameter(Mandatory=`$true)]
         [String]`$ComputerName,
         [String]`$Drive='c:'
     )
     Get-WmiObject -class Win32_logicalDisk -Filter `"DeviceID='`$Drive'`" -ComputerName `$ComputerName |
         Select PSComputerName, DeviceID,
             @{n='Size(GB)';e={`$_.size / 1gb -as [int]}},
             @{n='Free(GB)';e={`$_.Freespace / 1gb -as [int]}}

 }" | Out-File DiskInfo.ps1
> [System.Net.Dns]::GetHostByName($VM)

HostName   Aliases AddressList
--------   ------- -----------
bbenetskyy {}      {192.168.99.1, 192.168.56.1, 192.168.0.151}
> . .\DiskInfo.ps1
> Get-DiskInfo bbenetskyy

PSComputerName DeviceID Size(GB) Free(GB)
-------------- -------- -------- --------
BBENETSKYY     C:            488      239
```

## Feature # - Multifunctions in one file
Also we could define couple functions in one `ps1` script file. Just plate couple functions in one file:
#### Example #
```powershell
> "Function Function1 { Write-Output 'Call functon #1' }
 Function Function2 { Write-Output 'Call functon #2' }
 Function Function3 { Write-Output 'Call functon #3' }

 Function1
 Function2
 Function3
 " | Out-File MultiFunctions.ps1
> .\MultiFunctions.ps1
Call functon #1
Call functon #2
Call functon #3
```

## Feature # - Script Invoking from files

Here are listed available mehtods for invoke your function in current powreshell window.
But before let's create [SelfDescribed.ps1](https://github.com/bbenetskyy/powershell-live-talks/blob/master/SelfDescribed.ps1):

#### Example #
```powershell
> more .\SelfDescribed.ps1
Write-Host "Loading functions"
function MyFunc
{
    Write-Host "MyFunc is running!"
}
Write-Host "Done"

Function addOne([int]$intIN)
{
$intIN + 1
}
Function addTwo([int]$intIN)
{
$intIN + 2
}

#
#
#

> powershell -command "& { . .\SelfDescribed.ps1; MyFunc }"
Loading functions
Done
MyFunc is running!
> MyFunc
MyFunc : The term 'MyFunc' is not recognized as the name of a cmdlet, function, script file, or operable
program. Check the spelling of the name, or if a path was included, verify that the path is correct and try
again.
At line:1 char:1
+ MyFunc
+ ~~~~~~
    + CategoryInfo          : ObjectNotFound: (MyFunc:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException

#
#
#

> . .\SelfDescribed.ps1 
 Loading functions
 Done
 > MyFunc
  MyFunc is running!

#
#
#

> .\SelfDescribed.ps1
Loading functions
Done
> MyFunc
MyFunc : The term 'MyFunc' is not recognized as the name of a cmdlet, function, script file, or operable
program. Check the spelling of the name, or if a path was included, verify that the path is correct and try
again.
At line:1 char:1
+ MyFunc
+ ~~~~~~
    + CategoryInfo          : ObjectNotFound: (MyFunc:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException

#
#
#

> . .\SelfDescribed.ps1
Loading functions
Done
> addOne(2)
3
> Remove-Item function:\addOne
> addOne(2)
addOne : The term 'addOne' is not recognized as the name of a cmdlet, function, script file, or operable
program. Check the spelling of the name, or if a path was included, verify that the path is correct and try
again.
At line:1 char:1
+ addOne(2)
+ ~~~~~~
    + CategoryInfo          : ObjectNotFound: (addOne:String) [], CommandNotFoundException
    + FullyQualifiedErrorId : CommandNotFoundException
```

## Feature # - Variable Availability in Functions

When you first assign a value to a variable (initialize it) in a script, the variable is only available within the script and not on the console where you launched the script. Likewise, if you define a variable in a function, you cannot access its value at the script level where you called the function. The variable’s scope is responsible for this behavior; it determines where the variable is available.

**Scopes** are organized in hierarchies. At the top sits the Global scope. This scope is created whenever you start a PowerShell session. The **Script** scope is one level below the **Global** scope. Next is the scope of a function that you define in your script, and, if you create a function within a function, you also create a new scope that sits below the other scopes. A scope that is located one level above a certain other scope is called the parent scope; the lower-level scope is its child scope.

Variables defined in a child scope are unavailable in the parent scope. However, in the child scope, you have read access to variables initialized in the parent scope. Read access reaches down to all lower levels.

#### Example #
```powershell
> $Script = "Script scope"
> function myFunction {
>>      $Function = "Scope of the function"
>>      $Script
>>      $Script = "Trying to change a variable in the Script scope"
>> }
> myFunction
Script scope
> $Script
Script scope
> $Function
```

You can change this default behavior of PowerShell by using scope modifiers. The four available modifiers correspond to the absolute scopes mentioned above: `Private`, `Local`, `Script`, and `Global`. The command below creates a variable in a `Private` scope:
#### Example #
```powershell
> $Private:internal = "Hidden!!!"
```
This ensures that the variable can only be accessed in its Local scope (the scope where you defined it) and not in its child scopes.

In the example below, both variables are defined in the function, but only the one with the Script modifier is available at the script level:
#### Example #
```powershell
> function scopeFunction {
      $Script:ScriptScope = "Created in the Script Scope"
      $FunctionScope = "Created in the scope of the function"
}
> scopeFunction
> $ScriptScope
Created in the Script Scope
> $FunctionScope
```
Alternatively, you can use the `New-Variable` cmdlet to create a variable with the `AllScope` property:
#### Example #
```powershell
> New-Variable -Name coolVar -Option AllScope -Value "Available in all child scopes" 
> $coolVar
Available in all child scopes
```

## Feature # - Begin, Process and End of Function lifecycle

For functions and script cmdlets, three methods are available for processing pipeline input: `Begin`, `Process`, and `End` blocks. In these blocks, the `$_` variable represents the current input object.

## Begin
This block is used to provide optional one-time pre-processing for the function. 
The PowerShell runtime uses the code in this block one time for each instance of the function in the pipeline.

## Process
This block is used to provide record-by-record processing for the function. This block might be used any number of times, or not at all, depending on the input to the function. For example, if the function is the first command in the pipeline, the **Process** block will be used one time. If the function is not the first command in the pipeline, the **Process** block is used one time for every input that the function receives from the pipeline. If there is no pipeline input, the **Process** block is not used.

A Filter is a shorthand representation of a function whose body is composed entirely of a process block.

This block must be defined if a function parameter is set to accept pipeline input. If this block is not defined and the parameter accepts input from the pipeline, the function will miss the values that are passed to the function through the pipeline.

Also, if the function/cmdlet supports confirmation requests (the `-SupportsShouldProcess` parameter is set to `$True`), the call to the **ShouldProcess** method must be made from within the **Process** block.

## End
This block is used to provide optional one-time post-processing for the function.

#### Example #
```powershell
> . .\FunctionWithSteps1.ps1 -force
> 1..10|Show-Numbers
Begin
1
2
3
4
5
6
7
8
9
10
End
> . .\FunctionWithSteps2.ps1 -force
> Get-CompInfo bbenetskyy -Verbose -LogExecutionTime -WithPSObject
VERBOSE: Execution time logging turned on
VERBOSE: Computer: bbenetskyy

VERBOSE: Completed in 140.3881
FreeSpace ComputerName OS Name                  OS Build
--------- ------------ -------                  --------
      245 bbenetskyy   Microsoft Windows 10 Pro 17134


> Get-CompInfo bbenetskyy -Verbose -LogExecutionTime
VERBOSE: Execution time logging turned on
VERBOSE: Computer: bbenetskyy

Name                           Value
----                           -----
FreeSpace                      245
ComputerName                   bbenetskyy
OS Name                        Microsoft Windows 10 Pro
OS Build                       17134
VERBOSE: Completed in 57.2333
```

## Feature # - Background Jobs on Modules

Start-Job {param($scriptdir) Import-Module $scriptdir\Utils.psm1; ...} -Arg $PSScriptRoot


The `Start-Job` cmdlet starts a PowerShell background job on the local computer.

A PowerShell background job runs a command without interacting with the current session. When you start a background job, a job object returns immediately, even if the job takes an extended time to finish. You can continue to work in the session without interruption while the job runs.

https://blogs.technet.microsoft.com/heyscriptingguy/2012/12/31/using-windows-powershell-jobs/

## Feature # - How to create your first PowerShell Module Command
https://sid-500.com/2017/11/10/powershell-functions-how-to-create-your-first-powershell-module-command/

## Feature # - How And When To Create And Use PowerShell Modules
http://www.tomsitpro.com/articles/powershell-modules,2-846.html


## Feature # - Sending Email With Send-MailMessage (Gmail example)
Start-Job {param($scriptdir) Import-Module $scriptdir\Utils.psm1; ...} -Arg $PSScriptRoot



New-Module

```

## Feature # - How to zip up files using .NET and Add-Type
https://www.pdq.com/blog/powershell-zip-up-files-using-.net-and-add-type/

## Feature # - Get CPU Usage for a Process Using Get-Counter
https://www.pdq.com/blog/powershell-get-cpu-usage-for-a-process-using-get-counter/

## Feature # - Create Shortcuts on User Desktops using Powershell
https://www.pdq.com/blog/pdq-deploy-and-powershell/

<a name="desc"></a>
## 1. Description

sometext

<a name="usage"></a>
## 2. Usage tips
