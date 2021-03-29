# Metaphlan3_snakemake
Snakemake pipeline for the QC and taxonomic annotation by Metaphlan3 of WGS metagenomes

## Installation procedure

### Create a conda environment
Navigate to the conda_env directory and run:

'''
conda env create -f environment.yml
'''

Then install the metaphlan3 databases by running the setup_metaphlan.slurm script

## Run the pipeline
It is best to first run the FastQC step alone, take a look at the QC report generated and eventually update the Trimming step of the pipeline. Use the option --until fastq to run the first part of the pipeline first.


Edit the run.slurm script to your partition, aaccount and email specificities.

By default the system will submit a maximum of 60 jobs. To run the complete pipeline run:

'''
sbatch run.slurm
'''


