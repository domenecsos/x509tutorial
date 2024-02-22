rem cambiar en MIPC pcnx415 por el nombre de la propia maquina, y el correo en MIMAIL
set MIPC=pcnx415
set MIMAIL=dsv@nextret.net

rem Ficheros del certificado de servidor
set SERVER_CERT_PRIVATE_KEY=%MIPC%.key
set SERVER_CERT_SIGNATURE_REQUEST=%MIPC%.csr
set SERVER_CERT_PUBLIC_CERTIFICATE=%MIPC%.crt
set SERVER_CERT_EXTENSIONS=%MIPC%.ext

rem Datos del certificado

rem CN del certificado, sera lo que siga a https:// o nombre de DNS
rem modificar la direccion de correo
set SERVER_CERT_CN=%MIPC%.corp.nextret.net
rem Nombres alternativos que nos facilitan el desarrollo local
set SERVER_CERT_DNS_NAME_ALT_1=localhost
set SERVER_CERT_DNS_NAME_ALT_2=%MIPC%
rem Resto de elementos del subject
set SERVER_CERT_emailAddress=%MIMAIL%
set SERVER_CERT_C=ES
set SERVER_CERT_ST=Catalunya
set SERVER_CERT_L=Barcelona
set SERVER_CERT_O=Applications Development (ADV)
set SERVER_CERT_OU=The Java Wild Bunch

rem Configuracion certificado
set SERVER_CERT_PASSWORD=tortxon
set SERVER_CERT_SECURITY_BITS=4096
set SERVER_CERT_DURATION_DAYS=730

rem Keystore Java
set SSL_KEYSTORE_FILE=server.jks
set SSL_KEYSTORE_PASS=tartxan

rem Fichero PKCS#12 intermedio
set SSL_PKCS12_NAME=%MIPC%
set SSL_PKCS12_FILE=%MIPC%.p12
set SSL_PKCS12_PASS=turtxun
