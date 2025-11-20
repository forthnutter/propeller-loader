!
! handles the propeller binary data
!
! system includes go here
USING: alien.c-types accessors byte-arrays classes.struct kernel math math.bitwise sequences strings tools.continuations ;

! keep local includes here
USING: binfile  ;

IN: propeller-loader.propeller-binary

CONSTANT: SPIN_STACK_FRAME_CHECKSUM   0xEC
CONSTANT: MAX_IMAGE_SIZE              32768
CONSTANT: INIT_CALL_FRAME             B{ 0xFF 0xFF 0xF9 0xFF 0xFF 0xFF 0xF9 0xFF }


TUPLE: pbin filename bdata bfull error-flag error ;


! /* spin object file header */
STRUCT: spin-header
    { clkfreq uint32_t } ! 0
    { clkmode uint8_t }  ! 2
    { chksum uint8_t }   
    { pbase uint16_t }  ! 3
    { vbase uint16_t }  ! 4
    { dbase uint16_t }  ! 5
    { pcurr uint16_t }  ! 6
    { dcurr uint16_t }  ! 7
;

GENERIC: clkfrq-data-get ( pbin -- clk )
GENERIC: clkfrq-data-set ( clk pbin -- )
GENERIC: clkmode-data-get ( pbin -- clk )
GENERIC: clkmode-data-set ( clk pbin -- )
GENERIC: error-add ( string pbin -- )
GENERIC: checksum ( pbin -- )
GENERIC: checksum-get ( pbin -- checksum )
GENERIC: checksum-set ( chksum pbin -- )
GENERIC: validate ( pbin -- ? )
GENERIC: pbase-get ( pbin -- pbase )
GENERIC: dbase-get ( pbin -- dbase )
GENERIC: fullbin ( pbin -- )
GENERIC: vbase-get ( pbin -- vbase )


M: pbin error-add
    [ dup string? ] dip swap ! make sure we have a string
    [ 
        [ error>> push ] keep
        f swap error-flag<<
    ]
    [
        drop drop
    ] if
;

! we can change the clock mode on the fly
M: pbin clkmode-data-set
    [ error-flag>> ] keep swap not
    [
        bdata>> spin-header memory>struct clkmode<<
    ]
    [
        drop drop
    ] if
;
! go grab clock mode infomation from binary data
M: pbin clkmode-data-get
    [ error-flag>> ] keep swap not 
    [
        bdata>> spin-header memory>struct clkmode>>
    ]
    [
        drop ! no need for object
        0   ! return nothing important
    ] if
;

! we can change the clock on the fly
M: pbin clkfrq-data-set
    [ bdata>> length>> 0 = not ] keep swap
    [
        bdata>> spin-header memory>struct clkfreq<<
    ]
    [
        ! we have some kind of error
        "Missing Binary Data" swap error-add
         drop
    ] if
;
! go grab clock infomation from binary data
M: pbin clkfrq-data-get
    [ error-flag>> ] keep swap not 
    [
        bdata>> spin-header memory>struct clkfreq>>
    ]
    [
        drop ! no need for object
        0   ! return nothing important
    ] if
;


M: pbin checksum-set
    [ bdata>> length>> 0 = not ] keep swap
    [
        bdata>> spin-header memory>struct chksum<<
    ]
    [
        ! we have some kind of error
        "Missing Binary Data" swap error-add
         drop
    ] if
;


M: pbin checksum-get
    [ bdata>> length>> 0 = not ] keep swap
    [
        bdata>> spin-header memory>struct chksum>>
    ]
    [
        ! we have some kind of error
        "Missing Binary Data" swap error-add
         0
    ] if
;


! rebuild the checksum and store it back into the binary data
M: pbin checksum
    [ 0 swap checksum-set ] keep
   SPIN_STACK_FRAME_CHECKSUM swap
   [ bdata>> [ + 0xff mask ] each ] keep  ! cksum pbin
   [ checksum-get swap ] keep
   [ - 0xff mask ] dip checksum-set
;

! start of code 
M: pbin pbase-get
    bdata>> spin-header memory>struct pbase>> ;

! get the of code
M: pbin dbase-get
    bdata>> spin-header memory>struct dbase>> ;

! get the vbase
M: pbin vbase-get
    bdata>> spin-header memory>struct vbase>> ;


! copy bdata to full capacity memory also copy call frame
M: pbin fullbin
    [ bdata>> ] keep
    [ 0 MAX_IMAGE_SIZE <byte-array> ] dip
    [ bfull<< ] keep [ bfull>> ] keep
    [ copy ] dip
    [ dbase-get ] keep
    [ INIT_CALL_FRAME length - ] dip 
    [ INIT_CALL_FRAME swap ] dip
    [ bfull>> ] keep
    [ copy ] dip drop
;

! validate the binary data
M: pbin validate
    break
    ! lets test to see data is smaller the size if header
    [ bdata>> length>> ] keep ! length pbin
    [ spin-header struct-size < ] dip swap not
    [
        ! make sure the image isn't too large
        [ bdata>> length>> MAX_IMAGE_SIZE > not ] keep swap
        [
            ! make sure the code starts in the right place
            [ pbase-get 16 = ] keep swap
            [
                ! make sure there is space for the initial call frame
                [ dbase-get MAX_IMAGE_SIZE > not ] keep swap
                [
                    ! build up a call frame in full binary
                    [ fullbin ] keep

                    0 swap      ! start checksum at 0
                    [ bfull>> [ + 0xff mask ] each  0 = ] keep swap
          
                    [
                        ! make sure there is no data after the code
                        ! uint16_t idx = hdr->vbase;
                        [ vbase-get ] keep
                        [ dbase-get ] keep
                        [ INIT_CALL_FRAME length - ] dip
                        [ [ dup ] dip - 7 mask INIT_CALL_FRAME nth ] dip    ! initialCallFrame[idx - (hdr->dbase - sizeof(initialCallFrame))]
                        [ [ dup ] 2dip bfull>> swap [ nth ] dip = ] keep     ! fullImage[idx] == initialCallFrame[idx - (hdr->dbase - sizeof(initialCallFrame))])))
!    while (idx < m_imageSize && (fullImage[idx] == 0 || (idx >= hdr->dbase - sizeof(initialCallFrame) && idx < hdr->dbase && fullImage[idx] == initialCallFrame[idx - (hdr->dbase - sizeof(initialCallFrame))])))
!        ++idx;
!    if (idx < m_imageSize)
!        return IMAGE_CORRUPTED;
                        
                         t ]
                    [ "Image corrupted" swap error-add f ] if
                ] [ "Image to large" swap error-add f ] if
            ] [ "Image corrupted" swap error-add f ] if
        ] [ "Image to large" swap error-add f ] if
    ] [ "Image to small" swap error-add f ] if ;


! lets start here
: <pbin> ( file-name -- pbin )
    pbin new ! allocate memory for tupple
    V{ } clone >>error      ! error contains a vector list of string errors
    f >>error-flag          ! error flag 
    [ filename<< ] keep ! save the file name into class we may need it later on + keep class on stack
    [ filename>> <binfile> ] keep ! get object out of class -- binary data and class on stack
    [ bdata<< ] keep            ! save binary data from file

    [ validate ] keep swap drop
;