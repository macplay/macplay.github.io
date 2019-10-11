.. title: Improve and Extend Your Text Objects With `targets.vim`_
.. slug: improve-and-extend-your-text-objects-with-targetsvim
.. date: 2019-10-11 17:05:40 UTC+08:00
.. tags: vim, translation
.. category: vim
.. link: https://www.barbarianmeetscoding.com/blog/2019/08/11/exploring-vim-plugins-improve-and-extend-your-text-objects-with-targets-vim
.. description:
.. type: text
.. nocomments:
.. previewimage: /images/become-1-percent-better.jpg

Welcome back to the `Exploring Vim Plugins series <https://www.barbarianmeetscoding.com/blog/categories/exploring-vim-plugins>`_ ! In this series you learn how to become a little bit more productive each day by discovering awesome Vim plugins and how to master them. And today, it’s time for one of my favorites: `targets.vim`_ .

.. figure:: /images/become-1-percent-better.jpg
   :alt: become 1 percent better
   :align: center

.. TEASER_END

.. contents::
   :depth: 1

`targets.vim`_ is one of those plugins that truly enhances the way you work by supercharging one of the most fundamental Vim features: **text objects** .

Text Objects In Vim
===================

One of the best things about Vim is how it allows you to edit text with high precision. You type `daw` and Vim follows your command and **d** eletes a **w** ord. You type `ci'` and Vim goes ahead and helps you **c** hange some text **i** nside single quotes. Vim gives you this precision by combining its useful operators (delete, change, yank, etc) with a host of motions amongst which the most powerful are **text objects** .

**Text objects** describe the parts of a document: a word, a sentence, a paragraph, text within quotes, code blocks, HTML tags and more. In the previous examples, the `aw` and `i'` particles in `daw` and `ci'` are text objects:

- `aw` stands for **a word**
- `i'` stands for **inside single quotes**

Using operators in combination with text objects Vim gives you fine granularity and a lot of power to edit text-based documents and code.

So, if **text objects are so awesome, what do we need a plugin for** ? Well, What is more awesome than text-objects? **MORE** of them!

MORE Text Objects!!!!
=====================

**Have you ever wanted to change text between commas** ? Now you can! Let’s say we have this sentence:

.. code:: ReST

   I think, most of the time, therefore I am.

Type `ci`, followed by `all of the time` and `<ESC>` and voila!

.. code:: ReST

   I think, all of the time, therefore I am.

**Have you ever wanted to edit the parameters and arguments of a function** ? Now you can too!

Imagine that we have this **obliterate** function that allows us to inflict inordinate amount on pain amongst our foes:

.. code:: javascript

   function obliterate(target, mana) {
     const damage = mana*1d20() + 1d100();
     target.hp -= damage;
     console.log(`${target} is obliterated with a ray of dark energy`);
   }

We’d like the `mana` parameter to be optional and have a default value. Using `targets.vim`_ **argument** text object we can directly edit the `mana` argument as follows:

1. `c2ina` to change **i** nside the second **n** ext **a** rgument
2. `{mana=20}={}<ESC>` to have this argument be optional and provide a default value of `20`

**Isn’t it awesome?!**

`targets.vim`_ comes with lots of new text objects that give you a whole new level of precision, control, repeatability and speed when using Vim:

- Separators like ``,.;:+-=~_*#/|\&$``
- Arguments and parameters within functions
- Multitext objects that work with several pairs at once: `b` which can operate on any block (`{([`) and `q` that can operate on any quote.

Wait There’s More! Unifying and Improving Seeking Behavior
===========================================================

`targets.vim`_ doesn’t stop at adding new operators. It also improves the user experience and usefulness of all text objects.

One inconsistency that you may have noticed when using operators on text objects is how any quote text object behaves slightly different from the other ones. Unlike other text objects, quotes support seeking forward so that the cursor doesn’t need to be on top of the text object to operate on it. This is better illustrated with an example so imagine that you have a string like this one:

.. code:: javascript

   const greeting = "Hello Oh Mighty Wizard! I salute you!"
   ^

where the cursor is located on the first letter and represented by that `^` sign. Using `ci"` when can change the contents of that string even when we are not on top of the quotes themselves.

This seeking behavior is great because it means that we can save ourselves the keystrokes needed to position the cursor on top of the quotes. Alas, with other text objects there’s no seeking behavior.

Examine the following function:

.. code:: javascript

   const salute = (name) => `Hello Oh Mighty ${name}! I salute you`
   ^

Now let’s say that we’d like to change the name of that `name` argument. You may think that typing `ci(` would let you change the `name` argument at once but that is not the case.

