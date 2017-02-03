ffmpeg -ss 00:00:00.000 -i testsrc.mpg -t 30 out-1.mp4
ffmpeg -ss 00:00:30.000 -i testsrc.mpg -t 30 out-2.mp4
ffmpeg -ss 00:01:00.000 -i testsrc.mpg -t 30 out-3.mp4
ffmpeg -ss 00:01:30.000 -i testsrc.mpg -t 30 out-4.mp4
ffmpeg -ss 00:02:00.000 -i testsrc.mpg -t 30 out-5.mp4

ffmpeg -f concat -safe 0 -i testsrc-source.txt -c copy output.mp4
