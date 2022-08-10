Scripts and SQL for storing photo file details and generating html index pages

PowerShell command to generate folder and file listings:

    Get-ChildItem -Path I:\Photos -Recurse|  Where-Object {$_.GetType().Name -Like "DirectoryInfo"} | %{$_.FullName} > "d:\Google Drive\folders.txt"
    
    $format = @{Expression={$_.Name};Label="Name";width=60},`
          @{Expression={$_.Extension};Label="Extension";width=10},`
          @{Expression={$_.CreationTime.ToString("yyyy-mm-dd")};Label="CreationTime";width=25},`
          @{Expression={$_.FullName};Label="FullName";width=80}
          
    Get-ChildItem -Path I:\Photos -Recurse|  Where-Object {$_.GetType().Name -Like "FileInfo"} | Format-Table $format | Out-String -Width 300 | Out-File -Encoding utf8 "d:\Google Drive\files.txt"
    
Unix shell command to generate file listing:

     $ find $PWD > ../file_list.txt

Sources:

https://css-tricks.com/adaptive-photo-layout-with-flexbox/

https://codepen.io/markpraschan/pen/rNNByGG
