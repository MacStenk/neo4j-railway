# Contributing to Neo4j Railway

Thank you for your interest in contributing! 🎉

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/MacStenk/neo4j-railway/issues)
2. If not, create a new issue using the Bug Report template
3. Include as much detail as possible:
   - Railway plan and configuration
   - Memory settings
   - Logs from `railway logs`
   - Steps to reproduce

### Suggesting Features

1. Check existing [Issues](https://github.com/MacStenk/neo4j-railway/issues) for similar suggestions
2. Create a new issue with tag `enhancement`
3. Clearly describe:
   - The problem you're solving
   - Your proposed solution
   - Any alternatives you've considered

### Pull Requests

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Test locally with Docker:
   ```bash
   docker build -t neo4j-test .
   docker run -p 7474:7474 -p 7687:7687 neo4j-test
   ```
5. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
6. Push to your branch (`git push origin feature/AmazingFeature`)
7. Open a Pull Request

### Code Style

- Use clear, descriptive variable names
- Comment complex logic
- Follow Docker best practices
- Keep Dockerfile organized and documented

### Testing

Before submitting a PR:
- [ ] Build Docker image locally
- [ ] Test container starts successfully
- [ ] Verify Neo4j is accessible on port 7474
- [ ] Test Bolt connection on port 7687
- [ ] Check memory usage is within limits
- [ ] Update documentation if needed

### Documentation

If you're adding features or changing behavior:
- Update README.md
- Update relevant guide files (QUICKSTART.md, RAILWAY_GUIDE.md)
- Add comments to Dockerfile if needed

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/neo4j-railway.git
cd neo4j-railway

# Build locally
docker build -t neo4j-railway:dev .

# Run locally
docker run -d --name neo4j-dev \
  -e NEO4J_AUTH=neo4j/devpassword \
  -p 7474:7474 -p 7687:7687 \
  neo4j-railway:dev

# Check logs
docker logs -f neo4j-dev

# Access Neo4j Browser
open http://localhost:7474
```

## Questions?

Feel free to:
- Open an issue for questions
- Start a [Discussion](https://github.com/MacStenk/neo4j-railway/discussions)
- Reach out on Railway Discord

## Code of Conduct

- Be respectful and constructive
- Welcome newcomers
- Focus on what's best for the community
- Show empathy towards others

Thank you for contributing! 🙏
