<cfsetting requestTimeOut = "9000">
<cfinclude template="settings.inc">

<cfscript>
    qoptions = { result="result", datasource="recipes"};

    // Need to deal with other formats.  HEIC etc.
    image_files = queryexecute(
        "SELECT f.folder_path, f.name, f.extension
        FROM photos.files AS f
        left outer join

        (SELECT f2.parent_folder_id, f1.name, 'HEIC' as extension
        from photos.files as f1

        inner join photos.folders as f2
        on f1.folder_id = f2.id

        where f1.folder_path like '%thumbnails'
        and f1.extension = 'JPG') AS a

        ON f.folder_id = a.parent_folder_id
        AND f.name = a.name
        AND f.extension = a.extension

        where a.parent_folder_id is null
        and f.extension = 'HEIC'
        limit 5000;",
        [], qoptions);

    output_file = FileOpen("#settings.folder##settings.files.magick_to_do#", "write");
    for (row in image_files) {
        fileWriteLine(output_file, "magick #settings.drive##image_files.folder_path#\#image_files.name#.#image_files.extension# #settings.drive##image_files.folder_path#\#image_files.name#.jpg");
    }
    fileWriteLine(output_file, "pause");
    fileClose(output_file);
</cfscript>
Done - completed writing magick_to_do.bat