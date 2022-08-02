source ../built/install.sh

count_failed=0

run_test() {
  test_case=$1

  diff \
    ${test_case}/expected.txt \
    <(bash ${test_case}/generate-fixture.sh | cnt --no-progress)

  if [ $? -eq 0 ]; then
    echo -e "$test_case:\tPASSED"
  else
    count_failed=$(($count_failed + 1))
    echo -e "$test_case:\tFAILED"
  fi
}

run_test minimal
run_test one-to-ten

if [ $count_failed -eq 0 ]; then
  echo "All tests passed"
  exit 0
else
  echo "${count_failed} failed cases"
  exit 1
fi
