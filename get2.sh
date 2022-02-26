#!/bin/bash
curl -Lso- "$1" >> tmp1
cat tmp1 | sed -ne "/id=\"page-title\"/,/class=\"page-tags\"/p" | sed 's/ja\.scp-wiki\.net/scp-jp.wikidot.com/g' | sed -e "s/href=\"java//g" | sed -E "s/<a\shref=\"([^\"]+)\">([^<]+)</\2(🔗\1🔗)</g" | sed -E "s/footnote-[0-9]+'\)\">/>📝/g" | sed 's/<li>/・/g' | sed 's/Link To Guide.*//' | sed -E 's/<img src=\"(http[^"]+)\"/📷(\1) </' | cat >> tmp2

offset=$(cat tmp2 | rg -o "http://scp-jp\.wikidot\.com/$2/offset/.+🔗" | sed -n '$p' | sed 's/🔗//')
judge=$(echo "$offset" | rg "page\d+_limit")
if [ "$judge" != "" ] ; then
	judge=$(./get3.sh "$1" "$offset")
else
	judge=$(./get4.sh "$1" "$offset")
fi

if [ "$judge" = "recuresion" ] ; then
	./get2.sh "$offset" "$2"
else
	cat tmp1 | sed -ne "/class=\"page-tags\"/,/id=\"page-info-break\"/p" |  sed "s/<\/a>/\n/g" | sed -r 's/<a\shref.+>([^<]+)/🔖\1/g' | cat >> tmp2
	cat tmp2 | sed -E 's/\s+🔖/🔖/g' | nkf -Z0 | sed -E 's/<[^<]*>//g' | sed -E '/^\s*$/d' | sed 's/\&gt;/>/g' | sed 's/\&lt;/</g' | sed 's/\&nbsp;/ /g' | sed 's/\&quot;/"/g' | sed 's/\&raquo;/≫/g ' | sed 's/&laquo;/≪/g ' | sed 's/\&amp;/&/g' | sed 's/\&laquo;/“/g' | sed 's/\&raquo;/”/g' | sed 's/\&bdquo;/„/g' | sed 's/\&amp/\&/g' |  nkf --numchar-input | sed -E "1s/^\s*//" | cat > "$2".fmtl
	mv tmp1 ./.original/$2.html
	rm tmp2
	echo "$2 done!"
	exit
fi
