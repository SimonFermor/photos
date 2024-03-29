<cfsetting requestTimeOut = "9000">
<cfinclude template="settings.inc">

<!--- 
    Read each line in the files.txt file and add a record in the table files_import 
--->
<cfscript>
    files = FileOpen("#settings.temp_folder#\#settings.files.files_list#", "read");
    counter = 0;
    
    // Truncate temporary table used for import
    queryexecute("truncate table photos.files_import;", [], qoptions);

    // Import all files into files_import table
    while (not fileiseof(files)) {
        counter += 1;
        line = FileReadLine(files);
        // WriteOutput("#line#<br>");  // Debug
        if (right(line, 10) != 'thumbnails') {
            extension = trim(mid(line, 63, 10));
            name = trim(left(line, 60));
            created_at = trim(mid(line, 73, 20));
            path = trim(mid(line, 99, 200));
            //WriteOutput("name: #name#, extension: #extension#, creation_time: #created_at#, path: #path#<br />");

            if (name neq "Name" and name neq "----" and len(extension) gt 2) {
                // Remove extension from name
                name = left(name, len(name) - len(extension) - 1);

                // Remove leading drive letter and filename from end
                base_length = len(settings.drive) + len(settings.root_folder) + 2;
                folder_path = mid(path, base_length, len(path) - len(name) - len(extension) - base_length - 1);

                // Insert new file details
                query = queryexecute(
                    "insert into photos.files_import
                    (path, folder_path, name, extension, created_at)
                    values
                    (:path, :folder_path, :name, :extension, :created_at);",
                    { path={value=path}, folder_path={value=folder_path}, 
                      name={value=name}, extension={value=extension}, 
                      created_at={value=created_at}}, qoptions);
            }
        }
    }

    fileClose(files);

    // Set folder ID for imported files
    // If there are problems, check that folder ID is being set correctly
    query = queryexecute(
        "UPDATE photos.files_import AS f1
        INNER JOIN photos.folders AS f2
        ON (f1.folder_path = f2.path)
        SET f1.folder_id = f2.id
        WHERE f1.folder_id IS NULL;", [], qoptions
    );

    // Set create date time for file from import - for files previously imported
    // This fix will not be required in future
    query = queryexecute(
        "UPDATE photos.files AS f1
        INNER JOIN photos.files_import AS f2
        ON (f1.folder_id = f2.folder_id and f1.name = f2.name and f1.extension = f2.extension)
        SET f1.created_at = f2.created_at
        WHERE f1.created_at IS NULL;", [], qoptions
    );

    // Import new files - where file is in file_import table and not in photos.files table
    query = queryexecute(
        "INSERT INTO photos.files
        (path, folder_path, name, extension, folder_id, created_at)
        
        SELECT i.path, i.folder_path, i.name, i.extension, i.folder_id, i.created_at
        FROM photos.files_import AS i

        left JOIN photos.files AS f
        ON i.folder_id = f.folder_id
        AND i.name = f.name
        AND i.extension = f.extension

        WHERE f.name IS NULL;", [], qoptions
    );

    // Check for files not added - for example folder paths with a space
    not_added = queryexecute(
        "SELECT i.path, i.folder_path, i.name, i.extension, i.folder_id, i.created_at
            -- f.*
        FROM photos.files_import AS i

        left JOIN photos.files AS f
        ON i.folder_id = f.folder_id
        AND i.name = f.name
        AND i.extension = f.extension
        
        WHERE f.name IS NULL;", [], qoptions);

</cfscript>

Files not imported correctly:
<cfdump var="#not_added#">

<!--- Show the number of rows in the table --->
<cfquery name="import_count" datasource="recipes">
    select count(id) as file_count
    from photos.files_import;
</cfquery>

<cfdump var="#import_count#">