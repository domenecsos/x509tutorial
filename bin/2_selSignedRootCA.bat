@echo off

echo Creando certificado y clave privada de CA raiz con la configuracion de input\rootCAconfig.bat
type ..\input\rootCAconfig.bat
call ..\input\rootCAconfig.bat

set ROOT_CA_SUBJECT=/CN=%ROOT_CA_CN%/emailAddress=%ROOT_CA_emailAddress%/C=%ROOT_CA_C%/ST=%ROOT_CA_ST%/L=%ROOT_CA_L%/O=%ROOT_CA_O%/OU=%ROOT_CA_OU%

set DIR =%CD%
cd ..\output\

IF EXIST %ROOT_CA_PRIVATE_KEY% DEL /F %ROOT_CA_PRIVATE_KEY%
IF EXIST %ROOT_CA_PUBLIC_CERTIFICATE% DEL /F %ROOT_CA_PUBLIC_CERTIFICATE%

echo -
echo Ejecutando
echo openssl req -x509 -sha256 -days %ROOT_CA_DURATION_DAYS% -newkey rsa:%ROOT_CA_SECURITY_BITS% -subj "%ROOT_CA_SUBJECT%" -keyout %ROOT_CA_PRIVATE_KEY% -out %ROOT_CA_PUBLIC_CERTIFICATE% -passout pass:%ROOT_CA_PASSWORD%
echo -

openssl req ^
	-x509 ^
	-sha256 ^
	-days %ROOT_CA_DURATION_DAYS% ^
	-newkey rsa:%ROOT_CA_SECURITY_BITS%^
	-subj "%ROOT_CA_SUBJECT%" ^
	-keyout %ROOT_CA_PRIVATE_KEY% ^
	-out %ROOT_CA_PUBLIC_CERTIFICATE% ^
	-passout pass:%ROOT_CA_PASSWORD%

echo Clave privada
dir %ROOT_CA_PRIVATE_KEY% | find "%ROOT_CA_PRIVATE_KEY%"

echo Certificado
dir %ROOT_CA_PUBLIC_CERTIFICATE% | find "%ROOT_CA_PUBLIC_CERTIFICATE%"

echo Contenido del certificado
type %ROOT_CA_PUBLIC_CERTIFICATE%

echo -
echo Pulse para abrir el certificado
pause
echo Observe que no se confia en el (icono rojo con cruz encima)
echo Pulse Instalar certificado...
echo (o) Usuario actual, siguiente
echo (o) Colocar todos los certificados en el siguiente almacen, examinar
echo Entidades de certificacion raiz de confianza, aceptar, siguiente
echo Elija el almacen "Certificados raiz de confianza"
echo Finalizacion, finalizar
echo Si a la advertencia de seguridad, aceptar la confirmacion de importacion.
echo Despues de instalar cierre el certificado (aceptar).
start %ROOT_CA_PUBLIC_CERTIFICATE%
pause 
echo Vuelva a abrir el certificado desde el explorador y vea que ya se confia (sin cruz)
echo Cierre el certificado
start .
pause
echo Busque el certificado en las entidades raiz de confianza, certificados
echo Ejecutando certmgr.msc
start certmgr.msc
pause
echo Ejercicio final, busque el certificado en el navegador, por ejemplo
echo chrome://settings/security?search=gestionar+certificados 
echo e ir a Gestionar certificados
pause

cd %DIR%
