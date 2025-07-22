#!/bin/bash

# modify CULane to yours
CULane="/workspace/seg_label_generate/training_data"

./seg_label_generate \
    -l ${CULane}/list/train.txt \
    -m trainList \
    -d $CULane

# The generated list file would be saved as "${CULane}/list/train_gt.txt"
