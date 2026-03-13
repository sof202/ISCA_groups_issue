#!/bin/bash
#SBATCH --export=ALL
#SBATCH -p mrcq 
#SBATCH --time=00:01:00
#SBATCH -A Research_Project-MRC190311 
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=16
#SBATCH --mem=1G
#SBATCH --mail-type=END 
#SBATCH --output=/dev/null
#SBATCH --error=/dev/null
#SBATCH --job-name=permissions

FAILED_LOG="failed.log"
SUCCESS_LOG="success.log"

temp_file="/tmp/groups_${SLURM_JOB_ID}_err.tmp"
groups_output=$(groups 2>"${temp_file}")
groups_exit=$?
groups_stderr=$(cat "${temp_file}"; rm "${temp_file}")

if [[ $groups_exit -eq 0 ]]; then
    number_of_groups=$(echo "${groups_output}" | wc -w)
    if [[ "${number_of_groups}" -le 10 ]]; then
        output_file="${FAILED_LOG}"
        reason="num_groups: ${number_of_groups}"
    else
        output_file="${SUCCESS_LOG}"
        reason=""
    fi
else
    output_file="${FAILED_LOG}"
    reason="${groups_stderr}"
fi

# I'd love to use a heredoc for this bit, but I don't want to run into problems
# with /tmp being full

timestamp=$(date -u)
echo -e "<${timestamp}>\t${SLURM_JOB_ID}\t${SLURM_JOB_PARTITION}\t${SLURM_JOB_NODELIST}\t${SLURM_TASK_PID}\t${reason}"  >> "${output_file}"
