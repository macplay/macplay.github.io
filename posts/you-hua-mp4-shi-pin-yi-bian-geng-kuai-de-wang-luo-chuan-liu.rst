.. title: 【译】优化 MP4 视频以便更快的网络串流
.. slug: you-hua-mp4-shi-pin-yi-bian-geng-kuai-de-wang-luo-chuan-liu
.. date: 2018-03-18 18:06:03 UTC+08:00
.. tags: mp4, video, website, translation
.. category:
.. link: https://rigor.com/blog/2016/01/optimizing-mp4-video-for-fast-streaming
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

随着 `Flash 的落寞 <http://thenextweb.com/apps/2015/09/01/adobe-flash-just-took-another-step-towards-death-thanks-to-google/>`_ 以及 `移动设备的爆发性增长 <http://searchengineland.com/its-official-google-says-more-searches-now-on-mobile-than-on-desktop-220369>`_ ，越来越多的内容以 HTML5 视频的方式传递。在上一篇文章中你甚至能看到 `使用 HTML5 视频替换 GIF 动图来优化网站访问速度 <http://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video>`_ 这样的技巧。然而事实上，视频格式本身就有一堆优化技巧可用来改善它们的性能表现。其中非常重要的一点，就是视频文件可以合理优化以便作为 HTML5 视频在网络上串流播放。否则的话，播放视频文件可能会有数百毫秒的延迟，同时导致数兆字节的带宽被浪费，只因网站访客试图播放你的视频。在这篇文章里，我将向你展示如何优化视频文件以便在网络上更快地串流播放。

.. TEASER_END

MP4 串流是如何工作的？
----------------------

正如我们在 `上一篇文章 <http://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video>`_ 中讨论过的，HTML5 视频是无需像 Flash 那样需要插件支持即可观看视频的跨浏览器方案。到现今 2016 年， `经过 H.264 编码的视频存储在 MP4 容器之中 <http://rigor.com/blog/2015/12/optimizing-animated-gifs-with-html5-video>`_ （以下我将简单地称其为 MP4 视频），并统一成为所有在线 HTML5 视频的标准格式。所以，当我们谈及优化 HTML5 视频时，我们真正讨论的是如何优化 MP4 文件以便更快地串流播放。至于如何做到，则与 MP4 文件的结构以及视频串流如何工作有很大关系。

`MP4 文件由名为 "atoms" 的数据块构成 <http://www.adobe.com/devnet/video/articles/mp4_movie_atom.html>`_ 。有存储字幕或章节的 `atoms` ，同样也有存储视频和音频数据的 `atoms` 。至于视频和音频 `atoms` 处于哪个位置，以及如何播放视频诸如分辨率和帧速等，这些元数据信息都存储于一个名为 `moov` 的特殊 `atom` 之中。你可以将 `moov` atom 理解成 MP4 文件的某种 *目录列表* 。

当你播放视频时，程序搜寻整个 MP4 文件，定位 `moov` atom，然后使用它找到视频和音频数据的开头位置，并开始播放。然而， `atoms` 可能以任何顺序存储，所以程序无法提前得知 `moov` atom 在文件的哪个位置。如果你已经拥有整个视频文件，搜寻并找到 `moov` atom 问题并不大。然而，当你还没有拿到整个视频文件（比如说你串流播放 HTML5 视频时），恐怕就希望可以有另外一种方式。而这，就是串流播放视频的关键点！你无需事先下载整个视频文件，就可以立即开始观看。

当串流播放时，你的浏览器会请求视频并接受文件头部，它会检查 `moov` atom 是否在文件开头。如果 `moov` atom 没有在文件开头，则它要么得下载整个文件并试图找到 `moov` ，要么下载视频文件的不同小块并寻找 `moov` atom，反复搜寻直到遍历整个视频文件。

搜寻 `moov` atom 的整个过程需要耗费时间和带宽。很不幸的是，在 `moov` 被定位之前的这段时间里，视频都不能开始播放。从下面的截图中，我们能看到浏览器播放未经优化的 MP4 视频时的瀑布图。

.. figure:: /images/mp4-no-moov.png
   :alt: mp4-no-moov.png
   :align: center

