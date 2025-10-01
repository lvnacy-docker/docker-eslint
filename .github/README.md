<div align='center'>
    <a href='https://github.com/xlvnacyx'>
    <img
        src='./assets/lvnacy_emblem_plain.png'
        alt='Lunacy emblem, depicting a bold black letter V over a gray circle'
        width='128px'
    />
    </a>
    <br />
    <h1>Docker ESLint</h1>
    Code Quality Containers for Local Development<br>
    <i>Don't install. Containerize</i>
    <br>
    <br>
    Docker's proliferation means that if it can be containerized, it likely 
    is. So forget about installing everything locally and gumming up your 
    system with 18 billion tools; just run it in a container. All you need is 
    Docker installed locally.
    <br>
    •
    <a href='https:////github.com/xlvnacyx'>
        GitHub
    </a>
    •
    <a href='https://bsky.app/profile/code.lvnacy.xyz'>
        Bluesky
    </a>
    •
</div>

## Introduction
They say in order to commit the perfect crime, you best do it alone. The more 
people involved, the greater the risk of someone saying something that will 
lead back to you. Working alone then is, essentially, minimizing your attack 
surface. Now, how the fuck is this relevant here?

Most dev tooling is invasive as fuck. Most apps are, generally, but it seems 
developer apps are more so. When I learned this, I gutted my system of 
developer tooling and started working in virtual machines. However, this isn't 
the most convenient way to write code, nor the prettiest. Sometimes I just 
want to work on my main machine. This repo is born out of that desire, and is 
the first of a series.

## Tooling
Currently, these tools are available:

- `lvnacy/eslint` [Docker Hub](https://hub.docker.com/repository/docker/lvnacy/eslint/general)

This image is hardened, removing anything and everything that is not 
absolutely necessary to lint your code. No system package managers, no `git`, 
no `curl` ... you get the idea. Just ESLint running on Node. That's it. This 
means it's secure as fvck.

Anyway, here's how to make use of this image:

## ESLint
Pull this image:
```
docker pull lvnacy/eslint
```

or clone this repo, navigate to its directory, then build the image:

```bash
cd eslint
docker build -t your-fucking-handle/eslint .
```
OR, alternatively, copy the Dockerfile to the root of your project directory, 
then build the fucking thing.

Once it's built and ready to go, run that bitch:
```bash
# Using PWD environment variable
docker run --rm -v "${PWD}:/workspace" lvnacy/eslint .

# Using absolute path (most reliable)
docker run --rm -v "/path/to/your/project:/workspace" lvnacy/eslint .
```

You can also create your own Compose file to run the container. This project 
will be one day be updated with individual Compose files for each service, 
along one Compose file to integrate all services.

Additional options when running the eslint container:
```bash
# Show ESLint help
docker run --rm -v "$(pwd):/workspace" lvnacy/eslint

# Lint current directory
docker run --rm -v "$(pwd):/workspace" lvnacy/eslint .

# Lint specific directory
docker run --rm -v "$(pwd):/workspace" lvnacy/eslint src/

# Lint specific files
docker run --rm -v "$(pwd):/workspace" lvnacy/eslint file1.js file2.js

# Auto-fix issues
docker run --rm -v "$(pwd):/workspace" lvnacy/eslint --fix .

# Lint with specific config
docker run --rm -v "$(pwd):/workspace" lvnacy/eslint -c .eslintrc.json .

# Output to specific format
docker run --rm -v "$(pwd):/workspace" lvnacy/eslint --format json .
```

## Contributing
Find a bug? Have ideas on how to improve this functionality? Please create an 
issue or, even better, raise a PR! I'm happy to discuss ways to build a better 
image.

## Conclusion
That's it for now. You can find me on Bluesky at the profile linked above. 
Have fun building!