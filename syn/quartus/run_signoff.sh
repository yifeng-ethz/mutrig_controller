#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_name="mutrig_cfg_ctrl_syn"
revision="mutrig_cfg_ctrl_syn"

cd "${script_dir}"
quartus_sh --flow compile "${project_name}" -c "${revision}"
