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
8. //TODO

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

> Windows PowerShell commands have the following generic structure: `Verb-prefix_singular_noun`

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

> Errors will be reviewed later on chapter #7

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
## Feature #7 - Display basic information one page at a time
These commands display basic information about the `Format-Table` cmdlet one page at a time:
#### Example #12
```powershell
> Get-Help Format-Table | Out-Host -Paging
> help Format-Table
> man Format-Table
```
## Feature #8 - Display more information for a cmdlet
These commands display more information about the `Format-Table` cmdlet than usual:
#### Example #13
```powershell
> Get-Help Format-Table -Detailed
> Get-Help Format-Table -Full
```
The `Detailed` parameter displays the detailed view of the help topic, which includes parameter descriptions and examples.

The `Full` parameter displays the full view of the help topic, which includes parameter descriptions, examples, input and output object types, and additional notes.

**The `Detailed` and `Full` parameters are effective only for the commands whose help files are installed on the computer.**
## Feature #9 - Display selected parts of a cmdlet by using parameters
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

There are plenty of Linux shells with a pipeline, allowing you to send the text that one command outputs as input to the next command in the pipeline. PowerShell takes this to the next level by allowing you to take the objects that one cmdlet outputs and pass them as input to the next cmdlet in the pipeline.

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

If we would like to get all properties of `Get-Disk` command with Pipe Line we could simply filter only needed for use properties
#### Example #20
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
#### Example #21
```powershell
> Get-Disk |   select -Property *
```

## Feature #14 - Default Formatting
When I first started out with PowerShell, I thought everything was magic, but the truth is it just takes a little bit of time to understand what is going on underneath the hood. The same is true for the PowerShell formatting system. In fact, if you run the Get-Service cmdlet, the output generated only shows you 3 properties: `Status`, `Name` and `DisplayName`.


But if you pipe `Get-Service` to `Get-Member`, you see that the `ServiceController` objects have a lot more than just these three properties, so what is going on?


The answer lies within a hidden file that defines how most of the built-in cmdlets display their output. To get an understanding, type the following into the shell and hit enter.
#### Example #22
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

## Feature #15 - Formatting Your Data

If you are not happy with the default formatting of an object or type, you can roll your own formatting. There are three cmdlets you need to know to do this:
* `Format-List`
* `Format-Table`
* `Format-Wide`

`Format-Wide` simply takes a collection of objects and displays a single property of each object. By default, it will look for a name property; if your objects don’t contain a name property, it will use the first property of the object once the properties have been sorted alphabetically.
#### Example #23
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
#### Example #24
```powershell
> Get-Service -Name a*  | Format-Wide  -Property DisplayName -Column 6


Adaptive... Adobe A... Adobe F... AllJoyn... Applica... AMD Ext...
Applicat... Applica... Applica... App Rea... Microso... AppX De...
ASP.NET ... Assigne... Windows... Windows... ActiveX...
```
If something is formatted as a table by default, you can always switch it to list view by using the `Format-List` cmdlet. Let’s take a look at the output of the `Get-Process` cmdlet.
#### Example #25
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
#### Example #26
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
#### Example #27
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
#### Example #28
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
#### Example #29
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
## Feature #16 - Filtering and Comparing
One of the best things about using an object-based pipeline is that you can filter objects out of the pipeline at any stage using the `Where-Object` cmdlet.
#### Example #30
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
#### Example #31
```powershell
> help about_comparison
```
## Feature #17 - Display system processes one page at a time
The `Out-Host` cmdlet sends output to the PowerShell host for display. The host displays the output at the command line. Because `Out-Host` is the default, you do not have to specify it unless you want to use its parameters to change the display.
#### Example #32
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
## Feature #18 - Display session history
Windows PowerShell itself keeps a history of the commands you’ve typed in the current PowerShell session. You can use several included cmdlets to view and work with your history.

To view the history of commands you’ve typed, run the following cmdlet:
#### Example #33
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
#### Example #34
```powershell
> Get-History |  Select-String -Pattern "Table"

Get-Process | Format-Table name,id –AutoSize
```
To view a more detailed command history that displays the execution status of each command along with its start and end times, run the following command:
#### Example #35
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
#### Example #36
```powershell
> Get-History -Count 1000
> Get-History -Count 1000 | Select-String -Pattern "Table"
> Get-History -Count 1000 | Format-List -Property *
```

## Feature #15 - Get enhanced info by using Pipe Line

Let's get information for all running processes on our local computer and gets instances of WMI classes or information about the available classes for more detailed about each processes.

#### Example #23
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

## Feature #16 - Truncating Parameters
Windows PowerShell also allows you truncate parameter names up until the point where they become ambiguous, that is to say up until the point where PowerShell can no longer figure out which parameter you are talking about
#### Example #24
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

## Feature #17 - Script policies

Let's create  our first script in current directory. As code we will use simple `Write-Host` to display static text as output in our powershell window

#### Example #25
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

#### Example #26
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




## Feature # - Sending Email With Send-MailMessage (Gmail example)
https://www.pdq.com/blog/powershell-send-mailmessage-gmail/

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
