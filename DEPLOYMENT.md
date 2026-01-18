# Neo4j Deployment Anleitung

## Quick Start

### 1. Git Repository initialisieren

```bash
cd /Users/stevennoack/dev/neo4j-railway
git init
git add .
git commit -m "Initial commit: Neo4j for Railway"
```

### 2. Mit Railway verbinden

```bash
# Mit Railway einloggen
railway login

# Bestehendes Projekt linken
railway link d55ddd2d-62c4-4729-9f49-d46be7a6cd70

# Environment auswählen
railway environment
# Wähle: production (179bb13e-d325-45b9-95ac-7185d2d70da7)

# Service auswählen
railway service
# Wähle: neo4j (f717b6b3-52ce-477b-99ff-85ee2db03bb0)
```

### 3. Environment Variable setzen

**WICHTIG:** Ändere das Passwort!

```bash
railway variables set NEO4J_AUTH=neo4j/dein-sicheres-passwort
```

Oder im Railway Dashboard:
- Gehe zu Settings → Variables
- Klicke "New Variable"
- Key: `NEO4J_AUTH`
- Value: `neo4j/dein-sicheres-passwort`

### 4. Deployen

```bash
railway up
```

Das wird:
1. Den Dockerfile builden
2. Image zu Railway hochladen
3. Container starten mit optimierten Memory-Settings

### 5. Logs überwachen

```bash
railway logs
```

Warte bis du siehst:
```
Started.
Remote interface available at http://0.0.0.0:7474/
```

### 6. Verbindung testen

**TCP Proxy Connection:**
```
bolt://maglev.proxy.rlwy.net:11660
Username: neo4j
Password: dein-passwort
```

**HTTP Browser:**
```
http://neo4j-production-594b.up.railway.app:7474
```

## Troubleshooting

### "Container exits immediately"

Das bedeutet Memory-Problem. Reduziere weiter:

```bash
railway variables set NEO4J_server_memory_pagecache_size=128M
railway variables set NEO4J_dbms_memory_heap_max__size=384M
```

### "Could not reach Neo4j"

- Stelle sicher Port 7687 ist exposed
- Verwende `bolt://` nicht `bolt+s://`
- Teste: `nc -zv maglev.proxy.rlwy.net 11660`

### Passwort vergessen

```bash
# SSH in Container
railway ssh

# Setze neues Passwort
cypher-shell -u neo4j -p altes-passwort
CALL dbms.security.changePassword('neues-passwort');
```

## Nützliche Commands

```bash
# Status prüfen
railway status

# Logs live
railway logs --follow

# In Container SSH
railway ssh

# Service neu starten
railway redeploy

# Variables anzeigen
railway variables
```

## Memory Optimization Guide

Wenn Container immer noch crasht, passe die Werte an:

| RAM verfügbar | Pagecache | Heap Max | Heap Initial |
|---------------|-----------|----------|--------------|
| 512MB         | 128M      | 256M     | 128M         |
| 1GB           | 256M      | 512M     | 256M         |
| 2GB           | 512M      | 1G       | 512M         |

Setze in Railway Variables (doppelte Underscores beachten!):
```bash
railway variables set NEO4J_server_memory_pagecache_size=128M
railway variables set NEO4J_dbms_memory_heap_max__size=256M
railway variables set NEO4J_dbms_memory_heap_initial__size=128M
```
