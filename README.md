# Images Downloader
This script reads a text file that contains a list of image urls (one url per line) and downloads the images. If a url is invalid, the request fails or the url points to a resource that is not an image, an error is raised. By default errors are printed but execusion continues.

To run the task directly in your machine, run:
```
bundle install
rake download\["./specs/fixtures/urls.txt","./specs/output"\]
```

Additionally, you can pass your own folder and target directory.
To run the task from Docker read the instructions below.

### Setup dev env
To setup your dev env run:
```
make build
```

### Install dependencies
To install dependencies run:
```
make bundle
```

### Access docker container
To access the docker container run:
```
make dev
```

### Run the script to download images
Access the docker container and execute the rake task:
```
make dev
rake download["/app/specs/fixtures/urls.txt","/app/specs/output"]
```

The rake task takes two arguments, the absolute path to the file that contains the list of urls and the absolute path of the destination folder.

For conviniences there is a sample file that you can use for testing, but feel free to provide your own source file and target folder. Just make sure the file is accessible to the docker container if you are running this from docker.

### Run tests
To access the docker container run:
```
make test
```

### Possible improvements
Make http requests in parallel to improve speed. This could be done with threads or even background jobs like sidekiq.
