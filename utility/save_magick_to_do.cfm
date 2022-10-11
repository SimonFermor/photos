<cfsetting requestTimeOut = "9000">
<cfinclude template="settings.inc">

<cfscript>
    qoptions = { result="result", datasource="recipes"};

    // Need to deal with other formats.  HEIC etc.
    image_files = queryexecute(
        "SELECT f.folder_path, f.name, f.extension
        FROM photos.files AS f

        -- JPG files (excluding thumbnails)
        left outer join
        (SELECT f1.folder_id, f1.name, 'HEIC' as extension
        from photos.files as f1
        where f1.folder_path not like '%thumbnails'
        and (f1.extension = 'JPG' or f1.extension = 'jpg')) AS a

        ON f.folder_id = a.folder_id
        AND f.name = a.name
        AND f.extension = a.extension

        -- There will be no jpg if file has not been converted
        where a.folder_id is null
        and f.extension = 'HEIC'
        limit 5000;",
        [], qoptions);

    output_file = FileOpen("#settings.folder##settings.files.magick_to_do#", "write");
    for (row in image_files) {
        file_base_path = "#settings.drive##settings.root_folder##image_files.folder_path#\#image_files.name#";
        fileWriteLine(output_file, "magick #file_base_path#.#image_files.extension# #file_base_path#.jpg");
    }
    fileWriteLine(output_file, "pause");
    fileClose(output_file);
</cfscript>
Done - completed writing magick_to_do.bat