sinatra app for managing podcasts

iTunes won't let you manage files that get added to podcasts very well, this generates feeds from files in local directories so you can manage the feed.

Feeds are generated from any directory in the public/podcasts directory that has a podcast.yml file.

For example, create following directory structure and file:
public/podcasts/sample/podcast.yml

    title: Fight Club Podcast
    author: Tyler Durden
    description: the first rule...

start the server with:

    ruby podcaster

point browser to http://localhost:4567
