! handles connection to propeller

USING: kernel syntax ;

IN: propeller-loader.connection

TUPLE: connection portname baudrate config ;

! GENERIC: is-open ( -- ? )

M: connection is-open ( -- ? )
    f ;

M: connection close ( -- i )
    0 ;

M: connection connect ( -- i )
    0 ;

M: connection disconnect ( -- i )
    0 ;

M: connection set-reset-method ( method -- i )
    0 ;

M: connection generater-reset-signal ( -- i )
    0 ;

M: connection identify ( version -- i )
    0 ;

M: connection load-image ( image imageSize response responseSize -- i )
    0 ;

M: connection load-image ( image imageSize ltDownloadAndRun  info -- i )
    0 ;

M: connection receive-data-timeout ( buf len timeout -- i )
    0 ;


M: connection send-data ( buf len -- i )
    0 ;

M: connection receive-data-exact-timeout ( buf len timeout -- i )
    0 ;

M: connection set-baud-rate ( baudrate -- i )
    0 ;

M: connection max-data-size ( -- i )
    0 ;

M: connection terminal ( ?check  ?mode -- i )
    0 ;

M: connection port-name ( -- portname )
    [ portname>> 0 = not ] keep swap 
    [ portname>> ] [ "<none>" ] if
;

M: connection set-port-name ( portName -- )
    [ 0 = ] keep swap
    [ portname<< ] [ drop ] if ;

!        if (m_portName)
!            free(m_portName);
!        if ((m_portName = (char *)malloc(strlen(portName) + 1)) != NULL)
!            strcpy(m_portName, portName);
!    }


M: connection set-config ( config -- )
    config<< ;

M: connection get-config ( -- config )
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