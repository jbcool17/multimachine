#!/usr/bin/env bash

echo 'MATE!'
mkdir '~/Projects' && cd Projects
git clone https://github.com/jbcool17/multimachine.git && cd multimachine
cd VE-Setup/roc && bundle install
