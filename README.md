# CSIRO Ontoserver ♥ Keycloak

## Overview

This project demonstrates how to integrate CSIRO's [Ontoserver](https://ontoserver.csiro.au), a FHIR-based terminology server, with Red Hat's [Keycloak](https://keycloak.org).

Ontoserver relies on [SMART-on-FHIR Backend Services Authorization](https://hl7.org/fhir/uv/bulkdata/authorization/index.html). As the authorization/authentication specification for SMART-on-FHIR is derived from the [OpenID Connect](https://openid.net/connect/) specification, a "generic" authentication server that supports OAuth2 and OIDC, such as Keycloak, can be used to authorize requests to Ontoserver.

This projects uses Docker Compose to orchestrate four services working in tandem:
- `db`: A PostgreSQL database both for Ontoserver and Keycloak. It is not exposed on the public interface, but only accessible from the internal network.
- `ontoserver`: The Ontoserver instance that is being secured by Keycloak. It has security enabled and requires authentication for all API calls using SMART-on-FHIR.
- `keycloak`: The Keycloak authentication server and identification provider.
- `nginx`: a reverse proxy that sits in front of `ontoserver` and `keycloak`, which also handles TLS termination (very much recommended!)

## Getting Started

Apart from `docker` and `docker-compose` installed on your machine, you will need a license to use Ontoserver and need to be logged into Docker Hub with your authorized account. Pleae [refer to CSIRO](mailto:ontoserver-support@csiro.au) if you do not hold a license for Ontoserver.

You will also need a SSL certificate chain and key in PEM format to secure calls to your containers. The provided nginx SSL configuration assumes a `ssl_certificate` key containing your server certificate and all required intermediates, along with a `ssl_certicate_key` containing your private key. It was generated using [Mozilla's SSL Config](https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&hsts=false&ocsp=false&guideline=5.6) tool. For the provided SSL/TLS configuration, you will also need to either generate or download pre-generated Diffie-Hellman Parameters. See the `nginx/ssl.conf` for details.

Checklist for the initial start-up:

- [ ] docker hub logged-in
- [ ] PKI certificate issued from trusted CA, private key placed at `nginx/certs/certificate.key`, public key with the full certification chain at `nginx/certs/certificate-chain.pem`
- [ ] `nginx/certs/dhparam` generated or downloaded
- [ ] this article completed!