.PHONY: run

run:
	bundle install --without production
	rackup
