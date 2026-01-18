# Proxmox Backup Server Host Backup Tool

A Bash script for backing up standalone hosts to a Proxmox Backup Server (PBS)

## Description

This script allows you to:
- Backup the root directory (`root.pxar:/`) of the host to a specified PBS datastore
- Log the backup process to a log file (`pbs_client.log`)
- Optionally display real-time progress and information on the terminal

It uses PBS credentials, including an API token, to authenticate and perform the backup.

## Requirements
- Proxmox Backup Client (`proxmox-backup-client`) installed
- A PBS account with an API token
- Permissions to create backups on the PBS

## Configuration

Edit the script to provide your PBS credentials and settings:

```bash
PBS_PASSWORD='example-password-1234'          # Your API secret
PBS_USER_STRING='user@example@pbs!token'      # User/token in format: user@pbs!token
PBS_SERVER='pbs-server.example.com'           # PBS server address
PBS_DATASTORE='example-datastore'             # Name of the PBS datastore
PBS_NAMESPACE='example-vm-gen01.example.com'  # Namespace to store backups
```

You can also change the log file name if needed:
```bash
LOG_FILE="pbs_client.log"
```

## Usage

Run the script directly:
```bash
./pbs_client.sh
```

To display real-time info messages during the backup, pass the `info` parameter:
```bash
./pbs_client.sh info
```

## Parameters
- `info` — Optional. When provided, the script prints informational messages on the terminal as it runs. Otherwise, it only logs to the file.

## Logging

All backup events and errors are logged to `pbs_client.log` by default.

The log contains:
- Timestamps
- Log level (INFO, ERROR)
- Description of the action or error

Example log entry:
```
[2026-01-18 12:34:56] [INFO] Backup completed successfully.
```

## Automation with Cron

You can schedule automatic backups using cron. For example, to run daily at 2:00 AM and discard all output:

```bash
0 2 * * * /path/to/pbs_client.sh > /dev/null 2>&1
```

This will:
- Run the backup daily
- Suppress all output (no logs will be printed or saved by cron)
