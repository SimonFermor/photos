<!--- Extract and save folder name from full path --->

<cfinclude template="settings.inc">

<!--- Find new files - folder has not yet been set --->
<cfquery name="files" datasource="recipes">
  select id, path
  from photos.files
  where folder_path is null;
</cfquery>

Files where folder_path is null: <cfoutput>#files.recordCount#</cfoutput>

<!--- For each file, set folder_path, name and extension --->
<cfscript>
    for (row in files) {
        full_name = REMatch("([^\\]+)$", "#row.path#");
        filename = left(full_name[1], find(".", full_name[1]) -1);
        extension = right(full_name[1], len(full_name[1]) - len(filename) -1);
        folder_path = (left(row.path, len(row.path) - len(full_name[1]) -1) );

        query = queryexecute(
          "update photos.files 
          set folder_path = :folder_path,
            name = :filename, 
            extension = :extension
          where id = :row_id;",
          {folder_path={value=folder_path}, filename={value=filename}, 
          extension={value=extension}, row_id={value=row.id}}, qoptions);
    }
</cfscript>

<!--- For each file set folder id --->
<cfquery name="set_folder_ids" datasource="recipes">
  UPDATE photos.files AS f1

  INNER JOIN photos.folders AS f2
  ON (f1.folder_path = f2.path)

  SET f1.folder_id = f2.id
  WHERE f1.folder_id IS NULL;
</cfquery>

<br />
Done - set name, extension, folder_path, folder_id