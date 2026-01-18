# Volume Setup für Datenpersistenz

## Warum ein Volume?

Ohne Volume gehen alle Neo4j-Daten verloren, wenn:
- Der Container neu startet
- Ein Redeploy durchgeführt wird
- Railway den Service verschiebt

## Railway Volume einrichten

### Methode 1: Bei der ersten Einrichtung

1. **Deployment starten** (lasse es durchlaufen)
2. **Gehe zu Settings → Volumes**
3. **Klicke "+ New Volume"**
4. **Konfiguration:**
   - Name: `neo4j-data`
   - Mount Path: `/data`
   - Size: 1GB (oder mehr, je nach Bedarf)
5. **Klicke "Add"**
6. **Service redeploy:** Railway startet automatisch neu

### Methode 2: Über Railway CLI

```bash
# Im Projekt-Verzeichnis
railway link

# Volume hinzufügen
railway volume add \
  --name neo4j-data \
  --mount-path /data \
  --size 1

# Redeploy
railway redeploy
```

## Volume-Konfiguration

### Empfohlene Größen

| Use Case | Empfohlene Größe |
|----------|------------------|
| Development/Testing | 1GB |
| Small Production | 5GB |
| Medium Production | 10GB |
| Large Production | 20GB+ |

### Kosten

Railway Volumes kosten ca. **$0.25/GB/Monat**

Beispiele:
- 1GB = ~$0.25/Monat
- 5GB = ~$1.25/Monat
- 10GB = ~$2.50/Monat

## Was wird gespeichert?

Das Volume unter `/data` enthält:
- **Datenbank-Dateien** (graph.db)
- **Transaction Logs**
- **Security Credentials**
- **System-Konfiguration**

## Nach Volume-Setup verifizieren

### 1. SSH in Container

```bash
railway ssh
```

### 2. Prüfe Mount

```bash
# Liste Volumes
df -h | grep /data

# Prüfe Permissions
ls -la /data

# Prüfe Neo4j Daten
ls -la /data/databases
```

### 3. Teste Persistenz

```cypher
// Erstelle Test-Node
CREATE (n:TestPersistence {
  created: timestamp(),
  message: 'This should survive restarts'
}) RETURN n;

// Query Node
MATCH (n:TestPersistence) RETURN n;
```

Dann:
```bash
# Redeploy
railway redeploy

# Nach Neustart: Prüfe ob Node noch existiert
MATCH (n:TestPersistence) RETURN n;
```

## Backup-Strategie

### Manuelles Backup

```bash
# SSH in Container
railway ssh

# Neo4j Dump erstellen
neo4j-admin database dump neo4j --to=/data/backups/neo4j-$(date +%Y%m%d).dump

# Dump herunterladen (lokal)
railway run bash -c "cat /data/backups/neo4j-*.dump" > backup.dump
```

### Restore

```bash
# Stoppe Neo4j
railway ssh
neo4j stop

# Restore
neo4j-admin database load neo4j --from=/data/backups/neo4j-20260118.dump --overwrite-destination

# Starte Neo4j
neo4j start
```

### Automatisches Backup (Cron)

Erstelle einen Backup-Service in Railway:

```bash
# backup-script.sh
#!/bin/bash
DATE=$(date +%Y%m%d-%H%M%S)
neo4j-admin database dump neo4j --to=/data/backups/neo4j-${DATE}.dump

# Behalte nur die letzten 7 Backups
cd /data/backups
ls -t neo4j-*.dump | tail -n +8 | xargs rm -f
```

## Volume Migration

### Von einem Service zu einem anderen

```bash
# 1. Backup vom alten Service
railway ssh --service old-neo4j
neo4j-admin database dump neo4j --to=/tmp/migration.dump
exit

# 2. Backup herunterladen
railway run --service old-neo4j bash -c "cat /tmp/migration.dump" > migration.dump

# 3. Backup hochladen zum neuen Service
cat migration.dump | railway run --service new-neo4j bash -c "cat > /tmp/migration.dump"

# 4. Restore im neuen Service
railway ssh --service new-neo4j
neo4j stop
neo4j-admin database load neo4j --from=/tmp/migration.dump --overwrite-destination
neo4j start
```

## Troubleshooting

### "Permission denied" Fehler

```bash
railway ssh

# Fix Permissions
chown -R neo4j:neo4j /data
chmod -R 755 /data
```

### Volume ist voll

```bash
# Prüfe Nutzung
du -sh /data/*

# Bereinige Transaction Logs (Optional)
neo4j-admin database check neo4j
```

### Daten nicht persistiert

Prüfe ob Volume korrekt gemountet ist:
```bash
railway ssh
mount | grep /data

# Falls nicht gemountet:
# 1. Gehe zu Railway Dashboard
# 2. Settings → Volumes
# 3. Prüfe Mount Path: /data
# 4. Redeploy
```

## Best Practices

**DO:**
- Volume sofort nach erstem Deploy hinzufügen
- Regelmäßige Backups erstellen
- Volume-Größe monitoren
- Permissions prüfen nach Setup

**DON'T:**
- Volume erst später hinzufügen (Datenverlust!)
- Ohne Backups arbeiten
- Volume zu klein dimensionieren
- Root-Permissions verwenden

## Kosten-Optimierung

### Storage sparen

```cypher
// Alte Daten löschen
MATCH (n:OldData)
WHERE n.timestamp < timestamp() - 7776000000 // 90 Tage
DELETE n;

// Compaction
CALL apoc.periodic.iterate(
  "MATCH (n) RETURN n",
  "SET n.updated = timestamp()",
  {batchSize:10000}
);
```

### Monitoring

```bash
# Speichernutzung überwachen
watch -n 60 'du -sh /data/*'

# Größte Dateien finden
du -ah /data | sort -rh | head -n 20
```

## Weiterführende Links

- [Railway Volumes Docs](https://docs.railway.app/reference/volumes)
- [Neo4j Backup Guide](https://neo4j.com/docs/operations-manual/current/backup-restore/)
- [Neo4j Admin Commands](https://neo4j.com/docs/operations-manual/current/tools/neo4j-admin/)

---

**Tipp:** Füge das Volume immer beim ersten Deployment hinzu, um Datenverlust zu vermeiden.
