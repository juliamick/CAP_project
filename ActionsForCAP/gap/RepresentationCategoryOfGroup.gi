############################################################################
##
##                                ActionsForCAP package
##
##  Copyright 2016, Sebastian Gutsche, TU Kaiserslautern
##                  Sebastian Posur,   RWTH Aachen
##
#! @Chapter Semisimple Categories
##
#############################################################################

####################################
##
## Constructors
##
####################################

InstallMethod( RepresentationCategory,
               [ IsInt, IsInt ],
               
  function( order, group_nr )
    local databasekeys_filename, stream, command, database_keys, group_string, group_data, group;
    
    databasekeys_filename := 
      Concatenation( PackageInfo( "ActionsForCAP" )[1].InstallationPath, "/gap/AssociatorsDatabase/DatabaseKeys.g" );
    
    stream := InputTextFile( databasekeys_filename );
    
    command := ReadAll( stream );
    
    database_keys := EvalString( command );
    
    group_string := Concatenation( String( order ), ", ", String( group_nr ) );
    
    group_data := First( database_keys, entry -> entry[1] = group_string );
    
    if group_data = fail then
        
        Error( "The associator of ", group_string, " has not been computed yet" );
        
        return;
        
    fi;
    
    group := SmallGroup( order, group_nr );
    
    return RepresentationCategory( group, group_data );
    
end );

InstallMethod( RepresentationCategory,
               [ IsGroup ],
               
  function( group )
    local databasekeys_filename, stream, command, database_keys, group_string, group_data;
    
    databasekeys_filename := 
      Concatenation( PackageInfo( "ActionsForCAP" )[1].InstallationPath, "/gap/AssociatorsDatabase/DatabaseKeys.g" );
    
    stream := InputTextFile( databasekeys_filename );
    
    command := ReadAll( stream );
    
    database_keys := EvalString( command );
    
    group_string := String( group );
    
    group_data := First( database_keys, entry -> entry[1] = group_string );
    
    if group_data = fail then
        
        Error( "The associator of ", group_string, " has not been computed yet" );
        
        return;
        
    fi;
    
    return RepresentationCategory( group, group_data );
    
end );

## Rep( G )
##
InstallMethod( RepresentationCategory,
               [ IsGroup, IsList ],
               
  function( group, group_data )
    local group_string, name,
          irr, conductor, unit_number, e,
          field, membership_function, tensor_unit, associator_filename, is_complete_data,
          category;
    
    group_string := String( group );
    
    name := Concatenation( "The representation category of ", group_string );
    
    irr := Irr( group );
    
    conductor := group_data[2];
    
    unit_number := group_data[3];
    
    associator_filename := group_data[4];
    
    is_complete_data := group_data[5];
    
    membership_function := object -> IsGIrreducibleObject( object ) and IsIdenticalObj( UnderlyingGroup( object ), group );
    
    if conductor = 1 then
        
        field := HomalgFieldOfRationalsInDefaultCAS();
        
    else
        
        field := HomalgCyclotomicFieldInMAGMA( conductor, "e" );
        
    fi;
    
    SetConductor( field, conductor );
    
    tensor_unit := GIrreducibleObject( irr[ unit_number ] );
    
    category := SemisimpleCategory( field, membership_function, tensor_unit, associator_filename, is_complete_data,
                  [ IsRepresentationCategory, IsRepresentationCategoryObject, 
                    IsRepresentationCategoryMorphism, name ] );
    
    SetUnderlyingGroupForRepresentationCategory( category, group );
    
    return category;
    
end );

##
InstallMethod( RepresentationCategoryObject,
               [ IsList, IsCapCategory ],
               
  function( object_list, category )
    
    object_list := List( object_list, elem -> [ elem[1], GIrreducibleObject( elem[2] ) ] );
    
    return SemisimpleCategoryObject( object_list, category );
    
end );

##
InstallMethod( RepresentationCategoryObject,
               [ IsCharacter, IsCapCategory ],
               
  function( character, category )
    
    return RepresentationCategoryObject( [ [ 1, character ] ], category );
    
end );

