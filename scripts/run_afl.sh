#!/usr/bin/env bash
set -euo pipefail

AFL_DIR=${AFL_DIR:-"$HOME/AFL"}

WORK_DIR=${WORK_DIR:-"$PWD/work"}
TARGET_C="$PWD/src/toy.c"
TARGET_BIN="$WORK_DIR/toy_afl"

IN_DIR="$WORK_DIR/in"
OUT_DIR="$WORK_DIR/out"
LOG_DIR="$PWD/logs"
STAGE_LOG="$LOG_DIR/dbg_stage.log"

mkdir -p "$WORK_DIR" "$IN_DIR" "$OUT_DIR" "$LOG_DIR"
rm -rf "$OUT_DIR"/*
: > "$STAGE_LOG"

echo "[*] AFL_DIR=$AFL_DIR"
echo "[*] Build target with instrumentation..."
"$AFL_DIR/afl-gcc" -O0 -g "$TARGET_C" -o "$TARGET_BIN"

echo "[*] Prepare seeds..."
printf "A"  > "$IN_DIR/seed1"
printf "FU" > "$IN_DIR/seed2"

echo "[*] Run afl-fuzz (建议运行 1~3 分钟后 Ctrl+C 结束)..."
echo "[*] Log -> $STAGE_LOG"
AFL_NO_UI=1 "$AFL_DIR/afl-fuzz" -i "$IN_DIR" -o "$OUT_DIR" -- "$TARGET_BIN" > "$STAGE_LOG" 2>&1

