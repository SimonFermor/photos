component {

qoptions =  { result="result", datasource="recipes"};

// Write the start of the HTML file and the header
any function write_html_header(required string file_path) {
    var html_file = FileOpen("#file_path#", "write");
    fileWriteLine(html_file, "<html>");
    fileWriteLine(html_file, "  <head>");
    fileWriteLine(html_file, "    <link rel='stylesheet' href='https://cdn.jsdelivr.net/gh/fancyapps/fancybox@3.5.7/dist/jquery.fancybox.min.css' />");
    fileWriteLine(html_file, "    <link rel='stylesheet' href='../assets/styles/styles.css'>");
    fileWriteLine(html_file, "    <script  src='https://css-tricks.com/wp-content/themes/CSS-Tricks-19/js/min/jquery-3.5.1.min.js' id='jquery-js'></script>");
    fileWriteLine(html_file, "    <script  src='https://cdnjs.cloudflare.com/ajax/libs/fancybox/3.5.7/jquery.fancybox.min.js'></script>");
    fileWriteLine(html_file, "  </head>");
    fileWriteLine(html_file, "  <body>");
    fileClose(html_file);
}

// Write the end of the file
any function write_html_footer(required string file_path) {
    var html_file = FileOpen("#file_path#", "append");
    fileWriteLine(html_file, "  </body>");
    fileWriteLine(html_file, "</html>");
    fileClose(html_file);
}

// Write all collection index pages
remote any function write_all_collection_pages() {

    // Find all collections
    collections = queryexecute(
        "select c.name, c.start_at, c.end_at, c.description
        from photos.collections as c;",
        [], qoptions);

    // For each collection write the index page
    for (collection in collections) {
        write_collection_pages(collection.collection_id);
    }

    return collections;
}

// Write one collection index pages
remote any function write_collection_pages(collection_id) {
    write_html_header("#settings.index_folder#\collections\index.html");

    // Photo files for one collection - using date range as criteria
    files = queryexecute(
        "SELECT f.id, f.folder_path, f.name, f.extension
        FROM photos.files as f
        WHERE f.created_at > (SELECT start_at FROM photos.collections WHERE id = :collection_id)
        AND f.created_at < (SELECT end_at FROM photos.collections WHERE id = :collection_id)
        AND f.hide = 0;", 
        {collection_id = {value="#collection_id#"}}, qoptions);

    // Start the collection HTML file
    file_path = "#settings.index_folder#\collections\" & collection_id & ".html";
    write_html_header(file_path);

    index_file = FileOpen("#file_path#", "append");
    fileWriteLine(index_file, "            <ul class='gallery'>");

    // Write the links / img for each photo in the collection
    for (photo in files) {
        parent_folder_path = replace(photo.folder_path, "\", "/", "All");
        fileWriteLine(index_file, "            <li><a href='../../..#parent_folder_path#/#photo.name#.#photo.extension#' data-fancybox data-fancybox='gallery'>");
        fileWriteLine(index_file, "                <img src='../../..#parent_folder_path#/thumbnails/#photo.name#.#photo.extension#'></a></li>");
    }
    fileWriteLine(index_file, '<li></li>');
    
    // Finish the file
    write_html_footer(file_path);

    return files;
}

remote any function write_owner_index_pages(required string owner_name) {
    var file_path = "";

    // Create file and write html header
    var main_index_path = "#settings.index_folder#\#owner_name#\index.html";
    write_html_header(main_index_path);

    // Open file for adding links
    main_index_file = FileOpen("#main_index_path#", "append");
    fileWriteLine(main_index_file, "<ul>");

    // Find thumbnail folders for owner_name (only generate index page if there are thumbnails)
    folders = queryexecute(
        "select distinct folder_id, folder_path
        from photos.files
        where folder_path like '%#owner_name#%'
        and folder_path like '%thumbnails'
        order by folder_path;",
        [], qoptions);

        for (folder in folders) {
            // Add a line to the top level index for the folder file
            folder_path = right(folder.folder_path, len(folder.folder_path) - 9 - len(owner_name));
            fileWriteLine(main_index_file, "<li><a href='folder_#folder.folder_id#.html'
                >#left(folder_path, len(folder_path) - 11)#</a></li>");

            // Open folder index file and write header
            var file_path = "#settings.index_folder#\#owner_name#\folder_#folder.folder_id#.html";
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