The `(` text object doesn’t support seeking forward and so you’d need to perform the transformation in two separate steps.

First, you’d need to move the cursor with `f(`:

.. code:: javascript

   const salute = (name) => `Hello Oh Mighty ${name}! I salute you`
                  ^

And then you’d be in the position of changing that `name` with `ci(` since the `(` text object is under your cursor.

**The seeking behavior is superior because it allows you to do more with less keystrokes and because it lets changes be more easily repeated with the `.` command**. Unfortunately, such is not our luck and vanilla Vim only supports this behavior for quote text objects.

So what if I told you that `targets.vim`_ unifies and extends this seeking behavior to all text objects? Extend it so that we could use `ci(` in the previous example and be able to change that argument at once?

Yes! That would be awesome news just by itself. But `targets.vim`_ doesn’t stop there. `targets.vim`_ **gives you forward and backward seeking behavior across multiple lines** .

This is a simplified version of how seeking works:

1. If your cursor is on top of a text object, the operator applies to that text object
2. Otherwise it seeks forward within a line
3. If there’s no text object forward, it seeks backwards within a line
4. If there’s no text object in this line, it seeks forward
5. If there’s no text object in this line nor anywhere down a document, it seeks backwards.

Awesome right? This means that you can save even more keystrokes and edit text that much faster. Wihoo!

But what if you don’t want to change the next occurrence of a text object? What if you want to change the previous one? Does that mean that you need to move the cursor there first? No. The makers of `targets.vim`_ had great foresight and allow you to explicitly specify which text object you want to operate on with the `n` (for **n** ext) and `l` (for **l** ast) commands. Type:


- `cin[` and you’ll change the contents of the **next** pair of square brackets (this behaves exactly the same as `ci[`)
- `cil[` and you’ll change the contents of the **previous** pair of square brackets

These commands can also be combined with **counts** to operate on distant text objects:

- `c2in[` lets you change the contents of the second next pair of square brackets and so on.

Isn’t all of this extremely awesome?

Wait Again! There’s Even More! A, In, Around and Inside
========================================================

With vanilla Vim you have two modifiers that you can use when operating on text objects: `a` and `i` .

- `a"` means **a quoted string** and it includes all the characters of a quoted string including the quotes
- `i"` means **in quoted string** and it includes all the characters of a quoted string minus the quotes

`targets.vim`_ offers two new modifiers that let you be even more accurate: `A` and `I` .

- `A"` means **around a quote string** and includes one trailing whitespace in addition to the whole string including the quotes.
- `I"` means **inside a quote string** and includes the content inside quoted string excluding the quotes and any inner trailing whitespace. This is useful if you want to preserve whitespace inside a quotes, blocks and such.

.. figure:: /images/targets-vim-modifiers.jpg
   :alt: targets vim modifiers
   :align: center

Getting Started with targets.vim
================================

1. Install the plugin using your favorite plugin manager. You can find `more info about plugins managers and how to install plugins in this article <https://www.barbarianmeetscoding.com/blog/2019/05/31/exploring-vim-plugins-a-methodology-to-become-1-percent-better-every-week>`_
2. Practice as follows

`targets.vim`_ is one of those plugins that are seamless to learn and practice because they fit so well inside the philosophy of Vim. Since it extends such a core feature of Vim as text objects, using the new separators or argument text objects just feels natural to experienced Vim users. So natural in fact, that you probably wonder why these text objects aren’t built inside of Vim from the start.

From my personal experience, some of the things that will require some additional deliberate practice are the explicit seeking behaviors which aren’t present in the vanilla Vim experience:

0. Start using the new separators (this will just come naturally so I don’t think you’ll need to practice it deliberately)
1. Start taking advantage of the seeking behavior by using text objects directly from wherever the cursor is instead of moving on top a text object itself. This will make you faster, and it will make your changes more repeatable (using the `.` operator).
2. Practice with the explicit `n` and `l` seeking modifiers.
3. Practice using `A` instead of `a` and `I` instead of `i` and notice the different result.

Find out More
=============

The `documentation <https://github.com/wellle/targets.vim>`_ for this Vim plugin is truly **exceptional** , very thorough and with lots of helpful diagrams. So take a look at it `on GitHub <https://github.com/wellle/targets.vim>`_ or within Vim via the `:help targets` command.

Additionally, the `targets.vim cheatsheet <https://github.com/wellle/targets.vim/blob/master/cheatsheet.md>`_ is also very useful summary reference and provides lots of visual aids.

.. _`targets.vim`: https://github.com/wellle/targets.vim
