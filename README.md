[![Code Climate](https://codeclimate.com/repos/530b69bbe30ba013b2006de0/badges/90803071a8196bb9ee33/gpa.png)](https://codeclimate.com/repos/530b69bbe30ba013b2006de0/feed)

# Canvas::Client

The purpose of this gem is to provide a basic interface between Canvas LMS and an external Ruby application. At its core is a Canvas::Client class that talks to the Canvas API. An ORM-like model layer is built on top of it using Virtus. 

## Installation

Add this line to your application's Gemfile:

    gem 'canvas_client', github: 'dfurber/canvas_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install canvas_client # not until I add to RubyGems...

## Usage

### Configuration
The Canvas client needs some information in order to connect to the Canvas API. The simplest is to put this information in environment variables:

	ENV['CANVAS_TOKEN'] = 'the-token-you-created-from-your-profile-integrations-page'.
	ENV['CANVAS_URL']   = 'https://localhost:3000' # OR your URL without trailing slash. SSL required only for hosted.
	ENV['CANVAS_ACCOUNT'] = '1' # If your Canvas interactions involve one account then set it here

Canvas LMS uses OAuth2 access tokens. The simplest use case is to go to the profile page of a Canvas admin user and create a non-expiring token. Put that in the CANVAS_TOKEN environment variable.

You can also set these variables on the fly like so:

	Canvas.client.token = 'my-other-personal-user-token'
	Canvas.client.url = 'https://canvas.instructure.com'
	Canvas.client.account = '200'
	
### Using the Client
The Canvas client wraps the Canvas JSON API using the RestClient gem, adding the base URL and headers for you. While we recommend that you isolate code that depends on Canvas.client, you can perform HTTP operations like so:

	# A simple get:
	Canvas.client.get 'accounts/1/users', search_term: 'David'
	=> [{'id'=>2, 'name'=>'David Furber' ... }]
	
	# A post:
	Canvas.client.post 'accounts/1/users', user: { name: 'David Furber' }, pseudonym: { sis_user_id: 'SIS1' } # ...
	=> {'id' => 313, 'name' => 'David Furber', 'login_id' => 'furberd@gmail.com'}
	
	# A put:
	Canvas.client.put 'users/313', user: { name: 'Billy Bob Furber' }
	=> {'id'=>313, 'name' => 'Billy Bob Furber'}
	
	# A delete:
	Canvas.client.delete 'accounts/1/users/313'
	=> {'id'=>313, 'name' => 'Billy Bob Furber'}

### Using the ORM
It is better to use the (ever evolving) ORM layer to interact with the API.

	# Load a user:
	user = Canvas::User.find 313 # The user's Canvas ID. You can also send the name, email, or SIS ID.
	
	# Create a user:
	user = Canvas::User.new name: 'David Furber', sis_user_id: 'SIS3131212', email: 'furberd@gmail.com'
	user.save
	
	# Update a user:
	user.name = 'New Name'
	user.save
	
	# Delete a user:
	user.destroy

### Build your own models
Coming soon!

## Contributing

1. Fork it ( http://github.com/<my-github-username>/canvas-client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
