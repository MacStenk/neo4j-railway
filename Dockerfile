FROM neo4j:5.15.0-community

# Setze Umgebungsvariablen für optimierte Railway-Performance
# Total RAM Usage: ~768MB (passt in Railway Free/Hobby Tier)
ENV NEO4J_server_memory_pagecache_size=256M \
    NEO4J_dbms_memory_heap_max__size=512M \
    NEO4J_dbms_memory_heap_initial__size=256M

# Network Configuration
ENV NEO4J_server_default__listen__address=0.0.0.0 \
    NEO4J_dbms_connector_bolt_enabled=true \
    NEO4J_dbms_connector_bolt_listen__address=0.0.0.0:7687 \
    NEO4J_dbms_connector_http_enabled=true \
    NEO4J_dbms_connector_http_listen__address=0.0.0.0:7474 \
    NEO4J_dbms_connector_https_enabled=false

# Security Configuration
# OPTIONAL enables TLS - Railway's TCP Proxy can handle both
ENV NEO4J_dbms_connector_bolt_tls__level=OPTIONAL \
    NEO4J_AUTH=neo4j/changeme123

# APOC Plugin für erweiterte Graph-Operationen
RUN wget -q https://github.com/neo4j/apoc/releases/download/5.15.0/apoc-5.15.0-core.jar \
    -O /var/lib/neo4j/plugins/apoc-5.15.0-core.jar && \
    chmod 644 /var/lib/neo4j/plugins/apoc-5.15.0-core.jar

# APOC Procedures erlauben
ENV NEO4J_dbms_security_procedures_unrestricted=apoc.* \
    NEO4J_dbms_security_procedures_allowlist=apoc.*

# Expose Ports
EXPOSE 7474 7687

# Health Check
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
    CMD cypher-shell -u neo4j -p changeme123 "RETURN 1" || exit 1

# NOTE: Railway volumes must be added via Dashboard (Settings → Volumes)
# Recommended mount path: /data
# This ensures data persistence across deployments

CMD ["neo4j"]
