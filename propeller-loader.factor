! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors byte-arrays combinators command-line grouping io io.encodings.binary
       io.files io.files.info kernel math math.order math.parser namespaces
       sequences strings
       tools.continuations vocabs.metadata ;

! local function found in working directory 
USING: binfile ;

IN: propeller-loader

TUPLE: load file fbarray ;


: loader-usage ( -- )
    "Usage: loader [optons] [script] [file]" print
    "    [options]" print
    "        -b=<type>        Select target board and subtype (default is default:default)" print
    "        -board=<type>    same as above" print
    "        -c               Display numeric message codes" print
    "        -D=var:value     Define a board configuration variable" print
    "        -e               program eeprom and halt unless -r is specified" print
    "    [script]" print
    "        configuration file name .cfg" print
    "    [file]" print
    "        file name of binary file to be loaded" print
;

: loader-lines ( -- )
    [ write nl flush ] each-line ;

: loader-stream ( -- )
    [ 1024 read dup ] [ >string write flush ] while drop ;


: loader-file ( path -- )
    <binfile> [ drop loader-usage ] [ break drop ] if-empty
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
    { "run-loader" "-b" "script" "work/propeller-loader/LongSpinCode.binary" "LongSpinCode1.binary" } parse-command-line
;

: run-loader ( -- )
    load new    ! allocate some memory for tuple
    fake-command-line
    command-line get [ loader-usage ] [ loader-files ] if-empty
    drop
;

MAIN: run-loader
