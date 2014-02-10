# Dockerc

**Note: this is alpha software. The interfaces are not stable.**

A lightweight docker client that focuses on:

* returning simple data structures instead of any defined object model
* normalization of parameters (`:snake_cased` symbols for everyone!)
* exceptions thrown in exceptional cases
* explicit code paths to reduce confusion

This is an early release, currently being used to prove out some process management experiments.

## Installation

Add this line to your application's Gemfile:

    gem 'dockerc'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dockerc

## Usage

```ruby
# connect to unix:///var/run/docker.sock
c = Dockerc::Client.new
# connect to an alternate docker endpoint
c = Dockerc::Client.new(docker_url: 'http://localhost:4243')

# pull an image from the public repository
c.pull_image 'gorsuch/litterbox'

# launch a container
c.create_container :image => 'gorsuch/litterbox', :cmd => 'date'

# list all containers
c.containers
#=> [{:command=>"date ", :created=>1392044336, :id=>"ea1c87570244276041caafb69ab2fd102c974b0b214e885304de00222b9f6bd0", :image=>"gorsuch/litterbox:latest", :names=>["/desperate_hawking"], :ports=>[], :status=>"Exit 0"}]

```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/dockerc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
