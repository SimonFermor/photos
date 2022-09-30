<!--- Extract and save folder name from full path --->

<cfinclude template="settings.inc">

<!--- Find folders where name has not been set --->
<cfquery name="folders" datasource="recipes">
  select id, path
  from photos.folders
  where name is null;
</cfquery>

<cfscript>
  // https://stackoverflow.com/questions/9363145/regex-for-extracting-filename-from-path#9367263
  //    writeDump ("(/(\w?\:?\\?[\w\-_\\]*\\+)([\w-_]+)(\.[\w-_]+)/gi)", set_names.path[3]);
  //    test = REMatch("(^\\(.+)*\\(.+)$)", "#folders.path[3]#");

  // For each folder, set the name
  for (row in folders) {
    // Find the last part of the path, string after last \
    folder_name = REMatch("([^\\]+)$", "#row.path#");

    query = queryexecute(
      "update photos.folders 
      set name = (:folder_name) 
      where id = (:id)",
      // Folder name is first (and only) match
      { folder_name={value=folder_name[1]}, id={value=row.id} }, qoptions);
  }

  // Insert parent folder if not found
  // Parent path is LEFT(f2.path, LENGTH(f2.path) - LENGTH(f2.NAME) - 1)
  query = queryexecute(
    "INSERT INTO photos.folders
    (path)

    SELECT distinct LEFT(f2.path, LENGTH(f2.path) - LENGTH(f2.name) - 1) AS path
    FROM photos.folders AS f2

    LEFT JOIN photos.folders AS f1
    ON f1.path = LEFT(f2.path, LENGTH(f2.path) - LENGTH(f2.name) - 1)

    WHERE f1.path IS NULL;",
    [], qoptions);

  // Set parent folder ID for folder
  query =queryexecute(
    "UPDATE photos.folders AS f1

    inner JOIN photos.folders AS f2
    ON f2.path = LEFT(f1.path, LENGTH(f1.path) - LENGTH(f1.NAME) - 1)

    SET f1.parent_folder_id = f2.id

    WHERE f1.parent_folder_id IS NULL;",
    [], qoptions);

  // Set thumbnail folder ID
  query = queryexecute(
    "UPDATE photos.folders AS f1

    inner JOIN photos.folders AS f2
    ON f2.path = CONCAT(f1.path, '\\thumbnails')

    SET f1.thumbnail_folder_id = f2.id
    
    WHERE f1.thumbnail_folder_id IS NULL;",
    [], qoptions);

</cfscript>

Done - set folder names and inserted parent folders