@echo off

echo Creando truststore para certificado de CA raiz con la configuracion de input\userCertificate.bat
type ..\input\userCertificate.bat
call ..\input\userCertificate.bat

pause

echo Usando tambien la configuracion de input\rootCAconfig.bat
type ..\input\rootCAconfig.bat
call ..\input\rootCAconfig.bat

pause

set DIR=%CD%
cd ..\output\

IF EXIST %USER_CERT_TRUSTORE% DEL /F %USER_CERT_TRUSTORE%

echo -
echo No ejecutado por no ver el sentido:
echo    	-ext san=dns:localhost,ip:127.0.0.1 
echo -
echo Ejecutando
echo keytool -import -trustcacerts -noprompt -alias ca -file %ROOT_CA_PUBLIC_CERTIFICATE% -keystore %USER_CERT_TRUSTORE% -deststorepass %USER_CERT_TRUSTORE_PASS%
echo -

keytool -import ^
	-trustcacerts ^
	-noprompt ^
	-alias ca ^
	-file %ROOT_CA_PUBLIC_CERTIFICATE% ^
	-keystore %USER_CERT_TRUSTORE% ^
	-deststorepass %USER_CERT_TRUSTORE_PASS%

pause

echo -
echo Ejecutando
keytool -list -v -keystore %USER_CERT_TRUSTORE% -storepass %USER_CERT_TRUSTORE_PASS%
echo -

keytool -list -v ^
	-keystore %USER_CERT_TRUSTORE% ^
	-storepass %USER_CERT_TRUSTORE_PASS%

pause 
cd %DIR%
