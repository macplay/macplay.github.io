.. title: ffmpeg 命令行参数调优
.. slug: ffmpeg-ming-ling-xing-can-shu-diao-you
.. date: 2018-03-04 17:44:20 UTC+08:00
.. tags: ffmpeg, shell, terminal
.. category:
.. link:
.. description:
.. type: text
.. nocomments:
.. password:
.. previewimage:

.. raw:: html

   <video src="/videos/time_machine.mp4" loop autoplay>
       Your browser does not support the video tag.
   </video>

文件大小 325 KB。

完整命令：

.. code:: console

   ffmpeg -y -i mv.mp4 -ss 00:02:24.000 -to 00:02:29.000 -c:v libx264 -an -crf 35 -b:v 100k -r 10 -preset slow out.mp4

如果加上音轨 `-b:a 11k` ，则体积上升到 350 KB。

很理想了。
