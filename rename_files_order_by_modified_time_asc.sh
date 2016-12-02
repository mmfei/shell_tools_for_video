#!/bin/bash
# For batch rename files in folder order by modified time
# 把指定目录的文件改名 , 改成按照时间升序排序,并加前缀序号
pwd=`pwd`;
dir="$1";
ext="$2";
if [[ ! -d "$dir" ]]; then
	echo "empty dir";
	exit
fi

if [[ -z "$ext" ]]; then
	ext="mp4";
fi
ls $dir/*.$ext;
echo "rename $dir/*.$ext?(y/n)";
read ok;

if [[ "$ok" != "y" ]]; then
	echo "canncel";
	exit;
fi

cd $dir;
num=1
for f in `/bin/ls -tr *.$ext`; do
	len=`echo ${#num}`;
	if [[ $len < 2 ]]; then
		num1="0$num";
	else
		num1=$num;
	fi
	mv $f $num1"_"$f;
    let num=$num+1;
done
echo "rename success!";
echo "ls $dir";
cd $pwd;
