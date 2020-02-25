.. title: FFmpeg Filtering Guide
.. slug: ffmpeg-filtering-guide
.. date: 2020-02-24 20:50:03 UTC+08:00
.. tags:
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. previewimage:

FFmpeg Filtering 介绍
=====================

Filtering in FFmpeg is enabled through the libavfilter library.

In libavfilter, a filter can have multiple inputs and multiple outputs. To illustrate the sorts of things that are possible, we consider the following filtergraph::



                    [main]
    input --> split ---------------------> overlay --> output
                |                             ^
                |[tmp]                  [flip]|
                +-----> crop --> vflip -------+

This filtergraph splits the input stream in two streams, then sends one stream through the crop filter and the vflip filter, before merging it back with the other stream by overlaying it on top. You can use the following command to achieve this:

.. code:: shell

    ffmpeg -i INPUT -vf "split [main][tmp]; [tmp] crop=iw:ih/2:0:0, vflip [flip]; [main][flip] overlay=0:H/2" OUTPUT

以上引自 FFmpeg Filtering 官方手册。对 filtergraph 概念和语法基本了解之后，我们就可以参照 Filtering 入门 [#]_ 以及 Filters 文档 [#]_ 尝试编写出想要的效果。

.. [#] https://ffmpeg.org/ffmpeg-filters.html#Video-Filters

.. [#] https://ffmpeg.org/ffmpeg-filters.html#Filtering-Introduction

但是，首先，我们来创建演示用的视频素材。

testsrc
=======

    A filter with no input pads is called a "source", and a filter with no output pads is called a "sink".

没有输入端的 filter 被称为 source。也就是说，某些 filter（source）可被用来创建视频片段。当然，这些片段一般是通过特定算法生成的。

.. code:: shell

    ffmpeg -f lavfi -i testsrc=duration=10:size=1280x720:rate=30 movie1.avi

创建大小 1280x720 时长 10s 的视频片段，testsrc 是 ffmpeg 内置的 source filters 之一。


.. code:: shell

    ffmpeg -f lavfi -i testsrc=duration=20:size=1280x720:rate=30 temp.avi

创建时长 20s 的第二个片段。

注意到文件的 ``.avi`` 扩展名了吗？使用其它扩展名/编码其实也可以，但是在下一步切割片段时会遇到问题。假如使用 mp4/libx264 编码，接下来进行切割：

.. code:: shell

    ffmpeg -i temp.mp4 -ss 00:00:10 -c copy -y movie2.mp4

会发现 movie2.mp4 并没有如预料中的从 10s 处截断，而是有非常明显的偏移。

>>> ffprobe movie2.mp4
    Input #0, mov,mp4,m4a,3gp,3g2,mj2, from 'movie2.mp4':
      Metadata:
        major_brand     : isom
        minor_version   : 512
        compatible_brands: isomiso2avc1mp41
        encoder         : Lavf58.29.100
      Duration: 00:00:03.33, start: 6.666016, bitrate: 104 kb/s
        Stream #0:0(und): Video: h264 (High 4:4:4 Predictive) (avc1 / 0x31637661), yuv444p, 1280x720 [SAR 1:1 DAR 16:9], 99 kb/s, 30 fps, 30 tbr, 15360 tbn, 60 tbc (default)
        Metadata:
          handler_name    : VideoHandler

可以看到时长和开始时间都不正常。通过 ffmpeg wiki [#]_ 我们发现，将 ``-ss`` 放到 ``-i`` 之前或者 ``-copyts`` 选项，可以让开始时间重置为 0。另外，enable ``-seek_timestamp`` 选项，可以让 ffmpeg 将 ``-ss`` 视为真实的时间戳而非从文件开头的偏移量。

但是，片段时长问题依旧。很容易想到的一个可能是，ffmpeg 是按照关键帧来搜寻切割的。但是，加上 ``-accurate_seek`` 选项后，依旧没有效果。而且，阅读 wiki 后发现 ``-accurate_seek`` 自 ffmpeg 2.1 版本之后，默认就是开启的。

    As of FFmpeg 2.1, when transcoding with ffmpeg (i.e. not just stream copying), -ss is now also "frame-accurate" even when used as an input option.

这里，我们需要注意 ``transcoding`` 和 ``stream copying`` 适用场景，ffmpeg 仅在转码时是时间戳精确的，而在此处我们拷贝流时则不是。具体原因为何，需要搞清楚 PTS（Presentation Time Stamp） 与 DTS（Decoding Time Stamp）的区别 [#]_ ，简单来说，面对纷繁复杂的各种容器、格式，在 demuxer 解包之前，ffmpeg 的时间戳可能是不准确的，要么具体情况具体分析要么彻底解包后获得。

.. [#] https://trac.ffmpeg.org/wiki/Seeking

.. [#] https://video.stackexchange.com/questions/25291/how-to-precisely-trim-video-with-ffmpeg-ss-and-t-are-off-by-more-than-a-half

使用 ``.mp4`` 的另一个问题是，如上所示，其生成的视频片段 Pixel Format 为 ``yuv444p`` ，这会导致其在浏览器中无法播放，提示文件已损坏。相应的补救措施是使用 ``-pix_fmt yuv420p`` 进行转换。

无论如何，现在，我们得到了想要的两个视频片段：

.. container:: ui stackable grid

    .. container:: eight wide column

        .. raw:: html

           <video src="/videos/movie1.mp4" loop autoplay>
               Your browser does not support the video tag.
           </video>

    .. container:: eight wide column

        .. raw:: html

           <video src="/videos/movie2.mp4" loop autoplay>
               Your browser does not support the video tag.
           </video>

接下来，我们来尝试 ffmpeg 的 filter 功能。
