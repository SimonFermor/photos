<cfsetting requestTimeOut = "9000">

<!--- Read each line in the files.txt file and add a record in the table files 
      Need to update if existing --->
<cfscript>
    files = FileOpen("c:\temp\files.txt", "read");

    while (not fileiseof(files)) {
        line = FileReadLine(files);
        //WriteOutput("#line#");
        if (right(line, 4) != 'thumbnails') {
            path = right(line, len(line) -2);

            qoptions = { result="result", datasource="recipes"};
            query = queryexecute(
                "insert into photos.files 
                (path) 
                select (?) from dual
                where not exists (select id from photos.files where path = (?) limit 1);",
                [path, path], qoptions);
        }
    }
    fileClose(files);
</cfscript>

<!--- Show the number of rows in the table --->
<cfquery name="files" datasource="recipes">
    select count(id)
    from photos.files;
</cfquery>

<cfdump var="#files#">