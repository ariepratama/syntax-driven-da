#!/bin/bash

export SIZE=$1
export RUN_DATETIME=$2
export REPLACED_NON_TERMINAL=$3
export NUM_GENERATED_SENTENCES=$4
export AUGMENTATION=$5
export RANDOM_SEED=$6
export TIME=$7
export N_REPLACED_NON_TERMINAL=$8
export PRETRAINED_DIR=$9
export DATA_DIR=/home/u26/ariesutiono/da-coling2020/data
export LOG_DIR=/xdisk/hahnpowell/clu-daug/logs
export RESULT_DIR=/xdisk/hahnpowell/clu-daug/result-logs

export NAME_SUFFIX="${SIZE}-${AUGMENTATION}-${NUM_GENERATED_SENTENCES}-${REPLACED_NON_TERMINAL}-${N_REPLACED_NON_TERMINAL}-${RANDOM_SEED}-${RUN_DATETIME}"

sbatch --job-name=da-coling2020-${NAME_SUFFIX} \
--output=${LOG_DIR}/${NAME_SUFFIX}.sbatch.log \
--time=${TIME} \
--partition=standard \
--account=clu-ling \
--mail-type=ALL \
--mail-user=ariesutiono@email.arizona.edu \
--ntasks=1 \
--cpus-per-task=1 \
--gres=gpu:1 \
--mem=8GB \
--export=DATA_DIR=${DATA_DIR},LOG_DIR=${LOG_DIR},DATA_SIZE=${SIZE},RUN_DATETIME=${RUN_DATETIME},REPLACED_NON_TERMINAL=${REPLACED_NON_TERMINAL},NUM_GENERATED_SENTENCES=${NUM_GENERATED_SENTENCES},AUGMENTATION=${AUGMENTATION},RANDOM_SEED=${RANDOM_SEED},N_REPLACED_NON_TERMINAL=${N_REPLACED_NON_TERMINAL},RESULT_DIR=${RESULT_DIR},PRETRAINED_DIR=${PRETRAINED_DIR} \
run_experiment.sh