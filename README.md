# pufflet

A sample project playing with the idea of running [virtual-kubelet](https://virtual-kubelet.io) to drive processes on OpenBSD.

pufflet is a node client, run on an OpenBSD machine.  On startup, pufflet registers itself with a k8s API, and advertises itself as an available node to perform work.  On assignment of work, pufflet configures the local OpenBSD machine to execute the pod.

## Why

But Kubernetes is... yeah.  I know.

But OpenBSD is... yeah.  I know.

I use kubernetes for $DAYJOB -- a lot.  It's got some great things going for it.  I wondered if I could leverage the scheduling features to run OpenBSD binaries across multiple nodes -- all via the k8s api.

## Features

- node registration with k8s API
- executing OpenBSD "container" images

## OpenBSD "containers"

As of OpenBSD 7.4, there is no concept of a "container" exactly.  But, if we break down the features of an [OCI container](link needed), we can accomplish something earily similar in OpenBSD:

|| Containerd feature || OpenBSD technology ||
|--|--|
| shared kernel | process isolation |
| file system isolation | chroot(?) and unveil(?) |
| network isolation | pair(4), rdomain(8), rtable(8), pf(4) |
|--|--|

## Architecture

k8s <-> pufflet

pufflet <- socket/GRPC -> pufflet-config

### pufflet

The main node client, built to register to the k8s server, and handle API requests against the Node API.  Communication to pufflet-config is through a local socket, via GRPC. 

### pufflet-config

Leveraging some OpenBSD features requires elevated privileges -- in some case root.  To avoid privilege escalation on the local OpenBSD system, strict separation of concerns is followed.  All calls from the pufflet for configuration changes to the local OpenBSD system are relayed through a GRPC socket to a pufflet-config process.
