#!/bin/bash

font_sizes='20 24'
fonts='Georgia Rockwell'
book_json='./app/book.json'
target_book_dir='../book'

if [[ "$OSTYPE" == "darwin"* ]]; then
  echo "You're running this in OSX. Yay!"
else
  echo "This script only works in OSX!"
  exit 1
fi

npm --prefix ./app install

for font in $fonts;
do
  for font_size in $font_sizes;
  do
    echo "font: $font"
    echo "font_size: $font_size"
    sed -i .bak -e "s/\(fontSize\": \)\(.*\)\(,\)/\1${font_size}\3/" -e "s/\(fontFamily\": \"\)\(.*\)\(\",\)/\1${font}\3/" "${book_json}"
    rm "${book_json}.bak"
    BOOK_BUILD_DIR="${target_book_dir}" npm --prefix ./app run pdf
  done;
done;

for d in {app,docs}/media/pdf;
do
  cp app/*.{epub,mobi,pdf} $d 2>/dev/null
done

rm app/*.{epub,mobi,pdf} 2>/dev/null