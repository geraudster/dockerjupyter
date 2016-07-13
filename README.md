Container for Jupyter with Python3 kernel.

## Get image

    $ docker pull geraudster/dockerjupyter

## Configuration

Create a directory ~/.jupyter/secret, then create keypair:

    $ cd ~/.jupyter/secret
    $ openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mykey.key -out mycert.pem

Generate a hashed password:

    $ docker run -it geraudster/rjupyter python3 -c 'from notebook.auth import passwd; print(passwd())'
    Enter password: 
    Verify password: 
    sha1:f09ac5efb12e:b628023298e751bb20b83466d63a9ed3ce04e9e9

Type your password, then copy-paste the hashed password in your ~/.jupyter/secret/secret.ini:

    [Password]
    password = sha1:f09ac5efb12e:b628023298e751bb20b83466d63a9ed3ce04e9e9

Create a working dir where all notebooks will be stored:

    $ mkdir ~/jupyter

## Run it

    $ docker run -d -v $HOME/.jupyter/secret:/home/jupyter/secret \
                    -v $HOME/jupyter:/data/jupyter \
                    -p 8888:8888 geraudster/dockerjupyter

