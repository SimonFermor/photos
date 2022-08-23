<cfsetting requestTimeOut = "9000">
<cfinclude template="settings.inc">

<cfscript>
    bat_file_path = "#settings.folder##settings.files.mkdir_to_do#";

    // Find folders for files where there are missing thumbnails

    set thumbnail_folder_id in folders table
    then check for folders with files and no thumbnail folder

    image_folders = queryexecute(
        "SELECT DISTINCT `folder_path`
        FROM photos.files AS f1
        WHERE id NOT IN

        *** update this query

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

    fileWriteLine(output_file, "pause");
    fileClose(output_file);

</cfscript>
Done - see file <cfoutput>#bat_file_path#</cfoutput>