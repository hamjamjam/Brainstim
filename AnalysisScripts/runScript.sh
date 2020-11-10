filename=$1

module purge

module load matlab

matlab -nodesktop -nodisplay -r "clear; ${filename};"
