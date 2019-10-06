# Shortify

Yet another URL shortener written in Elixir.

<details><summary>Running shortify locally</summary>
<p>

- Set `DATABASE_URL` environment variable with pool size
> `postgres://username:password@db_host:5432/shortify_db?pool_size=10`
- Run `iex -S mix` on command-line
- Visit [http://localhost:4000](http://localhost:4000)

</p>
</details>

<details><summary>Building and deploying release with Docker</summary>
<p>

##### Building image

```sh
docker build -t shortify .
```

##### Running container

```sh
docker run --rm \
    -p 4000:4000 \
    -p 4001:4001 \
    -e DATABASE_URL="postgres://postgres:pass@pgdb:5432/shortify_db?pool_size=10" \
    -e WEB_BASE_URL="http://curl.ist" \
    -it shortify
```

- `4000` port listening for web and `4001` for API by default.

</p>
</details>

----
License : MIT
