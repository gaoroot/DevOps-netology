#!/bin/bash

# 720h = 30 дней
# 8760h = 1 год
# 43800h = 5 лет
# cert: 87600h = 10 лет
# int: 175200h = 20 лет
# root: 262800h = 30 лет

ca_street="Irkutsk"
ca_org="Home DevOps-devsys10"
ca_ou="pcs-devsys-diplom"
ca_url="https://vault.test.local"

# enable Vault PKI secret
vault secrets enable \
  -path=pki_root_ca \
  -description="PKI Root CA" \
  -max-lease-ttl="262800h" \
  pki

# generate root CA
vault write -format=json pki_root_ca/root/generate/internal \
  common_name="Root Certificate Authority" \
  country="Russian Federation" \
  locality="Irkutsk" \
  street_address="$ca_street" \
  postal_code="664046" \
  organization="$ca_org" \
  ou="$ca_ou" \
  ttl="262800h" > pki-root-ca.json

# save the certificate
cat pki-root-ca.json | jq -r .data.certificate > rootCA.pem

# publish urls for the root ca
vault write pki_root_ca/config/urls \
  issuing_certificates="$ca_url/v1/pki_root_ca/ca" \
  crl_distribution_points="$ca_url/v1/pki_root_ca/crl"

# enable Vault PKI secret
vault secrets enable \
  -path=pki_int_ca \
  -description="PKI Intermediate CA" \
  -max-lease-ttl="175200h" \
  pki

# create intermediate CA with common name test.local and save the CSR
vault write -format=json pki_int_ca/intermediate/generate/internal \
  common_name="Intermediate Certificate Authority" \
  country="Russian Federation" \
  locality="Irkutsk" \
  street_address="$ca_street" \
  postal_code="664046" \
  organization="$ca_org" \
  ou="$ca_ou" \
  ttl="175200h" | jq -r '.data.csr' > pki_intermediate_ca.csr

# send the intermediate CA's CSR to the root CA
vault write -format=json pki_root_ca/root/sign-intermediate csr=@pki_intermediate_ca.csr \
  country="Russia Federation" \
  locality="Irkutsk" \
  street_address="$ca_street" \
  postal_code="664046" \
  organization="$ca_org" \
  ou="$ca_ou" \
  format=pem_bundle \
  ttl="175200h" | jq -r '.data.certificate' > intermediateCA.cert.pem

# publish the signed certificate back to the Intermediate CA
vault write pki_int_ca/intermediate/set-signed \
  certificate=@intermediateCA.cert.pem

# publish the intermediate CA urls ???
vault write pki_int_ca/config/urls \
  issuing_certificates="$ca_url/v1/pki_int_ca/ca" \
  crl_distribution_points="$ca_url/v1/pki_int_ca/crl"

# create a role test-dot-local-server
vault write pki_int_ca/roles/test-dot-local-server \
  country="Russia Federation" \
  locality="Irkutsk" \
  street_address="$ca_street" \
  postal_code="664046" \
  organization="$ca_org" \
  ou="$ca_ou" \
  allowed_domains="test.local" \
  allow_subdomains=true \
  max_ttl="87600h" \
  key_bits="2048" \
  key_type="rsa" \
  allow_any_name=false \
  allow_bare_domains=false \
  allow_glob_domain=false \
  allow_ip_sans=true \
  allow_localhost=false \
  client_flag=false \
  server_flag=true \
  enforce_hostnames=true \
  key_usage="DigitalSignature,KeyEncipherment" \
  ext_key_usage="ServerAuth" \
  require_cn=true

# create a role test-dot-local-client
vault write pki_int_ca/roles/test-dot-local-client \
  country="Russia Federation" \
  locality="Irkutsk" \
  street_address="$ca_street" \
  postal_code="664046" \
  organization="$ca_org" \
  ou="$ca_ou" \
  allow_subdomains=true \
  max_ttl="87600h" \
  key_bits="2048" \
  key_type="rsa" \
  allow_any_name=true \
  allow_bare_domains=false \
  allow_glob_domain=false \
  allow_ip_sans=false \
  allow_localhost=false \
  client_flag=true \
  server_flag=false \
  enforce_hostnames=false \
  key_usage="DigitalSignature" \
  ext_key_usage="ClientAuth" \
  require_cn=true

# Create cert, 1 month(720 hours)
vault write -format=json pki_int_ca/issue/test-dot-local-server \
  common_name="vault.test.local" \
  alt_names="vault.test.local" \
  ttl="720h" > vault.test.local.crt

# save cert
cat vault.test.local.crt | jq -r .data.certificate > vault.test.local.crt.pem
cat vault.test.local.crt | jq -r .data.issuing_ca >> vault.test.local.crt.pem
cat vault.test.local.crt | jq -r .data.private_key > vault.test.local.crt.key