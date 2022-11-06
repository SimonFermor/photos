<cfsetting requestTimeOut = "9000">
<cfinclude template="settings.inc">

<cfscript>
    qoptions = { result="result", datasource="recipes"};

    // Need to deal with other formats.  HEIC etc.
    image_files = queryexecute(
        "SELECT folder_path, name, extension
        FROM photos.files AS f1
        WHERE id NOT IN
        
        -- Files with corresponding file in the thumbnails folder            
        (SELECT id
        FROM photos.files AS f
            
        INNER JOIN 
            -- Thumbnail files with parent folder id
            (SELECT f2.parent_folder_id as folder_id, f1.NAME, f1.extension
            from photos.files as f1
            inner join photos.folders as f2
            on f1.folder_id = f2.id
            where f1.folder_path like '%thumbnails') AS t
            
        ON f.folder_id = t.folder_id
        AND f.name = t.name
        AND f.extension = t.extension)
        
        AND f1.folder_path NOT LIKE '%thumbnails'

        -- Ignore files with path or filename containing space
        and f1.folder_path not like '% %'
        and f1.name not like '% %'

        -- Only image files
        AND f1.extension IN ('PNG', 'TIF', 'JPG', 'JPEG', 'jpg')
        limit 5000;",
        [], qoptions);

    output_file = FileOpen("#settings.temp_folder#\#settings.files.thumbnails_to_do#", "write");
    for (row in image_files) {
        base_path = "#settings.drive##settings.root_folder#\#image_files.folder_path#";
        fileWriteLine(output_file, "#base_path#,#image_files.name#.#image_files.extension#");
    }
    fileClose(output_file);
</cfscript>
Done - created thumbnails_to_do.txt