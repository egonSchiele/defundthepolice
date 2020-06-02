all:
	bundle exec ruby generate.rb

server:
	 cd public && python -m SimpleHTTPServer 7800
