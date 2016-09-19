LoadPackage( "ModulePres" );
Q := HomalgFieldOfRationalsInSingular();
R := Q*"x,y";
S := GradedRing( R );
WeightsOfIndeterminates( S );
eins := last[1];
M := HomalgMatrix( "[x^2,xy,y^2]", 3,1, S );
XX := GradedFreeLeftPresentation( 1, S );
S0 := GradedFreeLeftPresentation( 1, S );
S1 := GradedFreeLeftPresentation( 3, S, [ 2*eins, 2*eins, 2*eins ] );
alpha := GradedPresentationMorphism( S1, M, S0 );
M := CokernelObject( alpha );
FF := ResolutionFunctor( GradedLeftPresentations( S ), CoverByFreeModule );
res := ApplyFunctor( FF, M );
