#this function will call other functions.
#1) use switch to choose a function.
#2) parameter $outputfileForSurvy is used by surveyfun.
#3) parameter $dirToHash and $outputfileForHash is used by hashdir.
#4) parameter $dirToMove and $MoveTo is used by moveDirContenet. 
# eg. ( DoEveryThingBro -MoveFiles -dirForMove "C:\Users\mrashed\Desktop\Google_files" -MoveTo "C:\Users\mrashed\Desktop\bashfinal" ).
#**** please becarefull there are no default vlues for these parameters.
function DoEveryThingBro{
param(
[switch]$survey,
[switch]$hash,
[switch]$MoveFiles,
[parameter(ParameterSetName='survey')]$outputfileForSurvy,
[parameter(ParameterSetName='hash')]$dirToHash,
[parameter(ParameterSetName='hash')]$outputfileForHash,
[parameter(ParameterSetName='move')]$dirForMove,
[parameter(ParameterSetName='move')]$MoveTo

)
if ($survey){

surveyfun $outputfileForSurvy

}

if ($hash){

hashdir $dirToHash $outputfileForHash
}
if($MoveFiles){

moveDirContenet $dirForMove $MoveTo

}




}
#this function will print system information, Date, Processes and open connections(along with ports) to a file.
function surveyfun {
param ([parameter(Mandatory=$true)]$file)

systeminfo > $file
date >> $file
Get-Process | Sort-Object -Property "SI" >> $file
netstat -ano >> $file
}
#this function will hash anyfilese within a directory or hash a single file if you give it the path (eg. c"\...\Powerhorse.txt).
#then it will ask if you want to keep track the directory changes
function hashdir {
param([parameter(Mandatory=$true)] $dir,
      [parameter(Mandatory=$true)]$outputfile)

Get-ChildItem -Path $dir -Recurse | Get-FileHash > $outputfile
echo "Your Directory Has Been Hashed"
echo "Do You Want To keep tarcking for anyChanges in this directory?"
echo "please enter a number."
echo "[Yes]=1       [No]=2"
$choice = Read-Host
if ($choice -eq "1"){
keepTrack $dir $outputfile
}

}
#this function will move all the content of a directory to another directory using a loop.
function moveDirContenet {
param(
[parameter(Mandatory=$true)]$dir,
[parameter(Mandatory=$true)]$MoveTo)

Get-ChildItem -Path $dir | foreach { Move-Item -Path $_.FullName -Destination $MoveTo }

}
function keepTrack {
param([parameter(Mandatory=$true)] $dir,
      [parameter(Mandatory=$true)]$outputfile)
while($true){
Get-ChildItem -Path $dir -Recurse | Get-FileHash > "check.txt"
$old =[string] $(Get-Content $outputfile)
$new =[string] $(Get-Content "check.txt")
$equal = $old -eq $new
if (-not $equal){
echo "Directory Changed!"
$new | Out-File $outputfile

}
sleep 10
}

}



