# Neo4j auf Railway - Fresh Start

Optimierte Neo4j 5.15.0 Installation für Railway.

## 🚀 Quick Deployment

### 1. Neues Railway-Projekt erstellen

```bash
cd /Users/stevennoack/dev/neo4j-railway

# Git initialisieren
git init
git add .
git commit -m "Initial Neo4j Railway setup"

# Railway CLI
railway login
railway init
# Wähle: Create new project
# Name: neo4j-production
```

### 2. Environment Variables setzen

**WICHTIG:** Ändere das Default-Passwort!

Im Railway Dashboard oder via CLI:

```bash
# Passwort ändern (WICHTIG!)
railway variables set NEO4J_AUTH=neo4j/dein-sicheres-passwort
```

### 3. Deploy

```bash
railway up
```

### 4. Ports konfigurieren

Nach dem ersten Deployment:

1. Gehe zu Railway Dashboard → dein Service
2. **Settings → Networking → Public Networking**
3. Klicke auf "+ Add Domain" für Port 7474 (HTTP Browser)
4. **TCP Proxy** sollte automatisch für Port 7687 erstellt werden

### 5. Verbindung testen

**Via Neo4j Browser (HTTP):**
```
http://deine-railway-domain.railway.app
```

**Via Bolt (TCP Proxy):**
```
bolt://proxy-domain.railway.app:PORT
Username: neo4j
Password: dein-passwort
```

## 📊 Memory Configuration

Aktuelle Einstellungen (gesamt ~768MB):
- Pagecache: 256MB
- Heap Max: 512MB  
- Heap Initial: 256MB

Passt perfekt in:
- Railway Hobby Plan (1GB RAM)
- Railway Trial (512MB RAM mit etwas Puffer)

## 🔧 Troubleshooting

### Container startet nicht

```bash
# Logs checken
railway logs

# Häufige Probleme:
# 1. Zu wenig RAM → Memory-Limits reduzieren
# 2. Port-Konflikte → Ports in Railway Settings prüfen
```

### Memory zu hoch

Falls der Container crasht, reduziere die Limits:

```bash
railway variables set NEO4J_server_memory_pagecache_size=128M
railway variables set NEO4J_dbms_memory_heap_max__size=384M
railway variables set NEO4J_dbms_memory_heap_initial__size=128M
```

### Verbindung schlägt fehl

1. **Für Neo4j Browser:** Nutze die HTTP-Domain (Port 7474)
2. **Für Bolt:** Nutze `bolt://` (NICHT `bolt+s://`) mit TCP Proxy
3. **Test:** `nc -zv proxy-domain.railway.app PORT`

## 🎯 Features

✅ Neo4j 5.15.0 Community Edition
✅ APOC Plugin vorinstalliert
✅ Memory-optimiert für Railway
✅ TLS deaktiviert (einfacher für Development)
✅ Health Check integriert
✅ Bolt & HTTP aktiviert

## 🔐 Sicherheit

⚠️ **WICHTIG:** Das Default-Passwort `changeme123` MUSS geändert werden!

```bash
railway variables set NEO4J_AUTH=neo4j/ein-starkes-passwort
railway redeploy
```

## 📝 Nützliche Commands

```bash
# Status
railway status

# Logs live
railway logs --follow

# SSH in Container
railway ssh

# Neu deployen
railway redeploy

# Variables anzeigen
railway variables

# Service löschen
railway down
```

## 🌐 Nach dem Deployment

1. Notiere dir die **Railway Domain** (z.B. `neo4j-production-xxx.up.railway.app`)
2. Notiere dir den **TCP Proxy Port** (z.B. `proxy.railway.app:12345`)
3. Teste die Verbindung im Neo4j Browser
4. Ändere das Passwort!

## 💡 Best Practices

- Verwende Railway Environment Variables für Secrets
- Backup regelmäßig mit `neo4j-admin dump`
- Monitoring über Railway Dashboard
- Skaliere Ressourcen bei Bedarf im Railway Plan
