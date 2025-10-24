#!/bin/bash

# A simple argument parser for the Tireless Researcher tool.
# This script is a skeleton and will be expanded with the core logic later.

# --- Default Values ---
OPTIMIZATION_GOAL="performans"
TASK_PROMPT=""
DEADLINE=""

# --- Helper function for usage message ---
usage() {
    echo "Usage: $0 --task-prompt <prompt> --deadline <YYYY-MM-DD HH:MM:SS> [--optimization-goal <goal>]"
    echo ""
    echo "Arguments:"
    echo "  --task-prompt         Required. A detailed description of the task for Jules."
    echo "  --deadline            Required. The exact UTC timestamp when the work must stop."
    echo "  --optimization-goal   Optional. The primary goal of the optimization. Defaults to 'performans'."
    echo "                        (e.g., okunabilirlik, güvenlik, kod-kisaligi)"
    exit 1
}

# --- Parse Command-Line Arguments ---
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --task-prompt) TASK_PROMPT="$2"; shift ;;
        --deadline) DEADLINE="$2"; shift ;;
        --optimization-goal) OPTIMIZATION_GOAL="$2"; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown parameter passed: $1"; usage ;;
    esac
    shift
done

# --- Validate Required Arguments ---
if [ -z "$TASK_PROMPT" ] || [ -z "$DEADLINE" ]; then
    echo "Error: Missing required arguments."
    usage
fi

# --- Echo parsed values to confirm ---
echo "✅ Tool started with the following parameters:"
echo "--------------------------------------------------"
echo "Görev Tanımı (Task Prompt): $TASK_PROMPT"
echo "Bitiş Zamanı (Deadline):   $DEADLINE"
echo "Optimizasyon Hedefi (Goal): $OPTIMIZATION_GOAL"
echo "--------------------------------------------------"
echo ""
echo "Bu betik şu anda bir iskelettir. Gelecekte ana araştırma mantığı buraya eklenecektir."

# TODO: Add the core logic of the Tireless Researcher here.
# 1. Start a loop that runs until the DEADLINE.
# 2. Inside the loop, generate and test code variants.
# 3. Store results in the 'variants' and 'reports' directories.
