# SPDX-License-Identifier: PLMP-1.0-or-later
# Terminal-Recoverer – Justfile
# Minimal operational task runner for installation, removal, and maintenance.

set shell := ["bash", "-uc"]
set dotenv-load := true
set positional-arguments := true

project := "terminal-recoverer"
version := "0.1.0"

# ───────────────────────────────────────────────────────────────────────────────
# DEFAULT & INFO
# ───────────────────────────────────────────────────────────────────────────────

default:
    @just --list --unsorted

info:
    @echo "Project: {{project}}"
    @echo "Version: {{version}}"
    @echo "Install path: $HOME/.local/bin/terminal-recoverer"
    @echo "Systemd user dir: $HOME/.config/systemd/user"

status:
    @echo "=== Terminal Recoverer Status ==="
    systemctl --user status terminal-recoverer.service --no-pager || true
    systemctl --user status terminal-recoverer-coredump.service --no-pager || true

# ───────────────────────────────────────────────────────────────────────────────
# INSTALLATION & REMOVAL
# ───────────────────────────────────────────────────────────────────────────────

install:
    @echo "Installing Terminal Recoverer…"
    mkdir -p "$$HOME/.local/bin"
    mkdir -p "$$HOME/.bashrc.d"
    mkdir -p "$$HOME/.config/systemd/user"
    mkdir -p "$$HOME/Documents/terminal-logs"
    mkdir -p "$$HOME/Documents/crash-captures"

    cp bin/terminal-recoverer "$$HOME/.local/bin/terminal-recoverer"
    chmod +x "$$HOME/.local/bin/terminal-recoverer"

    cp systemd/terminal-recoverer.service "$$HOME/.config/systemd/user/"
    cp systemd/terminal-recoverer-coredump.service "$$HOME/.config/systemd/user/"

    cp shell/recoverer.sh "$$HOME/.bashrc.d/recoverer.sh"

    cp docs/terminal-recoverer-HOWTO.txt "$$HOME/terminal-recoverer-HOWTO.txt"

    systemctl --user daemon-reload
    echo "Sentinel installed. Enable services with:"
    echo "  systemctl --user enable --now terminal-recoverer.service"
    echo "  systemctl --user enable --now terminal-recoverer-coredump.service"

uninstall:
    @echo "Uninstalling Terminal Recoverer…"
    systemctl --user disable --now terminal-recoverer.service || true
    systemctl --user disable --now terminal-recoverer-coredump.service || true

    rm -f "$$HOME/.local/bin/terminal-recoverer"
    rm -f "$$HOME/.config/systemd/user/terminal-recoverer.service"
    rm -f "$$HOME/.config/systemd/user/terminal-recoverer-coredump.service"
    rm -f "$$HOME/.bashrc.d/recoverer.sh"
    rm -f "$$HOME/terminal-recoverer-HOWTO.txt"

    systemctl --user daemon-reload
    echo "Sentinel removed."

# ───────────────────────────────────────────────────────────────────────────────
# DOCUMENTATION
# ───────────────────────────────────────────────────────────────────────────────

docs:
    @echo "Generating documentation index…"
    mkdir -p docs/generated
    OUTPUT="docs/generated/index.adoc"
    echo "= Sentinel Documentation Index" > "$OUTPUT"
    echo ":toc:" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    for f in docs/*.adoc; do \
        name=$$(basename "$$f"); \
        echo "* link:../$$f[$$name]" >> "$OUTPUT"; \
    done
    echo "Documentation index generated at docs/generated/index.adoc"

# ───────────────────────────────────────────────────────────────────────────────
# UTILITIES
# ───────────────────────────────────────────────────────────────────────────────

logs:
    @echo "Log directory:"
    @echo "$$HOME/Documents/terminal-logs"
    @ls -1 "$$HOME/Documents/terminal-logs" || true

crashes:
    @echo "Crash capture directory:"
    @echo "$$HOME/Documents/crash-captures"
    @ls -1 "$$HOME/Documents/crash-captures" || true

edit:
    ${EDITOR:-code} .

