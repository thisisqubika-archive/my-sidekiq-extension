# App using sidekiq extension example

Install dependencies with:
``` bash
bundle
```

Run it with:
``` bash
bundle exec sidekiq -r './main.rb'
```

Run web ui with:
``` bash
bundle exec rackup
```

Then go to [http://localhost:9292/my-extension](http://localhost:9292/my-extension)
