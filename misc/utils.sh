function filename_to_gpu_str() {
  script_filename=`basename "$0"`
  gpu_str=""
  if [[ $script_filename == *"0"* ]]; then gpu_str="${gpu_str}0,"; fi
  if [[ $script_filename == *"1"* ]]; then gpu_str="${gpu_str}1,"; fi
  if [[ $script_filename == *"2"* ]]; then gpu_str="${gpu_str}2,"; fi
  if [[ $script_filename == *"3"* ]]; then gpu_str="${gpu_str}3,"; fi
  if [[ $script_filename == *"4"* ]]; then gpu_str="${gpu_str}4,"; fi
  if [[ $script_filename == *"5"* ]]; then gpu_str="${gpu_str}5,"; fi
  echo $gpu_str
}
