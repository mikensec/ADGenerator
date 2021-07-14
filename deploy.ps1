Invoke-Webrequest https://raw.githubusercontent.com/mikensec/ADGenerator/main/Invoke-ForestDeploy.ps1 -OutFile Invoke-ForestDeploy.ps1
Invoke-Webrequest https://raw.githubusercontent.com/mikensec/ADGenerator/main/ADGenerator.ps1 -OutFile ADGenerator.ps1

# Register the new PowerShell scheduled task

# The name of your scheduled task.
$taskName = "Invoke-ForestDeploy"

# Describe the scheduled task.
$description = "runs Invoke-ForestDeploy.ps1"

# Register the scheduled task
Register-ScheduledTask `
    -TaskName $taskName `
    -Action $taskAction `
    -Trigger $taskTrigger `
    -Description $description