import logging
import json
import secrets

import boto3
from OpenSSL import crypto

KEY_SIZE = 4096
CERT_DURATION = 10*365*24*60*60
CERT_COUNTRY = "US"
CERT_PROVINCE = "CA"
CERT_LOCALITY = "Redwood City"
CERT_ORGANIZATION = "Cyral Inc."
CERT_DEFAULT_HOST = "sidecar.app.cyral.com"

logger = logging.getLogger()
logger.setLevel(logging.INFO)
secrets_client = boto3.client('secretsmanager')

def handler(event, context):
  try:
    logger.info('Received event: {}'.format(json.dumps(event)))

    secret_id = event.get('SecretId')
    if not secret_id:
      logger.error('SecretId is empty')
      return {'statusCode': 400}

    hostname = event.get('Hostname', CERT_DEFAULT_HOST)
    is_ca_certificate = event.get('IsCACertificate', False)
    update_secret_if_needed(secret_id, hostname, is_ca_certificate)
    return {'statusCode': 200}
  except Exception as e:
    logger.error('Error: {}'.format(e))
    return {'statusCode': 400}

def update_secret_if_needed(secret_id, hostname, is_ca_certificate=False):
  current_value = None
  try:
    current_value = secrets_client.get_secret_value(
      SecretId=secret_id
    ).get('SecretString')
  except secrets_client.exceptions.ResourceNotFoundException as err:
    logger.info('Secret is empty, so a new certificate will be generated')
  if current_value:
    # do not update the secret if it already has a value
    return
  key_pem, cert_pem = generate_self_signed_cert(
    hostname,
    is_ca_certificate=is_ca_certificate,
  )
  secret_string = json.dumps({
    'key':key_pem,
    'cert':cert_pem,
  })
  secrets_client.update_secret(
    SecretId=secret_id,
    SecretString=secret_string
  )

def generate_self_signed_cert(
  hostname,
  is_ca_certificate=False,
):
  key = crypto.PKey()
  key.generate_key(crypto.TYPE_RSA, KEY_SIZE)
  private_key_pem = crypto.dump_privatekey(crypto.FILETYPE_PEM, key).decode('utf-8')

  ca_cert = crypto.X509()
  ca_cert.set_version(2)
  ca_cert.set_serial_number(secrets.randbits(128))
  ca_subj = ca_cert.get_subject()
  ca_subj.C = CERT_COUNTRY
  ca_subj.ST = CERT_PROVINCE
  ca_subj.L = CERT_LOCALITY
  ca_subj.O = CERT_ORGANIZATION
  ca_cert.add_extensions([
      crypto.X509Extension(b"subjectKeyIdentifier", False, b"hash", subject=ca_cert),
  ])
  ca_cert.add_extensions([
      crypto.X509Extension(b"authorityKeyIdentifier", False, b"keyid:always", issuer=ca_cert),
  ])
  ca_cert.add_extensions([
      crypto.X509Extension(b"basicConstraints", False, b"CA:TRUE"),
      crypto.X509Extension(b"keyUsage", False, b"keyCertSign, cRLSign"),
  ])
  ca_cert.set_issuer(ca_subj)
  ca_cert.set_pubkey(key)
  ca_cert.sign(key, 'sha256')
  ca_cert.gmtime_adj_notBefore(0)
  ca_cert.gmtime_adj_notAfter(CERT_DURATION)
  ca_certificate_pem = crypto.dump_certificate(crypto.FILETYPE_PEM, ca_cert).decode('utf-8')
  if is_ca_certificate:
    return (private_key_pem, ca_certificate_pem)

  # Create Self-Signed Certificate
  client_cert = crypto.X509()
  client_cert.set_version(2)
  client_cert.set_serial_number(secrets.randbits(128))
  client_subj = client_cert.get_subject()
  client_subj.C = CERT_COUNTRY
  client_subj.ST = CERT_PROVINCE
  client_subj.L = CERT_LOCALITY
  client_subj.O = CERT_ORGANIZATION
  client_subj.CN = hostname
  client_cert.add_extensions([
      crypto.X509Extension(b"basicConstraints", False, b"CA:FALSE"),
      crypto.X509Extension(b"subjectKeyIdentifier", False, b"hash", subject=client_cert),
  ])
  client_cert.add_extensions([
      crypto.X509Extension(b"authorityKeyIdentifier", False, b"keyid:always", issuer=ca_cert),
      crypto.X509Extension(b"extendedKeyUsage", False, b"serverAuth"),
      crypto.X509Extension(b"keyUsage", False, b"digitalSignature"),
  ])
  client_cert.add_extensions([
      crypto.X509Extension(b'subjectAltName', False,
          ','.join([
              f'DNS:*.{hostname}'
  ]).encode())])
  client_cert.set_issuer(ca_subj)
  client_cert.set_pubkey(key)
  client_cert.gmtime_adj_notBefore(0)
  client_cert.gmtime_adj_notAfter(CERT_DURATION)
  client_cert.sign(key, 'sha256')
  certifictate_pem = crypto.dump_certificate(crypto.FILETYPE_PEM, client_cert).decode('utf-8')

  return (private_key_pem, certifictate_pem)
