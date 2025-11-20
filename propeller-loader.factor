! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors byte-arrays combinators command-line grouping io io.encodings.binary
       io.files io.files.info kernel math math.order math.parser namespaces
       sequences strings
       tools.continuations vocabs.metadata ;

! local function found in working directory 
USING: propeller-loader.loader propeller-loader.prop-image propeller-loader.propeller-binary ;

IN: propeller-loader

TUPLE: ploader array ;

! test if file ok load into a array
! : readentirefile ( loader -- loader' )
!    [ file>> ] keep swap
!    [
!        [ file>> ] keep swap <binfile> >>fbarray
!    ]
!    [

!    ] if ;

: <ploader> ( -- ploader )
    ploader new
;

! idea here is create a fake command line for testing purpose
: fake-command-line ( -- )
    { "run-loader" "-b" "script" "work/propeller-loader/LargeSpinCode.binary" "LongSpinCode1.binary" } parse-command-line
;



: run-loader ( -- )
    "work/propeller-loader/LargeSpinCode.binary" <pbin>
!    fake-command-line
!    command-line get [ loader-usage ] [ loader-files ] if-empty
    drop drop
;

MAIN: run-loader
