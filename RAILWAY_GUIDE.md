# Railway Deployment Guide

## Methode 1: GitHub Repository Deploy (Empfohlen)

### Schritt 1: Railway Dashboard öffnen

1. Gehe zu [railway.app](https://railway.app)
2. Logge dich ein (oder erstelle einen Account)
3. Klicke auf **"New Project"**

### Schritt 2: Repository verbinden

1. Wähle **"Deploy from GitHub repo"**
2. Autorisiere GitHub (falls noch nicht geschehen)
3. Suche nach: `MacStenk/neo4j-railway`
4. Klicke auf das Repository

### Schritt 3: Service konfigurieren

Railway erkennt automatisch den Dockerfile und beginnt mit dem Build.

**Wichtig:** Setze jetzt die Environment Variables!

1. Klicke auf den Service
2. Gehe zu **"Variables"** Tab
3. Klicke **"New Variable"**
4. Füge hinzu:
   ```
   Key: NEO4J_AUTH
   Value: neo4j/dein-sicheres-passwort
   ```
5. Klicke **"Add"**

### Schritt 4: Deployment abwarten

1. Gehe zurück zum **"Deployments"** Tab
2. Warte bis Status **"Success"** anzeigt (ca. 2-3 Minuten)
3. Achte auf die Logs - warte auf: `Started.`

### Schritt 5: Networking konfigurieren

1. Gehe zu **"Settings"** → **"Networking"**
2. Bei **"Public Networking"** siehst du:
   - HTTP Domain (Port 7474)
   - TCP Proxy (Port 7687)
3. **Notiere beide URLs!**

### Schritt 6: Erste Verbindung

**Via Neo4j Browser (HTTP):**
```
URL: https://neo4j-production-xxx.up.railway.app
Username: neo4j
Password: dein-passwort
```

**Via Bolt (für Anwendungen):**
```
URL: bolt://maglev.proxy.rlwy.net:xxxxx
Username: neo4j
Password: dein-passwort
```

---

## Methode 2: Railway CLI Deploy

### Voraussetzungen

```bash
# Railway CLI installieren
npm install -g @railway/cli

# Einloggen
railway login
```

### Deployment

```bash
# Repository klonen
git clone https://github.com/MacStenk/neo4j-railway.git
cd neo4j-railway

# Railway Projekt erstellen
railway init
# Wähle: "Create new project"

# Environment Variable setzen
railway variables set NEO4J_AUTH=neo4j/dein-sicheres-passwort

# Deployen
railway up

# Logs überwachen
railway logs --follow
```

---

## Methode 3: Fork & Deploy

### Schritt 1: Fork erstellen

1. Gehe zu: https://github.com/MacStenk/neo4j-railway
2. Klicke oben rechts auf **"Fork"**
3. Wähle deinen Account
4. Fork wird erstellt

### Schritt 2: In Railway deployen

1. Gehe zu [railway.app](https://railway.app)
2. **"New Project"** → **"Deploy from GitHub repo"**
3. Wähle **dein geforktes Repository**
4. Railway startet automatisch den Build

### Schritt 3: Konfigurieren

Folge Schritt 3-6 von Methode 1 (Environment Variables, Networking, etc.)

---

## Post-Deployment Konfiguration

### Memory Anpassungen (Optional)

**Für Railway Trial (512MB RAM):**
```bash
railway variables set NEO4J_server_memory_pagecache_size=128M
railway variables set NEO4J_dbms_memory_heap_max__size=384M
railway variables set NEO4J_dbms_memory_heap_initial__size=128M
railway redeploy
```

**Für Railway Hobby (1GB RAM):**
```bash
railway variables set NEO4J_server_memory_pagecache_size=512M
railway variables set NEO4J_dbms_memory_heap_max__size=1G
railway variables set NEO4J_dbms_memory_heap_initial__size=512M
railway redeploy
```

### Passwort ändern (nach Deployment)

```bash
# SSH in Container
railway ssh

# Cypher Shell öffnen
cypher-shell -u neo4j -p altes-passwort

# Passwort ändern
CALL dbms.security.changePassword('neues-passwort');
:exit

# Variable aktualisieren
railway variables set NEO4J_AUTH=neo4j/neues-passwort
```

---

## Troubleshooting Railway

### "Deployment failed" während Build

**Ursache:** Build-Timeout oder Netzwerkfehler

**Lösung:**
```bash
# Neu deployen
railway redeploy

# Oder via CLI
railway up --force
```

### Container startet und stoppt sofort

**Ursache:** Nicht genug RAM

**Lösung:**
```bash
# Memory reduzieren
railway variables set NEO4J_server_memory_pagecache_size=128M
railway variables set NEO4J_dbms_memory_heap_max__size=384M
railway redeploy
```

### "Unhealthy" Status

**Ursache:** Health Check schlägt fehl

**Lösung:**
```bash
# Logs prüfen
railway logs

# SSH in Container
railway ssh

# Neo4j Status prüfen
ps aux | grep neo4j
curl http://localhost:7474
```

### Ports nicht erreichbar

**Ursache:** Networking nicht konfiguriert

**Lösung:**
1. Settings → Networking
2. Prüfe ob beide Ports exposed sind
3. Falls nicht: Service neu deployen

---

## Railway Dashboard Navigation

```
Project Dashboard
├── Deployments (Build-Status & Logs)
├── Variables (Environment Variables)
├── Settings
│   ├── General (Service Name, Region)
│   ├── Networking (Domains & Ports)
│   ├── Deploy (Restart Policy)
│   └── Danger Zone (Delete Service)
├── Observability (Metrics & Logs)
└── Logs (Live Logs)
```

---

## Best Practices

### 1. Environment Variables

**DO:**
- Verwende Railway Variables für Passwörter
- Setze `NEO4J_AUTH` vor dem ersten Start
- Dokumentiere Custom Variables

**DON'T:**
- Hardcode Passwörter im Dockerfile
- Commite .env Dateien zu Git
- Verwende default Passwörter in Production

### 2. Resource Management

**DO:**
- Starte mit default Settings (768MB)
- Monitore RAM Usage im Dashboard
- Upgrade Plan bei Bedarf

**DON'T:**
- Setze Memory höher als verfügbar
- Ignoriere "Out of Memory" Errors
- Lasse Service im Trial unbegrenzt laufen

### 3. Security

**DO:**
- Ändere Passwort nach Deployment
- Verwende starke Passwörter (16+ Zeichen)
- Aktiviere 2FA für Railway Account

**DON'T:**
- Verwende `changeme123` in Production
- Teile Credentials öffentlich
- Deaktiviere Authentication

---

## Weiterführende Links

- [Railway Docs](https://docs.railway.app/)
- [Neo4j Docs](https://neo4j.com/docs/)
- [GitHub Repository](https://github.com/MacStenk/neo4j-railway)
- [Railway Discord](https://discord.gg/railway)

---

## Deployment Checklist

- [ ] Railway Account erstellt
- [ ] GitHub autorisiert (für Methode 1 & 3)
- [ ] Repository verbunden/geklont
- [ ] `NEO4J_AUTH` Variable gesetzt
- [ ] Deployment erfolgreich (Status: Success)
- [ ] Container läuft (Logs zeigen "Started.")
- [ ] HTTP Domain notiert
- [ ] TCP Proxy Port notiert
- [ ] Erste Verbindung erfolgreich
- [ ] Passwort geändert (nach Test)
- [ ] Backup-Strategie definiert