##
InstallMethod( RepresentationCategoryMorphism,
               [ IsSemisimpleCategoryObject, IsList, IsSemisimpleCategoryObject ],
               
  function( source, morphism_list, range )
    local field, new_morphism_list, elem, vector_space_morphism;
    
    field := UnderlyingFieldForHomalgForSemisimpleCategory( CapCategory( source ) );
    
    new_morphism_list := [ ];
    
    for elem in morphism_list do
        
        vector_space_morphism := 
          VectorSpaceMorphism( VectorSpaceObject( NrRows( elem[1] ), field ),
                               elem[1], 
                               VectorSpaceObject( NrColumns( elem[1] ), field ) );
        
        Add( new_morphism_list, [ vector_space_morphism, GIrreducibleObject( elem[2] ) ] );
        
    od;
    
    return SemisimpleCategoryMorphism( source, new_morphism_list, range );
    
end );

## Rep( Z x G )
##
InstallMethod( RepresentationCategoryZGraded,
               [ IsInt, IsInt ],
               
  function( order, group_nr )
    local databasekeys_filename, stream, command, database_keys, group_string, group_data, group;
    
    databasekeys_filename := 
      Concatenation( PackageInfo( "ActionsForCAP" )[1].InstallationPath, "/gap/AssociatorsDatabase/DatabaseKeys.g" );
    
    stream := InputTextFile( databasekeys_filename );
    
    command := ReadAll( stream );
    
    database_keys := EvalString( command );
    
    group_string := Concatenation( String( order ), ", ", String( group_nr ) );
    
    group_data := First( database_keys, entry -> entry[1] = group_string );
    
    if group_data = fail then
        
        Error( "The associator of ", group_string, " has not been computed yet" );
        
        return;
        
    fi;
    
    group := SmallGroup( order, group_nr );
    
    return RepresentationCategoryZGraded( group, group_data );
    
end );

InstallMethod( RepresentationCategoryZGraded,
               [ IsGroup ],
               
  function( group )
    local databasekeys_filename, stream, command, database_keys, group_string, group_data;
    
    databasekeys_filename := 
      Concatenation( PackageInfo( "ActionsForCAP" )[1].InstallationPath, "/gap/AssociatorsDatabase/DatabaseKeys.g" );
    
    stream := InputTextFile( databasekeys_filename );
    
    command := ReadAll( stream );
    
    database_keys := EvalString( command );
    
    group_string := String( group );
    
    group_data := First( database_keys, entry -> entry[1] = group_string );
    
    if group_data = fail then
        
        Error( "The associator of ", group_string, " has not been computed yet" );
        
        return;
        
    fi;
    
    return RepresentationCategoryZGraded( group, group_data );
    
end );

InstallMethod( RepresentationCategoryZGraded,
               [ IsGroup, IsList ],
               
  function( group, group_data )
    local group_string, name,
          irr, conductor, unit_number, e,
          field, membership_function, tensor_unit, associator_filename, is_complete_data,
          category;
    
    group_string := String( group );
    
    name := Concatenation( "The Z-graded representation category of ", group_string );
    
    irr := Irr( group );
    
    conductor := group_data[2];
    
    unit_number := group_data[3];
    
    associator_filename := group_data[4];
    
    is_complete_data := group_data[5];
    
    membership_function := object -> IsGZGradedIrreducibleObject( object ) and IsIdenticalObj( UnderlyingGroup( object ), group );
    
    if conductor = 1 then
        
        field := HomalgFieldOfRationalsInDefaultCAS();
        
    else
        
        field := HomalgCyclotomicFieldInMAGMA( conductor, "e" );
        
    fi;
    
    SetConductor( field, conductor );
    
    tensor_unit := GZGradedIrreducibleObject( 0, irr[ unit_number ] );
    
    category := SemisimpleCategory( field, membership_function, tensor_unit, associator_filename, is_complete_data,
                  [ IsRepresentationCategory, IsRepresentationCategoryZGradedObject, 
                    IsRepresentationCategoryZGradedMorphism, name ] );
    
    SetUnderlyingGroupForRepresentationCategory( category, group );
    
    return category;
    
end );

##
InstallMethod( RepresentationCategoryZGradedObject,
               [ IsList, IsCapCategory ],
               
  function( object_list, category )
    
    object_list := List( object_list, elem -> [ elem[1], GZGradedIrreducibleObject( elem[2], elem[3] ) ] );
    
    return SemisimpleCategoryObject( object_list, category );
    
end );

