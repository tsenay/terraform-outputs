#!/usr/bin/env bash

set -o pipefail

_hcledit=$(which hcledit)

for tf_file in $(ls *.tf); do
    cat $tf_file | $_hcledit block list | while read line; do
        block_type="${line%%.*}"
        line="${line#*.}"
        case $block_type in
            locals|output|variable|data) continue; break ;;
            module)
                output_name=$line 
                output_description="Module '$output_name' attributes"
                output_value="$block_type.$output_name"
                ;;
            resource)
                label_kind="${line%.*}"
                label_name="${line#*.}"
                output_name="${label_kind}_${label_name//[\-]/_}"
                output_description="Resource '$label_kind.$label_name' attributes"
                output_value="$label_kind.$label_name"
                ;;
        esac
        
        cat <<-EOT

output "$output_name" {
  description = "$output_description"
  value       = $output_value
}
EOT
    done
done
