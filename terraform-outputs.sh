#!/usr/bin/env bash

set -o pipefail

_hcledit=$(which hcledit)

# Parameters
# - name
# - value
# - description
function dump_output() {
    cat <<-EOT

output "$1" {
  description = "$3"
  value       = $2
}
EOT
}

for tf_file in $(ls *.tf); do
    cat $tf_file | $_hcledit block list | while read line; do
        block_type="${line%%.*}"
        line="${line#*.}"
        case $block_type in
        locals | output | variable | data | provider | terraform)
            continue
            ;;
        module)
            output_name="module_${line}"
            output_description="Module '$line' attributes"
            output_value="$block_type.$line"
            ;;
        resource)
            label_kind="${line%.*}"
            label_name="${line#*.}"
            output_name="${label_kind}_${label_name//[\-]/_}"
            output_description="Resource '$label_kind.$label_name' attributes"
            output_value="$label_kind.$label_name"
            ;;
        esac
        dump_output "${output_name}" "${output_value}" "${output_description}"
    done
done
