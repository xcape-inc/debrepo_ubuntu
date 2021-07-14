# debrepo_ubuntu
Repository for apt packages for Ubuntu and generating apt repos pages

To add packages to the repo, make surew git lfs is installed locally (https://docs.github.com/en/github/managing-large-files/versioning-large-files/installing-git-large-file-storage).  After cloning the repo (shallow is recomeneded, but not required with lfs), add and commit the deb and push. Thats it; packages will automatically added to the repo.

To use repo, do the following:
```
wget -qO - https://xcape-inc.github.io/debrepo_ubuntu/archive.key | sudo apt-key add -

# To list and remove a key from apt sources use the following commands respectively.
apt-key list

# Register the external package repository.
echo 'deb https://xcape-inc.github.io/debrepo_ubuntu focal universe' | sudo tee /etc/apt/sources.list.d/xcape-inc.list

# Refresh the apt configuration.
sudo apt-get update
```

Dev notes:
How the pgp key was generated:
```bash
sudo mkdir -p /run/user/$(id -u) && chown $(id -u):$(id -g) /run/user/$(id -u)
export GNUPGHOME="$(mktemp -d)"
cat <<EOF | gpg --batch --full-gen-key -
     %echo Generating a basic OpenPGP key
     Key-Type: RSA
     Key-Length: 4096
     Subkey-Type: RSA
     Subkey-Length: 4096
     Name-Real: Xcape, Inc. Ubuntu Archive Automatic Signing Key
     Name-Comment: 20.04/focal
     Name-Email: support@xcapeinc.com
     Expire-Date: 2025-05-20
     Passphrase: abc
     %commit
     %echo done
EOF
gpg --list-secret-keys
gpg --armor --output archive.key --export-options export-minimal --export 'Xcape, Inc. Ubuntu Archive Automatic Signing Key'
gpg --armor --export-secret-keys 'Xcape, Inc. Ubuntu Archive Automatic Signing Key' > archive.priv

# restore in ci
gpg --import archive.key
printf '%s' "${APT_REPO_PGP_PRIV}" | gpg --allow-secret-key-import --import -
```

For how to generate the contents of the repo, see the github action files