rem Truststore para que el servidor muestre las CA de las que acepta certificados
set USER_CERT_TRUSTORE=truststore.jks
set USER_CERT_TRUSTORE_PASS=tirtxin

rem Certificado de usuario

rem cambiar el nombre de CN y de la base de los ficheros al gusto
set MICN=Bob
set MIFICHERO=bob

rem Ficheros del certificado de servidor
set USER_CERT_PRIVATE_KEY=%MIFICHERO%.key
set USER_CERT_SIGNATURE_REQUEST=%MIFICHERO%.csr
set USER_CERT_PUBLIC_CERTIFICATE=%MIFICHERO%.crt
rem (no usado)	set USER_CERT_EXTENSIONS=%MIFICHERO%.ext

rem Datos del certificado

rem CN del certificado, sera lo que siga a https:// o nombre de DNS
rem modificar la direccion de correo
set USER_CERT_CN=%MICN%
rem Resto de elementos del subject
set USER_CERT_emailAddress=%MIFICHERO%_cert@nextret.net
set USER_CERT_C=ES
set USER_CERT_ST=Catalunya
set USER_CERT_L=Barcelona
set USER_CERT_O=Applications Development (ADV)
set USER_CERT_OU=The Java Wild Bunch

rem Configuracion certificado
set USER_CERT_PASSWORD=t1rtx1n
set USER_CERT_SECURITY_BITS=4096
set USER_CERT_DURATION_DAYS=730

rem Fichero PKCS#12 final
set USER_CERT_PKCS12_NAME=%MIFICHERO%
set USER_CERT_PKCS12_FILE=%MIFICHERO%.p12
rem misma de la private key para evitar lios
set USER_CERT_PKCS12_PASS=%USER_CERT_PASSWORD%
