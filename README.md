# Versioner Documentation

Public documentation for [Versioner](https://versioner.io) - deployment tracking and visibility for engineering teams.

## 📚 View Documentation

Visit **[docs.versioner.io](https://docs.versioner.io)** to read the full documentation.

## 🛠️ Local Development

### Prerequisites
- Python 3.11+
- pip

### Setup
\`\`\`bash
# Install dependencies
pip install -r requirements.txt

# Start local server
mkdocs serve
\`\`\`

Visit `http://localhost:8000` to preview the docs.

### Building
\`\`\`bash
mkdocs build
\`\`\`

## 📝 Contributing

Documentation is written in Markdown and located in the `public/` directory.

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed contribution guidelines.

### Structure
- `public/getting-started.md` - Getting started guide
- `public/concepts/` - Core concepts
- `public/api/` - API reference
- `public/cli/` - CLI documentation
- `public/integrations/` - Integration guides

### Making Changes
1. Edit Markdown files in `public/`
2. Test locally with `mkdocs serve`
3. Submit a pull request

## 🚀 Deployment

Documentation is automatically deployed to docs.versioner.io when changes are merged to `main`.

## 📄 License

Copyright © 2025 Versioner. All rights reserved.
