<!--- Extract and save folder name from full path --->

<!--- All folders --->
<cfquery name="folders" datasource="recipes">
  select id, path
  from photos.folders;
</cfquery>

<cfscript>
// https://stackoverflow.com/questions/9363145/regex-for-extracting-filename-from-path#9367263
//    writeDump ("(/(\w?\:?\\?[\w\-_\\]*\\+)([\w-_]+)(\.[\w-_]+)/gi)", set_names.path[3]);
//    test = REMatch("(^\\(.+)*\\(.+)$)", "#folders.path[3]#");
    for (row in folders) {
        folder_name = REMatch("([^\\]+)$", "#row.path#");
        //writeDump("#folder_name#");
        qoptions = { result="result", datasource="recipes"};
        query = queryexecute(
            "update photos.folders set `name` = (?) where id = (?)",
            [folder_name[1], row.id], qoptions);
    }
</cfscript>
Done