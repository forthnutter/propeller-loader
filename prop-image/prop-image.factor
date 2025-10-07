! generate image for propeller


USING: accessors kernel ;


IN: propeller-loader.prop-image

TUPLE: propimage imagedata ;


! create our structure here
: <pimage> ( array -- obj )
    propimage new   ! memory
    swap >>imagedata        ! save binary image

;