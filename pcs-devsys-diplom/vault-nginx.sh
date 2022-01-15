#!/bin/bash

# 720h = 30 дней
# 8760h = 1 год
# 43800h = 5 лет
# cert: 87600h = 10 лет
# int: 175200h = 20 лет
# root: 262800h = 30 лет

ca_street="Irkutsk"
ca_org="GovoriAO DevOps-devsys10"
ca_ou="pcs-devsys-diplom"
ca_url="https://vault.test.local"

# Create a role test-dot-local-client
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

# Create cert, 30 дней(720 часов)
vault write -format=json pki_int_ca/issue/test-dot-local-server \
  common_name="vault.test.local" \
  alt_names="vault.test.local" \
  ttl="720h" > vault.test.local.crt

# Save cert
cat vault.test.local.crt | jq -r .data.certificate > vault.test.local.crt.pem
cat vault.test.local.crt | jq -r .data.issuing_ca >> vault.test.local.crt.pem
cat vault.test.local.crt | jq -r .data.private_key > vault.test.local.crt.key

# Copy certe to nginx directory
cp -f vault.test.local.crt.key /etc/nginx/vault/
cp -f vault.test.local.crt.pem /etc/nginx/vault/

# Restart nginx
systemctl restart nginx.service
