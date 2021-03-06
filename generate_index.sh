#!/bin/bash

declare -A catalog_comment_dict
catalog_comment_dict=([calc]="关于Cacl的内容" [elisp-common]="关于elisp的内容" [org-mode]="关于org-mode的内容" [emacs-common]="其他未分类的emacs内容" [raw]="未翻译或者翻译到一半的内容" [reddit]="reddit好问题" [Eshell]="Eshell之野望")

catalogs=$(for catalog in ${!catalog_comment_dict[*]};do
               echo $catalog
           done |sort)

function generate_headline()
{
    local catalog=$1
    echo "* " $catalog
    echo ${catalog_comment_dict[$catalog]}
    echo 
    generate_links $catalog |sort -t "<" -k2 -r
}

function generate_links()
{
    local catalog=$1
    posts=$(ls -t $catalog)
    old_ifs=$IFS
    IFS="
"
    for post in $posts
    do
        modify_date=$(git log --date=short --pretty=format:"%cd" -n 1 $catalog/$post) # 去除日期前的空格
        echo "+ [[https://github.com/lujun9972/emacs-document/blob/master/$catalog/$post][$post]]		<$modify_date>"
    done
    IFS=$old_ifs
}

for catalog in $catalogs
do
    generate_headline $catalog
done
