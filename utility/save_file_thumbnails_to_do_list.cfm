<cfsetting requestTimeOut = "9000">
<cfinclude template="settings.inc">

<cfscript>
    qoptions = { result="result", datasource="recipes"};

    // Need to deal with other formats.  HEIC etc.
    image_files = queryexecute(
        "SELECT `folder_path`, `name`, `extension`
        FROM photos.files AS f1
        WHERE id NOT IN
        
            (SELECT id
            FROM photos.files AS f
            
            INNER JOIN 
            
            (SELECT LEFT(folder_path, LENGTH(folder_path) - 11) AS folder_path, NAME, extension
            from photos.files as f
            where f.folder_path like '%thumbnails') AS t
            
            ON f.folder_path = t.folder_path
            AND f.name = t.name
            AND f.extension = t.extension)
        
        AND f1.folder_path NOT LIKE '%thumbnails'
        AND f1.extension IN ('PNG', 'TIF', 'JPG', 'JPEG')
        limit 5000;",
        [], qoptions);

    output_file = FileOpen("#settings.folder##settings.files.thumbnails_to_do#", "write");
    for (row in image_files) {
        fileWriteLine(output_file, "#settings.drive##image_files.folder_path#,#image_files.name#.#image_files.extension#");
    }
    fileClose(output_file);
</cfscript>
Done - created thumbnails_to_do.txt