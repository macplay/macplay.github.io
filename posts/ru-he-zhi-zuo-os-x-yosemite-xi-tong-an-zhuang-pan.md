<!--
.. title: 如何制作 OS X Yosemite 系统安装盘
.. slug: ru-he-zhi-zuo-os-x-yosemite-xi-tong-an-zhuang-pan
.. date: 2015-12-28 15:03:41 UTC+08:00
.. updated: 2017-10-26 11:03:41 UTC+08:00
.. tags: terminal, macos
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:
-->

最近在等 Yosemite 10.10.2 正式版推出，然后给手头的小白来个抹盘纯净重装。当然前提是需要可启动的系统安装盘，趁有空整理一下之前搜集的网上资料。

制作启动盘的方法主要参考 [lifehacker](http://lifehacker.com/how-to-burn-os-x-yosemite-to-a-usb-flash-drive-1647137212 "http://lifehacker.com/how-to-burn-os-x-yosemite-to-a-usb-flash-drive-1647137212") 和 [pc6](http://www.pc6.com/edu/69791.html "http://www.pc6.com/edu/69791.html") 的两篇文章，加上个人折腾的一点心得。

首先你需要准备Yosemite系统镜像，只要之前通过苹果应用商店升级的话，都能非常方便地在`已购`选项卡中找到镜像并下载。按以往的经验应用商店的下载速度还是比较快的，如果下载过程中无聊可以去忙点别的事情。下载完成后镜像会出现在 `Applications` 文件夹，注意千万不要点升级就行。接下来就是比较重要的制作过程：

<!-- TEASER_END -->

### 使用 DiskMaker X 制作

恐怕是最适合懒人和小白的方法了。 [DiskMaker X](http://liondiskmaker.com/ "http://liondiskmaker.com/") 作为一款免费软件，非常强大和易用，我的第一个系统安装盘就是通过它制作完成的。你需要插入至少 8GB 的 U 盘(事先备份好资料)，然后启动 DiskMaker X 一路按照提示鼠标点击就可以。需要提醒的是，制作过程可能比较长中间有段时间没有任何反应，千万不要以为软件挂了然后强制结束，耐心等待其完成。

### 使用终端命令操作

将准备好的 U 盘、移动硬盘或 SD 卡插入 Mac，并启动磁盘工具对该介质执行`抹掉`操作。盘符名请命名为 ”Untitled” ，格式为 `Mac OS Extended (Journaled)`/`Mac OS 扩展（日志式）`。

打开 `终端`, 在命令行中执行下面的命令，当提示输入密码时请输入你的 OS X 管理员登陆密码。这里需要区分下中文版和英文版的制作方法：

#### 英文版

	sudo /Applications/Install\ OS\ X\ Yosemite.app/Contents/Resources/createinstallmedia --volume /Volumes/Untitled --applicationpath /Applications/Install\ OS\ X\ Yosemite.app --nointeraction

#### 中文版

	sudo /Applications/安装\ OS\ X\ Yosemite.app/Contents/Resources/createinstallmedia --volume /Volumes/Untitled --applicationpath /Applications/安装\ OS\ X\ Yosemite.app --nointeraction

直接复制代码，然后 `Command + V` 粘贴到`终端`。如果一切正常的话`终端`界面中就会显示 Erasing Disk: 0%… 10%…20%… ，并最终完成制作。

无论通过哪种方法制作，完成后都不要急着删除Yosemite系统镜像。重启按住 `option` 键看下是否正常出现安装盘符，确认制作成功。

使用移动硬盘分区来制作安装盘可能是更好的选择。一方面移动硬盘没那么容易丢，读写速度也可以，另一方面如果使用大于 8 GB 的 U 盘多出来的空间就浪费掉了，而你本来可以用更便携的 U 盘从 windows 同事那拷贝资料什么的。移动硬盘新开辟一个 8 GB 的分区，不仅成本更低，而且 NTFS 和 HFS+ 格式可以共存，日常使用连接 windows 电脑也完全不受影响。

至于 SD 卡制作安装盘，目前还没尝试过，期待折腾党们的报告。:)
