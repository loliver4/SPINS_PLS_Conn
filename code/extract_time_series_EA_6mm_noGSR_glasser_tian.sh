#!/bin/bash

#SBATCH --job-name EA_time_series
#SBATCH --cpus-per-task=4
#SBATCH --output=/scratch/loliver/SPINS_PLS_Conn/EA_time_series_glasser_tian.txt
#SBATCH --error=/scratch/loliver/SPINS_PLS_Conn/EA_time_series_glasser_tian.err

module load ciftify

# extract EA residual signal from each glasser and tian scale II ROI at each timepoint

sub_dir=$(ls -d -- /scratch/loliver/SPINS_PLS_Conn/sub*) # lists ea subject directories

#sub_dir=$(ls -d -- /scratch/loliver/SPINS_PLS_Conn/sub-CMH0002)

for dir in ${sub_dir}; do
    subj=$(basename ${dir})
    in_dir="/projects/ttan/SPINS/analysis/GLM/${subj}/6_mm_no_GSR"

  if [ ! -f $dir/$subj_EA_6mm_noGSR_glasser_tian_meants.csv ]; then
   ciftify_meants --outputcsv ${dir}/${subj}_EA_6mm_noGSR_glasser_tian_meants.csv ${in_dir}/${subj}_task-emp_parametric-load_residual_contrast-map.dscalar.nii /projects/loliver/SPINS_PLS_Conn/data/Q1-Q6_RelatedValidation210.CorticalAreas_dil_Final_Final_Areas_Group_Colors.32k_fs_LR_Tian_Subcortex_S2.dlabel.nii
  fi

done
