grep -oP '(?<=\{\{\{).+?(?=\}\}\})' $1  | sort | uniq
