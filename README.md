Scripts and SQL for storing photo file details and generating html index pages

PowerShell command to generate folder and file listings:

    Get-ChildItem -Path I:\Photos -Recurse|  Where-Object {$_.GetType().Name -Like "DirectoryInfo"} | %{$_.FullName} > "d:\Google Drive\folders.txt"
    
    Get-ChildItem -Path I:\Photos -Recurse|  Where-Object {$_.GetType().Name -Like "FileInfo"} | Select-Object -Property Name, Extension, CreationTime, FullName > "d:\Google Drive\files.txt"
    
Unix shell command to generate file listing:

     $ find $PWD > ../file_list.txt

Sources:

https://css-tricks.com/adaptive-photo-layout-with-flexbox/

https://codepen.io/markpraschan/pen/rNNByGG
