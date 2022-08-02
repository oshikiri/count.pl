for i in $(seq 1 10); do
  for j in $(seq 1 $((100*$i))); do
    echo $i
  done
done
