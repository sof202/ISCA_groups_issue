#!/bin/bash
#SBATCH --export=ALL
#SBATCH -p mrcq 
#SBATCH --time=00:01:00
#SBATCH -A Research_Project-MRC190311 
#SBATCH --nodes=1 
#SBATCH --ntasks-per-node=16
#SBATCH --mem=1G
#SBATCH --mail-type=END 
#SBATCH --output=permissions%j.log
#SBATCH --error=permissions%j.err
#SBATCH --job-name=permissions

FAILED_LOG="failed.log"
SUCCESS_LOG="success.log"

# Number of groups should be 102 for me, but maybe there's a chance one or
# two slip through, I don't fuckin know.
number_of_groups=$(groups | wc -w)
if [[ $? -eq 0 ]];
    if [[ "${number_of_groups}" -le 10 ]]; then
        output_file="${FAILED_LOG}"
        reason="num_groups: ${number_of_groups}"
    else
        output_file="${SUCCESS_LOG}"
    fi
else
    output_file="${FAILED_LOG}"
    reason="${number_of_groups}"
fi

# I'd love to use a heredoc for this bit, but I don't want to run into problems
# with /tmp being full

timestamp=$(date -u)
echo -e "<${timestamp}>\t${SLURM_JOB_ID}\t${SLURM_JOB_PARTITION}\t${SLURM_JOB_NODELIST}\t${SLURM_TASK_PID}\t${reason}"  >> "${output_file}"
