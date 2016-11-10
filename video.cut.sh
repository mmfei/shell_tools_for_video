
if [[ "$#" -lt "2" ]]; then
    echo "/bin/bash "$0" inputFileConfig outputVideoFile"
    echo "/bin/bash "$0" abc.800x600.txt a.mp4"
    echo "/bin/bash "$0" abc.txt a.mp4"
    exit
fi

inputFileConfig=$1 #要求是 文件名.800x600.txt
outputVideoFile=$2

if [ ! -d $tmpDir ]; then
	mkdir -p $tmpDir;
fi

#处理文件名
name=`basename $inputFileConfig .txt` #文件名
# echo $name
resolution=`echo $name | cut -d "." -f2` #分辨率 (最终是800x600) , 如果为空 , 则不转换分辨率


tmpDir="tmp/$inputFileConfig/" #临时目录
if [ ! -d $tmpDir ]; then
	mkdir -p $tmpDir
fi


echo "读取配置的内容:$inputFileConfig"

# cat $inputFileConfig;
tmpConcatFile="aaa.$inputFileConfig.concat.filelist.txt"

if [[ -f "$tmpConcatFile" ]]; then
	rm $tmpConcatFile;
fi

tmpFfmpegCMD="$tmpDir/tmp.ffmpeg.sh"

echo "执行切割视频中.....";
i=1;
cat $inputFileConfig | sed '/^$/d'  | sed "/^#/d" | while read videoFile start end
do
	# echo ""
	# echo "******************"
	# echo "内容:$LINE";
	# videoFile=`echo $LINE | cut -d " " -f1`;
	# videoFile=`echo $LINE | awk -F " " '{print $1}'`;
	# start=`echo $LINE | awk -F " " '{print $2}'`;
	# end=`echo $LINE | awk -F " " '{print $3}'`;
	# echo $videoFile;
	# echo "videoFile:$videoFile:$start->$end";

	# ffmpeg -i GOPR8915.MP4 -ss 00:02:00 -to 00:02:30 -c copy aadddd.mp4
	echo "ffmpeg -i $videoFile -ss $start -to $end -c copy -y aaa.$i.$outputVideoFile > log 2>&1;" >> $tmpFfmpegCMD;
	# ffmpeg -i $videoFile -ss $start -to $end -c copy -y aaa.$i.$outputVideoFile  > log 2>&1; 
	# ffmpeg -i $videoFile -ss $start -to $end -c copy -y aaa.$i.$outputVideoFile; 
	echo "file 'aaa.$i.$outputVideoFile'" >> $tmpConcatFile;
	# echo "finished $i";
	i=$(($i+1))
done

cat $tmpFfmpegCMD;

if [[ ! -f "$tmpFfmpegCMD" ]]; then
	echo "无规则文件 $tmpFfmpegCMD";
	exit;
else
	sh $tmpFfmpegCMD > log 2>&1;
	echo "切割完成";

	rm $tmpFfmpegCMD;
fi



#concat
if [[ -f $tmpConcatFile ]]; then

	echo "执行合并视频中...[ $tmpConcatFile => $outputVideoFile ]";

	cat $tmpConcatFile;

	echo "ffmpeg -f concat -i **$tmpConcatFile** -c copy -y $outputVideoFile  > log 2>&1;";
	ffmpeg -f concat -i **$tmpConcatFile** -c copy -y $outputVideoFile  > log 2>&1; 

	# read ad;

	# rm $tmpConcatFile; 

	rm aaa.*.$outputVideoFile; #删除临时文件
fi

echo "设置分辨率$resolution";
if [[ ! -z $resolution ]]; then
	echo "执行转换分辨率中....[ $resolution ]"
	mv $outputVideoFile $tmpDir/out.out.mp4;
	echo "ffmpeg -i $tmpDir/out.out.mp4 -s $resolution $outputVideoFile";
	ffmpeg -i $tmpDir/out.out.mp4 -s $resolution $outputVideoFile  > log 2>&1;
	# read sd;
	rm $tmpDir/out.out.mp4;

fi


echo 'success';


# ffmpeg -vcodec mpeg4 -r:10 -i 铿锵玫瑰.mp4 -s 800x600 铿锵玫瑰800x600.mp4
# ffmpeg -f concat -i **a.txt** -c copy 铿锵玫瑰800x600.finished.mp4
# ffmpeg -i o.MP4 -s 800x600 o.o.mp4
