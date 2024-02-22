# Autenticación mutua TLS (mTLS) en aplicaciones SringBoot desplegadas como jar o war

Este conjunto de documentos discute la autenticación mutua TLS (mTLS) en aplicaciones SringBoot desplegadas como jar o war,
relatando las diversas pruebas de concepto efectuadas.

Las pruebas de concepto son:

- [Creación de certificados y keystores para entornos de desarrollo](10.CA-certs.md)
- [Configuración de una aplicación SpringBoot para mTLS ejecutada como jar](20.springBootJar.md)
- [Configuración de una aplicación SpringBoot desplegada como war en un Tomcat con mTLS](todo.md)
- [Configuración de una aplicación SpringBoot desplegada como war en un JBoss con mTLS](todo.md)
- [Configuración de una aplicación SpringBoot jar/war detrás de un Apache con mTLS](todo.md)

## Conceptos

Para trabar con SSL, certificados y autenticación mutua mTLS es necesario manejar diversos conceptos sobre:

- Criptografía de clave pública y privada.
- Certificados e infraestructura de clave pública y privada, estándar X.509.
- Herramientas para el manejo de certificados en aplicaciones Java (keystores \*.jks).
- Almacenamiento de certificados en el navegador del usuario.

Antes que hacer aquí una tesis, se intentará explicar muy someramente los conceptos a medida que se hagan operaciones en las pruebas de concepto, intentando que sea un *learn by example*.



