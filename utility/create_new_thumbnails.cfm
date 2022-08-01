<cfsetting requestTimeOut = "9000">
Started at <cfoutput>#now()#</cfoutput>

<cfscript>
    // File with list of files to create thumbnails
    file_name = "C:\temp\thumbnails_to_do.txt";

    // Log file for converted files
    done_list = fileOpen("c:\temp\done_list.txt", "write");

    // Loop through file and write image thumbnails if not already exists
    cfloop(file="#file_name#", index="i", item="line") {
        folder = listgetat(line, 1,",");
        filename = listgetat(line, 2,",");
        source_path = folder & '\' & filename;
        destination_path = folder & '\thumbnails\' & filename;

        fileWriteLine(done_list, "#source_path#,#destination_path#");

        if (not fileExists("#destination_path#")) {
            photo = imageRead("#source_path#");
            imageScaleToFit(photo, 300, 300);
            imageWrite(photo, "#destination_path#", 0.75, false);
        }
    }

    fileClose(done_list);
</cfscript>
Done