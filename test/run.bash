source ../built/count.sh

count_failed=0

run_test() {
  test_case=$1

  diff \
    ${test_case}/expected.txt \
    <(bash ${test_case}/generate-fixture.sh | cnt)

  if [ $? -eq 0 ]; then
    echo -e "$test_case:\tPASSED"
  else
    count_failed=$(($count_failed + 1))
    echo -e "$test_case:\tFAILED"
  fi
}

run_test one-to-ten
