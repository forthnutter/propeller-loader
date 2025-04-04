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



: loader-lines ( -- )
    [ write nl flush ] each-line ;

: loader-stream ( -- )
    [ 1024 read dup ] [ >string write flush ] while drop ;


: loader-file ( path -- )
    dup file-exists?
    [ binary [ loader-stream ] with-file-reader ]
    [ write ": not found" write nl flush ] if ;

: loader-files ( path -- )
    [ dup "-" = [ drop loader-lines ] [ loader-file ] if ] each ;

: run-loader ( -- )
    command-line get [ loader-lines ] [ loader-files ] if-empty
;

MAIN: run-loader
