@echo off
set DIR=%cd%
echo Creando certificado y clave privada de servidor con la configuracion de input\serverSideCertificate.bat
type ..\input\serverSideCertificate.bat
call ..\input\serverSideCertificate.bat
pause

rem Pragmatismo, mejor ir directamente al directorio de output
cd ..\output\

IF EXIST %SERVER_CERT_PRIVATE_KEY% DEL /F %SERVER_CERT_PRIVATE_KEY%
IF EXIST %SERVER_CERT_PUBLIC_CERTIFICATE% DEL /F %SERVER_CERT_PUBLIC_CERTIFICATE%
IF EXIST %SERVER_CERT_SIGNATURE_REQUEST% DEL /F %SERVER_CERT_SIGNATURE_REQUEST%

echo Generando una solicitud de firma de certificado (CSR) para una nueva clave privada del servidor

set SERVER_CERT_SUBJECT=/CN=%SERVER_CERT_CN%/emailAddress=%SERVER_CERT_emailAddress%/C=%SERVER_CERT_C%/ST=%SERVER_CERT_ST%/L=%SERVER_CERT_L%/O=%SERVER_CERT_O%/OU=%SERVER_CERT_OU%

echo -
echo Ejecutando
echo openssl req -new -newkey rsa:%SERVER_CERT_SECURITY_BITS% -subj "%SERVER_CERT_SUBJECT%" -keyout %SERVER_CERT_PRIVATE_KEY% -out %SERVER_CERT_SIGNATURE_REQUEST% -passout pass:%SERVER_CERT_PASSWORD%
echo -

openssl req -new ^
	-newkey rsa:%SERVER_CERT_SECURITY_BITS% ^
	-subj "%SERVER_CERT_SUBJECT%" ^
	-keyout %SERVER_CERT_PRIVATE_KEY% ^
	-out %SERVER_CERT_SIGNATURE_REQUEST% ^
	-passout pass:%SERVER_CERT_PASSWORD%

pause

type %SERVER_CERT_PRIVATE_KEY%
type %SERVER_CERT_SIGNATURE_REQUEST%

pause

echo Crea el fichero de extensiones %SERVER_CERT_EXTENSIONS%

echo authorityKeyIdentifier=keyid,issuer> %SERVER_CERT_EXTENSIONS%
echo basicConstraints=CA:FALSE>> %SERVER_CERT_EXTENSIONS%
echo subjectAltName = @alt_names>> %SERVER_CERT_EXTENSIONS%
echo [alt_names]>> %SERVER_CERT_EXTENSIONS%
echo DNS.1 = %SERVER_CERT_DNS_NAME_ALT_1%>> %SERVER_CERT_EXTENSIONS%
echo DNS.2 = %SERVER_CERT_DNS_NAME_ALT_2%>> %SERVER_CERT_EXTENSIONS%

type %SERVER_CERT_EXTENSIONS%

pause

echo Usando la configuacion de root CA para firmar
type ..\input\rootCAconfig.bat
call ..\input\rootCAconfig.bat

pause
echo Now, it’s time to sign the request with our rootCA.crt certificate and its private key:

echo -
echo Ejecutando
echo openssl x509 -req -CA %ROOT_CA_PUBLIC_CERTIFICATE%.crt -CAkey %ROOT_CA_PRIVATE_KEY% -in %SERVER_CERT_SIGNATURE_REQUEST% -out %SERVER_CERT_PUBLIC_CERTIFICATE% -days %SERVER_CERT_DURATION_DAYS% -CAcreateserial -extfile %SERVER_CERT_EXTENSIONS% -pass pass:%ROOT_CA_PASSWORD%
echo -

openssl x509 -req ^
	-CA %ROOT_CA_PUBLIC_CERTIFICATE% ^
	-CAkey %ROOT_CA_PRIVATE_KEY% ^
	-in %SERVER_CERT_SIGNATURE_REQUEST% ^
	-out %SERVER_CERT_PUBLIC_CERTIFICATE% ^
	-days %SERVER_CERT_DURATION_DAYS% ^
	-CAcreateserial ^
	-extfile %SERVER_CERT_EXTENSIONS% ^
	-passin pass:%ROOT_CA_PASSWORD%

type %SERVER_CERT_PUBLIC_CERTIFICATE%

echo Mostrando el certificado a titulo informativo, no se requiere accion.
echo Aproveche para observar la cadena de confianza.

start %SERVER_CERT_PUBLIC_CERTIFICATE%

pause

cd %DIR%