##
InstallMethod( RepresentationCategoryZGradedObject,
               [ IsInt, IsCharacter, IsCapCategory ],
               
  function( degree, character, category )
    
    return RepresentationCategoryZGradedObject( [ [ 1, degree, character ] ], category );
    
end );

##
InstallMethod( RepresentationCategoryZGradedObject,
               [ IsCharacter, IsCapCategory ],
               
  function( character, category )
    
    return RepresentationCategoryZGradedObject( [ [ 1, 0, character ] ], category );
    
end );


##
InstallMethod( RepresentationCategoryZGradedMorphism,
               [ IsSemisimpleCategoryObject, IsList, IsSemisimpleCategoryObject ],
               
  function( source, morphism_list, range )
    local field, new_morphism_list, elem, vector_space_morphism;
    
    field := UnderlyingFieldForHomalgForSemisimpleCategory( CapCategory( source ) );
    
    new_morphism_list := [ ];
    
    for elem in morphism_list do
        
        vector_space_morphism :=
          VectorSpaceMorphism( VectorSpaceObject( NrRows( elem[1] ), field ),
                               elem[1], 
                               VectorSpaceObject( NrColumns( elem[1] ), field ) );
        
        Add( new_morphism_list, [ vector_space_morphism, GZGradedIrreducibleObject( elem[2], elem[3] ) ] );
        
    od;
    
    return SemisimpleCategoryMorphism( source, new_morphism_list, range );
    
end );

####################################
##
## Attributes
##
####################################

##
InstallMethod( DegreeDecomposition,
               [ IsRepresentationCategoryZGradedObject ],
               
  function( object )
    local object_list, current_degree, new_list, new_list_entry, i, elem;
    
    object_list := SemisimpleCategoryObjectList( object );
    
    if IsEmpty( object_list ) then
        
        return object_list;
        
    fi;
    
    current_degree := UnderlyingDegree( object_list[1][2] );
    
    new_list := [ ];
    
    new_list_entry := [ object_list[1] ];
    
    for i in [ 2 .. Size( object_list ) ] do
        
        elem := object_list[i];
        
        if UnderlyingDegree( elem[2] ) = current_degree then
            
            Add( new_list_entry, elem );
            
        else
            
            Add( new_list, new_list_entry );
            
            current_degree := UnderlyingDegree( elem[2] );
            
            new_list_entry := [ elem ];
            
        fi;
        
    od;
    
    Add( new_list, new_list_entry );
    
    return List( new_list, entry -> [ UnderlyingDegree( entry[1][2] ) ,SemisimpleCategoryObject( entry , CapCategory( object ) ) ] );
    
end );

##
InstallMethod( DegreeDescendingFiltration,
               [ IsRepresentationCategoryZGradedObject ],
               
  function( object )
    local descending_decomposition, descending_filtration, i;
    
    descending_decomposition := Reversed( List( DegreeDecomposition( object ), elem -> elem[2] ) );
    
    if Size( descending_decomposition ) = 1 then
        
        return [];
        
    fi;
    
    descending_filtration := 
      [ InjectionOfCofactorOfDirectSum( [ descending_decomposition[1], descending_decomposition[2] ], 1 ) ];
    
    for i in [ 3 .. Size( descending_decomposition ) ] do
        
        Add( descending_filtration,
          InjectionOfCofactorOfDirectSum( [ Range( descending_filtration[ i - 2 ] ), descending_decomposition[ i ] ], 1 ) );
        
    od;
    
    return descending_filtration;
    
end );

##
InstallMethod( DegreeDescendingCofiltration,
               [ IsRepresentationCategoryZGradedObject ],
               
  function( object )
    local descending_decomposition, descending_cofiltration, i;
    
    descending_decomposition := Reversed( List( DegreeDecomposition( object ), elem -> elem[2] ) );
    
    if Size( descending_decomposition ) = 1 then
        
        return [];
        
    fi;
    
    descending_cofiltration := 
      [ ProjectionInFactorOfDirectSum( [ descending_decomposition[1], descending_decomposition[2] ], 1 ) ];
    
    for i in [ 3 .. Size( descending_decomposition ) ] do
        
        Add( descending_cofiltration,
          ProjectionInFactorOfDirectSum( [ Source( descending_cofiltration[ i - 2 ] ), descending_decomposition[ i ] ], 1 ) );
        
    od;
    
    return descending_cofiltration;
    
end );


