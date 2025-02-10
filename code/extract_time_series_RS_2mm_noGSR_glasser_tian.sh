#!/bin/bash

#SBATCH --job-name RS_time_series
#SBATCH --cpus-per-task=4
#SBATCH --output=/scratch/loliver/SPINS_PLS_Conn/RS_2mm_noGSR_time_series_glasser_tian.txt
#SBATCH --error=/scratch/loliver/SPINS_PLS_Conn/RS_2mm_noGSR_time_series_glasser_tian.err

module load ciftify

# extract resting-state time series data from each glasser and tian scale II ROI

sub_dir=$(ls -d -- /projects/ttan/SPINS/SPINS_rest/data/preprocessed/sub*) # lists subject directories

#sub_dir=$(ls -d -- /scratch/loliver/SPINS_PLS_Conn/sub-CMH0002)

for dir in ${sub_dir}; do
    subj=$(basename ${dir})

  if [ ! -f /scratch/loliver/SPINS_PLS_Conn/$subj/$subj_RS_2mm_noGSR_glasser_tian_meants.csv ]; then
   #mkdir /scratch/loliver/SPINS_PLS_Conn/${subj}
   ciftify_meants --outputcsv /scratch/loliver/SPINS_PLS_Conn/${subj}/${subj}_RS_2mm_noGSR_glasser_tian_meants.csv ${dir}/2_mm_no_GSR/${subj}_ses*_task-rest_run*_desc-cleansm2_bold.dtseries.nii /projects/loliver/SPINS_PLS_Conn/data/parcellations/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors.32k_fs_LR_Tian_Subcortex_S2.dlabel.nii
  fi

done
