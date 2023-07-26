#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""Fabric script that generates a\
.tgz archive from the contents of\
the web_static folder of your AirBnB Clone repo,\
using the function do_pack."""

from fabric.api import local
from datetime import datetime


def do_pack():
    """Function to generate .tgz archive"""
    local("mkdir -p versions")
    date = datetime.now().strftime("%Y%m%d%H%M%S")
    path = "versions/web_static_{}.tgz".format(date)
    try:
        local("tar -cvzf {} web_static".format(path))
        return path
    except e as Exception:
        return None
