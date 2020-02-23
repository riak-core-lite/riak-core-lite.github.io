.. title: Getting Started with Elixir
.. slug: getting-started-with-elixir
.. date: 2020-02-23 16:25:32 UTC+01:00
.. tags: 
.. category: 
.. link: 
.. description: 
.. type: text

Prerequisites
=============

You need to have Erlang installed, go to `Adopting Erlang's Setup Section <https://www.adoptingerlang.org/docs/development/setup/>`_ if you don't.

You also need to have Elixir installed, go to `Elixir's install page <https://elixir-lang.org/install.html>`_ for instructions if you don't have it already.

Setup
=====

We are going to create a new project using the Riak Core Lite Mix Task, but
first we need to install it, run the following in a terminal:

.. code-block:: sh

   mix archive.install hex rcl

Then on the terminal, go to the root directory where you want to
create your new project and run:

.. code-block:: sh

   mix rcl new ricorex

Change `ricorex` above (and in the rest of the guide) for the name of your project.

Now let's build it:

.. code-block:: sh

   cd ricorex
   mix deps.get
   mix compile

Let's start by running a single node:

.. code-block:: sh

   iex --name dev@127.0.0.1 -S mix run

After it starts you should see a prompt like this:

.. code-block:: sh

   iex(dev@127.0.0.1)1>

(You may see many logs too, hit enter to get the prompt again)

On the prompt run:

.. code-block:: iex

   iex(dev@127.0.0.1)2> Ricorex.Service.ping()

Remember to change `Ricorex` for your project's name if you changed it.

The output should look something like:

.. code-block:: ex

   {:pong, 2, :"dev@127.0.0.1", 936274486415109681974235595958868809467081785344}

(The last number may be different for you)

3 Node Cluster Setup
====================

Let's build a 3 node cluster on our machine.

First we need to create 3 slighly different releases, the only
differences are the ports they listen to and the node names, since
we are running them on the same machine we don't want them to
clash.

For that we can run:

.. code-block:: sh

   MIX_ENV=node1 mix release node1

.. code-block:: sh

   MIX_ENV=node2 mix release node2

.. code-block:: sh

   MIX_ENV=node3 mix release node3

Now open 3 terminals, on each run one of the following commands:

.. code-block:: sh

   ./_build/node1/rel/node1/bin/node1 start_iex

.. code-block:: sh

   ./_build/node2/rel/node2/bin/node2 start_iex

.. code-block:: sh

   ./_build/node3/rel/node3/bin/node3 start_iex

On `node2` and `node3` run:

.. code-block:: iex

   :riak_core.join('node1@127.0.0.1')

On `node1` run:

To see the planned changes in the ring:

.. code-block:: iex

   :riak_core_claimant.plan()

Now we can commit the plan:

.. code-block:: iex

   :riak_core_claimant.commit()

Periodically run:

.. code-block:: iex

   :riak_core_console.member_status([])

You will see something like this:

:::

   ================================= Membership ==================================
   Status     Ring    Pending    Node
   -------------------------------------------------------------------------------
   valid      46.9%     34.4%    'node1@127.0.0.1'
   valid      26.6%     32.8%    'node2@127.0.0.1'
   valid      26.6%     32.8%    'node3@127.0.0.1'
   -------------------------------------------------------------------------------
   Valid:3 / Leaving:0 / Exiting:0 / Joining:0 / Down:0
   :ok

Once it finishes rebalancing it will look like this::

   ================================= Membership ==================================
   Status     Ring    Pending    Node
   -------------------------------------------------------------------------------
   valid      34.4%      --      'node1@127.0.0.1'
   valid      32.8%      --      'node2@127.0.0.1'
   valid      32.8%      --      'node3@127.0.0.1'
   -------------------------------------------------------------------------------
   Valid:3 / Leaving:0 / Exiting:0 / Joining:0 / Down:0

Try:

.. code-block:: iex

   iex(node3@127.0.0.1)39> Ricorex.Service.ping(1)
   {:pong, 2, :"node3@127.0.0.1", 936274486415109681974235595958868809467081785344}

.. code-block:: iex

   iex(node3@127.0.0.1)40> Ricorex.Service.ping(3)
   {:pong, 4, :"node1@127.0.0.1", 616571003248974668617179538802181898917346541568}

.. code-block:: iex

   iex(node3@127.0.0.1)41> Ricorex.Service.ping(5)
   {:pong, 6, :"node2@127.0.0.1",
    1118962191081472546749696200048404186924073353216}

As you can see, each request landed on a different node.

Where to go from here
=====================

You can try building a key value store following this tutorial: `We can make a Key Value Store out of that <http://marianoguerra.org/posts/riak-core-on-partisan-on-elixir-tutorial-we-can-make-a-key-value-store-out-of-that.html>`_
