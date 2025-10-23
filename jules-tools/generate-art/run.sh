#!/bin/bash\npip install -r "$(dirname "$0")/requirements.txt"\npython "$(dirname "$0")/run.py" "$@"
