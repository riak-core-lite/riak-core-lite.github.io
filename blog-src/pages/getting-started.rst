.. title: Getting Started
.. slug: getting-started
.. date: 2020-02-15 12:42:04 UTC+01:00
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text

Here's a video version of this guide:

.. raw:: html

   <iframe width="560" height="315" src="https://www.youtube.com/embed/qQcmhg3P5mo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Prerequisites
=============

You need to have Erlang installed, go to `Adopting Erlang's Setup Section <https://www.adoptingerlang.org/docs/development/setup/>`_ if you don't.

You need to have a recent `rebar3 <https://www.rebar3.org/>`_ installed, check the `rebar3 getting started guide <https://www.rebar3.org/docs/getting-started>`_ if you don't.

Setup
=====

We are going to create a new project using a rebar3 template, but first we need to install it.

Open https://github.com/riak-core-lite/rebar3_template_riak_core_lite/ in your browser and follow the instructions there, I will copy
them here, but check that they match.

First open a terminal and clone the template in the right local folder:

.. code-block:: sh

   mkdir -p ~/.config/rebar3/templates
   git clone https://github.com/riak-core-lite/rebar3_template_riak_core_lite.git ~/.config/rebar3/templates/rebar3_template_riak_core_lite

Then on the terminal, go to the root directory where you want to
create your new project and run:

.. code-block:: sh

   rebar3 new rebar3_riak_core_lite name=ricor

This will create a new project called `ricor` in the `ricor` folder,
feel free to change the project name by changing it in the command
above, just remember to replace every instance of `ricor` for your
project's name in this guide.

Now `cd` to your newly created project:

.. code-block:: sh

   cd ricor

And build it:

.. code-block:: sh

   rebar3 release

When it finished building, try running it:

.. code-block:: sh

   ./_build/default/rel/ricor/bin/ricor console

You should get a prompt similar to this one::

   (ricor@127.0.0.1)1>

Write the following command on it:

.. code-block:: erl

   ricor:ping().

You should get a response similar to this one:

.. code-block:: erl

   {pong,'ricor1@127.0.0.1', 9...8}

The first item is the reply `pong`, the second is the node that
replied and the third is a really long number that identifies the
`vnode` that handled the request.

Now quit the Erlang shell by writing `q().` and hitting enter.

3 Node Cluster Setup
====================

Let's build a 3 node cluster on our machine.

First we need to create 3 slighly different releases, the only
differences are the ports they listen to and the node names, since
we are running them on the same machine we don't want them to
clash.

For that we can run:

.. code-block:: sh

   make devrel

After it finishes, open 3 terminals, run each command on one terminal:

.. code-block:: sh

   make dev1-console
   make dev2-console
   make dev3-console

You can check that they are not clustered by running:

.. code-block:: sh

   make devrel-status

It should show only node 1 with 100% of the ring.

Now let's join them:

.. code-block:: sh

   make devrel-join

Periodically check the ring status:

.. code-block:: sh

   make devrel-status

Eventually it will start migrating parts of the ring to node2 and node3, when it starts you can try running ping on any node:

.. code-block:: erl

   ricor:ping().

And check which node replies.

That's all, now you can start adding your own request handling
logic in the `ricor_vnode.erl` file to handle your use cases.

Have fun!
