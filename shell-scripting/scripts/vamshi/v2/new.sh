#!/bin/bash
echo -e "Checking whether the target file with a set of key words exists or not\n"

while read name
do
  grep $name source.txt > /dev/null
  if [ $? -eq 0 ]; then
        echo -e "$name is present in the source file \n"
  else
        echo -e "Oops, sorry, $name is not present in the source file. \n"
        exit;
  fi
done < keywords.txt

echo "The target file has all the key words present and successfully verified!!"
exit 0