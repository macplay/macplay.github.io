.. title: Nikola 博客资源链接问题
.. slug: nikola-bo-ke-zi-yuan-lian-jie-wen-ti
.. date: 2017-10-19 17:41:40 UTC+08:00
.. tags: nikola, static site
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

写博客的时候，经常会插入各种超链接。外部链接不必理会，正常插入即可。但是博客内部链接（譬如，请参阅上一篇文章： `30 分钟搭建一个 Nikola 博客`_ ）却是需要额外关注，规范做法应该是这样： `/posts/30-fen-zhong-jian-li-yi-ge-nikola-bo-ke/` ，而不是这样： `https://macplay.github.com/posts/30-fen-zhong-jian-li-yi-ge-nikola-bo-ke/` 。从最终效果来看貌似没有区别，但是如果发布到其它站点或者将来更换域名，第二种做法的缺陷就暴露出来了：届时需要将成百上千篇文章中的链接进行相应替换。因此，及早规范博客内部链接还是比较重要的。

.. _`30 分钟搭建一个 Nikola 博客`: /posts/30-fen-zhong-jian-li-yi-ge-nikola-bo-ke/

.. TEASER_END

.. contents:: 文章目录

使用相对链接
============

第一种规范做法其实就是“尽量使用相对链接”，避免外部环境变动对博客/文档造成不必要的影响。对于 Nikola 博客而言，这里的“相对”指的是网站根目录。作为静态博客，Nikola 的文件输出层级比较简单，概况如下：

>>> lt -T ~/mysite/output/
/Users/ashfinal/mysite/output
├── categories
├── documents
│  ├── print_output.pdf
│  └── xetex_output.tex
├── favicon.ico
├── galleries
│  ├── liuthangdeheliutupian-014.jpg
│  ├── liuthangdeheliutupian-014.thumbnail.jpg
├── images
│  ├── avatar.png
│  ├── avatar.thumbnail.png
├── listings
├── posts
│  ├── 30-fen-zhong-jian-li-yi-ge-nikola-bo-ke
│  │  ├── index.html
│  │  └── index.rst
└── videos
   ├── ncm_scope.mp4
   └── vim_table.mp4

链接语法则像这样：

.. code:: rst

   .. _`30 分钟搭建一个 Nikola 博客`: /posts/30-fen-zhong-jian-li-yi-ge-nikola-bo-ke/

其中 `posts` 是所有文章的输出目录，而紧跟其后的则是文章的 URL 字符串，由文章的 meta 信息 `slug` 自动生成。如果使用 `nikola new_post` 命令新建文章，则文件名称和 `slug` 是默认一致的。

.. warning::

   你当然可以自定义文章 `slug` ，但最好还是不要做任何改动。这样引用文章就可以直接输入文件名，而不必打开文件去查看文章的 `slug` 。

除此之外，Nikola 博客其实提供了专门的 `doc 指令`_ ，用来链接内部文档，语法如下：

.. code:: rst

   Take a look at :doc:`my other post <creating-a-theme>` about theme creating.


.. _`doc 指令`: https://getnikola.com/handbook.html#id98

个人觉得相对链接的方式已经足够，就没有使用该指令。

既然说到资源链接，那就再顺便说一下 Nikola 博客中插入图片及其它资源的问题。

图片资源链接
============

通常来说，如果有专用图床的话，那再好不过。即便使用 `https://username.somecdn.com/myphoto1.jpg` 这样的绝对链接，问题也不大，因为一般图床的图片链接是很稳定的，不会轻易变更。如果你没在使用图床，那么笔者推荐将图片与文章放到同一个 GitHub 仓库。这样做的原因有以下几点：

- **Nikola 博客支持**

  和所有文章一样，可使用相对链接的方式引用本地图片。Nikola 甚至默认生成缩略图，方便将图片资源用于不同场景。

- **管理方便**

  插入图片再也不必重复“上传到图床 -> 获取链接 -> 粘贴到文章”等步骤，直接引用本地图片，最终与文章等一起推送到远端仓库。不必担心图床服务下线无法访问，或者因过期未续费而面临数据清除的风险。

- **访问速度快**

  和所有图床服务一样，直接从 GitHub Pages 存取图片，可充分利用其全球 CDN 网络优势，提升博客静态资源的加载速度。

- **随时迁移**

  和所有图床服务一样，如果将来更换域名，甚至整体迁出 GitHub，图片链接毋需任何更改。

插入本地图片
------------

只需将图片放入网站源文件的 `images` 目录，就可以使用相对链接的方式在文章中随处引用。Nikola 默认会将 `images` 目录里的所有图片压缩，将其缩放到 1080p 尺寸，并且为其生成 400 像素的缩略图，文件名形如： `myimage.thumbnail.jpg` ，如果有必要的话可充分利用这一点——文章页面仅加载缩略图，点击再加载高清大图，提升博客网页的加载速度及在移动设备上的访问体验。

.. code:: rst

   .. image:: /images/avatar.thumbnail.png
      :target: /images/avatar.png
      :align: center

.. image:: /images/avatar.thumbnail.png
   :target: /images/avatar.png
   :align: center

已放入 `相册（galleries）` 中的图片也会生成缩略图，也可以在文章中引用。

.. code:: rst

   .. image:: /galleries/liuthangdeheliutupian-014.jpg

控制仓库容量
------------

有些人担心将图片这种二进制文件放到 GitHub 仓库，仓库容量可能会暴增，因为图片本身很不适合版本管理。

从个人实际使用经验来说，容量占用其实没那么大，还可以接受。根据 GitHub Pages 的服务说明 [#]_ ，单个仓库容量的限制为 1 GB，指的是网站源文件大小，渲染的网站文件并不占据空间。目前本博客 20 余篇文章，图片数量 20 余张，空间占用为 17 MB。平均一篇文章不到 1 MB，这样的话，就算笔耕不辍每天写一篇文章，也可以足足使用三年。如果仓库容量真的满了以后，可以选择付费扩展空间；或者注册新账号（GitHub 并没有限制单 IP 申请），使用同样的主题模版继续写作。

.. [#] https://help.github.com/articles/what-is-github-pages/

当然在日常使用中，对图片文件大小还是要稍微关注一下。比如写游记的时候，就不要将相机拍摄的照片未经任何压缩处理直接添加到仓库中。而对于网络图片或者屏幕截图，其文件大小均在合理范围之内，一般是不需要任何处理的。

总体而言，将图片和文章等放到同一 GitHub 仓库，带来的好处在笔者看来是显而易见的。

其它资源链接
============

如果想在博客上展示 PDF、音乐、短视频等等其它二进制文件，也是可以的——将其放到网站源文件的 `files` 目录即可。建议根据文件类型单独建立子文件夹，比如“pdfs”、“music”等。Nikola 博客在进行静态页面渲染的时候，会将 `files` 目录下的所有文件（夹）都复制到网站根目录下。所以其引用链接如下：

.. code:: rst

   查看 `pdf 样张`_ 。

   .. _`pdf 样张`: /pdfs/myfile.pdf

此外，如果你有一些图片并不希望 Nikola 对其进行处理，也可以建立子文件夹存放到 `files` 目录。

总结
====

及早建立良好的静态博客写作规范，可以避免以后更改带来的繁复任务量。链接、图片或其它资源的站内引用，原则上应尽量使用相对链接。本博客根据自身情况，将图片等二进制资源与文章存放到一起，读者朋友们的博客是如何处理的呢？欢迎在评论区谈谈你的看法。
