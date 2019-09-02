.. title: macOS 的文本替换功能
.. slug: macos-de-wen-ben-ti-huan-gong-neng
.. date: 2017-11-24 18:28:19 UTC+08:00
.. tags: macos, ime
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. previewimage:

前一段时间抹盘重装了 High Sierra 系统，发现之前定义好的文本替换全丢了。ᔪ(°ᐤ°)ᔭᐤᑋᑊ̣心想可能是 iCloud 抽风，过几天就同步过来了。然而，等到今天也没见同步过来。多半是永远也过不来了。这造成了非常严重的后果：我无法使用文本替换轻松输入特殊符号，也无法在打字聊天的时候输入颜文字卖萌了！(>_<)ͪͨͧͦ 趁着今天有空，我决定解决掉这个问题。

首先还是网络搜索了一下，看看文本替换功能是否支持导入导出，或者至少有个可备份的文件。否则，就算这次搞好也还是有数据丢失的风险，那过分依赖该功能就太不明智了。很快找到了来自苹果官方的结果： `How to export and import text substitutions on your Mac`_ 。根据这份帮助手册，文本替换是支持导入导出的，而且操作很简单。只需在文本替换 tab 页选中要导出的条目，将其拖放到桌面就会自动生成 `Text Substitutions.plist` 文件。而要导入数据的话，则直接把该文件拖回到文本替换 tab 页即可。是不是很简单？(ˊo̴̶̷̤⌄o̴̶̷̤ˋ)✧

.. _`How to export and import text substitutions on your Mac`: https://support.apple.com/en-us/HT204006

.. TEASER_END

解决掉后顾之忧，就可以开心地继续接下来的工作了。从 App Store 下载了一个颜文字软件，然后将其中感觉不错的挨个复制粘贴，并赋予它们触发词。经过一阵折腾后，就可以轻松使用颜文字卖萌了。(⌐■_■)

最终效果如下：

.. figure:: /images/kaomoji_input.png
   :align: center

图中使用的是系统默认输入法，仅前两项是我们刚使用文本替换自定义的。至于 4, 7 项中的 emoji 是拼音输入法本身就自带的。当初挺怀念文本替换功能，原因之一就是与系统结合紧密，随时可用。

鉴于最重要的颜文字输入需求已经解决 (⁎ְְ⁍̵̆ᴗְְְ⁍ັ̴⁎) 其它特殊字符以后随着输入需求逐渐增加即可，不必急于一时。

当然，这次得学乖点：肯定要将文本替换条目导出备份。如果你也有输入颜文字的需求，可以下载 `该文件`_ ，将其拖放到文本替换 tab 页导入即可使用。◠‿◠

.. _`该文件`: /listings/kaomoji.plist

.. figure:: /images/text_substitutions.thumbnail.png
   :align: center
   :target: /images/text_substitutions.png

感谢阅读！ ▄█▀█🌑ｶﾞｰﾝ
