#!/bin/bash

notmuch tag -inbox -- path:/.*\/Sent\sMail\|Trash/
notmuch tag +spam -- path:/.*\/Spam/
notmuch tag +draft -- path:/.*\/Drafts/
notmuch tag +sent -- path:/.*\/Sent\sMail/

notmuch tag +personal -- path:/Personal/
notmuch tag +netease -- path:/Netease163/

# notifications and so on
notmuch tag +notification -- from:notifications@github.com
