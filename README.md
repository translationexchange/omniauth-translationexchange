# OmniAuth for Translation Exchange

Translation Exchange OAuth2 Strategy for OmniAuth 1.4.

Supports the OAuth 2.0 server-side. Read the Translation Exchange docs for more details: https://docs.translationexchange.com/

## Installing

Add to your `Gemfile`:

```ruby
gem 'omniauth-translationexchange'
```

Then `bundle install`.

## Usage

`OmniAuth::Strategies::TranslationExchange` is simply a Rack middleware. Read the OmniAuth 1.0 docs for detailed instructions: https://github.com/intridea/omniauth.

Here's a quick example, adding the middleware to a Rails app in `config/initializers/omniauth.rb`:

```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :translationexchange, ENV['TRANSLATION_EXCHANGE_KEY'], ENV['TRANSLATION_EXCHANGE_SECRET']
end
```

## Configuring

You can configure several options, which you pass in to the `provider` method via a `Hash`:

* `scope`: A comma-separated list of permissions you want to request from the user. See the Translation Exchange docs for a full list of available permissions. Default: `email`.
* `display`: The display context to show the authentication page. Options are: `web`, `desktop` and `mobile`. Default: `web`.

For example, to request `email` permission and display the authorization page in a mobile app:
 
```ruby
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :translationexchange, ENV['TRANSLATION_EXCHANGE_KEY'], ENV['TRANSLATION_EXCHANGE_SECRET'], { 
      :scope => 'email', 
      :display => 'mobile'
  }
end
```

If you want to set the `display` format on a per-request basis, you can just pass it to the OmniAuth request phase URL, for example: `/auth/translationexchange?display=popup`.

## Authentication Hash

Here's an example *Authentication Hash* available in `request.env['omniauth.auth']`:

```ruby
{"provider"=>"translationexchange",
 "uid"=>"4e4885fd-c0ee-47f2-871d-22473a3de08d",
 "info"=>
  {"id"=>"4e4885fd-c0ee-47f2-871d-22473a3de08d",
   "display_name"=>"Alex Peterson",
   "first_name"=>"Alex",
   "last_name"=>"Peterson",
   "email"=>"alex@domain.com",
   "gender"=>"male",
   "mugshot"=>
    "https://gravatar.com/avatar/sdfasdfasdfasdfasdfasdfr34fsdf.png?s=65"},
 "credentials"=>
  {"token"=>"0ce884c17c79b74667e773c4c226e9fdc8f94f4c6fe4e7fd7b4558dbbbe62505",
   "expires_at"=>1495153596,
   "expires"=>true},
 "extra"=>
  {"user"=>
    {"uuid"=>"4e4885fd-c0ee-47f2-871d-22473a3de08d",
     "email"=>"alex@domain.com",
     "role"=>"developer",
     "display_name"=>"Alex Peterson",
     "first_name"=>"Alex",
     "last_name"=>"Peterson",
     "name"=>"Alex Peterson",
     "username"=>"alex",
     "mugshot"=>
      "https://gravatar.com/avatar/87345b2271259e2eeea3b01142f9af56.png?s=65",
     "time_zone"=>"Pacific Time (US & Canada)",
     "gender"=>"male",
     "created_at"=>"2013-11-21 14:28:45",
     "updated_at"=>"2017-05-18 15:23:03",
     "password_set_at"=>"2016-11-28 19:22:39",
     "last_logged_in_at"=>"2017-05-18 15:23:03"}}}
```

The precise information available may depend on the permissions which you request.
