! create loader from c++

USING: kernel propeller-loader.connection ;

IN: propeller-loader.loader

TUPLE: loader file connection array ;


! generate a usage text array
M: loader usage ( -- vector )
    V{} clone 
    [ "Usage: loader [optons] [script] [file]" swap push ] keep
    [ "    [options]" swap push ] keep
    [ "        -b=<type>        Select target board and subtype (default is default:default)" swap push ] keep
    [ "        -board=<type>    same as above" swap push ] keep
    [ "        -c               Display numeric message codes" swap push ] keep
    [ "        -D=var:value     Define a board configuration variable" swap push ] keep
    [ "        -e               program eeprom and halt unless -r is specified" swap push ] keep
    [ "    [script]" swap push ] keep
    [ "        configuration file name .cfg" swap push ] keep
    [ "    [file]" swap push ] keep
    [ "        file name of binary file to be loaded" swap push ] keep
;


M: loader set-connection ( loader connection -- )
    connection<<
;


M: loader identify ( loader version -- i )
    drop drop 0
;


M: loader load-file ( loader file loadType -- i )

    drop drop drop
!    uint8_t *image;
!    int imageSize;
!    int sts;
    
!    /* make sure the image was loaded into memory */
!    if (!(image = readFile(file, &imageSize)))
!        return -1;
    
!    /* load the file */
!    sts = loadImage(image, imageSize, loadType);
!    free(image);
    
!    /* return load result */
!    return sts;
    0
;

M: loader fast-load-file ( loader file loadtype -- i )
    drop drop drop 0
;


M: loader load-image ( loader image imagesize loadtype -- i )
    drop drop drop drop 0

!    // get the binary clock settings
!    PropImage img((uint8_t *)image, imageSize); // shouldn't really modify image!
    
!    // get the fast loader and program clock speeds
!    int clockSpeed;
!    int gotClockSpeed = GetNumericConfigField(m_connection->config(), "clkfreq", &clockSpeed);
!    if (gotClockSpeed) {
!        img.setClkFreq(clockSpeed);
!        img.updateChecksum();
!    }

!    // get the fast loader and program clock modes
!    int clockMode;
!    int gotClockMode = GetNumericConfigField(m_connection->config(), "clkmode", &clockMode);
!    if (gotClockMode) {
!        img.setClkMode(clockMode);
!        img.updateChecksum();
!    }
        
!    nmessage(INFO_DOWNLOADING, m_connection->portName());
!    return m_connection->loadImage(image, imageSize, loadType);
;

M: loader fast-load-image ( loader image imagesize loadtype -- i )
    drop drop drop drop 0
;

M: loader read-file ( loader file imagesize -- data )
    drop drop drop 0

!    uint8_t *image;
!    int imageSize;
!    ElfHdr elfHdr;
!    FILE *fp;

!    /* open the binary file */
!    if (!(fp = fopen(file, "rb")))
!        return NULL;
    
!    /* check for an elf file */
!    if (ReadAndCheckElfHdr(fp, &elfHdr))
!        image = readElfFile(fp, &elfHdr, &imageSize);

!    /* otherwise, assume a Spin binary */
!    else
!        image = readSpinBinaryFile(fp, &imageSize);
        
!    /* close the binary file */
!    fclose(fp);

!    /* return the image */
!    if (image) *pImageSize = imageSize;
!    return image;
;

M: loader fast-load-image-help ( loader image imagesize loadtype clockspeed clockmode baudrate fastloaderbaudrate -- i )
    drop drop drop drop drop drop drop drop 0
;

M: loader generate-initial-loader-image ( loader clockSpeed clockMode packetID loaderBaudRate fastLoaderBaudRate Length -- i )
    drop drop drop drop drop drop 0
;

M: loader transmit-packet ( loader id payload payloadSize pResult timeout -- i )
    drop drop drop drop drop drop 0
;


M: loader read-spin-binary-file ( loader fp pImageSize -- i )
    drop drop drop 0
;


M: loader read-elf-file ( loader fp hdr pImageSize -- i )
    drop drop drop drop 0
;


! initalise the loader 
: <loader> ( -- loader )
    loader new
    V{ } clone >>array
    <connection> >>connection
;

! class Loader {
! public:
!    Loader() : m_connection(0) {}
!    Loader(PropConnection *connection) : m_connection(connection) {}
!    ~Loader() {}
!    void setConnection(PropConnection *connection) { m_connection = connection; }
!    int identify(int *pVersion);
!    int loadFile(const char *file, LoadType loadType = ltDownloadAndRun);
!    int fastLoadFile(const char *file, LoadType loadType = ltDownloadAndRun);
!    int loadImage(const uint8_t *image, int imageSize, LoadType loadType = ltDownloadAndRun);
!    int fastLoadImage(const uint8_t *image, int imageSize, LoadType loadType = ltDownloadAndRun);
!    static uint8_t *readFile(const char *file, int *pImageSize);
! private:
!    int fastLoadImageHelper(const uint8_t *image, int imageSize, LoadType loadType, int clockSpeed, int clockMode, int loaderBaudRate, int fastLoaderBaudRate);
!    uint8_t *generateInitialLoaderImage(int clockSpeed, int clockMode, int packetID, int loaderBaudRate, int fastLoaderBaudRate, int *pLength);
!    int transmitPacket(int id, const uint8_t *payload, int payloadSize, int *pResult, int timeout = 2000);
!    static uint8_t *readSpinBinaryFile(FILE *fp, int *pImageSize);
!    static uint8_t *readElfFile(FILE *fp, ElfHdr *hdr, int *pImageSize);
!    PropConnection *m_connection;
! };