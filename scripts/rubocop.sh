# !/bin/bash

set -e

ALLOWED_WARNINGS=135
warnings=`rubocop --format simple | grep "offenses detected" | cut -d " " -f4`

if [ $warnings -gt $ALLOWED_WARNINGS ]
then
  echo -e "allowed warnings $ALLOWED_WARNINGS"
  echo -e "actual warnings $warnings"
  echo -e "Too many rubocop warnings"
  echo -e "Try running 'rubocop' so see what's going on."
  exit 1
else
  echo $warnings/$ALLOWED_WARNINGS is close enough ಠ_ಠ
  exit 0
fi
