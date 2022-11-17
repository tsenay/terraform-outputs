# terraform-outputs
Generate output from existing resources and modules

> Works on Linux/MacOS

## requirements

- This script require [hcledit](https://github.com/minamijoyo/hcledit) to work

## Installation

```bash
curl -o /usr/local/bin/terraform-outputs https://raw.githubusercontent.com/tsenay/terraform-outputs/main/terraform-outputs.sh 
chmod +x /usr/local/bin/terraform-outputs
```

## Usage

```bash
cd path/to/terraform/module
terraform-outputs > outputs.tf
```