你能看到浏览器在播放视频前进行了 3 次请求。第一个请求中，浏览器使用 `HTTP range request <https://en.wikipedia.org/wiki/Byte_serving>`_ 下载了视频文件的前 552 KB 字节。通过 HTTP 返回码的 206 Partical Content 报告，以及仔细查看请求头部数据，我们可以得知这一点。然而， `moov` atom 并没有被找到，浏览器仍不能开始播放视频。接下来，浏览器又使用一次范围请求（range request）拉取视频文件最末尾的 211 KB 字节。这次则包含了 `moov` atom，可以告知浏览器视频和音频从何处开始播放。终于，浏览器做了第三次也是最后一次请求，获得视频/音频数据，并开始播放视频。到这里，我们已经浪费了超过半兆字节的带宽，并将视频的播放推迟了 210 毫秒！仅仅是因为浏览器无法找到 `moov` atom。

如果你没有配置服务器以支持 HTTP 范围请求（range request），事情甚至会变得更糟。浏览器将不能来回部分请求来找到 `moov` ，而 **必须下载整个视频文件** 。这也是为何你应该 `优化服务器支持部分下载技术 <https://zoompf.com/blog/2010/03/performance-tip-for-http-downloads>`_ 的另一原因。

将 MP4 视频用作 HTML5 串流的理想方式，就是重组视频文件，使得 `moov` 正好位于文件开头。这样的话，浏览器可以避免下载整个文件，或者浪费时间进行额外请求以找到 `moov` 。为串流优化过的视频网站请求瀑布图，如下图所示：

.. figure:: /images/mp4-fast-start.png
   :alt: mp4-fast-start.png
   :align: center

将 `moov` 置于文件开头，视频将会更快地加载和播放，带来更好的用户体验。

优化 MP4 以便更快的网络串流
---------------------------

我们已经知道，要想优化视频为 HTML5 串流播放，则需要重组 MP4 atoms，以便 `moov` atom 位于文件开头。那么我们究竟要如何做呢？大多数视频编码软件都有“为 web 优化”或“为串流优化”的选项，正是用来做这件事情的。当创建视频时，你应该检查一下视频编码设置，以确保它被优化。比如在下面的截图中，我们看到开源软件 `Handbrake <https://handbrake.fr/>`_ 有一个“Web Optimized”的选项，它将确保 `moov` atom 处于文件开头。

.. figure:: /images/handbrake.png
   :alt: handbrake.png
   :align: center

当从源视频创建 MP4 的时候，这是一个可行的解决方案。但是，如果你拥有的已经是 MP4 文件呢？

你仍然可以重组已有的视频，优化它以适应 web 串流播放。开源编码器 `FFMpeg <https://www.ffmpeg.org/>`_ 命令行可以重组 MP4 文件，将 `moov` atom 放到文件开头。不像初始编码时那样消耗时间和 CPU，重组文件是一项更容易的操作，并且也不会以任何方式损失视频质量。下面是使用 ffmpeg 优化 `input.mp4` 文件的例子，输出文件名为 `output.mp4` 。

``ffmpeg -i input.mp4 -movflags faststart -acodec copy -vcodec copy output.mp4``

`-movflags faststart` 参数告诉 ffmpeg 重组 MP4 文件 atoms，将 `moov` 放到文件开头。我们同时告诉 ffmpeg 拷贝视频和音频数据，而非重新编码，这样其它任何东西都不会发生变动。

针对 Rigor 的客户，我们已经给 Zoompf-- `我们的性能分析和优化产品 <https://zoompf.com/features>`_ --添加了一项新功能，它将会检测 MP4 文件是否已经为 HTML5 视频串流优化。如果你仅仅想要快速检查一下你的网站，可以使用 `我们的免费性能报告服务 <https://zoompf.com/free>`_ 。

结论
----

无论你正在将 GIF 动图转换为 MP4 视频，还是手头已经有一大堆 MP4 视频，你都可以优化文件结构，以使得这些视频更快地加载和播放。通过重组 atoms 将 `moov` 放到文件开头，浏览器可以避免发送额外的 HTTP range request 请求来搜寻和定位 `moov` atom。而这，将允许浏览器立即开始串流播放视频。通常情况下，当你初始创建视频时，可以配置选项让其为串流播放而优化。如果你已有 MP4 文件，可以使用 ffmpeg 这类工具来重组文件，而不会更改其它的内容。
