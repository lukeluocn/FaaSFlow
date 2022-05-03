import threading
import time

import docker

cnt = 0
lock = threading.Lock()


class MyContainers(object):

    def __init__(self, fp, containers):
        self.__fp = fp
        self.__containers = containers

    def __getattr__(self, attr):
        self.__fp.write(f"[get] {attr}\n")
        self.__fp.flush()
        return getattr(self.__containers, attr)

    def run(self, *args, **kwargs):
        self.__fp.write(f"[run] {args} {kwargs}\n")
        self.__fp.flush()
        return self.__containers.run(*args, **kwargs)


class MyClient(object):

    def __init__(self):
        global cnt
        lock.acquire()
        self.__id = cnt
        cnt += 1
        lock.release()

        self.__fp = open(f"./my-client-{self.__id}.log", "a")
        self.__fp.write(80 * "-" + "\n")
        self.__fp.write(time.asctime() + "\n")
        self.__fp.flush()

        self.__client = docker.from_env()
        self.containers = MyContainers(self.__fp, self.__client.containers)

    def __getattr__(self, attr):
        self.__fp.write(f"[get] {attr}\n")
        self.__fp.flush()
        return getattr(self.__client, attr)


def from_env():
    return MyClient()
