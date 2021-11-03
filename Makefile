test:
	bundle exec rake test

pkg:
	bundle exec rake gem

gem: pkg

gem.push: gem
	ls pkg/*.gem | xargs gem push
