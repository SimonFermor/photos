<cfinclude template="settings.inc">

<cfscript>
// Open file with list of folders
folders = FileOpen("#settings.folder##settings.files.folders_list#", "read");

// For each line in file, check and if necessary insert folder path
while (not fileiseof(folders)) {
    line = FileReadLine(folders);
    if (len(line) gt 2 ) {
        // Remove leading drive and : to find path
        path = right(line, len(line) -2);

        // Insert if path not found in photos.folders.path
        query = queryexecute(
            "insert into photos.folders 
            (path) 
            select :path from dual
            where not exists 
                (select id from photos.folders where path = :path limit 1);",
            { path={value=path} }, qoptions);
    }
}

fileClose(folders);

</cfscript>

<!--- How many folders? --->
<cfquery name="folders" datasource="recipes">
    select count(id) as folder_count
    from photos.folders;
</cfquery>

Total number of rows in folders table: <cfoutput>#folders.folder_count#</cfoutput>