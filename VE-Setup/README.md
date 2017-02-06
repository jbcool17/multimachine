# FFMPEG ENCODING CLUSTER
- still in testing stages...

## Requirements
- vagrant & ansible for master/nodes development setup
  - ```vagrant up```
  - ```ansible-playbook provision.yml```

- ruby 2.3.1
### .ENV
- This uses the dotenv gem.
- here is an example of the .env file needed.

```
# Enter User/Pass
ROC_NODE_USER=vagrant
ROC_NODE_PASS=vagrant

# Enter IP Addresses
ROC_NODE1=xxx.xxx.xx.xxx
ROC_NODE2=xxx.xxx.xx.xxx
ROC_NODE3=xxx.xxx.xx.xxx
```

### Nodes
- Edit lib/encode_nodes.rb to add/remove Nodes.
- will automate this in the future.

## MachineManager
```
cd roc

# start all machines
bin/mm start_all

# stop all machines
bin/mm stop_all

# get status of all machines
bin/mm status

# Reload Machines
bin/mm reload_all
```

## MasterControl
- place files in roc folder, can't parse paths from anywhere yet
```
cd roc

# Submit Job to queue
bin/mc submit_job testsrc.mpg testsrc.mov options

# Runs jobs with ready status
bin/mc run_jobs

# Convert one off job
bin/mc convert testsrc.mpg testsrc.mov options

# List Jobs
bin/mc jobs - Lists all jobs

# Run Daemon
bin/mc run_daemon - not ready - use 'ruby run_daemon.rb'
```
