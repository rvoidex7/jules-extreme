#!/bin/bash
set -e; ENTITY_NAME="";
while [[ "$#" -gt 0 ]]; do case $1 in --name) ENTITY_NAME="$2"; shift ;; *) exit 1 ;; esac; shift; done
if [ -z "$ENTITY_NAME" ]; then exit 1; fi; DEST_DIR="projects/synthwave-samurai/src/entities"; FILE_PATH="${DEST_DIR}/${ENTITY_NAME}.js";
mkdir -p "$DEST_DIR"; if [ -f "$FILE_PATH" ]; then echo "File exists."; exit 1; fi
cat > "$FILE_PATH" << EOL
// Bu dosya 'new-entity' aracı tarafından oluşturuldu.
import * as THREE from 'https://cdn.skypack.dev/three@0.136.0';
export class ${ENTITY_NAME} extends THREE.Object3D { constructor() { super(); this.name = '${ENTITY_NAME}'; } update(deltaTime) {} }
EOL
echo "✅ Entity created: $FILE_PATH"
