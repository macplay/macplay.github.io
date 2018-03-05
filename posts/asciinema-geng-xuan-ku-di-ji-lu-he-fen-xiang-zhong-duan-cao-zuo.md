<!--
.. title: asciinema - 更炫酷地记录和分享终端操作
.. slug: asciinema-geng-xuan-ku-di-ji-lu-he-fen-xiang-zhong-duan-cao-zuo
.. date: 2016-04-21 21:34:12 UTC+08:00
.. updated: 2018-03-05 18:57:25 UTC+08:00
.. tags: asciinema, terminal, screencast
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:
-->

具体请访问官网： [asciinema - Record and share your terminal sessions, the right way](https://asciinema.org)

基于文本的录屏工具，对终端输入输出进行捕捉，然后以文本的形式来记录和回放！这使其拥有非常炫酷的特性：在“播放”过程中你随时可以暂停，然后对“播放器”中的文本进行复制或者其它操作！实际效果可以点击下方的播放按钮查看。

具体原理简单点说，就是把终端显示和时间戳记录成 ~~json~~ **cast** 格式，然后使用 JavaScript 脚本解析出来。配合官方提供的 CSS 样式，乍看起来以为是视频播放器，然而它却是不折不扣的文本。相比视频录屏或 GIF 动图的方式，文件体积小的不可思议（比如以下时长 2:49 的录屏仅为 325KB ），不需缓冲即可播放，可以更方便的分享给他人或者嵌入到网页中。

<!-- TEASER_END -->

安装和使用都非常简单：

终端中输入 `brew update && brew install asciinema` 即可安装。

使用方法：运行 `asciinema rec` 开始，录制完成后输入 `exit` 或按 `Ctrl-D` 结束。然后询问你是否上传，回车可将录制文件上传到官网并得到访问链接。使用浏览器打开链接即可观看刚记录的操作，再然后根据需要选择分享该链接或进行其它操作。

如何将「录屏」操作嵌入到博客，官方提供了较详细的说明。然而从别的网站拉取所有文件，可能遭遇到功夫墙并且访问速度有些慢，于是琢磨将其放到自个儿博客，最终效果用户体验非常好。

以下嵌入的是为本博客添加 asciinema 支持的录屏步骤：

<asciinema-player src="/asciicast/asciinema_start.cast" cols=110 rows=29 poster="npt:02:29"></asciinema-player>

小结：以后嵌入录屏文件，仅需粘贴以上代码行，修改 ~~json~~ **cast** 文件指向即可。~~json~~ **cast** 文件可从录制时直接输入 `asciinema rec demo.cast` 得到。

--------------------------------------------------------------------------------

**更新**

之前这篇文章讲的是将 asciinema 嵌入 [MkDocs](http://www.mkdocs.org/) 博客，而现在个人使用的是 [Nikola](https://getnikola.com/) 博客。以上的步骤当然已经失效，但是大概步骤是差不多的，所以仍然将该文章迁移到这里。将 asciinema 嵌入 Nikola 博客，只在模板文件里增加了 6 行代码。具体情形这里就不展开说了，详情可以参阅 GitHub 上的 [asciinema-player](https://github.com/asciinema/asciinema-player) 项目。

当然，可能有人更关心在文章中如何嵌入 asciinema 录屏文件。时隔这么久，这一步骤实际上更方便了：

```html
<asciinema-player src="/demo.cast"></asciinema-player>
```

只需一行！

如果需要参数自定义播放器的话，可以参阅官方手册。

THE END.
