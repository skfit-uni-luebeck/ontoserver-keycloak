# CSIRO Ontoserver ♥ Keycloak

## Overview

This project demonstrates how to integrate CSIRO's
[Ontoserver](https://ontoserver.csiro.au), a FHIR-based terminology server, with
Red Hat's [Keycloak](https://keycloak.org), an OpenID Connect-compliant Identity
and Access Management server.

Ontoserver relies on
[SMART-on-FHIR Backend Services Authorization](https://hl7.org/fhir/uv/bulkdata/authorization/index.html).
As the authorization/authentication specification for SMART-on-FHIR is derived
from the [OpenID Connect](https://openid.net/connect/) specification, a
"generic" authentication server that supports OAuth2 and OIDC, such as Keycloak,
can be used to authorize requests to Ontoserver.

This projects uses Docker Compose to orchestrate four services working in
tandem:

- `db`: A PostgreSQL database both for Ontoserver and Keycloak. It is not
  exposed on the public interface, but only accessible from the internal
  network.
- `ontoserver`: The Ontoserver instance that is being secured by Keycloak. It
  has security enabled and requires authentication for all API calls using
  SMART-on-FHIR.
- `keycloak`: The Keycloak authentication server and identification provider.
- `nginx`: a reverse proxy that sits in front of `ontoserver` and `keycloak`,
  which also handles TLS termination (very much recommended!)

## Getting Started

Apart from `docker` and `docker-compose` installed on your machine, you will
need a license to use Ontoserver and need to be logged into Docker Hub with your
authorized account. Please
[talk to the Ontoserver team at CSIRO](mailto:ontoserver-support@csiro.au) if
you do not hold a license for Ontoserver.

You will also need a SSL certificate chain and key in PEM format to secure calls
to your containers. The provided nginx SSL configuration assumes a
`ssl_certificate` key containing your server certificate and all required
intermediates, along with a `ssl_certicate_key` containing your private key. It
was generated using
[Mozilla's SSL Config](https://ssl-config.mozilla.org/#server=nginx&version=1.17.7&config=intermediate&openssl=1.1.1d&hsts=false&ocsp=false&guideline=5.6)
tool. For the provided SSL/TLS configuration, you will also need to either
generate or download pre-generated Diffie-Hellman Parameters. See the
`nginx/ssl.conf` for details.

When building the images in this `docker-compose` project, a number of
customizations are carried out. Most importantly, the Keycloak database and
associated user are created in the database.

In the keycloak container, this configuration assumes that two text files
`username.secret` and `password.secret` are present in `/opt/secrets/`. You must
create these files in the `keycloak` directory! They will be used to authorize
the Super-Admin of your Keycloak installation, so **make sure that they a) are
not trivial to guess and b) remain secret!**. They should _NEVER_ be added to
Git, in case you fork this repository, and are excluded using the `.gitignore`.
These files should only contain the username/password, and optionally a trailing
newline.

> Here is a checklist for the initial start-up:

- [ ] docker hub logged-in with an authorised account
- [ ] PKI certificate issued from trusted CA, private key placed at
      `nginx/certs/certificate.key`, public key _with the full certification
      chain_ at `nginx/certs/certificate-chain.pem`
- [ ] `nginx/certs/dhparam` [generated or downloaded](nginx/ssl.conf)
- [ ] username and password for Keycloak created,
      [noted securely](https://keepass.info/), added to
      `keycloak/username.secret` and `keycloak/password.secret`
