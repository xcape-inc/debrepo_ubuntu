# debrepo_ubuntu
Repository for apt packages for Ubuntu and generating apt repos pages

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