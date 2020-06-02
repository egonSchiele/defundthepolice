all:
	bundle exec ruby generate.rb

server:
	 python -m SimpleHTTPServer 7800
