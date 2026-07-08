#!/usr/bin/env bash

wget https://github.com/gleam-lang/gleam/releases/download/v1.14.0/gleam-v1.14.0-x86_64-unknown-linux-musl.tar.gz
wget https://github.com/gleam-lang/gleam/releases/download/v1.14.0/gleam-v1.14.0-x86_64-unknown-linux-musl.tar.gz.sha256

ls -ll

sha256sum -c gleam-v1.14.0-x86_64-unknown-linux-musl.tar.gz.sha256

tar -xf gleam-v1.14.0-x86_64-unknown-linux-musl.tar.gz

chmod +x gleam
mv gleam ~/.local/bin/

echo "gleam download complete"

pnpm i

# checks
gleam build
pnpm tsc --noEmit

# build
gleam run
pnpm parcel build --dist-dir out
