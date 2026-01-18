# Neo4j Railway Deployment

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/neo4j?referralCode=your-code)

Production-ready Neo4j 5.15.0 deployment optimized for Railway's infrastructure. Features memory-optimized settings (768MB total), APOC plugin, and one-click deployment.

## Features

- **One-Click Deploy** - Deploy directly from GitHub to Railway
- **Memory Optimized** - 768MB total RAM (256MB Pagecache + 512MB Heap)
- **APOC Plugin** - Pre-installed for advanced graph operations
- **Both Protocols** - Bolt (7687) and HTTP (7474) enabled
- **Health Check** - Automatic container monitoring
- **Railway Ready** - Optimized for Railway Free/Hobby tier

## Quick Deploy to Railway

### Option 1: One-Click Deploy (Easiest)

1. Click the "Deploy on Railway" button above
2. Set your password in the environment variables
3. Wait for deployment to complete
4. Access your Neo4j instance

### Option 2: Deploy from CLI

```bash
# Clone this repository
git clone https://github.com/MacStenk/neo4j-railway.git
cd neo4j-railway

# Login to Railway
railway login

# Initialize new project
railway init

# Set password (IMPORTANT!)
railway variables set NEO4J_AUTH=neo4j/your-secure-password

# Deploy
railway up

# Monitor logs
railway logs --follow
```

### Option 3: Connect Existing Railway Project

```bash
# In Railway Dashboard
1. Go to your project
2. Click "New Service"
3. Choose "GitHub Repo"
4. Select "MacStenk/neo4j-railway"
5. Set NEO4J_AUTH variable
6. Deploy
```

## Security Configuration

**Important:** Change the default password immediately.

Set the `NEO4J_AUTH` environment variable in Railway:

```
NEO4J_AUTH=neo4j/your-secure-password
```

Minimum password length: 8 characters

## Data Persistence

**Without a volume, all data is lost on redeploy.**

### Add Volume After First Deployment:

1. Go to Railway Dashboard → Your Service
2. **Settings → Volumes**
3. Click **"+ New Volume"**
4. Configure:
   - Name: `neo4j-data`
   - Mount Path: `/data`
   - Size: 1GB (minimum)
5. Click **"Add"**
6. Service will automatically redeploy

**Detailed Guide:** See [VOLUME_SETUP.md](VOLUME_SETUP.md)

**Cost:** ~$0.25/GB/month

## Connecting to Neo4j

**Important: Configure Networking First**

After deployment, you must configure networking in Railway:

### Step 1: Generate HTTP Domain
1. Settings → Networking → **"Generate Domain"**
2. This creates: `https://your-app.railway.app` (Port 7474)
3. Use for: Neo4j Browser

### Step 2: Add TCP Proxy
1. Settings → Networking → **"+ TCP Proxy"**
2. Port: **7687**
3. This creates: `bolt://maglev.proxy.rlwy.net:XXXXX`
4. Use for: Applications, Cypher-Shell, Neo4j Desktop

**Detailed Guide:** See [NETWORKING_SETUP.md](NETWORKING_SETUP.md)

---

After networking setup, connect using:

### HTTP Browser (Neo4j Browser)

```
URL: https://your-app.railway.app
Username: neo4j
Password: your-secure-password
```

### Bolt Protocol (For applications)

```
URL: bolt://proxy-domain.railway.app:PORT
Username: neo4j
Password: your-secure-password
```

**Note:** Use `bolt://` (not `bolt+s://`) for Railway TCP Proxy connections.

## Memory Configuration

Default settings (total ~768MB):

| Setting | Value | Description |
|---------|-------|-------------|
| Pagecache | 256MB | File system cache |
| Heap Max | 512MB | Maximum JVM heap |
| Heap Initial | 256MB | Initial JVM heap |

### Adjust Memory (if needed)

For Railway Trial (512MB RAM):
```bash
railway variables set NEO4J_server_memory_pagecache_size=128M
railway variables set NEO4J_dbms_memory_heap_max__size=384M
railway variables set NEO4J_dbms_memory_heap_initial__size=128M
```

