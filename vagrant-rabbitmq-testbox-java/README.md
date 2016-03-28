vagrant-rabbitmq-testbox
------------------------
Simple vagrant test box with rabbitmq, java, nodejs and postgresql.

Dependencies
------------

* Ruby 1.9.2
* Vagrant 1.6+
* librarian-chef


Install vagrant plugins (if not instaled)
-----------------------

```
$ vagrant plugin install vagrant-cachier
$ vagrant plugin install vagrant-omnibus

```

Install librarian
----------------------

```
$ gem install librarian-chef
```

Install chef cookbooks
----------------------

```
$ cd chef
$ librarian-chef install
```
