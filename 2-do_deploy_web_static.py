#!/usr/bin/python3
# -*- coding: utf-8 -*-

"""Fabric script that distributes an archive to your web servers"""

from fabric.api import *
from os import path

env.hosts = ['100.25.0.75', '34.204.95.3']
env.user = 'ubuntu'
env.key_filename = '~/.ssh/school'

def do_deploy(archive_path):
    """Distributes an archive to your web servers"""
    if not path.exists(archive_path):
        return False
    try:
        put(archive_path, '/tmp/')
        archive = archive_path.split('/')[-1]
        archive_folder = archive.split('.')[0]
        run('mkdir -p /data/web_static/releases/{}'.format(archive_folder))
        run('tar -xzf /tmp/{} -C /data/web_static/releases/{}'.format(archive, archive_folder))
        run('rm /tmp/{}'.format(archive))
        run('mv /data/web_static/releases/{}/web_static/* /data/web_static/releases/{}'.format(archive_folder, archive_folder))
        run('rm -rf /data/web_static/releases/{}/web_static'.format(archive_folder))
        run('rm -rf /data/web_static/current')
        run('ln -s /data/web_static/releases/{} /data/web_static/current'.format(archive_folder))
        return True
    except:
        return False
