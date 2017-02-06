# FFMPEG ENCODING CLUSTER
- still in testing stages...

## Requirements
- vagrant & ansible for master/nodes development setup
  - ```vagrant up```
  - ```ansible-playbook provision.yml```

- ruby 2.3.1


## MachineManager
```
# start all machines
roc/bin/mm start_all

# stop all machines
roc/bin/mm stop_all

# get status of all machines
roc/bin/mm status

# Reload Machines
roc/bin/mm reload_all
```

## MasterControl
- place files in roc folder, can't parse paths from anywhere yet
```
# Submit Job to queue
roc/bin/mc submit_job testsrc.mpg testsrc.mov options

# Runs jobs with ready status
roc/bin/mc run_jobs

# Convert one off job
roc/bin/mc convert testsrc.mpg testsrc.mov options

# List Jobs
roc/bin/mc jobs - Lists all jobs

# Run Daemon
roc/bin/mc run_daemon
```
