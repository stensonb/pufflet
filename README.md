# pufflet

A sample project playing with the idea of running [virtual-kubelet](https://virtual-kubelet.io) to drive processes on [OpenBSD](https://openbsd.org).

`pufflet` is a [Kubernetes](https://kubernetes.io) node client, run on an OpenBSD machine.  On startup, `pufflet` registers itself with a k8s API, and advertises itself as an available node to perform work (using a `pufflet` [runtimeClass](https://kubernetes.io/docs/concepts/containers/runtime-class/)).  On assignment of work, `pufflet` configures the local OpenBSD machine to execute the pod and "container" within.

Containers on OpenBSD?  "containers" maybe...see below.

## Why

But Kubernetes is... yeah.  I know.

But OpenBSD is... yeah.  I know.

I use kubernetes for $DAYJOB -- a lot.  It's got some great things going for it.  I wondered if I could leverage the scheduling features to run OpenBSD ~~binaries~~ "containers" across multiple nodes -- all via the k8s API.

## Features

- node registration with k8s API

## Desired Features

- executing OpenBSD "container" images

## OpenBSD "containers"

As of OpenBSD 7.6, there is no concept of a "container" exactly.  But, if we break down the features of an [OCI container](https://opencontainers.org), we can accomplish something earily similar in OpenBSD:

| Containerd feature | OpenBSD technology |
|:-------------------|-------------------:|
| shared kernel | process isolation |
| file system isolation | [chroot(2)](http://man.openbsd.org/chroot) and [unveil(2)](http://man.openbsd.org/unveil) |
| network isolation | [pair(4)](http://man.openbsd.org/pair), [rdomain(4)](http://man.openbsd.org/rdomain), [rtable(4)](http://man.openbsd.org/rtable), [pf(4)](http://man.openbsd.org/pf) |

## Architecture

k8s <-> `pufflet`

`pufflet` <- socket/GRPC -> `pufflet-config`

### pufflet

The main node client, built to register to the k8s server, and handle API requests against the Node API.  Communication to `pufflet-config` is through a local socket, via GRPC. 

### pufflet-config

Leveraging some OpenBSD features requires elevated privileges -- in some cases `root` (some of these may be avoided with properly scoped [doas(1)](https://man.openbsd.org/doas) rules).  To avoid privilege escalation on the local OpenBSD system, strict separation of concerns is followed.  All calls from the pufflet (running as non-priviledged user) for configuration changes to the local OpenBSD system are relayed through a local GRPC socket to the `pufflet-config` process (running as elevated user).  `pufflet-config` does the heavy lifting of configuring the OpenBSD machine.

## Supported OpenBSD versions

Tested against OpenBSD 7.6