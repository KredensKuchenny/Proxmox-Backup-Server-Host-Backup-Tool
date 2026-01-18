#!/bin/bash

# ===============================
# Proxmox Backup Script 
# ===============================

# PBS credentials and server info
PBS_PASSWORD='example-password-1234'
PBS_USER_STRING='user@example@pbs!example-vm.example.com'
PBS_SERVER='pbs-server.example.com'
PBS_DATASTORE='example-datastore'
PBS_NAMESPACE='example-vm-gen01.example.com'

# Log file
LOG_FILE="pbs_client.log"

# Check if "info" parameter was passed
SHOW_INFO=false
if [ "$1" == "info" ]; then
    SHOW_INFO=true
fi

# Logging function
log() {
    local LEVEL="$1"
    shift
    local MESSAGE="[$(date '+%Y-%m-%d %H:%M:%S')] [$LEVEL] $*"

    # Always log to file
    echo "$MESSAGE" >> "$LOG_FILE"

    # Display on screen only if SHOW_INFO=true
    if $SHOW_INFO; then
        echo "$MESSAGE"
    fi
}

# Exit script on error with logging
exit_on_error() {
    local MSG="$1"
    log "ERROR" "$MSG"
    exit 1
}

# Backup function
backup() {
    log "INFO" "=============================="
    log "INFO" "Starting backup process"
    log "INFO" "=============================="

    # PBS credentials and server info
    PBS_REPOSITORY="${PBS_USER_STRING}@${PBS_SERVER}:${PBS_DATASTORE}"
    PBS_HOSTNAME="$(hostname -s)"

    log "INFO" "Host: $PBS_HOSTNAME"
    log "INFO" "Repository: $PBS_REPOSITORY"
    log "INFO" "Namespace: $PBS_NAMESPACE"

    # Start backup
    log "INFO" "Initiating Proxmox backup..."
    PBS_PASSWORD="$PBS_PASSWORD" \
    PBS_REPOSITORY="$PBS_REPOSITORY" \
    PBS_HOSTNAME="$PBS_HOSTNAME" \
    proxmox-backup-client backup root.pxar:/ --ns "$PBS_NAMESPACE" >> "$LOG_FILE" 2>&1
    local BACKUP_EXIT_CODE=$?

    # Check backup result
    if [ $BACKUP_EXIT_CODE -eq 0 ]; then
        log "INFO" "Backup completed successfully."
    else
        log "ERROR" "Backup failed with exit code $BACKUP_EXIT_CODE!"
        exit_on_error "Backup process encountered an error."
    fi

    log "INFO" "=============================="
    log "INFO" "Backup process finished for host: $PBS_HOSTNAME"
    log "INFO" "=============================="
}

# Run backup
backup
