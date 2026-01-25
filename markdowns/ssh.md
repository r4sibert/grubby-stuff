# Some SSH stuff
## Revisions

* 2026.01.23:: verified

## Server-side

1. Download and install ssh if it don't exist
    
    ```
    $ which ssh
    $ sudo apt update && sudo apt upgrade
    $ sudo apt install openssh-server
    $ systemctl enable ssh
    ```

2. Check for running instances of ssh and sshd 
    
    ```
    $ which ssh
    $ sudo systemctl status ssh
    $ sudo systemctl status sshd
    ```
    You should see "enabled" under "Loaded" and
    "active (running)" under "Active". If not, run: 
    ```
    $ systemctl enable ssh
    ``` 
3. Note server IP
    ```
    $ ip -br a
    ```

4. Allow ssh traffic on port 22 
    ```
    $ sudo ufw allow OpenSSH
    $ # You can also specify port directly:
    $ # sudo ufw allow 22/tcp
    $ sudo ufw enable
    $ sudo ufw status
    ```

## Client-side

1. Check for ssh
    Check that ssh is installed and running
    ```
    $ which ssh
    $ sudo systemctl status ssh
    ```
    Install ssh if not present
    ```
    $ sudo apt -y update && sudo apt -y upgrade
    $ sudo apt install openssh-client
    $ sudo apt install openssh-server
    $ sudo systemctl enable ssh
    $ sudo systemctl status ssh
    ```

2. Generate ssh keys
    Check to see if the .ssh folder exists in the home directory. 
    Create one if it doesn't exist.
    ```
    $ cd ~/.ssh
    ```
    Create a unique keyset:
    ```
    $ ssh-keygen -t ed25519 -a 32 -f ~/.ssh/<distro>_ed25519
    ```
    When prompted, initialize the passkey with a passphrase.
    
3. Copy passkey to remote server
    Use the following command to copy the public key to the remote
    server. This will likely prompt you for the server password.
    ```
    $ ssh-copy-id user@server_ip
    ```

4. Generate a config file
    If it doesn't exist, create a ssh config file in the .ssh folder on the client. 
    This file allows for easy connection. First, copy the *public key*:
    ```
    $ cd ~/.ssh
    $ nvim config
    ```
    The config file can hold multiple hosts. Each host should have a block that looks like this:
    ```
    Host <alias name>
        Hostname <server ip>
        Port 22
        User <server username>
    ```
    You can change the default port (22) here. Save and exit the file

5. Test the connection
    Provided you have a working config file, access the remote server with:
    ```
    $ ssh <Host>
    ```
    If the key works, it should only ask you for the key passphrase. If this 
    doesn't work, connect to the server with:
    ```
    $ ssh host@ip
    ```
    Enter the password for the host when prompted. Check the .ssh directory for an "authorized_keys"
    file. Check to see that it contains the public key. If not, copy-paste from the client.

## Server-security
As it stands, port 22 is the default ssh port. It is open to the internet but only requires a password. Our client is currently configured
to use SSH keys to log in, but the server will still default back to password if it doesn't detect a key. Better
is to disable the password function altogether. 

1. Disable password authentication
    Navigate to the sshd_config file and change PasswordAuthentication 
    ```
    $ cd /etc/ssh
    $ nvim sshd_config
    ```
    Uncomment PasswordAuthentication and set it to 'no'

2. Change defaule port (optional)
    Uncomment Port 22 and change to something else, *e.g.,* 2222.
    Save and exit the file. 

3. Test and restart sshd service
    ```
    $ sudo sshd -t
    $ sudo systemctl restart sshd.service
    $ sudo systemctl status sshd
    $ # You should see 'active (running)'
    ```
    Open a new terminal tab (keep the current shell running) and try connecting to the server again. Do not shut
    down the other terminal until you can access the server from a fresh terminal. Troubleshoot if you cannot connect.



    

