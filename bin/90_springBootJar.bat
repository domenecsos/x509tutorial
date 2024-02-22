@echo off

call ..\input\userCertificate.bat
call ..\input\rootCAconfig.bat
call ..\input\serverSideCertificate.bat

echo ## 4.2. Spring Boot Application
echo - https://www.baeldung.com/x-509-authentication-in-spring-security#2-spring-boot-application
echo ```
echo server.ssl.key-store=_PATH_TO_%SSL_KEYSTORE_FILE%
echo server.ssl.key-store-password=%SSL_KEYSTORE_PASS%
echo server.ssl.key-alias=%MIPC%
echo server.ssl.key-password=%SERVER_CERT_PASSWORD%
echo server.ssl.enabled=true
echo server.port=8443
echo spring.security.user.name=Admin
echo spring.security.user.password=admin
echo ```

echo ## 5.2. Spring Security Configuration
echo - https://www.baeldung.com/x-509-authentication-in-spring-security#2-spring-security-configuration
echo ```
echo    @Bean
echo    public UserDetailsService userDetailsService() {
echo        return new UserDetailsService() {
echo            @Override
echo            public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
echo                if (username.equals("%MICN%")) {
echo                    return new User(username, "", 
echo                     AuthorityUtils.commaSeparatedStringToAuthorityList("ROLE_USER"));
echo                }
echo                throw new UsernameNotFoundException("User not found!");
echo            }
echo        };
echo    }
echo ```
echo ```
echo server.ssl.trust-store=_PATH_TO_%USER_CERT_TRUSTORE%
echo server.ssl.trust-store-password=%USER_CERT_TRUSTORE_PASS%
echo server.ssl.client-auth=need
echo ```

pause

