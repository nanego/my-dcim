## Setup

#### 1) env

Copy the `.env.exemple` into `.env`

#### 2) Launch Docker containers

```bash
docker compose up -d
```

#### 3) Log in

Visit `localhost:8085` and log in with username: `glpi`, password: `glpi`<br>
Note: The application initializes the database on startup. If you see a `Connection Reset` error, please wait about 20 seconds and try again.

#### 4) Enable the API

In the [settings](http://localhost:8085/front/config.form.php), navigate to the `API` tab, check `Enable legacy REST API`, and click Save. <br>
You must then add a client using your IP address (host machine) and copy the `app token`.

#### 5) Create a user_token

On the [users page](http://localhost:8085/front/user.php), click on the `glpi` user. At the bottom of the page, locate the `API token` field. <br>
Check "Regenerate" and then click Save. You now have your `user_token`.
