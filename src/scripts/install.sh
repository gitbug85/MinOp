if ! command -v minop >/dev/null 2>&1; then
    MINOP_DIR="$(cd "$(dirname "../bn")" && pwd)"
    echo "export PATH=\"\$PATH:$MINOP_DIR\"" >> ~/.bashrc
    export PATH="$PATH:$MINOP_DIR"
fi
