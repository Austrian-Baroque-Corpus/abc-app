# bin/bash

echo "fetching transkriptions from data_repo"
rm -rf data && mkdir data
curl -LO https://github.com/austrian-baroque-corpus/abc-data/archive/refs/heads/main.zip
unzip main

mkdir data/editions
mv ./abc-data-main/data/editions/* data/editions
touch "data/editions/about.xml"
echo "<about><title>Austrian Baroque Corpus ABaC:us</title><description>Austrian Baroque Corpus ABaC:us</description></about>" > data/editions/about.xml

rm -rf abc-data-main
rm main.zip
