<cfinclude template="settings.inc">

<cfscript>
    utility = createObject( 'component', 'photos.utility.utility' );

    // Find photographer folder names from photographers table
    photographers = queryexecute(
        "select folder
        from photos.photographers;",
        [], qoptions);

    // For each photographer, write html index pages
    for (photographer in photographers) {
        result = invoke( utility, 'write_owner_index_pages', 
            { owner_name = '#photographer.folder#'} );
    }
</cfscript>

Folders updated:
<cfdump var="#photographers#">