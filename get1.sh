#!/bin/bash
#ダウンロードしたい記事のurlを書いたファイルを引数で与えると，ダウンロードしてくれます
mkdir .original
cat "$1" | while read url ;
do
	name=$(echo "$url" | sed 's/http.*com\///' | sed 's/\/.*//') 
	./get2.sh "$url" "$name"
done
