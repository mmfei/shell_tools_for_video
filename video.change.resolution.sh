# ffmpeg -i o.MP4 -s 800x600 o.o.mp4
if [[ "$#" -lt "3" ]]; then
    echo "/bin/bash "$0" souredirpath targetdirpath 800x600"
    exit
fi

dir=$1;
todir=$2;
changeResolution=$3;
if [[ ! -d "$dir" ]]; then
    exit;
fi
if [[ ! -d "$todir" ]]; then
    mkdir -p $todir;
fi
scriptname="$dir/tmp.tmp.sh"
if [[ -f "$scriptname" ]]; then
    rm $scriptname;
fi
for name in `ls $dir`
do
   echo " echo 'changing $name to $changeResolution'; " >> $scriptname; 
   echo " ffmpeg -i $dir/$name -s $changeResolution $todir/$changeResolution.$name.mp4" >> $scriptname; 
done

if [[ -f "$scriptname" ]]; then
    sh $scriptname;
    #rm $scriptname;
fi

echo "path $todir";
ls $todir;
echo "successful";

