! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors byte-arrays combinators command-line grouping io io.encodings.binary
       io.files io.files.info kernel math math.order math.parser namespaces
       sequences strings
       tools.continuations vocabs.metadata ;

! local function found in working directory 
USING: binfile propeller-loader.loader loaderpropeller-loader.prop-image ;

IN: propeller-loader


: loader-file ( path -- ? )
    <binfile> [ drop loader-usage f ] [ break <pimage> ] if-empty
;

: loader-files ( path -- )
    [ [ loader-usage ] [ loader-file ] if-empty ] each ;

! test if file ok load into a array
: readentirefile ( loader -- loader' )
    [ file>> ] keep swap
    [
        [ file>> ] keep swap <binfile> >>fbarray
    ]
    [

    ] if ;

! idea here is create a fake command line for testing purpose
: fake-command-line ( -- )
    { "run-loader" "-b" "script" "work/propeller-loader/LargeSpinCode.binary" "LongSpinCode1.binary" } parse-command-line
;

: <loader> ( -- obj )
    load new    ! allocate some memory for tuple
    V{ } clone >>objarray
;

: run-loader ( -- )
    <loader>            ! create obj
    fake-command-line
    command-line get [ loader-usage ] [ loader-files ] if-empty
    drop
;

MAIN: run-loader
