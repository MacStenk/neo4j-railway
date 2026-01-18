#!/bin/bash

# Neo4j Railway Deployment Script
# Verwendung: ./deploy.sh

set -e

echo "🚀 Neo4j Railway Deployment"
echo "============================"
echo ""

# Prüfe ob Railway CLI installiert ist
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI nicht gefunden!"
    echo "Installation: npm install -g @railway/cli"
    exit 1
fi

# Prüfe ob Git initialisiert ist
if [ ! -d .git ]; then
    echo "📦 Initialisiere Git Repository..."
    git init
    git add .
    git commit -m "Initial Neo4j Railway setup"
    echo "✅ Git initialisiert"
else
    echo "✅ Git Repository existiert bereits"
fi

# Prüfe ob mit Railway verbunden
if [ ! -f .railway ]; then
    echo ""
    echo "🔗 Verbinde mit Railway..."
    echo "Wähle: Create new project"
    railway init
    echo "✅ Railway Projekt erstellt"
else
    echo "✅ Bereits mit Railway verbunden"
fi

# Frage nach Passwort
echo ""
read -sp "🔐 Neo4j Passwort eingeben (min. 8 Zeichen): " PASSWORD
echo ""

if [ ${#PASSWORD} -lt 8 ]; then
    echo "❌ Passwort muss mindestens 8 Zeichen lang sein!"
    exit 1
fi

# Setze Environment Variable
echo "🔧 Setze Environment Variables..."
railway variables set NEO4J_AUTH="neo4j/$PASSWORD"
echo "✅ NEO4J_AUTH gesetzt"

# Deploy
echo ""
echo "🚢 Deploying zu Railway..."
railway up

echo ""
echo "✅ Deployment erfolgreich!"
echo ""
echo "📊 Nächste Schritte:"
echo "1. Warte bis Container läuft: railway logs --follow"
echo "2. Öffne Railway Dashboard für Domain & TCP Proxy Info"
echo "3. Verbinde mit Neo4j Browser"
echo ""
echo "🔗 Nützliche Commands:"
echo "  railway logs          - Logs anzeigen"
echo "  railway status        - Status prüfen"
echo "  railway ssh           - In Container einloggen"
echo "  railway open          - Railway Dashboard öffnen"
echo ""
