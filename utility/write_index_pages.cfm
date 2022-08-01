<cfscript>
    utility = createObject( 'component', 'files.functions.utility' );

    result = invoke( utility, 'write_owner_index_pages', 
        { owner_name = '#owner_name#'} );
</cfscript>