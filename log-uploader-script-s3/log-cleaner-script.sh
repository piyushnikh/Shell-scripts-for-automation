#!/bin/bash

# Log purging script for Jenkins jobs.

JENKINS_HOME="/var/lib/jenkins"

for job_dir in "$JENKINS_HOME"/jobs/*/; do
    job_name="$(basename "$job_dir")"

    for build_dir in "$job_dir"/builds/*/; do
        rm -rf "$build_dir"
    done
done
