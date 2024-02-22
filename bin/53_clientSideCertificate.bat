@echo off

echo Creando e instalando certificado de usuario con la configuracion de input\userCertificate.bat
type ..\input\userCertificate.bat
call ..\input\userCertificate.bat

pause

echo Usando tambien la configuracion de input\rootCAconfig.bat
type ..\input\rootCAconfig.bat
call ..\input\rootCAconfig.bat

pause

set DIR=%CD%
cd ..\output\

IF EXIST %USER_CERT_PRIVATE_KEY% DEL /F %USER_CERT_PRIVATE_KEY%
IF EXIST %USER_CERT_SIGNATURE_REQUEST% DEL /F %USER_CERT_SIGNATURE_REQUEST%
IF EXIST %USER_CERT_PUBLIC_CERTIFICATE% DEL /F %USER_CERT_PUBLIC_CERTIFICATE%
IF EXIST %USER_CERT_PKCS12_FILE% DEL /F %USER_CERT_PKCS12_FILE%

set USER_CERT_SUBJECT=/CN=%USER_CERT_CN%/emailAddress=%USER_CERT_emailAddress%/C=%USER_CERT_C%/ST=%USER_CERT_ST%/L=%USER_CERT_L%/O=%USER_CERT_O%/OU=%USER_CERT_OU%

echo Creacion de clave privada y CSR del usuario

echo -
echo Ejecutando
echo openssl req -new -newkey rsa:%USER_CERT_SECURITY_BITS% -subj "%USER_CERT_SUBJECT%" -nodes -keyout %USER_CERT_PRIVATE_KEY% -out %USER_CERT_SIGNATURE_REQUEST% -passout pass:%USER_CERT_PASSWORD%
echo -

openssl req -new ^
	-newkey rsa:%USER_CERT_SECURITY_BITS% ^
	-subj "%USER_CERT_SUBJECT%" ^
	-nodes ^
	-keyout %USER_CERT_PRIVATE_KEY% ^
	-out %USER_CERT_SIGNATURE_REQUEST% ^
	-passout pass:%USER_CERT_PASSWORD%

dir %USER_CERT_PRIVATE_KEY% | findstr "%USER_CERT_PRIVATE_KEY%"
dir %USER_CERT_SIGNATURE_REQUEST% | findstr "%USER_CERT_SIGNATURE_REQUEST%"

pause

echo Firma por la root CA del certificado de usuario.

echo -
echo Ejecutando
echo openssl x509 -req -CA %ROOT_CA_PUBLIC_CERTIFICATE% -CAkey %ROOT_CA_PRIVATE_KEY% -in %USER_CERT_SIGNATURE_REQUEST% -out %USER_CERT_PUBLIC_CERTIFICATE% -days %USER_CERT_DURATION_DAYS% -CAcreateserial -passin pass:%ROOT_CA_PASSWORD%
echo -

openssl x509 -req ^
	-CA %ROOT_CA_PUBLIC_CERTIFICATE% ^
	-CAkey %ROOT_CA_PRIVATE_KEY% ^
	-in %USER_CERT_SIGNATURE_REQUEST% ^
	-out %USER_CERT_PUBLIC_CERTIFICATE% ^
	-days %USER_CERT_DURATION_DAYS% ^
	-CAcreateserial ^
	-passin pass:%ROOT_CA_PASSWORD%

dir %USER_CERT_PUBLIC_CERTIFICATE% | findstr "%USER_CERT_PUBLIC_CERTIFICATE%"

pause

start %USER_CERT_PUBLIC_CERTIFICATE%

echo Observe el certificado (sujeto y cadena de confianza). 
echo No se necesita accion.
echo  Aceptar.

pause 

echo Empaquetando certificado y clave privada en un PKCS#12 *.p12

echo -
echo Ejecutando
echo openssl pkcs12 -export -out %USER_CERT_PKCS12_FILE% -name "%USER_CERT_PKCS12_NAME%" -inkey %USER_CERT_PRIVATE_KEY% -in %USER_CERT_PUBLIC_CERTIFICATE% -passout pass:%USER_CERT_PKCS12_PASS%
echo -

openssl pkcs12 ^
	-export ^
	-out %USER_CERT_PKCS12_FILE% ^
	-name "%USER_CERT_PKCS12_NAME%" ^
	-inkey %USER_CERT_PRIVATE_KEY% ^
	-in %USER_CERT_PUBLIC_CERTIFICATE% ^
	-passout pass:%USER_CERT_PKCS12_PASS%

dir %USER_CERT_PKCS12_FILE% | findstr "%USER_CERT_PKCS12_FILE%"

echo La password del *.p12 (%USER_CERT_PKCS12_PASS%) debe coincidir con la password de la clave provada (%USER_CERT_PASSWORD%) para evitar problemas.

pause

echo Instale el PKCS#12 %USER_CERT_PKCS12_FILE%.

start %USER_CERT_PKCS12_FILE%

echo (o) Usuario actual, siguiente
echo Nombre de archivo = path completo a %USER_CERT_PKCS12_FILE%, siguiente
echo Contraseña %USER_CERT_PKCS12_PASS%, no es necesario cambiar las opciones [ ], siguiente.
echo (o) Colocar todos los certificados en el siguiente almacen, examinar. 
echo Personal, aceptar.
echo Siguiente.
echo Finalizacion del asistente: Personal, PFX, path a %USER_CERT_PKCS12_FILE%
echo Finalizar.
echo Importacion de una nueva clave de intercambio. CiberSeguridad?
echo Nivel de seguridad...
echo Contraseña para, anotar el valor o poner uno que tenga sentido. Desconocido.
echo Dar y confirmar una contraseña "segura".
echo Aceptar
echo La importacion se realizo completamente. Aceptar.

pause

echo Busque el certificado en los Personales, certificados
echo Ejecutando certmgr.msc
start certmgr.msc
pause
echo Ejercicio final, busque el certificado en el navegador, por ejemplo
echo chrome://settings/security?search=gestionar+certificados 
echo e ir a Gestionar certificados

pause
cd %DIR%
