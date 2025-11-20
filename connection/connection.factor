! handles connection to propeller

USING: accessors kernel tools.continuations
 ;

IN: propeller-loader.connection



TUPLE: connection portname baudrate config ;


GENERIC: close ( connection -- i )
GENERIC: connect ( connection -- i )
GENERIC: disconnect ( connection -- i )
GENERIC: generater-reset-signal ( connection -- i )
GENERIC: get-config ( connection -- config )
GENERIC: identify ( connection version -- i )
GENERIC: is-open ( connection -- ? )
GENERIC: load-image ( connection image imageSize response responseSize -- i )
GENERIC: load-image2 ( connection image imageSize ltDownloadAndRun  info -- i )
GENERIC: max-data-size ( connection -- i )
GENERIC: port-name ( connection -- portname )
GENERIC: receive-data-exact-timeout ( connection buf len timeout -- i )
GENERIC: receive-data-timeout ( connection buf len timeout -- i )
GENERIC: send-data ( connection buf len -- i )
GENERIC: set-baud-rate ( connection baudrate -- i )
GENERIC: set-config ( connection config -- )
GENERIC: set-port-name ( connection portName -- )
GENERIC: set-reset-method ( connection method -- i )
GENERIC: terminal ( connection ?check  ?mode -- i )


M: connection is-open
    drop f ;

M: connection close
    drop 0 ;

M: connection connect
    drop 0 ;

M: connection disconnect
    drop 0 ;

M: connection set-reset-method
    drop drop 0 ;

M: connection generater-reset-signal
    drop 0 ;

M: connection identify
    drop drop 0 ;

M: connection load-image
    drop drop drop drop drop 0 ;

M: connection load-image2
    drop drop drop drop drop 0 ;

M: connection receive-data-timeout
    drop drop drop drop 0 ;


M: connection send-data
    drop drop drop 0 ;

M: connection receive-data-exact-timeout
    drop drop drop drop 0 ;

M: connection set-baud-rate
    drop drop 0 ;

M: connection max-data-size
    drop 0 ;

M: connection terminal
    drop drop drop 0 ;

M: connection port-name
    [ portname>> 0 = not ] keep swap 
    [ portname>> ] [ drop "<none>" ] if
;

M: connection set-port-name
    [ 0 = ] keep swap
    [ portname<< ] [ drop drop ] if ;

!        if (m_portName)
!            free(m_portName);
!        if ((m_portName = (char *)malloc(strlen(portName) + 1)) != NULL)
!            strcpy(m_portName, portName);
!    }


M: connection set-config
    config<< ;

M: connection get-config
    config>> ;

: <connection> ( -- connection )
    connection new
;


! class PropConnection
! {
! public:
!    PropConnection() : m_config(NULL), m_portName(NULL) {}
!    ~PropConnection() {
!        if (m_portName)
!            free(m_portName);
!    }
!    virtual bool isOpen() = 0;
!    virtual int close() = 0;
!    virtual int connect() = 0;
!    virtual int disconnect() = 0;
!    virtual int setResetMethod(const char *method) = 0;
!    virtual int generateResetSignal() = 0;
!    virtual int identify(int *pVersion) = 0;
!    virtual int loadImage(const uint8_t *image, int imageSize, uint8_t *response, int responseSize) = 0;
!    virtual int loadImage(const uint8_t *image, int imageSize, LoadType loadType = ltDownloadAndRun, int info = false) = 0;
!    virtual int sendData(const uint8_t *buf, int len) = 0;
!    virtual int receiveDataTimeout(uint8_t *buf, int len, int timeout) = 0;
!    virtual int receiveDataExactTimeout(uint8_t *buf, int len, int timeout) = 0;
!    virtual int setBaudRate(int baudRate) = 0;
!    virtual int maxDataSize() = 0;
!    virtual int terminal(bool checkForExit, bool pstMode) = 0;
!    const char *portName() { return m_portName ? m_portName : "<none>"; }
!    void setPortName(const char *portName) {
!        if (m_portName)
!            free(m_portName);
!        if ((m_portName = (char *)malloc(strlen(portName) + 1)) != NULL)
!            strcpy(m_portName, portName);
!    }
!    void setConfig(BoardConfig *config) { m_config = config; }
!    BoardConfig *config() { return m_config; }
! protected:
!    BoardConfig *m_config;
!    char *m_portName;
!    int m_baudRate;
! };