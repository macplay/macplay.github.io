.. title: FFmpeg Filtering Guide
.. slug: ffmpeg-filtering-guide
.. date: 2020-02-24 20:50:03 UTC+08:00
.. updated: 2020-02-26 17:29:53 UTC+08:00
.. tags: ffmpeg
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. previewimage: /images/ffmpeg_datascope.thumbnail.png

.. figure:: /images/ffmpeg_datascope.thumbnail.png
    :target: /images/ffmpeg_datascope.png
    :alt: ffmpeg_datascope
    :align: center

.. contents:: 文档目录

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

.. TEASER_END

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

会发现 movie2.mp4 并没有如预料的从 10s 处截断，而是有非常明显的偏移。

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

可以看到时长和开始时间都不正常。通过 ffmpeg wiki [#]_ 我们发现，将 ``-ss`` 放到 ``-i`` 之前或者 ``-copyts`` 选项，可以让开始时间重置为 0。另外，开启 ``-seek_timestamp`` 选项，可以让 ffmpeg 将 ``-ss`` 视为真实的时间戳而非从文件开头的偏移量。

但是，片段时长问题依旧。很容易想到的一个可能是，ffmpeg 是按照关键帧来搜寻切割的。但是，加上 ``-accurate_seek`` 选项后，依旧没有效果。而且，阅读 wiki 后发现 ``-accurate_seek`` 自 ffmpeg 2.1 版本之后，默认就是开启的。

    As of FFmpeg 2.1, when transcoding with ffmpeg (i.e. not just stream copying), -ss is now also "frame-accurate" even when used as an input option.

这里，我们需要注意 ``transcoding`` 和 ``stream copying`` 适用场景。FFmpeg 仅在转码时是时间戳精确的，而在此处我们拷贝流时则不是。具体原因为何，需要搞清楚 PTS（Presentation Time Stamp） 与 DTS（Decoding Time Stamp）的区别 [#]_ ，简单来说，面对纷繁复杂的各种容器、格式，在 demuxer 解包之前，ffmpeg 的时间戳可能是不准确的，要么具体情况具体分析要么只能彻底解包后获得。

.. [#] https://trac.ffmpeg.org/wiki/Seeking

.. [#] https://video.stackexchange.com/questions/25291/how-to-precisely-trim-video-with-ffmpeg-ss-and-t-are-off-by-more-than-a-half

使用 ``.mp4`` 的另一个问题是，如上所示，其生成的视频片段 Pixel Format 为 ``yuv444p`` ，这会导致其在浏览器中无法播放，提示文件已损坏。相应的补救措施则是，使用 ``-pix_fmt yuv420p`` 进行一次转换。

无论如何，现在，我们得到了想要的两个视频片段：

.. container:: ui stackable grid

    .. container:: eight wide column

        .. raw:: html

           <video src="/videos/movie1.mp4" loop autoplay muted playsinline>
               Your browser does not support the video tag.
           </video>

    .. container:: eight wide column

        .. raw:: html

           <video src="/videos/movie2.mp4" loop autoplay muted playsinline>
               Your browser does not support the video tag.
           </video>

接下来，我们来尝试 ffmpeg 的 filter 功能。

在 ffmpeg/ffplay 中使用 filters
===============================

对于常见的 scale, crop, negate, rotate 等 filter 使用，我们不做过多介绍。官方 wifk [#]_ 也提供了不少例子，这里仅记录除此之外个人觉得有用、有趣的其它一些。

.. [#] https://trac.ffmpeg.org/wiki/FancyFilteringExamples

在 ffmpeg 中使用是最自由、最不受限制的一种。然而，通常我们并不想等待 ffmpeg 转码完成，创建文件之后，再使用播放器打开观看—最好能边转边看。这种情况下，使用 ffplay 就是一种更好的选择。但 ffplay 自身也有限制，其 ``-i`` 参数仅允许输入一条媒体流，想要多流处理再输出就很麻烦，而且其界面也过于简陋。这时，我们就可以先用 ffmpeg 处理，再使用匿名管道转发给其它应用。比如：

.. code:: shell

    ffmpeg -i movie1.mp4 -i movie2.mp4 -filter_complex "hstack" -f avi - | mpv -

将两支视频水平堆叠处理，再转发给 mpv 播放器。

.. raw:: html

   <video src="/videos/hstack.mp4" loop autoplay muted playsinline>
       Your browser does not support the video tag.
   </video>

其实，视频比对还有更精确的方法：

.. code:: shell

    ffplay -f lavfi "movie='movie1.mp4'[a];movie='movie2.mp4'[b];[a][b]blend=all_mode=grainextract"

.. raw:: html

   <video src="/videos/grainextract.mp4" loop autoplay muted playsinline>
       Your browser does not support the video tag.
   </video>

是的，以上命令特意使用了 ffplay 而非匿名管道。FFplay 的单条视频流限制有方法可以一定程度上绕过，答案是使用 ``movie`` filter。

给视频添加图片水印：

.. code:: shell

    ffmpeg -i movie1.mp4 -i qrcode.png -filter_complex "[1:v]scale=128:-1[w],[0:v][w]overlay=10:10" -f mpegts - | mpv -

.. figure:: /images/ffmpeg_watermark.thumbnail.png
    :target: /images/ffmpeg_watermark.png
    :alt: ffmpeg_watermark
    :align: center

.. code:: shell

    ffmpeg -i movie1.mp4 -i qrcode.png -filter_complex "[1:v]scale=128:-1[w],[0:v][w]overlay=(W-w)/2:(H-h)/2" -f mpegts - | mpv -

将水印放在屏幕正中间。

.. code:: shell

    ffmpeg -i movie1.mp4 -filter_complex "pad=2*iw:2*ih:ow-iw:oh-ih:color=#71cbf4" -f mpegts - | mpv -

将屏幕扩展成两倍大小，并将媒体流放到右下方。

.. figure:: /images/ffmpeg_pad.thumbnail.png
    :target: /images/ffmpeg_pad.png
    :alt: ffmpeg_pad
    :align: center

水印效果实际上使用了 ``overlay`` filter，其对视频流也是起作用的。

.. code:: shell

    ffmpeg -an -i movie1.mp4 -i movie2.mp4 -filter_complex "[0:v]scale=360:-1[o],[1:v][o]overlay=10:10:eof_action=pass" -f mpegts - | mpv -

.. raw:: html

   <video src="/videos/overlay.mp4" loop autoplay muted playsinline>
       Your browser does not support the video tag.
   </video>

移除第一条媒体流的音轨，并将其叠加到第二条媒体流的左上角， ``eof_action=pass`` 意为如果 overlay 的时长比主画面还长，则将 overlay 区域恢复原状。

.. code:: shell

    ffmpeg -i movie1.mp4 -filter_complex "split[m][s];[s]scale=360:-1,setpts=PTS+3/TB[bt];[m][bt]overlay=10:10:shortest=1" -f mpegts - | mpv -

在屏幕左上方显示主画面 3s 前的预览。

.. raw:: html

   <video src="/videos/setpts.mp4" loop autoplay muted playsinline>
       Your browser does not support the video tag.
   </video>

.. code:: shell

    ffmpeg -i file.mp4 -filter_complex "[0:a]asplit[t1];[t1]showvolume=w=1280[t2];[0:v][t2]overlay" -f mpegts - | mpv -

将 audio filter ``showvolume`` 创建的音频可视化图表叠加到主画面上方。

.. code:: shell

    ffplay -f lavfi -i nullsrc=s=256x256 -vf "geq=random(1)*255:128:128"

雪花屏效果。

mpv player
==========

作为主力播放器，mpv 有着舒服的界面和键位绑定。我们仍然希望能在 mpv 中使用 filter。事实上，最初翻阅 ffmpeg 手册的动机之一，就是希望能在 mpv 中同时并排播放两条视频流。

``--lavfi-complex`` 选项提供了这一能力，通过它 mpv 可以访问 libavfilter 的 filters。

.. code:: shell

    mpv null:// --lavfi-complex="mandelbrot[vo]"

播放内置 source filter mandelbrot 分形。

.. code:: shell

    mpv null:// --lavfi-complex="movie='movie1.mp4'[a];movie='movie2.mp4'[b];[a] scale=320:-1 [c];[b][c]overlay [vo]"

将 ``movie1.mp4`` 缩放并叠加到 ``movie2.mp4`` 左上方。

注意到其使用了 ``movie`` filter 来加载视频流。原因是 mpv 与 ffplay 一样，同样有单条媒体流的限制。不过，mpv 也提供了另一个选项： ``--external-file`` 来加载其它文件，这样就突破了单流限制，可以在 ``--lavfi-complex`` 中使用 ``aidN/vidN`` 来访问媒体流。

.. code:: shell

    mpv "https://example.com/file.m3u8" --external-files="movie.mp4" --lavfi-complex="[vid1][vid2]hstack[vo]" --no-resume-playback

而 mpv 通过 ytdl 支持在线直播。这样，我们就实现了同时播放远端视频流和本地文件。至于 layout 如何，hstack 还是 overlay 依个人需求而调整。

mmate
=====

mmate 是我不久前写的一个 mpv 伴侣软件。原因是我厌倦了追剧时浏览器中复制媒体地址，再打开命令提示符，输入 mpv 命令打开剧集…这一整个流程。mmate 会监视系统剪贴板，智能识别其中的媒体地址，依情况打开 mpv 播放器或将该媒体添加到播放列表。为了更大的灵活性，我还绘制了一个控制台界面，方便直接向 mpv 发送各类控制消息。当然，也包含 filters 处理消息。

.. figure:: /images/mmate.png
    :alt: mmate
    :align: center

通过发送 ``vf/af <operation> <value>`` 消息，mpv 可以对正在播放中的媒体实时运用 filters 并输出。其支持的 filters 可以执行 ``mpv -vf/af=help`` 后获知。比如， ``vf toggle negate`` 运用/取消负片效果。同时运用多个 filters： ``vf toggle crop=100:100,negate`` 。或者使用 ``vf add/remove <value>`` 将某 filter 添加到列表，再使用 toggle 命令运用或取消某一个或几个 filters。使用 ``vf cls ""`` 清除整个 filters 列表。如果某个/组 filters 语法巨复杂巨长，你可以使用 ``@label`` 给其添加标签。

以下整理了一些目前为止发现的有用有趣的 filters：

``vf toggle format=gray``

黑白影片。

``vf toggle @grid:drawgrid=width=100:height=100:thickness=2:color=red@0.5``

在画面上绘制格子。

.. figure:: /images/ffmpeg_grid.thumbnail.png
    :target: /images/ffmpeg_grid.png
    :alt: ffmpeg_grid
    :align: center

``vf toggle tile=2x2:nb_frames=4:padding=7:margin=2``

磁贴分割。

.. figure:: /images/ffmpeg_tile.thumbnail.png
    :target: /images/ffmpeg_tile.png
    :alt: ffmpeg_tile
    :align: center

``vf toggle drawbox=x=200:y=200:w=200:h=200:color=black@0.5:t=fill``

Drawbox。

.. figure:: /images/ffmpeg_drawbox.thumbnail.png
    :target: /images/ffmpeg_drawbox.png
    :alt: ffmpeg_drawbox
    :align: center

``vf toggle tblend=all_mode=grainextract``

帧差异比较。

``vf toggle swaprect=w/2:h:0:0:w/2:0``

区域替换 swaprect。

``vf toggle histogram=display_mode=0:level_height=244``

直方图。

``vf toggle vectorscope=color4``

vectorscope.

.. raw:: html

   <video src="/videos/vectorscope.mp4" loop autoplay muted playsinline>
       Your browser does not support the video tag.
   </video>

``vf toggle waveform=e=3``

.. figure:: /images/ffmpeg_waveform.thumbnail.png
    :target: /images/ffmpeg_waveform.png
    :alt: ffmpeg_waveform
    :align: center

``vf toggle oscilloscope=x=0.5:y=0:s=1``

oscilloscope.

.. figure:: /images/ffmpeg_oscilloscope.thumbnail.png
    :target: /images/ffmpeg_oscilloscope.png
    :alt: ffmpeg_oscilloscope
    :align: center

``vf toggle datascope=mode=color2``

datascope. 本文题图。
