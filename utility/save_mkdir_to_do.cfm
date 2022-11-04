<cfsetting requestTimeOut = "9000">
<cfinclude template="settings.inc">

<cfscript>
    bat_file_path = "#settings.temp_folder#\#settings.files.mkdir_to_do#";

    // Find paths for folder where there are image files and no corresponding thumbnails folder
    image_folders = queryexecute(
        "SELECT DISTINCT concat(f.path, '\\thumbnails') AS thumbnails_folder_path
        FROM photos.folders AS f
        
        INNER JOIN photos.files AS g
        ON f.id = g.folder_id
        
        WHERE f.NAME != 'thumbnails'
        AND f.thumbnail_folder_id IS NULL
        AND f.name NOT LIKE '% %'
        AND g.extension IN ('HEIC','PNG', 'TIF', 'JPG', 'JPEG', 'jpg');",
        [], qoptions);

    output_file = FileOpen("#bat_file_path#", "write");

    for (row in image_folders) {
        fileWriteLine(output_file, "mkdir #settings.drive##settings.root_folder##image_folders.thumbnails_folder_path#");
    }

    fileWriteLine(output_file, "pause");
    fileClose(output_file);

</cfscript>
Done - see file <cfoutput>#bat_file_path#</cfoutput>