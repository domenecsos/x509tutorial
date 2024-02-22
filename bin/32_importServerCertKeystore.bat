@echo off
set DIR=%cd%
echo Importa el certificado público y la clave privada del servidor en un keystore \*.jks que Java pueda manejar.
echo La importacion usa un fichero PKCS#12 intermedio para contener los dos ficheros

type ..\input\serverSideCertificate.bat
call ..\input\serverSideCertificate.bat
pause

rem Pragmatismo, mejor ir directamente al directorio de output
cd ..\output\

IF EXIST %SSL_KEYSTORE_FILE% DEL /F %SSL_KEYSTORE_FILE%
IF EXIST %SSL_PKCS12_NAME% DEL /F %SSL_PKCS12_NAME%

echo We'll use the PKCS 12 archive, to package our server's private key together with the signed certificate. Then we'll import it to the newly created keystore.jks.

echo We can use the following command to create a .p12 file:

echo -
echo Ejecutando
echo openssl pkcs12 -export -out %SSL_PKCS12_FILE% -name "%SSL_PKCS12_NAME%" -inkey %SERVER_CERT_PRIVATE_KEY% -in %SERVER_CERT_PUBLIC_CERTIFICATE% -passin pass:%SERVER_CERT_PASSWORD% -passout pass:%SSL_PKCS12_PASS%
echo -

openssl pkcs12 ^
	-export -out %SSL_PKCS12_FILE% ^
	-name "%SSL_PKCS12_NAME%" ^
	-inkey %SERVER_CERT_PRIVATE_KEY% ^
	-in %SERVER_CERT_PUBLIC_CERTIFICATE% ^
	-passin pass:%SERVER_CERT_PASSWORD% ^
	-passout pass:%SSL_PKCS12_PASS%

pause
echo So we now have the localhost.key and the localhost.crt bundled in the single localhost.p12 file.

dir %SSL_PKCS12_FILE% | findstr "%SSL_PKCS12_FILE%"

echo Es un fichero binario

pause

echo Let's now use keytool to create a keystore.jks repository and import the localhost.p12 file with a single command:

echo -
echo Ejecutando
echo keytool -importkeystore -srcstoretype PKCS12 -srckeystore %SSL_PKCS12_FILE% -srcstorepass %SSL_PKCS12_PASS% -deststoretype JKS -destkeystore %SSL_KEYSTORE_FILE% -deststorepass %SSL_KEYSTORE_PASS%
echo -

keytool -importkeystore ^
	-srcstoretype PKCS12 ^
	-srckeystore %SSL_PKCS12_FILE% ^
	-srcstorepass %SSL_PKCS12_PASS% ^
	-deststoretype JKS ^
	-destkeystore %SSL_KEYSTORE_FILE% ^
	-deststorepass %SSL_KEYSTORE_PASS%

pause

echo At this stage, we have everything in place for the server authentication part. Let's proceed with our Spring Boot application configuration.

echo -
echo Ejecutando
echo keytool -list -v -keystore %SSL_KEYSTORE_FILE% -storepass %SSL_KEYSTORE_PASS%
echo -

keytool -list -v ^
	-keystore %SSL_KEYSTORE_FILE% ^
	-storepass %SSL_KEYSTORE_PASS%

pause

cd %DIR%