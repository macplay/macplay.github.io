<!--
.. title: 如何解压 macOS 下的 pkg 文件
.. slug: ru-he-jie-ya-macos-xia-de-pkg-wen-jian
.. date: 2015-03-29 09:39:26 UTC+08:00
.. updated: 2017-10-26 08:00:00 UTC+08:00
.. tags: terminal, bash
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:
-->

有时候我们可能需要解包 pkg 格式的安装文件包，在 macOS 系统下完成该操作并不需要你额外再安装软件，系统内置的命令就可以。步骤也比较简单：

```bash
xar -xf Setup.pkg
cat mac-screenshot-gotd.pkg/Payload | cpio -i
```

![extract pkg](/images/jie_ya_pkg_wen_jian.png "extract pkg")

鉴于截图部分已经很清晰明白，就不多废话了。参考资料来自：[这里][original article]

原文讲的是 Linux 系统下解压 PKG 文件，步骤略有不同。有需要请自取。

[original article]:http://www.hoverlees.com/blog/?p=303 "http://www.hoverlees.com/blog/?p=303"
