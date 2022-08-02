<cfsetting requestTimeOut = "9000">

<cfscript>
    var bat_file_path = "c:\temp\mkdir_to_do.bat";

    qoptions = { result="result", datasource="recipes"};

    // Find folders for files where there are missing thumbnails
    image_folders = queryexecute(
        "SELECT DISTINCT `folder_path`
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
        AND f1.extension IN ('HEIC','PNG', 'TIF', 'JPG', 'JPEG')
        limit 5000;",
        [], qoptions);

    output_file = FileOpen("#bat_file_path#", "write");
    for (row in image_folders) {
        fileWriteLine(output_file, "mkdir I:#image_folders.folder_path#\thumbnails");
    }
    fileClose(output_file);

</cfscript>
Done - see file <cfoutput>#bat_file_path#</cfoutput>