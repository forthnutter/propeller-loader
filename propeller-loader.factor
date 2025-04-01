! Copyright (C) 2013 Joseph Moschini.
! See http://factorcode.org/license.txt for BSD license.
!

USING: accessors byte-arrays combinators grouping io
       io.files io.files.info kernel math math.order math.parser sequences
       tools.continuations io.encodings.binary ;
! local function found in working directory 
USING: binfile ;

IN: propeller-loader


! Read Entire File - read an entire file into an allocated buffer
: ReadEntireFile ( name -- barray )
! {
!    uint8_t *buf;
!    long size;
!    FILE *fp;

!    /* open the file in binary mode */
!    if (!(fp = fopen(name, "rb")))
        return NULL;

    /* get the file size */
    fseek(fp, 0L, SEEK_END);
    size = ftell(fp);
    fseek(fp, 0L, SEEK_SET);
    
    /* allocate a buffer for the file contents */
    if (!(buf = (uint8_t *)malloc(size))) {
        fclose(fp);
        return NULL;
    }
    
    /* read the contents of the file into the buffer */
    if (fread(buf, 1, size, fp) != size) {
        free(buf);
        fclose(fp);
        return NULL;
    }
    
    /* close the file ad return the buffer containing the file contents */
    *pSize = size;
    fclose(fp);
    return buf;
! }

;


: loader-run ( -- )
