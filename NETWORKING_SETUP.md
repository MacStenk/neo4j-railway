# 🌐 Railway Networking Setup - MANDATORY

## Nach dem ersten erfolgreichen Deployment MUSST du das Networking konfigurieren!

### Schritt 1: Generate Domain (HTTP - Port 7474)

1. Gehe zu **Settings → Networking**
2. Unter **"Public Networking"** klicke **"Generate Domain"**
3. Railway erstellt automatisch: `neo4j-production-xxx.up.railway.app`
4. ✅ Diese URL ist für den **Neo4j Browser** (Port 7474)

### Schritt 2: TCP Proxy (Bolt - Port 7687)

1. In **"Public Networking"** klicke **"+ TCP Proxy"**
2. Port eingeben: **7687**
3. Railway erstellt: `maglev.proxy.rlwy.net:XXXXX`
4. ✅ Diese URL ist für **Bolt-Verbindungen** (Apps/Tools)

---

## 📋 Nach Setup hast du:

### HTTP Domain (Neo4j Browser)
```
URL: https://neo4j-production-xxx.up.railway.app
Port: 7474
Verwendung: Im Browser öffnen → Neo4j Browser UI
```

### TCP Proxy (Bolt Protocol)
```
URL: bolt://maglev.proxy.rlwy.net:12345
Port: 7687 (gemappt auf Railway Port)
Verwendung: Für Anwendungen, Cypher-Shell, Neo4j Desktop
```

---

## 🔗 Verbindung testen

### Via Browser (HTTP):
1. Öffne: `https://deine-domain.up.railway.app`
2. Login:
   - Username: `neo4j`
   - Password: (dein gesetztes Passwort)
3. ✅ Sollte Neo4j Browser zeigen

### Via Bolt (z.B. Neo4j Desktop):
1. Add Database
2. URL: `bolt://maglev.proxy.rlwy.net:DEIN_PORT`
3. Username: `neo4j`
4. Password: (dein Passwort)
5. ✅ Connect

---

## ⚠️ Wichtig zu wissen:

### HTTP vs Bolt:
- **HTTP (7474)**: Nur für Neo4j Browser UI
- **Bolt (7687)**: Für alle anderen Tools & Apps

### Custom Domain (Optional):
Klicke auf **"+ Custom Domain"** wenn du eine eigene Domain verwenden willst:
- z.B.: `neo4j.deine-domain.de`
- Benötigt DNS-Konfiguration (CNAME)

### Private Networking:
- `neo4j-railway.railway.internal` ist nur **innerhalb** des Railway-Netzwerks erreichbar
- Verwende für externe Verbindungen die Public URLs!

---

## 🧪 Test-Commands

### HTTP testen:
```bash
curl https://neo4j-production-xxx.up.railway.app
# Sollte Neo4j Antwort zurückgeben
```

### Bolt testen:
```bash
# Mit nc (netcat)
nc -zv maglev.proxy.rlwy.net DEIN_PORT

# Mit telnet
telnet maglev.proxy.rlwy.net DEIN_PORT
```

---

## 📖 Zusammenfassung:

1. ✅ **Generate Domain** → HTTP-Zugriff
2. ✅ **+ TCP Proxy (Port 7687)** → Bolt-Zugriff
3. ✅ Beide URLs notieren
4. ✅ Testen!

**Ohne diese Setup-Schritte ist Neo4j NICHT von außen erreichbar!**
