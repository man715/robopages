# Robopages

A YAML based format for describing tools to LLMs, like man pages but for robots!

## Syntax

A robopage is a YAML file describing one or more tools that can be used by an LLM.

```yaml
# General description of this page.
description: Scan web server for known vulnerabilities.

# Define one or more functions that can be used by the LLM.
functions:
  nikto_scan:
    # Description of what the function does.
    description: Scan a specific target web server for known vulnerabilities.
    # Function parameters.
    parameters:
      target:
        type: string
        description: The URL of the target to scan.
        examples:
          - http://www.target.com/
          - https://target.tld

    # If the binary from cmdline is not found in $PATH, specify which container to pull and run it with.
    container:
      image: frapsoft/nikto
      args:
        - --net=host

    # The command line to execute.
    cmdline:
      - nikto
      - -host
      # Use these placeholders for the parameters.
      # Supported syntax variations: `${param}` and `${param or default_value}`
      - ${target}
```

## Usage

Refer to https://github.com/dreadnode/robopages-cli
