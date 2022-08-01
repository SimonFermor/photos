<cfsetting requestTimeOut = "9000">

<!--- Read each line in the server_files.txt file and add a record in the table server_files 
      Need to update if existing --->
<cfscript>
    files = FileOpen("c:\temp\server_files.txt", "read");

    while (not fileiseof(files)) {
        line = FileReadLine(files);
        if (right(line, 4) != 'thumbnails') {
            path = replace("\P" & right(line, len(line) -40), "/", "\", "all");
            qoptions = { result="result", datasource="recipes"};
            query = queryexecute(
                "insert into photos.server_files 
                (path) 
                select (?) from dual
                where not exists (select id from photos.server_files where path = (?) limit 1);",
                [path, path], qoptions);
        }
    }
    fileClose(files);
</cfscript>

<!--- Show the number of rows in the table --->
<cfquery name="files" datasource="recipes">
    select count(id)
    from photos.server_files;
</cfquery>

<cfdump var="#files#">