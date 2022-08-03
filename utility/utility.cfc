component {

any function write_html_header(required string file_path) {
    var html_file = FileOpen("#file_path#", "write");
    fileWriteLine(html_file, "<html>");
    fileWriteLine(html_file, "  <head>");
    fileWriteLine(html_file, "    <link rel='stylesheet' href='https://cdn.jsdelivr.net/gh/fancyapps/fancybox@3.5.7/dist/jquery.fancybox.min.css' />");
    fileWriteLine(html_file, "    <link rel='stylesheet' href='../styles.css'>");
    fileWriteLine(html_file, "    <script  src='https://css-tricks.com/wp-content/themes/CSS-Tricks-19/js/min/jquery-3.5.1.min.js' id='jquery-js'></script>");
    fileWriteLine(html_file, "    <script  src='https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.7/jquery.fancybox.min.js'></script>");
    fileWriteLine(html_file, "  </head>");
    fileWriteLine(html_file, "  <body>");
    fileClose(html_file);
}

any function write_html_footer(required string file_path) {
    var html_file = FileOpen("#file_path#", "append");
    fileWriteLine(html_file, "  </body>");
    fileWriteLine(html_file, "</html>");
    fileClose(html_file);
}

remote any function write_owner_index_pages(required string owner_name) {
    var file_path = "";

    // Create file and write html header
    var main_index_path = "c:\temp\photos\site\#owner_name#\index.html";
    write_html_header(main_index_path);

    // Open file for adding links
    main_index_file = FileOpen("#main_index_path#", "append");
    fileWriteLine(main_index_file, "<ul>");

    // Find thumbnail folders for owner_name (only generate index page if there are thumbnails)
    qoptions = { result="result", datasource="recipes"};
    folders = queryexecute(
        "select distinct folder_id, folder_path
        from photos.files
        where folder_path like '%#owner_name#%'
        and folder_path like '%thumbnails';",
        [], qoptions);

        for (folder in folders) {
            // Add a line to the top level index for the folder file
            folder_path = right(folder.folder_path, len(folder.folder_path) - 9 - len(owner_name));
            fileWriteLine(main_index_file, "<li><a href='folder_#folder.folder_id#.html'
                >#left(folder_path, len(folder_path) - 11)#</a></li>");

            // Open folder index file and write header
            var file_path = "c:\temp\photos\site\#owner_name#\folder_#folder.folder_id#.html";
            write_html_header(file_path);
            
            index_file = FileOpen("#file_path#", "append");
            fileWriteLine(index_file, "            <ul class='gallery'>");

            qoptions = { result="result", datasource="recipes"};
            files = queryexecute(
                "select id, folder_path, name, extension
                from photos.files
                where folder_id = (?);",
                [folder.folder_id], qoptions);

            for (photo in files) {
                parent_folder_path = replace(left(photo.folder_path, len(photo.folder_path) - 11), "\", "/", "All");
                parent_folder_path = right(parent_folder_path, len(parent_folder_path) - 7);
                fileWriteLine(index_file, "            <li><a href='../..#parent_folder_path#/#photo.name#.#photo.extension#' data-fancybox data-fancybox='gallery'>");
                fileWriteLine(index_file, "                <img src='../..#parent_folder_path#/thumbnails/#photo.name#.#photo.extension#'></a></li>");
            }
            fileWriteLine(index_file, "        </ul>");
            fileClose(index_file);
            write_html_footer(file_path);
        }

        fileWriteLine(main_index_file, "</ul>");
        fileClose(main_index_file);
        write_html_footer(main_index_path);
        
        return folders;
}

}