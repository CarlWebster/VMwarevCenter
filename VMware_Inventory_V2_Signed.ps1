﻿#Requires -Version 3.0
#This File is in Unicode format.  Do not edit in an ASCII editor.

#region help text

<#

.SYNOPSIS
	Creates a complete inventory of a VMware vSphere datacenter using PowerCLI and 
	Microsoft Word, PDF, plain text, or HTML.
.DESCRIPTION
	Creates a complete inventory of a VMware vSphere datacenter using PowerCLI and 
	Microsoft Word, PDF, plain text, or HTML.

	The default output is HTML.

	Creates a document named after the vCenter server.
	
	The Word/PDF Document includes a Cover Page, Table of Contents, and Footer.
	
	Includes support for the following language versions of Microsoft Word:
		Catalan
		Chinese
		Danish
		Dutch
		English
		Finnish
		French
		German
		Norwegian
		Portuguese
		Spanish
		Swedish
.PARAMETER VIServerName
    Name of the vCenter Server to connect to.
    This parameter is mandatory and does not have a default value.
    FQDN should be used; hostname can be used if it can be resolved correctly.
.PARAMETER HTML
	Creates an HTML file with an .html extension.
	This parameter is disabled by default.
.PARAMETER Text
	Creates a formatted text file with a .txt extension.
	This parameter is disabled by default.
.PARAMETER AddDateTime
	Adds a date time stamp to the end of the file name.
	Time stamp is in the format of yyyy-MM-dd_HHmm.
	June 1, 2023 at 6PM is 2023-06-01_1800.
	Output filename will be ReportName_2023-06-01_1800.docx (or .pdf).
	This parameter is disabled by default.
.PARAMETER Folder
	Specifies the optional output folder to save the output report. 
.PARAMETER Full
	Runs a full inventory for the Hosts, clusters, resource pools, networking and 
	virtual machines.
	
	This parameter is disabled by default - only a summary runs when this 
	parameter is not specified.
.PARAMETER Export
    Runs this script gathering all required data from PowerCLI as normal, then 
	exporting data to XML files in the .\Export directory.
	
	Export honors the path specified with the Folder parameter when the script 
	creates the Export directory.
	
    Once the export completes, you can copy it offline to run later with the 
	-Import parameter.
	
    This parameter overrides all other output formats.
	
	The following parameters are set to False or Null.
	HTML
	MSWord
	PDF
	Text
	AddDateTime
	Chart
	CompanyAddress
	CompanyEmail
	CompanyFax
	CompanyName
	CompanyPhone
	CoverPage
	From
	Import
	Issues
	ReportFooter
	SmtpServer
	SmtpPort
	To
	UseSSL
	UserName
.PARAMETER Import
    Runs this script gathering all required data from a previously run Export.
    Export directory must be present in the same directory as the script itself.
    Requires PowerCLI and a VIServerName to run in -Import -Full mode, otherwise
	PowerCLI and a VIServerName are not required.
    This parameter overrides all other output formats
.PARAMETER Dev
	Clears errors at the beginning of the script.
	Outputs all errors to a text file at the end of the script.
	
	This is used when the script developer requests more troubleshooting data.
	Text file is placed in the same folder from where the script is run.
	
	This parameter is disabled by default.
.PARAMETER Log
	Generates a log file for troubleshooting.
.PARAMETER ScriptInfo
	Outputs information about the script to a text file.
	Text file is placed in the same folder from where the script is run.
	
	This parameter is disabled by default.
	This parameter has an alias of SI.
.PARAMETER ReportFooter
	Outputs a footer section at the end of the report.

	This parameter has an alias of RF.
	
	Report Footer
		Report information:
			Created with: <Script Name> - Release Date: <Script Release 
			Date>
			Script version: <Script Version>
			Started on <Date Time in Local Format>
			Elapsed time: nn days, nn hours, nn minutes, nn.nn seconds
			Ran from domain <Domain Name> by user <Username>
			Ran from the folder <Folder Name>

	Script Name and Script Release date are script-specific variables.
	Script version is a script variable.
	Start Date Time in Local Format is a script variable.
	Elapsed time is a calculated value.
	Domain Name is $env:USERDNSDOMAIN.
	Username is $env:USERNAME.
	Folder Name is a script variable.
.PARAMETER Issues
    This parameter is still beta and is disabled by default
    Gathers basic summary data as well as specific issues data with the idea to be 
	run on a set schedule
    This parameter does not currently support Import\Export
.PARAMETER PCLICustom
    Prompts user to locate the PowerCLI Scripts directory in a non-default 
	installation
    This parameter is disabled by default
.PARAMETER MSWord
	SaveAs DOCX file
	This parameter is set True if no other output format is selected.
.PARAMETER PDF
	SaveAs PDF file instead of DOCX file.
	This parameter is disabled by default.
	The PDF file is roughly 5X to 10X larger than the DOCX file.
	This parameter requires Microsoft Word to be installed.
	This parameter uses the Word SaveAs PDF capability.
.PARAMETER Chart
    This parameter is disabled by default
    Gathers data from VMware stats to build performance graphs for hosts and VMs
	
	The following data are charted:
	
	Hosts:
		cpu.usage.average
		mem.granted.average
		mem.active.average
		mem.vmmemctl.average
		disk.usage.average
		disk.maxTotalLatency.latest
		net.received.average
		net.transmitted.average
		net.usage.average
	
	Cluster:
		cpu.usagemhz.average
		mem.usage.average
	
	VMs:
		cpu.usage.average
		mem.usage.average
		virtualDisk.write.average
		virtualDisk.read.average
		net.received.average
		net.transmitted.average

    DOTNET chart controls are required

	http://www.microsoft.com/en-us/download/details.aspx?id=14422

	This parameter is supported for MSWord and PDF only
.PARAMETER CompanyAddress
	Company Address to use for the Cover Page, if the Cover Page has the Address 
	field.
	
	The following Cover Pages have an Address field:
		Banded (Word 2013/2016)
		Contrast (Word 2010)
		Exposure (Word 2010)
		Filigree (Word 2013/2016)
		Ion (Dark) (Word 2013/2016)
		Retrospect (Word 2013/2016)
		Semaphore (Word 2013/2016)
		Tiles (Word 2010)
		ViewMaster (Word 2013/2016)
		
	This parameter is only valid with the MSWORD and PDF output parameters.
	This parameter has an alias of CA.
.PARAMETER CompanyEmail
	Company Email to use for the Cover Page, if the Cover Page has the Email 
	field.  
	
	The following Cover Pages have an Email field:
		Facet (Word 2013/2016)
	
	This parameter is only valid with the MSWORD and PDF output parameters.
	This parameter has an alias of CE.
.PARAMETER CompanyFax
	Company Fax to use for the Cover Page, if the Cover Page has the Fax field.  
	
	The following Cover Pages have a Fax field:
		Contrast (Word 2010)
		Exposure (Word 2010)
	
	This parameter is only valid with the MSWORD and PDF output parameters.
	This parameter has an alias of CF.
.PARAMETER CompanyName
	Company Name to use for the Cover Page.  
	Default value is contained in 
	HKCU:\Software\Microsoft\Office\Common\UserInfo\CompanyName or
	HKCU:\Software\Microsoft\Office\Common\UserInfo\Company, whichever is 
	populated on the computer running the script.
	This parameter has an alias of CN.
	If either registry key does not exist and this parameter is not specified, the 
	report will not contain a Company Name on the cover page.
	This parameter is only valid with the MSWORD and PDF output parameters.
.PARAMETER CompanyPhone
	Company Phone to use for the Cover Page if the Cover Page has the Phone field.  
	
	The following Cover Pages have a Phone field:
		Contrast (Word 2010)
		Exposure (Word 2010)
	
	This parameter is only valid with the MSWORD and PDF output parameters.
	This parameter has an alias of CPh.
.PARAMETER CoverPage
	What Microsoft Word Cover Page to use.
	Only Word 2010, 2013 and 2016 are supported.
	(default cover pages in Word en-US)
	
	Valid input is:
		Alphabet (Word 2010. Works)
		Annual (Word 2010. Doesn't work well for this report)
		Austere (Word 2010. Works)
		Austin (Word 2010/2013/2016. Doesn't work in 2013 or 2016, mostly 
		works in 2010 but Subtitle/Subject & Author fields need to be moved 
		after title box is moved up)
		Banded (Word 2013/2016. Works)
		Conservative (Word 2010. Works)
		Contrast (Word 2010. Works)
		Cubicles (Word 2010. Works)
		Exposure (Word 2010. Works if you like looking sideways)
		Facet (Word 2013/2016. Works)
		Filigree (Word 2013/2016. Works)
		Grid (Word 2010/2013/2016. Works in 2010)
		Integral (Word 2013/2016. Works)
		Ion (Dark) (Word 2013/2016. Top date doesn't fit; box needs to be 
		manually resized or font changed to 8 point)
		Ion (Light) (Word 2013/2016. Top date doesn't fit; box needs to be 
		manually resized or font changed to 8 point)
		Mod (Word 2010. Works)
		Motion (Word 2010/2013/2016. Works if top date is manually changed to 
		36 point)
		Newsprint (Word 2010. Works but date is not populated)
		Perspective (Word 2010. Works)
		Pinstripes (Word 2010. Works)
		Puzzle (Word 2010. Top date doesn't fit; box needs to be manually 
		resized or font changed to 14 point)
		Retrospect (Word 2013/2016. Works)
		Semaphore (Word 2013/2016. Works)
		Sideline (Word 2010/2013/2016. Doesn't work in 2013 or 2016, works in 
		2010)
		Slice (Dark) (Word 2013/2016. Doesn't work)
		Slice (Light) (Word 2013/2016. Doesn't work)
		Stacks (Word 2010. Works)
		Tiles (Word 2010. Date doesn't fit unless changed to 26 point)
		Transcend (Word 2010. Works)
		ViewMaster (Word 2013/2016. Works)
		Whisp (Word 2013/2016. Works)
		
	The default value is Sideline.
	This parameter has an alias of CP.
	This parameter is only valid with the MSWORD and PDF output parameters.
.PARAMETER UserName
	Username to use for the Cover Page and Footer.
	Default value is contained in $env:username
	This parameter has an alias of UN.
	This parameter is only valid with the MSWORD and PDF output parameters.
.PARAMETER SmtpServer
	Specifies the optional email server to send the output report. 
.PARAMETER SmtpPort
	Specifies the SMTP port. 
	Default is 25.
.PARAMETER UseSSL
	Specifies whether to use SSL for the SmtpServer.
	Default is False.
.PARAMETER From
	Specifies the username for the From email address.
	If SmtpServer is used, this is a required parameter.
.PARAMETER To
	Specifies the username for the To email address.
	If SmtpServer is used, this is a required parameter.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1
	
	The script uses all default values and prompts for the vCenter Server.
	Outputs an HTML report.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -VIServerName testvc.lab.com
	
	The script uses all default values and uses testvc.lab.com as the vCenter Server.
	Outputs an HTML report.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -MSWord -VIServerName testvc.lab.com
	
	The script uses all default values and saves the document as a Word file.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName=
	"Jacob Rutski" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Jacob Rutski"
	$env:username = Administrator

	Jacob Rutski for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -PDF -VIServerName testvc.lab.com
	
	The script uses all default values and saves the document as a PDF file.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName=
	"Jacob Rutski" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Jacob Rutski"
	$env:username = Administrator

	Jacob Rutski for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -TEXT -VIServerName testvc.lab.com

	This parameter outputs a basic txt file.
	
	The script uses all default values and saves the document as a formatted text 
	file.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -HTML -VIServerName testvc.lab.com

	This parameter will output an HTML report, which is the default.
	
	The script uses all default values and saves the document as an HTML file.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -Full -VIServerName testvc.lab.com
	
	Creates a full inventory of the VMware environment. *Note: a full report can take 
	a considerable amount of time to generate.
	
	Outputs an HTML report.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -PDF -Full -VIServerName testvc.lab.com
	
	Creates a full inventory of the VMware environment. *Note: a full report can take 
	a considerable amount of time to generate.
	The script uses all Default values and save the document as a PDF file.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName=
	"Jacob Rutski" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Jacob Rutski"
	$env:username = Administrator

	Jacob Rutski for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.
.EXAMPLE
	PS C:\PSScript .\VMware_Inventory_V2.ps1 -MSWord -CompanyName "SeriousTek" 
	-CoverPage "Mod" -UserName "Jacob Rutski" -VIServerName testvc.lab.com

	The script uses:
		Jacob Rutski Consulting for the Company Name.
		Mod for the Cover Page format.
		Jacob Rutski for the User Name.
.EXAMPLE
    PS C:\PSScript .\VMware_Inventory_V2.ps1 -Export -VIServerName 
	testvc.lab.com

	The script uses all default values and uses testvc.lab.com as the vCenter Server.
    Script will output all data to XML files in the .\Export directory created
.EXAMPLE
	PS C:\PSScript .\VMware_Inventory_V2.ps1 -MSWord -CN "SeriousTek" -CP "Mod" 
	-UN "Jacob Rutski" -VIServerName testvc.lab.com

	The script uses:
		Jacob Rutski Consulting for the Company Name (alias CN).
		Mod for the Cover Page format (alias CP).
		Jacob Rutski for the User Name (alias UN).
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -AddDateTime -VIServerName 
	testvc.lab.com
	
	The script uses all Default values.
	Adds a date time stamp to the end of the file name.
	Time stamp is in the format of yyyy-MM-dd_HHmm.
	June 1, 2023 at 6PM is 2023-06-01_1800.
	Output filename will be vCenterServer_2023-06-01_1800.docx
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -PDF -AddDateTime -VIServerName 
	testvc.lab.com
	
	The script uses all Default values and saves the document as a PDF file.
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\CompanyName=
	"Jacob Rutski" or
	HKEY_CURRENT_USER\Software\Microsoft\Office\Common\UserInfo\Company="Jacob Rutski"
	$env:username = Administrator

	Jacob Rutski for the Company Name.
	Sideline for the Cover Page format.
	Administrator for the User Name.

	Adds a date time stamp to the end of the file name.
	Time stamp is in the format of yyyy-MM-dd_HHmm.
	June 1, 2023 at 6PM is 2023-06-01_1800.
	Output filename will be vCenterServerSiteName_2023-06-01_1800.pdf
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -Folder \\FileServer\ShareName 
	-VIServerName testvc.lab.com
	
	The script uses all default values.

	Output HTML file will be saved in the path \\FileServer\ShareName
.EXAMPLE
	PS C:\PSScript >.\VMware_Inventory_V2.ps1 -Dev -ScriptInfo -Log
	
	Creates the default HTML report.
	
	Creates a text file named VMwareDocScriptV2Errors_yyyyMMddTHHmmssffff.txt that 
	contains up to the last 250 errors reported by the script.
	
	Creates a text file named VMwareDocScriptV2Info_yyyy-MM-dd_HHmm.txt that contains 
	all the script parameters and other basic information.
	
	Creates a text file for transcript logging named 
	VMwareDocScriptV2Transcript_yyyyMMddTHHmmssffff.txt.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -SmtpServer mail.domain.tld -From 
	VMWAdmin@domain.tld -To ITGroup@domain.tld	

	The script uses the email server mail.domain.tld, sending from VMWAdmin@domain.tld 
	and sending to ITGroup@domain.tld.

	The script uses the default SMTP port 25 and does not use SSL.

	If the current user's credentials are not valid to send an email, the script 
	prompts the user to enter valid credentials.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -SmtpServer mailrelay.domain.tld -From 
	Anonymous@domain.tld -To ITGroup@domain.tld	

	***SENDING UNAUTHENTICATED EMAIL***

	The script uses the email server mailrelay.domain.tld, sending from 
	anonymous@domain.tld and sending to ITGroup@domain.tld.

	To send an unauthenticated email using an email relay server requires the From 
	email account to use the name Anonymous.

	The script uses the default SMTP port 25 and does not use SSL.
	
	***GMAIL/G SUITE SMTP RELAY***
	https://support.google.com/a/answer/2956491?hl=en
	https://support.google.com/a/answer/176600?hl=en

	To send an email using a Gmail or g-suite account, you may have to turn ON the 
	"Less secure app access" option on your account.
	***GMAIL/G SUITE SMTP RELAY***

	The script generates an anonymous, secure password for the anonymous@domain.tld 
	account.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -SmtpServer labaddomain-
	com.mail.protection.outlook.com -UseSSL -From SomeEmailAddress@labaddomain.com -To 
	ITGroupDL@labaddomain.com	

	***OFFICE 365 Example***

	https://docs.microsoft.com/en-us/exchange/mail-flow-best-practices/how-to-set-up-a-multifunction-device-or-application-to-send-email-using-office-3
	
	This uses Option 2 from the above link.
	
	***OFFICE 365 Example***

	The script uses the email server labaddomain-com.mail.protection.outlook.com, 
	sending from SomeEmailAddress@labaddomain.com and sending to 
	ITGroupDL@labaddomain.com.

	The script uses the default SMTP port 25 and SSL.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -SmtpServer smtp.office365.com -SmtpPort 
	587 -UseSSL -From Webster@CarlWebster.com -To ITGroup@CarlWebster.com	

	The script uses the email server smtp.office365.com on port 587 using SSL, sending 
	from webster@carlwebster.com and sending to ITGroup@carlwebster.com.

	If the current user's credentials are not valid to send an email, the script 
	prompts the user to enter valid credentials.
.EXAMPLE
	PS C:\PSScript > .\VMware_Inventory_V2.ps1 -SmtpServer smtp.gmail.com -SmtpPort 587 
	-UseSSL -From Webster@CarlWebster.com -To ITGroup@CarlWebster.com	

	*** NOTE ***
	To send an email using a Gmail or g-suite account, you may have to turn ON the 
	"Less secure app access" option on your account.
	*** NOTE ***
	
	The script uses the email server smtp.gmail.com on port 587 using SSL, sending from 
	webster@gmail.com and sending to ITGroup@carlwebster.com.

	If the current user's credentials are not valid to send an email, the script 
	prompts the user to enter valid credentials.
.INPUTS
	None.  You cannot pipe objects to this script.
.OUTPUTS
	No objects are output from this script.  
	This script creates a Word, PDF, Formatted Text or HTML document.
.NOTES
	NAME: VMware_Inventory_V2.ps1
	VERSION: 2.01
	AUTHOR: Jacob Rutski and Carl Webster
	LASTEDIT: June 24, 2023
#>

#endregion

#region script parameters
#thanks to @jeffwouters and Michael B. Smith for helping me with these parameters
[CmdletBinding(SupportsShouldProcess = $False, ConfirmImpact = "None", DefaultParameterSetName = "Word") ]

Param(
    [parameter(Mandatory=$False)]
    [Alias("VC")]
    [ValidateNotNullOrEmpty()]
    [string]$VIServerName="",
	
	[parameter(Mandatory=$False)] 
	[Switch]$HTML=$False,

	[parameter(Mandatory=$False)] 
	[Switch]$Text=$False,

	[parameter(Mandatory=$False)] 
	[Switch]$AddDateTime=$False,
	
	[parameter(Mandatory=$False)] 
	[string]$Folder="",

	[parameter(Mandatory=$False)] 
	[Switch]$Full=$False,	

    [parameter(Mandatory=$False)]
    [Switch]$Export=$False,

    [parameter(Mandatory=$False)]
    [Switch]$Import=$False,

	[parameter(Mandatory=$False)] 
	[Switch]$Dev=$False,
	
	[parameter(Mandatory=$False)] 
	[Switch]$Log=$False,
	
	[parameter(Mandatory=$False)] 
	[Alias("SI")]
	[Switch]$ScriptInfo=$False,
	
	[parameter(Mandatory=$False)] 
	[Alias("RF")]
	[Switch]$ReportFooter=$False,

    [parameter(Mandatory=$False)]
    [Switch]$Issues=$False,
	
    [parameter(Mandatory=$False)]
    [Switch]$PCLICustom=$False,

	[parameter(ParameterSetName="WordPDF",Mandatory=$False)] 
	[Switch]$MSWord=$False,

	[parameter(ParameterSetName="WordPDF",Mandatory=$False)] 
	[Switch]$PDF=$False,

    [parameter(ParameterSetName="WordPDF",Mandatory=$False)]
    [Switch]$Chart=$False,

	[parameter(ParameterSetName="WordPDF",Mandatory=$False)] 
	[Alias("CA")]
	[ValidateNotNullOrEmpty()]
	[string]$CompanyAddress="",
    
	[parameter(ParameterSetName="WordPDF",Mandatory=$False)] 
	[Alias("CE")]
	[ValidateNotNullOrEmpty()]
	[string]$CompanyEmail="",
    
	[parameter(ParameterSetName="WordPDF",Mandatory=$False)] 
	[Alias("CF")]
	[ValidateNotNullOrEmpty()]
	[string]$CompanyFax="",
    
	[parameter(ParameterSetName="WordPDF",Mandatory=$False)] 
	[Alias("CN")]
	[ValidateNotNullOrEmpty()]
	[string]$CompanyName="",
    
	[parameter(ParameterSetName="WordPDF",Mandatory=$False)] 
	[Alias("CPh")]
	[ValidateNotNullOrEmpty()]
	[string]$CompanyPhone="",
    
	[parameter(ParameterSetName="WordPDF",Mandatory=$False)] 
	[Alias("CP")]
	[ValidateNotNullOrEmpty()]
	[string]$CoverPage="Sideline", 

	[parameter(ParameterSetName="WordPDF",Mandatory=$False)] 
	[Alias("UN")]
	[ValidateNotNullOrEmpty()]
	[string]$UserName=$env:username,

	[parameter(Mandatory=$False)] 
	[string]$SmtpServer="",

	[parameter(Mandatory=$False)] 
	[int]$SmtpPort=25,

	[parameter(Mandatory=$False)] 
	[switch]$UseSSL=$False,

	[parameter(Mandatory=$False)] 
	[string]$From="",

	[parameter(Mandatory=$False)] 
	[string]$To=""
	
	)
#endregion

#region script change log	
#webster@carlwebster.com
#@carlwebster on Twitter
#http://www.CarlWebster.com
#Created on June 1, 2014

#HTML functions and sample text contributed by Ken Avram October 2014
#HTML Functions FormatHTMLTable and AddHTMLTable modified by Jake Rutski May 2015
#Organized functions into logical units 16-Oct-2014
#Added regions 16-Oct-2014

#VMware vCenter inventory
#Jacob Rutski
#jake@serioustek.net
#http://blogs.serioustek.net
#@JRutski on Twitter
#Created on November 3rd, 2014
#
#Version 2.01 24-Jun-2023
#	Fix bug that kept Virtual Distributed Switches data from being in the report
#	When using -Import and -Full, handle making sure the vCenter name is given
#	When using -Import and -Full, handle making sure the vCenter is disconnected when the script completes
#
#Version 2.00 21-Apr-2023
#	Allow multiple output formats. You can now select any combination of HTML, MSWord, PDF, or Text
#	Changed some Write-Error to Write-Warning and changed some Write-Warning to Write-Host
#	Changed the default output to HTML
#	Fixed remaining $Null comparisons where $null was on the right instead of the left of the comparison
#	Fixed some text formatting issues
#	If you select PDF for Output and Microsoft Word is not installed, update the error message to state that PDF uses Word's SaveAs PDF function
#	In Function BuildDRSGroupsRules, fixed variable $DRSGroupsRules not defined error
#	In Function OutputClusters, added explanations from VMware for each counter
#	In Function OutputResourcePools, fixed invalid property name Name
#	In Function OutputVirtualMachines, added explanations from VMware for each counter and fixed one wrong counter name
#	In Function OutputVMHost made changes to the VMware performance counters put in Charts by separating the counters instead of grouping
#		If one counter was not available, then no chart was created for any of the counters grouped together
#		Added explanations from VMware for each counter
#	Made minor changes to Function AddStatsChart
#	Reformatted most Write-Error messages to show better in the console
#	Removed all comments referencing versions before 2.00
#	Removed existing Script ParameterSets and left only one for "WordPDF"
#	Thanks to T.E.R. for testing with vCenter 8
#	Updated the following functions to the latest versions:
#		AddHTMLTable
#		AddWordTable
#		CheckWordPrereq
#		FormatHTMLTable
#		GetCulture
#		Line
#		ProcessDocumentOutput
#		SaveandCloseDocumentandShutdownWord
#		SaveandCloseHTMLDocument
#		SaveandCloseTextDocument
#		SetupHTML
#		SetupText
#		SetupWord
#		SetWordCellFormat
#		SetWordHashTable
#		ValidateCoverPage
#		WriteHTMLLine
#		WriteWordLine
#	Updated the help text
#	Updated the ReadMe file
#
#endregion


Function AbortScript
{
	If($MSWord -or $PDF)
	{
		Write-Verbose "$(Get-Date -Format G): System Cleanup"
		If(Test-Path variable:global:word)
		{
			$Script:Word.quit()
			[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Script:Word) | Out-Null
			Remove-Variable -Name word -Scope Global 4>$Null
		}
	}
	[gc]::collect() 
	[gc]::WaitForPendingFinalizers()

	If($MSWord -or $PDF)
	{
		#is the winword Process still running? kill it

		#find out our session (usually "1" except on TS/RDC or Citrix)
		$SessionID = (Get-Process -PID $PID).SessionId

		#Find out if winword running in our session
		$wordprocess = ((Get-Process 'WinWord' -ea 0) | Where-Object {$_.SessionId -eq $SessionID}) | Select-Object -Property Id 
		If( $wordprocess -and $wordprocess.Id -gt 0)
		{
			Write-Verbose "$(Get-Date -Format G): WinWord Process is still running. Attempting to stop WinWord Process # $($wordprocess.Id)"
			Stop-Process $wordprocess.Id -EA 0
		}
	}
	
	Write-Verbose "$(Get-Date -Format G): Script has been aborted"
	#stop transcript logging
	If($Log -eq $True) 
	{
		If($Script:StartLog -eq $True) 
		{
			try 
			{
				Stop-Transcript | Out-Null
				Write-Verbose "$(Get-Date -Format G): $Script:LogPath is ready for use"
			} 
			catch 
			{
				Write-Verbose "$(Get-Date -Format G): Transcript/log stop failed"
			}
		}
	}
	$ErrorActionPreference = $SaveEAPreference
	Exit
}

#region initial variable testing and setup
Set-StrictMode -Version 2

#force  on
$PSDefaultParameterValues = @{"*:Verbose"=$True}
$SaveEAPreference         = $ErrorActionPreference
$ErrorActionPreference    = 'SilentlyContinue'
$script:MyVersion         = '2.01'
$Script:ScriptName        = "VMware_Inventory_V2.ps1"
$tmpdate                  = [datetime] "06/24/2023"
$Script:ReleaseDate       = $tmpdate.ToUniversalTime().ToShortDateString()

If($Null -eq $HTML)
{
	If($Text -or $MSWord -or $PDF)
	{
		$HTML = $False
	}
	Else
	{
		$HTML = $True
	}
}

If($MSWord -eq $False -and $PDF -eq $False -and $Text -eq $False -and $HTML -eq $False)
{
	$HTML = $True
}

Write-Verbose "$(Get-Date -Format G): Testing output parameters"

If($MSWord)
{
	Write-Verbose "$(Get-Date -Format G): MSWord is set"
}
If($PDF)
{
	Write-Verbose "$(Get-Date -Format G): PDF is set"
}
If($Text)
{
	Write-Verbose "$(Get-Date -Format G): Text is set"
}
If($HTML)
{
	Write-Verbose "$(Get-Date -Format G): HTML is set"
}

If(![String]::IsNullOrEmpty($SmtpServer) -and [String]::IsNullOrEmpty($From) -and [String]::IsNullOrEmpty($To))
{
	Write-Error "
	`n`n
	`t`t
	You specified an SmtpServer but did not include a From or To email address.
	`n`n
	`t`t
	Script cannot continue.
	`n`n"
	AbortScript
}
If(![String]::IsNullOrEmpty($SmtpServer) -and [String]::IsNullOrEmpty($From) -and ![String]::IsNullOrEmpty($To))
{
	Write-Error "
	`n`n
	`t`t
	You specified an SmtpServer and a To email address but did not include a From email address.
	`n`n
	`t`t
	Script cannot continue.
	`n`n"
	AbortScript
}
If(![String]::IsNullOrEmpty($SmtpServer) -and [String]::IsNullOrEmpty($To) -and ![String]::IsNullOrEmpty($From))
{
	Write-Error "
	`n`n
	`t`t
	You specified an SmtpServer and a From email address but did not include a To email address.
	`n`n
	`t`t
	Script cannot continue.
	`n`n"
	AbortScript
}
If(![String]::IsNullOrEmpty($From) -and ![String]::IsNullOrEmpty($To) -and [String]::IsNullOrEmpty($SmtpServer))
{
	Write-Error "
	`n`n
	`t`t
	You specified From and To email addresses but did not include the SmtpServer.
	`n`n
	`t`t
	Script cannot continue.
	`n`n"
	AbortScript
}
If(![String]::IsNullOrEmpty($From) -and [String]::IsNullOrEmpty($SmtpServer))
{
	Write-Error "
	`n`n
	`t`t
	You specified a From email address but did not include the SmtpServer.
	`n`n
	`t`t
	Script cannot continue.
	`n`n"
	AbortScript
}
If(![String]::IsNullOrEmpty($To) -and [String]::IsNullOrEmpty($SmtpServer))
{
	Write-Error "
	`n`n
	`t`t
	You specified a To email address but did not include the SmtpServer.
	`n`n
	`t`t
	Script cannot continue.
	`n`n"
	AbortScript
}

#test if the Chart option is used and Word or PDF is not selected
If($Chart)
{
	If(($MSWord -eq $False) -and ($PDF -eq $False))
	{
		Write-Warning ""
		Write-Warning "
		`n`n
		`t`t
		The Chart option is only valid when MSWord or PDF is also selected.
		`n`n
		`t`t
		The Chart option is now disabled.
		`n`n
		"
		Write-Warning ""
		$Chart = $False
	}
}

If($Issues)
{
	Write-Verbose "$(Get-Date -Format G): Issues is set"
	$Full = $False
	$Import = $False
	$Export = $False
}

If($Full)
{
	Write-Host ""
	Write-Host "Full-Run is set. This will create a full VMware inventory and can take a significant amount of time."
	Write-Host ""
}

If($Export)
{
	Write-Host ""
	Write-Host "Export is set - Script will output to XML for later use, overriding all output parameters."
	Write-Host ""

	$HTML           = $False
	$MSWord         = $False
	$PDF            = $False
	$Text           = $False
	$AddDateTime    = $False
	$Chart          = $False
	$CompanyAddress = $Null
	$CompanyEmail   = $Null
	$CompanyFax     = $Null
	$CompanyName    = $Null
	$CompanyPhone   = $Null
	$CoverPage      = $Null
	$From           = $Null
	$Import         = $False
	$Issues         = $False
	$ReportFooter   = $False
	$SmtpServer     = ""
	$SmtpPort       = $Null
	$To             = $Null
	$UseSSL         = $False
	$UserName       = $Null
	
	Write-Host ""
	Write-Host "
	You specified the Export option. The following parameters are now set to False or Null.
	`t`t
	HTML
	MSWord
	PDF
	Text
	AddDateTime
	Chart
	CompanyAddress
	CompanyEmail
	CompanyFax
	CompanyName
	CompanyPhone
	CoverPage
	From
	Import
	Issues
	ReportFooter
	SmtpServer
	SmtpPort
	To
	UseSSL
	UserName
	" -ForegroundColor White
}

If(!($VIServerName) -and (($Import -and $Full) -or !($Import))) #2.01 handle situation when using both import and full
{
    $VIServerName = Read-Host 'Please enter the FQDN of your vCenter server'
}

If($Folder -ne "")
{
	Write-Verbose "$(Get-Date -Format G): Testing folder path"
	#does it exist
	If(Test-Path $Folder -EA 0)
	{
		#it exists, now check to see if it is a folder and not a file
		If(Test-Path $Folder -pathType Container -EA 0)
		{
			#it exists and it is a folder
			Write-Verbose "$(Get-Date -Format G): Folder path $Folder exists and is a folder"
		}
		Else
		{
			#it exists but it is a file not a folder
#Do not indent the following write-error lines. Doing so will mess up the console formatting of the error message.
			Write-Error "
			`n`n
	Folder $Folder is a file, not a folder.
			`n`n
	Script cannot continue.
			`n`n"
			AbortScript
		}
	}
	Else
	{
		#does not exist
		Write-Error "
		`n`n
	Folder $Folder does not exist.
		`n`n
	Script cannot continue.
		`n`n
		"
		AbortScript
	}
}

If($Folder -eq "")
{
	$Script:pwdpath = $pwd.Path
}
Else
{
	$Script:pwdpath = $Folder
}

If($Script:pwdpath.EndsWith("\"))
{
	#remove the trailing \
	$Script:pwdpath = $Script:pwdpath.SubString(0, ($Script:pwdpath.Length - 1))
}

If($Log) 
{
	#start transcript logging
	$Script:LogPath = "$Script:pwdpath\VMwareDocScriptV2Transcript_$(Get-Date -f FileDateTime).txt"
	
	try 
	{
		Start-Transcript -Path $Script:LogPath -Force -Verbose:$false | Out-Null
		Write-Verbose "$(Get-Date -Format G): Transcript/log started at $Script:LogPath"
		$Script:StartLog = $true
	} 
	catch 
	{
		Write-Verbose "$(Get-Date -Format G): Transcript/log failed at $Script:LogPath"
		$Script:StartLog = $false
	}
}

If($Dev)
{
	$Error.Clear()
	$Script:DevErrorFile = "$Script:pwdpath\VMwareInventoryScriptV2Errors_$(Get-Date -f FileDateTime).txt"
}

#endregion

#region initialize variables for word html and text
[string]$Script:RunningOS = (Get-WmiObject -class Win32_OperatingSystem -EA 0).Caption

If($MSWord -or $PDF)
{
	#try and fix the issue with the $CompanyName variable
	$Script:CoName = $CompanyName
	Write-Verbose "$(Get-Date -Format G): CoName is $($Script:CoName)"
	
	#the following values were attained from 
	#http://msdn.microsoft.com/en-us/library/office/aa211923(v=office.11).aspx
	[int]$wdAlignPageNumberRight  = 2
	[int]$wdMove                  = 0
	[int]$wdSeekMainDocument      = 0
	[int]$wdSeekPrimaryFooter     = 4
	[int]$wdStory                 = 6
	#[int]$wdColorBlack            = 0
	[int]$wdColorGray05           = 15987699 
	[int]$wdColorGray15           = 14277081
	#[int]$wdColorRed              = 255
	[int]$wdColorWhite            = 16777215
	#[int]$wdColorYellow           = 65535
	[int]$wdWord2007              = 12
	[int]$wdWord2010              = 14
	[int]$wdWord2013              = 15
	[int]$wdWord2016              = 16
	[int]$wdFormatDocumentDefault = 16
	[int]$wdFormatPDF             = 17
	#http://blogs.technet.com/b/heyscriptingguy/archive/2006/03/01/how-can-i-right-align-a-single-column-in-a-word-table.aspx
	#http://msdn.microsoft.com/en-us/library/office/ff835817%28v=office.15%29.aspx
	#[int]$wdAlignParagraphLeft   = 0
	#[int]$wdAlignParagraphCenter = 1
	#[int]$wdAlignParagraphRight  = 2
	#http://msdn.microsoft.com/en-us/library/office/ff193345%28v=office.15%29.aspx
	#[int]$wdCellAlignVerticalTop    = 0
	#[int]$wdCellAlignVerticalCenter = 1
	#[int]$wdCellAlignVerticalBottom = 2
	#http://msdn.microsoft.com/en-us/library/office/ff844856%28v=office.15%29.aspx
	[int]$wdAutoFitFixed   = 0
	[int]$wdAutoFitContent = 1
	#[int]$wdAutoFitWindow = 2
	#http://msdn.microsoft.com/en-us/library/office/ff821928%28v=office.15%29.aspx
	[int]$wdAdjustNone         = 0
	[int]$wdAdjustProportional = 1
	#[int]$wdAdjustFirstColumn = 2
	#[int]$wdAdjustSameWidth   = 3

	[int]$PointsPerTabStop = 36
	[int]$Indent0TabStops  = 0 * $PointsPerTabStop
	#[int]$Indent1TabStops = 1 * $PointsPerTabStop
	#[int]$Indent2TabStops = 2 * $PointsPerTabStop
	#[int]$Indent3TabStops = 3 * $PointsPerTabStop
	#[int]$Indent4TabStops = 4 * $PointsPerTabStop

	#http://www.thedoctools.com/index.php?show=wt_style_names_english_danish_german_french
	[int]$wdStyleHeading1         = -2
	[int]$wdStyleHeading2         = -3
	[int]$wdStyleHeading3         = -4
	[int]$wdStyleHeading4         = -5
	[int]$wdStyleNoSpacing        = -158
	[int]$wdTableGrid             = -155
	#[int]$wdTableLightListAccent3 = -206

	[int]$wdLineStyleNone       = 0
	[int]$wdLineStyleSingle     = 1
	[int]$wdHeadingFormatTrue   = -1
	#[int]$wdHeadingFormatFalse = 0 
	
	[string]$Script:RunningOS = (Get-WmiObject -class Win32_OperatingSystem -EA 0).Caption
}

If($HTML)
{
    $global:htmlredmask       = "#FF0000" 4>$Null
    $global:htmlcyanmask      = "#00FFFF" 4>$Null
    $global:htmlbluemask      = "#0000FF" 4>$Null
    $global:htmldarkbluemask  = "#0000A0" 4>$Null
    $global:htmllightbluemask = "#ADD8E6" 4>$Null
    $global:htmlpurplemask    = "#800080" 4>$Null
    $global:htmlyellowmask    = "#FFFF00" 4>$Null
    $global:htmllimemask      = "#00FF00" 4>$Null
    $global:htmlmagentamask   = "#FF00FF" 4>$Null
    $global:htmlwhitemask     = "#FFFFFF" 4>$Null
    $global:htmlsilvermask    = "#C0C0C0" 4>$Null
    $global:htmlgraymask      = "#808080" 4>$Null
    $global:htmlblackmask     = "#000000" 4>$Null
    $global:htmlorangemask    = "#FFA500" 4>$Null
    $global:htmlmaroonmask    = "#800000" 4>$Null
    $global:htmlgreenmask     = "#008000" 4>$Null
    $global:htmlolivemask     = "#808000" 4>$Null

    $global:htmlbold        = 1 4>$Null
    $global:htmlitalics     = 2 4>$Null
    $global:htmlred         = 4 4>$Null
    $global:htmlcyan        = 8 4>$Null
    $global:htmlblue        = 16 4>$Null
    $global:htmldarkblue    = 32 4>$Null
    $global:htmllightblue   = 64 4>$Null
    $global:htmlpurple      = 128 4>$Null
    $global:htmlyellow      = 256 4>$Null
    $global:htmllime        = 512 4>$Null
    $global:htmlmagenta     = 1024 4>$Null
    $global:htmlwhite       = 2048 4>$Null
    $global:htmlsilver      = 4096 4>$Null
    $global:htmlgray        = 8192 4>$Null
    $global:htmlolive       = 16384 4>$Null
    $global:htmlorange      = 32768 4>$Null
    $global:htmlmaroon      = 65536 4>$Null
    $global:htmlgreen       = 131072 4>$Null
	$global:htmlblack       = 262144 4>$Null

	$global:htmlsb          = ( $htmlsilver -bor $htmlBold ) ## point optimization

	$global:htmlColor = 
	@{
		$htmlred       = $htmlredmask
		$htmlcyan      = $htmlcyanmask
		$htmlblue      = $htmlbluemask
		$htmldarkblue  = $htmldarkbluemask
		$htmllightblue = $htmllightbluemask
		$htmlpurple    = $htmlpurplemask
		$htmlyellow    = $htmlyellowmask
		$htmllime      = $htmllimemask
		$htmlmagenta   = $htmlmagentamask
		$htmlwhite     = $htmlwhitemask
		$htmlsilver    = $htmlsilvermask
		$htmlgray      = $htmlgraymask
		$htmlolive     = $htmlolivemask
		$htmlorange    = $htmlorangemask
		$htmlmaroon    = $htmlmaroonmask
		$htmlgreen     = $htmlgreenmask
		$htmlblack     = $htmlblackmask
	}
}

If($TEXT)
{
	[System.Text.StringBuilder] $global:Output = New-Object System.Text.StringBuilder( 16384 )
}
#endregion

#region word specific functions
Function SetWordHashTable
{
	Param([string]$CultureCode)

	#optimized by Michael B. Smith
	
	# DE and FR translations for Word 2010 by Vladimir Radojevic
	# Vladimir.Radojevic@Commerzreal.com

	# DA translations for Word 2010 by Thomas Daugaard
	# Citrix Infrastructure Specialist at edgemo A/S

	# CA translations by Javier Sanchez 
	# CEO & Founder 101 Consulting

	#ca - Catalan
	#da - Danish
	#de - German
	#en - English
	#es - Spanish
	#fi - Finnish
	#fr - French
	#nb - Norwegian
	#nl - Dutch
	#pt - Portuguese
	#sv - Swedish
	#zh - Chinese
	
	[string]$toc = $(
		Switch ($CultureCode)
		{
			'ca-'	{ 'Taula automática 2'; Break }
			'da-'	{ 'Automatisk tabel 2'; Break }
			#'de-'	{ 'Automatische Tabelle 2'; Break }
			'de-'	{ 'Automatisches Verzeichnis 2'; Break }
			'en-'	{ 'Automatic Table 2'; Break }
			'es-'	{ 'Tabla automática 2'; Break }
			'fi-'	{ 'Automaattinen taulukko 2'; Break }
			'fr-'	{ 'Table automatique 2'; Break } #changed 10-feb-2017 david roquier and samuel legrand
			'nb-'	{ 'Automatisk tabell 2'; Break }
			'nl-'	{ 'Automatische inhoudsopgave 2'; Break }
			'pt-'	{ 'Sumário Automático 2'; Break }
			'sv-'	{ 'Automatisk innehållsförteckn2'; Break }
			'zh-'	{ '自动目录 2'; Break }
		}
	)

	$Script:myHash                      = @{}
	$Script:myHash.Word_TableOfContents = $toc
	$Script:myHash.Word_NoSpacing       = $wdStyleNoSpacing
	$Script:myHash.Word_Heading1        = $wdStyleheading1
	$Script:myHash.Word_Heading2        = $wdStyleheading2
	$Script:myHash.Word_Heading3        = $wdStyleheading3
	$Script:myHash.Word_Heading4        = $wdStyleheading4
	$Script:myHash.Word_TableGrid       = $wdTableGrid
}

Function GetCulture
{
	Param([int]$WordValue)
	
	#http://msdn.microsoft.com/en-us/library/bb213877(v=office.12).aspx
	$CatalanArray = 1027
	$ChineseArray = 2052,3076,5124,4100
	$DanishArray = 1030
	$DutchArray = 2067, 1043
	$EnglishArray = 3081, 10249, 4105, 9225, 6153, 8201, 5129, 13321, 7177, 11273, 2057, 1033, 12297
	$FinnishArray = 1035
	$FrenchArray = 2060, 1036, 11276, 3084, 12300, 5132, 13324, 6156, 8204, 10252, 7180, 9228, 4108
	$GermanArray = 1031, 3079, 5127, 4103, 2055
	$NorwegianArray = 1044, 2068
	$PortugueseArray = 1046, 2070
	$SpanishArray = 1034, 11274, 16394, 13322, 9226, 5130, 7178, 12298, 17418, 4106, 18442, 19466, 6154, 15370, 10250, 20490, 3082, 14346, 8202
	$SwedishArray = 1053, 2077

	#ca - Catalan
	#da - Danish
	#de - German
	#en - English
	#es - Spanish
	#fi - Finnish
	#fr - French
	#nb - Norwegian
	#nl - Dutch
	#pt - Portuguese
	#sv - Swedish
	#zh - Chinese

	Switch ($WordValue)
	{
		{$CatalanArray -contains $_}	{$CultureCode = "ca-"}
		{$ChineseArray -contains $_}	{$CultureCode = "zh-"}
		{$DanishArray -contains $_}		{$CultureCode = "da-"}
		{$DutchArray -contains $_}		{$CultureCode = "nl-"}
		{$EnglishArray -contains $_}	{$CultureCode = "en-"}
		{$FinnishArray -contains $_}	{$CultureCode = "fi-"}
		{$FrenchArray -contains $_}		{$CultureCode = "fr-"}
		{$GermanArray -contains $_}		{$CultureCode = "de-"}
		{$NorwegianArray -contains $_}	{$CultureCode = "nb-"}
		{$PortugueseArray -contains $_}	{$CultureCode = "pt-"}
		{$SpanishArray -contains $_}	{$CultureCode = "es-"}
		{$SwedishArray -contains $_}	{$CultureCode = "sv-"}
		Default {$CultureCode = "en-"}
	}
	
	Return $CultureCode
}

Function ValidateCoverPage
{
	Param([int]$xWordVersion, [string]$xCP, [string]$CultureCode)
	
	$xArray = ""
	
	Switch ($CultureCode)
	{
		'ca-'	{
				If($xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Austin", "En bandes", "Faceta", "Filigrana",
					"Integral", "Ió (clar)", "Ió (fosc)", "Línia lateral",
					"Moviment", "Quadrícula", "Retrospectiu", "Sector (clar)",
					"Sector (fosc)", "Semàfor", "Visualització principal", "Whisp")
				}
				ElseIf($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Austin", "En bandes", "Faceta", "Filigrana",
					"Integral", "Ió (clar)", "Ió (fosc)", "Línia lateral",
					"Moviment", "Quadrícula", "Retrospectiu", "Sector (clar)",
					"Sector (fosc)", "Semàfor", "Visualització", "Whisp")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabet", "Anual", "Austin", "Conservador",
					"Contrast", "Cubicles", "Diplomàtic", "Exposició",
					"Línia lateral", "Mod", "Mosiac", "Moviment", "Paper de diari",
					"Perspectiva", "Piles", "Quadrícula", "Sobri",
					"Transcendir", "Trencaclosques")
				}
			}

		'da-'	{
				If($xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Austin", "BevægElse", "Brusen", "Facet", "Filigran", 
					"Gitter", "Integral", "Ion (lys)", "Ion (mørk)", 
					"Retro", "Semafor", "Sidelinje", "Stribet", 
					"Udsnit (lys)", "Udsnit (mørk)", "Visningsmaster")
				}
				ElseIf($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("BevægElse", "Brusen", "Ion (lys)", "Filigran",
					"Retro", "Semafor", "Visningsmaster", "Integral",
					"Facet", "Gitter", "Stribet", "Sidelinje", "Udsnit (lys)",
					"Udsnit (mørk)", "Ion (mørk)", "Austin")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("BevægElse", "Moderat", "Perspektiv", "Firkanter",
					"Overskrid", "Alfabet", "Kontrast", "Stakke", "Fliser", "Gåde",
					"Gitter", "Austin", "Eksponering", "Sidelinje", "Enkel",
					"Nålestribet", "Årlig", "Avispapir", "Tradionel")
				}
			}

		'de-'	{
				If($xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Austin", "Bewegung", "Facette", "Filigran", 
					"Gebändert", "Integral", "Ion (dunkel)", "Ion (hell)", 
					"Pfiff", "Randlinie", "Raster", "Rückblick", 
					"Segment (dunkel)", "Segment (hell)", "Semaphor", 
					"ViewMaster")
				}
				ElseIf($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Semaphor", "Segment (hell)", "Ion (hell)",
					"Raster", "Ion (dunkel)", "Filigran", "Rückblick", "Pfiff",
					"ViewMaster", "Segment (dunkel)", "Verbunden", "Bewegung",
					"Randlinie", "Austin", "Integral", "Facette")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alphabet", "Austin", "Bewegung", "Durchscheinend",
					"Herausgestellt", "Jährlich", "Kacheln", "Kontrast", "Kubistisch",
					"Modern", "Nadelstreifen", "Perspektive", "Puzzle", "Randlinie",
					"Raster", "Schlicht", "Stapel", "Traditionell", "Zeitungspapier")
				}
			}

		'en-'	{
				If($xWordVersion -eq $wdWord2013 -or $xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Austin", "Banded", "Facet", "Filigree", "Grid",
					"Integral", "Ion (Dark)", "Ion (Light)", "Motion", "Retrospect",
					"Semaphore", "Sideline", "Slice (Dark)", "Slice (Light)", "ViewMaster",
					"Whisp")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alphabet", "Annual", "Austere", "Austin", "Conservative",
					"Contrast", "Cubicles", "Exposure", "Grid", "Mod", "Motion", "Newsprint",
					"Perspective", "Pinstripes", "Puzzle", "Sideline", "Stacks", "Tiles", "Transcend")
				}
			}

		'es-'	{
				If($xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Austin", "Con bandas", "Cortar (oscuro)", "Cuadrícula", 
					"Whisp", "Faceta", "Filigrana", "Integral", "Ion (claro)", 
					"Ion (oscuro)", "Línea lateral", "Movimiento", "Retrospectiva", 
					"Semáforo", "Slice (luz)", "Vista principal", "Whisp")
				}
				ElseIf($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Whisp", "Vista principal", "Filigrana", "Austin",
					"Slice (luz)", "Faceta", "Semáforo", "Retrospectiva", "Cuadrícula",
					"Movimiento", "Cortar (oscuro)", "Línea lateral", "Ion (oscuro)",
					"Ion (claro)", "Integral", "Con bandas")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabeto", "Anual", "Austero", "Austin", "Conservador",
					"Contraste", "Cuadrícula", "Cubículos", "Exposición", "Línea lateral",
					"Moderno", "Mosaicos", "Movimiento", "Papel periódico",
					"Perspectiva", "Pilas", "Puzzle", "Rayas", "Sobrepasar")
				}
			}

		'fi-'	{
				If($xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Filigraani", "Integraali", "Ioni (tumma)",
					"Ioni (vaalea)", "Opastin", "Pinta", "Retro", "Sektori (tumma)",
					"Sektori (vaalea)", "Vaihtuvavärinen", "ViewMaster", "Austin",
					"Kuiskaus", "Liike", "Ruudukko", "Sivussa")
				}
				ElseIf($xWordVersion -eq $wdWord2013)
				{
					$xArray = ("Filigraani", "Integraali", "Ioni (tumma)",
					"Ioni (vaalea)", "Opastin", "Pinta", "Retro", "Sektori (tumma)",
					"Sektori (vaalea)", "Vaihtuvavärinen", "ViewMaster", "Austin",
					"Kiehkura", "Liike", "Ruudukko", "Sivussa")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Aakkoset", "Askeettinen", "Austin", "Kontrasti",
					"Laatikot", "Liike", "Liituraita", "Mod", "Osittain peitossa",
					"Palapeli", "Perinteinen", "Perspektiivi", "Pinot", "Ruudukko",
					"Ruudut", "Sanomalehtipaperi", "Sivussa", "Vuotuinen", "Ylitys")
				}
			}

		'fr-'	{
				If($xWordVersion -eq $wdWord2013 -or $xWordVersion -eq $wdWord2016)
				{
					$xArray = ("À bandes", "Austin", "Facette", "Filigrane", 
					"Guide", "Intégrale", "Ion (clair)", "Ion (foncé)", 
					"Lignes latérales", "Quadrillage", "Rétrospective", "Secteur (clair)", 
					"Secteur (foncé)", "Sémaphore", "ViewMaster", "Whisp")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alphabet", "Annuel", "Austère", "Austin", 
					"Blocs empilés", "Classique", "Contraste", "Emplacements de bureau", 
					"Exposition", "Guide", "Ligne latérale", "Moderne", 
					"Mosaïques", "Mots croisés", "Papier journal", "Perspective",
					"Quadrillage", "Rayures fines", "Transcendant")
				}
			}

		'nb-'	{
				If($xWordVersion -eq $wdWord2013 -or $xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Austin", "BevegElse", "Dempet", "Fasett", "Filigran",
					"Integral", "Ion (lys)", "Ion (mørk)", "Retrospekt", "Rutenett",
					"Sektor (lys)", "Sektor (mørk)", "Semafor", "Sidelinje", "Stripet",
					"ViewMaster")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabet", "Årlig", "Avistrykk", "Austin", "Avlukker",
					"BevegElse", "Engasjement", "Enkel", "Fliser", "Konservativ",
					"Kontrast", "Mod", "Perspektiv", "Puslespill", "Rutenett", "Sidelinje",
					"Smale striper", "Stabler", "Transcenderende")
				}
			}

		'nl-'	{
				If($xWordVersion -eq $wdWord2013 -or $xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Austin", "Beweging", "Facet", "Filigraan", "Gestreept",
					"Integraal", "Ion (donker)", "Ion (licht)", "Raster",
					"Segment (Light)", "Semafoor", "Slice (donker)", "Spriet",
					"Terugblik", "Terzijde", "ViewMaster")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Aantrekkelijk", "Alfabet", "Austin", "Bescheiden",
					"Beweging", "Blikvanger", "Contrast", "Eenvoudig", "Jaarlijks",
					"Krantenpapier", "Krijtstreep", "Kubussen", "Mod", "Perspectief",
					"Puzzel", "Raster", "Stapels",
					"Tegels", "Terzijde")
				}
			}

		'pt-'	{
				If($xWordVersion -eq $wdWord2013 -or $xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Animação", "Austin", "Em Tiras", "Exibição Mestra",
					"Faceta", "Fatia (Clara)", "Fatia (Escura)", "Filete", "Filigrana", 
					"Grade", "Integral", "Íon (Claro)", "Íon (Escuro)", "Linha Lateral",
					"Retrospectiva", "Semáforo")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabeto", "Animação", "Anual", "Austero", "Austin", "Baias",
					"Conservador", "Contraste", "Exposição", "Grade", "Ladrilhos",
					"Linha Lateral", "Listras", "Mod", "Papel Jornal", "Perspectiva", "Pilhas",
					"Quebra-cabeça", "Transcend")
				}
			}

		'sv-'	{
				If($xWordVersion -eq $wdWord2013 -or $xWordVersion -eq $wdWord2016)
				{
					$xArray = ("Austin", "Band", "Fasett", "Filigran", "Integrerad", "Jon (ljust)",
					"Jon (mörkt)", "Knippe", "Rutnät", "RörElse", "Sektor (ljus)", "Sektor (mörk)",
					"Semafor", "Sidlinje", "VisaHuvudsida", "Återblick")
				}
				ElseIf($xWordVersion -eq $wdWord2010)
				{
					$xArray = ("Alfabetmönster", "Austin", "Enkelt", "Exponering", "Konservativt",
					"Kontrast", "Kritstreck", "Kuber", "Perspektiv", "Plattor", "Pussel", "Rutnät",
					"RörElse", "Sidlinje", "Sobert", "Staplat", "Tidningspapper", "Årligt",
					"Övergående")
				}
			}

		'zh-'	{
				If($xWordVersion -eq $wdWord2010 -or $xWordVersion -eq $wdWord2013 -or $xWordVersion -eq $wdWord2016)
				{
					$xArray = ('奥斯汀', '边线型', '花丝', '怀旧', '积分',
					'离子(浅色)', '离子(深色)', '母版型', '平面', '切片(浅色)',
					'切片(深色)', '丝状', '网格', '镶边', '信号灯',
					'运动型')
				}
			}

		Default	{
					If($xWordVersion -eq $wdWord2013 -or $xWordVersion -eq $wdWord2016)
					{
						$xArray = ("Austin", "Banded", "Facet", "Filigree", "Grid",
						"Integral", "Ion (Dark)", "Ion (Light)", "Motion", "Retrospect",
						"Semaphore", "Sideline", "Slice (Dark)", "Slice (Light)", "ViewMaster",
						"Whisp")
					}
					ElseIf($xWordVersion -eq $wdWord2010)
					{
						$xArray = ("Alphabet", "Annual", "Austere", "Austin", "Conservative",
						"Contrast", "Cubicles", "Exposure", "Grid", "Mod", "Motion", "Newsprint",
						"Perspective", "Pinstripes", "Puzzle", "Sideline", "Stacks", "Tiles", "Transcend")
					}
				}
	}
	
	If($xArray -contains $xCP)
	{
		$xArray = $Null
		Return $True
	}
	Else
	{
		$xArray = $Null
		Return $False
	}
}

Function CheckWordPrereq
{
	If((Test-Path  REGISTRY::HKEY_CLASSES_ROOT\Word.Application) -eq $False)
	{
		$ErrorActionPreference = $SaveEAPreference
		
		If(($MSWord -eq $False) -and ($PDF -eq $True))
		{
			Write-Host "`n`n`t`tThis script uses Microsoft Word's SaveAs PDF function, please install Microsoft Word`n`n"
			AbortScript
		}
		Else
		{
			Write-Host "`n`n`t`tThis script directly outputs to Microsoft Word, please install Microsoft Word`n`n"
			AbortScript
		}
	}

	#find out our session (usually "1" except on TS/RDC or Citrix)
	$SessionID = (Get-Process -PID $PID).SessionId
	
	#Find out if winword is running in our session
	[bool]$wordrunning = $null –ne ((Get-Process 'WinWord' -ea 0) | Where-Object {$_.SessionId -eq $SessionID})
	If($wordrunning)
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Host "`n`n`tPlease close all instances of Microsoft Word before running this report.`n`n"
		AbortScript
	}
}

Function ValidateCompanyName
{
	[bool]$xResult = Test-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "CompanyName"
	If($xResult)
	{
		Return Get-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "CompanyName"
	}
	Else
	{
		$xResult = Test-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "Company"
		If($xResult)
		{
			Return Get-RegistryValue "HKCU:\Software\Microsoft\Office\Common\UserInfo" "Company"
		}
		Else
		{
			Return ""
		}
	}
}

Function Set-DocumentProperty {
    <#
	.SYNOPSIS
	Function to set the Title Page document properties in MS Word
	.DESCRIPTION
	Long description
	.PARAMETER Document
	Current Document Object
	.PARAMETER DocProperty
	Parameter description
	.PARAMETER Value
	Parameter description
	.EXAMPLE
	Set-DocumentProperty -Document $Script:Doc -DocProperty Title -Value 'MyTitle'
	.EXAMPLE
	Set-DocumentProperty -Document $Script:Doc -DocProperty Company -Value 'MyCompany'
	.EXAMPLE
	Set-DocumentProperty -Document $Script:Doc -DocProperty Author -Value 'Jim Moyle'
	.EXAMPLE
	Set-DocumentProperty -Document $Script:Doc -DocProperty Subject -Value 'MySubjectTitle'
	.NOTES
	Function Created by Jim Moyle June 2017
	Twitter : @JimMoyle
	#>
    param (
        [object]$Document,
        [String]$DocProperty,
        [string]$Value
    )
    try {
        $binding = "System.Reflection.BindingFlags" -as [type]
        $builtInProperties = $Document.BuiltInDocumentProperties
        $property = [System.__ComObject].invokemember("item", $binding::GetProperty, $null, $BuiltinProperties, $DocProperty)
        [System.__ComObject].invokemember("value", $binding::SetProperty, $null, $property, $Value)
    }
    catch {
        Write-Warning "Failed to set $DocProperty to $Value"
    }
}

Function FindWordDocumentEnd
{
	#return focus to main document    
	$Script:Doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument
	#move to the end of the current document
	$Script:Selection.EndKey($wdStory,$wdMove) | Out-Null
}

Function SetupWord
{
	Write-Verbose "$(Get-Date -Format G): Setting up Word"
    
	If(!$AddDateTime)
	{
		[string]$Script:WordFileName = "$($Script:pwdpath)\$($OutputFileName).docx"
		If($PDF)
		{
			[string]$Script:PDFFileName = "$($Script:pwdpath)\$($OutputFileName).pdf"
		}
	}
	ElseIf($AddDateTime)
	{
		[string]$Script:WordFileName = "$($Script:pwdpath)\$($OutputFileName)_$(Get-Date -f yyyy-MM-dd_HHmm).docx"
		If($PDF)
		{
			[string]$Script:PDFFileName = "$($Script:pwdpath)\$($OutputFileName)_$(Get-Date -f yyyy-MM-dd_HHmm).pdf"
		}
	}

	# Setup word for output
	Write-Verbose "$(Get-Date -Format G): Create Word comObject."
	$Script:Word = New-Object -comobject "Word.Application" -EA 0 4>$Null

#Do not indent the following write-error lines. Doing so will mess up the console formatting of the error message.
	If(!$? -or $Null -eq $Script:Word)
	{
		Write-Warning "The Word object could not be created. You may need to repair your Word installation."
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "
		`n`n
	The Word object could not be created. You may need to repair your Word installation.
		`n`n
	Script cannot Continue.
		`n`n"
		AbortScript
	}

	Write-Verbose "$(Get-Date -Format G): Determine Word language value"
	If( ( validStateProp $Script:Word Language Value__ ) )
	{
		[int]$Script:WordLanguageValue = [int]$Script:Word.Language.Value__
	}
	Else
	{
		[int]$Script:WordLanguageValue = [int]$Script:Word.Language
	}

	If(!($Script:WordLanguageValue -gt -1))
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "
		`n`n
	Unable to determine the Word language value. You may need to repair your Word installation.
		`n`n
	Script cannot Continue.
		`n`n
		"
		AbortScript
	}
	Write-Verbose "$(Get-Date -Format G): Word language value is $($Script:WordLanguageValue)"
	
	$Script:WordCultureCode = GetCulture $Script:WordLanguageValue
	
	SetWordHashTable $Script:WordCultureCode
	
	[int]$Script:WordVersion = [int]$Script:Word.Version
	If($Script:WordVersion -eq $wdWord2016)
	{
		$Script:WordProduct = "Word 2016"
	}
	ElseIf($Script:WordVersion -eq $wdWord2013)
	{
		$Script:WordProduct = "Word 2013"
	}
	ElseIf($Script:WordVersion -eq $wdWord2010)
	{
		$Script:WordProduct = "Word 2010"
	}
	ElseIf($Script:WordVersion -eq $wdWord2007)
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "
		`n`n
	Microsoft Word 2007 is no longer supported.`n`n`t`tScript will end.
		`n`n
		"
		AbortScript
	}
	ElseIf($Script:WordVersion -eq 0)
	{
		Write-Error "
		`n`n
	The Word Version is 0. You should run a full online repair of your Office installation.
		`n`n
	Script cannot Continue.
		`n`n
		"
		AbortScript
	}
	Else
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "
		`n`n
	You are running an untested or unsupported version of Microsoft Word.
		`n`n
	Script will end.
		`n`n
	Please send info on your version of Word to webster@carlwebster.com
		`n`n
		"
		AbortScript
	}

	#only validate CompanyName if the field is blank
	If([String]::IsNullOrEmpty($CompanyName))
	{
		Write-Verbose "$(Get-Date -Format G): Company name is blank. Retrieve company name from registry."
		$TmpName = ValidateCompanyName
		
		If([String]::IsNullOrEmpty($TmpName))
		{
			Write-Host "
		Company Name is blank so Cover Page will not show a Company Name.
		Check HKCU:\Software\Microsoft\Office\Common\UserInfo for Company or CompanyName value.
		You may want to use the -CompanyName parameter if you need a Company Name on the cover page.
			" -Foreground White
			$Script:CoName = $TmpName
		}
		Else
		{
			$Script:CoName = $TmpName
			Write-Verbose "$(Get-Date -Format G): Updated company name to $($Script:CoName)"
		}
	}
	Else
	{
		$Script:CoName = $CompanyName
	}

	If($Script:WordCultureCode -ne "en-")
	{
		Write-Verbose "$(Get-Date -Format G): Check Default Cover Page for $($WordCultureCode)"
		[bool]$CPChanged = $False
		Switch ($Script:WordCultureCode)
		{
			'ca-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Línia lateral"
						$CPChanged = $True
					}
				}

			'da-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Sidelinje"
						$CPChanged = $True
					}
				}

			'de-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Randlinie"
						$CPChanged = $True
					}
				}

			'es-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Línea lateral"
						$CPChanged = $True
					}
				}

			'fi-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Sivussa"
						$CPChanged = $True
					}
				}

			'fr-'	{
					If($CoverPage -eq "Sideline")
					{
						If($Script:WordVersion -eq $wdWord2013 -or $Script:WordVersion -eq $wdWord2016)
						{
							$CoverPage = "Lignes latérales"
							$CPChanged = $True
						}
						Else
						{
							$CoverPage = "Ligne latérale"
							$CPChanged = $True
						}
					}
				}

			'nb-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Sidelinje"
						$CPChanged = $True
					}
				}

			'nl-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Terzijde"
						$CPChanged = $True
					}
				}

			'pt-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Linha Lateral"
						$CPChanged = $True
					}
				}

			'sv-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "Sidlinje"
						$CPChanged = $True
					}
				}

			'zh-'	{
					If($CoverPage -eq "Sideline")
					{
						$CoverPage = "边线型"
						$CPChanged = $True
					}
				}
		}

		If($CPChanged)
		{
			Write-Verbose "$(Get-Date -Format G): Changed Default Cover Page from Sideline to $($CoverPage)"
		}
	}

	Write-Verbose "$(Get-Date -Format G): Validate cover page $($CoverPage) for culture code $($Script:WordCultureCode)"
	[bool]$ValidCP = $False
	
	$ValidCP = ValidateCoverPage $Script:WordVersion $CoverPage $Script:WordCultureCode
	
	If(!$ValidCP)
	{
		$ErrorActionPreference = $SaveEAPreference
		Write-Verbose "$(Get-Date -Format G): Word language value $($Script:WordLanguageValue)"
		Write-Verbose "$(Get-Date -Format G): Culture code $($Script:WordCultureCode)"
		Write-Error "
		`n`n
	For $($Script:WordProduct), $($CoverPage) is not a valid Cover Page option.
		`n`n
	Script cannot Continue.
		`n`n
		"
		AbortScript
	}

	$Script:Word.Visible = $False

	#http://jdhitsolutions.com/blog/2012/05/san-diego-2012-powershell-deep-dive-slides-and-demos/
	#using Jeff's Demo-WordReport.ps1 file for examples
	Write-Verbose "$(Get-Date -Format G): Load Word Templates"

	[bool]$Script:CoverPagesExist = $False
	[bool]$BuildingBlocksExist = $False

	$Script:Word.Templates.LoadBuildingBlocks()
	#word 2010/2013/2016
	$BuildingBlocksCollection = $Script:Word.Templates | Where-Object{$_.name -eq "Built-In Building Blocks.dotx"}

	Write-Verbose "$(Get-Date -Format G): Attempt to load cover page $($CoverPage)"
	$part = $Null

	$BuildingBlocksCollection | 
	ForEach-Object {
		If ($_.BuildingBlockEntries.Item($CoverPage).Name -eq $CoverPage) 
		{
			$BuildingBlocks = $_
		}
	}        

	If($Null -ne $BuildingBlocks)
	{
		$BuildingBlocksExist = $True

		Try 
		{
			$part = $BuildingBlocks.BuildingBlockEntries.Item($CoverPage)
		}

		Catch
		{
			$part = $Null
		}

		If($Null -ne $part)
		{
			$Script:CoverPagesExist = $True
		}
	}

	If(!$Script:CoverPagesExist)
	{
		Write-Verbose "$(Get-Date -Format G): Cover Pages are not installed or the Cover Page $($CoverPage) does not exist."
		Write-Host "Cover Pages are not installed or the Cover Page $($CoverPage) does not exist." -Foreground White
		Write-Host "This report will not have a Cover Page." -Foreground White
	}

	Write-Verbose "$(Get-Date -Format G): Create empty word doc"
	$Script:Doc = $Script:Word.Documents.Add()
	If($Null -eq $Script:Doc)
	{
		Write-Verbose "$(Get-Date -Format G): "
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "
		`n`n
	An empty Word document could not be created. You may need to repair your Word installation.
		`n`n
	Script cannot Continue.
		`n`n"
		AbortScript
	}

	$Script:Selection = $Script:Word.Selection
	If($Null -eq $Script:Selection)
	{
		Write-Verbose "$(Get-Date -Format G): "
		$ErrorActionPreference = $SaveEAPreference
		Write-Error "
		`n`n
	An unknown error happened selecting the entire Word document for default formatting options.
		`n`n
	Script cannot Continue.
		`n`n"
		AbortScript
	}

	#set Default tab stops to 1/2 inch (this line is not from Jeff Hicks)
	#36 =.50"
	$Script:Word.ActiveDocument.DefaultTabStop = 36

	#Disable Spell and Grammar Check to resolve issue and improve performance (from Pat Coughlin)
	Write-Verbose "$(Get-Date -Format G): Disable grammar and spell checking"
	#bug reported 1-Apr-2014 by Tim Mangan
	#save current options first before turning them off
	$Script:CurrentGrammarOption = $Script:Word.Options.CheckGrammarAsYouType
	$Script:CurrentSpellingOption = $Script:Word.Options.CheckSpellingAsYouType
	$Script:Word.Options.CheckGrammarAsYouType = $False
	$Script:Word.Options.CheckSpellingAsYouType = $False

	If($BuildingBlocksExist)
	{
		#insert new page, getting ready for table of contents
		Write-Verbose "$(Get-Date -Format G): Insert new page, getting ready for table of contents"
		$part.Insert($Script:Selection.Range,$True) | Out-Null
		$Script:Selection.InsertNewPage()

		#table of contents
		Write-Verbose "$(Get-Date -Format G): Table of Contents - $($Script:MyHash.Word_TableOfContents)"
		$toc = $BuildingBlocks.BuildingBlockEntries.Item($Script:MyHash.Word_TableOfContents)
		If($Null -eq $toc)
		{
			Write-Verbose "$(Get-Date -Format G): "
			Write-Host "Table of Content - $($Script:MyHash.Word_TableOfContents) could not be retrieved." -Foreground White
			Write-Host "This report will not have a Table of Contents." -Foreground White
		}
		Else
		{
			$toc.insert($Script:Selection.Range,$True) | Out-Null
		}
	}
	Else
	{
		Write-Host "Table of Contents are not installed." -Foreground White
		Write-Host "Table of Contents are not installed so this report will not have a Table of Contents." -Foreground White
	}

	#set the footer
	Write-Verbose "$(Get-Date -Format G): Set the footer"
	[string]$footertext = "Report created by $username"

	#get the footer
	Write-Verbose "$(Get-Date -Format G): Get the footer and format font"
	$Script:Doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekPrimaryFooter
	#get the footer and format font
	$footers = $Script:Doc.Sections.Last.Footers
	ForEach ($footer in $footers) 
	{
		If($footer.exists) 
		{
			$footer.range.Font.name = "Calibri"
			$footer.range.Font.size = 8
			$footer.range.Font.Italic = $True
			$footer.range.Font.Bold = $True
		}
	} #end ForEach
	Write-Verbose "$(Get-Date -Format G): Footer text"
	$Script:Selection.HeaderFooter.Range.Text = $footerText

	#add page numbering
	Write-Verbose "$(Get-Date -Format G): Add page numbering"
	$Script:Selection.HeaderFooter.PageNumbers.Add($wdAlignPageNumberRight) | Out-Null

	FindWordDocumentEnd
	#end of Jeff Hicks 
}

Function UpdateDocumentProperties
{
	Param([string]$AbstractTitle, [string]$SubjectTitle)
	#updated 8-Jun-2017 with additional cover page fields
	#Update document properties
	If($MSWORD -or $PDF)
	{
		If($Script:CoverPagesExist)
		{
			Write-Verbose "$(Get-Date -Format G): Set Cover Page Properties"
			#8-Jun-2017 put these 4 items in alpha order
            Set-DocumentProperty -Document $Script:Doc -DocProperty Author -Value $UserName
            Set-DocumentProperty -Document $Script:Doc -DocProperty Company -Value $Script:CoName
            Set-DocumentProperty -Document $Script:Doc -DocProperty Subject -Value $SubjectTitle
            Set-DocumentProperty -Document $Script:Doc -DocProperty Title -Value $Script:title

			#Get the Coverpage XML part
			$cp = $Script:Doc.CustomXMLParts | Where-Object{$_.NamespaceURI -match "coverPageProps$"}

			#get the abstract XML part
			$ab = $cp.documentelement.ChildNodes | Where-Object{$_.basename -eq "Abstract"}
			#set the text
			If([String]::IsNullOrEmpty($Script:CoName))
			{
				[string]$abstract = $AbstractTitle
			}
			Else
			{
				[string]$abstract = "$($AbstractTitle) for $($Script:CoName)"
			}
			$ab.Text = $abstract

			#added 8-Jun-2017
			$ab = $cp.documentelement.ChildNodes | Where-Object{$_.basename -eq "CompanyAddress"}
			#set the text
			[string]$abstract = $CompanyAddress
			$ab.Text = $abstract

			#added 8-Jun-2017
			$ab = $cp.documentelement.ChildNodes | Where-Object{$_.basename -eq "CompanyEmail"}
			#set the text
			[string]$abstract = $CompanyEmail
			$ab.Text = $abstract

			#added 8-Jun-2017
			$ab = $cp.documentelement.ChildNodes | Where-Object{$_.basename -eq "CompanyFax"}
			#set the text
			[string]$abstract = $CompanyFax
			$ab.Text = $abstract

			#added 8-Jun-2017
			$ab = $cp.documentelement.ChildNodes | Where-Object{$_.basename -eq "CompanyPhone"}
			#set the text
			[string]$abstract = $CompanyPhone
			$ab.Text = $abstract

			$ab = $cp.documentelement.ChildNodes | Where-Object{$_.basename -eq "PublishDate"}
			#set the text
			[string]$abstract = (Get-Date -Format d).ToString()
			$ab.Text = $abstract

			Write-Verbose "$(Get-Date -Format G): Update the Table of Contents"
			#update the Table of Contents
			$Script:Doc.TablesOfContents.item(1).Update()
			$cp = $Null
			$ab = $Null
			$abstract = $Null
		}
	}
}
#endregion

#region registry functions
#http://stackoverflow.com/questions/5648931/test-if-registry-value-exists
# This Function just gets $True or $False
Function Test-RegistryValue($path, $name)
{
	$key = Get-Item -LiteralPath $path -EA 0
	$key -and $Null -ne $key.GetValue($name, $Null)
}

# Gets the specified registry value or $Null if it is missing
Function Get-RegistryValue($path, $name)
{
	$key = Get-Item -LiteralPath $path -EA 0
	If($key)
	{
		$key.GetValue($name, $Null)
	}
	Else
	{
		$Null
	}
}
#endregion

#region word, text and html line output functions
Function line
#function created by Michael B. Smith, Exchange MVP
#@essentialexch on Twitter
#https://essential.exchange/blog
#for creating the formatted text report
#created March 2011
#updated March 2014
# updated March 2019 to use StringBuilder (about 100 times more efficient than simple strings)
{
	Param
	(
		[Int]    $tabs = 0, 
		[String] $name = '', 
		[String] $value = '', 
		[String] $newline = [System.Environment]::NewLine, 
		[Switch] $nonewline
	)

	while( $tabs -gt 0 )
	{
		$null = $global:Output.Append( "`t" )
		$tabs--
	}

	If( $nonewline )
	{
		$null = $global:Output.Append( $name + $value )
	}
	Else
	{
		$null = $global:Output.AppendLine( $name + $value )
	}
}

Function TextHeatMap
{
    Param([decimal]$PValue)
	[int]$maxlength = 14 #****100.00****
    
    Switch($PValue)
    {
        {$_ -lt 70}
		{
			$tmp = "{0:f2}" -f $PValue;
			return "*$($tmp)*".PadLeft($MaxLength, " ")
		}
        {$_ -ge 70 -and $_ -lt 80}
		{
			$tmp = "{0:f2}" -f $PValue;
			return "**$($tmp)**".PadLeft($MaxLength, " ")
		}
        {$_ -ge 80 -and $_ -lt 90}
		{
			$tmp = "{0:f2}" -f $PValue;
			return "***$($tmp)***".PadLeft($MaxLength, " ")
		}
        {$_ -ge 90 -and $_ -le 100}
		{
			$tmp = "{0:f2}" -f $PValue;
			return "****$($tmp)****".PadLeft($MaxLength, " ")
		}
    }
}
	
Function WriteWordLine
#Function created by Ryan Revord
#@rsrevord on Twitter
#Function created to make output to Word easy in this script
#updated 27-Mar-2014 to include font name, font size, italics and bold options
{
	Param([int]$style=0, 
	[int]$tabs = 0, 
	[string]$name = '', 
	[string]$value = '', 
	[string]$fontName=$Null,
	[int]$fontSize=0,
	[bool]$italics=$False,
	[bool]$boldface=$False,
	[Switch]$nonewline)
	
	#Build output style
	[string]$output = ""
	Switch ($style)
	{
		0 {$Script:Selection.Style = $Script:MyHash.Word_NoSpacing; Break}
		1 {$Script:Selection.Style = $Script:MyHash.Word_Heading1; Break}
		2 {$Script:Selection.Style = $Script:MyHash.Word_Heading2; Break}
		3 {$Script:Selection.Style = $Script:MyHash.Word_Heading3; Break}
		4 {$Script:Selection.Style = $Script:MyHash.Word_Heading4; Break}
		Default {$Script:Selection.Style = $Script:MyHash.Word_NoSpacing; Break}
	}
	
	#build # of tabs
	While($tabs -gt 0)
	{ 
		$output += "`t"; $tabs--; 
	}
 
	If(![String]::IsNullOrEmpty($fontName)) 
	{
		$Script:Selection.Font.name = $fontName
	} 

	If($fontSize -ne 0) 
	{
		$Script:Selection.Font.size = $fontSize
	} 
 
	If($italics -eq $True) 
	{
		$Script:Selection.Font.Italic = $True
	} 
 
	If($boldface -eq $True) 
	{
		$Script:Selection.Font.Bold = $True
	} 

	#output the rest of the parameters.
	$output += $name + $value
	$Script:Selection.TypeText($output)
 
	#test for new WriteWordLine 0.
	If($nonewline)
	{
		# Do nothing.
	} 
	Else 
	{
		$Script:Selection.TypeParagraph()
	}
}

#***********************************************************************************************************
# WriteHTMLLine
#***********************************************************************************************************

<#
.Synopsis
	Writes a line of output for HTML output
.DESCRIPTION
	This function formats an HTML line
.USAGE
	WriteHTMLLine <Style> <Tabs> <Name> <Value> <Font Name> <Font Size> <Options>

	0 for Font Size denotes using the default font size of 2 or 10 point

.EXAMPLE
	WriteHTMLLine 0 0 " "

	Writes a blank line with no style or tab stops, obviously none needed.

.EXAMPLE
	WriteHTMLLine 0 1 "This is a regular line of text indented 1 tab stops"

	Writes a line with 1 tab stop.

.EXAMPLE
	WriteHTMLLine 0 0 "This is a regular line of text in the default font in italics" "" $null 0 $htmlitalics

	Writes a line omitting font and font size and setting the italics attribute

.EXAMPLE
	WriteHTMLLine 0 0 "This is a regular line of text in the default font in bold" "" $null 0 $htmlbold

	Writes a line omitting font and font size and setting the bold attribute

.EXAMPLE
	WriteHTMLLine 0 0 "This is a regular line of text in the default font in bold italics" "" $null 0 ($htmlbold -bor $htmlitalics)

	Writes a line omitting font and font size and setting both italics and bold options

.EXAMPLE	
	WriteHTMLLine 0 0 "This is a regular line of text in the default font in 10 point" "" $null 2  # 10 point font

	Writes a line using 10 point font

.EXAMPLE
	WriteHTMLLine 0 0 "This is a regular line of text in Courier New font" "" "Courier New" 0 

	Writes a line using Courier New Font and 0 font point size (default = 2 if set to 0)

.EXAMPLE	
	WriteHTMLLine 0 0 "This is a regular line of RED text indented 0 tab stops with the computer name as data in 10 point Courier New bold italics: " $env:computername "Courier New" 2 ($htmlbold -bor $htmlred -bor $htmlitalics)

	Writes a line using Courier New Font with first and second string values to be used, also uses 10 point font with bold, italics and red color options set.

.NOTES

	Font Size - Unlike word, there is a limited set of font sizes that can be used in HTML.  They are:
		0 - default which actually gives it a 2 or 10 point.
		1 - 7.5 point font size
		2 - 10 point
		3 - 13.5 point
		4 - 15 point
		5 - 18 point
		6 - 24 point
		7 - 36 point
	Any number larger than 7 defaults to 7

	Style - Refers to the headers that are used with output and resemble the headers in word, 
	HTML supports headers h1-h6 and h1-h4 are more commonly used.  Unlike word, H1 will not 
	give you a blue colored font, you will have to set that yourself.

	Colors and Bold/Italics Flags are:

		htmlbold       
		htmlitalics    
		htmlred        
		htmlcyan        
		htmlblue       
		htmldarkblue   
		htmllightblue   
		htmlpurple      
		htmlyellow      
		htmllime       
		htmlmagenta     
		htmlwhite       
		htmlsilver      
		htmlgray       
		htmlolive       
		htmlorange      
		htmlmaroon      
		htmlgreen       
		htmlblack       
#>

$crlf = [System.Environment]::NewLine

Function WriteHTMLLine
#Function created by Ken Avram
#Function created to make output to HTML easy in this script
#headings fixed 12-Oct-2016 by Webster
#errors with $HTMLStyle fixed 7-Dec-2017 by Webster
{
	Param
	(
		[Int]    $style    = 0, 
		[Int]    $tabs     = 0, 
		[String] $name     = '', 
		[String] $value    = '', 
		[String] $fontName = $null,
		[Int]    $fontSize = 1,
		[Int]    $options  = $htmlblack
	)

	[System.Text.StringBuilder] $sb = New-Object System.Text.StringBuilder( 1024 )

	If( [String]::IsNullOrEmpty( $name ) )	
	{
		$null = $sb.Append( '<p></p>' )
	}
	Else
	{
		[Bool] $ital = $options -band $htmlitalics
		[Bool] $bold = $options -band $htmlBold

		If( $ital ) { $null = $sb.Append( '<i>' ) }
		If( $bold ) { $null = $sb.Append( '<b>' ) } 

		Switch( $style )
		{
			1 { $HTMLOpen = '<h1>'; $HTMLClose = '</h1>'; Break }
			2 { $HTMLOpen = '<h2>'; $HTMLClose = '</h2>'; Break }
			3 { $HTMLOpen = '<h3>'; $HTMLClose = '</h3>'; Break }
			4 { $HTMLOpen = '<h4>'; $HTMLClose = '</h4>'; Break }
			Default { $HTMLOpen = ''; $HTMLClose = ''; Break }
		}

		$null = $sb.Append( $HTMLOpen )

		$null = $sb.Append( ( '&nbsp;&nbsp;&nbsp;&nbsp;' * $tabs ) + $name + $value )


		If( $HTMLClose -eq '' ) { $null = $sb.Append( '<br>' )     }
		Else                    { $null = $sb.Append( $HTMLClose ) }

		If( $ital ) { $null = $sb.Append( '</i>' ) }
		If( $bold ) { $null = $sb.Append( '</b>' ) } 

		If( $HTMLClose -eq '' ) { $null = $sb.Append( '<br />' ) }
	}
	$null = $sb.AppendLine( '' )

	Out-File -FilePath $Script:HTMLFileName -Append -InputObject $sb.ToString() 4>$Null
}
#endregion

#region HTML table functions
#***********************************************************************************************************
# AddHTMLTable - Called from FormatHTMLTable function
# Created by Ken Avram
# modified by Jake Rutski
# re-implemented by Michael B. Smith and made the documentation match reality.
#***********************************************************************************************************
Function AddHTMLTable
{
	Param
	(
		[String]   $fontName  = 'Calibri',
		[Int]      $fontSize  = 2,
		[Int]      $colCount  = 0,
		[Int]      $rowCount  = 0,
		[Object[]] $rowInfo   = $null,
		[Object[]] $fixedInfo = $null
	)

	[System.Text.StringBuilder] $sb = New-Object System.Text.StringBuilder( 8192 )

	If( $rowInfo -and $rowInfo.Length -lt $rowCount )
	{
		$rowCount = $rowInfo.Length
	}

	for( $rowCountIndex = 0; $rowCountIndex -lt $rowCount; $rowCountIndex++ )
	{
		$null = $sb.AppendLine( '<tr>' )

		## reset
		$row = $rowInfo[ $rowCountIndex ]

		$subRow = $row
		If( $subRow -is [Array] -and $subRow[ 0 ] -is [Array] )
		{
			$subRow = $subRow[ 0 ]
		}

		$subRowLength = $subRow.Length
		For( $columnIndex = 0; $columnIndex -lt $colCount; $columnIndex += 2 )
		{
			$item = If( $columnIndex -lt $subRowLength ) { $subRow[ $columnIndex ] } Else { 0 }

			$text   = If( $item ) { $item.ToString() } Else { '' }
			$format = If( ( $columnIndex + 1 ) -lt $subRowLength ) { $subRow[ $columnIndex + 1 ] } Else { 0 }
			## item, text, and format ALWAYS have values, even if empty values
			$color  = $global:htmlColor[ $format -band 0xffffc ]
			[Bool] $bold = $format -band $htmlBold
			[Bool] $ital = $format -band $htmlitalics

			If( $null -eq $fixedInfo -or $fixedInfo.Length -eq 0 )
			{
				$null = $sb.Append( "<td style=""background-color:$( $color )""><font face='$( $fontName )' size='$( $fontSize )'>" )
			}
			Else
			{
				$null = $sb.Append( "<td style=""width:$( $fixedInfo[ $columnIndex / 2 ] ); background-color:$( $color )""><font face='$( $fontName )' size='$( $fontSize )'>" )
			}

			If( $bold ) { $null = $sb.Append( '<b>' ) }
			If( $ital ) { $null = $sb.Append( '<i>' ) }

			If( $text -eq ' ' -or $text.length -eq 0)
			{
				##$htmlbody += '&nbsp;&nbsp;&nbsp;'
				$null = $sb.Append( '&nbsp;&nbsp;&nbsp;' )
			}
			Else
			{
				For ($inx = 0; $inx -lt $text.length; $inx++ )
				{
					If( $text[ $inx ] -eq ' ' )
					{
						$null = $sb.Append( '&nbsp;' )
					}
					Else
					{
						Break
					}
				}
				$null = $sb.Append( $text )
			}

			If( $bold ) { $null = $sb.Append( '</b>' ) }
			If( $ital ) { $null = $sb.Append( '</i>' ) }

			$null = $sb.AppendLine( '</font></td>' )
		}

		$null = $sb.AppendLine( '</tr>' )
	}

	Out-File -FilePath $Script:HTMLFileName -Append -InputObject $sb.ToString() 4>$Null 
}

#***********************************************************************************************************
# FormatHTMLTable 
# Created by Ken Avram
# modified by Jake Rutski
#***********************************************************************************************************

<#
.Synopsis
	Format table for HTML output document
.DESCRIPTION
	This function formats a table for HTML from an array of strings
.PARAMETER noBorder
	If set to $true, a table will be generated without a border (border='0')
.PARAMETER noHeadCols
	This parameter should be used when generating tables without column headers
	Set this parameter equal to the number of columns in the table
.PARAMETER rowArray
	This parameter contains the row data array for the table
.PARAMETER columnArray
	This parameter contains column header data for the table
.PARAMETER fixedWidth
	This parameter contains widths for columns in pixel format ("100px") to override auto column widths
	The variable should contain a width for each column you wish to override the auto-size setting
	For example: $columnWidths = @("100px","110px","120px","130px","140px")

.USAGE
	FormatHTMLTable <Table Header> <Table Format> <Font Name> <Font Size>

.EXAMPLE
	FormatHTMLTable "Table Heading" "auto" "Calibri" 3

	This example formats a table and writes it out into an html file.  All of the parameters are optional
	defaults are used if not supplied.

	for <Table format>, the default is auto which will autofit the text into the columns and adjust to the longest text in that column.  You can also use percentage i.e. 25%
	which will take only 25% of the line and will auto word wrap the text to the next line in the column.  Also, instead of using a percentage, you can use pixels i.e. 400px.

	FormatHTMLTable "Table Heading" "auto" -rowArray $rowData -columnArray $columnData

	This example creates an HTML table with a heading of 'Table Heading', auto column spacing, column header data from $columnData and row data from $rowData

	FormatHTMLTable "Table Heading" -rowArray $rowData -noHeadCols 3

	This example creates an HTML table with a heading of 'Table Heading', auto column spacing, no header, and row data from $rowData

	FormatHTMLTable "Table Heading" -rowArray $rowData -fixedWidth $fixedColumns

	This example creates an HTML table with a heading of 'Table Heading, no header, row data from $rowData, and fixed columns defined by $fixedColumns

.NOTES
	In order to use the formatted table it first has to be loaded with data.  Examples below will show how to load the table:

	First, initialize the table array

	$rowdata = @()

	Then Load the array.  If you are using column headers then load those into the column headers array, otherwise the first line of the table goes into the column headers array
	and the second and subsequent lines go into the $rowdata table as shown below:

	$columnHeaders = @('Display Name',($htmlsilver -bor $htmlbold),'Status',($htmlsilver -bor $htmlbold),'Startup Type',($htmlsilver -bor $htmlbold))

	The first column is the actual name to display, the second are the attributes of the column i.e. color anded with bold or italics.  For the anding, parens are required or it will
	not format correctly.

	This is following by adding rowdata as shown below.  As more columns are added the columns will auto adjust to fit the size of the page.

	$rowdata = @()
	$columnHeaders = @("User Name",($htmlsilver -bor $htmlbold),$UserName,$htmlwhite)
	$rowdata += @(,('Save as PDF',($htmlsilver -bor $htmlbold),$PDF.ToString(),$htmlwhite))
	$rowdata += @(,('Save as TEXT',($htmlsilver -bor $htmlbold),$TEXT.ToString(),$htmlwhite))
	$rowdata += @(,('Save as WORD',($htmlsilver -bor $htmlbold),$MSWORD.ToString(),$htmlwhite))
	$rowdata += @(,('Save as HTML',($htmlsilver -bor $htmlbold),$HTML.ToString(),$htmlwhite))
	$rowdata += @(,('Add DateTime',($htmlsilver -bor $htmlbold),$AddDateTime.ToString(),$htmlwhite))
	$rowdata += @(,('Hardware Inventory',($htmlsilver -bor $htmlbold),$Hardware.ToString(),$htmlwhite))
	$rowdata += @(,('Computer Name',($htmlsilver -bor $htmlbold),$ComputerName,$htmlwhite))
	$rowdata += @(,('Filename1',($htmlsilver -bor $htmlbold),$Script:FileName1,$htmlwhite))
	$rowdata += @(,('OS Detected',($htmlsilver -bor $htmlbold),$Script:RunningOS,$htmlwhite))
	$rowdata += @(,('PSUICulture',($htmlsilver -bor $htmlbold),$PSCulture,$htmlwhite))
	$rowdata += @(,('PoSH version',($htmlsilver -bor $htmlbold),$Host.Version.ToString(),$htmlwhite))
	FormatHTMLTable "Example of Horizontal AutoFitContents HTML Table" -rowArray $rowdata

	The 'rowArray' paramater is mandatory to build the table, but it is not set as such in the function - if nothing is passed, the table will be empty.

	Colors and Bold/Italics Flags are shown below:

		htmlbold       
		htmlitalics    
		htmlred        
		htmlcyan        
		htmlblue       
		htmldarkblue   
		htmllightblue   
		htmlpurple      
		htmlyellow      
		htmllime       
		htmlmagenta     
		htmlwhite       
		htmlsilver      
		htmlgray       
		htmlolive       
		htmlorange      
		htmlmaroon      
		htmlgreen       
		htmlblack     

#>

Function FormatHTMLTable
{
	Param
	(
		[String]   $tableheader = '',
		[String]   $tablewidth  = 'auto',
		[String]   $fontName    = 'Calibri',
		[Int]      $fontSize    = 2,
		[Switch]   $noBorder    = $false,
		[Int]      $noHeadCols  = 1,
		[Object[]] $rowArray    = $null,
		[Object[]] $fixedWidth  = $null,
		[Object[]] $columnArray = $null
	)

	## FIXME - the help text for this function is wacky wrong - MBS
	## FIXME - Use StringBuilder - MBS - this only builds the table header - benefit relatively small
<#
	If( $SuperVerbose )
	{
		wv "FormatHTMLTable: fontname '$fontname', size $fontSize, tableheader '$tableheader'"
		wv "FormatHTMLTable: noborder $noborder, noheadcols $noheadcols"
		If( $rowarray -and $rowarray.count -gt 0 )
		{
			wv "FormatHTMLTable: rowarray has $( $rowarray.count ) elements"
		}
		Else
		{
			wv "FormatHTMLTable: rowarray is empty"
		}
		If( $columnarray -and $columnarray.count -gt 0 )
		{
			wv "FormatHTMLTable: columnarray has $( $columnarray.count ) elements"
		}
		Else
		{
			wv "FormatHTMLTable: columnarray is empty"
		}
		If( $fixedwidth -and $fixedwidth.count -gt 0 )
		{
			wv "FormatHTMLTable: fixedwidth has $( $fixedwidth.count ) elements"
		}
		Else
		{
			wv "FormatHTMLTable: fixedwidth is empty"
		}
	}
#>

	$HTMLBody = "<b><font face='" + $fontname + "' size='" + ($fontsize + 1) + "'>" + $tableheader + "</font></b>" + $crlf

	If( $null -eq $columnArray -or $columnArray.Length -eq 0)
	{
		$NumCols = $noHeadCols + 1
	}  # means we have no column headers, just a table
	Else
	{
		$NumCols = $columnArray.Length
	}  # need to add one for the color attrib

	If( $null -ne $rowArray )
	{
		$NumRows = $rowArray.length + 1
	}
	Else
	{
		$NumRows = 1
	}

	If( $noBorder )
	{
		$HTMLBody += "<table border='0' width='" + $tablewidth + "'>"
	}
	Else
	{
		$HTMLBody += "<table border='1' width='" + $tablewidth + "'>"
	}
	$HTMLBody += $crlf

	If( $columnArray -and $columnArray.Length -gt 0 )
	{
		$HTMLBody += '<tr>' + $crlf

		for( $columnIndex = 0; $columnIndex -lt $NumCols; $columnindex += 2 )
		{
			$val = $columnArray[ $columnIndex + 1 ]
			$tmp = $global:htmlColor[ $val -band 0xffffc ]
			[Bool] $bold = $val -band $htmlBold
			[Bool] $ital = $val -band $htmlitalics

			If( $null -eq $fixedWidth -or $fixedWidth.Length -eq 0 )
			{
				$HTMLBody += "<td style=""background-color:$($tmp)""><font face='$($fontName)' size='$($fontSize)'>"
			}
			Else
			{
				$HTMLBody += "<td style=""width:$($fixedWidth[$columnIndex/2]); background-color:$($tmp)""><font face='$($fontName)' size='$($fontSize)'>"
			}

			If( $bold ) { $HTMLBody += '<b>' }
			If( $ital ) { $HTMLBody += '<i>' }

			$array = $columnArray[ $columnIndex ]
			If( $array )
			{
				If( $array -eq ' ' -or $array.Length -eq 0 )
				{
					$HTMLBody += '&nbsp;&nbsp;&nbsp;'
				}
				Else
				{
					for( $i = 0; $i -lt $array.Length; $i += 2 )
					{
						If( $array[ $i ] -eq ' ' )
						{
							$HTMLBody += '&nbsp;'
						}
						Else
						{
							break
						}
					}
					$HTMLBody += $array
				}
			}
			Else
			{
				$HTMLBody += '&nbsp;&nbsp;&nbsp;'
			}
			
			If( $bold ) { $HTMLBody += '</b>' }
			If( $ital ) { $HTMLBody += '</i>' }
		}

		$HTMLBody += '</font></td>'
		$HTMLBody += $crlf
	}

	$HTMLBody += '</tr>' + $crlf

	Out-File -FilePath $Script:HTMLFileName -Append -InputObject $HTMLBody 4>$Null 
	$HTMLBody = ''

	If( $rowArray )
	{
		AddHTMLTable -fontName $fontName -fontSize $fontSize `
		-colCount $numCols -rowCount $NumRows `
		-rowInfo $rowArray -fixedInfo $fixedWidth
		$rowArray = $null
		$HTMLBody = '</table>'
	}
	Else
	{
		$HTMLBody += '</table>'
	}

	Out-File -FilePath $Script:HTMLFileName -Append -InputObject $HTMLBody 4>$Null 
}
#endregion

#region other HTML functions
#***********************************************************************************************************
# CheckHTMLColor - Called from AddHTMLTable WriteHTMLLine and FormatHTMLTable
#***********************************************************************************************************
Function CheckHTMLColor
{
	Param($hash)

	If($hash -band $htmlwhite)
	{
		Return $htmlwhitemask
	}
	If($hash -band $htmlred)
	{
		Return $htmlredmask
	}
	If($hash -band $htmlcyan)
	{
		Return $htmlcyanmask
	}
	If($hash -band $htmlblue)
	{
		Return $htmlbluemask
	}
	If($hash -band $htmldarkblue)
	{
		Return $htmldarkbluemask
	}
	If($hash -band $htmllightblue)
	{
		Return $htmllightbluemask
	}
	If($hash -band $htmlpurple)
	{
		Return $htmlpurplemask
	}
	If($hash -band $htmlyellow)
	{
		Return $htmlyellowmask
	}
	If($hash -band $htmllime)
	{
		Return $htmllimemask
	}
	If($hash -band $htmlmagenta)
	{
		Return $htmlmagentamask
	}
	If($hash -band $htmlsilver)
	{
		Return $htmlsilvermask
	}
	If($hash -band $htmlgray)
	{
		Return $htmlgraymask
	}
	If($hash -band $htmlblack)
	{
		Return $htmlblackmask
	}
	If($hash -band $htmlorange)
	{
		Return $htmlorangemask
	}
	If($hash -band $htmlmaroon)
	{
		Return $htmlmaroonmask
	}
	If($hash -band $htmlgreen)
	{
		Return $htmlgreenmask
	}
	If($hash -band $htmlolive)
	{
		Return $htmlolivemask
	}
}

Function HTMLHeatMap
{
    Param([decimal]$PValue)
    
    Switch($PValue)
    {
        {$_ -lt 70}{return $htmlgreen; Break}
        {$_ -ge 70 -and $_ -lt 80}{return $htmlyellow; Break}
        {$_ -ge 80 -and $_ -lt 90}{return $htmlorange; Break}
        {$_ -ge 90 -and $_ -le 100}{return $htmlred; Break}
    }
}
#endregion

#region Iain's Word table functions
<#
.Synopsis
	Add a table to a Microsoft Word document
.DESCRIPTION
	This function adds a table to a Microsoft Word document from either an array of
	Hashtables or an array of PSCustomObjects.

	Using this function is quicker than setting each table cell individually but can
	only utilise the built-in MS Word table autoformats. Individual tables cells can
	be altered after the table has been appended to the document (a table reference
	is returned).
.EXAMPLE
	AddWordTable -Hashtable $HashtableArray

	This example adds table to the MS Word document, utilising all key/value pairs in
	the array of hashtables. Column headers will display the key names as defined.
	Note: the columns might not be displayed in the order that they were defined. To
	ensure columns are displayed in the required order utilise the -Columns parameter.
.EXAMPLE
	AddWordTable -Hashtable $HashtableArray -List

	This example adds table to the MS Word document, utilising all key/value pairs in
	the array of hashtables. No column headers will be added, in a ListView format.
	Note: the columns might not be displayed in the order that they were defined. To
	ensure columns are displayed in the required order utilise the -Columns parameter.
.EXAMPLE
	AddWordTable -CustomObject $PSCustomObjectArray

	This example adds table to the MS Word document, utilising all note property names
	the array of PSCustomObjects. Column headers will display the note property names.
	Note: the columns might not be displayed in the order that they were defined. To
	ensure columns are displayed in the required order utilise the -Columns parameter.
.EXAMPLE
	AddWordTable -Hashtable $HashtableArray -Columns FirstName,LastName,EmailAddress

	This example adds a table to the MS Word document, but only using the specified
	key names: FirstName, LastName and EmailAddress. If other keys are present in the
	array of Hashtables they will be ignored.
.EXAMPLE
	AddWordTable -CustomObject $PSCustomObjectArray -Columns FirstName,LastName,EmailAddress -Headers "First Name","Last Name","Email Address"

	This example adds a table to the MS Word document, but only using the specified
	PSCustomObject note properties: FirstName, LastName and EmailAddress. If other note
	properties are present in the array of PSCustomObjects they will be ignored. The
	display names for each specified column header has been overridden to display a
	custom header. Note: the order of the header names must match the specified columns.
#>

Function AddWordTable
{
	[CmdletBinding()]
	Param
	(
		# Array of Hashtable (including table headers)
		[Parameter(Mandatory=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName='Hashtable', Position=0)]
		[ValidateNotNullOrEmpty()] [System.Collections.Hashtable[]] $Hashtable,
		# Array of PSCustomObjects
		[Parameter(Mandatory=$True, ValueFromPipelineByPropertyName=$True, ParameterSetName='CustomObject', Position=0)]
		[ValidateNotNullOrEmpty()] [PSCustomObject[]] $CustomObject,
		# Array of Hashtable key names or PSCustomObject property names to include, in display order.
		# If not supplied then all Hashtable keys or all PSCustomObject properties will be displayed.
		[Parameter(ValueFromPipelineByPropertyName=$True)] [AllowNull()] [string[]] $Columns = $Null,
		# Array of custom table header strings in display order.
		[Parameter(ValueFromPipelineByPropertyName=$True)] [AllowNull()] [string[]] $Headers = $Null,
		# AutoFit table behavior.
		[Parameter(ValueFromPipelineByPropertyName=$True)] [AllowNull()] [int] $AutoFit = -1,
		# List view (no headers)
		[Switch] $List,
		# Grid lines
		[Switch] $NoGridLines,
		[Switch] $NoInternalGridLines,
		# Built-in Word table formatting style constant
		# Would recommend only $wdTableFormatContempory for normal usage (possibly $wdTableFormatList5 for List view)
		[Parameter(ValueFromPipelineByPropertyName=$True)] [int] $Format = 0
	)

	Begin 
	{
		Write-Debug ("Using parameter set '{0}'" -f $PSCmdlet.ParameterSetName);
		## Check if -Columns wasn't specified but -Headers were (saves some additional parameter sets!)
		If(($Null -eq $Columns) -and ($Null -eq $Headers)) 
		{
			Write-Warning "No columns specified and therefore, specified headers will be ignored.";
			$Columns = $Null;
		}
		ElseIf(($Null -ne $Columns) -and ($Null -ne $Headers)) 
		{
			## Check if number of specified -Columns matches number of specified -Headers
			If($Columns.Length -ne $Headers.Length) 
			{
				Write-Error "The specified number of columns does not match the specified number of headers.";
			}
		} ## end ElseIf
	} ## end Begin

	Process
	{
		## Build the Word table data string to be converted to a range and then a table later.
		[System.Text.StringBuilder] $WordRangeString = New-Object System.Text.StringBuilder;

		Switch ($PSCmdlet.ParameterSetName) 
		{
			'CustomObject' 
			{
				If($Null -eq $Columns) 
				{
					## Build the available columns from all availble PSCustomObject note properties
					[string[]] $Columns = @();
					## Add each NoteProperty name to the array
					ForEach($Property in ($CustomObject | Get-Member -MemberType NoteProperty)) 
					{ 
						$Columns += $Property.Name; 
					}
				}

				## Add the table headers from -Headers or -Columns (except when in -List(view)
				If(-not $List) 
				{
					Write-Debug ("$(Get-Date -Format G): `t`tBuilding table headers");
					If($Null -ne $Headers) 
					{
                        [ref] $Null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Headers));
					}
					Else 
					{ 
                        [ref] $Null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Columns));
					}
				}

				## Iterate through each PSCustomObject
				Write-Debug ("$(Get-Date -Format G): `t`tBuilding table rows");
				ForEach($Object in $CustomObject) 
				{
					$OrderedValues = @();
					## Add each row item in the specified order
					ForEach($Column in $Columns) 
					{ 
						$OrderedValues += $Object.$Column; 
					}
					## Use the ordered list to add each column in specified order
					[ref] $Null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $OrderedValues));
				} ## end ForEach
				Write-Debug ("$(Get-Date -Format G): `t`t`tAdded '{0}' table rows" -f ($CustomObject.Count));
			} ## end CustomObject

			Default 
			{   ## Hashtable
				If($Null -eq $Columns) 
				{
					## Build the available columns from all available hashtable keys. Hopefully
					## all Hashtables have the same keys (they should for a table).
					$Columns = $Hashtable[0].Keys;
				}

				## Add the table headers from -Headers or -Columns (except when in -List(view)
				If(-not $List) 
				{
					Write-Debug ("$(Get-Date -Format G): `t`tBuilding table headers");
					If($Null -ne $Headers) 
					{ 
						[ref] $Null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Headers));
					}
					Else 
					{
						[ref] $Null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $Columns));
					}
				}
                
				## Iterate through each Hashtable
				Write-Debug ("$(Get-Date -Format G): `t`tBuilding table rows");
				ForEach($Hash in $Hashtable) 
				{
					$OrderedValues = @();
					## Add each row item in the specified order
					ForEach($Column in $Columns) 
					{ 
						$OrderedValues += $Hash.$Column; 
					}
					## Use the ordered list to add each column in specified order
					[ref] $Null = $WordRangeString.AppendFormat("{0}`n", [string]::Join("`t", $OrderedValues));
				} ## end ForEach

				Write-Debug ("$(Get-Date -Format G): `t`t`tAdded '{0}' table rows" -f $Hashtable.Count);
			} ## end default
		} ## end Switch

		## Create a MS Word range and set its text to our tab-delimited, concatenated string
		Write-Debug ("$(Get-Date -Format G): `t`tBuilding table range");
		$WordRange = $Script:Doc.Application.Selection.Range;
		$WordRange.Text = $WordRangeString.ToString();

		## Create hash table of named arguments to pass to the ConvertToTable method
		$ConvertToTableArguments = @{ Separator = [Microsoft.Office.Interop.Word.WdTableFieldSeparator]::wdSeparateByTabs; }

		## Negative built-in styles are not supported by the ConvertToTable method
		If($Format -ge 0) 
		{
			$ConvertToTableArguments.Add("Format", $Format);
			$ConvertToTableArguments.Add("ApplyBorders", $True);
			$ConvertToTableArguments.Add("ApplyShading", $True);
			$ConvertToTableArguments.Add("ApplyFont", $True);
			$ConvertToTableArguments.Add("ApplyColor", $True);
			If(!$List) 
			{ 
				$ConvertToTableArguments.Add("ApplyHeadingRows", $True); 
			}
			$ConvertToTableArguments.Add("ApplyLastRow", $True);
			$ConvertToTableArguments.Add("ApplyFirstColumn", $True);
			$ConvertToTableArguments.Add("ApplyLastColumn", $True);
		}

		## Invoke ConvertToTable method - with named arguments - to convert Word range to a table
		## See http://msdn.microsoft.com/en-us/library/office/aa171893(v=office.11).aspx
		Write-Debug ("$(Get-Date -Format G): `t`tConverting range to table");
		## Store the table reference just in case we need to set alternate row coloring
		$WordTable = $WordRange.GetType().InvokeMember(
			"ConvertToTable",                               # Method name
			[System.Reflection.BindingFlags]::InvokeMethod, # Flags
			$Null,                                          # Binder
			$WordRange,                                     # Target (self!)
			([Object[]]($ConvertToTableArguments.Values)),  ## Named argument values
			$Null,                                          # Modifiers
			$Null,                                          # Culture
			([String[]]($ConvertToTableArguments.Keys))     ## Named argument names
		);

		## Implement grid lines (will wipe out any existing formatting
		If($Format -lt 0) 
		{
			Write-Debug ("$(Get-Date -Format G): `t`tSetting table format");
			$WordTable.Style = $Format;
		}

		## Set the table autofit behavior
		If($AutoFit -ne -1) 
		{ 
			$WordTable.AutoFitBehavior($AutoFit); 
		}

		If(!$List)
		{
			#the next line causes the heading row to flow across page breaks
			$WordTable.Rows.First.Headingformat = $wdHeadingFormatTrue;
		}

		If(!$NoGridLines) 
		{
			$WordTable.Borders.InsideLineStyle = $wdLineStyleSingle;
			$WordTable.Borders.OutsideLineStyle = $wdLineStyleSingle;
		}
		If($NoGridLines) 
		{
			$WordTable.Borders.InsideLineStyle = $wdLineStyleNone;
			$WordTable.Borders.OutsideLineStyle = $wdLineStyleNone;
		}
		If($NoInternalGridLines) 
		{
			$WordTable.Borders.InsideLineStyle = $wdLineStyleNone;
			$WordTable.Borders.OutsideLineStyle = $wdLineStyleSingle;
		}

		Return $WordTable;

	} ## end Process
}

<#
.Synopsis
	Sets the format of one or more Word table cells
.DESCRIPTION
	This function sets the format of one or more table cells, either from a collection
	of Word COM object cell references, an individual Word COM object cell reference or
	a hashtable containing Row and Column information.

	The font name, font size, bold, italic , underline and shading values can be used.
.EXAMPLE
	SetWordCellFormat -Hashtable $Coordinates -Table $TableReference -Bold

	This example sets all text to bold that is contained within the $TableReference
	Word table, using an array of hashtables. Each hashtable contain a pair of co-
	ordinates that is used to select the required cells. Note: the hashtable must
	contain the .Row and .Column key names. For example:
	@ { Row = 7; Column = 3 } to set the cell at row 7 and column 3 to bold.
.EXAMPLE
	$RowCollection = $Table.Rows.First.Cells
	SetWordCellFormat -Collection $RowCollection -Bold -Size 10

	This example sets all text to size 8 and bold for all cells that are contained
	within the first row of the table.
	Note: the $Table.Rows.First.Cells returns a collection of Word COM cells objects
	that are in the first table row.
.EXAMPLE
	$ColumnCollection = $Table.Columns.Item(2).Cells
	SetWordCellFormat -Collection $ColumnCollection -BackgroundColor 255

	This example sets the background (shading) of all cells in the table's second
	column to red.
	Note: the $Table.Columns.Item(2).Cells returns a collection of Word COM cells objects
	that are in the table's second column.
.EXAMPLE
	SetWordCellFormat -Cell $Table.Cell(17,3) -Font "Tahoma" -Color 16711680

	This example sets the font to Tahoma and the text color to blue for the cell located
	in the table's 17th row and 3rd column.
	Note: the $Table.Cell(17,3) returns a single Word COM cells object.
#>

Function SetWordCellFormat 
{
	[CmdletBinding(DefaultParameterSetName='Collection')]
	Param (
		# Word COM object cell collection reference
		[Parameter(Mandatory=$True, ValueFromPipeline=$True, ParameterSetName='Collection', Position=0)] [ValidateNotNullOrEmpty()] $Collection,
		# Word COM object individual cell reference
		[Parameter(Mandatory=$True, ParameterSetName='Cell', Position=0)] [ValidateNotNullOrEmpty()] $Cell,
		# Hashtable of cell co-ordinates
		[Parameter(Mandatory=$True, ParameterSetName='Hashtable', Position=0)] [ValidateNotNullOrEmpty()] [System.Collections.Hashtable[]] $Coordinates,
		# Word COM object table reference
		[Parameter(Mandatory=$True, ParameterSetName='Hashtable', Position=1)] [ValidateNotNullOrEmpty()] $Table,
		# Font name
		[Parameter()] [AllowNull()] [string] $Font = $Null,
		# Font color
		[Parameter()] [AllowNull()] $Color = $Null,
		# Font size
		[Parameter()] [ValidateNotNullOrEmpty()] [int] $Size = 0,
		# Cell background color
		[Parameter()] [AllowNull()] [int]$BackgroundColor = $Null,
		# Force solid background color
		[Switch] $Solid,
		[Switch] $Bold,
		[Switch] $Italic,
		[Switch] $Underline
	)

	Begin 
	{
		Write-Debug ("Using parameter set '{0}'." -f $PSCmdlet.ParameterSetName);
	}

	Process 
	{
		Switch ($PSCmdlet.ParameterSetName) 
		{
			'Collection' {
				ForEach($Cell in $Collection) 
				{
					If($Null -ne $BackgroundColor) { $Cell.Shading.BackgroundPatternColor = $BackgroundColor; }
					If($Bold) { $Cell.Range.Font.Bold = $True; }
					If($Italic) { $Cell.Range.Font.Italic = $True; }
					If($Underline) { $Cell.Range.Font.Underline = 1; }
					If($Null -ne $Font) { $Cell.Range.Font.Name = $Font; }
					If($Null -ne $Color) { $Cell.Range.Font.Color = $Color; }
					If($Size -ne 0) { $Cell.Range.Font.Size = $Size; }
					If($Solid) { $Cell.Shading.Texture = 0; } ## wdTextureNone
				} # end ForEach
			} # end Collection
			'Cell' 
			{
				If($Bold) { $Cell.Range.Font.Bold = $True; }
				If($Italic) { $Cell.Range.Font.Italic = $True; }
				If($Underline) { $Cell.Range.Font.Underline = 1; }
				If($Null -ne $Font) { $Cell.Range.Font.Name = $Font; }
				If($Null -ne $Color) { $Cell.Range.Font.Color = $Color; }
				If($Size -ne 0) { $Cell.Range.Font.Size = $Size; }
				If($Null -ne $BackgroundColor) { $Cell.Shading.BackgroundPatternColor = $BackgroundColor; }
				If($Solid) { $Cell.Shading.Texture = 0; } ## wdTextureNone
			} # end Cell
			'Hashtable' 
			{
				ForEach($Coordinate in $Coordinates) 
				{
					$Cell = $Table.Cell($Coordinate.Row, $Coordinate.Column);
					If($Bold) { $Cell.Range.Font.Bold = $True; }
					If($Italic) { $Cell.Range.Font.Italic = $True; }
					If($Underline) { $Cell.Range.Font.Underline = 1; }
					If($Null -ne $Font) { $Cell.Range.Font.Name = $Font; }
					If($Null -ne $Color) { $Cell.Range.Font.Color = $Color; }
					If($Size -ne 0) { $Cell.Range.Font.Size = $Size; }
					If($Null -ne $BackgroundColor) { $Cell.Shading.BackgroundPatternColor = $BackgroundColor; }
					If($Solid) { $Cell.Shading.Texture = 0; } ## wdTextureNone
				}
			} # end Hashtable
		} # end Switch
	} # end process
}

<#
.Synopsis
	Sets alternate row colors in a Word table
.DESCRIPTION
	This function sets the format of alternate rows within a Word table using the
	specified $BackgroundColor. This function is expensive (in performance terms) as
	it recursively sets the format on alternate rows. It would be better to pick one
	of the predefined table formats (if one exists)? Obviously the more rows, the
	longer it takes :'(

	Note: this function is called by the AddWordTable function if an alternate row
	format is specified.
.EXAMPLE
	SetWordTableAlternateRowColor -Table $TableReference -BackgroundColor 255

	This example sets every-other table (starting with the first) row and sets the
	background color to red (wdColorRed).
.EXAMPLE
	SetWordTableAlternateRowColor -Table $TableReference -BackgroundColor 39423 -Seed Second

	This example sets every other table (starting with the second) row and sets the
	background color to light orange (weColorLightOrange).
#>

Function SetWordTableAlternateRowColor 
{
	[CmdletBinding()]
	Param (
		# Word COM object table reference
		[Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)] [ValidateNotNullOrEmpty()] $Table,
		# Alternate row background color
		[Parameter(Mandatory=$true, Position=1)] [ValidateNotNull()] [int] $BackgroundColor,
		# Alternate row starting seed
		[Parameter(ValueFromPipelineByPropertyName=$true, Position=2)] [ValidateSet('First','Second')] [string] $Seed = 'First'
	)

	Process 
	{
		$StartDateTime = Get-Date;
		Write-Debug ("{0}: `t`tSetting alternate table row colors.." -f $StartDateTime);

		## Determine the row seed (only really need to check for 'Second' and default to 'First' otherwise
		If($Seed.ToLower() -eq 'second') 
		{ 
			$StartRowIndex = 2; 
		}
		Else 
		{ 
			$StartRowIndex = 1; 
		}

		For($AlternateRowIndex = $StartRowIndex; $AlternateRowIndex -lt $Table.Rows.Count; $AlternateRowIndex += 2) 
		{ 
			$Table.Rows.Item($AlternateRowIndex).Shading.BackgroundPatternColor = $BackgroundColor;
		}

		## I've put verbose calls in here we can see how expensive this functionality actually is.
		$EndDateTime = Get-Date;
		$ExecutionTime = New-TimeSpan -Start $StartDateTime -End $EndDateTime;
		Write-Debug ("{0}: `t`tDone setting alternate row style color in '{1}' seconds" -f $EndDateTime, $ExecutionTime.TotalSeconds);
	}
}
#endregion

#region general script functions
Function VISetup( [string] $VIServer )
{
	# Check for root
	# http://blogs.technet.com/b/heyscriptingguy/archive/2011/05/11/check-for-admin-credentials-in-a-powershell-script.aspx
	If(!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
	{
		Write-Host "`nThis script is not running as administrator - this is required to set global PowerCLI parameters. You may see PowerCLI warnings.`n"
	}

	Write-Verbose "$(Get-Date -Format G): Setting up VMware PowerCLI"
	#Check to see if PowerCLI is installed via Module or MSI
	$PSDefaultParameterValues = @{"*:Verbose"=$False}

	If($Null -ne (Get-Module -ListAvailable | Where-Object {$_.Name -eq "VMware.PowerCLI"}))
	{
		$PSDefaultParameterValues = @{"*:Verbose"=$True}
		# PowerCLI is installed via PowerShell Gallery\or the module is installed
		Write-Verbose "$(Get-Date -Format G): PowerCLI Module install found"
		# grab the PWD before PCLI resets it to C:\
		$tempPWD = $pwd
	}
	Else
	{
		$PSDefaultParameterValues = @{"*:Verbose"=$True}
		If($PCLICustom)
		{
			Write-Verbose "$(Get-Date -Format G): Custom PowerCLI Install location"
			$PCLIPath = "$(Select-FolderDialog)\Initialize-PowerCLIEnvironment.ps1" 4>$Null
		}
		ElseIf($env:PROCESSOR_ARCHITECTURE -like "*AMD64*")
		{
			$PCLIPath = "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"
		}
		Else
		{
			$PCLIPath = "C:\Program Files\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"
		}

		If(!(Test-Path $PCLIPath))
		{
			# PCLI v6.5 changed install directory...check here first
			If($env:PROCESSOR_ARCHITECTURE -like "*AMD64*")
			{
				$PCLIPath = "C:\Program Files (x86)\VMware\Infrastructure\PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"
			}
			Else
			{
				$PCLIPath = "C:\Program Files\VMware\Infrastructure\PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1"
			}
		}
		If(Test-Path $PCLIPath)
		{
			# grab the PWD before PCLI resets it to C:\
			$tempPWD = $pwd
			Import-Module $PCLIPath *>$Null
		}
		Else
		{
			Write-Error "
			`n`n
			`t`t
			PowerCLI does not appear to be installed - please install the latest version of PowerCLI.
			`n`n
			`t`t
			This script will now exit.
			`n`n
			"
			Write-Host "*** If PowerCLI was installed to a non-Default location, please use the -PCLICustom parameter ***"
			AbortScript
		}
	}

	$PSDefaultParameterValues = @{"*:Verbose"=$False}
	$Script:xPowerCLIVer = (Get-Command Connect-VIServer).Version
	$PSDefaultParameterValues = @{"*:Verbose"=$True}

	Write-Verbose "$(Get-Date -Format G): Loaded PowerCLI version $($Script:xPowerCLIVer.Major).$($Script:xPowerCLIVer.Minor)"
	If($Script:xPowerCLIVer.Major -lt 5 -or ($Script:xPowerCLIVer.Major -eq 5 -and $Script:xPowerCLIVer.Minor -lt 1))
	{
		Write-Host "`nPowerCLI version $($Script:xPowerCLIVer.Major).$($Script:xPowerCLIVer.Minor) is installed. PowerCLI version 5.1 or later is required to run this script. `nPlease install the latest version and run this script again. This script will now exit."
		AbortScript
	}

	#Set PCLI defaults and reset PWD
	cd $tempPWD 4>$Null
	Write-Verbose "$(Get-Date -Format G): Setting PowerCLI global Configuration"
	Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -DisplayDeprecationWarnings $False -Confirm:$False *>$Null

	#Are we already connected to VC?
	If(Test-Path variable:global:DefaultVIServer) #first see if the variable exists
	{
		If($global:DefaultVIServer)
		{
			Write-Host "`nIt appears PowerCLI is already connected to a VCenter Server. Please use the 'Disconnect-VIServer' cmdlet to disconnect any sessions before running inventory."
			AbortScript
		}
	}

	#Connect to VI Server
	Write-Verbose "$(Get-Date -Format G): Connecting to VIServer: $($VIServer)"
	$Script:VCObj = Connect-VIServer $VIServer 4>$Null

	#Verify we successfully connected
	If(!($?))
	{
		Write-Host "Connecting to vCenter failed with the following error: $($Error[0].Exception.Message.substring($Error[0].Exception.Message.IndexOf("Connect-VIServer") + 16).Trim()) This script will now exit."
		AbortScript
	}
}

Function Select-FolderDialog
{
	# http://stackoverflow.com/questions/11412617/get-a-folder-path-from-the-explorer-menu-to-a-powershell-variable
	param([string]$Description="Select PowerCLI Scripts Directory - Default is C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\",[string]$RootFolder="Desktop")

	[System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null     

	$objForm = New-Object System.Windows.Forms.FolderBrowserDialog
	$objForm.Rootfolder  = $RootFolder
	$objForm.Description = $Description
	$Show = $objForm.ShowDialog()
	If($Show -eq "OK")
	{
		Return $objForm.SelectedPath
	}
	Else
	{
		Write-Error "
		`n`n
		`t`t
		Operation cancelled by user.
		`n`n
		"
	}
}

Function SetGlobals
{
    Write-Verbose "$(Get-Date -Format G): Gathering VMware Global data"
    ## Any Get used more than once is set to a global variable to limit the number of calls to PowerCLI
    ## Export commands from http://blogs.technet.com/b/heyscriptingguy/archive/2011/09/06/learn-how-to-save-powershell-objects-for-offline-analysis.aspx
    If($Export)
    {
        If(!(Test-Path "$Script:pwdpath\Export"))
        {
            New-Item "$Script:pwdpath\Export" -type directory *>$Null
        }
        Write-Host "$(Get-Date -Format G):" -ForegroundColor White
        Write-Host "$(Get-Date -Format G): Exporting data to $Script:pwdpath\Export" -ForegroundColor White
        Write-Host "$(Get-Date -Format G):" -ForegroundColor White
        Write-Verbose "$(Get-Date -Format G): Gathering Compute data"
        $Script:VMHosts = Get-VMHost 4>$Null| Sort-Object Name 
        Get-Cluster 4>$Null| Sort-Object Name | Export-Clixml .\Export\Cluster.xml 4>$Null
        $VMHosts | Sort-Object Name | Export-Clixml .\Export\VMHost.xml 4>$Null
        Get-Datastore 4>$Null| Sort-Object Name | Export-Clixml .\Export\Datastore.xml 4>$Null
        Get-Snapshot -VM * 4>$Null| Export-Clixml .\Export\Snapshot.xml 4>$Null
        Get-AdvancedSetting -Entity $VIServerName 4>$Null| Where-Object{$_.Type -eq "VIServer" -and ($_.Name -like "mail.smtp.port" -or $_.Name -like "mail.smtp.server" -or $_.Name -like "mail.sender" -or $_.Name -like "VirtualCenter.FQDN")} | Export-Clixml .\Export\vCenterAdv.xml 4>$Null
        Get-AdvancedSetting -Entity ($VMHosts | Where-Object{$_.ConnectionState -like "*Connected*" -or $_.ConnectionState -like "*Maintenance*"}).Name 4>$Null| Where-Object{$_.Name -like "Syslog.global.logdir" -or $_.Name -like "Syslog.global.loghost"} | Export-Clixml .\Export\HostsAdv.xml 4>$Null
        Get-View -ViewType ClusterComputeResource -Property Name,ConfigurationEx | Export-Clixml .\Export\ClusterView.xml 4>$Null
        Get-VMHostService -VMHost * 4>$Null| Export-Clixml .\Export\HostService.xml 4>$Null
        Write-Verbose "$(Get-Date -Format G): Gathering Virtual Machine data"
        $Script:VirtualMachines = Get-VM 4>$Null| Sort-Object Name
        $Script:VirtualMachines | Export-Clixml .\Export\VM.xml 4>$Null
        Get-ResourcePool 4>$Null| Sort-Object Name | Export-Clixml .\Export\ResourcePool.xml 4>$Null
        Get-View 4>$Null(Get-View ServiceInstance 4>$Null).Content.PerfManager | Export-Clixml .\Export\vCenterStats.xml 4>$Null
        Get-View ServiceInstance 4>$Null| Export-Clixml .\Export\ServiceInstance.xml 4>$Null
        (((Get-View extensionmanager).ExtensionList).Description 4>$Null) | Export-Clixml .\Export\Plugins.xml 4>$Null
        Get-View 4>$Null(Get-View serviceInstance 4>$Null| Select-Object -First 1).Content.LicenseManager | Export-Clixml .\Export\Licensing.xml 4>$Null
        Get-VIPermission 4>$Null| Sort-Object Entity | Export-Clixml .\Export\VIPerms.xml 4>$Null
        Get-VIRole 4>$Null| Sort-Object Name | Export-Clixml .\Export\VIRoles.xml 4>$Null
        BuildDRSGroupsRules | Export-Clixml .\Export\DRSRules.xml 4>$Null
        If($Full)
        {
            If(!(Test-Path "$Script:pwdpath\Export\VMDetail"))
            {
                New-Item "$Script:pwdpath\Export\VMDetail" -type directory *>$Null
            }      
			Write-Host "$(Get-Date -Format G):" -ForegroundColor White
			Write-Host "$(Get-Date -Format G): Exporting Networking data to $Script:pwdpath\Export\VMDetail" -ForegroundColor White
			Write-Host "$(Get-Date -Format G):" -ForegroundColor White
            Write-Verbose "$(Get-Date -Format G): Gathering Networking data"
            Get-VMHostNetworkAdapter 4>$Null| Export-Clixml .\Export\HostNetwork.xml 4>$Null
            Get-VirtualSwitch 4>$Null| Export-Clixml .\Export\vSwitch.xml 4>$Null
            Get-NetworkAdapter * 4>$Null| Export-Clixml .\Export\NetworkAdapter.xml 4>$Null
            Get-VirtualPortGroup 4>$Null| Export-Clixml .\Export\PortGroup.xml 4>$Null
        }
    }
    ElseIf($Import)
    {
        ## Check for export directory
        If(Test-Path .\Export)
        {
            $Script:Clusters          = Import-Clixml .\Export\Cluster.xml
            $Script:VMHosts           = Import-Clixml .\Export\VMHost.xml
            $Script:Datastores        = Import-Clixml .\Export\Datastore.xml
            $Script:Snapshots         = Import-Clixml .\Export\Snapshot.xml
            $Script:HostAdvSettings   = Import-Clixml .\Export\HostsAdv.xml
            $Script:ClusterView       = Import-Clixml .\Export\ClusterView.xml
            $Script:VCAdvSettings     = Import-Clixml .\Export\vCenterAdv.xml
            $Script:VCObj             = Import-Clixml .\Export\VCObj.xml
            $Script:HostServices      = Import-Clixml .\Export\HostService.xml
            $Script:VirtualMachines   = Import-Clixml .\Export\VM.xml
            $Script:Resources         = Import-Clixml .\Export\ResourcePool.xml
            $SCript:VMPlugins         = Import-Clixml .\Export\Plugins.xml
            $Script:vCenterStatistics = Import-Clixml .\Export\vCenterStats.xml
            $Script:VCLicensing       = Import-Clixml .\Export\Licensing.xml
            $Script:VIPerms           = Import-Clixml .\Export\VIPerms.xml
            $Script:VIRoles           = Import-Clixml .\Export\VIRoles.xml
            $Script:DRSRules          = Import-Clixml .\Export\DRSRules.xml
            If(Test-Path .\Export\RegSQL.xml)
			{
				$Script:RegSQL = Import-Clixml .\Export\RegSQL.xml
			}
            If($Full)
            {
                $Script:HostNetAdapters   = Import-Clixml .\Export\HostNetwork.xml
                $Script:VirtualSwitches   = Import-Clixml .\Export\vSwitch.xml
                $Script:VMNetworkAdapters = Import-Clixml .\Export\NetworkAdapter.xml
                $Script:VirtualPortGroups = Import-Clixml .\Export\PortGroup.xml
            }
            $Script:VIServerName = (($VCAdvSettings) | Where-Object{$_.Name -like "VirtualCenter.FQDN"}).Value
        }
        Else
        {
            ## VMware Export not found, exit script
            Write-Host "Import option set, but no Export data directory found. Please copy the Export folder into the same folder as this script and run it again. This script will now exit."
            AbortScript
        }
    }
    ElseIf($Issues)
    {
        Write-Verbose "$(Get-Date -Format G): Gathering Compute data"
        $Script:Clusters = Get-Cluster 4>$Null | Sort-Object Name
        $Script:VMHosts = Get-VMHost 4>$Null | Sort-Object Name
        $Script:Datastores = Get-Datastore 4>$Null | Sort-Object Name
        Write-Verbose "$(Get-Date -Format G): Gathering Virtual Machine data"
        $Script:VirtualMachines = Get-VM 4>$Null | Sort-Object Name
        $Script:Snapshots = Get-Snapshot -VM * 4>$Null | Sort-Object VM
    }
    Else
    {
        Write-Verbose "$(Get-Date -Format G): Gathering Compute data"
        $Script:Clusters = Get-Cluster 4>$Null| Sort-Object Name 
        $Script:VMHosts = Get-VMHost 4>$Null| Sort-Object Name 
        $Script:Datastores = Get-Datastore 4>$Null| Sort-Object Name 
        $Script:HostAdvSettings = Get-AdvancedSetting -Entity ($VMHosts | Where-Object{$_.ConnectionState -like "*Connected*" -or $_.ConnectionState -like "*Maintenance*"}).Name 4>$Null
        $Script:ClusterView = Get-View -ViewType ClusterComputeResource -Property Name,ConfigurationEx 4>$Null
        $Script:VCAdvSettings = Get-AdvancedSetting -Entity $VIServerName 4>$Null
        $Script:HostServices = Get-VMHostService -VMHost * 4>$Null
        Write-Verbose "$(Get-Date -Format G): Gathering Virtual Machine data"
        $Script:VirtualMachines = Get-VM 4>$Null| Sort-Object Name 
        $Script:Resources = Get-ResourcePool 4>$Null| Sort-Object Name 
        $Script:VMPlugins = (((Get-View extensionmanager 4>$Null).ExtensionList).Description) 
        $Script:ServiceInstance = Get-View ServiceInstance 4>$Null
        $Script:vCenterStatistics = Get-View ($ServiceInstance).Content.PerfManager 4>$Null
        $Script:VCLicensing = Get-View ($ServiceInstance | Select-Object -First 1).Content.LicenseManager 4>$Null
        $Script:VIPerms = Get-VIPermission 4>$Null| Sort-Object Entity 
        $Script:VIRoles = Get-VIRole 4>$Null| Sort-Object Name 
        $Script:DRSRules = BuildDRSGroupsRules

        If($Full)
        {
            $Script:Snapshots = Get-Snapshot -VM * 4>$Null
            Write-Verbose "$(Get-Date -Format G): Gathering Networking data"
            $Script:HostNetAdapters = Get-VMHostNetworkAdapter 4>$Null
            $Script:VirtualSwitches = Get-VirtualSwitch 4>$Null
            $Script:VMNetworkAdapters = Get-NetworkAdapter * 4>$Null
            $Script:VirtualPortGroups = Get-VirtualPortGroup 4>$Null
        }
    }
	
    ## Cannot use Get-VMHostStorage in the event of a completely headless server with no local storage (cdrom, local disk, etc)
    ## Get-VMHostStorage with a wildcard will fail on headless servers so it must be called for each host
}

Function AddStatsChart
{
	Param
	(
		# Needed paramaters: ChartType, Title, Width, Length, ChartName, Format
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='StatData', Position=0)][ValidateNotNullOrEmpty()] $StatData,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] $StatData2 = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] $StatData3 = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string] $Data1Label = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string] $Data2Label = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string] $Data3Label = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string] $Type = $null,
		[Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)] [string] $Title = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [int] $Width = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [int] $Length = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string] $ExportName = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [string] $ExportType = $null,
		[Parameter(ValueFromPipelineByPropertyName=$true)] [AllowNull()] [switch] $Legend = $false
	)

	Process
	{
		# load the appropriate assemblies 
		[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
		[void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

		# http://blogs.technet.com/b/richard_macdonald/archive/2009/04/28/3231887.aspx
		# create the chart object
		$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart 
		## Ensure .NET Charting is installed
		If(!$?)
		{
			## Assembly not loaded - exit
			Write-Host "`n
			Microsoft Chart Controls for .NET is not installed but required to generate chart images. 
			`n
			Please install the latest version and run this script again. This script will now exit. 
			`n
			http://www.microsoft.com/en-us/download/details.aspx?id=14422"
			AbortScript            
		}  
		Else
		{
			## Assembly loaded
			Write-Host "$(Get-Date -Format G): Gathering data from VMware stats to build performance graph"
		}
		
		$Chart.Width = $Width
		$Chart.Height = $Length

		# create a chartarea to draw on and add to chart 
		$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea 
		$Chart.ChartAreas.Add($ChartArea)

		# get Time\value data from Get-Stats
		$VMTime = @(ForEach($stamp in $StatData){$stamp.TimeStamp})
		$VMValue = @(ForEach($stamp2 in $StatData){$stamp2.Value})

		# convert KB memory to GB
		If(($StatData.unit | Select-Object -Unique) -eq "KB")
		{
			$KBConversion = $true
			$ChartArea.AxisY.Title = "GB"
			$tempArr = @()
			ForEach($ValueData in $VMValue)
			{
				$tempArr += $ValueData / 1048576
			}
			$VMValue = $tempArr
		}
		Else
		{
			If($StatData.unit | Select-Object -Unique)
			{
				$ChartArea.AxisY.Title = ($StatData.unit | Select-Object -Unique) 
			}
		}

		# add titles and data series
		[void]$Chart.Titles.Add($Title)

		If(!$Data1Label)
		{
			$Data1Label = "Data 1"
		}
		[void]$Chart.Series.Add($Data1Label) 
		$Chart.Series[$Data1Label].Points.DataBindXY($VMTime, $VMValue)
		$Chart.Series[$Data1Label].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$Type
		$Chart.Series[$Data1Label].Color = [System.Drawing.Color]::Blue

		# add 2nd data series
		If($StatData2)
		{
			If(!$Data2Label)
			{
				$Data2Label = "Data 2"
			}
			$VMTime2 = @(ForEach($stamp in $StatData2){$stamp.TimeStamp})
			$VMValue2 = @(ForEach($stamp2 in $StatData2){$stamp2.Value})
			If($KBConversion)
			{
				$tempArr = @()
				ForEach($ValueData2 in $VMValue2)
				{
					$tempArr += $ValueData2 / 1048576
				}
				$VMValue2 = $tempArr
			}
			[void]$Chart.Series.Add($Data2Label)
			$Chart.Series[$Data2Label].Points.DataBindXY($VMTime2, $VMValue2)
			$Chart.Series[$Data2Label].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$Type
			$Chart.Series[$Data2Label].Color = [System.Drawing.Color]::Red
		}

		# add 3rd data series
		If($StatData3)
		{
			If(!$Data3Label)
			{
				$Data3Label = "Data 3"
			}
			$VMTime3 = @(ForEach($stamp in $StatData3){$stamp.TimeStamp})
			$VMValue3 = @(ForEach($stamp2 in $StatData3){$stamp2.Value})
			If($KBConversion)
			{
				$tempArr = @()
				ForEach($ValueData3 in $VMValue3)
				{
					$tempArr += $ValueData3 / 1048576
				}
				$VMValue3 = $tempArr
			}
			[void]$Chart.Series.Add($Data3Label)
			$Chart.Series[$Data3Label].Points.DataBindXY($VMTime3, $VMValue3)
			$Chart.Series[$Data3Label].ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::$Type
			$Chart.Series[$Data3Label].Color = [System.Drawing.Color]::Green
		}

		$Chart.BackColor = [System.Drawing.Color]::Transparent

		# add a legend
		If($Legend)
		{
			$ChartLegend = New-Object System.Windows.Forms.DataVisualization.Charting.Legend
			$Chart.Legends.Add($ChartLegend) | Out-Null
			#$Chart.Legends.Add($Legend) | Out-Null
		}

		If(!$ExportName)
		{
			$Chart.SaveImage("$($Script:pwdpath)\Chart$($Title).png", "PNG")
			$Script:Word.Selection.InlineShapes.AddPicture("$($Script:pwdpath)\Chart$($Title).png") | Out-Null
			If(Test-Path "$($Script:pwdpath)\Chart$($Title).png")
			{
				Remove-Item "$($Script:pwdpath)\Chart$($Title).png" -Force
			}
		}
	} # End Process
}

Function BuildDRSGroupsRules
{
	$DRSGroupsRules = @()
    ## From http://www.vnugglets.com/2011/07/backupexport-full-drs-rule-info-via.html
    Get-View -ViewType ClusterComputeResource -Property Name, ConfigurationEx 4>$Null| ForEach-Object{
        ## if the cluster has any DRS rules
        If($Null -ne $_.ConfigurationEx.Rule)
		{
            $viewCurrClus = $_
            $DRSGroupsRules = @()
            $viewCurrClus.ConfigurationEx.Rule | ForEach-Object {
                $oRuleInfo = New-Object -Type PSObject -Property @{
                    ClusterName = $viewCurrClus.Name
                    RuleName = $_.Name
                    RuleType = $_.GetType().Name
                    bRuleEnabled = $_.Enabled
                    bMandatory = $_.Mandatory
                } 
 
                ## add members to the output object, to be populated in a bit
                "bKeepTogether,VMNames,VMGroupName,VMGroupMembers,AffineHostGrpName,AffineHostGrpMembers,AntiAffineHostGrpName,AntiAffineHostGrpMembers".Split(",") | ForEach-Object {Add-Member -InputObject $oRuleInfo -MemberType NoteProperty -Name $_ -Value $null}
 
                ## switch statement based on the object type of the .NET view object
                Switch($_){
                    ## if it is a ClusterVmHostRuleInfo rule, get the VM info from the cluster View object
                    #   a ClusterVmHostRuleInfo item "identifies virtual machines and host groups that determine virtual machine placement"
                    {$_ -is [VMware.Vim.ClusterVmHostRuleInfo]} {
                        $oRuleInfo.VMGroupName = $_.VmGroupName
                        ## get the VM group members' names
                        $oRuleInfo.VMGroupMembers = (Get-View -Property Name -Id ($viewCurrClus.ConfigurationEx.Group | Where-Object {($_ -is [VMware.Vim.ClusterVmGroup]) -and ($_.Name -eq $oRuleInfo.VMGroupName)}).Vm 4>$Null| ForEach-Object {$_.Name}) -join ","
                        $oRuleInfo.AffineHostGrpName = $_.AffineHostGroupName
                        ## get affine hosts' names
                        $oRuleInfo.AffineHostGrpMembers = If($Null -ne $_.AffineHostGroupName) {(Get-View -Property Name -Id ($viewCurrClus.ConfigurationEx.Group | Where-Object {($_ -is [VMware.Vim.ClusterHostGroup]) -and ($_.Name -eq $oRuleInfo.AffineHostGrpName)}).Host 4>$Null| ForEach-Object {$_.Name}) -join ","}
                        $oRuleInfo.AntiAffineHostGrpName = $_.AntiAffineHostGroupName
                        ## get anti-affine hosts' names
                        $oRuleInfo.AntiAffineHostGrpMembers = If($Null -ne $_.AntiAffineHostGroupName) {(Get-View -Property Name -Id ($viewCurrClus.ConfigurationEx.Group | Where-Object {($_ -is [VMware.Vim.ClusterHostGroup]) -and ($_.Name -eq $oRuleInfo.AntiAffineHostGrpName)}).Host 4>$Null| ForEach-Object {$_.Name}) -join ","}
                        break;
                    } 
                    ## if ClusterAffinityRuleSpec (or AntiAffinity), get the VM names (using Get-View)
                    {($_ -is [VMware.Vim.ClusterAffinityRuleSpec]) -or ($_ -is [VMware.Vim.ClusterAntiAffinityRuleSpec])} {
                        $oRuleInfo.VMNames = If($_.Vm.Count -gt 0) {(Get-View -Property Name -Id $_.Vm 4>$Null| ForEach-Object {$_.Name}) -join ","}
                    } 
                    {$_ -is [VMware.Vim.ClusterAffinityRuleSpec]} {
                        $oRuleInfo.bKeepTogether = $true
                    } 
                    {$_ -is [VMware.Vim.ClusterAntiAffinityRuleSpec]} {
                        $oRuleInfo.bKeepTogether = $false
                    }
                    default {"none of the above"}
                }
 
                $DRSGroupsRules += $oRuleInfo
            } 
        } 
		Else
		{
            $DRSGroupsRules = @()
		}
    } 
    Return $DRSGroupsRules
}

Function truncate
{
    Param([string]$strIn, [int]$length)
    If($strIn.Length -gt $length)
	{
		"$($strIn.Substring(0, $length))..." 
	}
    Else
	{ 
		$strIn 
	}
}

Function ShowScriptOptions
{
	Write-Verbose "$(Get-Date -Format G): "
	Write-Verbose "$(Get-Date -Format G): "
	Write-Verbose "$(Get-Date -Format G): AddDateTime    : $AddDateTime"
	Write-Verbose "$(Get-Date -Format G): Chart          : $Chart"
	If($MSWORD -or $PDF)
	{
		Write-Verbose "$(Get-Date -Format G): Company Address: $CompanyAddress"
		Write-Verbose "$(Get-Date -Format G): Company Email  : $CompanyEmail"
		Write-Verbose "$(Get-Date -Format G): Company Fax    : $CompanyFax"
		Write-Verbose "$(Get-Date -Format G): Company Name   : $Script:CoName"
		Write-Verbose "$(Get-Date -Format G): Company Phone  : $CompanyPhone"
		Write-Verbose "$(Get-Date -Format G): Cover Page     : $CoverPage"
	}
	Write-Verbose "$(Get-Date -Format G): Dev            : $Dev"
	If($Dev)
	{
		Write-Verbose "$(Get-Date -Format G): DevErrorFile   : $Script:DevErrorFile"
	}
	Write-Verbose "$(Get-Date -Format G): Export         : $Export"
	If($HTML)
	{
		Write-Verbose "$(Get-Date -Format G): HTMLFilename   : $Script:HTMLFilename"
	}
	If($MSWord)
	{
		Write-Verbose "$(Get-Date -Format G): WordFilename   : $Script:WordFilename"
	}
	If($PDF)
	{
		Write-Verbose "$(Get-Date -Format G): PDFFilename    : $Script:PDFFilename"
	}
	If($Text)
	{
		Write-Verbose "$(Get-Date -Format G): TextFilename   : $Script:TextFilename"
	}
	Write-Verbose "$(Get-Date -Format G): Folder         : $Folder"
	Write-Verbose "$(Get-Date -Format G): From           : $From"
	Write-Verbose "$(Get-Date -Format G): Full           : $Full"
	Write-Verbose "$(Get-Date -Format G): Import         : $Import"
	Write-Verbose "$(Get-Date -Format G): Issues         : $Issues"
	Write-Verbose "$(Get-Date -Format G): Log            : $Log"
	Write-Verbose "$(Get-Date -Format G): Report Footer  : $ReportFooter"
	Write-Verbose "$(Get-Date -Format G): Save As HTML   : $HTML"
	Write-Verbose "$(Get-Date -Format G): Save As PDF    : $PDF"
	Write-Verbose "$(Get-Date -Format G): Save As TEXT   : $TEXT"
	Write-Verbose "$(Get-Date -Format G): Save As WORD   : $MSWORD"
	Write-Verbose "$(Get-Date -Format G): ScriptInfo     : $ScriptInfo"
	Write-Verbose "$(Get-Date -Format G): Smtp Port      : $SmtpPort"
	Write-Verbose "$(Get-Date -Format G): Smtp Server    : $SmtpServer"
	Write-Verbose "$(Get-Date -Format G): Title          : $Script:Title"
	Write-Verbose "$(Get-Date -Format G): To             : $To"
	Write-Verbose "$(Get-Date -Format G): Use SSL        : $UseSSL"
	If($MSWORD -or $PDF)
	{
		Write-Verbose "$(Get-Date -Format G): User Name      : $UserName"
	}
	Write-Verbose "$(Get-Date -Format G): VIServerName   : $VIServerName"
	Write-Verbose "$(Get-Date -Format G): "
	Write-Verbose "$(Get-Date -Format G): OS Detected    : $Script:RunningOS"
	Write-Verbose "$(Get-Date -Format G): PoSH version   : $($Host.Version)"
	Write-Verbose "$(Get-Date -Format G): PSCulture      : $PSCulture"
	Write-Verbose "$(Get-Date -Format G): PSUICulture    : $PSUICulture"
	If($MSWORD -or $PDF)
	{
		Write-Verbose "$(Get-Date -Format G): Word language  : $Script:WordLanguageValue"
		Write-Verbose "$(Get-Date -Format G): Word version   : $Script:WordProduct"
	}
	Write-Verbose "$(Get-Date -Format G): "
	Write-Verbose "$(Get-Date -Format G): Script start   : $Script:StartTime"
	Write-Verbose "$(Get-Date -Format G): "
	Write-Verbose "$(Get-Date -Format G): "
}

Function validStateProp( [object] $object, [string] $topLevel, [string] $secondLevel )
{
	#function created 8-jan-2014 by Michael B. Smith
	If( $object )
	{
		If( ( Get-Member -Name $topLevel -InputObject $object ) )
		{
			If( ( Get-Member -Name $secondLevel -InputObject $object.$topLevel ) )
			{
				Return $True
			}
		}
	}
	Return $False
}

Function validObject( [object] $object, [string] $topLevel )
{
	#function created 8-jan-2014 by Michael B. Smith
	If( $object )
	{
		If((Get-Member -Name $topLevel -InputObject $object))
		{
			Return $True
		}
	}
	Return $False
}

Function SaveandCloseDocumentandShutdownWord
{
	#bug fix 1-Apr-2014
	#reset Grammar and Spelling options back to their original settings
	$Script:Word.Options.CheckGrammarAsYouType = $Script:CurrentGrammarOption
	$Script:Word.Options.CheckSpellingAsYouType = $Script:CurrentSpellingOption

	Write-Verbose "$(Get-Date -Format G): Save and Close document and Shutdown Word"
	If($Script:WordVersion -eq $wdWord2010)
	{
		#the $saveFormat below passes StrictMode 2
		#I found this at the following two links
		#http://msdn.microsoft.com/en-us/library/microsoft.office.interop.word.wdsaveformat(v=office.14).aspx
		If($PDF)
		{
			Write-Verbose "$(Get-Date -Format G): Saving as DOCX file first before saving to PDF"
		}
		Else
		{
			Write-Verbose "$(Get-Date -Format G): Saving DOCX file"
		}
		Write-Verbose "$(Get-Date -Format G): Running $($Script:WordProduct) and detected operating system $($Script:RunningOS)"
		$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatDocumentDefault")
		$Script:Doc.SaveAs([REF]$Script:WordFileName, [ref]$SaveFormat)
		If($PDF)
		{
			Write-Verbose "$(Get-Date -Format G): Now saving as PDF"
			$saveFormat = [Enum]::Parse([Microsoft.Office.Interop.Word.WdSaveFormat], "wdFormatPDF")
			$Script:Doc.SaveAs([REF]$Script:PDFFileName, [ref]$saveFormat)
		}
	}
	ElseIf($Script:WordVersion -eq $wdWord2013 -or $Script:WordVersion -eq $wdWord2016)
	{
		If($PDF)
		{
			Write-Verbose "$(Get-Date -Format G): Saving as DOCX file first before saving to PDF"
		}
		Else
		{
			Write-Verbose "$(Get-Date -Format G): Saving DOCX file"
		}
		Write-Verbose "$(Get-Date -Format G): Running $($Script:WordProduct) and detected operating system $($Script:RunningOS)"
		$Script:Doc.SaveAs2([REF]$Script:WordFileName, [ref]$wdFormatDocumentDefault)
		If($PDF)
		{
			Write-Verbose "$(Get-Date -Format G): Now saving as PDF"
			$Script:Doc.SaveAs([REF]$Script:PDFFileName, [ref]$wdFormatPDF)
		}
	}

	Write-Verbose "$(Get-Date -Format G): Closing Word"
	$Script:Doc.Close()
	$Script:Word.Quit()
	Write-Verbose "$(Get-Date -Format G): System Cleanup"
	[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Script:Word) | Out-Null
	If(Test-Path variable:global:word)
	{
		Remove-Variable -Name word -Scope Global 4>$Null
	}
	$SaveFormat = $Null
	[gc]::collect() 
	[gc]::WaitForPendingFinalizers()
	
	#is the winword Process still running? kill it

	#find out our session (usually "1" except on TS/RDC or Citrix)
	$SessionID = (Get-Process -PID $PID).SessionId

	#Find out if winword running in our session
	$wordprocess = ((Get-Process 'WinWord' -ea 0) | Where-Object {$_.SessionId -eq $SessionID}) | Select-Object -Property Id 
	If( $wordprocess -and $wordprocess.Id -gt 0)
	{
		Write-Verbose "$(Get-Date -Format G): WinWord Process is still running. Attempting to stop WinWord Process # $($wordprocess.Id)"
		Stop-Process $wordprocess.Id -EA 0
	}
}

Function SetupText
{
	Write-Verbose "$(Get-Date -Format G): Setting up Text"

	[System.Text.StringBuilder] $global:Output = New-Object System.Text.StringBuilder( 16384 )

	If(!$AddDateTime)
	{
		[string]$Script:TextFileName = "$($Script:pwdpath)\$($OutputFileName).txt"
	}
	ElseIf($AddDateTime)
	{
		[string]$Script:TextFileName = "$($Script:pwdpath)\$($OutputFileName)_$(Get-Date -f yyyy-MM-dd_HHmm).txt"
	}
}

Function SetupHTML
{
	Write-Verbose "$(Get-Date -Format G): Setting up HTML"
	If(!$AddDateTime)
	{
		[string]$Script:HTMLFileName = "$($Script:pwdpath)\$($OutputFileName).html"
	}
	ElseIf($AddDateTime)
	{
		[string]$Script:HTMLFileName = "$($Script:pwdpath)\$($OutputFileName)_$(Get-Date -f yyyy-MM-dd_HHmm).html"
	}

	$htmlhead = "<html><head><meta http-equiv='Content-Language' content='da'><title>" + $Script:Title + "</title></head><body>"
	Out-File -FilePath $Script:HTMLFileName -Force -InputObject $HTMLHead 4>$Null
}

Function SaveandCloseTextDocument
{
	Write-Verbose "$(Get-Date -Format G): Saving Text file"
	Line 0 ""
	Line 0 "Report Complete"
	Write-Output $global:Output.ToString() | Out-File $Script:TextFileName 4>$Null
}

Function SaveandCloseHTMLDocument
{
	Write-Verbose "$(Get-Date -Format G): Saving HTML file"
	WriteHTMLLine 0 0 ""
	WriteHTMLLine 0 0 "Report Complete"
	Out-File -FilePath $Script:HTMLFileName -Append -InputObject "<p></p></body></html>" 4>$Null
}

Function SetFileNames
{
	Param([string]$OutputFileName)
	
	If($MSWord -or $PDF)
	{
		CheckWordPreReq
		
		SetupWord
	}
	If($Text)
	{
		SetupText
	}
	If($HTML)
	{
		SetupHTML
	}
	ShowScriptOptions
}

Function OutputReportFooter
{
	<#
	Report Footer
		Report information:
			Created with: <Script Name> - Release Date: <Script Release Date>
			Script version: <Script Version>
			Started on <Date Time in Local Format>
			Elapsed time: nn days, nn hours, nn minutes, nn.nn seconds
			Ran from domain <Domain Name> by user <Username>
			Ran from the folder <Folder Name>

	Script Name and Script Release date are script-specific variables.
	Script version is a script variable.
	Start Date Time in Local Format is a script variable.
	Domain Name is $env:USERDNSDOMAIN.
	Username is $env:USERNAME.
	Folder Name is a script variable.
	#>

	$runtime = $(Get-Date) - $Script:StartTime
	$Str = [string]::format("{0} days, {1} hours, {2} minutes, {3}.{4} seconds",
		$runtime.Days,
		$runtime.Hours,
		$runtime.Minutes,
		$runtime.Seconds,
		$runtime.Milliseconds)

	If($MSWORD -or $PDF)
	{
		$Script:selection.InsertNewPage()
		WriteWordLine 1 0 "Report Footer"
		WriteWordLine 2 0 "Report Information:"
		WriteWordLine 0 1 "Created with: $Script:ScriptName - Release Date: $Script:ReleaseDate"
		WriteWordLine 0 1 "Script version: $Script:MyVersion"
		WriteWordLine 0 1 "Started on $Script:StartTime"
		WriteWordLine 0 1 "Elapsed time: $Str"
		WriteWordLine 0 1 "Ran from domain $env:USERDNSDOMAIN by user $env:USERNAME"
		WriteWordLine 0 1 "Ran from the folder $Script:pwdpath"
	}
	If($Text)
	{
		Line 0 "///  Report Footer  \\\"
		Line 1 "Report Information:"
		Line 2 "Created with: $Script:ScriptName - Release Date: $Script:ReleaseDate"
		Line 2 "Script version: $Script:MyVersion"
		Line 2 "Started on $Script:StartTime"
		Line 2 "Elapsed time: $Str"
		Line 2 "Ran from domain $env:USERDNSDOMAIN by user $env:USERNAME"
		Line 2 "Ran from the folder $Script:pwdpath"
	}
	If($HTML)
	{
		WriteHTMLLine 1 0 "///&nbsp;&nbsp;Report Footer&nbsp;&nbsp;\\\"
		WriteHTMLLine 2 0 "Report Information:"
		WriteHTMLLine 0 1 "Created with: $Script:ScriptName - Release Date: $Script:ReleaseDate"
		WriteHTMLLine 0 1 "Script version: $Script:MyVersion"
		WriteHTMLLine 0 1 "Started on $Script:StartTime"
		WriteHTMLLine 0 1 "Elapsed time: $Str"
		WriteHTMLLine 0 1 "Ran from domain $env:USERDNSDOMAIN by user $env:USERNAME"
		WriteHTMLLine 0 1 "Ran from the folder $Script:pwdpath"
	}
}

Function ProcessDocumentOutput
{
	If($MSWORD -or $PDF)
	{
		SaveandCloseDocumentandShutdownWord
	}
	If($Text)
	{
		SaveandCloseTextDocument
	}
	If($HTML)
	{
		SaveandCloseHTMLDocument
	}

	$GotFile = $False

	If($MSWord)
	{
		If(Test-Path "$($Script:WordFileName)")
		{
			Write-Verbose "$(Get-Date -Format G): $($Script:WordFileName) is ready for use"
			$GotFile = $True
		}
		Else
		{
			Write-Error "Unable to save the output file, $($Script:WordFileName)"
		}
	}
	If($PDF)
	{
		If(Test-Path "$($Script:PDFFileName)")
		{
			Write-Verbose "$(Get-Date -Format G): $($Script:PDFFileName) is ready for use"
			$GotFile = $True
		}
		Else
		{
			Write-Error "Unable to save the output file, $($Script:PDFFileName)"
		}
	}
	If($Text)
	{
		If(Test-Path "$($Script:TextFileName)")
		{
			Write-Verbose "$(Get-Date -Format G): $($Script:TextFileName) is ready for use"
			$GotFile = $True
		}
		Else
		{
			Write-Error "Unable to save the output file, $($Script:TextFileName)"
		}
	}
	If($HTML)
	{
		If(Test-Path "$($Script:HTMLFileName)")
		{
			Write-Verbose "$(Get-Date -Format G): $($Script:HTMLFileName) is ready for use"
			$GotFile = $True
		}
		Else
		{
			Write-Error "Unable to save the output file, $($Script:HTMLFileName)"
		}
	}
	
	#email output file if requested
	If($GotFile -and ![System.String]::IsNullOrEmpty( $SmtpServer ))
	{
		$emailattachments = @()
		If($MSWord)
		{
			$emailAttachments += $Script:WordFileName
		}
		If($PDF)
		{
			$emailAttachments += $Script:PDFFileName
		}
		If($Text)
		{
			$emailAttachments += $Script:TextFileName
		}
		If($HTML)
		{
			$emailAttachments += $Script:HTMLFileName
		}
		SendEmail $emailAttachments
	}
}
#endregion

#region Summary and vCenter functions
Function ProcessSummary
{
	Write-Verbose "$(Get-Date -Format G): Processing Summary page"
	If($MSWord -or $PDF)
	{
		$Selection.InsertNewPage()
		WriteWordLine 1 0 "vCenter Summary"

		$TableRange = $doc.Application.Selection.Range
		$Table = $doc.Tables.Add($TableRange, 1, 5)
		$Table.Style = $Script:MyHash.Word_TableGrid
		$Table.Cell(1,1).Range.Text = "Legend: "
		$Table.Cell(1,2).Range.Text = "0% - 69%"
		$Table.Cell(1,3).Range.Text = "70% - 79%"
		$Table.Cell(1,4).Range.Text = "80% - 89%"
		$Table.Cell(1,5).Range.Text = "90% - 100%"

		SetWordCellFormat -Cell $Table.Cell(1,2) -BackgroundColor 7405514
		SetWordCellFormat -Cell $Table.Cell(1,3) -BackgroundColor 9434879
		SetWordCellFormat -Cell $Table.Cell(1,4) -BackgroundColor 42495
		SetWordCellFormat -Cell $Table.Cell(1,5) -BackgroundColor 238

		$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
		$Table.AutoFitBehavior($wdAutoFitContent)

		#return focus back to document
		$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

		#move to the end of the current document
		$selection.EndKey($wdStory,$wdMove) | Out-Null
		$TableRange = $Null
		$Table = $Null
		WriteWordLine 0 0 ""
	}
	If($HTML)
	{
		WriteHTMLLine 1 0 "vCenter Summary"
		$rowData = @()
		$columnHeaders = @(
			"Legend",$htmlwhite,
			'0% - 69%',$htmlgreen,
			'70% - 79%',$htmlyellow,
			'80% - 89%',$htmlorange,
			'90% - 100%',$htmlred
		)
		FormatHTMLTable "" -columnArray $columnHeaders
		WriteHTMLLine 0 1 ""
	}
	If($Text)
	{
		Line 0 "vCenter Summary"
		Line 1 "Legend: "
		Line 2 "0% - 69%   - *"
		Line 2 "70% - 79%  - **"
		Line 2 "80% - 89%  - ***" 
		Line 2 "90% - 100% - ****"
		Line 0 ""
	}

    ## Cluster Summary
    Write-Verbose "$(Get-Date -Format G): `tProcessing Cluster Summary"
    If($MSWord -or $PDF)
    {
        WriteWordLine 2 0 "Cluster Summary"

        ## Create an array of hashtables
	    [System.Collections.Hashtable[]] $ClusterWordTable = @();
	    ## Seed the row index from the second row
	    [int] $CurrentServiceIndex = 2;

        ForEach($Cluster in $Script:Clusters)
        {
            ## Add the required key/values to the hashtable
	        $WordTableRowHash = @{ 
				Cluster        = $Cluster.Name;
				HostsinCluster = @($VMHosts | Where-Object{$_.IsStandAlone -eq $False -and $_.Parent -like $Cluster.Name}).Count;
				HAEnabled      = $Cluster.HAEnabled;
				DRSEnabled     = $Cluster.DrsEnabled;
				DRSAutomation  = $Cluster.DrsAutomationLevel;
				VMCount        = @($Script:VirtualMachines | Where-Object{$_.VMHost -in @($VMHosts | Where-Object{$_.ParentId -like $Cluster.Id}).Name}).Count;
	        }
	        ## Add the hash to the array
	        $ClusterWordTable += $WordTableRowHash;
	        $CurrentServiceIndex++;
        }

        ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($ClusterWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $ClusterWordTable `
			-Columns Cluster, HostsinCluster, HAEnabled, DRSEnabled, DRSAutomation, VMCount `
			-Headers "Cluster Name", "Host Count", "HA Enabled", "DRS Enabled", "DRS Automation Level", "VM Count" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
    }
    If($HTML)
    {
        $rowData = @()
        $columnHeaders = @(
			"Cluster Name",($htmlsilver -bor $htmlbold),
			"Host Count",($htmlsilver -bor $htmlbold),
			"HA Enabled",($htmlsilver -bor $htmlbold),
			"DRS Enabled",($htmlsilver -bor $htmlbold),
			"DRS Automation Level",($htmlsilver -bor $htmlbold),
			"VM Count",($htmlsilver -bor $htmlbold)
		)

        ForEach($Cluster in $Script:Clusters)
        {
            $rowData += @(,(
				$Cluster.Name,$htmlwhite,
				@($VMHosts | Where-Object{$_.IsStandAlone -eq $False -and $_.Parent -like $Cluster.Name}).Count,$htmlwhite,
				$Cluster.HAEnabled,$htmlwhite,
				$Cluster.DrsEnabled,$htmlwhite,
				$Cluster.DrsAutomationLevel,$htmlwhite,
				@($Script:VirtualMachines | Where-Object{$_.VMHost -in @($VMHosts | Where-Object{$_.ParentId -like $Cluster.Id}).Name}).Count,$htmlwhite)
			)
        }
        FormatHTMLTable "Cluster Summary" -rowArray $rowData -columnArray $columnHeaders
        WriteHTMLLine 0 1 ""
    }
	If($Text)
	{
		Line 0 "Cluster Summary"
        Line 1 "Cluster Name               Host Count  HA Enabled  DRS Enabled  DRS Automation Level  VM Count"
		Line 1 "=============================================================================================="
		       #1234567890123456789012345SS1234567890SS1234567890SS12345678901SS12345678901234567890SS12345678

        ForEach($Cluster in $Script:Clusters)
        {
			Line 1 ( "{0,-25}  {1,-10}  {2,-10}  {3,-11}  {4,-20}  {5,-8}" -f `
				$Cluster.Name,
				@($VMHosts | Where-Object{$_.IsStandAlone -eq $False -and $_.Parent -like $Cluster.Name}).Count,
				$Cluster.HAEnabled,
				$Cluster.DrsEnabled,
				$Cluster.DrsAutomationLevel,
				@($Script:VirtualMachines | Where-Object{$_.VMHost -in @($VMHosts | Where-Object{$_.ParentId -like $Cluster.Id}).Name}).Count
			)
        }
        Line 0 ""
	}

    ##Host summary
    Write-Verbose "$(Get-Date -Format G): `tProcessing Host Summary"
    If($MSWord -or $PDF)
    {
        WriteWordLine 2 0 "Host Summary"
        ## Create an array of hashtables
	    [System.Collections.Hashtable[]] $HostWordTable = @();
	    ## Seed the row index from the second row
	    [int] $CurrentServiceIndex = 2;

        $heatMap = @{Row = @(); Column = @(); Color = @()}
        ForEach($VMHost in $VMHosts)
        {
            If($VMHost.IsStandAlone)
            {
                $xStandAlone = "Standalone"
            }
            Else
            {
                $xStandAlone = $VMhost.Parent
            }

            ## Add the required key/values to the hashtable
	        $WordTableRowHash = @{ 
				VMHost          = $VMHost.Name;
				ConnectionState = $VMHost.ConnectionState;
				ESXVersion      = $VMHost.Version;
				ClusterMember   = $xStandAlone;
				CPUPercent      = $("{0:P2}" -f $($VMHost.CpuUsageMhz / $VMHost.CpuTotalMhz));
				MemoryPercent   = $("{0:P2}" -f $($VMhost.MemoryUsageGB / $VMHost.MemoryTotalGB));
				VMCount         = @(($Script:VirtualMachines) | Where-Object{$_.VMHost -like $VMHost.Name}).Count;
	        }

            ## Build VMHost heatmap
            Switch([decimal]($WordTableRowHash.CPUPercent -replace '%' -replace ',','.'))
            {
                {$_ -lt 70}					{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(5); $heatMap.Color += @(7405514); Break}
                {$_ -ge 70 -and $_ -lt 80}	{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(5); $heatMap.Color += @(9434879); Break}
                {$_ -ge 80 -and $_ -lt 90}	{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(5); $heatMap.Color += @(42495); Break}
                {$_ -ge 90 -and $_ -le 100}	{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(5); $heatMap.Color += @(238); Break}
            }
            Switch([decimal]($WordTableRowHash.MemoryPercent -replace '%' -replace ',','.'))
            {
                {$_ -lt 70}					{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(6); $heatMap.Color += @(7405514); Break}
                {$_ -ge 70 -and $_ -lt 80}	{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(6); $heatMap.Color += @(9434879); Break}
                {$_ -ge 80 -and $_ -lt 90}	{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(6); $heatMap.Color += @(42495); Break}
                {$_ -ge 90 -and $_ -le 100}	{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(6); $heatMap.Color += @(238); Break}
            }
	        ## Add the hash to the array
	        $HostWordTable += $WordTableRowHash;
	        $CurrentServiceIndex++;
    
        }

        ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($HostWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $HostWordTable `
			-Columns VMHost, ConnectionState, ESXVersion, ClusterMember, CPUPercent, MemoryPercent, VMCount `
			-Headers "Host Name", "Connection State", "ESX Version", "Parent Cluster", "CPU Used %", "Memory Used %", "VM Count" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordTableAlternateRowColor $Table $wdColorGray05 "Second"
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;
			For($i = 0; $i -lt $heatMap.Row.Count; $i++)
			{
				SetWordCellFormat -Cell $Table.Cell($heatMap.Row[$i],$heatMap.Column[$i]) -BackgroundColor $heatMap.Color[$i]
			}

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
    }
    If($HTML)
    {
        $rowData = @()
        $columnHeaders = @(
			"Host Name",($htmlsilver -bor $htmlbold),
			"Connection State",($htmlsilver -bor $htmlbold),
			"ESX Version",($htmlsilver -bor $htmlbold),
			"Parent Cluster",($htmlsilver -bor $htmlbold),
			'CPU Used %',($htmlsilver -bor $htmlbold),
			'Memory Used %',($htmlsilver -bor $htmlbold),
			"VM Count",($htmlsilver -bor $htmlbold)
		)
		
        ForEach($VMHost in $VMHosts)
        {
            If($VMHost.IsStandAlone)
            {
                $xStandAlone = "Standalone"
            }
            Else
            {
                $xStandAlone = $VMhost.Parent
            }

            $cpuPerc = HTMLHeatMap (($VMHost.CpuUsageMhz / $VMHost.CpuTotalMhz) * 100)
            $memPerc = HTMLHeatMap (($VMhost.MemoryUsageGB / $VMHost.MemoryTotalGB) * 100)
            $rowData += @(,(
				$VMHost.Name,$htmlwhite,
				$VMHost.ConnectionState,$htmlwhite,
				$VMHost.Version,$htmlwhite,
				$xStandAlone,$htmlwhite,
				$("{0:P2}" -f $($VMHost.CpuUsageMhz / $VMHost.CpuTotalMhz)),$cpuPerc,
				$("{0:P2}" -f $($VMhost.MemoryUsageGB / $VMHost.MemoryTotalGB)),$memPerc,
				@(($Script:VirtualMachines) | Where-Object{$_.VMHost -like $VMHost.Name}).Count,$htmlwhite)
			)
        }

        FormatHTMLTable "Host Summary" -rowArray $rowData -columnArray $columnHeaders
        WriteHTMLLine 0 1 ""
    }
	If($Text)
	{
		Line 0 "Host Summary"
		Line 1 "Host Name                       Connection State  ESX Version  Parent Cluster       CPU Used %   Memory Used %  VM Count"
		Line 1 "==================================================================================================================="
		       #123456789012345678901234567890SS1234567890123456SS12345678901SS123456789012345SS12345678901234SS12345678901234SS12345678

        ForEach($VMHost in $VMHosts)
        {
            If($VMHost.IsStandAlone)
            {
                $xStandAlone = "Standalone"
            }
            Else
            {
                $xStandAlone = $VMhost.Parent
            }

            $cpuPerc = TextHeatMap (($VMHost.CpuUsageMhz / $VMHost.CpuTotalMhz) * 100)
            $memPerc = TextHeatMap (($VMhost.MemoryUsageGB / $VMHost.MemoryTotalGB) * 100)

			Line 1 ( "{0,-30}  {1,-16}  {2,-11}  {3,-15}  {4,-14}  {5,-14}  {6,-8}" -f `
				(truncate $VMHost.Name 27),
				$VMHost.ConnectionState,
				$VMHost.Version,
				$xStandAlone,
				$cpuPerc,
				$memPerc,
				@($Script:VirtualMachines | Where-Object{$_.VMHost -like $VMHost.Name}).Count
			)
        }
        Line 0 ""
	}

	##Datastore summary
	Write-Verbose "$(Get-Date -Format G): `tProcessing Datastore Summary"
	If($MSWord -or $PDF)
	{
		WriteWordLine 2 0 "Datastore Summary"
		## Create an array of hashtables
		[System.Collections.Hashtable[]] $DatastoreWordTable = @();
		## Seed the row index from the second row
		[int] $CurrentServiceIndex = 2;

		$heatMap = @{Row = @(); Column = @(); Color = @()}
		ForEach($Datastore in $Script:Datastores)
		{
			$WordTableRowHash = @{
				Datastore  = $Datastore.Name;
				DSType     = $Datastore.Type;
				DSTotalCap = $("{0:N2}" -f $Datastore.CapacityGB + " GB");
				DSFreeCap  = $("{0:N2}" -f $Datastore.FreeSpaceGB + " GB");
				DSFreePerc = $("{0:P2}" -f $(($Datastore.CapacityGB - $Datastore.FreeSpaceGB) / $Datastore.CapacityGB));
			}

			## Build Datastore summary heatmap
			Switch([decimal]($WordTableRowHash.DSFreePerc -replace '%' -replace ',','.'))
			{
				{$_ -lt 70}					{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(5); $heatMap.Color += @(7405514); Break}
				{$_ -ge 70 -and $_ -lt 80}	{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(5); $heatMap.Color += @(9434879); Break}
				{$_ -ge 80 -and $_ -lt 90}	{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(5); $heatMap.Color += @(42495); Break}
				{$_ -ge 90 -and $_ -le 100}	{$heatMap.Row += @($CurrentServiceIndex); $heatMap.Column += @(5); $heatMap.Color += @(238); Break}
			}
			## Add the hash to the array
			$DatastoreWordTable += $WordTableRowHash;
			$CurrentServiceIndex++;
		}

		## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($DatastoreWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $DatastoreWordTable `
			-Columns Datastore, DSType, DSTotalCap, DSFreeCap, DSFreePerc `
			-Headers "Datastore Name", "Type", "Total Capacity", "Free Space", "Percent Used" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordTableAlternateRowColor $Table $wdColorGray05 "Second"
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;
			For($i = 0; $i -lt $heatMap.Row.Count; $i++)
			{
				SetWordCellFormat -Cell $Table.Cell($heatMap.Row[$i],$heatMap.Column[$i]) -BackgroundColor $heatMap.Color[$i]
			}

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
	}
	If($HTML)
	{
		$rowData = @()
		$columnHeaders = @(
			"Datastore Name",($htmlsilver -bor $htmlbold),
			"Type",($htmlsilver -bor $htmlbold),
			"Total Capacity",($htmlsilver -bor $htmlbold),
			"Free Space",($htmlsilver -bor $htmlbold),
			"Percent Used",($htmlsilver -bor $htmlbold)
		)

		ForEach($Datastore in $Script:Datastores)
		{
			$dsPerc = HTMLHeatMap ((($Datastore.CapacityGB - $Datastore.FreeSpaceGB) / $Datastore.CapacityGB) * 100)
			$rowData += @(,(
				$Datastore.Name,$htmlwhite,
				$Datastore.Type,$htmlwhite,
				$("{0:N2}" -f $Datastore.CapacityGB + " GB"),$htmlwhite,
				$("{0:N2}" -f $Datastore.FreeSpaceGB + " GB"),$htmlwhite,
				$("{0:P2}" -f $(($Datastore.CapacityGB - $Datastore.FreeSpaceGB) / $Datastore.CapacityGB)),$dsPerc)
			)
		}

		FormatHTMLTable "Datastore Summary" -rowArray $rowData -columnArray $columnHeaders
	}
	If($Text)
	{
		Line 0 "Datastore Summary"
		Line 1 "Datastore Name                  Type   Total Capacity  Free Space      Percent Used"
		Line 1 "==================================================================================="
		       #123456789012345678901234567890SS12345SS12345678901234SS12345678901234SS123456789012

		ForEach($Datastore in $Script:Datastores)
		{
			$dsPerc = TextHeatMap ((($Datastore.CapacityGB - $Datastore.FreeSpaceGB) / $Datastore.CapacityGB) * 100)

			Line 1 ( "{0,-30}  {1,-5}  {2,-14}  {3,-14}  {4,-12}" -f `
				(truncate $Datastore.Name 27),
				$Datastore.Type,
				$("{0:N2}" -f $Datastore.CapacityGB + " GB"),
				$("{0:N2}" -f $Datastore.FreeSpaceGB + " GB"),
				$("{0:P2}" -f $(($Datastore.CapacityGB - $Datastore.FreeSpaceGB) / $Datastore.CapacityGB)),
				$dsPerc
			)
		}
		Line 0 ""
	}
}

Function ProcessvCenter
{
    Write-Verbose "$(Get-Date -Format G): Processing vCenter Global Settings"
    If($MSWord -or $PDF)
	{
        $Selection.InsertNewPage()
		WriteWordLine 1 0 "vCenter Server"
	}
    If($HTML)
    {
        WriteHTMLLine 1 0 "vCenter Server"
    }
	If($Text)
	{
		Line 0 "vCenter Server"
	} 
    
    ## Global vCenter settings
    ## Try to get vCenter DSN if Windows Server
    If(!$Import)
    {
		#	https://www.virtuallyghetto.com/2015/06/quick-tip-determining-the-vcenter-server-os-platform-windows-or-vcsa-using-vsphere-api.html
		If($Script:VCObj.ExtensionData.Content.About -like "*win32*")	# skip checking for DSN if not a Windows vCenter
		{
			Write-Verbose "$(Get-Date -Format G): `tRetrieving vCenter DSN"
			$RemReg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $VIServerName)
			If($?)
			{
				$VCDBKey = "SOFTWARE\\VMware, Inc.\\VMware VirtualCenter\\DB"
				$VCDB = ($RemReg[0].OpenSubKey($VCDBKey,$true)).GetValue("1")

				$DBDetails = "SOFTWARE\\ODBC\\ODBC.INI\\$($VCDB)"   
			}
		}
		Else
		{
			$VCDB = $False
			Write-Verbose "$(Get-Date -Format G): `tRunning VCSA"
		}
    }

    If($Export)
    {
		Write-Verbose "$(Get-Date -Format G): `tProcessing Export"
        $RegExpObj = New-Object psobject
        $RegExpObj | Add-Member -Name VCDB      -MemberType NoteProperty -Value $VCDB
        $RegExpObj | Add-Member -Name SQLDB     -MemberType NoteProperty -Value ($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("Database")
        $RegExpObj | Add-Member -Name SQLServer -MemberType NoteProperty -Value ($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("Server")
        $RegExpObj | Add-Member -Name SQLUser   -MemberType NoteProperty -Value ($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("LastUser")
        $RegExpObj | Export-Clixml .\Export\RegSQL.xml 4>$Null
    }

    Write-Verbose "$(Get-Date -Format G): `tOutput vCenter Global Settings"
    If($MSWord -or $PDF)
    {
        WriteWordLine 2 0 "Global Settings"
        [System.Collections.Hashtable[]] $ScriptInformation = @()
        $ScriptInformation += @{ Data = "Name"; Value = (($VCAdvSettings) | Where-Object{$_.Name -like "VirtualCenter.FQDN"}).Value;}
        $ScriptInformation += @{ Data = "Version"; Value = $VCObj.Version; }
        $ScriptInformation += @{ Data = "Build"; Value = $VCObj.Build; }
        If($Import -and $RegSQL)
        {
            $ScriptInformation += @{ Data = "DSN Name"; Value = $RegSQL.VCDB; }
            $ScriptInformation += @{ Data = "SQL Database"; Value = $RegSQL.SQLDB; }
            $ScriptInformation += @{ Data = "SQL Server"; Value = $RegSQL.SQLServer; }
            $ScriptInformation += @{ Data = "Last SQL User"; Value = $RegSQL.SQLUser; }
        }
        ElseIf($VCDB)
        {
            $ScriptInformation += @{ Data = "DSN Name"; Value = $VCDB; }
            $ScriptInformation += @{ Data = "SQL Database"; Value = ($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("Database"); }
            $ScriptInformation += @{ Data = "SQL Server"; Value = ($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("Server"); }
            $ScriptInformation += @{ Data = "Last SQL User"; Value = ($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("LastUser"); }
        }
        $ScriptInformation += @{ Data = "EMail Sender"; Value = (($VCAdvSettings) | Where-Object{$_.Name -like "mail.sender"}).Value; }
        $ScriptInformation += @{ Data = "SMTP Server"; Value = (($VCAdvSettings) | Where-Object{$_.Name -like "mail.smtp.server"}).Value; }
        $ScriptInformation += @{ Data = "SMTP Server Port"; Value = (($VCAdvSettings) | Where-Object{$_.Name -like "mail.smtp.port"}).Value; }

        $Table = AddWordTable -Hashtable $ScriptInformation `
		-Columns Data,Value `
		-List `
		-Format $wdTableGrid `
		-AutoFit $wdAutoFitFixed;

		## IB - Set the header row format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		$Table.Columns.Item(1).Width = 205;
		$Table.Columns.Item(2).Width = 200;

		#$Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 0 ""
    }
    If($HTML)
    {
        $rowdata = @()
        $colWidths = @("150px","200px")
        $rowdata += @(,("Server Name",($htmlsilver -bor $htmlbold),(($VCAdvSettings) | Where-Object{$_.Name -like "VirtualCenter.FQDN"}).Value,$htmlwhite))
        $rowdata += @(,("Version",($htmlsilver -bor $htmlbold),$VCObj.Version,$htmlwhite))
        $rowdata += @(,("Build",($htmlsilver -bor $htmlbold),$VCObj.Build,$htmlwhite))
        If($Import -and $RegSQL)
        {
            $rowdata += @(,("DSN Name",($htmlsilver -bor $htmlbold),$RegSQL.VCDB,$htmlwhite))
            $rowdata += @(,("SQL Database",($htmlsilver -bor $htmlbold),$RegSQL.SQLDB,$htmlwhite))
            $rowdata += @(,("SQL Server",($htmlsilver -bor $htmlbold),$RegSQL.SQLServer,$htmlwhite))
            $rowdata += @(,("Last SQL User",($htmlsilver -bor $htmlbold),$RegSQL.SQLUser,$htmlwhite))         
        }
        ElseIf($VCDB)
        {
            $rowdata += @(,("DSN Name",($htmlsilver -bor $htmlbold),$VCDB,$htmlwhite))
            $rowdata += @(,("SQL Database",($htmlsilver -bor $htmlbold),($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("Database"),$htmlwhite))
            $rowdata += @(,("SQL Server",($htmlsilver -bor $htmlbold),($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("Server"),$htmlwhite))
            $rowdata += @(,("Last SQL User",($htmlsilver -bor $htmlbold),($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("LastUser"),$htmlwhite))
        }
        $rowdata += @(,("Email Sender",($htmlsilver -bor $htmlbold),(($VCAdvSettings) | Where-Object{$_.Name -like "mail.sender"}).Value,$htmlwhite))
        $rowdata += @(,("SMTP Server",($htmlsilver -bor $htmlbold),(($VCAdvSettings) | Where-Object{$_.Name -like "mail.smtp.server"}).Value,$htmlwhite))
        $rowdata += @(,("SMTP Server Port",($htmlsilver -bor $htmlbold),(($VCAdvSettings) | Where-Object{$_.Name -like "mail.smtp.port"}).Value,$htmlwhite))

        FormatHTMLTable "General Settings" -noHeadCols 2 -rowArray $rowdata -fixedWidth $colWidths -tablewidth "350"
        WriteHTMLLine 0 1 ""
    }
    If($Text)
    {
		Line 0 "Global Settings" 
		Line 1 ""
		Line 1 "Server Name`t`t: " (($VCAdvSettings) | Where-Object{$_.Name -like "VirtualCenter.FQDN"}).Value
		Line 1 "Version`t`t`t: " $VCObj.Version
		Line 1 "Build`t`t`t: " $VCObj.Build
		If($Import -and $RegSQL)
		{
			Line 1 "DSN Name`t`t: " $RegSQL.VCDB
			Line 1 "SQL Database`t`t: " $RegSQL.SQLDB
			Line 1 "SQL Server`t`t: " $RegSQL.SQLServer
			Line 1 "Last SQL User`t`t: " $RegSQL.SQLUser           
		}
		ElseIf($VCDB)
		{
			Line 1 "DSN Name`t`t: " $VCDB
			Line 1 "SQL Database`t`t: " ($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("Database")
			Line 1 "SQL Server`t`t: " ($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("Server")
			Line 1 "Last SQL User`t`t: " ($RemReg[0].OpenSubKey($DBDetails,$true)).GetValue("LastUser")
		}
		Line 1 "Email Sender`t`t: " (($VCAdvSettings) | Where-Object{$_.Name -like "mail.sender"}).Value
		Line 1 "SMTP Server`t`t: " (($VCAdvSettings) | Where-Object{$_.Name -like "mail.smtp.server"}).Value
		Line 1 "SMTP Server Port`t: " (($VCAdvSettings) | Where-Object{$_.Name -like "mail.smtp.port"}).Value
		Line 0 ""
    }

    ## vCenter historical statistics
    Write-Verbose "$(Get-Date -Format G): `tOutput vCenter Historical Statistics"
    $vCenterStats = @()
    If($MSWord -or $PDF)
    {
        ## Create an array of hashtables
	    [System.Collections.Hashtable[]] $vCenterStats = @();
	    ## Seed the row index from the second row
	    [int] $CurrentServiceIndex = 2;
        WriteWordLine 2 0 "Historical Statistics"
        ForEach($xStatLevel in $vCenterStatistics.HistoricalInterval)
        {
            Switch($xStatLevel.SamplingPeriod)
            {
                300		{$xInterval = "5 Minutes"; Break}
                1800	{$xInterval = "30 Minutes"; Break}
                7200	{$xInterval = "2 Hours"; Break}
                86400	{$xInterval = "1 Day"; Break}
            }
            ## Add the required key/values to the hashtable
	        $WordTableRowHash = @{
				IntervalDuration = $xInterval;
				IntervalEnabled  = $xStatLevel.Enabled;
				SaveDuration     = $xStatLevel.Name;
				StatsLevel       = $xStatLevel.Level;
            }
            ## Add the hash to the array
	        $vCenterStats += $WordTableRowHash;
	        $CurrentServiceIndex++
        }

        ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($vCenterStats.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $vCenterStats `
			-Columns IntervalDuration, IntervalEnabled, SaveDuration, StatsLevel `
			-Headers "Interval Duration", "Enabled", "Save For", "Statistics Level" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
    }
    If($Text)
    {
        Line 0 "Historical Statistics" 
        Line 1 ""
        Line 1 "Interval Duration  Enabled  Save For    Statistics Level"
		Line 1 "========================================================"
		       #12345678901234567SS1234567SS1234567890SS1234567890123456
		
        ForEach($xStatLevel in $vCenterStatistics.HistoricalInterval)
        {
            Switch($xStatLevel.SamplingPeriod)
            {
                300		{$xInterval = "5 Min."; Break}
                1800	{$xInterval = "30 Min."; Break}
                7200	{$xInterval = "2 Hours"; Break}
                86400	{$xInterval = "1 Day"; Break}
            }
			Line 1 ( "{0,-17}  {1,-7}  {2,-10}  {3,-16}" -f `
				$xInterval,
				$xStatLevel.Enabled,
				$xStatLevel.Name,
				$xStatLevel.Level
			)
        }
        Line 0 ""
    }
    If($HTML)
    {
        $rowdata = @()
        $columnHeaders = @(
			"Interval Duration",($htmlsilver -bor $htmlbold),
			"Enabled",($htmlsilver -bor $htmlbold),
			"Save For",($htmlsilver -bor $htmlbold),
			"Statistics Level",($htmlsilver -bor $htmlbold)
		)
		
        ForEach($xStatLevel in $vCenterStatistics.HistoricalInterval)
        {
            Switch($xStatLevel.SamplingPeriod)
            {
                300		{$xInterval = "5 Min."; Break}
                1800	{$xInterval = "30 Min."; Break}
                7200	{$xInterval = "2 Hours"; Break}
                86400	{$xInterval = "1 Day"; Break}
            }
            $rowdata += @(,(
				$xInterval,$htmlwhite,
				$xStatLevel.Enabled,$htmlWhite,
				$xStatLevel.Name,$htmlWhite,
				$xStatLevel.Level,$htmlWhite)
			)
        }
        FormatHTMLTable "Historical Statistics" -rowArray $rowdata -columnArray $columnHeaders
        WriteHTMLLine 0 0 ""
    }

    ## vCenter Licensing
    Write-Verbose "$(Get-Date -Format G): `tOutput vCenter Licensing"
    If($MSWord -or $PDF)
    {
        ## Create an array of hashtables
	    [System.Collections.Hashtable[]] $LicenseWordTable = @();
	    ## Seed the row index from the second row
	    [int] $CurrentServiceIndex = 2;
        WriteWordLine 2 0 "Licensing"
        #http://blogs.vmware.com/PowerCLI/2012/05/retrieving-license-keys-from-multiple-vCenters.html
        ForEach ($LicenseMan in $VCLicensing) 
        { 
            ForEach ($License in ($LicenseMan | Select-Object -ExpandProperty Licenses))
            {
                ## Add the required key/values to the hashtable
	            $WordTableRowHash = @{ 
					LicenseName  = $License.Name;
					LicenseKey   = "*****" + $License.LicenseKey.Substring(23);
					LicenseTotal = $License.Total;
					LicenseUsed  = $License.Used;
	            }
	            ## Add the hash to the array
	            $LicenseWordTable += $WordTableRowHash;
	            $CurrentServiceIndex++
            }
        }

        ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($LicenseWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $LicenseWordTable `
			-Columns LicenseName, LicenseKey, LicenseTotal, LicenseUsed `
			-Headers "License Name", "Key Last 5", "Total Licenses", "Licenses Used" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15 -Size 8;

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
    }
    If($Text)
    {
        Line 0 "Licensing" 
        Line 1 ""
        Line 1 "License Name                      Key Last 5   Total Licenses Licenses Used"
		       #VMware vSphere 6 Enterprise Plus  *****-00000  9              9
			   #12345678901234567890123456789012SS12345678901SS12345678901234S1234567890123
		Line 1 "==========================================================================="
        ForEach ($LicenseMan in $VCLicensing) 
        {
            ForEach ($License in ($LicenseMan | Select-Object -ExpandProperty Licenses))
            {
				Line 1 ( "{0,-32}  *****{1,-6}  {2,-14} {3,-13}" -f `
					(truncate $License.Name 29), 
					$License.LicenseKey.Substring(23), 
					$License.Total, 
					$License.Used 
				)
            }
        }
        Line 0 ""
    }
    If($HTML)
    {
        $rowdata = @()
        $columnHeaders = @(
			"License Name",($htmlsilver -bor $htmlbold),
			"Key Last 5",($htmlsilver -bor $htmlbold),
			"Total Licenses",($htmlsilver -bor $htmlbold),
			"Licenses Used",($htmlsilver -bor $htmlbold)
		)
		
        ForEach ($LicenseMan in $VCLicensing) 
        { 
            ForEach ($License in ($LicenseMan | Select-Object -ExpandProperty Licenses))
            {
                $rowdata += @(,(
					$License.Name,$htmlwhite,
					"*****$($License.LicenseKey.Substring(23))",$htmlwhite,
					$License.Total,$htmlwhite,
					$License.Used,$htmlwhite)
				)
            }
        }
        FormatHTMLTable "Licensing" -rowArray $rowdata -columnArray $columnHeaders
        WriteHTMLLine 0 0 ""
    }

    ## vCenter Permissions
    Write-Verbose "$(Get-Date -Format G): `tOutput vCenter Permissions"
    If($MSWord -or $PDF)
    {
        ## Create an array of hashtables
	    [System.Collections.Hashtable[]] $PermsWordTable = @();
	    ## Seed the row index from the second row
	    [int] $CurrentServiceIndex = 2;
        WriteWordLine 2 0 "vCenter Permissions"
        ForEach ($VIPerm in $VIPerms)
        {
            ## Add the required key/values to the hashtable
	        $WordTableRowHash = @{
				Entity    = $VIPerm.Entity;
				Principal = $VIPerm.Principal;
				Role      = $VIPerm.Role;
            }
            ## Add the hash to the array
            $PermsWordTable += $WordTableRowHash
            $CurrentServiceIndex++
        }

        ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($PermsWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $PermsWordTable `
			-Columns Entity, Principal, Role `
			-Headers "Entity", "Principal", "Role" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent; 

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15 -Size 8;

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""  
		}
    }
    If($Text)
    {
        Line 0 "vCenter Permissions"
		Line 1 "Entity                Principal                                                             Role                          "
		Line 1 "=========================================================================================================================="
		#       12345678901234567890SS12345678901234567890123456789012345678901234567890123456789012345678SS123456789012345678901234567890

        ForEach($VIPerm in $VIPerms)
        {
			Line 1 ( "{0,-20}  {1,-68}  {2,-30}" -f `
				(truncate $VIPerm.Entity 17), 
				(truncate $VIPerm.Principal 65), 
				(truncate $VIPerm.Role 27) 
			)
        }
		Line 0 ""
    }
    If($HTML)
    {
        $rowData = @()
        $columnHeaders = @(
			"Entity",($htmlsilver -bor $htmlbold),
			"Principal",($htmlsilver -bor $htmlbold),
			"Role",($htmlsilver -bor $htmlbold)
		)
		
        ForEach($VIPerm in $VIPerms)
        {
            $rowData += @(,(
				$VIPerm.Entity,$htmlwhite,
				$VIPerm.Principal,$htmlwhite,
				$VIPerm.Role,$htmlwhite)
			)
        }
        FormatHTMLTable "vCenter Permissions" -columnArray $columnHeaders -rowArray $rowdata
        WriteHTMLLine 0 0 ""
    }

    ## vCenter Role Perms
    Write-Verbose "$(Get-Date -Format G): `tProcessing vCenter Role Permissions"
    If($MSWord -or $PDF)
    {
        WriteWordLine 2 0 "Active non-Standard vCenter Roles"
        ForEach($role in ($VIPerms | Select-Object Role -Unique))
        {
            ForEach($expandRole in $VIRoles | Where-Object{$_.Name -eq $role.Role -and $_.IsSystem -eq $false})
            {
                WriteWordLine 0 0 $expandRole.Name -boldface $true
                ForEach($privRole in $expandRole.PrivilegeList)
				{
					WriteWordLine 0 0 $privRole -fontSize 8
				}
                WriteWordLine 0 0 ""
            }
        }
    }
    If($Text)
    {
        Line 0 "Active non-Standard vCenter Roles"
        ForEach($role in ($VIPerms | Select-Object Role -Unique))
        {
            ForEach($expandRole in $VIRoles | Where-Object{$_.Name -eq $role.Role -and $_.IsSystem -eq $false})
            {
                Line 0 $expandRole.Name
                ForEach($privRole in $expandRole.PrivilegeList)
				{
					Line 1 $privRole
				}
				Line 0 ""
            }
        }
    }
    If($HTML)
    {
        WriteHTMLLine 1 0 "Active non-Standard vCenter Roles"
        ForEach($role in ($VIPerms | Select-Object Role -Unique))
        {
            ForEach($expandRole in $VIRoles | Where-Object{$_.Name -eq $role.Role -and $_.IsSystem -eq $false})
            {
                WriteHTMLLine 0 0 $expandRole.Name -options $htmlBold -fontSize 3
                ForEach($privRole in $expandRole.PrivilegeList)
				{
					WriteHTMLLine 0 0 $privRole -fontSize 2
				}
                WriteHTMLLine 0 0 ""
            }
        }
    }

    ## vCenter Plugins
    Write-Verbose "$(Get-Date -Format G): `tOutput vCenter Plugins"
    If($MSWord -or $PDF)
    {
        ## Create an array of hashtables
	    [System.Collections.Hashtable[]] $PluginsWordTable = @();
	    ## Seed the row index from the second row
	    [int] $CurrentServiceIndex = 2;
        WriteWordLine 2 0 "vCenter Plugins"
        ForEach ($VMPlugin in $VMPlugins)
        {
            ## Add the required key/values to the hashtable
	        $WordTableRowHash = @{
				PluginName = $VMPlugin.Label;
				PluginDesc = $VMPlugin.Summary;
            }  
	        ## Add the hash to the array
	        $PluginsWordTable += $WordTableRowHash;
	        $CurrentServiceIndex++                       
        }  

        ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($PluginsWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $PluginsWordTable `
			-Columns PluginName, PluginDesc `
			-Headers "Plugin", "Description" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;    

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15 -Size 8;

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""   
		}		
    }
    If($Text)
    {
        Line 0 "Plugins"
        Line 1 "Plugin                                          Description                                                                                         "
		Line 1 "===================================================================================================================================================="
		       #123456789012345678901234567890123456789012345SSS1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
               #VMware vSphere Profile-driven Storage Service   The vService Manager manages vService dependencies on virtual machines and vApps, and vServices p...
        ForEach($VMPlugin in $VMPlugins)
        {
			Line 1 ( "{0,-45}   {1,-100}" -f `
				(truncate $VMPlugin.Label 42), 
				(truncate $VMPlugin.Summary 97)
			)
        }
		Line 0 ""
    }
    If($HTML)
    {
        $rowdata = @()
        $columnHeaders = @(
			"Plugin",($htmlsilver -bor $htmlbold),
			"Description",($htmlsilver -bor $htmlbold)
		)
		
        ForEach($VMPlugin in $VMPlugins)
        {
            $rowData += @(,(
				$VMPlugin.Label,$htmlwhite,
				$VMPlugin.Summary,$htmlwhite)
			)
        }
        FormatHTMLTable "vCenter Plugins" -columnArray $columnHeaders -rowArray $rowdata
    }
}
#endregion

#region Hosts and Clusters functions
Function ProcessVMHosts
{
    Write-Verbose "$(Get-Date -Format G): Processing VMware Hosts"
    If($MSWord -or $PDF)
	{
        $Selection.InsertNewPage()
		WriteWordLine 1 0 "Hosts"
	}
	If($Text)
	{
		Line 0 "Hosts"
	}
    If($HTML)
    {
        WriteHTMLLine 1 0 "Hosts"
    }    

    If($? -and ($VMHosts))
    {
        $First = 0
        ForEach($VMHost in $VMHosts)
        {
            If($First -ne 0 -and ($MSWord -or $PDF))
			{
				$Selection.InsertNewPage()
			}
            OutputVMHosts $VMHost
            $First++
        }
    }
    ElseIf($? -and ($Null -eq $VMHosts))
    {
        Write-Warning "There are no ESX Hosts"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "There are no ESX Hosts"
		}
		If($Text)
		{
			Line 1 "There are no ESX Hosts"
		}
		If($HTML)
		{
            WriteHTMLLine 0 1 "There are no ESX Hosts"
		}
    }
    Else
    {
    	Write-Warning "Unable to retrieve ESX Hosts"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "Unable to retrieve ESX Hosts"
		}
		If($Text)
		{
			Line 1 "Unable to retrieve ESX Hosts"
		}
		If($HTML)
		{
            WriteHTMLLine 0 1 "Unable to retrieve ESX Hosts"
		}
    }
}

Function OutputVMHosts
{
    Param([object] $VMHost)
    Write-Verbose "$(Get-Date -Format G): `tOutput VMware Host $($VMHost.Name)"

    $xHostService = ($HostServices) | Where-Object{$_.VMHostId -eq $VMHost.Id}
    
	If($Export)
	{
		(Get-VMHostNtpServer -VMHost $VMHost.Name 4>$Null) -join ", " | Export-Clixml .\Export\$($VMHost.Name)-NTP.xml 4>$Null
	} 
	
    $xHostAdvanced = ($HostAdvSettings) | Where-Object{$_.Entity -like $VMHost.Name}
    ## Set vmhoststorage variable - will fail if host has no devices (headless - boot from USB\SD using NFS only)
	If($VMHost.PowerState -eq "PoweredOn")
	{
		If($Export)
		{
			Get-VMHostStorage -VMHost $VMHost 4>$Null| Where-Object{$_.ScsiLun.LunType -notlike "*cdrom*"} | Export-Clixml .\Export\$($VMHost.Name)-Storage.xml 4>$Null
			If(!$?)
			{
				Write-Warning ""
				Write-Warning "Get-VMHostStorage failed. If $($VMHost) has no local storage and uses NFS only, the above error can be ignored."
				Write-Warning ""
			}
		}
		ElseIf($Import)
		{
			$xVMHostStorage = Import-Clixml .\Export\$($VMHost.Name)-Storage.xml
		}
		Else
		{
			$xVMHostStorage = Get-VMHostStorage -VMHost $VMHost 4>$Null| Where-Object{$_.ScsiLun.LunType -notlike "*cdrom*"} 4>$null
			If(!$?)
			{
				Write-Warning ""
				Write-Warning "Get-VMHostStorage failed. If $($VMHost) has no local storage and uses NFS only, the above error can be ignored."
				Write-Warning ""
			}
		}
	}

    If($VMHost.IsStandAlone)
    {
        $xStandAlone = "Standalone Host"
    }
    Else
    {
        $xStandAlone = "Clustered Host"
    }

    If($VMHost.HyperthreadingActive)
    {
        $xHyperThreading = "Active"
    }
    Else
    {
        $xHyperThreading = "Disabled"
    }
    If((($xHostService) | Where-Object{$_.Key -eq "TSM-SSH"}).Running)
    {
        $xSSHService = "Running"
    }
    Else
    {
        $xSSHService = "Stopped"
    }
    If((($xHostService) | Where-Object{$_.Key -eq "ntpd"}).Running)
    {
        $xNTPService = "Running"
        If($Import)
        {
            $xNTPServers = Import-Clixml .\Export\$($VMHost.Name)-NTP.xml
        }
        Else
        {
            $xNTPServers = (Get-VMHostNtpServer -VMHost $VMHost.Name 4>$Null) -join ", " 4>$Null
        }
    }
    Else
    {
        $xNTPService = "Stopped"
    }
    If($xVMHostStorage.SoftwareIScsiEnabled)
    {
        $xiSCSI = "Enabled"
    }
    Else
    {
        $xiSCSI = "Disabled"
    }
    If($MSWord -or $PDF)
    {
        
        WriteWordLine 2 0 "Host: $($VMHost.Name)"
        [System.Collections.Hashtable[]] $ScriptInformation = @()
        $ScriptInformation += @{ Data = "Name"; Value = $VMHost.Name; }
        $ScriptInformation += @{ Data = "ESXi Version"; Value = $VMHost.Version; }
        $ScriptInformation += @{ Data = "ESXi Build"; Value = $VMHost.Build; }
		$ScriptInformation += @{ Data = "Power State"; Value = $VMHost.PowerState; }
		$ScriptInformation += @{ Data = "Connection State"; Value = $VMHost.ConnectionState; }
        $ScriptInformation += @{ Data = "Host Status"; Value = $xStandAlone; }
        If(!$VMHost.IsStandAlone)
        {
            $ScriptInformation += @{ Data = "Parent Object"; Value = $VMHost.Parent; }
        }
        If($VMHost.VMSwapfileDatastore)
        {
            $ScriptInformation += @{ Data = "VM Swapfile Datastore"; Value = $VMHost.VMSwapfileDatastore.Name; }
        }
        $ScriptInformation += @{ Data = "Manufacturer"; Value = $VMHost.Manufacturer; }
        $ScriptInformation += @{ Data = "Model"; Value = $VMHost.Model; }
        $ScriptInformation += @{ Data = "CPU Type"; Value = $VMHost.ProcessorType; }
        $ScriptInformation += @{ Data = "Maximum EVC Mode"; Value = $VMHost.MaxEVCMode; }
        $ScriptInformation += @{ Data = "CPU Core Count"; Value = $VMHost.NumCpu; }
        $ScriptInformation += @{ Data = "Hyperthreading"; Value = $xHyperthreading; }
        $ScriptInformation += @{ Data = "CPU Power Policy"; Value = $VMHost.ExtensionData.config.PowerSystemInfo.CurrentPolicy.ShortName; }
        $ScriptInformation += @{ Data = "Total Memory"; Value = "$([decimal]::round($VMHost.MemoryTotalGB)) GB"; }
        If($VMHost.PowerState -like "PoweredOn")
        {
            $ScriptInformation += @{ Data = "SSH Service Policy"; Value = (($xHostService) | Where-Object{$_.Key -eq "TSM-SSH"}).Policy; }
            $ScriptInformation += @{ Data = "SSH Service Status"; Value = $xSSHService; }
            $ScriptInformation += @{ Data = "Scratch Log location"; Value = (($xHostAdvanced) | Where-Object{$_.Name -eq "Syslog.global.logdir"}).Value; }
            $ScriptInformation += @{ Data = "Scratch Log remote host"; Value =  (($xHostAdvanced) | Where-Object{$_.Name -eq "Syslog.global.loghost"}).Value; }
            $ScriptInformation += @{ Data = "NTP Service Policy"; Value = (($xHostService) | Where-Object{$_.Key -eq "ntpd"}).Policy; }
            $ScriptInformation += @{ Data = "NTP Service Status"; Value = $xNTPService; }
            $ScriptInformation += @{ Data = "NFS Max Queue Depth"; Value = (($xHostAdvanced) | Where-Object{$_.Name -eq "NFS.MaxQueueDepth"}).Value; }
            $ScriptInformation += @{ Data = "NFS Max Volumes"; Value = (($xHostAdvanced) | Where-Object{$_.Name -eq "NFS.MaxVolumes"}).Value; }
            $ScriptInformation += @{ Data = "TCP IP Heap Size"; Value = (($xHostAdvanced) | Where-Object{$_.Name -eq "Net.TcpipHeapSize"}).Value; }
            $ScriptInformation += @{ Data = "TCP IP Heap Max"; Value = (($xHostAdvanced) | Where-Object{$_.Name -eq "Net.TcpipHeapMax"}).Value; }
            If($xVMHostStorage){$ScriptInformation += @{ Data = "Software iSCSI Service"; Value = $xiSCSI; }}
            If((($xHostService) | Where-Object{$_.Key -eq "ntpd"}).Running)
            {
                $ScriptInformation += @{ Data = "NTP Servers"; Value = $xNTPServers; }
            }
        }

        $Table = AddWordTable -Hashtable $ScriptInformation `
		-Columns Data,Value `
		-List `
		-Format $wdTableGrid `
		-AutoFit $wdAutoFitFixed;

		## IB - Set the header row format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		$Table.Columns.Item(1).Width = 205;
		$Table.Columns.Item(2).Width = 200;

		# $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 0 ""
        If($xVMHostStorage)
        {
            WriteWordLine 0 0 "Block Storage"

            ## Create an array of hashtables
            [System.Collections.Hashtable[]] $ClusterWordTable = @();
            ## Seed the row index from the second row
            [int] $CurrentServiceIndex = 2;

            ForEach($xLUN in ($xVMHostStorage.ScsiLun) | Where-Object{$_.LunType -notlike "*cdrom*"})
            {
                ## Add the required key/values to the hashtable
                $WordTableRowHash = @{
					Model       = $xLUN.Model;
					Vendor      = $xLUN.Vendor;
					Capacity    = $("{0:N2}" -f $xLUN.CapacityGB + " GB");
					RuntimeName = $xLUN.RuntimeName;
					MultiPath   = $xLUN.MultipathPolicy;
					Identifier  =  truncate $xLUN.CanonicalName 20
                }
                ## Add the hash to the array
	            $ClusterWordTable += $WordTableRowHash;
	            $CurrentServiceIndex++;
            }

            ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
			If($ClusterWordTable.Count -gt 0)
			{
				$Table = AddWordTable -Hashtable $ClusterWordTable `
				-Columns Model, Vendor, Capacity, RunTimeName, MultiPath, Identifier `
				-Headers "Model", "Vendor", "Capacity", "Runtime Name", "MultiPath", "Identifier" `
				-Format $wdTableGrid `
				-AutoFit $wdAutoFitContent;

				## IB - Set the header row format
				SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

				$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

				FindWordDocumentEnd
				$Table = $Null

				WriteWordLine 0 0 ""
			}
        }

        If($VMHost.ConnectionState -like "*NotResponding*" -or $VMHost.PowerState -eq "PoweredOff")
        {
            WriteWordLine 0 0 "Note: $($VMHost.Name) is not responding or is in an unknown state - data in this and other reports will be missing or inaccurate." -italics $True
            WriteWordLine 0 0 ""
        }

        If($VMHost.PowerState -like "PoweredOn" -and $Chart)
        {
			$PSDefaultParameterValues = @{"*:Verbose"=$False}
			$StatTypes = @(Get-StatType -Entity $VMHost.Name)
			
			#Information taken from https://communities.vmware.com/t5/Storage-Performance/vCenter-Performance-Counters/ta-p/2790328
			If($StatTypes.Contains("cpu.usage.average"))
			{
				#The CPU utilization.  This value is reported with 100% representing all processor cores on the system. As an example, a 2-way VM using 50% of a four-core system is completely using two cores.
				$VMHostCPU = Get-Stat -Entity $VMHost.Name -Stat cpu.usage.average -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30 | Where-Object{$_.Instance -like ""}
				#AddStatsChart -StatData $VMHostCPU -Title "$($VMHost.Name) CPU" -Width 275 -Length 200 -Type "Line"
				AddStatsChart -StatData $VMHostCPU -Title "$($VMHost.Name) CPU Usage Average" -Width 700 -Length 500 -Type "Line"
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "The CPU utilization.  This value is reported with 100% representing all  processor cores on the system."
				WriteWordLine 0 0 "As an example, a 2-way VM using 50% of a  four-core system is completely using two cores."
				WriteWordLine 0 0 "Rated in Percent"
				WriteWordLine 0 0 ""
			}
			
			If($StatTypes.Contains("mem.granted.average"))
			{
				#The amount of memory that was granted to the VM by the host. Memory is not granted to the host until it is touched one time and granted memory may be swapped out or ballooned away if the VMkernel needs the memory.
				$VMHostGrant = Get-Stat -Entity $VMHost.Name -Stat mem.granted.average -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30
				#AddStatsChart -StatData $VMHostGrant -StatData2 $VMHostActive -StatData3 $VMHostBalloon -Title "$($VMHost.Name) Memory" -Width 325 -Length 200 -Data1Label "Granted" -Data2Label "Active" -Data3Label "Balloon" -Legend -Type "Line"
				AddStatsChart -StatData $VMHostGrant -Title "$($VMHost.Name) Granted Memory Average" -Width 700 -Length 500 -Legend -Type "Line"
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "The amount of memory that was granted to the VM by the host."
				WriteWordLine 0 0 "Memory is  not granted to the host until it is touched one time and granted memory."
				WriteWordLine 0 0 "May be swapped out or ballooned away if the VMkernel needs the memory."
				WriteWordLIne 0 0 "Rated in kiloBytes"
				WriteWordLine 0 0 ""
			}

			If($StatTypes.Contains("mem.active.average"))
			{
				#The amount of memory used by the VM in the past small window of time.   This is the "true" number of how much memory the VM currently has need of.  Additional, unused memory may be swapped out or ballooned with no impact to the guest's performance.
				$VMHostActive = Get-Stat -Entity $VMHost.Name -Stat mem.active.average -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30
				#AddStatsChart -StatData $VMHostGrant -StatData2 $VMHostActive -StatData3 $VMHostBalloon -Title "$($VMHost.Name) Memory" -Width 325 -Length 200 -Data1Label "Granted" -Data2Label "Active" -Data3Label "Balloon" -Legend -Type "Line"
				AddStatsChart -StatData $VMHostActive -Title "$($VMHost.Name) Active Memory Average" -Width 700 -Length 500 -Legend -Type "Line"
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "The amount of memory used by the VM in the past small window of time."
				WriteWordLine 0 0 "This is the 'true' number of how much memory the VM currently has need of"
				WriteWordLine 0 0 "Additional, unused memory may be swapped out or ballooned with no  impact to the guest's performance"
				WriteWordLine 0 0 "Rated in kiloBytes"
				WriteWordLine 0 0 ""
			}

			If($StatTypes.Contains("mem.vmmemctl.average"))
			{
				#The amount of memory currently claimed by the balloon driver. This is
				#not a performance problem, per se, but represents the host starting to
				#take memory from less needful VMs for those with large amounts of
				#active memory. But if the host is ballooning, check swap rates (swapin
				#and swapout) which would be indicative of performance problems.
				$VMHostBalloon = Get-Stat -Entity $VMHost.Name -Stat mem.vmmemctl.average -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30
				#AddStatsChart -StatData $VMHostGrant -StatData2 $VMHostActive -StatData3 $VMHostBalloon -Title "$($VMHost.Name) Memory" -Width 325 -Length 200 -Data1Label "Granted" -Data2Label "Active" -Data3Label "Balloon" -Legend -Type "Line"
				AddStatsChart -StatData $VMHostBalloon -Title "$($VMHost.Name) Balloon Memory Driver" -Width 700 -Length 500 -Legend -Type "Line"
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "The amount of memory currently claimed by the balloon driver. This is"
				WriteWordLine 0 0 "not a performance problem, per se, but represents the host starting to"
				WriteWordLine 0 0 "take memory from less needful VMs for those with large amounts of"
				WriteWordLine 0 0 "active memory. But if the host is ballooning, check swap rates (swapin"
				WriteWordLine 0 0 "and swapout) which would be indicative of performance problems."
				WriteWordLine 0 0 "Rated in kiloBytes"
			}
            WriteWordLine 0 0 ""

            # Disk IO chart here...Get-Stats for NFS datastores may not be possible?
			If($StatTypes.Contains("disk.usage.average"))
			{
				#Average disk throughput over the sample period.
				$VMDiskUsageAvg = Get-Stat -Entity $VMHost.Name -Stat disk.usage.average -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30
				AddStatsChart -StatData $VMDiskUsageAvg -Title "$($VMHost.Name) Disk Usage Average" -Width 700 -Length 500 -Legend -Type "Line"
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "Average disk throughput over the sample period."
				WriteWordLine 0 0 "Rated in kiloBytesPerSecond"           
				WriteWordLine 0 0 ""
			}

			If($StatTypes.Contains("disk.maxTotalLatency.latest"))
			{
				#The highest reported total latency (device and kernel times) in the sample window.
				$VMDiskUsageAvg = Get-Stat -Entity $VMHost.Name -Stat disk.maxTotalLatency.latest -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30
				AddStatsChart -StatData $VMDiskUsageAvg -Title "$($VMHost.Name) Disk Usage Average" -Width 700 -Length 500 -Legend -Type "Line"
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "The highest reported total latency (device and kernel times) in the sample window."
				WriteWordLine 0 0 "Rated in milliseconds"           
			}
			WriteWordLine 0 0 ""

			If($StatTypes.Contains("net.received.average"))
			{
				#Average network throughput for received traffic.
				$VMHostNetRec = Get-Stat -Entity $VMHost.Name -Stat "net.received.average" -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30 | Where-Object{$_.Instance -like ""}
				#AddStatsChart -StatData $VMHostNetRec -StatData2 $VMHostNetTrans -Title "$($VMHost.Name) Net IO" -Width 300 -Length 200 -Data1Label "Recv" -Data2Label "Trans" -Legend -Type "Line"
				AddStatsChart -StatData $VMHostNetRec -Title "$($VMHost.Name) Net Received Average" -Width 700 -Length 500 -Legend -Type "Line"
				WriteWordLine 0 0 ""           
				WriteWordLine 0 0 "Average network throughput for received traffic."           
				WriteWordLine 0 0 "Rated in kiloBytesPerSecond"           
				WriteWordLine 0 0 ""           
			}

			If($StatTypes.Contains("net.transmitted.average"))
			{
				#Average network throughput for transmitted traffic.
				$VMHostNetTrans = Get-Stat -Entity $VMHost.Name -Stat "net.transmitted.average" -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30 | Where-Object{$_.Instance -like ""}
				#AddStatsChart -StatData $VMHostNetRec -StatData2 $VMHostNetTrans -Title "$($VMHost.Name) Net IO" -Width 300 -Length 200 -Data1Label "Recv" -Data2Label "Trans" -Legend -Type "Line"
				AddStatsChart -StatData $VMHostNetTrans -Title "$($VMHost.Name) Net Transmitted Average" -Width 700 -Length 500 -Legend -Type "Line"
				WriteWordLine 0 0 ""           
				WriteWordLine 0 0 "Average network throughput for transmitted traffic."           
				WriteWordLine 0 0 "Rated in kiloBytesPerSecond"           
				WriteWordLine 0 0 ""           
			}
            
			If($StatTypes.Contains("net.usage.average"))
			{
				#Network Usage (Average)
				$VMHostNetAverage = Get-Stat -Entity $VMHost.Name -Stat "net.usage.average" -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30 | Where-Object{$_.Instance -like ""}
				#AddStatsChart -StatData $VMHostNetRec -StatData2 $VMHostNetTrans -Title "$($VMHost.Name) Net IO" -Width 300 -Length 200 -Data1Label "Recv" -Data2Label "Trans" -Legend -Type "Line"
				AddStatsChart -StatData $VMHostNetAverage -Title "$($VMHost.Name) Net Average Usage" -Width 700 -Length 500 -Legend -Type "Line"
				WriteWordLine 0 0 ""           
				WriteWordLine 0 0 "Network Usage (Average)"           
				WriteWordLine 0 0 "Rated in kiloBytesPerSecond"           
			}
			WriteWordLine 0 0 ""           
            
			$PSDefaultParameterValues = @{"*:Verbose"=$True}
        }
    }
    If($Text)
    {
        Line 0 "Host: $($VMHost.Name)"
        Line 0 ""
        Line 1 "Name`t`t`t: " $VMHost.Name
        Line 1 "ESXi Version`t`t: " $VMHost.Version
        Line 1 "ESXi Build`t`t: " $VMHost.Build
        Line 1 "Power State`t`t: " $VMHost.PowerState
        Line 1 "Connection State`t: " $VMHost.ConnectionState
        Line 1 "Host Status`t`t: " $xStandAlone
        If(!$VMHost.IsStandAlone)
        {
            Line 1 "Parent Object`t`t: " $VMHost.Parent
        }
        If($VMHost.VMSwapfileDatastore)
        {
            Line 1 "VM Swapfile DS`t`t: " $VMHost.VMSwapfileDatastore.Name
        }
        Line 1 "Manufacturer`t`t: " $VMHost.Manufacturer
        Line 1 "Model`t`t`t: " $VMHost.Model
        Line 1 "CPU Type`t`t: " $VMHost.ProcessorType
        Line 1 "Maximum EVC Mode`t: " $VMHost.MaxEVCMode
        Line 1 "CPU Core Count`t`t: " $VMHost.NumCpu
        Line 1 "Hyperthreading`t`t: " $xHyperThreading
        Line 1 "CPU Power Policy`t: " $VMHost.ExtensionData.config.PowerSystemInfo.CurrentPolicy.ShortName
        Line 1 "Total Memory`t`t: $([decimal]::round($VMHost.MemoryTotalGB)) GB"
        Line 1 "SSH Policy`t`t: " (($xHostService) | Where-Object{$_.Key -eq "TSM-SSH"}).Policy
        Line 1 "SSH Service Status`t: " $xSSHService
        Line 1 "Scratch Log location`t: " (($xHostAdvanced) | Where-Object{$_.Name -eq "Syslog.global.logdir"}).Value
        Line 1 "Scratch Log server`t: " (($xHostAdvanced) | Where-Object{$_.Name -eq "Syslog.global.loghost"}).Value
        Line 1 "NTP Service Policy`t: " (($xHostService) | Where-Object{$_.Key -eq "ntpd"}).Policy
        Line 1 "NTP Service Status`t: " $xNTPService
        Line 1 "NFS Max Queue Depth`t: " (($xHostAdvanced) | Where-Object{$_.Name -eq "NFS.MaxQueueDepth"}).Value
        Line 1 "NFS Max Volumes`t`t: " (($xHostAdvanced) | Where-Object{$_.Name -eq "NFS.MaxQueueDepth"}).Value
        Line 1 "TCP IP Heap Size`t: " (($xHostAdvanced) | Where-Object{$_.Name -eq "Net.TcpipHeapSize"}).Value
        Line 1 "TCP IP Heap Max`t`t: " (($xHostAdvanced) | Where-Object{$_.Name -eq "Net.TcpipHeapMax"}).Value
        If((($xHostService) | Where-Object{$_.Key -eq "ntpd"}).Running)
        {
            Line 1 "NTP Servers`t`t: " $xNTPServers
        }
        Line 0 ""
        If($xVMHostStorage)
        {
            Line 0 "Block Storage"
            Line 0 ""
            Line 1 "Model                 Vendor      Capacity         Runtime Name          Multipath             Identifier                      "
			Line 1 "==============================================================================================================================="
			       #12345678901234567890SS1234567890SS123456789012345SS12345678901234567890SS12345678901234567890SS123456789012345678901234567890...
            ForEach($xLUN in ($xVMHostStorage.ScsiLun) | Where-Object{$_.LunType -notlike "*cdrom*"})
            {
				$CapacityGB = "{0:N2}" -f $xLUN.CapacityGB
				$CapacityGB = "$($CapacityGB) GB"
				
				Line 1 ( "{0,-20}  {1,-10}  {2,-15}  {3,-20}  {4,-20}  {5,-11}" -f `
					(truncate $xLUN.Model 17),
					(truncate $xLUN.Vendor 7),
					$CapacityGB,
					(truncate $xLUN.RuntimeName 17),
					(truncate $xLUN.MultipathPolicy 17),
					(truncate $xLUN.CanonicalName 30)
				)
            }
            Line 0 ""
        }
        If($VMHost.ConnectionState -like "*NotResponding*" -or $VMHost.PowerState -eq "PoweredOff")
        {
            Line 0 "Note: $($VMHost.Name) is not responding or is in an unknown state - data in this and other reports will be missing or inaccurate."
            Line 0 ""
        }
    }
    If($HTML)
    {
        $rowData = @()
        $colWidths = @("150px","200px")
        $rowData += @(,("Name",($htmlsilver -bor $htmlbold),$VMHost.Name,$htmlwhite))
        $rowData += @(,("ESXi Version",($htmlsilver -bor $htmlbold),$VMHost.Version,$htmlwhite))
        $rowData += @(,("ESXi Build",($htmlsilver -bor $htmlbold),$VMHost.Build,$htmlwhite))
        $rowData += @(,("Power State",($htmlsilver -bor $htmlbold),$VMHost.PowerState,$htmlwhite))
        $rowData += @(,("Connection State",($htmlsilver -bor $htmlbold),$VMHost.ConnectionState,$htmlwhite))
        $rowData += @(,("Host Status",($htmlsilver -bor $htmlbold),$xStandAlone,$htmlwhite))
        If(!$VMHost.IsStandAlone)
        {
            $rowData += @(,("Parent Object",($htmlsilver -bor $htmlbold),$VMHost.Parent,$htmlwhite))
        }
        If($VMHost.VMSwapfileDatastore)
        {
            $rowData += @(,("VM Swapfile DS",($htmlsilver -bor $htmlbold),$VMHost.VMSwapfileDatastore.Name,$htmlwhite))
        }
        $rowData += @(,("Manufacturer",($htmlsilver -bor $htmlbold),$VMHost.Manufacturer,$htmlwhite))
        $rowData += @(,("Model",($htmlsilver -bor $htmlbold),$VMHost.Model,$htmlwhite))
        $rowData += @(,("CPU Type",($htmlsilver -bor $htmlbold),$VMHost.ProcessorType,$htmlwhite))
        $rowData += @(,("Maximum EVC Mode",($htmlsilver -bor $htmlbold),$VMHost.MaxEVCMode,$htmlwhite))
        $rowData += @(,("CPU Core Count",($htmlsilver -bor $htmlbold),$VMHost.NumCpu,$htmlwhite))
        $rowData += @(,("Hyperthreading",($htmlsilver -bor $htmlbold),$xHyperThreading,$htmlwhite))
        $rowData += @(,("CPU Power Policy",($htmlsilver -bor $htmlbold),$VMHost.ExtensionData.config.PowerSystemInfo.CurrentPolicy.ShortName,$htmlwhite))
        $rowData += @(,("Total Memory",($htmlsilver -bor $htmlbold),"$([decimal]::round($VMHost.MemoryTotalGB)) GB",$htmlwhite))
        $rowData += @(,("SSH Policy",($htmlsilver -bor $htmlbold),(($xHostService) | Where-Object{$_.Key -eq "TSM-SSH"}).Policy,$htmlwhite))
        $rowData += @(,("SSH Service Status",($htmlsilver -bor $htmlbold),$xSSHService,$htmlwhite))
        $rowData += @(,("Scratch Log location",($htmlsilver -bor $htmlbold),(($xHostAdvanced) | Where-Object{$_.Name -eq "Syslog.global.logdir"}).Value,$htmlwhite))
        $rowData += @(,("Scratch Log Server",($htmlsilver -bor $htmlbold),(($xHostAdvanced) | Where-Object{$_.Name -eq "Syslog.global.loghost"}).Value,$htmlwhite))
        $rowData += @(,("NTP Service Policy",($htmlsilver -bor $htmlbold),(($xHostService) | Where-Object{$_.Key -eq "ntpd"}).Policy,$htmlwhite))
        $rowData += @(,("NTP Service Status",($htmlsilver -bor $htmlbold),$xNTPService,$htmlwhite))
        $rowData += @(,("NFS Max Queue Depth",($htmlsilver -bor $htmlbold),(($xHostAdvanced) | Where-Object{$_.Name -eq "NFS.MaxQueueDepth"}).Value,$htmlwhite))
        $rowData += @(,("NFS Max Volumes",($htmlsilver -bor $htmlbold),(($xHostAdvanced) | Where-Object{$_.Name -eq "NFS.MaxVolumes"}).Value,$htmlwhite))
        $rowData += @(,("TCP IP Heap Size",($htmlsilver -bor $htmlbold),(($xHostAdvanced) | Where-Object{$_.Name -eq "Net.TcpipHeapSize"}).Value,$htmlwhite))
        $rowData += @(,("TCP IP Heap Max",($htmlsilver -bor $htmlbold),(($xHostAdvanced) | Where-Object{$_.Name -eq "Net.TcpipHeapMax"}).Value,$htmlwhite))
        If((($xHostService) | Where-Object{$_.Key -eq "ntpd"}).Running)
        {
            $rowData += @(,("NTP Servers",($htmlsilver -bor $htmlbold),$xNTPServers,$htmlwhite))
        }

        FormatHTMLTable "Host: $($VMHost.Name)" -noHeadCols 2 -rowArray $rowData -fixedWidth $colWidths -tablewidth "350"
        WriteHTMLLine 0 1 ""
        If($xVMHostStorage)
        {
            $rowData = @()
            $columnHeaders = @(
				"Model",($htmlsilver -bor $htmlbold),
				"Vendor",($htmlsilver -bor $htmlbold),
				"Capacity",($htmlsilver -bor $htmlbold),
				"Runtime Name",($htmlsilver -bor $htmlbold),
				"Multipath",($htmlsilver -bor $htmlbold),
				"Identifier",($htmlsilver -bor $htmlbold)
			)
			
            ForEach($xLUN in ($xVMHostStorage.ScsiLun) | Where-Object{$_.LunType -notlike "*cdrom*"})
            {
                $rowdata += @(,(
					$xLun.Model,$htmlwhite,
					$xLun.Vendor,$htmlwhite,
					"$("{0:N2}" -f $xLUN.CapacityGB + " GB")",$htmlwhite,
					$xLUN.RuntimeName,$htmlwhite,
					$xLUN.MultipathPolicy,$htmlwhite,
					$xLUN.CanonicalName,$htmlwhite)
				)
            }
            FormatHTMLTable "Block Storage" -rowArray $rowData -columnArray $columnHeaders
            WriteHTMLLine 0 0 ""
        }
        If($VMHost.ConnectionState -like "*NotResponding*" -or $VMHost.PowerState -eq "PoweredOff")
        {
            WriteHTMLLine 0 1 "Note: $($VMHost.Name) is not responding or is in an unknown state - data in this and other reports will be missing or inaccurate." "" $Null 0 $htmlitalics
            WriteHTMLLine 0 0 ""
        }
    }
}

Function ProcessClusters
{
    Write-Verbose "$(Get-Date -Format G): Processing VMware Clusters"
    If($MSWord -or $PDF)
	{
		$Selection.InsertNewPage()
		WriteWordLine 1 0 "Clusters"
	}
	If($Text)
	{
		Line 0 "Clusters"
	}
    If($HTML)
    {
        WriteHTMLLine 1 0 "Clusters"
    }

    If($? -and ($Script:Clusters))
    {
        ForEach($VMCluster in $Script:Clusters)
        {
           OutputClusters $VMCluster
        }
    }
    ElseIf($? -and ($Null -eq $Script:Clusters))
    {
        Write-Warning "There are no VMware Clusters"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "There are no VMware Clusters"
		}
		If($Text)
		{
			Line 1 "There are no VMware Clusters"
		}
		If($HTML)
		{
           WriteHTMLLine 0 1 "There are no VMware Clusters"
		}
    }
    Else
    {
    	Write-Warning "Unable to retrieve VMware Clusters"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "Unable to retrieve VMware Clusters"
		}
		If($Text)
		{
			Line 1 "Unable to retrieve VMware Clusters"
		}
		If($HTML)
		{
            WriteHTMLLine 0 1 "Unable to retrieve VMware Clusters"
		}
    }
}

Function OutputClusters
{
    Param([object] $VMCluster)

    Write-Verbose "$(Get-Date -Format G): `tOutput VMware Cluster $($VMCluster.Name)"
    # Proactive HA code from @lamw https://github.com/vmware/PowerCLI-Example-Scripts/blob/master/Modules/ProactiveHA/ProactiveHA.psm1
    $xClusterHosts = (($VMHosts) | Where-Object{$_.ParentId -eq $VMCLuster.Id} | Select-Object -ExpandProperty Name) -join "`n"
    If($MSWord -or $PDF)
    {
        WriteWordLine 2 0 "Cluster: $($VMCluster.Name)"
        [System.Collections.Hashtable[]] $ScriptInformation = @()
        $ScriptInformation += @{ Data = "Name"; Value = $VMCluster.Name; }
        $ScriptInformation += @{ Data = "HA Enabled?"; Value = $VMCluster.HAEnabled; }
        If($VMCluster.HAEnabled)
        {
            $ScriptInformation += @{ Data = "HA Admission Control Enabled?"; Value = $VMCluster.HAAdmissionControlEnabled; }
            $ScriptInformation += @{ Data = "HA Failover Level"; Value = $VMCluster.HAFailoverLevel; }
            $ScriptInformation += @{ Data = "HA Restart Priority"; Value = $VMCluster.HARestartPriority; }
            $ScriptInformation += @{ Data = "HA Isolation Response"; Value = $VMCluster.HAIsolationResponse; }
        }
        $xProactiveHA = ($ClusterView | Where-Object{$_.Name -eq $VMCluster.Name})
        $ScriptInformation += @{ Data = "Proactive HA Enabled?"; Value = $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Enabled; }
        If($xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Enabled)
        {
            $ScriptInformation += @{ Data = "Proactive HA Response"; Value = $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Behavior; }
            $ScriptInformation += @{ Data = "Moderate Remediation Mode"; Value = $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.ModerateRemediation; }
            $ScriptInformation += @{ Data = "Severe Remediation Mode"; Value = $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.SevereRemediation; }
            $ScriptInformation += @{ Data = "Proactive HA Providers"; Value = $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Providers; }
        }
        $ScriptInformation += @{ Data = "DRS Enabled?"; Value = $VMCluster.DrsEnabled; }
        If($VMCluster.DrsEnabled)
        {
            $ScriptInformation += @{ Data = "DRS Automation Level"; Value = $VMCluster.DrsAutomationLevel; }
        }
        $ScriptInformation += @{ Data = "EVC Mode"; Value = $VMCluster.EVCMode; }
        If($VMCluster.VsanEnabled)
        {
            $ScriptInformation += @{ Data = "VSAN Enabled?"; Value = $VMCluster.VsanEnabled; }
            $ScriptInformation += @{ Data = "VSAN Disk Claim Mode"; Value = $VMCluster.VsanDiskClaimMode; }
        }
        
        $Table = AddWordTable -Hashtable $ScriptInformation `
		-Columns Data,Value `
		-List `
		-Format $wdTableGrid `
		-AutoFit $wdAutoFitFixed;

		## IB - Set the header row format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		$Table.Columns.Item(1).Width = 225;
		$Table.Columns.Item(2).Width = 200;

		# $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 0 ""

        If($VMCluster.DrsEnabled -and ($Script:DRSRules | Where-Object{$_.ClusterName -eq $VMCluster.Name}))
        {
            WriteWordLine 2 0 "DRS Rules and Groups"
            ForEach($DRSRule in ($Script:DRSRules | Where-Object{$_.ClusterName -eq $VMCluster.Name}))
            {
                [System.Collections.Hashtable[]] $ScriptInformation = @()
                $ScriptInformation += @{ Data = "Rule Name"; Value = $DRSRule.RuleName; }
                $ScriptInformation += @{ Data = "Rule Type"; Value = $DRSRule.RuleType; }
                $ScriptInformation += @{ Data = "Rule Enabled"; Value = $DRSRule.bRuleEnabled; }
                If($DRSRule.bMandatory)
				{
					$ScriptInformation += @{ Data = "Mandatory"; Value = $DRSRule.bMandatory; }
				}
                If($DRSRule.bKeepTogether)
				{
					$ScriptInformation += @{ Data = "Keep Together"; Value = $DRSRule.bKeepTogether; }
				}
                If($DRSRule.VMNames)
				{
					$ScriptInformation += @{ Data = "Virtual Machines"; Value = $DRSRule.VMNames; }
				}
                If($DRSRule.VMGroupName)
				{
					$ScriptInformation += @{ Data = "VM Group"; Value = $DRSRule.VMGroupName; }
				}
                If($DRSRule.VMGroupMembers)
				{
					$ScriptInformation += @{ Data = "Virtual Machines"; Value = $DRSRule.VMGroupMembers; }
				}
                If($DRSRule.AffineHostGrpName)
				{
					$ScriptInformation += @{ Data = "Host Affinity Group"; Value = $DRSRule.AffineHostGrpName; }
				}
                If($DRSRule.AffineHostGrpMembers)
				{
					$ScriptInformation += @{ Data = "Affinity Group Members"; Value = $DRSRule.AffineHostGrpMembers; }
				}
                If($DRSRule.AntiAffineHostGrpName)
				{
					$ScriptInformation += @{ Data = "Host Anti Affinity Group"; Value = $DRSRule.AntiAffineHostGrpName; }
				}
                If($DRSRule.AntiAffineHostGrpMembers)
				{
					$ScriptInformation += @{ Data = "Anti Affinity Group Members"; Value = $DRSRule.AntiAffineHostGrpMembers; }
				}

                $Table = AddWordTable -Hashtable $ScriptInformation `
                -Columns Data,Value -List -Format $wdTableGrid -AutoFit $wdAutoFitFixed

		        ## IB - Set the header row format
		        SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		        $Table.Columns.Item(1).Width = 225;
		        $Table.Columns.Item(2).Width = 200;

		        # $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		        FindWordDocumentEnd
		        $Table = $Null
		        WriteWordLine 0 0 ""
            }
        }

        If($xClusterHosts)
        {
            [System.Collections.Hashtable[]] $ScriptInformation = @()
            $ScriptInformation += @{ Data = "Hosts in $($VMCluster.Name)";}
            $ScriptInformation += @{ Data = $xClusterHosts;}

            $Table = AddWordTable -Hashtable $ScriptInformation `
		    -Columns Data `
		    -List `
		    -Format $wdTableGrid `
		    -AutoFit $wdAutoFitFixed;

		    ## IB - Set the header row format
		    SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		    $Table.Columns.Item(1).Width = 250;
		    # $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		    FindWordDocumentEnd
		    $Table = $Null
		    WriteWordLine 0 0 "" 
        }
        If($Chart)
        {
			$PSDefaultParameterValues = @{"*:Verbose"=$False}
			$StatTypes = @(Get-StatType -Entity $VMCluster.Name)

			If($StatTypes.Contains("cpu.usagemhz.average"))
			{
				#The CPU utilization. The maximum possible value here is the frequency of the processors times the number of cores. 
				#As an example, a VM using 4000 MHz on a system with four 2 GHz processors is using 50% of the CPU (4000 / (4 * 2000) = 0.5)
				$ClusterCpuAvg = Get-Stat -Entity $VMCluster.Name -Stat cpu.usagemhz.average -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30
				AddStatsChart -StatData $ClusterCpuAvg -Type "Line" -Title "$($VMCluster.Name) CPU Percent" -Width 700 -Length 500
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "The CPU utilization. The maximum possible value here is the frequency of the processors times the number of cores."
				WriteWordLine 0 0 "As an example, a VM using 4000 MHz on a system with four 2 GHz processors is using 50% of the CPU (4000 / (4 * 2000) = 0.5)"
				WriteWordLine 0 0 "Rated in megaHertz"
				WriteWordLine 0 0 ""
			}

			If($StatTypes.Contains("mem.usage.average"))
			{
				#The percentage of memory used as a percent of all available machine memory. Available for host and VM.
				$ClusterMemAvg = Get-Stat -Entity $VMCluster.Name -Stat mem.usage.average -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30
				AddStatsChart -StatData $ClusterMemAvg -Type "Line" -Title "$($VMCluster.Name) Memory Percent" -Width 700 -Length 500
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "The percentage of memory used as a percent of all available machine memory."
				WriteWordLine 0 0 "Available for host and VM."
				WriteWordLine 0 0 "Rated in percent"
			}
			$PSDefaultParameterValues = @{"*:Verbose"=$True}

            WriteWordLine 0 0 ""
        }
    }
    If($HTML)
    {
        $rowdata = @()
        $colWidths = @("150px","200px")
        $rowdata += @(,("Name",($htmlsilver -bor $htmlbold),$VMCluster.Name,$htmlwhite))
        $rowdata += @(,("HA Enabled",($htmlsilver -bor $htmlbold),$VMCluster.HAEnabled,$htmlwhite))
        If($VMCluster.HAEnabled)
        {
            $rowdata += @(,("HA Admission Control Enabled",($htmlsilver -bor $htmlbold),$VMCluster.HAAdmissionControlEnabled,$htmlwhite))
            $rowdata += @(,("HA Failover Level",($htmlsilver -bor $htmlbold),$VMCluster.HAFailoverLevel,$htmlwhite))
            $rowdata += @(,("HA Restart Priority",($htmlsilver -bor $htmlbold),$VMCluster.HARestartPriority,$htmlwhite))
            $rowdata += @(,("HA Isolation Response",($htmlsilver -bor $htmlbold),$VMCluster.HAIsolationResponse,$htmlwhite))
        }
        $xProactiveHA = ($ClusterView | Where-Object{$_.Name -eq $VMCluster.Name})
        $rowdata += @(,("Proactive HA Enabled",($htmlsilver -bor $htmlbold),$xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Enabled))
        If($xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Enabled)
        {
            $rowdata += @(,("Proactive HA Response",($htmlsilver -bor $htmlbold),$xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Behavior))
            $rowdata += @(,("Moderate Remediation Mode",($htmlsilver -bor $htmlbold),$xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.ModerateRemediation))
            $rowdata += @(,("Severe Remediation Mode",($htmlsilver -bor $htmlbold),$xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.SevereRemediation))
            $rowdata += @(,("Proactive HA Providers",($htmlsilver -bor $htmlbold),$xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Providers))
        }
        $rowdata += @(,("DRS Enabled",($htmlsilver -bor $htmlbold),$VMCluster.DrsEnabled,$htmlwhite))
        If($VMCluster.DrsEnabled)
        {
            $rowdata += @(,("DRS Automation Level",($htmlsilver -bor $htmlbold),$VMCluster.DrsAutomationLevel,$htmlwhite))
        }
        $rowdata += @(,("EVC Mode",($htmlsilver -bor $htmlbold),$VMCluster.EVCMode,$htmlwhite))
        If($VMCluster.VsanEnabled)
        {
            $rowdata += @(,("VSAN Enabled",($htmlsilver -bor $htmlbold),$VMCluster.VsanEnabled,$htmlwhite))
            $rowdata += @(,("VSAN Disk Claim Mode",($htmlsilver -bor $htmlbold),$VMCluster.VsanDiskClaimMode,$htmlwhite))
        }

        FormatHTMLTable "Cluster: $($VMCluster.Name)" -noHeadCols 2 -rowArray $rowdata -fixedWidth $colWidths -tablewidth "350"
        WriteHTMLLine 0 1 ""

        If($VMCluster.DrsEnabled -and ($Script:DRSRules | Where-Object{$_.ClusterName -eq $VMCluster.Name}))
        {
            WriteHTMLLine 0 0 "DRS Rules and Groups" -options $htmlbold -fontSize 4
            ForEach($DRSRule in ($Script:DRSRules | Where-Object{$_.ClusterName -eq $VMCluster.Name}))
            {
                $rowdata = @()
                $colWidths = @("150px","200px")
                $rowdata += @(,("Rule Name", ($htmlsilver -bor $htmlbold),$DRSRule.RuleName,$htmlwhite))
                $rowdata += @(,("Rule Type", ($htmlsilver -bor $htmlbold),$DRSRule.RuleType,$htmlwhite))
                $rowdata += @(,("Rule Enabled", ($htmlsilver -bor $htmlbold),$DRSRule.bRuleEnabled,$htmlwhite))
                If($DRSRule.bMandatory)
				{
					$rowdata += @(,("Mandatory", ($htmlsilver -bor $htmlbold),$DRSRule.bMandatory,$htmlwhite))
				}
                If($DRSRule.bKeepTogether)
				{
					$rowdata += @(,("Keep Together", ($htmlsilver -bor $htmlbold),$DRSRule.bKeepTogether,$htmlwhite))
				}
                If($DRSRule.VMNames)
				{
					$rowdata += @(,("Virtual Machines", ($htmlsilver -bor $htmlbold),$DRSRule.VMNames,$htmlwhite))
				}
                If($DRSRule.VMGroupName)
				{
					$rowdata += @(,("VM Group", ($htmlsilver -bor $htmlbold),$DRSRule.VMGroupName,$htmlwhite))
				}
                If($DRSRule.VMGroupMembers)
				{
					$rowdata += @(,("Virtual Machines", ($htmlsilver -bor $htmlbold),$DRSRule.VMGroupMembers,$htmlwhite))
				}
                If($DRSRule.AffineHostGrpName)
				{
					$rowdata += @(,("Host Affinity Group", ($htmlsilver -bor $htmlbold),$DRSRule.AffineHostGrpName,$htmlwhite))
				}
                If($DRSRule.AffineHostGrpMembers)
				{
					$rowdata += @(,("Affinity Group Members", ($htmlsilver -bor $htmlbold),$DRSRule.AffineHostGrpMembers,$htmlwhite))
				}
                If($DRSRule.AntiAffineHostGrpName)
				{
					$rowdata += @(,("Host Anti Affinity Group", ($htmlsilver -bor $htmlbold),$DRSRule.AntiAffineHostGrpName,$htmlwhite))
				}
                If($DRSRule.AntiAffineHostGrpMembers)
				{
					$rowdata += @(,("Anti Affinity Group Members", ($htmlsilver -bor $htmlbold),$DRSRule.AntiAffineHostGrpMembers,$htmlwhite))
				}

                FormatHTMLTable "" -noHeadCols 2 -rowArray $rowdata -fixedWidth $colWidths -tablewidth "350"
                WriteHTMLLine 0 0 ""
            }
        }

        If($xClusterHosts)
        {
            WriteHTMLLine 0 0 "Hosts in $($VMCluster.Name)" -options $htmlbold -fontSize 4
            ForEach ($cluHost in $xClusterHosts -split "`n")
			{
				WriteHTMLLine 0 1 $cluHost
			}
            WriteHTMLLine 0 1 ""
        }
    }
    If($Text)
    {
        Line 0 "Cluster: $($VMCluster.Name)"
        Line 1 "HA Enabled`t`t`t: " $VMCluster.HAEnabled
        If($VMCluster.HAEnabled)
        {
            Line 1 "HA Admission Control`t`t: " $VMCluster.HAAdmissionControlEnabled
            Line 1 "HA Failover Level`t`t: " $VMCluster.HAFailoverLevel
            Line 1 "HA Restart Priority`t`t: " $VMCluster.HARestartPriority
            Line 1 "HA Isolation Response`t`t: " $VMCluster.HAIsolationResponse
        }
        $xProactiveHA = ($ClusterView | Where-Object{$_.Name -eq $VMCluster.Name})
        Line 1 "Proactive HA Enabled`t`t: " $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Enabled
        If($xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Enabled)
        {
            Line 1 "Proactive HA Response`t`t: " $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Behavior
            Line 1 "Moderate Remediation Mode`t: " $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.ModerateRemediation
            Line 1 "Severe Remediation Mode`t`t: " $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.SevereRemediation
            Line 1 "Proactive HA Providers`t`t: " $xProactiveHA.ConfigurationEx.InfraUpdateHaConfig.Providers
        }
        Line 1 "DRS Enabled`t`t`t: " $VMCluster.DrsEnabled
        If($VMCluster.DrsEnabled)
        {
            Line 1 "DRS Automation Level`t`t: " $VMCluster.DrsAutomationLevel
        }
        Line 1 "EVC Mode`t`t`t: " $VMCluster.EVCMode
        If($VMCluster.VsanEnabled)
        {
            Line 1 "VSAN Enabled`t`t`t: " $VMCluster.VsanEnabled
            Line 1 "VSAN Disk Claim Mode`t`t: " $VMCluster.VsanDiskClaimMode
        }
        Line 0 ""

        If($VMCluster.DrsEnabled -and ($Script:DRSRules | Where-Object{$_.ClusterName -eq $VMCluster.Name}))
        {
            Line 0 "DRS Rules and Groups"
            ForEach($DRSRule in ($Script:DRSRules | Where-Object{$_.ClusterName -eq $VMCluster.Name}))
            {
                Line 1 "Rule Name`t`t`t: " $DRSRule.RuleName
                Line 1 "Rule Type`t`t`t: " $DRSRule.RuleType
                Line 1 "Rule Enabled`t`t`t: " $DRSRule.bRuleEnabled
                If($DRSRule.bMandatory)
				{
					Line 1 "Mandatory`t`t`t: " $DRSRule.bMandatory
				}
                If($DRSRule.bKeepTogether)
				{
					Line 1 "Keep Together`t`t`t: " $DRSRule.bKeepTogether
				}
                If($DRSRule.VMNames)
				{
					Line 2 "Virtual Machines`t: " $DRSRule.VMNames
				}
                If($DRSRule.VMGroupName)
				{
					Line 1 "VM Group`t`t`t: " $DRSRule.VMGroupName
				}
                If($DRSRule.VMGroupMembers)
				{
					Line 2 "Virtual Machines`t: " $DRSRule.VMGroupMembers
				}
                If($DRSRule.AffineHostGrpName)
				{
					Line 1 "Host Affinity Group`t`t: " $DRSRule.AffineHostGrpName
				}
                If($DRSRule.AffineHostGrpMembers)
				{
					Line 1 "Affinity Group Members`t`t: " $DRSRule.AffineHostGrpMembers
				}
                If($DRSRule.AntiAffineHostGrpName)
				{
					Line 1 "Host Anti Affinity Group`t: " $DRSRule.AntiAffineHostGrpName
				}
                If($DRSRule.AntiAffineHostGrpMembers)
				{
					Line 1 "Anti Affinity Group Members`t: " $DRSRule.AntiAffineHostGrpMembers
				}

                Line 0 " "
            }
        }

        If($xClusterHosts)
        {
			#Hosts in the cluster
			Line 0 "Hosts in $($VMCluster.Name)"
			ForEach ($xHost in (($VMHosts) | Where-Object{$_.ParentId -eq $VMCLuster.Id}).Name)
			{
				Line 1 $xHost
			}
			Line 0 ""
        }
    }
}
#endregion

#region resource pools function
Function ProcessResourcePools
{
    Write-Verbose "$(Get-Date -Format G): Processing VMware Resource Pools"
    If($MSWord -or $PDF)
	{
		$Selection.InsertNewPage()
		WriteWordLine 1 0 "Resource Pools"
	}
	If($Text)
	{
		Line 0 "Resource Pools"
	}
    If($HTML)
    {
        WriteHTMLLine 1 0 "Resource Pools"
    }

    If($? -and ($Resources))
    {
        ForEach($ResPool in $Resources)
        {
            OutputResourcePools $ResPool
        }
    }
    ElseIf($? -and ($Null -eq $Resources))
    {
        Write-Warning "There are no Resource Pools"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "There are no Resource Pools"
		}
		If($Text)
		{
			Line 1 "There are no Resource Pools"
		}
		If($HTML)
		{
            WriteHTMLLine 0 1 "There are no Resource Pools"
		}
    }
    Else
    {
    	Write-Warning "Unable to retrieve Resource Pools"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "Unable to retrieve Resource Pools"
		}
		If($Text)
		{
			Line 1 "Unable to retrieve Resource Pools"
		}
		If($HTML)
		{
            WriteHTMLLine 0 1 "Unable to retrieve Resource Pools"
		}
    }
}

Function OutputResourcePools
{
    Param([object] $ResourcePool)
    Write-Verbose "$(Get-Date -Format G): `tOutput VMware Resource Pool $($ResourcePool.Name)"

    If((validObject $Script:Clusters Name) -and $Script:Clusters.Name -contains $ResourcePool.Parent)
    {
        $xResourceParent = "$($ResourcePool.Parent) (Cluster Root)"
    }
    ElseIf($VMHosts.Name -contains $ResourcePool.Parent)
    {
        $xResourceParent = "$($ResourcePool.Parent) (Host Root)"
    }
    Else
    {
        $xResourceParent = "$($ResourcePool.Parent)"
    }
    If($ResourcePool.CpuLimitMHz -eq -1)
    {
        $xCpuLimit = "None"
    }
    Else
    {
        $xCpuLimit = "$($ResourcePool.CpuLimitMHz) MHz"
    }
    If($ResourcePool.MemReservationGB -eq -1)
    {
        $xMemRes = "None"
    }
    Else
    {
        If($ResourcePool.MemReservationGB -lt 1)
        {
            $xMemRes = "$([decimal]::Round($ResourcePool.MemReservationMB)) MB"
        }
        $xMemRes = "$([decimal]::Round($ResourcePool.MemReservationGB)) GB"
    }      
    If($ResourcePool.MemLimitGB -eq -1)
    {
        $xMemLimit = "None"
    }
    Else
    {
        If($ResourcePool.MemLimitGB -lt 1)
        {
            $xMemLimit = "$([decimal]::Round($ResourcePool.MemLimitMB)) MB"
        }
        $xMemLimit = "$([decimal]::Round($ResourcePool.MemLimitGB)) GB"
    }
    $xResPoolHosts = @(($Script:VirtualMachines) | Where-Object{$_.ResourcePoolId -eq $ResourcePool.Id} | Select-Object Name | Sort-Object Name)
    If($MSWord -or $PDF)
    {
        WriteWordLine 2 0 "Resource Pool: $($ResourcePool.Name)"
        [System.Collections.Hashtable[]] $ScriptInformation = @()
        $ScriptInformation += @{ Data = "Name"; Value = $ResourcePool.Name; }
        $ScriptInformation += @{ Data = "Parent Pool"; Value = $xResourceParent; }
        $ScriptInformation += @{ Data = "CPU Shares Level"; Value = $ResourcePool.CpuSharesLevel; }
        $ScriptInformation += @{ Data = "Number of CPU Shares"; Value = $ResourcePool.NumCpuShares; }
	    $ScriptInformation += @{ Data = "CPU Reservation"; Value = "$($ResourcePool.CpuReservationMHz) MHz"; }
	    $ScriptInformation += @{ Data = "CPU Limit"; Value = $xCpuLimit; }
        $ScriptInformation += @{ Data = "CPU Limit Expandable"; Value = $ResourcePool.CpuExpandableReservation; }
        $ScriptInformation += @{ Data = "Memory Shares Level"; Value = $ResourcePool.MemSharesLevel; }
        $ScriptInformation += @{ Data = "Number of Memory Shares"; Value = $ResourcePool.NumMemShares; }
	    $ScriptInformation += @{ Data = "Memory Reservation"; Value = $xMemRes; }
	    $ScriptInformation += @{ Data = "Memory Limit"; Value = $xMemLimit; }
        $ScriptInformation += @{ Data = "Memory Limit Expandable"; Value = $ResourcePool.MemExpandableReservation; }

        $Table = AddWordTable -Hashtable $ScriptInformation `
	    -Columns Data,Value `
	    -List `
	    -Format $wdTableGrid `
	    -AutoFit $wdAutoFitFixed;

	    ## IB - Set the header row format
	    SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

	    $Table.Columns.Item(1).Width = 205;
	    $Table.Columns.Item(2).Width = 200;

	    # $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

	    FindWordDocumentEnd
	    $Table = $Null
	    WriteWordLine 0 0 ""
        
        If($xResPoolHosts)
        {
            If($xResPoolHosts.Count -gt 25)
            {
                WriteWordLine 0 0 "VMs in $($ResourcePool.Name)"
                BuildMultiColumnTable $xResPoolHosts.Name
                WriteWordLine 0 0 ""
            }
            Else
            {
                [System.Collections.Hashtable[]] $ScriptInformation = @()
                $ScriptInformation += @{ Data = "VMs in $($ResourcePool.Name)";}
                $ScriptInformation += @{ Data = ($xResPoolHosts.Name) -join "`n";}

                $Table = AddWordTable -Hashtable $ScriptInformation `
		        -Columns Data `
		        -List `
		        -Format $wdTableGrid `
		        -AutoFit $wdAutoFitFixed;

		        ## IB - Set the header row format
		        SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		        $Table.Columns.Item(1).Width = 280;

		        # $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		        FindWordDocumentEnd
		        $Table = $Null
		        WriteWordLine 0 0 ""  
            }
        }
    }
    If($HTML)
    {
        $rowdata = @()
        $colWidths = @("150px","200px")
        $rowdata += @(,("Parent Pool",($htmlsilver -bor $htmlbold),$xResourceParent,$htmlwhite))
        $rowdata += @(,("CPU Shares Level",($htmlsilver -bor $htmlbold),$ResourcePool.CpuSharesLevel,$htmlwhite))
        $rowdata += @(,("Number of CPU Shares",($htmlsilver -bor $htmlbold),$ResourcePool.NumCpuShares,$htmlwhite))
        $rowdata += @(,("CPU Reservation",($htmlsilver -bor $htmlbold),$xCpuLimit,$htmlwhite))
        $rowdata += @(,("CPU Limit",($htmlsilver -bor $htmlbold),$xCpuLimit,$htmlwhite))
        $rowdata += @(,("CPU Limit Expandable",($htmlsilver -bor $htmlbold),$ResourcePool.CpuExpandableReservation,$htmlwhite))
        $rowdata += @(,("Memory Shares Level",($htmlsilver -bor $htmlbold),$ResourcePool.MemSharesLevel,$htmlwhite))
        $rowdata += @(,("Number of Memory Shares",($htmlsilver -bor $htmlbold),$ResourcePool.NumMemShares,$htmlwhite))
        $rowdata += @(,("Memory Reservation",($htmlsilver -bor $htmlbold),$xMemRes,$htmlwhite))
        $rowdata += @(,("Memory Limit",($htmlsilver -bor $htmlbold),$xMemLimit,$htmlwhite))
        $rowdata += @(,("Memory Limit Expandable",($htmlsilver -bor $htmlbold),$ResourcePool.MemExpandableReservation,$htmlwhite))

        FormatHTMLTable "Resource Pool: $($ResourcePool.Name)" -noHeadCols 2 -rowArray $rowdata -fixedWidth $colWidths -tablewidth "350"

        If($xResPoolHosts)
        {
            WriteHTMLLine 2 1 "VMs in $($ResourcePool.Name)"
            ForEach($xVM in (($Script:VirtualMachines) | Where-Object{$_.ResourcePoolId -eq $ResourcePool.Id} | Sort-Object Name).Name)
            {
                WriteHTMLLine 0 2 $xVM
            }
        }
		WriteHTMLLine 0 0 ""
    }
    If($Text)
    {
        Line 0 "Resource Pool: $($ResourcePool.Name)"
        Line 0 ""
        Line 1 "Name`t`t`t: " $ResourcePool.Name
        Line 1 "Parent Pool`t`t: " $xResourceParent
        Line 1 "CPU Shares Level`t: " $ResourcePool.CpuSharesLevel
        Line 1 "Number of CPU Shares`t: " $ResourcePool.NumCpuShares
        Line 1 "CPU Reservation`t`t: $($ResourcePool.CpuReservationMHz) MHz"
        Line 1 "CPU Limit`t`t: " $xCpuLimit
        Line 1 "CPU Limit Expandable`t: " $ResourcePool.CpuExpandableReservation
        Line 1 "Memory Shares Level`t: " $ResourcePool.MemSharesLevel
        Line 1 "Number of Memory Shares`t: " $ResourcePool.NumMemShares
        Line 1 "Memory Reservation`t: " $xMemRes
        Line 1 "Memory Limit`t`t: " $xMemLimit
        Line 1 "Memory Limit Expandable`t: " $ResourcePool.MemExpandableReservation
        Line 0 ""

        If($xResPoolHosts)
        {
            Line 0 "VMs in $($ResourcePool.Name)"
            ForEach($xVM in (($Script:VirtualMachines) | Where-Object{$_.ResourcePoolId -eq $ResourcePool.Id} | Sort-Object Name).Name)
            {
                Line 1 $xVM
            }
            Line 0 ""
        }
    }
}
#endregion

#region host networking and VMKernel ports functions
Function ProcessVMKPorts
{
	Write-Verbose "$(Get-Date -Format G): Processing VMkernel Ports"
	If($MSWord -or $PDF)
	{
		$Selection.InsertNewPage()
		WriteWordLine 1 0 "VMKernel Ports"
	}
	If($Text)
	{
		Line 0 "VMKernel Ports"
	}
	If($HTML)
	{
		#WriteHTMLLine "VMKernel Ports"
	}
	
	$Script:VMKPortGroups = @()
	ForEach ($VMHost in ($VMHosts) | Where-Object{($_.ConnectionState -like "*Connected*") -or ($_.ConnectionState -like "*Maintenance*")})
	{
		If($MSWord -or $PDF)
		{
			WriteWordLine 2 0 "VMKernel Ports on: $($VMHost.Name)"
		}
		If($Text)
		{
			Line 0 "VMKernel Ports on: $($VMHost.Name)"
		}
		If($HTML)
		{
			WriteHTMLLine 2 0 "VMKernel Ports on: $($VMHost.Name)"
		}

		$VMKPorts = $HostNetAdapters | Where-Object{$_.DeviceName -Like "*vmk*" -and $_.VMHost -like $VMHost.Name} | Sort-Object PortGroupName

		If($? -and ($VMKPorts))
		{
			ForEach ($VMK in $VMKPorts)
			{
				OutputVMKPorts $VMK
			}
		}
		ElseIf($? -and ($Null -eq $VMKPorts))
		{
			Write-Warning "There are no VMKernel ports"
			If($MSWord -or $PDF)
			{
				WriteWordLine 0 1 "There are no VMKernel ports"
			}
			If($Text)
			{
				Line 1 "There are no VMKernel ports"
			}
			If($HTML)
			{
				WriteHTMLLine 0 1 "There are no VMKernel ports"
			}
		}
		Else
		{
			If(!($Export))
			{
				Write-Warning "Unable to retrieve VMKernel ports"
			}
			If($MSWord -or $PDF)
			{
				WriteWordLine 0 1 "Unable to retrieve VMKernel ports"
			}
			If($Text)
			{
				Line 1 "Unable to retrieve VMKernel ports"
			}
			If($HTML)
			{
				WriteHTMLLine 0 1 "Unable to retrieve VMKernel ports"
			}
		}
	}
}

Function OutputVMKPorts
{
    Param([object] $VMK)

    Write-Verbose "$(Get-Date -Format G): `tOutput VMkernel Port $($VMK.PortGroupName)"
    $xSwitchDetail = $Script:VirtualPortGroups | Where-Object{$_.Name -like $VMK.PortGroupName} | Select-Object -Unique
    $Script:VMKPortGroups += $VMK.PortGroupName

    If($VMK.VMotionEnabled)
    {
        $xVMotionEnabled = "Yes"
    }
    Else
    {
        $xVMotionEnabled = "No"
    }
	
    If($VMK.FaultToleranceLoggingEnabled)
    {
        $xFTLogging = "Yes"
    }
    Else
    {
        $xFTLogging = "No"
    }
    
	If($VMK.ManagementTrafficEnabled)
    {
        $xMgmtTraffic = "Yes"
    }
    Else
    {
        $xMgmtTraffic = "No"
    }
    
	If($VMK.DhcpEnabled)
    {
        $xIPAddressType = "DHCP"
    }
    Else
    {
        $xIPAddressType = "Static IP"
    }
    
	If( $xSwitchDetail.PSObject.Properties[ 'VLanId' ] )
	{
		Switch($xSwitchDetail.VLanId)
		{
			0		{$xSwitchVLAN = "None"; Break}
			4095	{$xSwitchVLAN = "Trunk"; Break}
			Default	{$xSwitchVLAN = $xSwitchDetail.VLanId.ToString(); Break}
		}
	}
	Else
	{
		$xSwitchVLAN = "N/A"
	}
   
    If($MSWord -or $PDF)
    {
        [System.Collections.Hashtable[]] $ScriptInformation = @()
        $ScriptInformation += @{ Data = "Port Name"; Value = $VMK.PortGroupName; }
        $ScriptInformation += @{ Data = "Port ID"; Value = $VMK.DeviceName; }
        $ScriptInformation += @{ Data = "MAC Address"; Value = $VMK.Mac; }
        $ScriptInformation += @{ Data = "IP Address Type"; Value = $xIPAddressType; }
        $ScriptInformation += @{ Data = "IP Address"; Value = $VMK.IP; }
        $ScriptInformation += @{ Data = "Subnet Mask"; Value = $VMK.SubnetMask; }
        $ScriptInformation += @{ Data = "VLAN ID"; Value = $xSwitchVLAN; }
        $ScriptInformation += @{ Data = "VMotion Traffic?"; Value = $xVMotionEnabled; }
        $ScriptInformation += @{ Data = "FT Logging Traffic?"; Value = $xFTLogging; }
        $ScriptInformation += @{ Data = "Management Traffic?"; Value = $xMgmtTraffic; }
		$cnt = -1
		ForEach($item in $xSwitchDetail.VirtualSwitch)
		{
			$cnt++
			
			If($cnt -eq 0)
			{
				$ScriptInformation += @{ Data = "Parent vSwitch"; Value = $item; }
			}
			Else
			{
				$ScriptInformation += @{ Data = ""; Value = $item; }
			}
		}

        $Table = AddWordTable -Hashtable $ScriptInformation `
		-Columns Data,Value `
		-List `
		-Format $wdTableGrid `
		-AutoFit $wdAutoFitFixed;

		## IB - Set the header row format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		$Table.Columns.Item(1).Width = 190;
		$Table.Columns.Item(2).Width = 220;

		# $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 0 ""
    }
    If($HTML)
    {
        $rowdata = @()
        $colWidths = @("150px","200px")
        $rowdata += @(,("Port Name",($htmlsilver -bor $htmlbold),$VMK.PortGroupName,$htmlwhite))
        $rowdata += @(,("Port ID",($htmlsilver -bor $htmlbold),$VMK.DeviceName,$htmlwhite))
        $rowdata += @(,("MAC Address",($htmlsilver -bor $htmlbold),$VMK.Mac,$htmlwhite))
        $rowdata += @(,("IP Address Type",($htmlsilver -bor $htmlbold),$xIPAddressType,$htmlwhite))
        $rowdata += @(,("IP Address",($htmlsilver -bor $htmlbold),$VMK.IP,$htmlwhite))
        $rowdata += @(,("Subnet Mask",($htmlsilver -bor $htmlbold),$VMK.SubnetMask,$htmlwhite))
        $rowdata += @(,("VLAN ID",($htmlsilver -bor $htmlbold),$xSwitchVLAN,$htmlwhite))
        $rowdata += @(,("vMotion Traffic",($htmlsilver -bor $htmlbold),$xVMotionEnabled,$htmlwhite))
        $rowdata += @(,("FT Logging",($htmlsilver -bor $htmlbold),$xFTLogging,$htmlwhite))
        $rowdata += @(,("Management Traffic",($htmlsilver -bor $htmlbold),$xMgmtTraffic,$htmlwhite))
		$cnt = -1
		ForEach($item in $xSwitchDetail.VirtualSwitch)
		{
			$cnt++
			
			If($cnt -eq 0)
			{
				$rowdata += @(,("Parent vSwitch",($htmlsilver -bor $htmlbold),$item,$htmlwhite))
			}
			Else
			{
				$rowdata += @(,("",($htmlsilver -bor $htmlbold),$item,$htmlwhite))
			}
		}
        
        FormatHTMLTable "" -noHeadCols 2 -rowArray $rowdata -fixedWidth $colWidths -tablewidth "350"
        WriteHTMLLine 0 0 ""
    }
    If($Text)
    {
        Line 1 "Port Name`t`t: " $VMK.PortGroupName
        Line 1 "Port ID`t`t`t: " $VMK.DeviceName
        Line 1 "MAC Address`t`t: " $VMK.Mac
        Line 1 "IP Address Type`t`t: " $xIPAddressType
        Line 1 "IP Address`t`t: " $VMK.IP
        Line 1 "Subnet Mask`t`t: " $VMK.SubnetMask
        Line 1 "VLAN ID`t`t`t: " $xSwitchVLAN
        Line 1 "vMotion Traffic`t`t: " $xVMotionEnabled
        Line 1 "FT Logging Traffic`t: " $xFTLogging
        Line 1 "Management Traffic`t: " $xMgmtTraffic
		$cnt = -1
		ForEach($item in $xSwitchDetail.VirtualSwitch)
		{
			$cnt++
			
			If($cnt -eq 0)
			{
				Line 1 "Parent vSwitch`t`t: " $item
			}
			Else
			{
				Line 4 "  " $item
			}
		}
        Line 0 ""
    }
}

Function ProcessHostNetworking
{
	Write-Verbose "$(Get-Date -Format G): Processing Host Networking"
	If($MSWord -or $PDF)
	{
		$Selection.InsertNewPage()
		WriteWordLine 1 0 "Host Network Adapters"
	}
	If($Text)
	{
		Line 0 "Host Network Adapters"
	}
	If($HTML)
	{
		#WriteHTMLLine 1 0 "Host Network Adapters"
	}

	$NetArray = @()

	ForEach ($VMHost in ($VMHosts) | Where-Object{($_.ConnectionState -like "*Connected*") -or ($_.ConnectionState -like "*Maintenance*")})
	{
		$HostNics = $HostNetAdapters | Where-Object{$_.Name -notlike "*vmk*" -and $_.VMHost -like $VMHost.Name} | Sort-Object Name
		ForEach($Nic in $HostNics)
		{
			$NetObject = New-Object psobject
			$NetObject | Add-Member -Name Hostname -MemberType NoteProperty -Value $VMHost.Name
			$NetObject | Add-Member -Name devName -MemberType NoteProperty -Value $Nic.DeviceName
			$NetObject | Add-Member -Name MAC -MemberType NoteProperty -Value $Nic.Mac
			$NetObject | Add-Member -Name Duplex -MemberType NoteProperty -Value $Nic.FullDuplex
			$NetObject | Add-Member -Name Speed -MemberType NoteProperty -Value $Nic.BitRatePerSec
			$netArray += $NetObject
		}
	}

	If($? -and ($netArray))
	{
		OutputHostNetworking $NetArray
	}
	ElseIf($? -and ($Null -eq $NetArray))
	{
		Write-Warning "There are no Host Network Adapters"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "There are no Host Network Adapters"
		}
		If($Text)
		{
			Line 1 "There are no Host Network Adapters"
		}
		If($HTML)
		{
			WriteHTMLLine 0 1 "There are no Host Network Adapters"
		}
	}
	Else
	{
		If(!($Export))
		{
			Write-Warning "Unable to retrieve Host Network Adapters"
		}
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "Unable to retrieve Host Network Adapters"
		}
		If($Text)
		{
			Line 1 "Unable to retrieve Host Network Adapters"
		}
		If($HTML)
		{
			WriteHTMLLine 0 1 "Unable to retrieve Host Network Adapters"
		}
	}
}

Function OutputHostNetworking
{
	Param([object] $HostNic)

	Write-Verbose "$(Get-Date -Format G): `tOutput Host Networking"
	If($MSWord -or $PDF)
	{
		## Create an array of hashtables
		[System.Collections.Hashtable[]] $HostNicWordTable = @();
		## Seed the row index from the second row
		[int] $CurrentServiceIndex = 2;

		ForEach($xHostNic in $HostNic)
		{
			If($xHostNic.Duplex)
			{
				$xDuplex = "Full Duplex"
			}
			Else
			{
				$xDuplex = "Half Duplex"
			}

			Switch($xHostNic.Speed)
			{
				0		{$xPortSpeed = "Down"; $xDuplex = ""; Break}
				10		{$xPortSpeed = "10Mbps"; Break}
				100		{$xPortSpeed = "100Mbps"; Break}
				1000	{$xPortSpeed = "1Gbps"; Break}
				10000	{$xPortSpeed = "10Gbps"; Break}
				20000	{$xPortSpeed = "20Gbps"; Break}
				40000	{$xPortSpeed = "40Gbps"; Break}
				80000	{$xPortSpeed = "80Gbps"; Break}
				100000	{$xPortSpeed = "100Gbps"; Break}
			}

			## Add the required key/values to the hashtable
			$WordTableRowHash = @{
				Hostname   = $xHostNic.Hostname;
				DeviceName = $xHostNic.devName;
				PortSpeed  = $xPortSpeed;
				MACAddr    = $xHostNic.Mac;
				Duplex     = $xDuplex;
			}
			$HostNicWordTable += $WordTableRowHash;
			$CurrentServiceIndex++    
		}

		## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($HostNicWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $HostNicWordTable `
			-Columns HostName, DeviceName, PortSpeed, MACAddr, Duplex `
			-Headers "Host", "Device Name", "Port Speed", "MAC Address", "Duplex" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
	}
	If($Text)
	{
		Line 1 "Host                            Device Name           Port Speed  MAC Address        Duplex     "
		Line 1 "================================================================================================"
		       #123456789012345678901234567890SS12345678901234567890SS1234567890SS12345678901234567SS12345678901
		ForEach($xHostNic in $HostNic)
		{
			If($xHostNic.Duplex)
			{
				$xDuplex = "Full Duplex"
			}
			Else
			{
				$xDuplex = "Half Duplex"
			}

			Switch($xHostNic.Speed)
			{
				0		{$xPortSpeed = "Down"; $xDuplex = ""; Break}
				10		{$xPortSpeed = "10Mbps"; Break}
				100		{$xPortSpeed = "100Mbps"; Break}
				1000	{$xPortSpeed = "1Gbps"; Break}
				10000	{$xPortSpeed = "10Gbps"; Break}
				20000	{$xPortSpeed = "20Gbps"; Break}
				40000	{$xPortSpeed = "40Gbps"; Break}
				80000	{$xPortSpeed = "80Gbps"; Break}
				100000	{$xPortSpeed = "100Gbps"; Break}
			}

			Line 1 ( "{0,-30}  {1,-20}  {2,-10}  {3,-17}  {4,-17}" -f `
				(truncate $xHostNic.Hostname 27),
				(truncate $xHostNic.DevName 17),
				$xPortSpeed,
				$xHostNic.Mac,
				$xDuplex
			)
		}
		Line 0 ""
	}
	If($HTML)
	{
		$rowdata = @()
		ForEach($xHostNic in $HostNic)
		{
			If($xHostNic.Duplex)
			{
				$xDuplex = "Full Duplex"
			}
			Else
			{
				$xDuplex = "Half Duplex"
			}

			Switch($xHostNic.Speed)
			{
				0		{$xPortSpeed = "Down"; $xDuplex = ""; Break}
				10		{$xPortSpeed = "10Mbps"; Break}
				100		{$xPortSpeed = "100Mbps"; Break}
				1000	{$xPortSpeed = "1Gbps"; Break}
				10000	{$xPortSpeed = "10Gbps"; Break}
				20000	{$xPortSpeed = "20Gbps"; Break}
				40000	{$xPortSpeed = "40Gbps"; Break}
				80000	{$xPortSpeed = "80Gbps"; Break}
				100000	{$xPortSpeed = "100Gbps"; Break}
			}

			$rowdata += @(,(
				$xHostNic.HostName,$htmlwhite,
				$xHostNic.devName,$htmlwhite,
				$xPortSpeed,$htmlwhite,
				$xHostNic.Mac,$htmlwhite,
				$xDuplex,$htmlwhite)
			)
		}

		$columnHeaders = @(
			"Host",($htmlSilver -bor $htmlbold),
			"Device Name",($htmlSilver -bor $htmlbold),
			"Port Speed",($htmlSilver -bor $htmlbold),
			"MAC Address",($htmlSilver -bor $htmlbold),
			"Duplex",($htmlSilver -bor $htmlbold)
		)

		FormatHTMLTable "Host Network Adapters" -rowArray $rowdata -columnArray $columnHeaders
		WriteHTMLLine 0 0 ""
	}
}
#endregion

#region port groups and vswitch functions
Function ProcessVMPortGroups
{
	Write-Verbose "$(Get-Date -Format G): Processing VM Port Groups"
	If($MSWord -or $PDF)
	{
		$Selection.InsertNewPage()
		WriteWordLine 1 0 "Virtual Machine Port Groups"
	}
	If($Text)
	{
		Line 0 "Virtual Machine Port Groups"
	}
	If($HTML)
	{
		WriteHTMLLine 1 0 "Virtual Machine Port Groups"
	}

	If($? -and ($Script:VirtualPortGroups))
	{
		ForEach($VMPortGroup in $Script:VirtualPortGroups)
		{
			OutputVMPortGroups $VMPortGroup
		}
	}
	ElseIf($? -and ($Null -eq $Script:VirtualPortGroups))
	{
		Write-Warning "There are no VM Port Groups"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "There are no VM Port Groups"
		}
		If($Text)
		{
			Line 1 "There are no VM Port Groups"
		}
		If($HTML)
		{
			WriteHTMLLine 0 1 "There are no VM Port Groups"
		}
	}
	Else
	{
		If(!($Export))
		{
			Write-Warning "Unable to retrieve VM Port Groups"
		}
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "Unable to retrieve VM Port Groups"
		}
		If($Text)
		{
			Line 1 "Unable to retrieve VM Port Groups"
		}
		If($HTML)
		{
			WriteHTMLLine 0 1 "Unable to retrieve VM Port Groups"
		}
	}
}

Function BuildMultiColumnTable
{
	Param([Array]$xArray, [String]$xType)
	
	#divide by 0 bug reported 9-Apr-2014 by Lee Dehmer 
	#if security group name or OU name was longer than 60 characters it caused a divide by 0 error
	
	#added a second parameter to the function so the verbose message would say whether 
	#the function is processing servers, security groups or OUs.
	
	If(-not ($xArray -is [Array]))
	{
		$xArray = (,$xArray)
	}
	[int]$MaxLength = 0
	[int]$TmpLength = 0
	#remove 60 as a hard-coded value
	#60 is the max width the table can be when indented 36 points
	[int]$MaxTableWidth = 70
	ForEach($xName in $xArray)
	{
		$TmpLength = $xName.Length
		If($TmpLength -gt $MaxLength)
		{
			$MaxLength = $TmpLength
		}
	}
	$TableRange = $doc.Application.Selection.Range
	#removed hard-coded value of 60 and replace with MaxTableWidth variable
	[int]$Columns = [Math]::Floor($MaxTableWidth / $MaxLength)
	If($xArray.count -lt $Columns)
	{
		[int]$Rows = 1
		#not enough array items to fill columns so use array count
		$MaxCells  = $xArray.Count
		#reset column count so there are no empty columns
		$Columns   = $xArray.Count 
	}
	ElseIf($Columns -eq 0)
	{
		#divide by 0 bug if this condition is not handled
		#number was larger than $MaxTableWidth so there can only be one column
		#with one cell per row
		[int]$Rows = $xArray.count
		$Columns   = 1
		$MaxCells  = 1
	}
	Else
	{
		[int]$Rows = [Math]::Floor( ( $xArray.count + $Columns - 1 ) / $Columns)
		#more array items than columns so don't go past last column
		$MaxCells  = $Columns
	}
	$Table = $doc.Tables.Add($TableRange, $Rows, $Columns)
	$Table.Style = $Script:MyHash.Word_TableGrid
	
	$Table.Borders.InsideLineStyle = $wdLineStyleSingle
	$Table.Borders.OutsideLineStyle = $wdLineStyleSingle
	[int]$xRow = 1
	[int]$ArrayItem = 0
	While($xRow -le $Rows)
	{
		For($xCell=1; $xCell -le $MaxCells; $xCell++)
		{
			$Table.Cell($xRow,$xCell).Range.Text = $xArray[$ArrayItem]
			$ArrayItem++
		}
		$xRow++
	}
	$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustNone)
	$Table.AutoFitBehavior($wdAutoFitContent)

	#return focus back to document
	$doc.ActiveWindow.ActivePane.view.SeekView = $wdSeekMainDocument

	#move to the end of the current document
	$selection.EndKey($wdStory,$wdMove) | Out-Null
	$TableRange = $Null
	$Table = $Null
	$xArray = $Null
}

Function OutputVMPortGroups
{
	Param([object] $VMPortGroup)

	Write-Verbose "$(Get-Date -Format G): `tOutput VM Port Group $($VMPortGroup.Name)"
	If($Script:VMKPortGroups -notcontains $VMPortGroup.Name)
	{
		$xVMOnNetwork = @(($VMNetworkAdapters) | Where-Object{$_.NetworkName -eq $VMPortGroup.Name} | Select-Object Parent | Sort-Object Parent | ForEach-Object {$_.Parent})
            
		If( $VMPortGroup.PSObject.Properties[ 'VLanId' ] )
		{
			Switch($VMPortGroup.VLanId)
			{
				0		{$xPortVLAN = "None"; Break}
				4095	{$xPortVLAN = "Trunk"; Break}
				Default	{$xPortVLAN = $VMPortGroup.VLanId.ToString(); Break}
			}
		}
		Else
		{
			$xPortVLAN = "N/A"
		}

        If($MSWord -or $PDF)
        {
			WriteWordLine 2 0 "VM Port Group: $($VMPortGroup.Name)"
			[System.Collections.Hashtable[]] $ScriptInformation = @()
			$ScriptInformation += @{ Data = "Parent vSwitch"; Value = $VMPortGroup.VirtualSwitch; }
			$ScriptInformation += @{ Data = "VLAN ID"; Value = $xPortVLAN; }

			$Table = AddWordTable -Hashtable $ScriptInformation `
			-Columns Data,Value `
			-List `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitFixed;

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

			$Table.Columns.Item(1).Width = 225;
			$Table.Columns.Item(2).Width = 200;

			# $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null
			WriteWordLine 0 0 ""

			If($xVMOnNetwork)
			{
				If($xVMOnNetwork.Count -gt 25)
				{
					WriteWordLine 0 0 "VMs in $($VMPortGroup.Name)"
					BuildMultiColumnTable $xVMOnNetwork.Name
					WriteWordLine 0 0 ""                    
				}
				Else
				{
					[System.Collections.Hashtable[]] $ScriptInformation = @()
					$ScriptInformation += @{ Data = "VMs on $($VMPortGroup.Name)";}
					$ScriptInformation += @{ Data = ($xVMOnNetwork.Name) -join "`n";}

					$Table = AddWordTable -Hashtable $ScriptInformation `
					-Columns Data `
					-List `
					-Format $wdTableGrid `
					-AutoFit $wdAutoFitFixed;

					## IB - Set the header row format
					SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

					$Table.Columns.Item(1).Width = 280;

					# $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

					FindWordDocumentEnd
					$Table = $Null
					WriteWordLine 0 0 "" 
				}
			}
        }
        If($Text)
        {
            Line 1 "VM Port Group`t: $($VMPortGroup.Name)"
            Line 1 "Parent vSwitch`t: " $VMPortGroup.VirtualSwitch
            Line 1 "VLAN ID`t`t: " $xPortVLAN
            Line 0 ""

            If($xVMOnNetwork)
            {
                Line 1 "VMs on $($VMPortGroup.Name)"
                ForEach($xVMNet in ($VMNetworkAdapters | Where-Object{$_.NetworkName -eq $VMPortGroup.Name} | Select-Object Parent | Sort-Object Name))
                {
                    Line 3 "  " $xVMNet.Parent
                }
            }
            Line 0 ""
        }
        If($HTML)
        {
            $rowData = @()
            $colWidths = @("150px","200px")
            $rowData += @(,("Parent vSwitch",($htmlsilver -bor $htmlbold),$VMPortGroup.Name,$htmlwhite))
            $rowData += @(,("VLAN ID",($htmlsilver -bor $htmlbold),$xPortVLAN,$htmlwhite))
            FormatHTMLTable "VM Port Group: $($VMPortGroup.Name)" -noHeadCols 2 -rowArray $rowData -fixedWidth $colWidths -tablewidth "350"
            WriteHTMLLine 0 0 ""

            If($xVMOnNetwork)
            {
                WriteHTMLLine 2 1 "VMs on $($VMPortGroup.Name)"
                ForEach($xVMNet in ($VMNetworkAdapters | Where-Object{$_.NetworkName -eq $VMPortGroup.Name} | Select-Object Parent | Sort-Object Name))
                {
                    WriteHTMLLine 0 2 $xVMNet.Parent
                }
                WriteHTMLLine 0 0 ""
            }
        }
    }
}

Function ProcessStandardVSwitch
{
	Write-Verbose "$(Get-Date -Format G): Processing DV Switching"
	$PSDefaultParameterValues = @{"*:Verbose"=$False}
	#2.01 fix bug. Using *>$Null caused the Get-DvSwitch cmdlet's output to also go to $Null and $DvSwitches was empty
    $DvSwitches = Get-VDSwitch 2>$Null 
	$PSDefaultParameterValues = @{"*:Verbose"=$True}
    If($DvSwitches)
    {
        ## DV Switches found - process them
        If($MSWord -or $PDF)
        {
            $Selection.InsertNewPage()
            WriteWordLine 1 0 "DV Switching"
            OutputDVSwitching $DvSwitches
        }
        If($Text)
        {
            Line 0 "DV Switching"
            OutputDVSwitching $DvSwitches
        }
        If($HTML)
        {
            WriteHTMLLine 1 0 "DV Switching"
            OutputDVSwitching $DvSwitches
        }
    }

    Write-Verbose "$(Get-Date -Format G): Processing Standard vSwitching"
    If($MSWord -or $PDF)
	{
		$Selection.InsertNewPage()
		WriteWordLine 1 0 "Standard vSwitching"
	}
	If($Text)
	{
		Line 0 "Standard vSwitching"
	}
    If($HTML)
    {
        #nothing
    }

    $vSwitchArray = @()
    ForEach ($VMHost in $VMHosts)
    {
		$stdVSwitchs = New-Object System.Collections.ArrayList
		
		ForEach($Item in $Script:VirtualSwitches)
		{
			If( $Item.PSObject.Properties[ 'VMHost' ] )
			{
				$null = $stdVSwitchs.Add($Item)
			}
		}
        #$stdVSwitchs = $Script:VirtualSwitches | Where-Object{$_.VMHost -like $VMHost.Name} | Sort-Object Name
        
		ForEach ($vSwitch in $stdVSwitchs)
        {
            $switchObj = New-Object psobject
            $switchObj | Add-Member -Name HostName -MemberType NoteProperty -Value $VMHost.Name
            $switchObj | Add-Member -Name Name -MemberType NoteProperty -Value $vSwitch.Name
            $switchObj | Add-Member -Name NumPorts -MemberType NoteProperty -Value $vSwitch.NumPorts
            $switchObj | Add-Member -Name NumPortsAvailable -MemberType NoteProperty -Value $vSwitch.NumPortsAvailable
            $switchObj | Add-Member -Name Mtu -MemberType NoteProperty -Value $vSwitch.Mtu
            $switchObj | Add-Member -Name Nic -MemberType NoteProperty -Value $vSwitch.Nic
            $vSwitchArray += $switchObj
        }
    }

	If($? -and ($vSwitchArray))
	{
		OutputStandardVSwitch $vSwitchArray
	}
	ElseIf($? -and ($Null -eq $stdVSwitchs))
	{
		Write-Warning "There are no standard VSwitches configured on $($VMHost.Name)"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "There are no standard VSwitches configured on $($VMHost.Name)"
		}
		If($Text)
		{
			Line 1 "There are no standard VSwitches configured on $($VMHost.Name)"
		}
		If($HTML)
		{
			WriteHTMLLine 0 1 "There are no standard VSwitches configured on $($VMHost.Name)"
		}
	}
	Else
	{
		If(!($Export))
		{
			Write-Warning "Unable to retrieve standard VSwitches configured"
		}
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "Unable to retrieve standard VSwitches configured"
		}
		If($Text)
		{
			Line 1 "Unable to retrieve standard VSwitches configured"
		}
		If($HTML)
		{
			WriteHTMLLine 0 1 "Unable to retrieve standard VSwitches configured"
		}
	}
}

Function OutputStandardVSwitch
{
    Param([object] $stdVSwitchs)

    Write-Verbose "$(Get-Date -Format G): `tOutput Standard vSwitching"
    If($MSWord -or $PDF)
    {
        ## Create an array of hashtables
	    [System.Collections.Hashtable[]] $switchWordTable = @();
	    ## Seed the row index from the second row
	    [int] $CurrentServiceIndex = 2;

        ForEach($stdVSwitch in $stdVSwitchs)
        {
            $xvSwitchNics = ($stdVSwitch.Nic) -join ", "

            ## Add the required key/values to the hashtable
	        $WordTableRowHash = @{
				VMHost = $stdVSwitch.HostName;
				switchName = $stdVSwitch.Name;
				NumPorts = $stdVSwitch.NumPorts;
				NumPortsAvail = $stdVSwitch.NumPortsAvailable;
				Mtu = $stdVSwitch.Mtu;
				Nics = $xvSwitchNics
            }

            $switchWordTable += $WordTableRowHash;
            $CurrentServiceIndex++;
        }

		If($switchWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $switchWordTable `
			-Columns VMHost, switchName, NumPorts, NumPortsAvail, Mtu, Nics `
			-Headers "Host", "vSwitch", "Total Ports", "Ports Available", "MTU", "Physical Adapters" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			SetWordTableAlternateRowColor $Table $wdColorGray05 "Second"
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

			# $Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
    }
    If($Text)
    {
		Line 1 "Host                            vSwitch Name          Total Ports  Ports Available  vSwitch MTU  Physical Host Adapters"
		Line 1 "======================================================================================================================="
		       #123456789012345678901234567890SS12345678901234567890SS12345678901SS123456789012345SS12345678901SS1234567890123456789012
        ForEach($stdVSwitch in $stdVSwitchs)
        {
            $xvSwitchNics = ($stdVSwitch.Nic) -join " "

			Line 1 ( "{0,-30}  {1,-20}  {2,-11}  {3,-15}  {4,-11}  {5,-22}" -f `
				(truncate $stdVSwitch.HostName 27),
				(truncate $stdVSwitch.Name 17),
				$stdVSwitch.NumPorts,
				$stdVSwitch.NumPortsAvailable,
				$stdVSwitch.Mtu,
				$xvSwitchNics
			)
        }
        Line 0 ""
    }
    If($HTML)
    {
        $rowdata = @()
        $columnHeaders = @(
			"Host",($htmlsilver -bor $htmlbold),
			"vSwitch",($htmlsilver -bor $htmlbold),
			"Total Ports",($htmlsilver -bor $htmlbold),
			"Ports Available",($htmlsilver -bor $htmlbold),
			"MTU",($htmlsilver -bor $htmlbold),
			"Physical Adapters",($htmlsilver -bor $htmlbold)
		)
        
        ForEach($stdVSwitch in $stdVSwitchs)
        {
            $xvSwitchNics = ($stdVSwitch.Nic) -join " "
            $rowdata += @(,(
				$stdVSwitch.HostName,$htmlwhite,
				$stdVSwitch.Name,$htmlwhite,
				$stdVSwitch.NumPorts,$htmlwhite,
				$stdVSwitch.NumPortsAvailable,$htmlwhite,
				$stdVSwitch.Mtu,$htmlwhite,
				$xvSwitchNics,$htmlwhite)
			)
        }
        FormatHTMLTable "Standard VSwitching" -rowArray $rowdata -columnArray $columnHeaders
    }
}

Function OutputDVSwitching
{
    Param([object] $dvSwitches)
	Write-Verbose "$(Get-Date -Format G): `tOutput DV Switching"

    $VdPortGroups = Get-VDPortgroup 4>$Null
    If($MSWord -or $PDF)
    {
        ## Create an array of hashtables
	    [System.Collections.Hashtable[]] $dvSwitchWordTable = @();
	    ## Seed the row index from the second row
	    [int] $CurrentServiceIndex = 2;

        ForEach($dvSwitch in $dvSwitches)
        {
            ## Add the required key/values to the hashtable
	        $WordTableRowHash = @{ 
				dvName = $dvSwitch.Name;
				dvVendor = $dvSwitch.Vendor;
				dvVersion = $dvSwitch.Version;
				dvUplink = $dvSwitch.NumUplinkPorts;
				dvMtu = $dvSwitch.Mtu
            }
	        ## Add the hash to the array
	        $dvSwitchWordTable += $WordTableRowHash;
	        $CurrentServiceIndex++;

        }

        ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($dvSwitchWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $dvSwitchWordTable `
			-Columns dvName, dvVendor, dvVersion, dvUplink, dvMtu `
			-Headers "Switch Name", "Vendor", "Switch Version", "Uplink Ports", "Switch MTU" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

			# $Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}

        ## Create an array of hashtables
	    [System.Collections.Hashtable[]] $dvPortWordTable = @();
	    ## Seed the row index from the second row
	    [int] $CurrentServiceIndex = 2;

        Write-Verbose "$(Get-Date -Format G): `t`tGathering DV Port data"
        ForEach($vdPortGroup in $VdPortGroups)
        {
            ForEach($vdPort in (Get-VDPort -VDPortgroup $VdPortGroup.Name 4>$null| Where-Object{$Null -ne $_.ConnectedEntity}))
            {
                #If($vdPort.ConnectedEntity -like "*vmk*"){$xPortName = "VMKernel"}Else{$xPortName = $vdPort.Name}
                If($VdPort.IsLinkUp)
				{
					$xLinkUp = "Up"
				}
				Else
				{
					$xLinkUp = "Down"
				}

                ## Add the required key/values to the hashtable
	            $WordTableRowHash = @{ 
					hostName = $vdport.ProxyHost;
					entity = $vdport.ConnectedEntity;
					portGroup = $vdport.Portgroup;
					linkstatus = $xLinkUp;
					macAddr = $vdport.MacAddress;
					switch = $vdport.Switch
                }
	            ## Add the hash to the array
	            $dvPortWordTable += $WordTableRowHash;
	            $CurrentServiceIndex++;         
            }
        }

        ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($dvPortWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $dvPortWordTable `
			-Columns hostname, entity, portGroup, linkstatus, macAddr, switch `
			-Headers "Host Name", "Entity", "Port Group", "Status", "MAC Address", "DV Switch" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
    }
    If($HTML)
    {
        $rowData = @()
        $columnHeaders = @(
			"Switch Name",($htmlsilver -bor $htmlbold),
			"Vendor",($htmlsilver -bor $htmlbold),
			"Switch Version",($htmlsilver -bor $htmlbold),
			"Uplink Ports",($htmlsilver -bor $htmlbold),
			"Switch MTU",($htmlsilver -bor $htmlbold)
		)
        
        ForEach($dvSwitch in $dvSwitches)
        {
            $rowData += @(,(
				$dvSwitch.Name,$htmlwhite,
				$dvSwitch.Vendor,$htmlwhite,
				$dvSwitch.Version,$htmlwhite,
				$dvSwitch.NumUplinkPorts,$htmlwhite,
				$dvSwitch.Mtu,$htmlwhite)
			)
        }
        FormatHTMLTable "DV Switches" -rowArray $rowData -columnArray $columnHeaders
        WriteHTMLLine 0 0 ""

        $rowData = @()
        $columnHeaders = @(
			"Host Name",($htmlsilver -bor $htmlbold),
			"Entity",($htmlsilver -bor $htmlbold),
			"Port Group",($htmlsilver -bor $htmlbold),
			"Status",($htmlsilver -bor $htmlbold),
			"MAC Address",($htmlsilver -bor $htmlbold),
			"DV Switch",($htmlsilver -bor $htmlbold)
		)

        Write-Verbose "$(Get-Date -Format G): `t`tGathering DV Port data"
        ForEach($vdPortGroup in $VdPortGroups)
        {
            ForEach($vdPort in (Get-VDPort -VDPortgroup $VdPortGroup.Name 4>$null| Where-Object{$Null -ne $_.ConnectedEntity}))
            {
                If($VdPort.IsLinkUp)
				{
					$xLinkUp = "Up"
				}
				Else
				{
					$xLinkUp = "Down"
				}
                $rowData += @(,(
					$vdport.ProxyHost,$htmlwhite,
					$vdport.ConnectedEntity,$htmlwhite,
					$vdport.Portgroup,$htmlwhite,
					$xLinkUp,$htmlwhite,
					$vdport.MacAddress,$htmlwhite,
					$vdport.Switch,$htmlwhite)
				)
            }
        }
        FormatHTMLTable "DV SwitchPorts" -rowArray $rowData -columnArray $columnHeaders
        WriteHTMLLine 0 0 ""
    }
	If($Text)
	{
        Line 0 "DV Switches"
		Line 1 "Switch Name                     Vendor                Switch Version  Uplink Ports  Switch MTU"
		Line 1 "=============================================================================================="
		       #123456789012345678901234567890SS12345678901234567890SS12345678901234SS123456789012SS1234567890
        
        ForEach($dvSwitch in $dvSwitches)
        {
			Line 1 ( "{0,-30}  {1,-20}  {2,-14}  {3,-12}  {4,-10}" -f `
				(truncate $dvSwitch.Name 27),
				(truncate $dvSwitch.Vendor 17),
				$dvSwitch.Version,
				$dvSwitch.NumUplinkPorts,
				$dvSwitch.Mtu
			)
        }
        Line 0 ""

        Line 0 "DV SwitchPorts"
		Line 1 "Host Name                       Entity                Port Group                      Status  MAC Address        DV Switch      "
		Line 1 "================================================================================================================================"
               #123456789012345678901234567890SS12345678901234567890SS123456789012345678901234567890SS123456SS12345678901234567SS123456789012345		

        Write-Verbose "$(Get-Date -Format G): `t`tGathering DV Port data"
        ForEach($vdPortGroup in $VdPortGroups)
        {
            ForEach($vdPort in (Get-VDPort -VDPortgroup $VdPortGroup.Name 4>$null| Where-Object{$Null -ne $_.ConnectedEntity}))
            {
                If($VdPort.IsLinkUp)
				{
					$xLinkUp = "Up"
				}
				Else
				{
					$xLinkUp = "Down"
				}

				Line 1 ( "{0,-30}  {1,-20}  {2,-30}  {3,-6}  {4,-17}  {5,-15}" -f `
					(truncate $vdport.ProxyHost 27),
					(truncate $vdport.ConnectedEntity 17),
					(truncate $vdport.Portgroup 27),
					$xLinkUp,
					$vdport.MacAddress,
					$vdport.Switch
				)
            }
        }
        Line 0 ""
	}
}
#endregion

#region storage and datastore functions
Function ProcessDatastores
{
    Write-Verbose "$(Get-Date -Format G): Processing Datastores"
    If($MSWord -or $PDF)
	{
		$Selection.InsertNewPage()
		WriteWordLine 1 0 "VM Datastores"
	}
	If($Text)
	{
		Line 0 "VM Datastores"
	}
    If($HTML)
    {
        WriteHTMLLine 1 0 "Datastores"
    }
    ForEach ($Datastore in $Script:Datastores)
    {
        OutputDatastores $Datastore
    }
}

Function OutputDatastores
{
	Param([object] $Datastore)

	Write-Verbose "$(Get-Date -Format G): `tOutput Datastore $($Datastore.Name)"
	If($Datastore.StorageIOControlEnabled)
	{
		$xSIOC = "Enabled"
	}
	Else
	{
		$xSIOC = "Disabled"
	}

	If($MSWord -or $PDF)
	{
		WriteWordLine 2 0 "Datastore: $($Datastore.Name)"
		[System.Collections.Hashtable[]] $ScriptInformation = @()
		$ScriptInformation += @{ Data = "Name"; Value = $Datastore.Name; }
		$ScriptInformation += @{ Data = "Type"; Value = $Datastore.Type; }
		$ScriptInformation += @{ Data = "Status"; Value = $Datastore.State; }
		$ScriptInformation += @{ Data = "Free Space"; Value = "$([decimal]::Round($Datastore.FreeSpaceGB)) GB"; }
		$ScriptInformation += @{ Data = "Capacity"; Value = "$([decimal]::Round($Datastore.CapacityGB)) GB"; }
		$ScriptInformation += @{ Data = "Storage IO Control"; Value = $xSIOC; }
		If($Null -ne  $Datastore.CongestionThresholdMillisecond)
		{
			$ScriptInformation += @{ Data = "SIOC Threshold"; Value = "$($Datastore.CongestionThresholdMillisecond) ms"; }
		}
		If($Datastore.Type -like "NFS*")
		{
			$cnt=-1
			ForEach($Item in $Datastore.RemoteHost)
			{
				$cnt++

				If($cnt -eq 0)
				{
					$ScriptInformation += @{ Data = "NFS Server"; Value = $Item; }
				}
				Else
				{
					$ScriptInformation += @{ Data = ""; Value = $Item; }
				}
			}
			$ScriptInformation += @{ Data = "Share Path"; Value = $Datastore.RemotePath; }
		}
		If($Datastore.Type -like "VMFS*")
		{
			$ScriptInformation += @{ Data = "File System Version"; Value = $Datastore.FileSystemVersion; }
		}

		$Table = AddWordTable -Hashtable $ScriptInformation `
		-Columns Data,Value `
		-List `
		-Format $wdTableGrid `
		-AutoFit $wdAutoFitFixed;

		## IB - Set the header row format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		$Table.Columns.Item(1).Width = 180;
		$Table.Columns.Item(2).Width = 260;

		# $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 0 ""

		#Hosts connected to this datastore
		$xHostsConnected = (($VMHosts) | Where-Object{$_.DatastoreIdList -contains $Datastore.Id} | Select-Object -ExpandProperty Name | Sort-Object Name ) -join "`n"

		[System.Collections.Hashtable[]] $ScriptInformation = @()
		$ScriptInformation += @{ Data = "Hosts Connected to $($Datastore.Name)";}
		$ScriptInformation += @{ Data = $xHostsConnected;}

		$Table = AddWordTable -Hashtable $ScriptInformation `
		-Columns Data `
		-List `
		-Format $wdTableGrid `
		-AutoFit $wdAutoFitFixed;

		## IB - Set the header row format
		SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		$Table.Columns.Item(1).Width = 280;

		# $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 0 "" 
	}
	If($HTML)
	{
		$rowData = @()
		$colWidths = @("150px","200px")
		$rowData += @(,("Datastore",($htmlsilver -bor $htmlbold),$Datastore.Name,$htmlWhite))
		$rowData += @(,("Type",($htmlsilver -bor $htmlbold),$Datastore.Type,$htmlWhite))
		$rowData += @(,("Status",($htmlsilver -bor $htmlbold),$Datastore.State,$htmlWhite))
		$rowData += @(,("Free Space",($htmlsilver -bor $htmlbold),"$([decimal]::Round($Datastore.FreeSpaceGB)) GB",$htmlWhite))
		$rowData += @(,("Capacity",($htmlsilver -bor $htmlbold),"$([decimal]::Round($Datastore.CapacityGB)) GB",$htmlWhite))
		$rowData += @(,("Storage IO Control",($htmlsilver -bor $htmlbold),$xSIOC,$htmlWhite))
		If($Null -ne  $Datastore.CongestionThresholdMillisecond)
		{
			$rowData += @(,("SIOC Threshold",($htmlsilver -bor $htmlbold),"$($Datastore.CongestionThresholdMillisecond) ms",$htmlWhite))
		}
		If($Datastore.Type -like "NFS*")
		{
			$cnt=-1
			ForEach($Item in $Datastore.RemoteHost)
			{
				$cnt++

				If($cnt -eq 0)
				{
					$rowData += @(,("NFS Server",($htmlsilver -bor $htmlbold),$Item,$htmlWhite))
				}
				Else
				{
					$rowData += @(,("",($htmlsilver -bor $htmlbold),$Item,$htmlWhite))
				}
			}
			$rowData += @(,("Share Path",($htmlsilver -bor $htmlbold),$Datastore.RemotePath,$htmlWhite))
		}
		If($Datastore.Type -like "VMFS*")
		{
			$rowData += @(,("File System Version",($htmlsilver -bor $htmlbold),$Datastore.FileSystemVersion,$htmlWhite))
		}
		FormatHTMLTable $Datastore.Name -noHeadCols 2 -rowArray $rowData -fixedWidth $colWidths -tablewidth "350"
		WriteHTMLLine 0 1 ""
	}
	If($Text)
	{
		Line 0 "Datastore: $($Datastore.Name)"
		Line 1 "Name`t`t`t: " $Datastore.Name
		Line 1 "Type`t`t`t: " $Datastore.Type
		Line 1 "Status`t`t`t: " $Datastore.State
		Line 1 "Free Space`t`t: $([decimal]::Round($Datastore.FreeSpaceGB)) GB"
		Line 1 "Capacity`t`t: $([decimal]::Round($Datastore.CapacityGB)) GB"
		Line 1 "Storage IO Control`t: " $xSIOC
		If($Null -ne  $Datastore.CongestionThresholdMillisecond)
		{
			Line 1 "SIOC Threshold`t`t: $($Datastore.CongestionThresholdMillisecond) ms"
		}
		If($Datastore.Type -like "NFS*")
		{
			$cnt=-1
			ForEach($Item in $Datastore.RemoteHost)
			{
				$cnt++

				If($cnt -eq 0)
				{
					Line 1 "NFS Server`t`t: " $Item
				}
				Else
				{
					Line 4 "  " $Item
				}
			}
			Line 1 "Share Path`t`t: " $Datastore.RemotePath
		}
		If($Datastore.Type -like "VMFS*")
		{
			Line 1 "File System Version`t: " $Datastore.FileSystemVersion
		}
		Line 0 ""
	}
}
#endregion

#region virtual machine functions
Function ProcessVirtualMachines
{
    Write-Verbose "$(Get-Date -Format G): Processing Virtual Machines"
    If($MSWord -or $PDF)
	{
		$Selection.InsertNewPage()
		WriteWordLine 1 0 "Virtual Machines"
        $First = $True
	}
	If($Text)
	{
		Line 0 "Virtual Machines"
	}
	If($HTML)
	{
		WriteHTMLLine 1 0 "Virtual Machines"
	}

    If($? -and ($Script:VirtualMachines))
    {
        $First = $True
        ForEach($VM in $Script:VirtualMachines)
        {
            If(!$First -and !$Export)
			{
				If($MSWord -or $PDF)
				{
					$Selection.InsertNewPage()
				}
			}
            OutputVirtualMachines $VM
            $First = $False
        }
    }
    ElseIf($? -and ($Null -eq $Script:VirtualMachines))
    {
        Write-Warning "There are no Virtual Machines"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "There are no Virtual Machines"
		}
		If($Text)
		{
			Line 1 "There are no Virtual Machines"
		}
		If($HTML)
		{
			WriteHTMLLine 0 1 "There are no Virtual Machines"
		}
    }
    Else
    {
    	Write-Warning "Unable to retrieve Virtual Machines"
		If($MSWord -or $PDF)
		{
			WriteWordLine 0 1 "Unable to retrieve Virtual Machines"
		}
		If($Text)
		{
			Line 1 "Unable to retrieve Virtual Machines"
		}
		If($HTML)
		{
			WriteHTMLLine 0 1 "Unable to retrieve Virtual Machines"
		}
    }
}

Function OutputVirtualMachines
{
	Param([object] $VM)

	Write-Verbose "$(Get-Date -Format G): `tOutput Virtual Machine $($VM.Name)"
	If($VM.MemoryGB -lt 1)
	{
		$xMemAlloc = "$($VM.MemoryMB) MB"
	}
	Else
	{
		$xMemAlloc = "$($VM.MemoryGB) GB"
	}
	If($VM.Guest.OSFullName)
	{
		$xGuestOS = $VM.Guest.OSFullName
	}
	Else
	{
		$xGuestOS = $VM.GuestId
	}
	If($VM.VApp)
	{
		$xParentFolder = "VAPP: $($VM.VApp)"
		$xParentResPool = "VAPP: $($VM.VApp)"
	}
	Else
	{
		$xParentFolder = $VM.Folder
		$xParentResPool = $VM.ResourcePool
	}
	If($VM.ExtensionData.Config.CpuAllocation.Limit -eq -1)
	{
		$xCpuLimit = 'Unlimited'
	}
	Else
	{
		$xCpuLimit = "$($VM.ExtensionData.Config.CpuAllocation.Limit) MHz"
	}

	If($VM.ExtensionData.Config.MemoryAllocation.Limit -eq -1)
	{
		$xMemLimit = 'Unlimited'
	}
	Else
	{
		$xMemLimit = "$($VM.ExtensionData.Config.MemoryAllocation.Limit) MB"
	}

	$xVMDetail = $False
	If($VM.Guest.State -eq "Running")
	{
		$xVMDetail = $True
		If($Export)
		{
			$VM.Guest | Export-Clixml .\Export\VMDetail\$($VM.Name)-Detail.xml 4>$Null
		}
		If($Import)
		{
			$GuestImport = Import-Clixml .\Export\VMDetail\$($VM.Name)-Detail.xml
		}
	}

	If($MSWord -or $PDF)
	{
		WriteWordLine 2 0 "VM: $($VM.Name)"
		[System.Collections.Hashtable[]] $ScriptInformation = @()
		$ScriptInformation += @{ Data = "Name"; Value = $VM.Name; }
		If(![String]::IsNullOrEmpty($VM.Notes))
		{
			$ScriptInformation += @{ Data = "Notes"; Value = $VM.Notes.Replace("`n"," "); }
		}
		$ScriptInformation += @{ Data = "Guest OS"; Value = $xGuestOS; }
		$ScriptInformation += @{ Data = "VM Hardware Version"; Value = $VM.HardwareVersion; }
		$ScriptInformation += @{ Data = "Power State"; Value = $VM.PowerState; }
		$ScriptInformation += @{ Data = "Guest State"; Value = $VM.Guest.State; }
		$ScriptInformation += @{ Data = "Guest Tools Status"; Value = $VM.Guest.ExtensionData.ToolsStatus; }
		$ScriptInformation += @{ Data = "Guest Tools Version"; Value = $VM.Guest.ToolsVersion; }
		If($xVMDetail)
		{
			$ScriptInformation += @{ Data = "Guest IP Address"; Value = $VM.Guest.ExtensionData.IpAddress; }
		}
		$ScriptInformation += @{ Data = "Guest Tools Time Sync"; Value = $VM.ExtensionData.Config.Tools.SyncTimeWithHost; }
		$ScriptInformation += @{ Data = "Current Host"; Value = $VM.VMHost; }
		$ScriptInformation += @{ Data = "Parent Folder"; Value = $xParentFolder; }
		$ScriptInformation += @{ Data = "Parent Resource Pool"; Value = $xParentResPool; }
		If($VM.VApp)
		{
			$ScriptInformation += @{ Data = "Part of a VApp"; Value = $VM.VApp; }
		}
		$ScriptInformation += @{ Data = "vCPU Sockets"; Value = $VM.NumCPU/$VM.ExtensionData.Config.Hardware.NumCoresPerSocket; }
		$ScriptInformation += @{ Data = "vCPU Cores per Socket"; Value = $VM.ExtensionData.Config.Hardware.NumCoresPerSocket; }
		$ScriptInformation += @{ Data = "vCPU Total"; Value = $VM.NumCpu; }
		$ScriptInformation += @{ Data = "CPU Resources"; Value = "$($VM.VMResourceConfiguration.CpuSharesLevel) - $($VM.VMResourceConfiguration.NumCpuShares)"; }
		$ScriptInformation += @{ Data = "CPU Reservation"; Value = "$($VM.ExtensionData.Config.CpuAllocation.Reservation) Mhz"; }
		$ScriptInformation += @{ Data = "CPU Resource Limit"; Value = $xCpuLimit; }
		$ScriptInformation += @{ Data = "RAM Allocation"; Value = $xMemAlloc; }
		$ScriptInformation += @{ Data = "RAM Resources"; Value = "$($VM.VMResourceConfiguration.MemSharesLevel) - $($VM.VMResourceConfiguration.NumMemShares)"; }
		$ScriptInformation += @{ Data = "RAM Reservation"; Value = "$($VM.ExtensionData.Config.MemoryAllocation.Reservation) MB"; }
		$ScriptInformation += @{ Data = "RAM Resource Limit"; Value = $xMemLimit; }
		
		$VMNics = Get-NetworkAdapter -VM $VM.Name 4>$Null
		
		If($? -and $Null -ne $VMNics)
		{
			$xNicCount = 0
			ForEach($VMNic in $VMNics)
			{
				$xNicCount++
				$ScriptInformation += @{ Data = "Network Adapter $($xNicCount)"; Value = $VMNic.Type; }
				$ScriptInformation += @{ Data = "     Port Group"; Value = $VMNic.NetworkName; }
				$ScriptInformation += @{ Data = "     MAC Address"; Value = $VMNic.MacAddress; }
				If($Import)
				{
					$xVMGuestNics = $GuestImport.Nics
				}
				Else
				{
					$xVMGuestNics = $VM.Guest.Nics
				}
				If($xVMDetail)
				{
					$cnt=-1
					ForEach($Item in $VM.Guest.IPAddress)
					{
						$cnt++
						
						If($cnt -eq 0)
						{
							$ScriptInformation += @{ Data = "     IP Address"; Value = $Item; }
						}
						Else
						{
							$ScriptInformation += @{ Data = ""; Value = $Item; }
						}
					}
				}
			}
		}
		$ScriptInformation += @{ Data = "Storage Allocation"; Value = "$([decimal]::Round($VM.ProvisionedSpaceGB)) GB"; }
		$ScriptInformation += @{ Data = "Storage Usage"; Value = "{0:N2}" -f $VM.UsedSpaceGB + " GB"; }
		If($xVMDetail)
		{
			If($Import)
			{
				$xVMDisks = $GuestImport.Disks
			}
			Else
			{
				$xVMDisks = $VM.Guest.Disks
			}
			ForEach($VMVolume in ($xVMDisks | Sort-Object Path))
			{
				$ScriptInformation += @{ Data = "Guest Volume Path"; Value = $VMVolume.Path; }
				$ScriptInformation += @{ Data = "     Capacity"; Value = "{0:N2}" -f $VMVolume.CapacityGB + " GB"; }
				$ScriptInformation += @{ Data = "     Free Space"; Value = "{0:N2}" -f $VMVolume.FreeSpaceGB + " GB"; }
			}
		}

		$VMHardDisks = Get-HardDisk -VM $VM.Name 4>$Null
		
		If($? -and $Null -ne $VMHardDisks)
		{
			$xDiskCount = 0
			ForEach($VMDisk in $VMHardDisks)
			{
				$xDiskCount += 1
				$ScriptInformation += @{ Data = "Hard Disk $($xDiskCount)"; Value = "{0:N2}" -f $VMDisk.CapacityGB + " GB"; }
				If( $VMDisk.PSObject.Properties[ 'Filename' ] )
				{
					$ScriptInformation += @{ Data = "     Datastore"; Value = $VMDisk.Filename.Substring($VMDisk.Filename.IndexOf("[")+1,$VMDisk.Filename.IndexOf("]")-1); }
					$ScriptInformation += @{ Data = "     Disk Path"; Value = $VMDisk.Filename.Substring($VMDisk.Filename.IndexOf("]")+2); }
				}
				If( $VMDisk.PSObject.Properties[ 'StorageFormat' ] )
				{
					$ScriptInformation += @{ Data = "     Format"; Value = $VMDisk.StorageFormat; }
				}
				If( $VMDisk.PSObject.Properties[ 'DiskType' ] )
				{
					$ScriptInformation += @{ Data = "     Type"; Value = $VMDisk.DiskType; }
				}
				If( $VMDisk.PSObject.Properties[ 'Persistence' ] )
				{
					$ScriptInformation += @{ Data = "     Persistence"; Value = $VMDisk.Persistence; }
				}
			}
		}
		
		$Snapshots = Get-Snapshot -VM $VM.Name 4>$Null
		
		If($? -and $Null -ne $Snapshots)
		{
			$Snaps = 0
			ForEach($Snapshot in $Snapshots)
			{
				$Snaps++
			}

			If($Snaps -gt 0)
			{
				$ScriptInformation += @{ Data = "VM has Snapshots"; Value = $Snaps.ToString(); }
			}
		}

		$Table = AddWordTable -Hashtable $ScriptInformation `
		-Columns Data,Value `
		-List `
		-Format $wdTableGrid `
		-AutoFit $wdAutoFitFixed;

		## IB - Set the header row format
		SetWordCellFormat -Collection $Table.Columns.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

		$Table.Columns.Item(1).Width = 150;
		$Table.Columns.Item(2).Width = 300;

		# $Table.Rows.SetLeftIndent($Indent1TabStops,$wdAdjustProportional)

		FindWordDocumentEnd
		$Table = $Null
		WriteWordLine 0 0 ""

		If($VM.Guest.State -eq "Running" -and $Chart)
		{
			$PSDefaultParameterValues = @{"*:Verbose"=$False}
			$StatTypes = @(Get-StatType -Entity $VM.Name)

			If($StatTypes.Contains("cpu.usage.average"))
			{
				#The CPU utilization. This value is reported with 100% representing all processor cores on the system. As an example, a 2-way VM using 50% of a four-core system is completely using two cores.
				$VMCpuAvg = Get-Stat -Entity $VM.Name -Stat cpu.usage.average -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30
				AddStatsChart -StatData $VMCpuAvg -Type "Line" -Title "$($VM.Name) CPU Percent" -Width 700 -Length 500
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "The CPU utilization. This value is reported with 100% representing all processor cores on the system."
				WriteWordLine 0 0 "As an example, a 2-way VM using 50% of a four-core system is completely using two cores."
				WriteWordLine 0 0 "Rated in percent"
				WriteWordLine 0 0 ""
			}

			If($StatTypes.Contains("mem.usage.average"))
			{
				#The percentage of memory used as a percent of all available machine memory. Available for host and VM.
				$VMMemAvg = Get-Stat -Entity $VM.Name -Stat mem.usage.average -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30
				AddStatsChart -StatData $VMMemAvg -Type "Line" -Title "$($VM.Name) Memory Percent" -Width 700 -Length 500
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "The percentage of memory used as a percent of all available machine memory."
				WriteWordLine 0 0 "Available for host and VM."
				WriteWordLine 0 0 "Rated in percent"
				WriteWordLine 0 0 ""
			}

			If($StatTypes.Contains("virtualDisk.write.average") -and $StatTypes.Contains("virtualDisk.read.average"))
			{
				#Rate of writing data from the virtual disk.
				#Rate of reading data from the virtual disk.
				$VMdiskWrite = Get-Stat -Entity $VM.Name -Stat "virtualDisk.write.average" -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30 | Where-Object{$_.Instance -like ""}
				$VMdiskread = Get-Stat -Entity $VM.Name -Stat "virtualDisk.read.average" -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30 | Where-Object{$_.Instance -like ""}
				AddStatsChart -StatData $VMdiskWrite -StatData2 $VMdiskread -Title "$($VM.Name) Disk IO" -Width 700 -Length 500 -Data1Label "Write IO" -Data2Label "Read IO" -Legend -Type "Line"
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "Rate of writing data from the virtual disk."
				WriteWordLine 0 0 "Rate of reading data from the virtual disk."
				WriteWordLine 0 0 "Both are rated in kiloBytesPerSecond"
				WriteWordLine 0 0 ""
			}

			If($StatTypes.Contains("net.received.average") -and $StatTypes.Contains("net.transmitted.average"))
			{
				#Average network throughput for received traffic.
				#Average network throughput for transmitted traffic.
				$VMNetRec = Get-Stat -Entity $VM.Name -Stat "net.received.average" -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30 | Where-Object{$_.Instance -like ""}
				$VMNetTrans = Get-Stat -Entity $VM.Name -Stat "net.transmitted.average" -Start (Get-Date).AddDays(-7) -Finish (Get-Date) -IntervalMins 30 | Where-Object{$_.Instance -like ""}
				AddStatsChart -StatData $VMNetRec -StatData2 $VMNetTrans -Title "$($VM.Name) Net IO" -Width 700 -Length 500 -Data1Label "Recv" -Data2Label "Trans" -Legend -Type "Line"
				WriteWordLine 0 0 ""
				WriteWordLine 0 0 "Average network throughput for received traffic."
				WriteWordLine 0 0 "Average network throughput for transmitted traffic."
				WriteWordLine 0 0 "Both are rated in kiloBytesPerSecond"
				WriteWordLine 0 0 ""
			}
			$PSDefaultParameterValues = @{"*:Verbose"=$True}
		} 
	}
	If($Text)
	{
		Line 0 "VM: $($VM.Name)"
		Line 1 "Name`t`t`t: " $VM.Name
		If(![String]::IsNullOrEmpty($VM.Notes))
		{
			Line 1 "Notes`t`t`t: " (truncate $VM.Notes.Replace("`n"," ") 100)
		}
		Line 1 "Guest OS`t`t: " $xGuestOS
		Line 1 "VM Hardware Version`t: " $VM.HardwareVersion
		Line 1 "Power State`t`t: " $VM.PowerState
		Line 1 "Guest State`t`t: " $VM.Guest.State
		Line 1 "Guest Tools Status`t: " $VM.Guest.ExtensionData.ToolsStatus
		Line 1 "Guest Tools Version`t: " $VM.Guest.ToolsVersion
		If($xVMDetail)
		{
			Line 1 "Guest IP Address`t: " $VM.Guest.ExtensionData.IpAddress
		}
		Line 1 "Guest Tools Time Sync`t: " $VM.ExtensionData.Config.Tools.SyncTimeWithHost
		Line 1 "Current Host`t`t: " $VM.VMHost
		Line 1 "Parent Folder`t`t: " $xParentFolder
		Line 1 "Parent Resource Pool`t: " $xParentResPool
		If($VM.VApp)
		{
			Line 1 "Part of a VApp`t`t: " $VM.VApp
		}
		Line 1 "vCPU Sockets`t`t: " ($VM.NumCPU/$VM.ExtensionData.Config.Hardware.NumCoresPerSocket)
		Line 1 "vCPU Cores per Socket`t: " $VM.ExtensionData.Config.Hardware.NumCoresPerSocket
		Line 1 "vCPU Total`t`t: " $VM.NumCpu
		Line 1 "CPU Resources`t`t: $($VM.VMResourceConfiguration.CpuSharesLevel) - $($VM.VMResourceConfiguration.NumCpuShares)"
		Line 1 "CPU Reservation`t`t: $($VM.ExtensionData.Config.CpuAllocation.Reservation) Mhz"
		Line 1 "CPU Resource Limit`t: " $xCpuLimit
		Line 1 "RAM Allocation`t`t: " $xMemAlloc
		Line 1 "RAM Resources`t`t: $($VM.VMResourceConfiguration.MemSharesLevel) - $($VM.VMResourceConfiguration.NumMemShares)"
		Line 1 "RAM Reservation`t`t: $($VM.ExtensionData.Config.MemoryAllocation.Reservation) MB"
		Line 1 "RAM Resource Limit`t: " $xMemLimit
		
		$VMNics = Get-NetworkAdapter -VM $VM.Name 4>$Null
		
		If($? -and $Null -ne $VMNics)
		{
			$xNicCount = 0
			ForEach($VMNic in $VMNics)
			{
				$xNicCount += 1
				Line 1 "Network Adapter $($xNicCount)`t: " $VMNic.Type
				Line 2 "Port Group`t: " $VMNic.NetworkName
				Line 2 "MAC Address`t: " $VMNic.MacAddress
				If($Import)
				{
					$xVMGuestNics = $GuestImport.Nics
				}
				Else
				{
					$xVMGuestNics = $VM.Guest.Nics
				}
				If($xVMDetail)
				{
					$cnt=-1
					ForEach($Item in $VM.Guest.IPAddress)
					{
						$cnt++
						
						If($cnt -eq 0)
						{
							Line 2 "IP Address`t: " $Item
						}
						Else
						{
							Line 4 "  " $Item
						}
					}
				}
			}
		}
		Line 1 "Storage Allocation`t: $([decimal]::Round($VM.ProvisionedSpaceGB)) GB"
		Line 1 "Storage Usage`t`t: " $("{0:N2}" -f $VM.UsedSpaceGB + " GB")
		If($xVMDetail)
		{
			ForEach($VMVolume in $VM.Guest.Disks)
			{
				Line 1 "Guest Volume Path`t: " $VMVolume.Path
				Line 2 "Capacity`t: " $("{0:N2}" -f $VMVolume.CapacityGB + " GB")
				Line 2 "Free Space`t: " $("{0:N2}" -f $VMVolume.FreeSpaceGB + " GB")
			}
		}
		
		$VMHardDisks = Get-HardDisk -VM $VM.Name 4>$Null
		
		If($? -and $Null -ne $VMHardDisks)
		{
			$xDiskCount = 0
			ForEach($VMDisk in $VMHardDisks)
			{
				$xDiskCount += 1
				Line 1 "Hard Disk $($xDiskCount)`t`t: " $("{0:N2}" -f $VMDisk.CapacityGB + " GB")
				If( $VMDisk.PSObject.Properties[ 'Filename' ] )
				{
					Line 2 "Datastore`t: " $VMDisk.Filename.Substring($VMDisk.Filename.IndexOf("[")+1,$VMDisk.Filename.IndexOf("]")-1)
					Line 2 "Disk Path`t: " $VMDisk.Filename.Substring($VMDisk.Filename.IndexOf("]")+2)
				}
				If( $VMDisk.PSObject.Properties[ 'StorageFormat' ] )
				{
					Line 2 "Format`t`t: " $VMDisk.StorageFormat
				}
				If( $VMDisk.PSObject.Properties[ 'DiskType' ] )
				{
					Line 2 "Type`t`t: " $VMDisk.DiskType
				}
				If( $VMDisk.PSObject.Properties[ 'Persistence' ] )
				{
					Line 2 "Persistence`t: " $VMDisk.Persistence
				}
			}
		}
		
		$Snapshots = Get-Snapshot -VM $VM.Name 4>$Null
		
		If($? -and $Null -ne $Snapshots)
		{
			$Snaps = 0
			ForEach($Snapshot in $Snapshots)
			{
				$Snaps++
			}

			If($Snaps -gt 0)
			{
				Line 1 "VM has Snapshots`t: " $Snaps.ToString()
			}
		}
		Line 0 ""
	}
	If($HTML)
	{
		$rowdata = @()
		$rowdata += @(,("Name",($htmlsilver -bor $htmlbold),$VM.Name,$htmlwhite))
		If(![String]::IsNullOrEmpty($VM.Notes))
		{
			$rowdata += @(,("Notes",($htmlsilver -bor $htmlbold),$VM.Notes.Replace("`n"," "),$htmlwhite))
		}
		$rowdata += @(,("Guest OS",($htmlsilver -bor $htmlbold),$xGuestOS,$htmlwhite))
		$rowdata += @(,("VM Hardware Version",($htmlsilver -bor $htmlbold),$VM.HardwareVersion,$htmlwhite))
		$rowdata += @(,("Power State",($htmlsilver -bor $htmlbold),$VM.PowerState,$htmlwhite))
		$rowdata += @(,("Guest State",($htmlsilver -bor $htmlbold),$VM.Guest.State,$htmlwhite))
		$rowdata += @(,("Guest Tools Status",($htmlsilver -bor $htmlbold),$VM.Guest.Extensiondata.ToolsStatus,$htmlwhite))
		$rowdata += @(,("Guest Tools Version",($htmlsilver -bor $htmlbold),$VM.Guest.ToolsVersion,$htmlwhite))
		If($xVMDetail)
		{
			$rowdata += @(,("Guest IP Address",($htmlsilver -bor $htmlbold),$VM.Guest.Extensiondata.IpAddress,$htmlwhite))
		}
		$rowdata += @(,("Guest Tools Time Sync",($htmlsilver -bor $htmlbold),$VM.ExtensionData.Config.Tools.SyncTimeWithHost,$htmlwhite))
		$rowdata += @(,("Current Host",($htmlsilver -bor $htmlbold),$VM.VMHost,$htmlwhite))
		$rowdata += @(,("Parent Folder",($htmlsilver -bor $htmlbold),$xParentFolder,$htmlwhite))
		$rowdata += @(,("Parent Resource Pool",($htmlsilver -bor $htmlbold),$xParentResPool,$htmlwhite))
		If($VM.VApp)
		{
			$rowdata += @(,("Part of a VApp",($htmlsilver -bor $htmlbold),$VM.VApp,$htmlwhite))
		}
		$rowdata += @(,("vCPU Sockets",($htmlsilver -bor $htmlbold),($VM.NumCPU/$VM.ExtensionData.Config.Hardware.NumCoresPerSocket),$htmlwhite))
		$rowdata += @(,("vCPU Cores per Socket",($htmlsilver -bor $htmlbold),$VM.ExtensionData.Config.Hardware.NumCoresPerSocket,$htmlwhite))
		$rowdata += @(,("vCPU Total",($htmlsilver -bor $htmlbold),$VM.NumCpu,$htmlwhite))
		$rowdata += @(,("CPU Resources",($htmlsilver -bor $htmlbold),"$($VM.VMResourceConfiguration.CpuSharesLevel) - $($VM.VMResourceConfiguration.NumCpuShares)",$htmlwhite))
		$rowdata += @(,("CPU Reservation",($htmlsilver -bor $htmlbold),"$($VM.ExtensionData.Config.CpuAllocation.Reservation) Mhz",$htmlwhite))
		$rowdata += @(,("CPU Resource Limit",($htmlsilver -bor $htmlbold),$xCpuLimit,$htmlwhite))
		$rowdata += @(,("RAM Allocation",($htmlsilver -bor $htmlbold),$xMemAlloc,$htmlwhite))
		$rowdata += @(,("RAM Resources",($htmlsilver -bor $htmlbold),"$($VM.VMResourceConfiguration.MemSharesLevel) - $($VM.VMResourceConfiguration.NumMemShares)",$htmlwhite))
		$rowdata += @(,("RAM Reservation",($htmlsilver -bor $htmlbold),"$($VM.ExtensionData.Config.MemoryAllocation.Reservation) MB",$htmlwhite))
		$rowdata += @(,("RAM Resource Limit",($htmlsilver -bor $htmlbold),$xMemLimit,$htmlwhite))
		
		$VMNics = Get-NetworkAdapter -VM $VM.Name 4>$Null
		
		If($? -and $Null -ne $VMNics)
		{
			$xNicCount = 0
			ForEach($VMNic in $VMNics)
			{
				$xNicCount += 1
				$rowdata += @(,("Network Adapter $($xNicCount)",($htmlsilver -bor $htmlbold),$VMNic.Type,$htmlwhite))
				$rowdata += @(,("     Port Group",($htmlsilver -bor $htmlbold),$VMNic.NetworkName,$htmlwhite))
				$rowdata += @(,("     MAC Address",($htmlsilver -bor $htmlbold),$VMNic.MacAddress,$htmlwhite))
				If($Import)
				{
					$xVMGuestNics = $GuestImport.Nics
				}
				Else
				{
					$xVMGuestNics = $VM.Guest.Nics
				}
				If($xVMDetail)
				{
					$cnt=-1
					ForEach($Item in $VM.Guest.IPAddress)
					{
						$cnt++
						
						If($cnt -eq 0)
						{
							$rowdata += @(,("     IP Address",($htmlsilver -bor $htmlbold),$Item,$htmlwhite))
						}
						Else
						{
							$rowdata += @(,("",($htmlsilver -bor $htmlbold),$Item,$htmlwhite))
						}
					}
				}
			}
		}

		$rowdata += @(,("Storage Allocation",($htmlsilver -bor $htmlbold),"$([decimal]::Round($VM.ProvisionedSpaceGB)) GB",$htmlwhite))
		$rowdata += @(,("Storage Usage",($htmlsilver -bor $htmlbold),$("{0:N2}" -f $VM.UsedSpaceGB + " GB"),$htmlwhite))
		If($xVMDetail)
		{
			If($Import)
			{
				$xVMDisks = $GuestImport.Disks
			}
			Else
			{
				$xVMDisks = $VM.Guest.Disks
			}

			ForEach($VMVolume in $xVMDisks)
			{
				$rowdata += @(,("Guest Volume Path",($htmlsilver -bor $htmlbold),$VMVolume.Path,$htmlwhite))
				$rowdata += @(,("     Capacity",($htmlsilver -bor $htmlbold),$("{0:N2}" -f $VMVolume.CapacityGB + " GB"),$htmlwhite))
				$rowdata += @(,("     Free Space",($htmlsilver -bor $htmlbold),$("{0:N2}" -f $VMVolume.FreeSpaceGB + " GB"),$htmlwhite))
			}
		}

		$VMHardDisks = Get-HardDisk -VM $VM.Name 4>$Null
		
		If($? -and $Null -ne $VMHardDisks)
		{
			$xDiskCount = 0
			ForEach($VMDisk in $VMHardDisks)
			{
				$xDiskCount += 1
				$rowdata += @(,("Hard Disk $($xDiskCount)",($htmlsilver -bor $htmlbold),$("{0:N2}" -f $VMDisk.CapacityGB + " GB"),$htmlwhite))
				If( $VMDisk.PSObject.Properties[ 'Filename' ] )
				{
					$rowdata += @(,("     Datastore",($htmlsilver -bor $htmlbold),$VMDisk.Filename.Substring($VMDisk.Filename.IndexOf("[")+1,$VMDisk.Filename.IndexOf("]")-1),$htmlwhite))
					$rowdata += @(,("     Disk Path",($htmlsilver -bor $htmlbold),$VMDisk.Filename.Substring($VMDisk.Filename.IndexOf("]")+2),$htmlwhite))
				}
				If( $VMDisk.PSObject.Properties[ 'StorageFormat' ] )
				{
					$rowdata += @(,("     Format",($htmlsilver -bor $htmlbold),$VMDisk.StorageFormat,$htmlwhite))
				}
				If( $VMDisk.PSObject.Properties[ 'DiskType' ] )
				{
					$rowdata += @(,("     Type",($htmlsilver -bor $htmlbold),$VMDisk.DiskType,$htmlwhite))
				}
				If( $VMDisk.PSObject.Properties[ 'Persistence' ] )
				{
					$rowdata += @(,("     Persistence",($htmlsilver -bor $htmlbold),$VMDisk.Persistence,$htmlwhite))
				}
			}
		}
		
		$Snapshots = Get-Snapshot -VM $VM.Name 4>$Null
		
		If($? -and $Null -ne $Snapshots)
		{
			$Snaps = 0
			ForEach($Snapshot in $Snapshots)
			{
				$Snaps++
			}

			If($Snaps -gt 0)
			{
				$rowdata += @(,("VM has Snapshots",($htmlsilver -bor $htmlbold),$Snaps.ToString(),$htmlwhite))
			}
		}

		$colWidths = @("150px","300px")
		FormatHTMLTable "VM: $($VM.Name)" -rowArray $rowdata -noHeadCols 2 -fixedWidth $colWidths -tablewidth "450"
		WriteHTMLLine 0 0 ""
	}
}
#endregion

#region vCenter Issues functions
Function ProcessSnapIssues
{
    If($Snapshots)
    {
        Write-Verbose "$(Get-Date -Format G): Processing Issues: Virtual Machine Snapshots found"
        If($MSWord -or $PDF)
	    {
		    $Selection.InsertNewPage()
		    WriteWordLine 1 0 "Virtual Machines with Snapshots"
	    }
	    If($Text)
		{
			Line 0 "Virtual Machines with Snapshots"
		}
        If($HTML)
	    {
		    WriteHTMLLine 1 0 "Virtual Machines with Snapshots"
	    }
            
        OutputSnapIssues $Snapshots
    }
}

Function OutputSnapIssues
{
    Param([object] $VMSnaps)

	Write-Verbose "$(Get-Date -Format G): `tOutput Issues: Virtual Machine Snapshots found"
    If($MSWord -or $PDF)
    {
		[System.Collections.Hashtable[]] $SnapWordTable = @()
		ForEach($Snap in $VMSnaps)
		{
			$WordTableRowHash = @{ 
				SnapVM = $Snap.VM;
				SnapName = $Snap.Name;
				SnapCreated = $Snap.Created;
				SnapIsCurrent = $Snap.IsCurrent;
				SnapParentSnapshot = $Snap.ParentSnapshot;
				SnapQuiesced = $Snap.Quiesced;
				SnapDescription = $Snap.Description
			}
			## Add the hash to the array
			$SnapWordTable += $WordTableRowHash;
		}

		 ## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		 If($SnapWordTable.Count -gt 0)
		 {
			$Table = AddWordTable -Hashtable $SnapWordTable `
			-Columns SnapVM, SnapName, SnapCreated, SnapIsCurrent, SnapParentSnapshot, SnapQuiesced, SnapDescription `
			-Headers "Virtual Machine", "Snapshot Name", "Created", "Running Current", "Parent", "Quiesced", "Description" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
	}
    If($HTML)
    {
        $rowdata = @()
        $columnHeaders = @(
			"Virtual Machine",($htmlsilver -bor $htmlbold),
			"Snapshot Name",($htmlsilver -bor $htmlbold),
			"Created",($htmlsilver -bor $htmlbold),
			"Running Current",($htmlsilver -bor $htmlbold),
			"Parent",($htmlsilver -bor $htmlbold),
			"Quiesced",($htmlsilver -bor $htmlbold),
			"Description",($htmlsilver -bor $htmlbold)
		)

        ForEach($Snap in $VMSnaps)
        {
            $rowdata += @(,(
				$Snap.VM,$htmlwhite,
				$Snap.Name,$htmlwhite,
				$Snap.Created,$htmlwhite,
				$Snap.IsCurrent,$htmlwhite,
				$Snap.ParentSnapshot,$htmlwhite,
				$Snap.Quiesced,$htmlwhite,
				$Snap.Description,$htmlwhite)
			)
        }

        FormatHTMLTable "" -rowArray $rowdata -columnArray $columnHeaders
    }
    If($Text)
    {
        ForEach($Snap in $VMSnaps)
        {
			Line 1 "Virtual Machine`t: " $Snap.VM
			Line 1 "Snapshot Name`t: " $Snap.Name
			Line 1 "Created`t`t: " $Snap.Created
			Line 1 "Running Current`t: " $Snap.IsCurrent
			Line 1 "Parent`t`t: " $Snap.ParentSnapshot
			Line 1 "Quiesced`t: " $Snap.Quiesced
			Line 1 "Description`t: " $Snap.Description
			Line 0 ""
        }
    }
}

Function ProcessOpticalIssues
{
    #$VMCDRom = $Script:VirtualMachines | Where-Object{$_.CDDrives.ConnectionState.Connected}
	
	$CDDrives = New-Object System.Collections.ArrayList
	
	ForEach($Item in $Script:VirtualMachines)
	{
		$CDDVDs = Get-CDDrive -VM $Item.Name 4>$Null
		
		If($? -and $Null -ne $CDDVDs)
		{
			ForEach($CDDVD in $CDDVDs)
			{
				If( $CDDVD.PSObject.Properties[ 'ConnectionState' ] -and $CDDVD.ConnectionState.Connected)
				{
					$null = $CDDrives.Add($CDDVD)
				}
			}
		}
	}
	
	#$VMCDRom = $Script:VirtualMachines | Where-Object{($_ | Get-CDDrive 4>$Null).ConnectionState.Connected}
    If($CDDrives)
    {
        Write-Verbose "$(Get-Date -Format G): Processing Issues: Mounted CDROM drives found"
        If($MSWord -or $PDF)
	    {
		    $Selection.InsertNewPage()
		    WriteWordLine 1 0 "Virtual Machines with CDROM drives mounted"
	    }
	    If($Text)
		{
			Line 0 "Virtual Machines with CDROM drives mounted"
		}
		If($HTML)
		{
		    WriteHTMLLine 1 0 "Virtual Machines with CDROM drives mounted"
		}

        OutputOpticalIssues $CDDrives
    }
}

Function OutputOpticalIssues
{
    Param([object] $CDDrives)

	Write-Verbose "$(Get-Date -Format G): `tOutput Issues: Mounted CDROM drives found"
    If($MSWord -or $PDF)
    {
		[System.Collections.Hashtable[]] $OpticalWordTable = @()
		ForEach($CDDrive in $CDDrives)
		{
			$WordTableRowHash = @{ 
				VMName           = $CDDrive.Parent;
				VMCDName         = $CDDrive.Name;
				VMCDIsoPath      = $CDDrive.IsoPath;
				VMCDHostDevice   = $CDDrive.HostDevice;
				VMCDRemoteDevice = $CDDrive.RemoteDevice
			}
			## Add the hash to the array
			$OpticalWordTable+= $WordTableRowHash;
		}

		## Add the table to the document, using the hashtable (-Alt is short for -AlternateBackgroundColor!)
		If($OpticalWordTable.Count -gt 0)
		{
			$Table = AddWordTable -Hashtable $OpticalWordTable `
			-Columns VMName, VMCDName, VMCDIsoPath, VMCDHostDevice, VMCDRemoteDevice `
			-Headers "Virtual Machine", "CD/DVD Drive","ISO Path", "Host Device", "Remote Device" `
			-Format $wdTableGrid `
			-AutoFit $wdAutoFitContent;

			## IB - Set the header row format
			SetWordCellFormat -Collection $Table -Size 9 -BackgroundColor $wdColorWhite
			SetWordCellFormat -Collection $Table.Rows.Item(1).Cells -Bold -BackgroundColor $wdColorGray15;

			$Table.Rows.SetLeftIndent($Indent0TabStops,$wdAdjustProportional)

			FindWordDocumentEnd
			$Table = $Null

			WriteWordLine 0 0 ""
		}
    }
    If($HTML)
    {
        WriteHTMLLine 0 0 ""
        $rowdata = @()
        $columnHeaders = @(
			"Virtual Machine",($htmlsilver -bor $htmlbold),
			"CD/DVD Drive",($htmlsilver -bor $htmlbold),
			"ISO Path",($htmlsilver -bor $htmlbold),
			"Host Device",($htmlsilver -bor $htmlbold),
			"Remote Device",($htmlsilver -bor $htmlbold)
		)

		ForEach($CDDrive in $CDDrives)
		{
			$rowdata += @(,(
				$CDDrive.Parent,$htmlwhite,
				$CDDrive.Name,$htmlwhite,
				$CDDrive.IsoPath,$htmlwhite,
				$CDDrive.HostDevice,$htmlwhite,
				$CDDrive.RemoteDevice,$htmlwhite)
			)
		}

        FormatHTMLTable "" -rowArray $rowdata -columnArray $columnHeaders
    }
    If($Text)
    {
		ForEach($CDDrive in $CDDrives)
		{
			Line 1 "Virtual Machine`t: " $CDDrive.Parent
			Line 1 "CD/DVD Drive`t: " $CDDrive.Name
			Line 1 "ISO Path`t: " $CDDrive.IsoPath
			Line 1 "Host Device`t: " $CDDrive.HostDevice
			Line 1 "Remote Device`t: " $CDDrive.RemoteDevice
			Line 0 ""
		}
    }
}
#endregion

#region script setup function
Function ProcessScriptSetup
{
	$script:startTime = Get-Date
}
#endregion

#region script end function
Function ProcessScriptEnd
{
	Write-Verbose "$(Get-Date -Format G): Script has completed"
	Write-Verbose "$(Get-Date -Format G): "

	#http://poshtips.com/measuring-elapsed-time-in-powershell/
	Write-Verbose "$(Get-Date -Format G): Script started: $($Script:StartTime)"
	Write-Verbose "$(Get-Date -Format G): Script ended: $(Get-Date)"
	$runtime = $(Get-Date) - $Script:StartTime
	$Str = [string]::format("{0} days, {1} hours, {2} minutes, {3}.{4} seconds", `
		$runtime.Days, `
		$runtime.Hours, `
		$runtime.Minutes, `
		$runtime.Seconds,
		$runtime.Milliseconds)
	Write-Verbose "$(Get-Date -Format G): Elapsed time: $($Str)"

	If($Dev)
	{
		If($SmtpServer -eq "")
		{
			Out-File -FilePath $Script:DevErrorFile -InputObject $error 4>$Null
		}
		Else
		{
			Out-File -FilePath $Script:DevErrorFile -InputObject $error -Append 4>$Null
		}
	}

	If($ScriptInfo)
	{
		$SIFile = "$Script:pwdpath\VMwareInventoryScriptV2Info_$(Get-Date -f yyyy-MM-dd_HHmm).txt"
		Out-File -FilePath $SIFile -InputObject "" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Add DateTime   : $AddDateTime" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Chart          : $Chart" 4>$Null
		If($MSWORD -or $PDF)
		{
			Out-File -FilePath $SIFile -Append -InputObject "Company Address: $CompanyAddress" 4>$Null		
			Out-File -FilePath $SIFile -Append -InputObject "Company Email  : $CompanyEmail" 4>$Null		
			Out-File -FilePath $SIFile -Append -InputObject "Company Fax    : $CompanyFax" 4>$Null		
			Out-File -FilePath $SIFile -Append -InputObject "Company Name   : $Script:CoName" 4>$Null		
			Out-File -FilePath $SIFile -Append -InputObject "Company Phone  : $CompanyPhone" 4>$Null		
			Out-File -FilePath $SIFile -Append -InputObject "Cover Page     : $CoverPage" 4>$Null
		}
		Out-File -FilePath $SIFile -Append -InputObject "Dev            : $Dev" 4>$Null
		If($Dev)
		{
			Out-File -FilePath $SIFile -Append -InputObject "DevErrorFile   : $Script:DevErrorFile" 4>$Null
		}
		Out-File -FilePath $SIFile -Append -InputObject "Export         : $Export" 4>$Null
		If($HTML)
		{
			Out-File -FilePath $SIFile -Append -InputObject "HTMLFilename   : $Script:HTMLFileName" 4>$Null
		}
		If($MSWord)
		{
			Out-File -FilePath $SIFile -Append -InputObject "WordFilename   : $Script:WordFileName" 4>$Null
		}
		If($PDF)
		{
			Out-File -FilePath $SIFile -Append -InputObject "PDFFilename    : $Script:PDFFileName" 4>$Null
		}
		If($Text)
		{
			Out-File -FilePath $SIFile -Append -InputObject "TextFilename   : $Script:TextFileName" 4>$Null
		}
		Out-File -FilePath $SIFile -Append -InputObject "Folder         : $Folder" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "From           : $From" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Full           : $Full" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Import         : $Import" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Issues         : $Issues" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Log            : $Log" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Report Footer  : $ReportFooter" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Save As HTML   : $HTML" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Save As PDF    : $PDF" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Save As TEXT   : $TEXT" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Save As WORD   : $MSWORD" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Script Info    : $ScriptInfo" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Smtp Port      : $SmtpPort" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Smtp Server    : $SmtpServer" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Title          : $Script:Title" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "To             : $To" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Use SSL        : $UseSSL" 4>$Null
		If($MSWORD -or $PDF)
		{
			Out-File -FilePath $SIFile -Append -InputObject "User Name      : $UserName" 4>$Null
		}
		Out-File -FilePath $SIFile -Append -InputObject "VIServerName   : $VIServerName" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "OS Detected    : $Script:RunningOS" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "PoSH version   : $($Host.Version)" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "PSCulture      : $PSCulture" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "PSUICulture    : $PSUICulture" 4>$Null
		If($MSWORD -or $PDF)
		{
			Out-File -FilePath $SIFile -Append -InputObject "Word language  : $Script:WordLanguageValue" 4>$Null
			Out-File -FilePath $SIFile -Append -InputObject "Word version   : $Script:WordProduct" 4>$Null
		}
		Out-File -FilePath $SIFile -Append -InputObject "" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Script start   : $Script:StartTime" 4>$Null
		Out-File -FilePath $SIFile -Append -InputObject "Elapsed time   : $Str" 4>$Null
	}

	#stop transcript logging
	If($Log -eq $True) 
	{
		If($Script:StartLog -eq $true) 
		{
			try 
			{
				Stop-Transcript | Out-Null
				Write-Verbose "$(Get-Date -Format G): $Script:LogPath is ready for use"
			} 
			catch 
			{
				Write-Verbose "$(Get-Date -Format G): Transcript/log stop failed"
			}
		}
	}
	$ErrorActionPreference = $SaveEAPreference
}
#endregion

#region email function
#region email function
Function SendEmail
{
	Param([array]$Attachments)
	Write-Verbose "$(Get-Date -Format G): Prepare to email"

	$emailAttachment = $Attachments
	$emailSubject = $Script:Title
	$emailBody = @"
Hello, <br />
<br />
$Script:Title is attached.

"@ 

	If($Dev)
	{
		Out-File -FilePath $Script:DevErrorFile -InputObject $error 4>$Null
	}

	$error.Clear()
	
	If($From -Like "anonymous@*")
	{
		#https://serverfault.com/questions/543052/sending-unauthenticated-mail-through-ms-exchange-with-powershell-windows-server
		$anonUsername = "anonymous"
		$anonPassword = ConvertTo-SecureString -String "anonymous" -AsPlainText -Force
		$anonCredentials = New-Object System.Management.Automation.PSCredential($anonUsername,$anonPassword)

		If($UseSSL)
		{
			Send-MailMessage -Attachments $emailAttachment -Body $emailBody -BodyAsHtml -From $From `
			-Port $SmtpPort -SmtpServer $SmtpServer -Subject $emailSubject -To $To `
			-UseSSL -credential $anonCredentials *>$Null 
		}
		Else
		{
			Send-MailMessage -Attachments $emailAttachment -Body $emailBody -BodyAsHtml -From $From `
			-Port $SmtpPort -SmtpServer $SmtpServer -Subject $emailSubject -To $To `
			-credential $anonCredentials *>$Null 
		}
		
		If($?)
		{
			Write-Verbose "$(Get-Date -Format G): Email successfully sent using anonymous credentials"
		}
		ElseIf(!$?)
		{
			$e = $error[0]

			Write-Verbose "$(Get-Date -Format G): Email was not sent:"
			Write-Warning "$(Get-Date): Exception: $e.Exception" 
		}
	}
	Else
	{
		If($UseSSL)
		{
			Write-Verbose "$(Get-Date -Format G): Trying to send email using current user's credentials with SSL"
			Send-MailMessage -Attachments $emailAttachment -Body $emailBody -BodyAsHtml -From $From `
			-Port $SmtpPort -SmtpServer $SmtpServer -Subject $emailSubject -To $To `
			-UseSSL *>$Null
		}
		Else
		{
			Write-Verbose  "$(Get-Date): Trying to send email using current user's credentials without SSL"
			Send-MailMessage -Attachments $emailAttachment -Body $emailBody -BodyAsHtml -From $From `
			-Port $SmtpPort -SmtpServer $SmtpServer -Subject $emailSubject -To $To *>$Null
		}

		If(!$?)
		{
			$e = $error[0]
			
			#error 5.7.57 is O365 and error 5.7.0 is gmail
			If($null -ne $e.Exception -and $e.Exception.ToString().Contains("5.7"))
			{
				#The server response was: 5.7.xx SMTP; Client was not authenticated to send anonymous mail during MAIL FROM
				Write-Verbose "$(Get-Date -Format G): Current user's credentials failed. Ask for usable credentials."

				If($Dev)
				{
					Out-File -FilePath $Script:DevErrorFile -InputObject $error -Append 4>$Null
				}

				$error.Clear()

				$emailCredentials = Get-Credential -UserName $From -Message "Enter the password to send email"

				If($UseSSL)
				{
					Send-MailMessage -Attachments $emailAttachment -Body $emailBody -BodyAsHtml -From $From `
					-Port $SmtpPort -SmtpServer $SmtpServer -Subject $emailSubject -To $To `
					-UseSSL -credential $emailCredentials *>$Null 
				}
				Else
				{
					Send-MailMessage -Attachments $emailAttachment -Body $emailBody -BodyAsHtml -From $From `
					-Port $SmtpPort -SmtpServer $SmtpServer -Subject $emailSubject -To $To `
					-credential $emailCredentials *>$Null 
				}

				If($?)
				{
					Write-Verbose "$(Get-Date -Format G): Email successfully sent using new credentials"
				}
				ElseIf(!$?)
				{
					$e = $error[0]

					Write-Verbose "$(Get-Date -Format G): Email was not sent:"
					Write-Warning "$(Get-Date): Exception: $e.Exception" 
				}
			}
			Else
			{
				Write-Verbose "$(Get-Date -Format G): Email was not sent:"
				Write-Warning "$(Get-Date): Exception: $e.Exception" 
			}
		}
	}
}
#endregion

#region script core
#Script begins

ProcessScriptSetup

#If(!($Import))
If(($Import -and $Full) -or !($Import)) #2.01 handle situation when using both import and full
{
	VISetup $VIServerName
}

SetGlobals

If($Export -eq $False)
{
	[string]$Script:Title = "VMware Inventory Report V2 - $VIServerName"
	SetFileNames "$($VIServerName)-Inventory V2"

	If($Issues)
	{
		ProcessSummary
		ProcessSnapIssues
		ProcessOpticalIssues
	}
	Else
	{
		ProcessSummary
		ProcessvCenter
		ProcessClusters
		ProcessResourcePools
		ProcessVMHosts
	}

	#Process full inventory
	If($Full)
	{
		ProcessDatastores
		ProcessHostNetworking
		ProcessStandardVSwitch
		ProcessVMKPorts
		ProcessVMPortGroups
		ProcessVirtualMachines
	}
	#endregion

	#region finish script
	Write-Verbose "$(Get-Date -Format G): Finishing up document"

	#end of document processing

	###Change the two lines below for your script###
	$AbstractTitle = "VMware Inventory Report V2"
	$SubjectTitle = "VMware vCenter Inventory Report V2"

	UpdateDocumentProperties $AbstractTitle $SubjectTitle

	If($ReportFooter)
	{
		OutputReportFooter
	}

	ProcessDocumentOutput
}
Else
{
	Write-Verbose "$(Get-Date -Format G): Finishing up Export"
}

#Disconnect from VCenter
#If(!($Import))
If(($Import -and $Full) -or !($Import)) #2.01 handle situation when using both import and full
{
	Write-Verbose "$(Get-Date -Format G):"
	Write-Verbose "$(Get-Date -Format G): Disconnecting from $VIServerName"
	Write-Verbose "$(Get-Date -Format G):"
	Disconnect-VIServer $VIServerName -Confirm:$False 4>$Null
	
	If($?)
	{
		Write-Host "$(Get-Date -Format G):"
		Write-Host "$(Get-Date -Format G): Disconnecting from $VIServerName WAS SUCCESSFUL" -ForegroundColor White -BackgroundColor Black
		Write-Host "$(Get-Date -Format G):"
	}
	Else
	{
		Write-Host "$(Get-Date -Format G):"
		Write-Host "$(Get-Date -Format G): Disconnecting from $VIServerName WAS NOT SUCCESSFUL" -ForegroundColor Red -BackgroundColor Black
		Write-Host "$(Get-Date -Format G):"
	}
}

ProcessScriptEnd
#endregion
# SIG # Begin signature block
# MIItUQYJKoZIhvcNAQcCoIItQjCCLT4CAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU9wqnoIoSkaIkIrg+7+Ee0wPM
# ibiggiaxMIIFjTCCBHWgAwIBAgIQDpsYjvnQLefv21DiCEAYWjANBgkqhkiG9w0B
# AQwFADBlMQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYD
# VQQLExB3d3cuZGlnaWNlcnQuY29tMSQwIgYDVQQDExtEaWdpQ2VydCBBc3N1cmVk
# IElEIFJvb3QgQ0EwHhcNMjIwODAxMDAwMDAwWhcNMzExMTA5MjM1OTU5WjBiMQsw
# CQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cu
# ZGlnaWNlcnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQw
# ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz
# 7MKnJS7JIT3yithZwuEppz1Yq3aaza57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS
# 5F/WBTxSD1Ifxp4VpX6+n6lXFllVcq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7
# bXHiLQwb7iDVySAdYyktzuxeTsiT+CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfI
# SKhmV1efVFiODCu3T6cw2Vbuyntd463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jH
# trHEtWoYOAMQjdjUN6QuBX2I9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14
# Ztk6MUSaM0C/CNdaSaTC5qmgZ92kJ7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2
# h4mXaXpI8OCiEhtmmnTK3kse5w5jrubU75KSOp493ADkRSWJtppEGSt+wJS00mFt
# 6zPZxd9LBADMfRyVw4/3IbKyEbe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPR
# iQfhvbfmQ6QYuKZ3AeEPlAwhHbJUKSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ER
# ElvlEFDrMcXKchYiCd98THU/Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4K
# Jpn15GkvmB0t9dmpsh3lGwIDAQABo4IBOjCCATYwDwYDVR0TAQH/BAUwAwEB/zAd
# BgNVHQ4EFgQU7NfjgtJxXWRM3y5nP+e6mK4cD08wHwYDVR0jBBgwFoAUReuir/SS
# y4IxLVGLp6chnfNtyA8wDgYDVR0PAQH/BAQDAgGGMHkGCCsGAQUFBwEBBG0wazAk
# BggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29tMEMGCCsGAQUFBzAC
# hjdodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vRGlnaUNlcnRBc3N1cmVkSURS
# b290Q0EuY3J0MEUGA1UdHwQ+MDwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0
# LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwEQYDVR0gBAowCDAGBgRV
# HSAAMA0GCSqGSIb3DQEBDAUAA4IBAQBwoL9DXFXnOF+go3QbPbYW1/e/Vwe9mqyh
# hyzshV6pGrsi+IcaaVQi7aSId229GhT0E0p6Ly23OO/0/4C5+KH38nLeJLxSA8hO
# 0Cre+i1Wz/n096wwepqLsl7Uz9FDRJtDIeuWcqFItJnLnU+nBgMTdydE1Od/6Fmo
# 8L8vC6bp8jQ87PcDx4eo0kxAGTVGamlUsLihVo7spNU96LHc/RzY9HdaXFSMb++h
# UD38dglohJ9vytsgjTVgHAIDyyCwrFigDkBjxZgiwbJZ9VVrzyerbHbObyMt9H5x
# aiNrIv8SuFQtJ37YOtnwtoeW/VvRXKwYw02fc7cBqZ9Xql4o4rmUMIIFkDCCA3ig
# AwIBAgIQBZsbV56OITLiOQe9p3d1XDANBgkqhkiG9w0BAQwFADBiMQswCQYDVQQG
# EwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNl
# cnQuY29tMSEwHwYDVQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwHhcNMTMw
# ODAxMTIwMDAwWhcNMzgwMTE1MTIwMDAwWjBiMQswCQYDVQQGEwJVUzEVMBMGA1UE
# ChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYD
# VQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQC/5pBzaN675F1KPDAiMGkz7MKnJS7JIT3yithZwuEppz1Y
# q3aaza57G4QNxDAf8xukOBbrVsaXbR2rsnnyyhHS5F/WBTxSD1Ifxp4VpX6+n6lX
# FllVcq9ok3DCsrp1mWpzMpTREEQQLt+C8weE5nQ7bXHiLQwb7iDVySAdYyktzuxe
# TsiT+CFhmzTrBcZe7FsavOvJz82sNEBfsXpm7nfISKhmV1efVFiODCu3T6cw2Vbu
# yntd463JT17lNecxy9qTXtyOj4DatpGYQJB5w3jHtrHEtWoYOAMQjdjUN6QuBX2I
# 9YI+EJFwq1WCQTLX2wRzKm6RAXwhTNS8rhsDdV14Ztk6MUSaM0C/CNdaSaTC5qmg
# Z92kJ7yhTzm1EVgX9yRcRo9k98FpiHaYdj1ZXUJ2h4mXaXpI8OCiEhtmmnTK3kse
# 5w5jrubU75KSOp493ADkRSWJtppEGSt+wJS00mFt6zPZxd9LBADMfRyVw4/3IbKy
# Ebe7f/LVjHAsQWCqsWMYRJUadmJ+9oCw++hkpjPRiQfhvbfmQ6QYuKZ3AeEPlAwh
# HbJUKSWJbOUOUlFHdL4mrLZBdd56rF+NP8m800ERElvlEFDrMcXKchYiCd98THU/
# Y+whX8QgUWtvsauGi0/C1kVfnSD8oR7FwI+isX4KJpn15GkvmB0t9dmpsh3lGwID
# AQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNVHQ4E
# FgQU7NfjgtJxXWRM3y5nP+e6mK4cD08wDQYJKoZIhvcNAQEMBQADggIBALth2X2p
# bL4XxJEbw6GiAI3jZGgPVs93rnD5/ZpKmbnJeFwMDF/k5hQpVgs2SV1EY+CtnJYY
# ZhsjDT156W1r1lT40jzBQ0CuHVD1UvyQO7uYmWlrx8GnqGikJ9yd+SeuMIW59mdN
# Oj6PWTkiU0TryF0Dyu1Qen1iIQqAyHNm0aAFYF/opbSnr6j3bTWcfFqK1qI4mfN4
# i/RN0iAL3gTujJtHgXINwBQy7zBZLq7gcfJW5GqXb5JQbZaNaHqasjYUegbyJLkJ
# EVDXCLG4iXqEI2FCKeWjzaIgQdfRnGTZ6iahixTXTBmyUEFxPT9NcCOGDErcgdLM
# MpSEDQgJlxxPwO5rIHQw0uA5NBCFIRUBCOhVMt5xSdkoF1BN5r5N0XWs0Mr7QbhD
# parTwwVETyw2m+L64kW4I1NsBm9nVX9GtUw/bihaeSbSpKhil9Ie4u1Ki7wb/UdK
# Dd9nZn6yW0HQO+T0O/QEY+nvwlQAUaCKKsnOeMzV6ocEGLPOr0mIr/OSmbaz5mEP
# 0oUA51Aa5BuVnRmhuZyxm7EAHu/QD09CbMkKvO5D+jpxpchNJqU1/YldvIViHTLS
# oCtU7ZpXwdv6EM8Zt4tKG48BtieVU+i2iW1bvGjUI+iLUaJW+fCmgKDWHrO8Dw9T
# dSmq6hN35N6MgSGtBxBHEa2HPQfRdbzP82Z+MIIGrjCCBJagAwIBAgIQBzY3tyRU
# fNhHrP0oZipeWzANBgkqhkiG9w0BAQsFADBiMQswCQYDVQQGEwJVUzEVMBMGA1UE
# ChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMSEwHwYD
# VQQDExhEaWdpQ2VydCBUcnVzdGVkIFJvb3QgRzQwHhcNMjIwMzIzMDAwMDAwWhcN
# MzcwMzIyMjM1OTU5WjBjMQswCQYDVQQGEwJVUzEXMBUGA1UEChMORGlnaUNlcnQs
# IEluYy4xOzA5BgNVBAMTMkRpZ2lDZXJ0IFRydXN0ZWQgRzQgUlNBNDA5NiBTSEEy
# NTYgVGltZVN0YW1waW5nIENBMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKC
# AgEAxoY1BkmzwT1ySVFVxyUDxPKRN6mXUaHW0oPRnkyibaCwzIP5WvYRoUQVQl+k
# iPNo+n3znIkLf50fng8zH1ATCyZzlm34V6gCff1DtITaEfFzsbPuK4CEiiIY3+va
# PcQXf6sZKz5C3GeO6lE98NZW1OcoLevTsbV15x8GZY2UKdPZ7Gnf2ZCHRgB720RB
# idx8ald68Dd5n12sy+iEZLRS8nZH92GDGd1ftFQLIWhuNyG7QKxfst5Kfc71ORJn
# 7w6lY2zkpsUdzTYNXNXmG6jBZHRAp8ByxbpOH7G1WE15/tePc5OsLDnipUjW8LAx
# E6lXKZYnLvWHpo9OdhVVJnCYJn+gGkcgQ+NDY4B7dW4nJZCYOjgRs/b2nuY7W+yB
# 3iIU2YIqx5K/oN7jPqJz+ucfWmyU8lKVEStYdEAoq3NDzt9KoRxrOMUp88qqlnNC
# aJ+2RrOdOqPVA+C/8KI8ykLcGEh/FDTP0kyr75s9/g64ZCr6dSgkQe1CvwWcZklS
# UPRR8zZJTYsg0ixXNXkrqPNFYLwjjVj33GHek/45wPmyMKVM1+mYSlg+0wOI/rOP
# 015LdhJRk8mMDDtbiiKowSYI+RQQEgN9XyO7ZONj4KbhPvbCdLI/Hgl27KtdRnXi
# YKNYCQEoAA6EVO7O6V3IXjASvUaetdN2udIOa5kM0jO0zbECAwEAAaOCAV0wggFZ
# MBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFLoW2W1NhS9zKXaaL3WMaiCP
# nshvMB8GA1UdIwQYMBaAFOzX44LScV1kTN8uZz/nupiuHA9PMA4GA1UdDwEB/wQE
# AwIBhjATBgNVHSUEDDAKBggrBgEFBQcDCDB3BggrBgEFBQcBAQRrMGkwJAYIKwYB
# BQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBBBggrBgEFBQcwAoY1aHR0
# cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1c3RlZFJvb3RHNC5j
# cnQwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0Rp
# Z2lDZXJ0VHJ1c3RlZFJvb3RHNC5jcmwwIAYDVR0gBBkwFzAIBgZngQwBBAIwCwYJ
# YIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4ICAQB9WY7Ak7ZvmKlEIgF+ZtbYIULh
# sBguEE0TzzBTzr8Y+8dQXeJLKftwig2qKWn8acHPHQfpPmDI2AvlXFvXbYf6hCAl
# NDFnzbYSlm/EUExiHQwIgqgWvalWzxVzjQEiJc6VaT9Hd/tydBTX/6tPiix6q4XN
# Q1/tYLaqT5Fmniye4Iqs5f2MvGQmh2ySvZ180HAKfO+ovHVPulr3qRCyXen/KFSJ
# 8NWKcXZl2szwcqMj+sAngkSumScbqyQeJsG33irr9p6xeZmBo1aGqwpFyd/EjaDn
# mPv7pp1yr8THwcFqcdnGE4AJxLafzYeHJLtPo0m5d2aR8XKc6UsCUqc3fpNTrDsd
# CEkPlM05et3/JWOZJyw9P2un8WbDQc1PtkCbISFA0LcTJM3cHXg65J6t5TRxktcm
# a+Q4c6umAU+9Pzt4rUyt+8SVe+0KXzM5h0F4ejjpnOHdI/0dKNPH+ejxmF/7K9h+
# 8kaddSweJywm228Vex4Ziza4k9Tm8heZWcpw8De/mADfIBZPJ/tgZxahZrrdVcA6
# KYawmKAr7ZVBtzrVFZgxtGIJDwq9gdkT/r+k0fNX2bwE+oLeMt8EifAAzV3C+dAj
# fwAL5HYCJtnwZXZCpimHCUcr5n8apIUP/JiW9lVUKx+A+sDyDivl1vupL0QVSucT
# Dh3bNzgaoSv27dZ8/DCCBrAwggSYoAMCAQICEAitQLJg0pxMn17Nqb2TrtkwDQYJ
# KoZIhvcNAQEMBQAwYjELMAkGA1UEBhMCVVMxFTATBgNVBAoTDERpZ2lDZXJ0IElu
# YzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTEhMB8GA1UEAxMYRGlnaUNlcnQg
# VHJ1c3RlZCBSb290IEc0MB4XDTIxMDQyOTAwMDAwMFoXDTM2MDQyODIzNTk1OVow
# aTELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMUEwPwYDVQQD
# EzhEaWdpQ2VydCBUcnVzdGVkIEc0IENvZGUgU2lnbmluZyBSU0E0MDk2IFNIQTM4
# NCAyMDIxIENBMTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANW0L0LQ
# KK14t13VOVkbsYhC9TOM6z2Bl3DFu8SFJjCfpI5o2Fz16zQkB+FLT9N4Q/QX1x7a
# +dLVZxpSTw6hV/yImcGRzIEDPk1wJGSzjeIIfTR9TIBXEmtDmpnyxTsf8u/LR1oT
# pkyzASAl8xDTi7L7CPCK4J0JwGWn+piASTWHPVEZ6JAheEUuoZ8s4RjCGszF7pNJ
# cEIyj/vG6hzzZWiRok1MghFIUmjeEL0UV13oGBNlxX+yT4UsSKRWhDXW+S6cqgAV
# 0Tf+GgaUwnzI6hsy5srC9KejAw50pa85tqtgEuPo1rn3MeHcreQYoNjBI0dHs6EP
# bqOrbZgGgxu3amct0r1EGpIQgY+wOwnXx5syWsL/amBUi0nBk+3htFzgb+sm+YzV
# svk4EObqzpH1vtP7b5NhNFy8k0UogzYqZihfsHPOiyYlBrKD1Fz2FRlM7WLgXjPy
# 6OjsCqewAyuRsjZ5vvetCB51pmXMu+NIUPN3kRr+21CiRshhWJj1fAIWPIMorTmG
# 7NS3DVPQ+EfmdTCN7DCTdhSmW0tddGFNPxKRdt6/WMtyEClB8NXFbSZ2aBFBE1ia
# 3CYrAfSJTVnbeM+BSj5AR1/JgVBzhRAjIVlgimRUwcwhGug4GXxmHM14OEUwmU//
# Y09Mu6oNCFNBfFg9R7P6tuyMMgkCzGw8DFYRAgMBAAGjggFZMIIBVTASBgNVHRMB
# Af8ECDAGAQH/AgEAMB0GA1UdDgQWBBRoN+Drtjv4XxGG+/5hewiIZfROQjAfBgNV
# HSMEGDAWgBTs1+OC0nFdZEzfLmc/57qYrhwPTzAOBgNVHQ8BAf8EBAMCAYYwEwYD
# VR0lBAwwCgYIKwYBBQUHAwMwdwYIKwYBBQUHAQEEazBpMCQGCCsGAQUFBzABhhho
# dHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQQYIKwYBBQUHMAKGNWh0dHA6Ly9jYWNl
# cnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRSb290RzQuY3J0MEMGA1Ud
# HwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRy
# dXN0ZWRSb290RzQuY3JsMBwGA1UdIAQVMBMwBwYFZ4EMAQMwCAYGZ4EMAQQBMA0G
# CSqGSIb3DQEBDAUAA4ICAQA6I0Q9jQh27o+8OpnTVuACGqX4SDTzLLbmdGb3lHKx
# AMqvbDAnExKekESfS/2eo3wm1Te8Ol1IbZXVP0n0J7sWgUVQ/Zy9toXgdn43ccsi
# 91qqkM/1k2rj6yDR1VB5iJqKisG2vaFIGH7c2IAaERkYzWGZgVb2yeN258TkG19D
# +D6U/3Y5PZ7Umc9K3SjrXyahlVhI1Rr+1yc//ZDRdobdHLBgXPMNqO7giaG9OeE4
# Ttpuuzad++UhU1rDyulq8aI+20O4M8hPOBSSmfXdzlRt2V0CFB9AM3wD4pWywiF1
# c1LLRtjENByipUuNzW92NyyFPxrOJukYvpAHsEN/lYgggnDwzMrv/Sk1XB+JOFX3
# N4qLCaHLC+kxGv8uGVw5ceG+nKcKBtYmZ7eS5k5f3nqsSc8upHSSrds8pJyGH+PB
# VhsrI/+PteqIe3Br5qC6/To/RabE6BaRUotBwEiES5ZNq0RA443wFSjO7fEYVgcq
# LxDEDAhkPDOPriiMPMuPiAsNvzv0zh57ju+168u38HcT5ucoP6wSrqUvImxB+YJc
# FWbMbA7KxYbD9iYzDAdLoNMHAmpqQDBISzSoUSC7rRuFCOJZDW3KBVAr6kocnqX9
# oKcfBnTn8tZSkP2vhUgh+Vc7tJwD7YZF9LRhbr9o4iZghurIr6n+lB3nYxs6hlZ4
# TjCCBsAwggSooAMCAQICEAxNaXJLlPo8Kko9KQeAPVowDQYJKoZIhvcNAQELBQAw
# YzELMAkGA1UEBhMCVVMxFzAVBgNVBAoTDkRpZ2lDZXJ0LCBJbmMuMTswOQYDVQQD
# EzJEaWdpQ2VydCBUcnVzdGVkIEc0IFJTQTQwOTYgU0hBMjU2IFRpbWVTdGFtcGlu
# ZyBDQTAeFw0yMjA5MjEwMDAwMDBaFw0zMzExMjEyMzU5NTlaMEYxCzAJBgNVBAYT
# AlVTMREwDwYDVQQKEwhEaWdpQ2VydDEkMCIGA1UEAxMbRGlnaUNlcnQgVGltZXN0
# YW1wIDIwMjIgLSAyMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAz+yl
# JjrGqfJru43BDZrboegUhXQzGias0BxVHh42bbySVQxh9J0Jdz0Vlggva2Sk/QaD
# FteRkjgcMQKW+3KxlzpVrzPsYYrppijbkGNcvYlT4DotjIdCriak5Lt4eLl6FuFW
# xsC6ZFO7KhbnUEi7iGkMiMbxvuAvfTuxylONQIMe58tySSgeTIAehVbnhe3yYbyq
# Ogd99qtu5Wbd4lz1L+2N1E2VhGjjgMtqedHSEJFGKes+JvK0jM1MuWbIu6pQOA3l
# jJRdGVq/9XtAbm8WqJqclUeGhXk+DF5mjBoKJL6cqtKctvdPbnjEKD+jHA9QBje6
# CNk1prUe2nhYHTno+EyREJZ+TeHdwq2lfvgtGx/sK0YYoxn2Off1wU9xLokDEaJL
# u5i/+k/kezbvBkTkVf826uV8MefzwlLE5hZ7Wn6lJXPbwGqZIS1j5Vn1TS+QHye3
# 0qsU5Thmh1EIa/tTQznQZPpWz+D0CuYUbWR4u5j9lMNzIfMvwi4g14Gs0/EH1OG9
# 2V1LbjGUKYvmQaRllMBY5eUuKZCmt2Fk+tkgbBhRYLqmgQ8JJVPxvzvpqwcOagc5
# YhnJ1oV/E9mNec9ixezhe7nMZxMHmsF47caIyLBuMnnHC1mDjcbu9Sx8e47LZInx
# scS451NeX1XSfRkpWQNO+l3qRXMchH7XzuLUOncCAwEAAaOCAYswggGHMA4GA1Ud
# DwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMI
# MCAGA1UdIAQZMBcwCAYGZ4EMAQQCMAsGCWCGSAGG/WwHATAfBgNVHSMEGDAWgBS6
# FtltTYUvcyl2mi91jGogj57IbzAdBgNVHQ4EFgQUYore0GH8jzEU7ZcLzT0qlBTf
# UpwwWgYDVR0fBFMwUTBPoE2gS4ZJaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0Rp
# Z2lDZXJ0VHJ1c3RlZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNybDCB
# kAYIKwYBBQUHAQEEgYMwgYAwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2lj
# ZXJ0LmNvbTBYBggrBgEFBQcwAoZMaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29t
# L0RpZ2lDZXJ0VHJ1c3RlZEc0UlNBNDA5NlNIQTI1NlRpbWVTdGFtcGluZ0NBLmNy
# dDANBgkqhkiG9w0BAQsFAAOCAgEAVaoqGvNG83hXNzD8deNP1oUj8fz5lTmbJeb3
# coqYw3fUZPwV+zbCSVEseIhjVQlGOQD8adTKmyn7oz/AyQCbEx2wmIncePLNfIXN
# U52vYuJhZqMUKkWHSphCK1D8G7WeCDAJ+uQt1wmJefkJ5ojOfRu4aqKbwVNgCeij
# uJ3XrR8cuOyYQfD2DoD75P/fnRCn6wC6X0qPGjpStOq/CUkVNTZZmg9U0rIbf35e
# Ca12VIp0bcrSBWcrduv/mLImlTgZiEQU5QpZomvnIj5EIdI/HMCb7XxIstiSDJFP
# PGaUr10CU+ue4p7k0x+GAWScAMLpWnR1DT3heYi/HAGXyRkjgNc2Wl+WFrFjDMZG
# QDvOXTXUWT5Dmhiuw8nLw/ubE19qtcfg8wXDWd8nYiveQclTuf80EGf2JjKYe/5c
# QpSBlIKdrAqLxksVStOYkEVgM4DgI974A6T2RUflzrgDQkfoQTZxd639ouiXdE4u
# 2h4djFrIHprVwvDGIqhPm73YHJpRxC+a9l+nJ5e6li6FV8Bg53hWf2rvwpWaSxEC
# yIKcyRoFfLpxtU56mWz06J7UWpjIn7+NuxhcQ/XQKujiYu54BNu90ftbCqhwfvCX
# hHjjCANdRyxjqCU4lwHSPzra5eX25pvcfizM/xdMTQCi2NYBDriL7ubgclWJLCcZ
# YfZ3AYwwggdeMIIFRqADAgECAhAFulYuS3p29y1ilWIrK5dmMA0GCSqGSIb3DQEB
# CwUAMGkxCzAJBgNVBAYTAlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8G
# A1UEAxM4RGlnaUNlcnQgVHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBT
# SEEzODQgMjAyMSBDQTEwHhcNMjExMjAxMDAwMDAwWhcNMjMxMjA3MjM1OTU5WjBj
# MQswCQYDVQQGEwJVUzESMBAGA1UECBMJVGVubmVzc2VlMRIwEAYDVQQHEwlUdWxs
# YWhvbWExFTATBgNVBAoTDENhcmwgV2Vic3RlcjEVMBMGA1UEAxMMQ2FybCBXZWJz
# dGVyMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA98Xfb+rSvcKK6oXU
# 0jjumwlQCG2EltgTWqBp3yIWVJvPgbbryZB0JNT3vWbZUOnqZxENFG/YxDdR88By
# ukOAeveRE1oeYNva7kbEpQ7vH9sTNiVFsglOQRtSyBch3353BZ51gIESO1sxW9dw
# 41rMdUw6AhxoMxwhX0RTV25mUVAadNzDEuZzTP3zXpWuoAeYpppe8yptyw8OR79A
# d83ttDPLr6o/SwXYH2EeaQu195FFq7Fn6Yp/kLYAgOrpJFJpRxd+b2kWxnOaF5RI
# /EcbLH+/20xTDOho3V7VGWTiRs18QNLb1u14wiBTUnHvLsLBT1g5fli4RhL7rknp
# 8DHksuISIIQVMWVfgFmgCsV9of4ymf4EmyzIJexXcdFHDw2x/bWFqXti/TPV8wYK
# lEaLa2MrSMH1Jrnqt/vcP/DP2IUJa4FayoY2l8wvGOLNjYvfQ6c6RThd1ju7d62r
# 9EJI8aPXPvcrlyZ3y6UH9tiuuPzsyNVnXKyDphJm5I57tLsN8LSBNVo+I227VZfX
# q3MUuhz0oyErzFeKnLsPB1afLLfBzCSeYWOMjWpLo+PufKgh0X8OCRSfq6Iigpj9
# q5KzjQ29L9BVnOJuWt49fwWFfmBOrcaR9QaN4gAHSY9+K7Tj3kUo0AHl66QaGWet
# R7XYTel+ydst/fzYBq6SafVOt1kCAwEAAaOCAgYwggICMB8GA1UdIwQYMBaAFGg3
# 4Ou2O/hfEYb7/mF7CIhl9E5CMB0GA1UdDgQWBBQ5WnsIlilu682kqvRMmUxb5DHu
# gTAOBgNVHQ8BAf8EBAMCB4AwEwYDVR0lBAwwCgYIKwYBBQUHAwMwgbUGA1UdHwSB
# rTCBqjBToFGgT4ZNaHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0VHJ1
# c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAyMUNBMS5jcmwwU6BRoE+G
# TWh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFRydXN0ZWRHNENvZGVT
# aWduaW5nUlNBNDA5NlNIQTM4NDIwMjFDQTEuY3JsMD4GA1UdIAQ3MDUwMwYGZ4EM
# AQQBMCkwJwYIKwYBBQUHAgEWG2h0dHA6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzCB
# lAYIKwYBBQUHAQEEgYcwgYQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2lj
# ZXJ0LmNvbTBcBggrBgEFBQcwAoZQaHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29t
# L0RpZ2lDZXJ0VHJ1c3RlZEc0Q29kZVNpZ25pbmdSU0E0MDk2U0hBMzg0MjAyMUNB
# MS5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAGcm1xuESCj6Y
# VIf55C/gtmnsRJWtf7zEyqUtXhYU+PMciHnjnUbOmuF1+jKTA6j9FN0Ktv33fVxt
# WQ+ZisNssZbfwaUd3goBQatFF2TmUc1KVsRUj/VU+uVPcL++tzaYkDydowhiP+9D
# IEOXOYxunjlwFppOGrk3edKRj8p7puv9sZZTdPiUHmJ1GvideoXTAJ1Db6Jmn6ee
# tnl4m6zx9CCDJF9z8KexKS1bSpJBbdKz71H1PlgI7Tu4ntLyyaRVOpan8XYWmu9k
# 35TOfHHl8Cvbg6itg0fIJgvqnLJ4Huc+y6o/zrvj6HrFSOK6XowdQLQshrMZ2ceT
# u8gVkZsKZtu0JeMpkbVKmKi/7RXIZdh9bn0NhzslioXEX+s70d60kntMsBAQX0Ar
# OpKmrqZZJuxNMGAIXpEwSTeyqu0ujZI9eE1AU7EcZsYkZawdyLmilZdw1qwEQlAv
# EqyjbjY81qtpkORAeJSpnPelUlyyQelJPLWFR0syKsUyROqg5OFXINxkHaJcuWLW
# RPFJOEooSWPEid4rHMftaG2gOPg35o7yPzzHd8Y9pCX2v55NYjLrjUkz9JCjQ/g0
# LiOo3a+yvot+7izsaJEs8SAdhG7RZ/fdsyv+SyyoEzsd1iO/mZ2DQ0rKaU/fiCXJ
# pvrNmEwg+pbeIOCOgS0x5pQ0dyMlBZoxggYKMIIGBgIBATB9MGkxCzAJBgNVBAYT
# AlVTMRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjFBMD8GA1UEAxM4RGlnaUNlcnQg
# VHJ1c3RlZCBHNCBDb2RlIFNpZ25pbmcgUlNBNDA5NiBTSEEzODQgMjAyMSBDQTEC
# EAW6Vi5Lenb3LWKVYisrl2YwCQYFKw4DAhoFAKBAMBkGCSqGSIb3DQEJAzEMBgor
# BgEEAYI3AgEEMCMGCSqGSIb3DQEJBDEWBBSuWnXxdzGARXS0NbLrQUVoyDu9mTAN
# BgkqhkiG9w0BAQEFAASCAgBLoaD6qo/85CFQaFkbVKaZxr4aAFTNsqsmjx4e1ab4
# /vn8k0EK2op7Pxr37g4vdv93hOx2ObN5h/lyePMc37WUo2cwkYfAxrdF7E39VyzW
# xHBk5Xb55eukzFPzACE7b1WAvM9jOXPm0sANwTBn7KD9mxCpJfdYFhK3tRQbOOmE
# THCE5KJf81qkDNarZNqIhWwR8JHxOyGmhF/QUmkLNtf1EGhMcgsfOwzvcdopcaSK
# l6ClKfMpMUwpcvV9AShuDnxpLey2jo+AC2PxeYDm9weraNQ+bU0+oQPV8cS0JpUS
# xt1eTIckPScsFkjFMaiMQov41YoidxIv4Dfk4UCsieAL3MZCYj3o+S+cR4kgeD0m
# 2jM+9rwM7xOJeUc6RqbNfHkqrAgUXOessihTKhHhuLNNyXApEzDaNREizwBmXpPy
# As3KFFwHB33+MrDZ2GegJCx0HaBuU80+E57x9OrMlJ9QRhZDlNXDJQ6gL4TDm+La
# 0gY2UCClWmhdIqCYEN64eo5AEFv4OtR6em4Wd3T36dDyrInxpdz8ZeL9FcNmeD+e
# mlrC5q/UPhM80E2xlWacghbZH4/OLN5kWt9nAH3ppz+7voJmAQRlHHqXx3aP8q+Q
# AW0KTvAE4DDsCmaS+yF7VuNhai13K/Ti7lb939Nh5gbiRUQDumkz1ghSdU2QnAXn
# S6GCAyAwggMcBgkqhkiG9w0BCQYxggMNMIIDCQIBATB3MGMxCzAJBgNVBAYTAlVT
# MRcwFQYDVQQKEw5EaWdpQ2VydCwgSW5jLjE7MDkGA1UEAxMyRGlnaUNlcnQgVHJ1
# c3RlZCBHNCBSU0E0MDk2IFNIQTI1NiBUaW1lU3RhbXBpbmcgQ0ECEAxNaXJLlPo8
# Kko9KQeAPVowDQYJYIZIAWUDBAIBBQCgaTAYBgkqhkiG9w0BCQMxCwYJKoZIhvcN
# AQcBMBwGCSqGSIb3DQEJBTEPFw0yMzA2MjQyMjM4MDJaMC8GCSqGSIb3DQEJBDEi
# BCDf4glicqI0j8zmX1+eh1pdxStLOkbpzC+gaTyS131jQzANBgkqhkiG9w0BAQEF
# AASCAgBmjRMY72lWu7GVRExgU4w5978624q3XO3j1dEIZoUHmeb5ylkAp9oR61mL
# EvwSr2EfSys7H+EoSoevmSho96qmmaEf2T7IAp/Wxoi1bZ3sFvWlDsqtPg2NrvSW
# iufBLfB/ntpgeL0SFyVTvjiio0yHG94CSDN/6/0cXrv5I8lGAxOpZAkEt7WGIGWW
# SMABBkQD0o70rVFh7zCH4Y7HR2o/CLLGq8H+v9Y4BHVXYuuLGiK3tmIIRYFw5raV
# nVb61DFv0P/tlYnztE8ze36xFk31ZRTWRQHFk+2U1atrSy4oXKzvuVKLJ6QctArN
# xCUk4tQ1zIFH9+WJprs0n5MiZfX2X7Hx0DhYsOKwB8o/ZTNYJyB3PjUakROQ0ixl
# QXnVCVXEFzuiykD22bcbkDopsOvW02FbYoBLiks68IajjBkYVE4G+dRc3tQa8lRl
# Pc+9m87rx2ffUqohp9KuHqQqmoYpfFAHUoZMHvcRIgPlt5CDSQ5T+EKHBy68gnA/
# Idp7D4sB6+7Qh6oytRh7zL/kcf7vT5vFqHOtXijp5KIh+dGIpOw8pwbO64TfkimK
# wK9MSUFKEHtxqjshaAjXK90UugzNNkHXRDnyy0k2u+yJKkuxiyMQpaxiOv1QlOmr
# CW8kdrdz46hUEw7m3ppWo/hWljhMGCwuTcU5ZpBG2AnzkxgyyQ==
# SIG # End signature block
