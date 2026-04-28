# List available commands
default:
    just --list

# ====================================
# === Development Environment ===
# ====================================

# Start local docs server (http://localhost:8000)
dev_up:
    @echo "Starting MkDocs dev server at http://localhost:8000 ..."
    mkdocs serve

# Start local docs server in background
dev_up_bg:
    @echo "Starting MkDocs dev server in background..."
    mkdocs serve &
    @echo "✅ Running at http://localhost:8000 — stop with: just dev_down"

# Stop background MkDocs server
dev_down:
    -pkill -f "mkdocs serve" && echo "✅ MkDocs server stopped" || echo "No MkDocs server running"

# ====================================
# === Build ===
# ====================================

# Production build (strict — fails on warnings)
build:
    mkdocs build --strict

# ====================================
# === Setup ===
# ====================================

# Install Python dependencies
setup:
    pip install -r requirements.txt
