# 🚀 Quick Start - Neo4j auf Railway

## Option 1: Automatisches Deployment (Empfohlen)

```bash
cd /Users/stevennoack/dev/neo4j-railway
chmod +x deploy.sh
./deploy.sh
```

Das Script macht automatisch:
- ✅ Git initialisieren
- ✅ Railway Projekt erstellen
- ✅ Passwort setzen
- ✅ Deployment starten

## Option 2: Manuelles Deployment

### Schritt 1: Git Setup
```bash
cd /Users/stevennoack/dev/neo4j-railway
git init
git add .
git commit -m "Initial commit"
```

### Schritt 2: Railway Setup
```bash
railway login
railway init
# Wähle: "Create new project"
# Name: neo4j-production (oder dein Wunschname)
```

### Schritt 3: Passwort setzen
```bash
railway variables set NEO4J_AUTH=neo4j/dein-sicheres-passwort
```

### Schritt 4: Deploy
```bash
railway up
```

### Schritt 5: Logs checken
```bash
railway logs --follow
```

Warte bis du siehst:
```
Started.
Remote interface available at http://0.0.0.0:7474/
```

## 🌐 Nach dem Deployment

### 1. Railway Dashboard öffnen
```bash
railway open
```

### 2. Domain & Ports notieren

Im Dashboard unter **Settings → Networking**:

- **HTTP Domain** (Port 7474): `neo4j-production-xxx.railway.app`
- **TCP Proxy** (Port 7687): `maglev.proxy.rlwy.net:xxxxx`

### 3. Mit Neo4j Browser verbinden

**Option A: HTTP Browser**
```
URL: http://neo4j-production-xxx.railway.app
Username: neo4j
Password: dein-passwort
```

**Option B: Bolt Connection (für externe Tools)**
```
URL: bolt://maglev.proxy.rlwy.net:xxxxx
Username: neo4j
Password: dein-passwort
```

⚠️ **WICHTIG:** Verwende `bolt://` (NICHT `bolt+s://`)!

## 🔍 Troubleshooting

### Container startet nicht?
```bash
railway logs

# Falls "Out of Memory":
railway variables set NEO4J_server_memory_pagecache_size=128M
railway variables set NEO4J_dbms_memory_heap_max__size=384M
railway redeploy
```

### Verbindung schlägt fehl?
```bash
# Teste TCP Proxy
nc -zv maglev.proxy.rlwy.net DEIN_PORT

# Prüfe ob Service läuft
railway status
```

### Passwort vergessen?
```bash
railway ssh
cypher-shell -u neo4j -p altes-passwort
# In Cypher Shell:
CALL dbms.security.changePassword('neues-passwort');
```

## 📊 Wichtige Commands

```bash
# Logs anzeigen
railway logs

# Status prüfen  
railway status

# SSH in Container
railway ssh

# Neu deployen
railway redeploy

# Dashboard öffnen
railway open

# Variables anzeigen
railway variables
```

## ✅ Success Checklist

- [ ] Railway CLI installiert (`npm install -g @railway/cli`)
- [ ] Railway Account erstellt
- [ ] Git Repository initialisiert
- [ ] Railway Projekt erstellt
- [ ] Passwort in Variables gesetzt
- [ ] Deployment erfolgreich (`railway up`)
- [ ] Container läuft (siehe `railway logs`)
- [ ] HTTP Domain funktioniert
- [ ] TCP Proxy Port notiert
- [ ] Verbindung mit Neo4j Browser erfolgreich

## 🎯 Next Steps

1. **Teste die Verbindung:**
   ```cypher
   CREATE (n:TestNode {name: 'Hello Railway'}) RETURN n;
   ```

2. **Erkunde APOC:**
   ```cypher
   CALL apoc.help("apoc");
   ```

3. **Backup erstellen:**
   ```bash
   railway ssh
   neo4j-admin database dump neo4j
   ```

## 💡 Tipps

- Nutze Railway Environment Variables für alle Secrets
- Aktiviere automatische Backups (Railway Add-ons)
- Monitore RAM-Nutzung im Railway Dashboard
- Upgraden zu Hobby Plan für mehr Stabilität (1GB RAM statt 512MB)

Viel Erfolg! 🚀
