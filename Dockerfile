FROM python:3.9-slim

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    uuid-runtime \
    --no-install-recommends

WORKDIR /app

# Criar link simbólico para garantir o acesso ao bundle de certificados no caminho esperado
RUN mkdir -p /etc/pki/tls/certs && ln -sf /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt

ENV CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

COPY tests/ ./tests/

COPY entrypoint.sh /app/

RUN pip install pyresttest pycurl

RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
