# Shortify

Yet another URL shortener written with elixir.


<details><summary>Running Docker Container</summary>
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