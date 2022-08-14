<cfinclude template="settings.inc">

<cfscript>
    folders = FileOpen("#settings.folder##settings.files.folders_list#", "read");

    while (not fileiseof(folders)) {
        line = FileReadLine(folders);
        //WriteOutput("#line#");
        path = right(line, len(line) -2);

        qoptions = { result="result", datasource="recipes"};
        query = queryexecute(
            "insert into photos.folders 
            (path) 
            select (?) from dual
            where not exists (select id from photos.folders where path = (?) limit 1);",
            [path, path], qoptions);
        }
    fileClose(folders);
</cfscript>

<!--- How many folders? --->
<cfquery name="folders" datasource="recipes">
    select count(id)
    from photos.folders;
</cfquery>

Count of rows in folders table
<cfdump var="#folders#">