For Railway Hobby (1GB+ RAM):
```bash
railway variables set NEO4J_server_memory_pagecache_size=512M
railway variables set NEO4J_dbms_memory_heap_max__size=1G
railway variables set NEO4J_dbms_memory_heap_initial__size=512M
```

## Configuration

### Environment Variables

All configuration is done through Railway environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `NEO4J_AUTH` | `neo4j/changeme123` | Username/password (CHANGE THIS!) |
| `NEO4J_server_memory_pagecache_size` | `256M` | Pagecache size |
| `NEO4J_dbms_memory_heap_max__size` | `512M` | Max heap size |
| `NEO4J_dbms_memory_heap_initial__size` | `256M` | Initial heap size |

### Ports

- **7474** - HTTP (Neo4j Browser)
- **7687** - Bolt Protocol

Railway automatically exposes these ports via:
- Public domain for port 7474
- TCP Proxy for port 7687

## Troubleshooting

### Container crashes immediately

**Cause:** Not enough RAM available

**Solution:**
```bash
# Reduce memory settings
railway variables set NEO4J_server_memory_pagecache_size=128M
railway variables set NEO4J_dbms_memory_heap_max__size=384M
railway redeploy
```

### Can't connect via Bolt

**Cause:** Using wrong protocol or port

**Solution:**
- Use `bolt://` (not `bolt+s://`)
- Use Railway's TCP Proxy address (find in Dashboard → Networking)
- Test connection: `nc -zv proxy-address PORT`

### "Database access might require an authenticated connection"

**Cause:** Wrong password or Neo4j not fully started

**Solution:**
- Check password in Railway variables
- Wait 30-60 seconds after deployment
- Check logs: `railway logs`

### Health check failing

**Cause:** Neo4j not responding on time

**Solution:**
- Check container has enough resources
- View logs for startup errors
- Health check retries automatically

## Documentation Files

- `QUICKSTART.md` - Step-by-step deployment guide
- `DEPLOYMENT.md` - Detailed deployment instructions
- `README.md` - This file
- `deploy.sh` - Automated deployment script

## Testing Your Installation

After deployment, test with these Cypher queries:

```cypher
// Create a test node
CREATE (n:TestNode {name: 'Hello Railway', timestamp: timestamp()}) 
RETURN n;

// Test APOC
CALL apoc.help("apoc.create");

// Check database status
CALL dbms.components();
```

## Learning Resources

- [Neo4j Documentation](https://neo4j.com/docs/)
- [APOC Documentation](https://neo4j.com/labs/apoc/)
- [Railway Documentation](https://docs.railway.app/)
- [Cypher Query Language](https://neo4j.com/developer/cypher/)

## Cost Estimation

### Railway Free Trial
- 512MB RAM, 1GB Disk
- $5 credit
- ~500 hours runtime
- **Estimated cost:** Free for testing

### Railway Hobby Plan
- $5/month
- 1GB RAM, 10GB Disk
- Unlimited hours
- **Estimated cost:** $5-10/month

### Railway Pro Plan
- From $20/month
- Scalable resources
- **Recommended for production**

## Contributing

Contributions are welcome. Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is open source and available under the [MIT License](LICENSE).

## Acknowledgments

- Neo4j Team for the graph database
- Railway Team for the deployment platform
- APOC contributors for extended procedures

## Support

- **Issues:** [GitHub Issues](https://github.com/MacStenk/neo4j-railway/issues)
- **Discussions:** [GitHub Discussions](https://github.com/MacStenk/neo4j-railway/discussions)
- **Railway Community:** [Railway Discord](https://discord.gg/railway)

## Links

- [GitHub Repository](https://github.com/MacStenk/neo4j-railway)
- [Railway Platform](https://railway.app)
- [Neo4j Official](https://neo4j.com)
- [APOC Library](https://neo4j.com/labs/apoc/)
